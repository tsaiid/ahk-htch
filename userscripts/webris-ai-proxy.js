#!/usr/bin/env node

const http = require("node:http");

const PORT = Number(process.env.WEBRIS_AI_PROXY_PORT || 8787);
const HOST = process.env.WEBRIS_AI_PROXY_HOST || "127.0.0.1";
const GOOGLE_API_KEY = process.env.GOOGLE_AI_API_KEY || process.env.GEMINI_API_KEY || "";
const GOOGLE_MODEL = process.env.WEBRIS_AI_GOOGLE_MODEL || "gemma-4-31b-it";
const DEFAULT_FALLBACK_MODELS = "gemini-2.5-flash-lite,gemini-2.5-flash";
const RAW_FALLBACK_MODELS = process.env.WEBRIS_AI_FALLBACK_MODELS !== undefined
    ? process.env.WEBRIS_AI_FALLBACK_MODELS
    : DEFAULT_FALLBACK_MODELS;
const GOOGLE_FALLBACK_MODELS = RAW_FALLBACK_MODELS
    .split(",")
    .map(m => m.trim())
    .filter(m => m && m !== GOOGLE_MODEL);
const GOOGLE_API_BASE_URL = (process.env.WEBRIS_AI_GOOGLE_API_BASE_URL || "https://generativelanguage.googleapis.com/v1beta").replace(/\/+$/, "");
const THINKING_LEVEL = process.env.WEBRIS_AI_THINKING_LEVEL !== undefined
    ? process.env.WEBRIS_AI_THINKING_LEVEL.trim()
    : "MINIMAL";
const UPSTREAM_TIMEOUT_MS = Number(process.env.WEBRIS_AI_TIMEOUT_MS || 60000);
const RETRY_COUNT = Math.max(0, Number(process.env.WEBRIS_AI_RETRY_COUNT ?? 2));
const DEBUG_LOG = /^(1|true|yes)$/i.test(process.env.WEBRIS_AI_DEBUG || "");
const MAX_BODY_BYTES = 200 * 1024;

let requestSerial = 0;

if (!Number.isInteger(PORT) || PORT < 1 || PORT > 65535) {
    console.error(`Invalid WEBRIS_AI_PROXY_PORT: ${process.env.WEBRIS_AI_PROXY_PORT}`);
    process.exit(1);
}

if (!Number.isFinite(UPSTREAM_TIMEOUT_MS) || UPSTREAM_TIMEOUT_MS <= 0) {
    console.error(`Invalid WEBRIS_AI_TIMEOUT_MS: ${process.env.WEBRIS_AI_TIMEOUT_MS}`);
    process.exit(1);
}

const REFINE_SYSTEM_PROMPT = String.raw`
# ROLE
You are a professional Radiologist and Medical Editor specializing in clinical documentation for Radiology Reports and Electronic Health Records (EHR).

# GOAL
Refine or translate the input text into professional, fluent, and logically structured medical English.

# SPECIFIC INSTRUCTIONS
1. **Clinical Fluency**: Ensure the output uses standard medical terminology and professional reporting syntax.
2. **Format Preservation**: You MUST strictly preserve all original bullet points, numbering, and line breaks. If the original text uses bullet markers such as "-", keep the same bullet-list structure after refinement, even when there is only one bullet item.
3. **Image Locator Preservation**: Keep image locator labels exactly as written, such as "(Srs/Img: 14/60)"; do not expand abbreviations like "Srs/Img" into "Series/Image".
4. **Special Logic (Pulmonary Nodules)**:
- If the input describes a "pulmonary nodule" and provides two dimensions (e.g., 10 x 8 mm).
- ACTION: Calculate the mean diameter: $\frac{length + width}{2}$.
- FORMAT: Include the result in the sentence, e.g., "(mean diameter: 9 mm)".

# CONSTRAINTS
- Output ONLY the refined medical text.
- Do NOT provide any preamble, explanations, or conversational fillers.
- Maintain the exact hierarchical structure of the original input.
- Use metric units as provided in the source text.
`.trim();

class HttpError extends Error {
    constructor(statusCode, message) {
        super(message);
        this.name = "HttpError";
        this.statusCode = statusCode;
    }
}

function sendJson(res, statusCode, payload, extraHeaders = {}) {
    const body = JSON.stringify(payload);
    res.writeHead(statusCode, {
        "Content-Type": "application/json; charset=utf-8",
        "Content-Length": Buffer.byteLength(body),
        ...extraHeaders
    });
    res.end(body);
}

function sendNoContent(res) {
    res.writeHead(204);
    res.end();
}

function readJsonBody(req) {
    return new Promise((resolve, reject) => {
        const declaredLength = Number(req.headers["content-length"]);
        if (Number.isFinite(declaredLength) && declaredLength > MAX_BODY_BYTES) {
            req.resume();
            reject(new HttpError(413, `Request body is too large (limit: ${MAX_BODY_BYTES} bytes).`));
            return;
        }

        const chunks = [];
        let totalBytes = 0;
        let settled = false;

        const fail = err => {
            if (settled) return;
            settled = true;
            reject(err);
        };

        req.on("data", chunk => {
            if (settled) return;
            totalBytes += chunk.length;
            if (totalBytes > MAX_BODY_BYTES) {
                chunks.length = 0;
                fail(new HttpError(413, `Request body is too large (limit: ${MAX_BODY_BYTES} bytes).`));
                return;
            }
            chunks.push(chunk);
        });

        req.on("end", () => {
            if (settled) return;
            settled = true;
            const raw = Buffer.concat(chunks).toString("utf8");
            try {
                resolve(raw ? JSON.parse(raw) : {});
            } catch (err) {
                reject(new HttpError(400, `Invalid JSON: ${err.message}`));
            }
        });

        req.on("error", err => {
            fail(new HttpError(400, `Request stream error: ${err.message}`));
        });
    });
}

function stripMarkdownCodeFence(text) {
    const trimmed = text.trim();
    const fenced = trimmed.match(/^```(?:\w+)?\r?\n?([\s\S]*?)\r?\n?```$/);
    if (fenced) return fenced[1].trim();
    if (trimmed.startsWith("`") && trimmed.endsWith("`")) {
        return trimmed.slice(1, -1).trim();
    }
    return trimmed;
}

function extractGoogleText(responseJson) {
    const firstCandidate = responseJson?.candidates?.[0];
    const parts = firstCandidate?.content?.parts || [];
    const text = parts
        .filter(part => !part.thought && typeof part.text === "string")
        .map(part => part.text)
        .join("");

    if (!text) {
        const blockReason = responseJson?.promptFeedback?.blockReason;
        const finishReason = firstCandidate?.finishReason;
        const details = [
            blockReason ? `blockReason=${blockReason}` : "",
            finishReason ? `finishReason=${finishReason}` : ""
        ].filter(Boolean).join(", ");
        throw new HttpError(
            502,
            details
                ? `Google API response did not include text (${details}).`
                : "Google API response did not include text."
        );
    }

    return stripMarkdownCodeFence(text);
}

function logRequest(requestId, message, data = {}) {
    console.log(`[${new Date().toISOString()}] [WebRIS AI proxy] [${requestId}] ${message}`, data);
}

function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

function isRetryableStatus(status) {
    return status === 429 || status === 503;
}

function mapUpstreamStatus(status) {
    if (status === 429 || status === 503) return status;
    return 502;
}

function parseRetryAfterMs(headerValue) {
    if (!headerValue) return null;
    const seconds = Number(headerValue);
    if (Number.isFinite(seconds) && seconds > 0) {
        return Math.min(seconds * 1000, 10000);
    }
    return null;
}

function supportsThinkingLevel(model) {
    return /^(gemma-4|gemini-3)/i.test(model);
}

async function callGoogleModelOnce(model, prompt, requestId, attempt) {
    const url = `${GOOGLE_API_BASE_URL}/models/${encodeURIComponent(model)}:generateContent`;
    const startedAt = Date.now();

    const generationConfig = {
        temperature: 0.3,
        topP: 0.95
    };
    if (THINKING_LEVEL && !/^(off|none)$/i.test(THINKING_LEVEL) && supportsThinkingLevel(model)) {
        generationConfig.thinkingConfig = { thinkingLevel: THINKING_LEVEL };
    }

    logRequest(requestId, "calling Google API", {
        model,
        attempt,
        promptLength: prompt.length
    });

    let upstream;
    try {
        upstream = await fetch(url, {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                "x-goog-api-key": GOOGLE_API_KEY
            },
            body: JSON.stringify({
                contents: [{
                    role: "user",
                    parts: [{ text: prompt }]
                }],
                generationConfig
            }),
            signal: AbortSignal.timeout(UPSTREAM_TIMEOUT_MS)
        });
    } catch (err) {
        if (err?.name === "TimeoutError") {
            throw new HttpError(504, `Google API timed out after ${UPSTREAM_TIMEOUT_MS}ms.`);
        }
        throw new HttpError(502, `Google API network error: ${err?.message || String(err)}`);
    }

    const responseText = await upstream.text();
    const responseLog = {
        model,
        attempt,
        status: upstream.status,
        elapsedMs: Date.now() - startedAt,
        responseLength: responseText.length
    };
    if (DEBUG_LOG) {
        responseLog.responsePreview = responseText.slice(0, 300);
    }
    logRequest(requestId, "Google API response", responseLog);

    let responseJson = {};
    try {
        responseJson = responseText ? JSON.parse(responseText) : {};
    } catch {
        responseJson = {};
    }

    if (!upstream.ok) {
        const message = responseJson?.error?.message || responseText || `HTTP ${upstream.status}`;
        const err = new HttpError(mapUpstreamStatus(upstream.status), `Google API failed: ${message}`);
        err.upstreamStatus = upstream.status;
        err.retryAfterMs = parseRetryAfterMs(upstream.headers.get("retry-after"));
        throw err;
    }

    return extractGoogleText(responseJson);
}

async function callGoogleRefine(text, requestId) {
    if (!GOOGLE_API_KEY) {
        throw new HttpError(503, "GOOGLE_AI_API_KEY or GEMINI_API_KEY is not set.");
    }

    const prompt = `${REFINE_SYSTEM_PROMPT}\n\nInput Text:\n${text}`;
    const modelsToTry = [GOOGLE_MODEL, ...GOOGLE_FALLBACK_MODELS];
    let lastError = null;

    for (let modelIndex = 0; modelIndex < modelsToTry.length; modelIndex++) {
        const model = modelsToTry[modelIndex];

        for (let attempt = 1; attempt <= RETRY_COUNT + 1; attempt++) {
            try {
                const refinedText = await callGoogleModelOnce(model, prompt, requestId, attempt);
                return { text: refinedText, model };
            } catch (err) {
                lastError = err;
                const retryable = isRetryableStatus(err.upstreamStatus);
                const hasMoreAttempts = attempt <= RETRY_COUNT;

                if (retryable && hasMoreAttempts) {
                    const delayMs = err.retryAfterMs ?? Math.min(500 * Math.pow(2, attempt - 1), 4000);
                    logRequest(requestId, "retrying Google API after transient error", {
                        model,
                        attempt,
                        upstreamStatus: err.upstreamStatus,
                        delayMs
                    });
                    await sleep(delayMs);
                    continue;
                }

                const canFallback = modelIndex < modelsToTry.length - 1
                    && (retryable || err.upstreamStatus === 404 || err.statusCode === 504);

                if (canFallback) {
                    logRequest(requestId, "switching to fallback model", {
                        failedModel: model,
                        nextModel: modelsToTry[modelIndex + 1],
                        reason: err.message
                    });
                    break;
                }

                throw err;
            }
        }
    }

    throw lastError || new HttpError(502, "Google API failed.");
}

const server = http.createServer(async (req, res) => {
    const pathname = new URL(req.url || "/", `http://${HOST}:${PORT}`).pathname;

    if (req.method === "OPTIONS") {
        sendNoContent(res);
        return;
    }

    if (req.method === "GET" && pathname === "/health") {
        sendJson(res, 200, {
            ok: true,
            provider: "google",
            model: GOOGLE_MODEL,
            fallbackModels: GOOGLE_FALLBACK_MODELS,
            hasApiKey: Boolean(GOOGLE_API_KEY)
        });
        return;
    }

    if (req.method !== "POST" || pathname !== "/refine") {
        sendJson(res, 404, { error: "Not found." });
        return;
    }

    const requestId = ++requestSerial;

    try {
        const body = await readJsonBody(req);
        const text = typeof body.text === "string" ? body.text : "";
        const reqLog = { textLength: text.length };
        if (DEBUG_LOG) {
            reqLog.textPreview = text.slice(0, 300);
        }
        logRequest(requestId, "refine request received", reqLog);

        if (!text.trim()) {
            sendJson(res, 400, { error: "Missing text." });
            return;
        }

        const result = await callGoogleRefine(text, requestId);
        const doneLog = {
            model: result.model,
            outputLength: result.text.length
        };
        if (DEBUG_LOG) {
            doneLog.outputPreview = result.text.slice(0, 300);
        }
        logRequest(requestId, "refine request completed", doneLog);

        sendJson(res, 200, {
            text: result.text,
            provider: "google",
            model: result.model
        });
    } catch (err) {
        const statusCode = err instanceof HttpError ? err.statusCode : 500;
        const errLog = {
            statusCode,
            error: err.message
        };
        if (DEBUG_LOG) {
            errLog.stack = err.stack;
        }
        logRequest(requestId, "refine request failed", errLog);
        sendJson(res, statusCode, { error: err.message });
    }
});

server.on("error", err => {
    if (err.code === "EADDRINUSE") {
        console.error(`Port ${PORT} is already in use on ${HOST}.`);
    } else {
        console.error(`Server error: ${err.message}`);
    }
    process.exit(1);
});

function shutdown(signal) {
    console.log(`Received ${signal}, shutting down WebRIS AI proxy...`);
    server.close(() => {
        process.exit(0);
    });
    setTimeout(() => process.exit(0), 3000).unref();
}

process.on("SIGINT", () => shutdown("SIGINT"));
process.on("SIGTERM", () => shutdown("SIGTERM"));

server.listen(PORT, HOST, () => {
    console.log(`WebRIS AI proxy listening on http://${HOST}:${PORT}`);
    console.log(`Provider: google, model: ${GOOGLE_MODEL}`);
    if (GOOGLE_FALLBACK_MODELS.length > 0) {
        console.log(`Fallback models: ${GOOGLE_FALLBACK_MODELS.join(", ")}`);
    }
});
