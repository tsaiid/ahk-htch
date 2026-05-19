#!/usr/bin/env node

const http = require("node:http");

const PORT = Number(process.env.WEBRIS_AI_PROXY_PORT || 8787);
const HOST = process.env.WEBRIS_AI_PROXY_HOST || "127.0.0.1";
const GOOGLE_API_KEY = process.env.GOOGLE_AI_API_KEY || process.env.GEMINI_API_KEY || "";
const GOOGLE_MODEL = process.env.WEBRIS_AI_GOOGLE_MODEL || "gemma-4-31b-it";
const GOOGLE_API_BASE_URL = process.env.WEBRIS_AI_GOOGLE_API_BASE_URL || "https://generativelanguage.googleapis.com/v1beta";
let requestSerial = 0;

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

function sendJson(res, statusCode, payload) {
    const body = JSON.stringify(payload);
    res.writeHead(statusCode, {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
        "Access-Control-Allow-Headers": "Content-Type",
        "Content-Type": "application/json; charset=utf-8",
        "Content-Length": Buffer.byteLength(body)
    });
    res.end(body);
}

function readJsonBody(req) {
    return new Promise((resolve, reject) => {
        let body = "";

        req.setEncoding("utf8");
        req.on("data", chunk => {
            body += chunk;
            if (body.length > 200000) {
                reject(new Error("Request body is too large."));
                req.destroy();
            }
        });
        req.on("end", () => {
            try {
                resolve(body ? JSON.parse(body) : {});
            } catch (err) {
                reject(new Error(`Invalid JSON: ${err.message}`));
            }
        });
        req.on("error", reject);
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
    const parts = responseJson?.candidates?.flatMap(candidate => candidate?.content?.parts || []) || [];
    const text = parts
        .filter(part => !part.thought && typeof part.text === "string")
        .map(part => part.text)
        .join("");

    if (!text) {
        throw new Error("Google API response did not include text.");
    }

    return stripMarkdownCodeFence(text);
}

function logRequest(requestId, message, data = {}) {
    console.log(`[${new Date().toISOString()}] [WebRIS AI proxy] [${requestId}] ${message}`, data);
}

async function callGoogleRefine(text, requestId) {
    if (!GOOGLE_API_KEY) {
        throw new Error("GOOGLE_AI_API_KEY or GEMINI_API_KEY is not set.");
    }

    const prompt = `${REFINE_SYSTEM_PROMPT}\n\nInput Text:\n${text}`;
    const url = `${GOOGLE_API_BASE_URL}/models/${encodeURIComponent(GOOGLE_MODEL)}:generateContent`;
    const startedAt = Date.now();

    logRequest(requestId, "calling Google API", {
        model: GOOGLE_MODEL,
        inputLength: text.length,
        promptLength: prompt.length
    });

    const upstream = await fetch(url, {
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
            generationConfig: {
                temperature: 0.3,
                thinkingConfig: { thinkingLevel: "MINIMAL" },
                topP: 0.95
            }
        })
    });

    const responseText = await upstream.text();
    logRequest(requestId, "Google API response", {
        status: upstream.status,
        elapsedMs: Date.now() - startedAt,
        responseLength: responseText.length,
        responsePreview: responseText.slice(0, 300)
    });

    let responseJson = {};
    try {
        responseJson = responseText ? JSON.parse(responseText) : {};
    } catch {
        responseJson = {};
    }

    if (!upstream.ok) {
        const message = responseJson?.error?.message || responseText || `HTTP ${upstream.status}`;
        throw new Error(`Google API failed: ${message}`);
    }

    return extractGoogleText(responseJson);
}

const server = http.createServer(async (req, res) => {
    if (req.method === "OPTIONS") {
        sendJson(res, 204, {});
        return;
    }

    if (req.method === "GET" && req.url === "/health") {
        sendJson(res, 200, {
            ok: true,
            provider: "google",
            model: GOOGLE_MODEL,
            hasApiKey: Boolean(GOOGLE_API_KEY)
        });
        return;
    }

    if (req.method !== "POST" || req.url !== "/refine") {
        sendJson(res, 404, { error: "Not found." });
        return;
    }

    const requestId = ++requestSerial;

    try {
        const body = await readJsonBody(req);
        const text = typeof body.text === "string" ? body.text : "";
        logRequest(requestId, "refine request received", {
            textLength: text.length,
            textPreview: text.slice(0, 300)
        });

        if (!text.trim()) {
            sendJson(res, 400, { error: "Missing text." });
            return;
        }

        const refinedText = await callGoogleRefine(text, requestId);
        logRequest(requestId, "refine request completed", {
            outputLength: refinedText.length,
            outputPreview: refinedText.slice(0, 300)
        });

        sendJson(res, 200, {
            text: refinedText,
            provider: "google",
            model: GOOGLE_MODEL
        });
    } catch (err) {
        logRequest(requestId, "refine request failed", {
            error: err.message,
            stack: err.stack
        });
        sendJson(res, 500, { error: err.message });
    }
});

server.listen(PORT, HOST, () => {
    console.log(`WebRIS AI proxy listening on http://${HOST}:${PORT}`);
    console.log(`Provider: google, model: ${GOOGLE_MODEL}`);
});
