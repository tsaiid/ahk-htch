// ==UserScript==
// @name         Enhanced WebRIS
// @namespace    http://tsai.it/
// @version      20250925.1
// @description  Add more functions and colors to EBM WebRIS
// @author       I-Ta Tsai
// @match        http://10.2.2.160:8080/
// @match        http://10.2.2.160:8080/risworklist/*
// @match        http://10.2.2.160:8080/verworklist/*
// @match        https://hlwris.tzuchi.com.tw/webris/
// @match        https://hlwris.tzuchi.com.tw/webris/risworklist/*
// @match        https://hlwris.tzuchi.com.tw/webris/verworklist/*
// @require      https://code.jquery.com/jquery-3.7.1.min.js
// @require      https://gist.githubusercontent.com/BrockA/2625891/raw/9c97aa67ff9c5d56be34a55ad6c18a314e5eb548/waitForKeyElements.js
// @icon         https://www.google.com/s2/favicons?sz=64&domain=2.160
// @grant        GM_xmlhttpRequest
// @grant        GM_registerMenuCommand
// @connect      127.0.0.1
// @connect      localhost
// ==/UserScript==

(function() {
    'use strict';

    let userAgent = navigator.userAgent;
    let isEdge = /Edg/.test(userAgent);
    let prev_examdate = '';
    let prev_examdate_pid = '';
    let isAiRefinePending = false;
    let isAiRefineAltDown = false;
    let isAiRefineSuppressingAltMenu = false;
    let lastAiRefineAltDownAt = 0;

    const AI_REFINE_PROXY_URL = "http://127.0.0.1:8787/refine";
    const AI_REFINE_DEBUG = true;

    console.log("[WebRIS AI] userscript loaded", {
        proxyUrl: AI_REFINE_PROXY_URL,
        hasGmXmlHttpRequest: typeof GM_xmlhttpRequest === "function",
        hasGmRegisterMenuCommand: typeof GM_registerMenuCommand === "function"
    });

    const CONTRAST_STR = {
        X5A: " without contrast medium",
        X5B: " with contrast medium",
        X5C: " without and with contrast medium",
        X6A: " without contrast medium",
        X6B: " with contrast medium",
        X6C: " without and with contrast medium"
    };

    function isSameExam(prevExamName, currExamName) {
        return (prevExamName === currExamName || prevExamName === currExamName.replace(/ /g, ''));
    }
    function isSimilarExam(prevExamName, currExamName) {
        return (simExam[currExamName] && simExam[currExamName].includes(prevExamName));
    }
    function isRelatedReport(prevExamName, currExamName) {
        return isSameExam(prevExamName, currExamName) || isSimilarExam(prevExamName, currExamName);
    }

    function findExamInfoByLabel(labelText) {
        const labels = document.querySelectorAll('div[style="width: 99%;"] label');
        for (let label of labels) {
            if (label.innerText === labelText) {
                const parent = label.parentElement;
                const input = parent.querySelector('input');
                if (input) {
                    return input.value.trim();
                }
            }
        }
        return null;
    }

    function getCurrExamName() {
        return findExamInfoByLabel('檢查項目');
    }
    function getCurrExamDate() {
        return findExamInfoByLabel('檢查日期');
    }
    function getCurrExamTime() {
        return findExamInfoByLabel('檢查時間');
    }
    function getCurrContrast() {
        return findExamInfoByLabel('顯影劑');
    }
    function getCurrPatId() {
        return findExamInfoByLabel('病歷號碼');
    }
    function getCurrAccNo() {
        return findExamInfoByLabel('檢查單號');
    }

    function getFrameHistoryTr() {
        // exclude no data case: the tr has only 1 td with colspan attr.
        const allRows = document.querySelectorAll('#frameHistory tbody tr');
        const filteredRows = Array.from(allRows).filter(tr => {
            const tds = tr.querySelectorAll('td');
            return !Array.from(tds).some(td => td.hasAttribute('colspan'));
        });
        return filteredRows;
    }

    function getFrameHistoryUnfinishedTr() {
        const allRows = document.querySelectorAll('#frameHistory tbody tr');
        const filteredRows = Array.from(allRows).filter(tr => {
            const tds = tr.querySelectorAll('td:first-child');
            return Array.from(tds).some(td => td.textContent.endsWith('*'));
        });
        return filteredRows;
    }

    function getFrameHistoryFinishedSameDateTr(specifiedExamDate) {
        const allRows = document.querySelectorAll('#frameHistory tbody tr');
        const filteredRows = Array.from(allRows).filter(tr => {
            const tds = tr.querySelectorAll('td:first-child');
            return Array.from(tds).some(td => !td.textContent.endsWith('*') && td.textContent == specifiedExamDate);
        });
        return filteredRows;
    }

    function scrollToSelectedItem(selectedTr) {
        // can be used for both history report and pathology report tables
        //const frameHistory = document.querySelector('#frameHistory');
        const tableParentDiv = selectedTr?.parentNode?.parentNode?.parentNode;
        //console.log("selectedTr: " + selectedTr);
        //console.log("selectedTr.parentNode: " + selectedTr?.parentNode);
        //console.log("tableParentDiv: " + tableParentDiv);
        if (tableParentDiv) {
            const theadTrHeight = tableParentDiv.querySelector('thead tr')?.clientHeight ?? 0;
            //console.log('tr top: ' + selectedTr.offsetTop + '; tr height: ' + selectedTr.clientHeight + '; div top: ' + tableParentDiv.offsetTop + '; div height: ' + tableParentDiv.clientHeight + '; div scrollTop: ' + tableParentDiv.scrollTop);
            if (selectedTr.offsetTop + selectedTr.clientHeight > tableParentDiv.scrollTop + tableParentDiv.clientHeight) {
                tableParentDiv.scrollTop = selectedTr.offsetTop - theadTrHeight;
            } else if (selectedTr.offsetTop < tableParentDiv.scrollTop + theadTrHeight) {
                tableParentDiv.scrollTop = (selectedTr.offsetTop + selectedTr.clientHeight < tableParentDiv.clientHeight)
                    ? 0
                : selectedTr.offsetTop - theadTrHeight;
            }
        }
    }

    function getPathoHistoryTr() {
        // exclude no data case: the tr has only 1 td with colspan attr.
        const allRows = document.querySelectorAll('div.table-wrp.block.max-h-48 tbody tr');
        const filteredRows = Array.from(allRows).filter(tr => {
            const tds = tr.querySelectorAll('td');
            return !Array.from(tds).some(td => td.hasAttribute('colspan'));
        });
        return filteredRows;
    }

    function getTabName() {
        return document.querySelector('div.flex.items-center.text-20 div.text-primary')?.textContent;
    }

    function isAbdCT(examName) {
        const abdCTList = ['Abdomen to Pelvis CT', 'Abdomen  Liver Triple Phase CT', 'Abdomen  Liver 4 Phase CT',
                           'ABDOMEN  Lymph  Nodes   CT', 'Colon cancer (Abdomen & Pelvis)-CT',
                           'Abdomen pancreas dual phase CT'];
        return abdCTList.includes(examName);
    }
    function isChestCT(examName) {
        const chestCTList = ['Chest CT', 'Chest Pulmonary Arteries CT'];
        return chestCTList.includes(examName);
    }
    function isAortaCT(examName) {
        return examName.includes("Aorta");
    }
    function isMsk(examName) {
        return examName.match(/JOINT|Leg|Hand(-CT| MRI)|Forearm- CT|Femur|foot (CT|MRI)/);
    }
    function isAngio(examName) {
        const angioList = ['Celiac a three vessel', 'Lipiodol T.A.E.(trans-arterial embolization)-Lipiodol',
                           'Percutaneous placement of ureter stent', 'Percutaneous retrieval of ureteral stent',
                           'PCN', 'Percutaneous ureteroplasty', 'PCN revision', 'P.T.C.', 'P.T.C.D.'];
        return angioList.includes(examName);
    }
    function isSonoCDU(examName) {
        return examName.includes("Sono CDU");
    }
    function isSonoBreast(examName) {
        return examName == "Sono Breasts";
    }
    function isSpineCTorMRI(examName) {
        return examName.match(/SPINE.+(CT|MRI)/);
    }

    function joinWithAnd(arr) {
        // 如果 array 為空，返回空字串
        if (arr.length === 0) return '';
        // 如果 array 只有一個元素，直接返回
        if (arr.length === 1) return arr[0];
        // 如果 array 有兩個元素，使用 'and' 連接
        if (arr.length === 2) return `${arr[0]} and ${arr[1]}`;

        // 處理三個以上的元素，將前 n-1 個元素用 ", " 連接，最後一個元素用 ", and " 連接
        const lastItem = arr.pop(); // 取出最後一個元素
        return `${arr.join(', ')}, and ${lastItem}`;
    }

    function getEditorElement(target) {
        return target.closest?.('.ql-editor') || null;
    }

    function getEditorElementFromSelection() {
        const selection = window.getSelection();
        if (!selection || !selection.rangeCount) return null;

        const nodes = [selection.anchorNode, selection.focusNode];
        for (const node of nodes) {
            const element = node?.nodeType === Node.ELEMENT_NODE ? node : node?.parentElement;
            const editor = element?.closest?.(".ql-editor");
            if (editor) return editor;
        }

        return null;
    }

    function getActiveEditorElement() {
        return getEditorElement(document.activeElement) || getEditorElementFromSelection();
    }

    function getBestEditorEventTarget(target) {
        const editor = getEditorElement(target) || getActiveEditorElement();
        return editor || target;
    }

    function getEventTargetDebug(target) {
        if (!target) return "(no target)";
        const tagName = target.tagName || target.nodeName || "(unknown)";
        const id = target.id ? `#${target.id}` : "";
        const className = typeof target.className === "string" && target.className
            ? `.${target.className.trim().replace(/\s+/g, ".")}`
            : "";
        return `${tagName}${id}${className}`;
    }

    function logAiRefineDebug(message, data = null) {
        if (!AI_REFINE_DEBUG) return;
        if (data === null) {
            console.log(`[WebRIS AI] ${message}`);
        } else {
            console.log(`[WebRIS AI] ${message}`, data);
        }
    }

    function normalizeContentEditableInsertText(text) {
        return text.replace(/\n+$/g, "");
    }

    function createEditorLine(sourceLine, text) {
        const line = sourceLine.cloneNode(false);
        if (text.length) {
            line.appendChild(document.createTextNode(text));
        } else {
            line.appendChild(document.createElement("br"));
        }
        return line;
    }

    function insertEditorLines(editor, beforeLine, sourceLine, text) {
        const lines = text.split("\n");
        let lastLine = null;

        lines.forEach(lineText => {
            const line = createEditorLine(sourceLine, lineText);
            editor.insertBefore(line, beforeLine);
            lastLine = line;
        });

        return lastLine;
    }

    function insertEditorLineList(editor, beforeLine, sourceLine, lines) {
        let lastLine = null;

        lines.forEach(lineText => {
            const line = createEditorLine(sourceLine, lineText);
            editor.insertBefore(line, beforeLine);
            lastLine = line;
        });

        return lastLine;
    }

    function getEditorLineElement(editor, node) {
        let element = node?.nodeType === Node.ELEMENT_NODE ? node : node?.parentElement;
        while (element && element.parentElement !== editor) {
            element = element.parentElement;
        }
        return element?.parentElement === editor ? element : null;
    }

    function setCaretAfterNode(node) {
        const range = document.createRange();
        range.setStartAfter(node);
        range.collapse(true);

        const selection = window.getSelection();
        selection.removeAllRanges();
        selection.addRange(range);
    }

    function setCaretBeforeNode(node) {
        const range = document.createRange();
        range.setStartBefore(node);
        range.collapse(true);

        const selection = window.getSelection();
        selection.removeAllRanges();
        selection.addRange(range);
    }

    function setCaretInEditorLine(line) {
        const range = document.createRange();
        range.setStart(line, 0);
        range.collapse(true);

        const selection = window.getSelection();
        selection.removeAllRanges();
        selection.addRange(range);
    }

    function dispatchEditorInput(editor, inputType, data = null) {
        editor.dispatchEvent(new InputEvent("input", { bubbles: true, inputType, data }));
    }

    function replaceSelectedContentEditableText(editor, text) {
        const selection = window.getSelection();
        if (!selection || !selection.rangeCount || selection.isCollapsed) return false;
        if (!editor.contains(selection.anchorNode) || !editor.contains(selection.focusNode)) return false;

        const range = selection.getRangeAt(0);
        const startLine = getEditorLineElement(editor, range.startContainer);
        const endLine = getEditorLineElement(editor, range.endContainer);
        let lastNode = null;

        if (startLine && endLine) {
            const afterLine = endLine.nextSibling;

            let line = startLine;
            while (line) {
                const nextLine = line.nextSibling;
                line.remove();
                if (line === endLine) break;
                line = nextLine;
            }

            lastNode = insertEditorLines(editor, afterLine, startLine, text);
        } else {
            const fragment = document.createDocumentFragment();
            fragment.appendChild(document.createTextNode(text));
            lastNode = fragment.lastChild;

            range.deleteContents();
            range.insertNode(fragment);
        }

        if (lastNode) {
            setCaretAfterNode(lastNode);
        }

        dispatchEditorInput(editor, "insertText", text);
        return true;
    }

    function insertContentEditableText(editor, text) {
        if (!editor) return false;

        const selection = window.getSelection();
        if (!selection || !selection.rangeCount) return false;
        if (!editor.contains(selection.anchorNode) || !editor.contains(selection.focusNode)) return false;

        if (!selection.isCollapsed) {
            return replaceSelectedContentEditableText(editor, text.replace(/\r\n|\r/g, "\n"));
        }

        const range = selection.getRangeAt(0);
        const currentLine = getEditorLineElement(editor, range.startContainer) || editor.firstElementChild;
        if (!currentLine) return false;

        const normalizedText = text.replace(/\r\n|\r/g, "\n");
        const lines = normalizedText.split("\n");

        if (lines.length === 1) {
            const textNode = document.createTextNode(normalizedText);
            range.insertNode(textNode);
            setCaretAfterNode(textNode);
        } else {
            const isCurrentLineEmpty = isEmptyEditorDomLine(currentLine);
            let lastLine = null;

            if (isCurrentLineEmpty) {
                lastLine = insertEditorLines(editor, currentLine, currentLine, normalizedText);
                currentLine.remove();
                setCaretAfterNode(lastLine);
            } else {
                const tailRange = range.cloneRange();
                tailRange.setEnd(currentLine, currentLine.childNodes.length);
                const tailFragment = tailRange.extractContents();
                const tailFirstChild = tailFragment.firstChild;
                const firstTextNode = document.createTextNode(lines[0]);
                range.insertNode(firstTextNode);

                lastLine = insertEditorLineList(editor, currentLine.nextSibling, currentLine, lines.slice(1));
                if (tailFirstChild) {
                    lastLine.appendChild(tailFragment);
                    setCaretBeforeNode(tailFirstChild);
                } else {
                    setCaretAfterNode(lastLine);
                }
            }
        }

        dispatchEditorInput(editor, "insertText", normalizedText);
        return true;
    }

    function selectionHasTextInElement(element) {
        const selection = window.getSelection();
        return selection && !selection.isCollapsed && element.contains(selection.anchorNode) && element.contains(selection.focusNode);
    }

    function getCurrentEditorDomLine(editor) {
        const selection = window.getSelection();
        if (!selection || !selection.rangeCount || !selection.isCollapsed) return null;
        if (!editor.contains(selection.anchorNode)) return null;

        let node = selection.anchorNode;
        if (node === editor) {
            node = editor.childNodes[selection.anchorOffset] || editor.childNodes[selection.anchorOffset - 1];
        }

        let line = node?.nodeType === Node.ELEMENT_NODE ? node : node?.parentElement;
        while (line && line.parentElement !== editor) {
            line = line.parentElement;
        }

        return line?.parentElement === editor ? line : null;
    }

    function selectCurrentEditorDomLine(editor) {
        if (selectionHasTextInElement(editor)) return false;

        const line = getCurrentEditorDomLine(editor);
        if (!line) return false;

        const range = document.createRange();
        range.selectNodeContents(line);

        const selection = window.getSelection();
        selection.removeAllRanges();
        selection.addRange(range);
        return true;
    }

    function isEmptyEditorDomLine(line) {
        return line.textContent.replace(/\u00a0/g, '').trim() === '';
    }

    function deleteEmptyEditorDomLine(editor, line) {
        const nextLine = line.nextSibling;
        const prevLine = line.previousSibling;
        line.remove();

        if (!editor.firstChild) {
            const newLine = document.createElement(line.tagName.toLowerCase());
            newLine.appendChild(document.createElement('br'));
            editor.appendChild(newLine);
            setCaretInEditorLine(newLine);
        } else {
            setCaretInEditorLine(nextLine || prevLine);
        }

        dispatchEditorInput(editor, 'deleteContent');
    }

    function deleteEditorDomTextToLineEnd(editor) {
        const selection = window.getSelection();
        if (!selection || !selection.rangeCount || !selection.isCollapsed) return false;
        if (!editor.contains(selection.anchorNode)) return false;

        const line = getCurrentEditorDomLine(editor);
        if (!line) return false;

        if (isEmptyEditorDomLine(line)) {
            deleteEmptyEditorDomLine(editor, line);
            return true;
        }

        const range = selection.getRangeAt(0).cloneRange();
        range.setEnd(line, line.childNodes.length);

        if (!range.collapsed) {
            range.deleteContents();
        } else if (line.nextSibling) {
            line.nextSibling.remove();
        } else {
            return false;
        }

        dispatchEditorInput(editor, 'deleteContentForward');
        return true;
    }

    function cutSelectedEditorDomText(editor) {
        const selection = window.getSelection();
        if (!selection || !selection.rangeCount || selection.isCollapsed) return false;
        if (!editor.contains(selection.anchorNode) || !editor.contains(selection.focusNode)) return false;

        const text = selection.toString();
        navigator.clipboard?.writeText(text).catch(() => {});

        const range = selection.getRangeAt(0);
        const startLine = getEditorLineElement(editor, range.startContainer);
        const endLine = getEditorLineElement(editor, range.endContainer);

        if (startLine && endLine) {
            const caretLine = endLine.nextSibling || startLine.previousSibling;
            let line = startLine;
            while (line) {
                const nextLine = line.nextSibling;
                line.remove();
                if (line === endLine) break;
                line = nextLine;
            }

            if (!editor.firstChild) {
                const newLine = createEditorLine(startLine, "");
                editor.appendChild(newLine);
                setCaretInEditorLine(newLine);
            } else {
                setCaretInEditorLine(caretLine || editor.firstChild);
            }
        } else {
            range.deleteContents();
            selection.removeAllRanges();
            selection.addRange(range);
        }

        dispatchEditorInput(editor, 'deleteByCut');
        return true;
    }

    function getSelectionInEditor(editor) {
        const selection = window.getSelection();
        if (!selection || !selection.rangeCount || selection.isCollapsed) return null;
        if (!editor.contains(selection.anchorNode) || !editor.contains(selection.focusNode)) return null;
        return selection;
    }

    function getNormalizedTrailingNewlines(text) {
        const match = text.replace(/\r\n|\r/g, "\n").match(/\n+$/);
        return match ? match[0] : "";
    }

    function normalizeAiRefineResult(text, trailingNewlines) {
        let result = text.replace(/\r\n|\r/g, "\n").replace(/\n+$/g, "");
        return result + trailingNewlines;
    }

    function showAiRefineStatus(message, duration = 1800) {
        let status = document.querySelector("#ebm-webris-ai-status");
        if (!status) {
            status = document.createElement("div");
            status.id = "ebm-webris-ai-status";
            Object.assign(status.style, {
                position: "fixed",
                left: "50%",
                top: "33vh",
                transform: "translateX(-50%)",
                zIndex: "2147483647",
                padding: "12px 18px",
                background: "#f3f1ec",
                color: "#35414b",
                border: "1px solid #ddd8cf",
                borderRadius: "8px",
                fontSize: "17px",
                lineHeight: "1.4",
                boxShadow: "0 12px 32px rgba(48, 56, 66, 0.13)",
                maxWidth: "min(720px, 86vw)",
                whiteSpace: "pre-wrap"
            });
            document.body.appendChild(status);
        }

        status.textContent = message;
        status.style.display = "block";

        clearTimeout(status._hideTimer);
        if (duration > 0) {
            status._hideTimer = setTimeout(() => {
                status.style.display = "none";
            }, duration);
        }
    }

    function postJsonWithGm(url, payload) {
        if (typeof GM_xmlhttpRequest !== "function") {
            throw new Error("GM_xmlhttpRequest unavailable. Please reload/reinstall the Tampermonkey script so @grant permissions are applied.");
        }

        return new Promise((resolve, reject) => {
            logAiRefineDebug("POST proxy", {
                url,
                payloadKeys: Object.keys(payload),
                textLength: payload.text?.length ?? 0
            });

            GM_xmlhttpRequest({
                method: "POST",
                url,
                headers: { "Content-Type": "application/json" },
                data: JSON.stringify(payload),
                timeout: 120000,
                onload: response => {
                    logAiRefineDebug("proxy response", {
                        status: response.status,
                        responseLength: response.responseText?.length ?? 0,
                        responsePreview: response.responseText?.slice(0, 300) ?? ""
                    });

                    if (response.status < 200 || response.status >= 300) {
                        reject(new Error(response.responseText || `HTTP ${response.status}`));
                        return;
                    }

                    try {
                        resolve(JSON.parse(response.responseText));
                    } catch (err) {
                        reject(new Error(`Invalid proxy response: ${err.message}`));
                    }
                },
                ontimeout: () => reject(new Error("AI proxy request timed out.")),
                onerror: response => {
                    logAiRefineDebug("proxy request error", response);
                    reject(new Error("AI proxy request failed."));
                }
            });
        });
    }

    async function callAiRefineProxy(selectedText) {
        const response = await postJsonWithGm(AI_REFINE_PROXY_URL, { text: selectedText });
        if (!response || typeof response.text !== "string") {
            throw new Error("AI proxy did not return text.");
        }
        return response.text;
    }

    function restoreSelectionRange(editor, range) {
        if (!range) return false;
        if (!editor.contains(range.startContainer) || !editor.contains(range.endContainer)) return false;

        const selection = window.getSelection();
        selection.removeAllRanges();
        selection.addRange(range);
        return true;
    }

    function getRangeTextBefore(range, line) {
        const beforeRange = document.createRange();
        beforeRange.selectNodeContents(line);
        beforeRange.setEnd(range.startContainer, range.startOffset);
        return beforeRange.toString();
    }

    function getRangeTextAfter(range, line) {
        const afterRange = document.createRange();
        afterRange.selectNodeContents(line);
        afterRange.setStart(range.endContainer, range.endOffset);
        return afterRange.toString();
    }

    function buildReplacementLines(prefix, replacementText, suffix) {
        const replacementLines = replacementText.replace(/\r\n|\r/g, "\n").split("\n");
        replacementLines[0] = prefix + replacementLines[0];
        replacementLines[replacementLines.length - 1] += suffix;
        return replacementLines;
    }

    function replaceSelectedEditorRangeText(editor, range, text) {
        if (!editor.contains(range.startContainer) || !editor.contains(range.endContainer)) return false;

        const startLine = getEditorLineElement(editor, range.startContainer);
        const endLine = getEditorLineElement(editor, range.endContainer);

        if (!startLine || !endLine) {
            const textNode = document.createTextNode(text.replace(/\r\n|\r/g, "\n"));
            range.deleteContents();
            range.insertNode(textNode);
            setCaretAfterNode(textNode);
            dispatchEditorInput(editor, "insertText", text);
            return true;
        }

        const afterLine = endLine.nextSibling;
        const prefix = getRangeTextBefore(range, startLine);
        const suffix = getRangeTextAfter(range, endLine);
        const replacementLines = buildReplacementLines(prefix, text, suffix);

        let line = startLine;
        while (line) {
            const nextLine = line.nextSibling;
            line.remove();
            if (line === endLine) break;
            line = nextLine;
        }

        let lastLine = null;
        replacementLines.forEach(lineText => {
            const newLine = createEditorLine(startLine, lineText);
            editor.insertBefore(newLine, afterLine);
            lastLine = newLine;
        });

        if (lastLine) {
            setCaretAfterNode(lastLine);
        }

        dispatchEditorInput(editor, "insertText", text.replace(/\r\n|\r/g, "\n"));
        return true;
    }

    function closeAiRefineComparisonDialog(dialog) {
        dialog?._cleanup?.();
        dialog?.remove();
    }

    function hasAiRefineComparisonDialog() {
        return Boolean(document.querySelector("#ebm-webris-ai-compare-dialog"));
    }

    function showAiRefineComparisonDialog(editor, selectedRange, originalText, refinedText) {
        const existingDialog = document.querySelector("#ebm-webris-ai-compare-dialog");
        existingDialog?.remove();
        const editorStyle = window.getComputedStyle(editor);
        const editorTextStyle = {
            fontFamily: editorStyle.fontFamily,
            fontSize: editorStyle.fontSize,
            lineHeight: editorStyle.lineHeight
        };

        const dialog = document.createElement("div");
        dialog.id = "ebm-webris-ai-compare-dialog";
        dialog.tabIndex = -1;
        Object.assign(dialog.style, {
            position: "fixed",
            inset: "0",
            zIndex: "2147483647",
            background: "rgba(48, 56, 66, 0.28)",
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            padding: "24px"
        });

        const panel = document.createElement("div");
        Object.assign(panel.style, {
            width: "min(1120px, 94vw)",
            height: "min(720px, 86vh)",
            background: "#f3f1ec",
            color: "#35414b",
            borderRadius: "8px",
            border: "1px solid #ddd8cf",
            boxShadow: "0 24px 68px rgba(48, 56, 66, 0.19)",
            display: "grid",
            gridTemplateRows: "auto 1fr auto",
            overflow: "hidden",
            fontFamily: "system-ui, -apple-system, BlinkMacSystemFont, Segoe UI, sans-serif"
        });

        const header = document.createElement("div");
        header.textContent = "AI Refine";
        Object.assign(header.style, {
            padding: "12px 16px",
            fontSize: "16px",
            fontWeight: "600",
            color: "#394752",
            background: "#ebe8e1",
            borderBottom: "1px solid #ddd8cf"
        });

        const body = document.createElement("div");
        Object.assign(body.style, {
            display: "grid",
            gridTemplateColumns: "1fr 1fr",
            gap: "12px",
            padding: "12px",
            minHeight: "0"
        });

        const beforeBox = createAiRefineComparePane("Before", originalText, true, editorTextStyle);
        const afterBox = createAiRefineComparePane("After", refinedText, true, editorTextStyle);
        body.append(beforeBox.wrapper, afterBox.wrapper);

        const footer = document.createElement("div");
        Object.assign(footer.style, {
            display: "flex",
            justifyContent: "flex-end",
            gap: "8px",
            padding: "12px 16px",
            borderTop: "1px solid #ddd8cf",
            background: "#ebe8e1"
        });

        const cancelButton = createAiRefineDialogButton("取消", "#ddd8cf", "#46525d");
        const acceptButton = createAiRefineDialogButton("採用", "#6f879d", "#fff");
        const cancelDialog = () => {
            closeAiRefineComparisonDialog(dialog);
            showAiRefineStatus("AI 潤色結果未採用");
        };
        const acceptDialog = () => {
            try {
                if (!restoreSelectionRange(editor, selectedRange)) {
                    throw new Error("原本選取範圍已改變，未套用 AI 結果。");
                }

                replaceSelectedEditorRangeText(editor, selectedRange, afterBox.textarea.value);
                closeAiRefineComparisonDialog(dialog);
                showAiRefineStatus("AI 潤色結果已採用");
            } catch (err) {
                console.error(err);
                showAiRefineStatus(`AI 潤色結果套用失敗: ${err.message}`, 8000);
            }
        };

        cancelButton.addEventListener("click", () => {
            cancelDialog();
        });

        acceptButton.addEventListener("click", () => {
            acceptDialog();
        });

        footer.append(cancelButton, acceptButton);
        panel.append(header, body, footer);
        dialog.appendChild(panel);

        const handleDialogKeydown = ev => {
            if (ev.key === "Escape") {
                ev.preventDefault();
                ev.stopPropagation();
                cancelDialog();
            } else if (ev.key === "Enter") {
                ev.preventDefault();
                ev.stopPropagation();
                acceptDialog();
            }
        };

        dialog.addEventListener("keydown", handleDialogKeydown);
        document.addEventListener("keydown", handleDialogKeydown, true);
        dialog._cleanup = () => {
            document.removeEventListener("keydown", handleDialogKeydown, true);
        };

        document.body.appendChild(dialog);
        const focusAfterText = () => {
            if (!document.body.contains(dialog)) return;
            if (document.activeElement !== afterBox.textarea) {
                afterBox.textarea.focus({ preventScroll: true });
                afterBox.textarea.setSelectionRange(0, 0);
                logAiRefineDebug("comparison dialog focused", {
                    activeElement: getEventTargetDebug(document.activeElement)
                });
            }
        };

        focusAfterText();
        requestAnimationFrame(() => requestAnimationFrame(focusAfterText));
        setTimeout(focusAfterText, 80);
        setTimeout(focusAfterText, 250);
    }

    function createAiRefineComparePane(title, text, readOnly, textStyle) {
        const wrapper = document.createElement("div");
        Object.assign(wrapper.style, {
            display: "grid",
            gridTemplateRows: "auto 1fr",
            minWidth: "0",
            minHeight: "0"
        });

        const label = document.createElement("div");
        label.textContent = title;
        Object.assign(label.style, {
            padding: "0 0 6px",
            fontSize: "13px",
            fontWeight: "600",
            color: "#53616b"
        });

        const textarea = document.createElement("textarea");
        textarea.value = text;
        textarea.readOnly = readOnly;
        Object.assign(textarea.style, {
            width: "100%",
            height: "100%",
            resize: "none",
            boxSizing: "border-box",
            border: "1px solid #ddd8cf",
            borderRadius: "6px",
            padding: "10px",
            background: readOnly ? "#eeeae3" : "#f8f6f1",
            color: "#35414b",
            fontFamily: textStyle.fontFamily,
            fontSize: textStyle.fontSize,
            lineHeight: textStyle.lineHeight,
            whiteSpace: "pre-wrap"
        });

        wrapper.append(label, textarea);
        return { wrapper, textarea };
    }

    function createAiRefineDialogButton(text, background, color) {
        const button = document.createElement("button");
        button.type = "button";
        button.textContent = text;
        Object.assign(button.style, {
            minWidth: "72px",
            padding: "7px 12px",
            border: "0",
            borderRadius: "6px",
            background,
            color,
            cursor: "pointer",
            fontSize: "14px",
            fontWeight: "600"
        });
        return button;
    }

    async function refineSelectedEditorText(target) {
        const editor = getEditorElement(target) || getActiveEditorElement();
        logAiRefineDebug("refine invoked", {
            eventTarget: getEventTargetDebug(target),
            activeElement: getEventTargetDebug(document.activeElement),
            hasEditor: Boolean(editor),
            hasSelection: Boolean(window.getSelection()?.rangeCount),
            selectionCollapsed: window.getSelection()?.isCollapsed ?? null
        });

        if (!editor) {
            showAiRefineStatus(`Alt+R 已觸發，但找不到 .ql-editor\nTarget: ${getEventTargetDebug(target)}\nActive: ${getEventTargetDebug(document.activeElement)}`, 6000);
            return true;
        }

        let selection = getSelectionInEditor(editor);
        if (!selection && !selectCurrentEditorDomLine(editor)) {
            showAiRefineStatus(`Alt+R 已觸發，但無法選取目前行\nEditor text length: ${editor.textContent.length}`, 6000);
            return true;
        }

        selection = getSelectionInEditor(editor);
        if (!selection) {
            showAiRefineStatus("Alt+R 已觸發，但選取範圍不在 .ql-editor 內", 6000);
            return true;
        }

        const selectedText = selection.toString();
        logAiRefineDebug("selected text", {
            length: selectedText.length,
            preview: selectedText.slice(0, 300)
        });

        if (selectedText.trim() === "") {
            showAiRefineStatus("選取的文字為空");
            return true;
        }

        if (isAiRefinePending) {
            showAiRefineStatus("Alt+R 已觸發，但 AI 潤色仍在進行中...");
            return true;
        }

        const selectedRange = selection.getRangeAt(0).cloneRange();
        const trailingNewlines = getNormalizedTrailingNewlines(selectedText);

        try {
            isAiRefinePending = true;
            document.body.style.cursor = "wait";
            showAiRefineStatus("AI 潤色中...", 0);

            const refinedText = await callAiRefineProxy(selectedText);
            const finalText = normalizeAiRefineResult(refinedText, trailingNewlines);

            showAiRefineComparisonDialog(editor, selectedRange, selectedText, finalText);
            showAiRefineStatus(`AI 潤色完成，請確認是否採用\nOutput length: ${finalText.length}`);
        } catch (err) {
            console.error(err);
            showAiRefineStatus(`AI 潤色失敗: ${err.message}\nProxy: ${AI_REFINE_PROXY_URL}`, 8000);
        } finally {
            isAiRefinePending = false;
            document.body.style.cursor = "";
        }

        return true;
    }

    function reorderSelectedTextValue(selectedText, deOrder = false, keepEmptyLine = false, itemChar = "", discardSeIm = true) {
        let isSpine = false;
        let hadTrimmedRight = false;

        selectedText = selectedText.replace(/\r\n|\r/g, "\n");

        if (selectedText.endsWith("\n")) {
            selectedText = selectedText.slice(0, -1);
            hadTrimmedRight = true;
        }

        if (!selectedText.length) return null;

        const txtAry = selectedText.split("\n");
        const endLine = txtAry.length;
        let finalText = "";
        let isFirstLineEmpty = false;
        let startLineNo = parseInt(selectedText.match(/^(\d+)/)?.[1] ?? "1", 10);

        txtAry.forEach((line, i) => {
            const index = i + 1;

            if (index === 1 && !line.length) {
                isFirstLineEmpty = true;
            }

            if (!/^\s*$/.test(line)) {
                if (/^\s*[-+*]*\s*([Vv]arying degree|[Mm]ild).+causing:/.test(line)) {
                    isSpine = true;
                }

                let tmpText = line;
                if (!deOrder) {
                    const orderChar = itemChar.length ? itemChar : `${startLineNo++}.`;
                    const matchedSpineLevel = line.match(/^\s*([-+*]*|-->)\s*([CcTtLl]\d{1,2}-.+$)/);
                    if (isSpine && matchedSpineLevel) {
                        finalText += "-> ";
                        tmpText = matchedSpineLevel[2];
                    } else {
                        finalText += `${orderChar} `;
                    }
                }

                if (!itemChar.length && discardSeIm) {
                    tmpText = tmpText.replace(/\s*\(Srs\/Img:[\s,\-/\d;]+\)/g, "");
                    tmpText = tmpText.replace(/Mark L\d+:\s*/g, "");
                }

                finalText += tmpText.replace(
                    /^(\s*)((\d+\.)|([-+*>=])|(\(?\d+\)))?(\s*)(\w?)(.*)/,
                    (_match, _p1, _p2, _p3, _p4, _p5, _p6, firstWordChar, restText) => firstWordChar.toUpperCase() + restText
                );

                if (index < endLine || hadTrimmedRight) {
                    finalText += "\n";
                }
            } else {
                if (isFirstLineEmpty && index === 1) {
                    finalText += `${line}\n`;
                }

                if (keepEmptyLine) {
                    if (isFirstLineEmpty) {
                        if (index % 2 === 0) {
                            finalText += `${line}\n`;
                        }
                    } else if (index % 2 === 1) {
                        finalText += `${line}\n`;
                    }
                }
            }
        });

        return finalText;
    }

    function getReorderSelectedTextOptions(ev) {
        if (!ev.ctrlKey && !ev.altKey && !ev.shiftKey) {
            if (ev.key === "KanaMode" || ev.code === "KanaMode") {
                return {};
            }
            if (ev.key === "Convert" || ev.code === "Convert") {
                return { keepEmptyLine: true, itemChar: "-", discardSeIm: false };
            }
        }

        if (ev.ctrlKey && ev.altKey && ev.key.toLowerCase() === "o") {
            return { discardSeIm: !ev.shiftKey };
        }

        if (ev.ctrlKey && ev.shiftKey && !ev.altKey) {
            if (ev.key === "*" || ev.code === "NumpadMultiply") {
                return { keepEmptyLine: true, itemChar: "*" };
            }
            if (ev.code === "Minus") {
                return { keepEmptyLine: true, itemChar: "-" };
            }
            if (ev.key === "+" || ev.code === "Equal" || ev.code === "NumpadAdd") {
                return { keepEmptyLine: true, itemChar: "+" };
            }
        }

        if (ev.ctrlKey && ev.altKey && ev.key === ">") {
            return { keepEmptyLine: true, itemChar: "->" };
        }

        return null;
    }

    function reorderSelectedText(target, options) {
        const editor = getEditorElement(target);
        if (!editor) return false;

        const selection = window.getSelection();
        if (!selection || selection.isCollapsed || !editor.contains(selection.anchorNode) || !editor.contains(selection.focusNode)) {
            return false;
        }

        let finalText = reorderSelectedTextValue(
            selection.toString(),
            false,
            options.keepEmptyLine ?? false,
            options.itemChar ?? "",
            options.discardSeIm ?? true
        );
        if (finalText === null) return false;
        finalText = normalizeContentEditableInsertText(finalText);

        return replaceSelectedContentEditableText(editor, finalText);
    }

    function isAiRefineHotkey(ev) {
        const isKeyR = ev.code === "KeyR" || ev.key.toLowerCase() === "r" || ev.keyCode === 82;
        const hasAlt = ev.altKey || (isAiRefineAltDown && Date.now() - lastAiRefineAltDownAt < 2500);

        return hasAlt
            && !ev.ctrlKey
            && !ev.shiftKey
            && isKeyR;
    }

    function handleAiRefineHotkey(ev) {
        const isAltKey = ev.key === "Alt" || ev.code === "AltLeft" || ev.code === "AltRight";
        const isKeyR = ev.code === "KeyR" || ev.key.toLowerCase() === "r" || ev.keyCode === 82;
        const hasEditorContext = Boolean(getEditorElement(ev.target) || getActiveEditorElement());
        const shouldSuppressBrowserAltMenu = isAltKey
            && (hasEditorContext || hasAiRefineComparisonDialog() || isAiRefineSuppressingAltMenu);

        if (ev.type === "keydown" && isAltKey) {
            isAiRefineAltDown = true;
            isAiRefineSuppressingAltMenu = hasEditorContext || hasAiRefineComparisonDialog();
            lastAiRefineAltDownAt = Date.now();
        } else if (ev.type === "keyup" && isAltKey) {
            isAiRefineAltDown = false;
            if (shouldSuppressBrowserAltMenu) {
                ev.preventDefault();
                ev.stopPropagation();
                ev.stopImmediatePropagation();
                isAiRefineSuppressingAltMenu = false;
                if (hasAiRefineComparisonDialog()) {
                    const textareas = document.querySelectorAll("#ebm-webris-ai-compare-dialog textarea");
                    textareas[textareas.length - 1]?.focus({ preventScroll: true });
                }
                return true;
            }
        }

        if (ev.altKey || isAltKey || isKeyR) {
            logAiRefineDebug("hotkey event observed", {
                type: ev.type,
                key: ev.key,
                code: ev.code,
                keyCode: ev.keyCode,
                altKey: ev.altKey,
                trackedAltDown: isAiRefineAltDown,
                ctrlKey: ev.ctrlKey,
                shiftKey: ev.shiftKey,
                repeat: ev.repeat,
                target: getEventTargetDebug(ev.target),
                activeElement: getEventTargetDebug(document.activeElement)
            });
        }

        if (shouldSuppressBrowserAltMenu) {
            ev.preventDefault();
        }

        if (!isAiRefineHotkey(ev)) return false;
        if (ev.__webRisAiRefineHandled) return true;
        ev.__webRisAiRefineHandled = true;
        isAiRefineSuppressingAltMenu = true;

        logAiRefineDebug("Alt+R keydown", {
            key: ev.key,
            code: ev.code,
            target: getEventTargetDebug(ev.target),
            activeElement: getEventTargetDebug(document.activeElement)
        });

        ev.preventDefault();
        ev.stopPropagation();
        ev.stopImmediatePropagation();
        refineSelectedEditorText(getBestEditorEventTarget(ev.target));
        return true;
    }

    window.addEventListener('keydown', handleAiRefineHotkey, true);
    window.addEventListener('keyup', handleAiRefineHotkey, true);
    document.addEventListener('keydown', handleAiRefineHotkey, true);
    document.addEventListener('keyup', handleAiRefineHotkey, true);

    if (typeof GM_registerMenuCommand === "function") {
        GM_registerMenuCommand("WebRIS AI Refine selection/current line", () => {
            logAiRefineDebug("menu command invoked", {
                activeElement: getEventTargetDebug(document.activeElement)
            });
            refineSelectedEditorText(getBestEditorEventTarget(document.activeElement));
        });
    } else {
        console.warn("[WebRIS AI] GM_registerMenuCommand unavailable; loader metadata may need reload.");
    }

    document.addEventListener('keydown', (ev) => {
        let nextReportChkBox = document.querySelector("div.footer input");
        let prevReportTab = document.querySelector('div[style="height: 870px; width: 41.6667%; left: 0%; top: 60px;"] > div > div:nth-child(1) > div:nth-child(1) > div:nth-child(1)');
        let pathoReportTab = document.querySelector('div[style="height: 870px; width: 41.6667%; left: 0%; top: 60px;"] > div > div:nth-child(1) > div:nth-child(2) > div:nth-child(1)');
        let labReportTab = document.querySelector('div[style="height: 870px; width: 41.6667%; left: 0%; top: 60px;"] > div > div:nth-child(1) > div:nth-child(3) > div:nth-child(1)');
        let openHisBtn = document.querySelectorAll('div.footer div.pt-1 button')[2];
        let copyReportBtn = document.querySelector('button[title="複製內容F8"]');

        const reorderOptions = getReorderSelectedTextOptions(ev);
        if (reorderOptions) {
            if (reorderSelectedText(ev.target, reorderOptions)) {
                ev.preventDefault();
            }
            return;
        }

        if (ev.ctrlKey && ev.key === 'k') {
            const editor = getEditorElement(ev.target);
            if (editor) {
                ev.preventDefault();
                deleteEditorDomTextToLineEnd(editor);
                return;
            }
        }

        // Ctrl+X: cut selected text, or cut the current logical line if no text is selected.
        if (ev.ctrlKey && ev.key === 'x') {
            const editor = getEditorElement(ev.target);
            if (editor) {
                const line = getCurrentEditorDomLine(editor);
                if (line && isEmptyEditorDomLine(line)) {
                    ev.preventDefault();
                    navigator.clipboard?.writeText('\n').catch(() => {});
                    deleteEmptyEditorDomLine(editor, line);
                    return;
                }

                if (selectCurrentEditorDomLine(editor)) {
                    ev.preventDefault();
                    cutSelectedEditorDomText(editor);
                }
                return;
            }
        }

        if (handleAiRefineHotkey(ev)) {
            return;
        }

        // Alt+] or Alt+[: find next/prev report
        if (ev.altKey && (ev.key === ']' || ev.key === '[')) {
            console.log("Alt+] or Alt+[: find next/prev report");
            // check which tab is active
            const tabName = getTabName();
            if (tabName == "歷史報告") {
                //const currExamName = getCurrExamName();
                const currTr = document.querySelector('#frameHistory tr.text-secondary');
                const frameHistoryTr = getFrameHistoryTr();
                //console.log(`frameHistoryTr: ` + frameHistoryTr);
                if (frameHistoryTr.length) {
                    let i = [...frameHistoryTr].indexOf(currTr);
                    //console.log('curr index: ' + i + '; length: ' + frameHistoryTr.length);
                    i += (ev.key === ']') ? 1 : -1; // if no selection, i will be -1 + 1 = 0;
                    if (i >= frameHistoryTr.length) {
                        i = 0;
                    } else if (i < 0) {
                        i = frameHistoryTr.length - 1;
                    }
                    //console.log('after index: ' + i + '; length: ' + frameHistoryTr.length);
                    frameHistoryTr[i].click();
                    //const frameHistory = document.querySelector('#frameHistory');
                    //console.log('tr top: ' + frameHistoryTr[i].offsetTop + '; div top: ' + frameHistory.offsetTop + '; div height: ' + frameHistory.clientHeight + '; div scrollTop: ' + frameHistory.scrollTop);
                    scrollToSelectedItem(frameHistoryTr[i]);
                }
            } else if (tabName == "病理報告") {
                console.log("tab: 病理報告");
                const currTr = document.querySelector('div.table-wrp.block.max-h-48 tr.text-secondary');
                const pathoHistoryTr = getPathoHistoryTr();
                //console.log(`frameHistoryTr: ` + frameHistoryTr);
                if (pathoHistoryTr.length) {
                    let i = [...pathoHistoryTr].indexOf(currTr);
                    //console.log('curr index: ' + i + '; length: ' + frameHistoryTr.length);
                    i += (ev.key === ']') ? 1 : -1; // if no selection, i will be -1 + 1 = 0;
                    if (i >= pathoHistoryTr.length) {
                        i = 0;
                    } else if (i < 0) {
                        i = pathoHistoryTr.length - 1;
                    }
                    //console.log('after index: ' + i + '; length: ' + frameHistoryTr.length);
                    pathoHistoryTr[i].click();
                    //const frameHistory = document.querySelector('#frameHistory');
                    //console.log('tr top: ' + frameHistoryTr[i].offsetTop + '; div top: ' + frameHistory.offsetTop + '; div height: ' + frameHistory.clientHeight + '; div scrollTop: ' + frameHistory.scrollTop);
                    scrollToSelectedItem(pathoHistoryTr[i]);
                }
            }
        }

        // Ctrl+] or Ctrl+[: find next/prev similar report
        if (ev.ctrlKey && (ev.key === ']' || ev.key === '[')) {
            console.log("Ctrl+] or Ctrl+[: find next/prev similar report");
            // check which tab is active
            const tabName = getTabName();
            if (tabName == "歷史報告") {
                const currExamName = getCurrExamName();
                const currTr = document.querySelector('#frameHistory tr.text-secondary');
                const frameHistoryTr = getFrameHistoryTr();
                if (currExamName) {
                    let i = [...frameHistoryTr].indexOf(currTr);
                    let step;
                    if (ev.key === ']') {
                        i = (i > -1) ? i + 1 : 0;
                        step = 1;
                    } else {
                        i = (i > -1) ? i - 1 : frameHistoryTr.length - 1;
                        step = -1;
                    }
                    let foundSimilar = false;
                    for (; i >= 0 && i < frameHistoryTr.length; i+=step) {
                        const prevExamName = frameHistoryTr[i].children[4].textContent;
                        //console.log(prevExamName + ': ' + isRelatedReport(prevExamName, currExamName));
                        if (isRelatedReport(prevExamName, currExamName)) {
                            frameHistoryTr[i].click();
                            scrollToSelectedItem(frameHistoryTr[i]);
                            foundSimilar = true;
                            break;
                        }
                    }
                    if (!foundSimilar && currTr) {
                        scrollToSelectedItem(currTr);
                    }
                }
            } else if (tabName == "病理報告") {
                console.log("tab: 病理報告");
                const currTr = document.querySelector('div.table-wrp.block.max-h-48 tr.text-secondary');
                const pathoHistoryTr = getPathoHistoryTr();
                //console.log(`frameHistoryTr: ` + frameHistoryTr);
                if (pathoHistoryTr.length) {
                    let i = [...pathoHistoryTr].indexOf(currTr);
                    let step;
                    //i += (ev.key === ']') ? 1 : -1; // if no selection, i will be -1 + 1 = 0;
                    if (ev.key === ']') {
                        i = (i > -1) ? i + 1 : 0;
                        step = 1;
                    } else {
                        i = (i > -1) ? i - 1 : pathoHistoryTr.length - 1;
                        step = -1;
                    }
                    let foundSimilar = false;
                    for (; i >= 0 && i < pathoHistoryTr.length; i+=step) {
                        const pathoName = pathoHistoryTr[i].children[2].textContent;
                        //console.log(prevExamName + ': ' + isRelatedReport(prevExamName, currExamName));
                        if (pathoName.match(/^Surgical pathology Level|第四級外科病理/)) {
                            pathoHistoryTr[i].click();
                            scrollToSelectedItem(pathoHistoryTr[i]);
                            foundSimilar = true;
                            break;
                        }
                    }
                    if (!foundSimilar && currTr) {
                        scrollToSelectedItem(currTr);
                    }
                }
            }
        }

        // Ctrl+} or Ctrl+{: find next/prev similar report
        if (ev.ctrlKey && (ev.key === '}' || ev.key === '{')) {
            console.log("Ctrl+} or Ctrl+{: find next/prev similar report");
            const currExamName = getCurrExamName();
            const currTr = document.querySelector('#frameHistory tr.text-secondary');
            const frameHistoryTr = getFrameHistoryTr();
            if (currExamName) {
                let i = [...frameHistoryTr].indexOf(currTr);
                let step;
                if (ev.key === '}') {
                    i = (i > -1) ? i + 1 : 0;
                    step = 1;
                } else {
                    i = (i > -1) ? i - 1 : frameHistoryTr.length - 1;
                    step = -1;
                }
                let foundSimilar = false;
                for (; i >= 0 && i < frameHistoryTr.length; i+=step) {
                    const prevExamName = frameHistoryTr[i].children[4].textContent;
                    //console.log(prevExamName + ': ' + isRelatedReport(prevExamName, currExamName));
                    if (isSameExam(prevExamName, currExamName)) {
                        frameHistoryTr[i].click();
                        scrollToSelectedItem(frameHistoryTr[i]);
                        foundSimilar = true;
                        break;
                    }
                }
                if (!foundSimilar && currTr) {
                    scrollToSelectedItem(currTr);
                }
            }
        }

        // Ctrl+I: Insert indication
        if (ev.ctrlKey && ev.altKey && ev.key === 'i') {
            console.log("Ctrl+I: Insert indication");
            let soap_o = document.querySelector('div[style="height: 930px;"] > div:nth-child(3) textarea').value;
            let found_indication = soap_o.match(/檢查目的：(.+)/);
            if (found_indication) {
                insertContentEditableText(getEditorElement(ev.target), found_indication[1]);
            } else {
                let soap_a = document.querySelector('div[style="height: 930px;"] > div:nth-child(4) textarea').value;
                found_indication = soap_a.match(/【檢查目的】\n(.+?)\n/s);
                if (found_indication) {
                    insertContentEditableText(getEditorElement(ev.target), found_indication[1]);
                }
            }
        }

        // Alt+G: Toggle Lab Grouping
        if (ev.altKey && ev.key === 'g') {
            console.log("Alt+G: Toggle Lab Grouping");
            const sliderGrouping = document.querySelector('div[style="height: 870px; width: 41.6667%; left: 0%; top: 60px;"] span.slider');
            if (sliderGrouping) {
                sliderGrouping.click();
            }
            ev.preventDefault();
        }

        // Ctrl+G: Folding All Lab Grouping in 3rd and 2nd order
        if (ev.ctrlKey && ev.key === 'g') {
            console.log("Ctrl+G: Folding All Lab Grouping in 3rd and 2nd order");
            // 3rd order
            document.querySelectorAll('div[style="border: 0.5px solid rgb(215, 215, 215); border-radius: 6px;"] div.p-1 div.pointer').forEach(function(p){
                if (p.nextElementSibling) {
                    p.children[0].click();
                }
            });
            // 2nd order
            document.querySelectorAll('div[style="border: 0.5px solid rgb(215, 215, 215); border-radius: 6px;"] div.p-2 div.pointer').forEach(function(p){
                if (p.nextElementSibling) {
                    p.click();
                }
            });
            ev.preventDefault();
        }

        // Ctrl+1: Click Prev Report Tab
        if (ev.ctrlKey && ev.key === '1') {
            console.log("Ctrl+1: Click Prev Report Tab");
            prevReportTab.click();
            ev.preventDefault();
        }
        // Ctrl+2: Click Patho Report Tab
        if (ev.ctrlKey && ev.key === '2') {
            console.log("Ctrl+2: Click Patho Report Tab");
            pathoReportTab.click();
            ev.preventDefault();
        }
        // Ctrl+3: Click Lab Report Tab
        if (ev.ctrlKey && ev.key === '3') {
            console.log("Ctrl+3: Click Lab Report Tab");
            labReportTab.click();
            ev.preventDefault();
        }

        // Ctrl+4: Open Infinitt
        if (ev.ctrlKey && ev.key === '4') {
            console.log("Ctrl+4: Open Infinitt");
            const lid = "A60076"; // Infinitt userid
            const lpw = "A60076"; // Infinitt passwd
            const pid = getCurrPatId();
            const an = getCurrAccNo();
            const infinitt_url = (!isEdge ? "microsoft-edge:" : "") + `http://10.2.2.30/pkg_pacs/external_interface.aspx?LID=${lid}&LPW=${lpw}&AN=${an}&PID=${pid}`;
            window.open(infinitt_url, '_blank', 'height=100,width=200,screenX=0,toolbar=0,menubar=0,status=1');
            console.log(infinitt_url);
            ev.preventDefault();
        }

        // Ctrl+H: Open HIS
        if (ev.ctrlKey && ev.key === 'h') {
            console.log("Ctrl+H: Open HIS");
            openHisBtn.click();
            ev.preventDefault();
        }

        // Ctrl+R: Disable reload page
        if (ev.ctrlKey && ev.key === 'r') {
            console.log("Ctrl+R: Disable reload page");
            ev.preventDefault();
        }

        // Ctrl+0: Copy report without opening images
        // Remap hotkey to Ctrl+Esc in AHK
        if (ev.ctrlKey && ev.key === '0') {
            console.log("Ctrl+0: Copy report without opening images");
            copyReportBtn.click();

            // save prev report date into a var for further pasting
            const s = document.querySelector('tr.text-secondary td').textContent;
            prev_examdate = s.replace(/(\d{4})\/(\d{2})\/(\d{2})/, '$1-$2-$3');
            prev_examdate_pid = getCurrPatId();
            //console.log(prev_examdate);
            ev.preventDefault();
        }
        // Ctrl+9: Open previous images
        // Remap hotkey to Alt+Esc in AHK
        if (ev.ctrlKey && ev.key === '9') {
            console.log("Ctrl+9: Open previous images");

            // double click the prev report to open in PACS
            var dblClickEvent = new MouseEvent('dblclick', {
                'view': window,
                'bubbles': true,
                'cancelable': true
            });
            let selectedPrevReport = document.querySelector("#frameHistory tr.text-secondary");
            if (selectedPrevReport) {
                selectedPrevReport.dispatchEvent(dblClickEvent);
            }
            ev.preventDefault();
        }
        // Ctrl+Alt+P: Insert Pathology Date And Report
        // Remap hotkey to Alt+P in AHK
        if (ev.ctrlKey && ev.altKey && ev.key === 'p') {
            console.log("Ctrl+Alt+P: Insert Pathology Date And Report");
            const tabName = getTabName();
            if (tabName == "病理報告") {
                let pat_date = document.querySelector('tr.text-secondary td:nth-child(2)')?.textContent;
                if (pat_date) {
                    pat_date = pat_date.replace(/(\d{4})\/(\d{2})\/(\d{2})/, '$1-$2-$3');
                    const full_pat_report = document.querySelector('div[style="height: 870px; width: 41.6667%; left: 0%; top: 60px;"] textarea').value;
                    const pat_diagnosis = full_pat_report.replace(/.+檢驗後診斷名稱:\n(.+)\n\n報告內容.+$/s, '$1');
                    const formatted_str = `${pat_date}: ${pat_diagnosis}`;
                    insertContentEditableText(getEditorElement(ev.target), formatted_str);
                }
            } else if (tabName == "檢驗報告") {
                console.log('檢驗報告');
            }
        }
        // Ctrl+Alt+D: Insert Prev Exam Date Copied
        // Remap hotkey to Alt+D in AHK
        if (ev.ctrlKey && ev.altKey && ev.key === 'd') {
            console.log("Ctrl+Alt+D: Insert Prev Exam Date Copied");
            //navigator.clipboard.writeText(prev_examdate);
            const curr_pid = getCurrPatId();
            if (curr_pid === prev_examdate_pid) {
                insertContentEditableText(getEditorElement(ev.target), prev_examdate);
            }
        }

        // Ctrl+Alt+Shift+D: Insert Prev Exam Date Currently Selected
        // Remap hotkey to Alt+Shift+D in AHK
        if (ev.ctrlKey && ev.altKey && ev.key === 'D') {
            console.log("Ctrl+Alt+D: Insert Prev Exam Date Currently Selected");
            //navigator.clipboard.writeText(prev_examdate);
            const tds = document.querySelector('tr.text-secondary')?.querySelectorAll('td');
            const examdate = tds[0]?.textContent?.replace(/(\d{4})\/(\d{2})\/(\d{2})/, '$1-$2-$3');
            const modality = tds[2]?.textContent;
            if (examdate && modality) {
                insertContentEditableText(getEditorElement(ev.target), `${examdate} ${modality}`);
            }
        }


        const descCompareFn = (a, b) => (a > b ? -1 : 0);
        const spineCompareFn = (a, b) => {
            const spineOrder = ['Cervical', 'Thoracic', 'Lumbosacral'];
            const indexA = spineOrder.indexOf(a);
            const indexB = spineOrder.indexOf(b);
            return (indexA === -1 ? Infinity : indexA) - (indexB === -1 ? Infinity : indexB);
        };

        // Ctrl+Alt+F: Insert Exam Name and Contrast
        // Remap hotkey to Ctrl+Alt+Shift+E in AHK
        if (ev.ctrlKey && ev.altKey && ev.key === 'f') {
            console.log("Ctrl+Alt+F: Insert Exam Name and Contrast");
            const currExamName = getCurrExamName();
            if (currExamName) {
                let examStr = currExamName;
                const currContrast = getCurrContrast();
                if (currContrast && CONTRAST_STR.hasOwnProperty(currContrast)) {
                    examStr += CONTRAST_STR[currContrast];
                }
                // handle multiple parts CT exams
                if (isAbdCT(currExamName)) {
                    const frameHistoryUnfinishedTr = getFrameHistoryUnfinishedTr();
                    for (let i = 0; i < frameHistoryUnfinishedTr.length; i++) {
                        const unfinishedExamName = frameHistoryUnfinishedTr[i].children[4].textContent;
                        if (isChestCT(unfinishedExamName)) {
                            examStr = unfinishedExamName.replace(' CT', ', ') + examStr;
                            break;
                        }
                    }
                } else if (isChestCT(currExamName)) {
                    const frameHistoryUnfinishedTr = getFrameHistoryUnfinishedTr();
                    for (let i = 0; i < frameHistoryUnfinishedTr.length; i++) {
                        const unfinishedExamName = frameHistoryUnfinishedTr[i].children[4].textContent;
                        if (isAbdCT(unfinishedExamName)) {
                            examStr = examStr.replace(' CT', ', ' + unfinishedExamName);
                            break;
                        }
                    }
                } else if (isAortaCT(currExamName)) {
                    const frameHistoryUnfinishedTr = getFrameHistoryUnfinishedTr();
                    for (let i = 0; i < frameHistoryUnfinishedTr.length; i++) {
                        const unfinishedExamName = frameHistoryUnfinishedTr[i].children[4].textContent;
                        if (isAortaCT(unfinishedExamName)) {
                            const currPart = currExamName.match(/(\w+)\s+Aorta/)[1];
                            const unfinishedPart = unfinishedExamName.match(/(\w+)\s+Aorta/)[1];
                            const aortaPartList = [currPart, unfinishedPart].sort(descCompareFn).join(" and ");
                            examStr = examStr.replace(/\w+\s+(Aorta.+$)/, aortaPartList + " $1");
                            break;
                        }
                    }
                } else if (isMsk(currExamName)) {
                    const soap_s = [...document.querySelectorAll('span')].filter((el) => el.innerText.includes("病患主述"))[0].parentElement.nextSibling.value;
                    const foundLat = soap_s.match(/\b((l(eft|['`′]?t))|(r(ight|['`′]?t)))\b/i);
                    if (foundLat) {
                        const strLat = foundLat[1].charAt(0).toUpperCase() == 'L' ? 'Left ' : 'Right ';
                        examStr = strLat + examStr;
                    }
                } else if (isSpineCTorMRI(currExamName)) {
                    const frameHistoryUnfinishedTr = getFrameHistoryUnfinishedTr();
                    const [, currPart, currModality] = currExamName.match(/SPINE\s+(\w+)\s+(CT|MRI)/);
                    let spinePartList = [currPart];
                    let reByCurrModality = new RegExp("SPINE\\s+(\\w+)\\s+" + currModality);
                    for (let i = 0; i < frameHistoryUnfinishedTr.length; i++) {
                        const unfinishedExamName = frameHistoryUnfinishedTr[i].children[4].textContent;
                        if (isSpineCTorMRI(unfinishedExamName)) {
                            const foundUnfinished = unfinishedExamName.match(reByCurrModality);
                            if (foundUnfinished) {
                                const unfinishedPart = foundUnfinished[1];
                                spinePartList.push(unfinishedPart);
                            }
                        }
                    }
                    const spinePartStr = joinWithAnd(spinePartList.sort(spineCompareFn));
                    examStr = examStr.replace(/.+(CT|MRI)/, "SPINE " + spinePartStr + " $1");
                }
                insertContentEditableText(getEditorElement(ev.target), examStr + ":\n\n");
            }
        }

        // Ctrl+Alt+E: Insert Exam Name
        // Remap hotkey to Alt+E in AHK
        if (ev.ctrlKey && ev.altKey && ev.key === 'e') {
            console.log("Ctrl+Alt+E: Insert Exam Name");
            const currExamName = getCurrExamName();
            if (currExamName) {
                insertContentEditableText(getEditorElement(ev.target), currExamName + ":\n\n");
            }
        }

        // Select Btn Negative
        if (ev.altKey && ev.key === '1') {
            //console.log("a");
            const btn1 = document.querySelector('input[name="chfindcode"][value="1"]');
            if (btn1) {
                btn1.click();
            }
            console.log("Alt+1");
        }
        // Select Btn No Sig Finding
        if (ev.altKey && ev.key === '2') {
            //console.log("a");
            const btn2 = document.querySelector('input[name="chfindcode"][value="2"]');
            if (btn2) {
                btn2.click();
            }
            console.log("Alt+2");
        }
        // Select Btn Sig Finding
        if (ev.altKey && ev.key === '3') {
            //console.log("a");
            const btn3 = document.querySelector('input[name="chfindcode"][value="3"]');
            if (btn3) {
                btn3.click();
            }
            console.log("Alt+3");
        }
        // Select Btn Tumor
        if (ev.altKey && ev.key === '4') {
            //console.log("a");
            const btn4 = document.querySelector('input[name="chfindcode"][value="4"]');
            if (btn4) {
                btn4.click();
            }
            console.log("Alt+4");
        }

        // Alt+C: Save without next report
        if (ev.altKey && ev.key === 'c') {
            //console.log("a");
            if (nextReportChkBox.checked) {
                nextReportChkBox.click();
            }
            document.querySelector('div.footer button[title="F1"]').click();
            console.log("Alt+C");
        }

        // Ctrl+S: Save with next report
        if (ev.ctrlKey && ev.key === 's') {
            //console.log("a");
            if (!nextReportChkBox.checked) {
                nextReportChkBox.click();
            }
            document.querySelector('div.footer button[title="F1"]').click();
            console.log("Ctrl+S");
            ev.preventDefault();
        }
    });

    waitForKeyElements (
        '#frameHistory tbody tr td:nth-child(5)'
        , highlightSimilarExamAndClickLatest
    );

    var foundSimilarReportAccNo = '';
    function forceSameReport(examName) {
        return isSonoCDU(examName) || isSonoBreast(examName) || isSpineCTorMRI(examName) || isChestCT(examName)
        || needSamePlainFilm.includes(examName);
    }
    function isMultiPart(examName) {
        return isChestCT(examName) || isAbdCT(examName) || isAortaCT(examName)
        || isAngio(examName) || isSpineCTorMRI(examName);
    }
    function highlightSimilarExamAndClickLatest(jNode) {
        const currExamName = getCurrExamName();
        //console.log(jNode.first().siblings('td').first().text());
        if (currExamName) {
            const prevExamName = jNode[0].textContent;
            let foundReport = false;
            if (prevExamName === currExamName || prevExamName === currExamName.replace(/ /g, '')) {
                jNode.first().addClass('hl-same-report');
                foundReport = true;
            } else if (isSimilarExam(prevExamName, currExamName)) {
                //console.log("檢查項目: " + currExamName);
                //console.log(jNode.first());
                jNode.first().addClass('hl-sim-report');
                if (!forceSameReport(currExamName)) {
                    foundReport = true;
                }
            }
            // check if a multipart exam first
            if (isMultiPart(currExamName)) {
                const accNo = getCurrAccNo();
                const currExamDateStr = getCurrExamDate();
                const frameHistoryFinishedSameDateTr = getFrameHistoryFinishedSameDateTr(currExamDateStr);
                for (let i = 0; i < frameHistoryFinishedSameDateTr.length; i++) {
                    const prevExamName = frameHistoryFinishedSameDateTr[i].children[4].textContent;
                    if ((accNo != foundSimilarReportAccNo) && ((isChestCT(currExamName) && isAbdCT(prevExamName))
                                                               || (isChestCT(prevExamName) && isAbdCT(currExamName))
                                                               || (isAortaCT(prevExamName) && prevExamName != currExamName)
                                                               || (isAngio(currExamName) && isAngio(prevExamName))
                                                               || (isSpineCTorMRI(currExamName) && isSpineCTorMRI(prevExamName)))) {
                        console.log('Is Multi Part Exam. foundAccNo: ' + foundSimilarReportAccNo + ' accNo: ' + accNo);
                        foundSimilarReportAccNo = accNo;
                        setTimeout(() => {
                            frameHistoryFinishedSameDateTr[i].click();
                            scrollToSelectedItem(frameHistoryFinishedSameDateTr[i]);
                        }, 1500);
                    }
                }
            }
            if (foundReport) {
                const currExamDateStr = getCurrExamDate();
                const currExamTimeStr = getCurrExamTime();
                const currExamDateTime = new Date(currExamDateStr + ' ' + currExamTimeStr);
                const prevExamTr = jNode.first().parent();
                const prevExamDateStr = prevExamTr.children().eq(0).text().split('*')[0];
                const prevExamTimeStr = prevExamTr.children().eq(1).text();
                const prevExamDateTime = new Date(prevExamDateStr + ' ' + prevExamTimeStr);
                if (currExamDateTime > prevExamDateTime) {
                    const accNo = getCurrAccNo();
                    if (accNo != foundSimilarReportAccNo) {
                        console.log(prevExamDateTime + ': ' + jNode.first().text());
                        foundSimilarReportAccNo = accNo;

                        // Delayed for 1 second
                        setTimeout(() => {
                            console.log("first run for this exam: " + accNo);
                            jNode.first().click();

                            // scroll to selected report
                            const selectedTr = jNode.first().parent().get(0);
                            scrollToSelectedItem(selectedTr);
                        }, 1500);

                    } else {
                        //console.log("not first run: " + prevExamDateTime + ': ' + prevExamName);
                    }
                }
            }
        }
    }

    const needSamePlainFilm = ['Whole spine AP', 'Whole spine lateral'];

    const simExam = {
        // plain film
        'Chest': ['CHEST', 'Chest AP Portable', 'Chest PA+lateral(R)', 'Chest PA+lateral(L)', 'CHEST PA+Lat(L.R)',
                  '【限IDS申報】Chest PA(Telemedicine)', '【限IDS申報】山地鄉胸部X光檢查'],
        'Chest-Study': ['Chest', 'CHEST', 'Chest AP Portable', 'Chest PA+lateral(R)', 'Chest PA+lateral(L)',
                        'CHEST PA+Lat(L.R)', 'Lung Low Dose CT-Study', '【限IDS申報】Chest PA(Telemedicine)',
                        '【限IDS申報】山地鄉胸部X光檢查'],
        'Chest PA+lateral(L)': ['Chest', 'CHEST', 'Chest AP Portable', '【限IDS申報】Chest PA(Telemedicine)',
                                '【限IDS申報】山地鄉胸部X光檢查'],
        'Chest PA+lateral(R)': ['Chest', 'CHEST', 'Chest AP Portable', '【限IDS申報】Chest PA(Telemedicine)',
                                '【限IDS申報】山地鄉胸部X光檢查'],
        'Chest AP Portable': ['Chest', 'CHEST', '【限IDS申報】Chest PA(Telemedicine)', '【限IDS申報】山地鄉胸部X光檢查'],
        'KUB': ['ABDOMEN KUB', 'KUB Portable'],
        'KUB Portable': ['ABDOMEN KUB', 'KUB'],
        'Abdomen standing': ['KUB', 'ABDOMEN KUB', 'KUB Portable'],

        'C spine dynamic': ['C spine AP', 'C spine AP+ lateral'],
        'C spine AP': ['C spine dynamic', 'C spine AP+ lateral'],
        'C spine AP+ lateral': ['C spine dynamic', 'C spine AP'],
        'T spine AP+lateral standing': ['T spine AP+lateral', 'TL spine AP+lateral', 'TL spine AP+lateral standing', 'T-L spine AP+Lat'],
        'T spine AP+lateral': ['TL spine AP+lateral', 'TL spine AP+lateral standing', 'T-L spine AP+Lat'],
        'TL spine AP+lateral standing': ['T spine AP+lateral', 'TL spine AP+lateral', 'T-L spine AP+Lat'],
        'TL spine AP+lateral': ['TL spine AP+lateral standing', 'T-L spine AP+Lat',
                                'LS spine lateral standing', 'LS spine AP+lateral'],
        'TL spine lateral': ['TL spine AP+lateral', 'TL spine AP+lateral standing'],
        'LS spine AP+lateral': [
            'LS spine AP+lateral standing', 'LS spine AP Lat', 'LS spine dynamic', 'LS-spine dynamic',
            'LS spine lateral', 'T-L spine AP+Lat', 'TL spine AP+lateral'
        ],
        'LS spine AP+lateral standing': [
            'LS spine AP+lateral', 'LS spine AP Lat', 'LS spine dynamic', 'LS spine lateral standing',
            'LS spine lateral', 'T-L spine AP+Lat', 'TL spine AP+lateral'
        ],
        'LS spine dynamic': ['LS-spine dynamic', 'LS spine AP+lateral', 'LS spine AP+lateral standing',
                             'LS spine AP', 'LS spine lateral', 'LS spine lateral standing'],
        'LS spine AP': ['LS-spine dynamic', 'LS spine AP+lateral', 'LS spine dynamic', 'LS spine lateral'],
        'LS spine lateral': ['LS-spine dynamic', 'LS spine AP+lateral', 'LS spine dynamic'],
        'LS spine lateral standing': ['LS-spine dynamic', 'LS spine dynamic', 'LS spine AP+lateral'],
        'Coccyx AP+lateral': ['Coccyx lateral'],
        'Whole spine lateral': ['Whole spine AP'],
        'Whole spine AP': ['Whole spine lateral'],

        'Shoulder AP(R)': ['Shoulder internal+external(R)', 'Shoulder axial(R)', 'Scapula Y view(R)',
                           'Scapula AP+Y view(R)', 'Shoulder AP(both)'],
        'Shoulder AP(L)': ['Shoulder internal+external(L)', 'Shoulder axial(L)', 'Scapula Y view(L)',
                           'Scapula AP+Y view(L)', 'Shoulder AP(both)'],
        'Shoulder internal+external(R)': ['Shoulder AP(R)'],
        'Shoulder internal+external(L)': ['Shoulder AP(L)'],
        'Elbow oblique(R)': ['Elbow AP+lateral(R)'],
        'Elbow AP+lateral(R)': ['Elbow oblique(R)'],
        'Elbow oblique(L)': ['Elbow AP+lateral(L)'],
        'Elbow AP+lateral(L)': ['Elbow oblique(L)'],
        'Wrist PA+lateral(R)': ['Wrist PA+lateral(both)'],
        'Wrist PA+lateral(L)': ['Wrist PA+lateral(both)'],
        'Wrist PA ulnar deviation(R)': ['Wrist PA+lateral(R)'],
        'Wrist PA ulnar deviation(L)': ['Wrist PA+lateral(L)'],
        'Hand PA(R)': ['Hand PA+oblique(R)', 'Hand PA+lateral(R)'],
        'Hand PA(L)': ['Hand PA+oblique(L)', 'Hand PA+lateral(L)'],
        'Hand PA+lateral(R)': ['Hand PA+oblique(R)'],
        'Hand PA+lateral(L)': ['Hand PA+oblique(L)'],
        'Hand PA+oblique(R)': ['Hand PA+lateral(R)'],
        'Hand PA+oblique(L)': ['Hand PA+lateral(L)'],
        'Pelvis THR': ['Hip lateral(R)', 'Hip lateral(L)', 'KUB'],
        'Hip lateral(R)': ['Pelvis THR'],
        'Hip lateral(L)': ['Pelvis THR'],
        'Hip AP+lateral(R)': ['Pelvis THR', 'Hip lateral(R)'],
        'Hip AP+lateral(L)': ['Pelvis THR', 'Hip lateral(L)'],
        'Femur AP(R)': ['Femur AP+lateral(R)'],
        'Femur AP(L)': ['Femur AP+lateral(L)'],
        'Femur AP+lateral(R)': ['Femur AP(R)'],
        'Femur AP+lateral(L)': ['Femur AP(L)'],
        'Knee AP+lateral(R)': ['Knee AP+lateral standing(R)', 'JOINT Knee CT'],
        'Knee AP+lateral(L)': ['Knee AP+lateral standing(L)', 'JOINT Knee CT'],
        'Knee AP+lateral standing(R)': ['Knee AP+lateral(R)', 'JOINT Knee CT'],
        'Knee AP+lateral standing(L)': ['Knee AP+lateral(L)', 'JOINT Knee CT'],
        'Foot AP+lateral(R)': ['Foot lateral(R)', 'Foot AP+oblique(R)'],
        'Foot AP+lateral(L)': ['Foot lateral(L)', 'Foot AP+oblique(L)'],
        'Foot AP+oblique(R)': ['Foot lateral(R)', 'Foot AP+lateral(R)'],
        'Foot AP+oblique(L)': ['Foot lateral(L)', 'Foot AP+lateral(L)'],
        'Foot lateral standing(R)': ['Foot AP+oblique(R)', 'Foot lateral(R)', 'Foot AP+lateral(R)'],
        'Foot lateral standing(L)': ['Foot AP+oblique(L)', 'Foot lateral(L)', 'Foot AP+lateral(L)'],

        // ultrasound
        'Sono Abdomen': ['腹部超音波，追蹤性', 'Abdominal ultrasound, for follow-up', 'Abdomen sono'],
        'Abdominal ultrasound, for follow-up': ['腹部超音波，追蹤性', 'Sono Abdomen', 'Abdomen sono'],
        'Sono CDU  Kideny': ['Abdominal ultrasound, for follow-up', 'Sono Abdomen', 'Abdomen sono'],
        'Sono Breasts': ['SonoBreasts', 'Breasts sono',
                         'Mammography L&R', 'Mammography L&R(HPA)限45歲以上', 'Mammography L&R(HPA)', 'MAMMOGRAPHY L&R'],

        // CT
        'Abdomen to Pelvis CT': ['Abdomen  Liver Triple Phase CT', 'Abdomen  Liver 4 Phase CT', 'ABDOMEN Liver MRI',
                                 'Colon cancer (Abdomen & Pelvis)-CT'],
        'Abdomen  Liver Triple Phase CT': ['Abdomen to Pelvis CT', 'Abdomen  Liver 4 Phase CT',
                                           'Colon cancer (Abdomen & Pelvis)-CT'],
        'Abdomen  Liver 4 Phase CT': ['Abdomen to Pelvis CT', 'Abdomen  Liver Triple Phase CT', 'ABDOMEN Liver MRI',
                                      'Sono Abdomen', 'Colon cancer (Abdomen & Pelvis)-CT'],
        'Abdomen pancreas dual phase CT': [
            'Abdomen  Pancreas Dual Phase  CT', 'Abdomen to Pelvis CT', 'Abdomen  Liver 4 Phase CT',
            'Abdomen  Liver Triple Phase CT',
        ],
        'Colon cancer (Abdomen & Pelvis)-CT': [
            'Abdomen to Pelvis CT', 'Abdomen  Liver Triple Phase CT', 'Abdomen  Liver 4 Phase CT'
        ],
        'Gastric cancer staging(Hydro CT)': [
            'Abdomen to Pelvis CT',
        ],
        'ABDOMEN  Lymph  Nodes   CT': [
            'Abdomen to Pelvis CT', 'PELVIS  Uterus∕Ovaries   CT',
        ],
        'Chest CT': [
            'Lung cancer (Chest & Upper abdomen)-CT', 'Lung Low Dose CT', 'Lung-Low Dose CT',
            'Chest Pulmonary Arteries CT', 'HRCT-Lung',
            'Chest', 'CHEST', 'Chest AP Portable', 'Chest PA+lateral(L)',
        ],
        'Lung cancer (Chest & Upper abdomen)-CT': [
            'Chest CT', 'Lung Low Dose CT', 'Lung-Low Dose CT', 'Chest Pulmonary Arteries CT', 'HRCT-Lung',
        ],
        'HRCT-Lung': [
            'Chest CT', 'Lung Low Dose CT', 'Lung-Low Dose CT', 'Chest Pulmonary Arteries CT',
            'Lung cancer (Chest & Upper abdomen)-CT',
        ],
        'JOINT Shoulder CT': ['Shoulder internal+external(R)', 'Shoulder AP(R)',
                              'Shoulder internal+external(L)', 'Shoulder AP(L)',],
        'JOINT ELBOW CT': ['Elbow AP+lateral(R)', 'Elbow AP+lateral(L)'],
        'PELVIS  Hip  CT': ['Pelvis THR'],
        'JOINT Ankle  CT': ['Ankle AP+lateral(R)', 'Ankle AP+lateral(L)'],
        'SPINE  Cervical  CT': ['SPINE Cervical MRI', 'C spine AP+ lateral', 'C spine dynamic', 'C spine AP'],
        'SPINE Lumbosacral CT': ['LS spine dynamic', 'LS spine AP', 'LS spine AP+lateral standing', 'LS spine AP+lateral',
                                 'LS spine lateral', 'TL spine AP+lateral standing', 'TL spine AP+lateral',
                                 'SPINE Lumbar  MRI', 'SPINE Lumbosacral MRI'],

        // MRI
        'SPINE Lumbosacral MRI': ['LS spine dynamic', 'LS spine AP', 'LS spine AP+lateral standing', 'LS spine AP+lateral',
                                  'LS spine lateral', 'TL spine AP+lateral standing', 'TL spine AP+lateral',
                                  'SPINE Lumbar  MRI'],
        'SPINE Lumbar  MRI': ['LS spine dynamic', 'LS spine AP', 'LS spine AP+lateral standing', 'LS spine AP+lateral',
                              'LS spine lateral', 'TL spine AP+lateral standing', 'TL spine AP+lateral',
                              'SPINE Lumbosacral MRI'],
        'SPINE Cervical MRI': ['SPINE  Cervical  CT', 'C spine AP+ lateral', 'C spine dynamic', 'C spine AP'],

        'JOINT Knee MRI': ['Knee AP+lateral standing(both)', 'Merchant view(both)',
                           'Knee AP+lateral standing(R)', 'Knee AP+lateral standing(L)',
                           'Knee AP+lateral(R)', 'Knee AP+lateral(L)'],
        'JOINT Shoulder MRI': [
            'Shoulder internal+external(L)', 'Shoulder internal+external(R)', 'Shoulder internal+external(both)',
            'Shoulder AP(both)', 'Shoulder axial(both)', 'Scapula Y view(both)',
        ],
        'JOINT Ankle MRI': ['Ankle stress view(R)'],
        'JOINT Wrist MRI': ['Wrist PA+lateral(R)', 'Wrist PA+lateral(L)'],

        'ABDOMEN Liver MRI': ['Abdomen  Liver 4 Phase CT', 'Abdomen  Liver Triple Phase CT'],
        'Liver (Primovist) MRI': ['Abdomen liver(Primovist) MRI', 'ABDOMEN Liver MRI',
                                  'Abdomen  Liver 4 Phase CT', 'Abdomen  Liver Triple Phase CT'],
        'Colon cancer (Abdomen & Pelvis) MRI': ['Colon cancer (Abdomen & Pelvis)-CT'],
        'PELVIS Prostate MRI': ['Prostate cancer (Abdomen & Pelvis) MRI'],
        'Prostate cancer (Abdomen & Pelvis) MRI': ['PELVIS Prostate MRI'],

        // Breast
        'CHEST Breast MRI': ['Sono Breasts', 'SonoBreasts', 'Breasts sono'],

        // Angio
        'Lipiodol T.A.E.(trans-arterial embolization)-Lipiodol': ['血管阻塞術'],
        'P.T.C.': ['P.T.C.D.'],
        'P.T.C.D.': ['P.T.C.'],
    };

    /* highlight gender */
    waitForKeyElements (
        'div.main div[style="width: 99%;"] div.pt-1 div.grow-0.h-10:nth-child(8) input'
        , colorizeGender
    );

    function colorizeGender(jNode) {
        //console.log(jNode);
        console.log('Gender: ' + jNode.first().val());
        const gender = jNode.first().val();
        const male_color = '#00A8E8';
        const female_color = '#FF4081';
        const color = (gender == 'M' ? male_color : female_color);
        // set style will overwrite the class in Stylus
        const style_str = `color: ${color} !important; max-width: 3.5em; text-align: center;`;
        jNode.first().attr('style', style_str);
    }

    /* highlight date by day */
    waitForKeyElements (
        "main table > tbody > tr > td:nth-child(6)"
        , colorizeExamDate
    );

    function colorizeExamDate(jNode) {
        //console.log(jNode);
        //console.log(jNode.val());
        const found_date = jNode[0].textContent.match(/\d{4}\/\d{2}\/(\d{2})/);
        if (found_date) {
            jNode.first().addClass('hl-examdate-' + (found_date[1] % 7));
        }
    }

    /* highlight origin */
    waitForKeyElements (
        'main table > tbody[style="min-height: 24vh;"] > tr > td:nth-child(2)'
        , colorizeExamOrigin
    );

    waitForKeyElements (
        'div.main div[style="width: 99%;"] div.pt-1 div.grow-0.h-10:nth-child(12) input'
        , colorizeExamOrigin
    );

    function colorizeExamOrigin(jNode) {
        //console.log(jNode.get(0).nodeName);
        //console.log(jNode[0].nodeType);
        //console.log(jNode.val());
        let examOriginStr;
        switch (jNode.get(0).nodeName) {
            case 'TD':
                examOriginStr = jNode[0].textContent;
                switch (examOriginStr) {
                    case '住院':
                        jNode.first().addClass('hl-examorigin-adm');
                        break;
                    case '急診':
                        jNode.first().addClass('hl-examorigin-er');
                        break;
                    case '健檢':
                        jNode.first().addClass('hl-examorigin-hc');
                        break;
                    case '門診':
                        jNode.first().addClass('hl-examorigin-opd');
                        break;
                    default:
                }
                break;
            case 'INPUT':
                console.log('ExamOrigin: ' + jNode[0].value);
                examOriginStr = jNode[0].value;
                if (examOriginStr.match(/^住院/)) {
                    jNode.first().attr('style', 'color: #be99ff !important');
                } else if (examOriginStr.match(/^急診/)) {
                    jNode.first().attr('style', 'color: #ff62ac !important');
                } else if (examOriginStr == '健檢') {
                    jNode.first().attr('style', 'color: #f0f0bb !important');
                } else if (examOriginStr == '門診') {
                    jNode.first().attr('style', 'color: #a9f0aa !important');
                }
                break;
            default:
        }
    }

    /* highlight patient name */
    waitForKeyElements (
        "main table > tbody > tr > td:nth-child(5)"
        , colorizeBundledExam
    );

    function colorizeBundledExam(jNode) {
        const trimmedAccNo = jNode.first().text().slice(1, -2);
        //console.log(jNode.first().text());
        //console.log(jNode.val());
        //const trimmedAccNo = jNode[0].textContent.slice(0, -2);
        //console.log(trimmedAccNo);
        //const prevTr = jNode.first().parent().prev();
        const nextTr = jNode.first().parent().next('tr');
        if (nextTr && nextTr.children().eq(4)) {
            const nextTrTrimmedAccno = nextTr.children().eq(4).text().slice(1, -2);
            //console.log(nextTrTrimmedAccno);
            if (trimmedAccNo === nextTrTrimmedAccno) {
                const hlClass = 'hl-bundledexam-' + (parseInt(trimmedAccNo) % 3);
                jNode.first().parent().children().eq(10).addClass(hlClass); // highlight exam name
                nextTr.children().eq(10).addClass(hlClass);
            }
        }
    }

    /* darken not completed reports */
    waitForKeyElements (
        "#frameHistory tbody tr td:nth-child(1)"
        , darkenIncompletedReport
    );

    function darkenIncompletedReport(jNode) {
        //console.log(jNode);
        //console.log(jNode.val());
        if (jNode[0].textContent.match(/\*$/)) {
            //const reportDrTd = jNode.next().next().next();
            //reportDrTd.addClass('dk-incompleted-report');
            jNode.addClass('dk-incompleted-report');
            jNode.siblings().addClass('dk-incompleted-report');
            //console.log(reportDrTd);
        }
    }

    /* highlight recent 1 month patho reports */
    waitForKeyElements (
        "div.table-wrp.block.max-h-48 tbody tr td:nth-child(2)"
        , hightlightRecentPathoReport
    );

    function hightlightRecentPathoReport(jNode) {
        //console.log(jNode);
        //console.log(jNode.val());
        const inputDate = new Date(jNode[0].textContent);
        if (isNaN(inputDate)) return false; // 確保輸入是有效的日期
        const currentDate = new Date();
        const oneMonthAgo = new Date();
        oneMonthAgo.setMonth(currentDate.getMonth() - 1);
        if (inputDate >= oneMonthAgo && inputDate <= currentDate) {
            jNode.addClass('hl-recent-patho-report');
            //console.log(reformattedExamDate);
        }
    }

    /* highlight important patho reports */
    waitForKeyElements (
        "div.table-wrp.block.max-h-48 tbody tr td:nth-child(3)"
        , hightlightImportantPathoReport
    );

    function hightlightImportantPathoReport(jNode) {
        //console.log(jNode);
        //console.log(jNode.val());
        const pathoName = jNode[0].textContent;
        if (pathoName.match(/^Surgical pathology Level|第四級外科病理/)) {
            jNode.addClass('hl-important-patho-report');
            //console.log(reformattedExamDate);
        }
    }

    /*
     * No need to reformat date string after upgrading to 1.0.51
     *

    waitForKeyElements (
        "#app > main > main > div > div.flex-auto > div.px-5 > div.overflow-auto > table > tbody > tr > td:nth-child(6)"
        , reformatExamDate
    );
    waitForKeyElements (
        "#frameHistory tbody tr td:nth-child(1)"
        , reformatExamDate
    );

    function reformatExamDate(jNode) {
        //console.log(jNode);
        //console.log(jNode.val());
        if (jNode.is("input")) {
            const reformattedExamDate = jNode.val().replace(/(\d{4})(\d{2})(\d{2})/, '$1-$2-$3');
            //console.log("input: " + reformattedExamDate);
            jNode.val(reformattedExamDate);
        } else {
            const reformattedExamDate = jNode[0].textContent.replace(/(\d{4})(\d{2})(\d{2})/, '$1-$2-$3');
            jNode[0].textContent = reformattedExamDate;
            //console.log(reformattedExamDate);
        }
    }

    waitForKeyElements (
        "#app > main > main > div > div.flex-auto > div.px-5 > div.overflow-auto > table > tbody > tr > td:nth-child(7)"
        , reformatExamTime
    );
    waitForKeyElements (
        "#frameHistory tbody tr td:nth-child(2)"
        , reformatExamTime
    );

    function reformatExamTime(jNode) {
        jNode[0].textContent = jNode[0].textContent.replace(/(.{2})(.{2})(.{2})/, '$1:$2:$3');
    }

    waitForKeyElements (
        "#app > main > main > div > div.flex-auto > main > div > div.main > div > div > div:nth-child(2) > div > div:nth-child(3) > div.table-wrp.block.max-h-48 > table > tbody > tr > td:nth-child(2)"
        , reformatPathoDate
    );

    function reformatPathoDate(jNode) {
        const foundPathoDate = jNode[0].textContent.match(/^(\d{3})(\d{2})(\d{2})$/);
        if (foundPathoDate) {
            const newDateStr = (parseInt(foundPathoDate[1]) + 1911).toString() + '-' + foundPathoDate[2] + '-' + foundPathoDate[3];
            if (Date.parse(newDateStr)) {
                jNode[0].textContent = newDateStr;
            }
        }
    }

    */
})();
