#!/usr/bin/env node

const fs = require("node:fs");
const { parseArgs } = require("node:util");

const DEFAULT_HOST = process.env.WEBRIS_AI_PROXY_HOST || "127.0.0.1";
const DEFAULT_PORT = Number(process.env.WEBRIS_AI_PROXY_PORT || 8787);
const DEFAULT_SAMPLE_TEXT = "- 10 x 8 mm pulmonary nodule in RUL (Srs/Img: 14/60).";
const DEFAULT_TIMEOUT_MS = 60000;
const HEALTH_TIMEOUT_MS = 5000;

function printHelp() {
    console.log(`Usage: node userscripts/test-webris-ai-proxy.js [options]

Options:
  --url <url>        Proxy base URL (default: http://${DEFAULT_HOST}:${DEFAULT_PORT})
  --host <host>      Proxy host (default: ${DEFAULT_HOST})
  --port <port>      Proxy port (default: ${DEFAULT_PORT})
  --text <text>      Custom text to send to POST /refine
  --file <path>      Read input text from file (use "-" for stdin)
  --health-only      Only run GET /health check (skips Google API call)
  --timeout <ms>     Timeout for /refine request in ms (default: ${DEFAULT_TIMEOUT_MS})
  --json             Print machine-readable JSON result
  -h, --help         Show this help message
`);
}

function readInputText(options) {
    if (options.text !== undefined) {
        return { text: options.text, isDefault: false };
    }

    if (options.file !== undefined) {
        const content = options.file === "-"
            ? fs.readFileSync(0, "utf8")
            : fs.readFileSync(options.file, "utf8");
        return { text: content, isDefault: false };
    }

    return { text: DEFAULT_SAMPLE_TEXT, isDefault: true };
}

async function fetchJson(url, init, timeoutMs) {
    const startedAt = Date.now();
    const res = await fetch(url, {
        ...init,
        signal: AbortSignal.timeout(timeoutMs)
    });
    const elapsedMs = Date.now() - startedAt;
    const rawText = await res.text();

    let json = null;
    try {
        json = rawText ? JSON.parse(rawText) : null;
    } catch {
        json = null;
    }

    return {
        status: res.status,
        ok: res.ok,
        elapsedMs,
        rawText,
        json
    };
}

function formatError(err) {
    if (err?.name === "TimeoutError") {
        return "Request timed out";
    }
    const causeCode = err?.cause?.code || err?.code;
    if (causeCode === "ECONNREFUSED") {
        return "Connection refused (proxy 未啟動或 port 不正確)";
    }
    return causeCode ? `${err.message} (${causeCode})` : (err?.message || String(err));
}

function evaluateDefaultSampleChecks(outputText) {
    const warnings = [];
    if (!outputText.trimStart().startsWith("-")) {
        warnings.push('輸出未保留原本的 "-" 項目符號');
    }
    if (!outputText.includes("Srs/Img: 14/60")) {
        warnings.push('輸出未保留影像定位標記 "(Srs/Img: 14/60)"');
    }
    if (!/mean diameter\s*:\s*9\s*mm/i.test(outputText)) {
        warnings.push('輸出未包含預期的肺結節平均直徑 "(mean diameter: 9 mm)"');
    }
    return warnings;
}

async function main() {
    let parsed;
    try {
        parsed = parseArgs({
            options: {
                url: { type: "string" },
                host: { type: "string" },
                port: { type: "string" },
                text: { type: "string" },
                file: { type: "string" },
                timeout: { type: "string" },
                "health-only": { type: "boolean", default: false },
                json: { type: "boolean", default: false },
                help: { type: "boolean", short: "h", default: false }
            },
            strict: true
        });
    } catch (err) {
        console.error(`Argument error: ${err.message}`);
        printHelp();
        process.exit(2);
    }

    const opts = parsed.values;
    if (opts.help) {
        printHelp();
        process.exit(0);
    }

    const host = opts.host || DEFAULT_HOST;
    const port = opts.port ? Number(opts.port) : DEFAULT_PORT;
    if (!opts.url && (!Number.isInteger(port) || port < 1 || port > 65535)) {
        console.error(`Invalid port: ${opts.port}`);
        process.exit(2);
    }

    const timeoutMs = opts.timeout ? Number(opts.timeout) : DEFAULT_TIMEOUT_MS;
    if (!Number.isFinite(timeoutMs) || timeoutMs <= 0) {
        console.error(`Invalid timeout: ${opts.timeout}`);
        process.exit(2);
    }

    const baseUrl = (opts.url || `http://${host}:${port}`).replace(/\/+$/, "");
    const report = {
        baseUrl,
        ok: true,
        checks: []
    };

    const log = (...args) => {
        if (!opts.json) {
            console.log(...args);
        }
    };

    log(`Testing WebRIS AI proxy at ${baseUrl}`);
    log("");

    // 1. Health check
    try {
        const health = await fetchJson(`${baseUrl}/health`, { method: "GET" }, Math.min(HEALTH_TIMEOUT_MS, timeoutMs));
        const passed = health.status === 200 && health.json?.ok === true;
        const hasApiKey = Boolean(health.json?.hasApiKey);

        report.checks.push({
            name: "health",
            ok: passed && hasApiKey,
            status: health.status,
            elapsedMs: health.elapsedMs,
            data: health.json
        });

        if (!passed) {
            report.ok = false;
            log(`[FAIL] GET /health -> HTTP ${health.status} (${health.elapsedMs}ms)`);
            log(`       Response: ${health.rawText.slice(0, 300)}`);
        } else if (!hasApiKey) {
            report.ok = false;
            log(`[FAIL] GET /health -> HTTP 200 (${health.elapsedMs}ms), but hasApiKey is false`);
            log(`       Provider: ${health.json.provider}, Model: ${health.json.model}`);
            log("       Hint: 請檢查 GOOGLE_AI_API_KEY / GEMINI_API_KEY 或 userscripts/webris-ai-proxy.local.ps1");
        } else {
            log(`[PASS] GET /health -> HTTP 200 (${health.elapsedMs}ms)`);
            log(`       Provider: ${health.json.provider}, Model: ${health.json.model}, hasApiKey: true`);
        }
    } catch (err) {
        const message = formatError(err);
        report.ok = false;
        report.checks.push({
            name: "health",
            ok: false,
            error: message
        });
        log(`[FAIL] GET /health -> ${message}`);
        log("       Hint: 請先執行 userscripts\\start-webris-ai-proxy.cmd 或 node userscripts/webris-ai-proxy.js");
    }

    if (!report.ok) {
        if (opts.json) {
            console.log(JSON.stringify(report, null, 2));
        }
        process.exit(1);
    }

    if (opts["health-only"]) {
        if (opts.json) {
            console.log(JSON.stringify(report, null, 2));
        } else {
            log("\nHealth-only check passed.");
        }
        process.exit(0);
    }

    // 2. Validation check (empty text should return 400 without calling Google API)
    try {
        const emptyRes = await fetchJson(
            `${baseUrl}/refine`,
            {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ text: "   " })
            },
            Math.min(HEALTH_TIMEOUT_MS, timeoutMs)
        );
        const passed = emptyRes.status === 400;
        report.checks.push({
            name: "validation-empty-text",
            ok: passed,
            status: emptyRes.status,
            elapsedMs: emptyRes.elapsedMs
        });
        if (passed) {
            log(`[PASS] POST /refine (empty text validation) -> HTTP 400 (${emptyRes.elapsedMs}ms)`);
        } else {
            report.ok = false;
            log(`[FAIL] POST /refine (empty text validation) -> expected HTTP 400, got HTTP ${emptyRes.status}`);
        }
    } catch (err) {
        const message = formatError(err);
        report.ok = false;
        report.checks.push({
            name: "validation-empty-text",
            ok: false,
            error: message
        });
        log(`[FAIL] POST /refine (empty text validation) -> ${message}`);
    }

    // 3. End-to-end refine check
    let inputInfo;
    try {
        inputInfo = readInputText(opts);
    } catch (err) {
        console.error(`Failed to read input text: ${err.message}`);
        process.exit(2);
    }

    try {
        const refine = await fetchJson(
            `${baseUrl}/refine`,
            {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ text: inputInfo.text })
            },
            timeoutMs
        );

        const outputText = typeof refine.json?.text === "string" ? refine.json.text : "";
        const passed = refine.status === 200 && outputText.trim().length > 0;
        const warnings = passed && inputInfo.isDefault ? evaluateDefaultSampleChecks(outputText) : [];

        report.checks.push({
            name: "refine",
            ok: passed,
            status: refine.status,
            elapsedMs: refine.elapsedMs,
            model: refine.json?.model,
            input: inputInfo.text,
            output: outputText,
            warnings,
            error: passed ? undefined : (refine.json?.error || refine.rawText.slice(0, 300))
        });

        if (passed) {
            log(`[PASS] POST /refine -> HTTP 200 (${refine.elapsedMs}ms)`);
            log(`       Model: ${refine.json.model || "(unknown)"}`);
            log("");
            log("--- Input ---");
            log(inputInfo.text);
            log("--- Output ---");
            log(outputText);
            if (warnings.length > 0) {
                log("");
                for (const warning of warnings) {
                    log(`[WARN] ${warning}`);
                }
            }
        } else {
            report.ok = false;
            const errMsg = refine.json?.error || refine.rawText.slice(0, 300) || `HTTP ${refine.status}`;
            log(`[FAIL] POST /refine -> HTTP ${refine.status} (${refine.elapsedMs}ms)`);
            log(`       Error: ${errMsg}`);
        }
    } catch (err) {
        const message = formatError(err);
        report.ok = false;
        report.checks.push({
            name: "refine",
            ok: false,
            error: message
        });
        log(`[FAIL] POST /refine -> ${message}`);
    }

    if (opts.json) {
        console.log(JSON.stringify(report, null, 2));
    } else {
        log("");
        log(report.ok ? "All checks passed." : "Some checks failed.");
    }

    process.exit(report.ok ? 0 : 1);
}

main();
