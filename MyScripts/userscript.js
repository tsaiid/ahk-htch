// ==UserScript==
// @name         Enhanced WebRIS
// @namespace    http://tsai.it/
// @version      2024-03-04
// @description  try to take over the world!
// @author       You
// @match        http://10.2.2.160:8080/
// @match        http://10.2.2.160:8080/risworklist/*
// @match        http://10.2.2.160:8080/verworklist/*
// @icon         https://www.google.com/s2/favicons?sz=64&domain=2.160
// @grant        none
// ==/UserScript==

(function() {
    'use strict';

    let userAgent = navigator.userAgent;
    let isEdge = /Edg/.test(userAgent);
    let prev_examdate = '';

    const CONTRAST_STR = {
        X5A: " without contrast medium",
        X5B: " with contrast medium",
        X5C: " without and with contrast medium",
        X6A: " without contrast medium",
        X6B: " with contrast medium",
        X6C: " without and with contrast medium"
    };

    document.addEventListener('keydown', (ev) => {
        let nextReportChkBox = document.querySelector("div.footer input");
        let prevReportTab = document.querySelector("#app > main > main > div > div.flex-auto > main > div > div.main > div > div > div:nth-child(2) > div > div:nth-child(1) > div:nth-child(1) > div:nth-child(1)");
        let pathoReportTab = document.querySelector("#app > main > main > div > div.flex-auto > main > div > div.main > div > div > div:nth-child(2) > div > div:nth-child(1) > div:nth-child(2) > div:nth-child(1)");
        let labReportTab = document.querySelector("#app > main > main > div > div.flex-auto > main > div > div.main > div > div > div:nth-child(2) > div > div:nth-child(1) > div:nth-child(3) > div:nth-child(1)");
        let openHisBtn = document.querySelectorAll('div.footer div.pt-1 button')[2];
        let copyReportBtn = document.querySelector('#app > main > main > div > div.flex-auto > main > div > div.main > div > div > div:nth-child(2) > div > div:nth-child(3) > div.flex.items-center > button');

        // Ctrl+1: Click Prev Report Tab
        if (ev.ctrlKey && ev.key === '1') {
            console.log("Ctrl+1: Click Prev Report Tab");
            prevReportTab.click();
        }
        // Ctrl+2: Click Patho Report Tab
        if (ev.ctrlKey && ev.key === '2') {
            console.log("Ctrl+2: Click Patho Report Tab");
            pathoReportTab.click();
        }
        // Ctrl+3: Click Lab Report Tab
        if (ev.ctrlKey && ev.key === '3') {
            console.log("Ctrl+3: Click Lab Report Tab");
            labReportTab.click();
        }

        // Ctrl+4: Open Infinitt
        if (ev.ctrlKey && ev.key === '4') {
            console.log("Ctrl+4: Open Infinitt");
            const lid = "A60076"; // Infinitt userid
            const lpw = "A60076"; // Infinitt passwd
            const pid = document.querySelector('input[title="病歷號碼"]').value;
            const an = document.querySelector('input[title="檢查單號"]').value;
            const infinitt_url = (!isEdge ? "microsoft-edge:" : "") + `http://10.2.2.30/pkg_pacs/external_interface.aspx?LID=${lid}&LPW=${lpw}&AN=${an}&PID=${pid}`;
            window.open(infinitt_url);
            console.log(infinitt_url);
        }

        // Ctrl+H: Open HIS
        if (ev.ctrlKey && ev.key === 'h') {
            console.log("Ctrl+H: Open HIS");
            openHisBtn.click();
        }

        // Ctrl+0: Copy report
        // Remap hotkey to Ctrl+Esc in AHK
        if (ev.ctrlKey && ev.key === '0') {
            console.log("Ctrl+0: Copy report");
            copyReportBtn.click();
            // save prev report date into a var for further pasting
            const s = document.querySelector('tr.text-secondary td').textContent;
            prev_examdate = `${s.substring(0, 4)}-${s.substring(4, 6)}-${s.substring(6)}`;
            console.log(prev_examdate);
        }
        // Ctrl+Alt+D: Insert Prev Exam Date
        // Remap hotkey to Alt+D in AHK
        if (ev.ctrlKey && ev.altKey && ev.key === 'd') {
            console.log("Ctrl+Alt+D: Insert Prev Exam Date");
            //navigator.clipboard.writeText(prev_examdate);
            document.execCommand('insertText', false, prev_examdate);
        }
        // Ctrl+Alt+F: Insert Exam Name and Contrast
        // Remap hotkey to Ctrl+Alt+Shift+E in AHK
        if (ev.ctrlKey && ev.altKey && ev.key === 'f') {
            console.log("Ctrl+Alt+F: Insert Exam Name and Contrast");
            const i1 = document.querySelector('input[title="檢查項目"]');
            if (i1) {
                let examname = i1.value;
                const i2 = document.querySelector('input[title="顯影劑"]');
                if (i2 && i2.value) {
                    examname += CONTRAST_STR[i2.value];
                }
                document.execCommand('insertText', false, examname + ":\n\n");
            }
        }
        // Ctrl+Alt+E: Insert Exam Name
        // Remap hotkey to Alt+E in AHK
        if (ev.ctrlKey && ev.altKey && ev.key === 'e') {
            console.log("Ctrl+Alt+E: Insert Exam Name");
            const i = document.querySelector('input[title="檢查項目"]');
            if (i) {
                document.execCommand('insertText', false, i.value + ":\n\n");
            }
        }

        // Select Btn Negative
        if (ev.altKey && ev.key === '1') {
            //console.log("a");
            const btn1 = document.querySelector('div.main > div > div > div:nth-child(6) > div > div.flex.items-center.flex-wrap.text-16 > label:nth-child(1) > input');
            if (btn1) {
                btn1.click();
            }
            console.log("Alt+1");
        }
        // Select Btn No Sig Finding
        if (ev.altKey && ev.key === '2') {
            //console.log("a");
            const btn2 = document.querySelector('div.main > div > div > div:nth-child(6) > div > div.flex.items-center.flex-wrap.text-16 > label:nth-child(2) > input');
            if (btn2) {
                btn2.click();
            }
            console.log("Alt+2");
        }
        // Select Btn Sig Finding
        if (ev.altKey && ev.key === '3') {
            //console.log("a");
            const btn3 = document.querySelector('div.main > div > div > div:nth-child(6) > div > div.flex.items-center.flex-wrap.text-16 > label:nth-child(3) > input');
            if (btn3) {
                btn3.click();
            }
            console.log("Alt+3");
        }
        // Select Btn Tumor
        if (ev.altKey && ev.key === '4') {
            //console.log("a");
            const btn4 = document.querySelector('div.main > div > div > div:nth-child(6) > div > div.flex.items-center.flex-wrap.text-16 > label:nth-child(4) > input');
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
})();