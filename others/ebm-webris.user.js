// ==UserScript==
// @name         Enhanced WebRIS
// @namespace    http://tsai.it/
// @version      20241212.1
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
// @grant        none
// ==/UserScript==

(function() {
    'use strict';

    let userAgent = navigator.userAgent;
    let isEdge = /Edg/.test(userAgent);
    let prev_examdate = '';
    let prev_examdate_pid = '';

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
                    return input.value;
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
        const frameHistory = document.querySelector('#frameHistory');
        //console.log('tr top: ' + frameHistoryTr[i].offsetTop + '; div top: ' + frameHistory.offsetTop + '; div height: ' + frameHistory.clientHeight + '; div scrollTop: ' + frameHistory.scrollTop);
        if (selectedTr.offsetTop + selectedTr.clientHeight > frameHistory.scrollTop + frameHistory.clientHeight) {
            frameHistory.scrollTop = selectedTr.offsetTop;
        } else if (selectedTr.offsetTop < frameHistory.scrollTop) {
            frameHistory.scrollTop = (selectedTr.offsetTop + selectedTr.clientHeight < frameHistory.clientHeight)
                ? 0
                : selectedTr.offsetTop;
        }
    }

    function isAbdCT(examName) {
        const abdCTList = ['Abdomen to Pelvis CT', 'Abdomen  Liver Triple Phase CT', 'Abdomen  Liver 4 Phase CT',
                           'ABDOMEN  Lymph  Nodes   CT', 'Colon cancer (Abdomen & Pelvis)-CT'];
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
        return examName.match(/JOINT|Leg|Hand-CT/);
    }
    function isAngio(examName) {
        const angioList = ['Celiac a three vessel', 'Lipiodol T.A.E.(trans-arterial embolization)-Lipiodol',
                           'Percutaneous placement of ureter stent', 'Percutaneous retrieval of ureteral stent',
                           'PCN', 'Percutaneous ureteroplasty', 'PCN revision'];
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

    document.addEventListener('keydown', (ev) => {
        let nextReportChkBox = document.querySelector("div.footer input");
        let prevReportTab = document.querySelector('div[style="height: 870px; width: 41.6667%; left: 0%; top: 60px;"] > div > div:nth-child(1) > div:nth-child(1) > div:nth-child(1)');
        let pathoReportTab = document.querySelector('div[style="height: 870px; width: 41.6667%; left: 0%; top: 60px;"] > div > div:nth-child(1) > div:nth-child(2) > div:nth-child(1)');
        let labReportTab = document.querySelector('div[style="height: 870px; width: 41.6667%; left: 0%; top: 60px;"] > div > div:nth-child(1) > div:nth-child(3) > div:nth-child(1)');
        let openHisBtn = document.querySelectorAll('div.footer div.pt-1 button')[2];
        let copyReportBtn = document.querySelector('button[title="複製內容"]');

        // Alt+] or Alt+[: find next/prev report
        if (ev.altKey && (ev.key === ']' || ev.key === '[')) {
            console.log("Alt+] or Alt+[: find next/prev report");
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
                const frameHistory = document.querySelector('#frameHistory');
                //console.log('tr top: ' + frameHistoryTr[i].offsetTop + '; div top: ' + frameHistory.offsetTop + '; div height: ' + frameHistory.clientHeight + '; div scrollTop: ' + frameHistory.scrollTop);
                scrollToSelectedItem(frameHistoryTr[i]);
            }
        }

        // Ctrl+] or Ctrl+[: find next/prev similar report
        if (ev.ctrlKey && (ev.key === ']' || ev.key === '[')) {
            console.log("Ctrl+] or Ctrl+[: find next/prev similar report");
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
                document.execCommand('insertText', false, found_indication[1]);
            } else {
                let soap_a = document.querySelector('div[style="height: 930px;"] > div:nth-child(4) textarea').value;
                found_indication = soap_a.match(/【檢查目的】\n(.+?)\n/s);
                if (found_indication) {
                    document.execCommand('insertText', false, found_indication[1]);
                }
            }
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
        }
        // Ctrl+Alt+P: Insert Pathology Date And Report
        // Remap hotkey to Alt+P in AHK
        if (ev.ctrlKey && ev.altKey && ev.key === 'p') {
            console.log("Ctrl+Alt+P: Insert Pathology Date And Report");
            let pat_date = document.querySelector('tr.text-secondary td:nth-child(2)').textContent;
            if (pat_date) {
                pat_date = pat_date.replace(/(\d{4})\/(\d{2})\/(\d{2})/, '$1-$2-$3');
                const full_pat_report = document.querySelector('div[style="height: 870px; width: 41.6667%; left: 0%; top: 60px;"] textarea').value;
                const pat_diagnosis = full_pat_report.replace(/.+檢驗後診斷名稱:\n(.+)\n\n報告內容.+$/s, '$1');
                const formatted_str = `${pat_date}: ${pat_diagnosis}`;
                document.execCommand('insertText', false, formatted_str);
            }
        }
        // Ctrl+Alt+D: Insert Prev Exam Date in Y-M-D format
        // Remap hotkey to Alt+D in AHK
        if (ev.ctrlKey && ev.altKey && ev.key === 'd') {
            console.log("Ctrl+Alt+D: Insert Prev Exam Date (Y-M-D)");
            //navigator.clipboard.writeText(prev_examdate);
            const curr_pid = getCurrPatId();
            if (curr_pid === prev_examdate_pid) {
                document.execCommand('insertText', false, prev_examdate);
            }
        }

        // Ctrl+Alt+Shift+D: Insert Prev Exam Date in Y/M/D format
        // Remap hotkey to Alt+Shift+D in AHK
        if (ev.ctrlKey && ev.altKey && ev.key === 'D') {
            console.log("Ctrl+Alt+D: Insert Prev Exam Date (Y/M/D)");
            //navigator.clipboard.writeText(prev_examdate);
            const curr_pid = getCurrPatId();
            if (curr_pid === prev_examdate_pid) {
                const [year, month, day] = prev_examdate.split('-');
                const new_prev_examdate = `${year}/${parseInt(month)}/${parseInt(day)}`;
                document.execCommand('insertText', false, new_prev_examdate);
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
                    const foundLat = soap_s.match(/\b(([Ll](eft|['`′]?t))|([Rr](ight|['`′]?t)))\b/);
                    if (foundLat) {
                        const strLat = foundLat[1].charAt(0).toUpperCase() == 'L' ? 'Left ' : 'Right ';
                        examStr = strLat + examStr;
                    }
                } else if (isSpineCTorMRI(currExamName)) {
                    const frameHistoryUnfinishedTr = getFrameHistoryUnfinishedTr();
                    const currPart = currExamName.match(/SPINE\s+(\w+)\s+(CT|MRI)/)[1];
                    let spinePartList = [currPart];
                    for (let i = 0; i < frameHistoryUnfinishedTr.length; i++) {
                        const unfinishedExamName = frameHistoryUnfinishedTr[i].children[4].textContent;
                        if (isSpineCTorMRI(unfinishedExamName)) {
                            const unfinishedPart = unfinishedExamName.match(/SPINE\s+(\w+)\s+(CT|MRI)/)[1];
                            spinePartList.push(unfinishedPart);
                        }
                    }
                    const spinePartStr = joinWithAnd(spinePartList.sort(spineCompareFn));
                    examStr = examStr.replace(/.+(CT|MRI)/, "SPINE " + spinePartStr + " $1");
                }
                document.execCommand('insertText', false, examStr + ":\n\n");
            }
        }

        // Ctrl+Alt+E: Insert Exam Name
        // Remap hotkey to Alt+E in AHK
        if (ev.ctrlKey && ev.altKey && ev.key === 'e') {
            console.log("Ctrl+Alt+E: Insert Exam Name");
            const currExamName = getCurrExamName();
            if (currExamName) {
                document.execCommand('insertText', false, currExamName + ":\n\n");
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
        return isSonoCDU(examName) || isSonoBreast(examName) || isSpineCTorMRI(examName) || isChestCT(examName);
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
                            const frameHistory = document.querySelector("#frameHistory");
                            frameHistory.scrollTop = (jNode.get(0).offsetTop + jNode.get(0).clientHeight > frameHistory.clientHeight) ? jNode.get(0).offsetTop : 0;
                        }, 1500);

                    } else {
                        //console.log("not first run: " + prevExamDateTime + ': ' + prevExamName);
                    }
                }
            }
        }
    }

    const simExam = {
        // plain film
        'Chest': ['CHEST', 'Chest AP Portable', 'Chest PA+lateral(R)', 'Chest PA+lateral(L)', 'CHEST PA+Lat(L.R)',
                  '【限IDS申報】Chest PA(Telemedicine)'],
        'Chest-Study': ['Chest', 'CHEST', 'Chest AP Portable', 'Chest PA+lateral(R)', 'Chest PA+lateral(L)',
                        'CHEST PA+Lat(L.R)', 'Lung Low Dose CT-Study', '【限IDS申報】Chest PA(Telemedicine)'],
        'Chest PA+lateral(L)': ['Chest', 'CHEST', 'Chest AP Portable', '【限IDS申報】Chest PA(Telemedicine)'],
        'Chest PA+lateral(R)': ['Chest', 'CHEST', 'Chest AP Portable', '【限IDS申報】Chest PA(Telemedicine)'],
        'Chest AP Portable': ['Chest', 'CHEST', '【限IDS申報】Chest PA(Telemedicine)'],
        'KUB': ['ABDOMEN KUB', 'KUB Portable'],
        'KUB Portable': ['ABDOMEN KUB', 'KUB'],
        'Abdomen standing': ['KUB', 'ABDOMEN KUB', 'KUB Portable'],

        'C spine dynamic': ['C spine AP', 'C spine AP+ lateral'],
        'C spine AP': ['C spine dynamic', 'C spine AP+ lateral'],
        'C spine AP+ lateral': ['C spine dynamic', 'C spine AP'],
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
            'LS spine AP+lateral', 'LS spine AP Lat', 'LS spine dynamic',
            'LS spine lateral', 'T-L spine AP+Lat', 'TL spine AP+lateral'
        ],
        'LS spine dynamic': ['LS-spine dynamic', 'LS spine AP+lateral', 'LS spine AP+lateral standing',
                             'LS spine AP', 'LS spine lateral'],
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
        'Sono Abdomen': ['腹部超音波，追蹤性', 'Abdominal ultrasound, for follow-up'],
        'Abdominal ultrasound, for follow-up': ['腹部超音波，追蹤性', 'Sono Abdomen'],
        'Sono CDU  Kideny': ['Abdominal ultrasound, for follow-up', 'Sono Abdomen'],
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
        'Chest CT': [
            'Lung cancer (Chest & Upper abdomen)-CT', 'Lung Low Dose CT', 'Lung-Low Dose CT',
            'Chest Pulmonary Arteries CT',
            'Chest', 'CHEST', 'Chest AP Portable',
        ],
        'Lung cancer (Chest & Upper abdomen)-CT': [
            'Chest CT', 'Lung Low Dose CT', 'Lung-Low Dose CT', 'Chest Pulmonary Arteries CT',
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
        'Colon cancer (Abdomen & Pelvis) MRI': ['Colon cancer (Abdomen & Pelvis)-CT'],
        'PELVIS Prostate MRI': ['Prostate cancer (Abdomen & Pelvis) MRI'],
        'Prostate cancer (Abdomen & Pelvis) MRI': ['PELVIS Prostate MRI'],

        // Breast
        'CHEST Breast MRI': ['Sono Breasts', 'SonoBreasts', 'Breasts sono'],

        // Angio
        'Lipiodol T.A.E.(trans-arterial embolization)-Lipiodol': ['血管阻塞術'],
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
                jNode.first().addClass(hlClass);
                nextTr.children().eq(4).addClass(hlClass);
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
            const reportDrTd = jNode.next().next().next();
            reportDrTd.addClass('dk-incompleted-report');
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