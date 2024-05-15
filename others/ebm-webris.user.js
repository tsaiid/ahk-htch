// ==UserScript==
// @name         Enhanced WebRIS
// @namespace    http://tsai.it/
// @version      20240515.1
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

    document.addEventListener('keydown', (ev) => {
        let nextReportChkBox = document.querySelector("div.footer input");
        let prevReportTab = document.querySelector('div[style="height: 870px; width: 41.6667%; left: 0%; top: 60px;"] > div > div:nth-child(1) > div:nth-child(1) > div:nth-child(1)');
        let pathoReportTab = document.querySelector('div[style="height: 870px; width: 41.6667%; left: 0%; top: 60px;"] > div > div:nth-child(1) > div:nth-child(2) > div:nth-child(1)');
        let labReportTab = document.querySelector('div[style="height: 870px; width: 41.6667%; left: 0%; top: 60px;"] > div > div:nth-child(1) > div:nth-child(3) > div:nth-child(1)');
        let openHisBtn = document.querySelectorAll('div.footer div.pt-1 button')[2];
        let copyReportBtn = document.querySelector('button[title="複製內容"]');

        // Ctrl+I: Insert indication
        if (ev.ctrlKey && ev.altKey && ev.key === 'i') {
            console.log("Ctrl+I: Insert indication");
            let soap_o = document.querySelector('#app > main > main > div > div.flex-auto > main > div > div.main > div > div > div:nth-child(3) > div > div > textarea').value;
            let found_indication = soap_o.match(/檢查目的：(.+)/);
            if (found_indication) {
                document.execCommand('insertText', false, found_indication[1]);
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
            const pid = document.querySelector('input[title="病歷號碼"]').value;
            const an = document.querySelector('input[title="檢查單號"]').value;
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
            prev_examdate_pid = document.querySelector('input[title="病歷號碼"]').value;
            //console.log(prev_examdate);
        }
        // Ctrl+9: Copy report with opening images
        // Remap hotkey to Ctrl+Shift+Esc in AHK
        if (ev.ctrlKey && ev.key === '9') {
            console.log("Ctrl+9: Copy report with opening images");
            copyReportBtn.click();

            // double click the prev report to open in PACS
            var dblClickEvent = new MouseEvent('dblclick', {
                'view': window,
                'bubbles': true,
                'cancelable': true
            });
            const examName = document.querySelector('input[title="檢查項目"]');
            switch (examName.value) {
                case 'Chest':
                case 'KUB':
                case 'Sono Thyroid glands':
                case 'Sono Abdomen':
                case 'Sono Breasts':
                case 'Abdominal ultrasound, for follow-up':
                case 'Sono CDU  Kideny':
                    break;
                default:
                    document.querySelector("#frameHistory tr.text-secondary").dispatchEvent(dblClickEvent);
            }

            // save prev report date into a var for further pasting
            const s = document.querySelector('tr.text-secondary td').textContent;
            prev_examdate = s.replace(/(\d{4})(\d{2})(\d{2})/, '$1-$2-$3');
            console.log(prev_examdate);
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
        // Ctrl+Alt+D: Insert Prev Exam Date
        // Remap hotkey to Alt+D in AHK
        if (ev.ctrlKey && ev.altKey && ev.key === 'd') {
            console.log("Ctrl+Alt+D: Insert Prev Exam Date");
            //navigator.clipboard.writeText(prev_examdate);
            const curr_pid = document.querySelector('input[title="病歷號碼"]').value;
            if (curr_pid === prev_examdate_pid) {
                document.execCommand('insertText', false, prev_examdate);
            }
        }
        // Ctrl+Alt+F: Insert Exam Name and Contrast
        // Remap hotkey to Ctrl+Alt+Shift+E in AHK
        if (ev.ctrlKey && ev.altKey && ev.key === 'f') {
            console.log("Ctrl+Alt+F: Insert Exam Name and Contrast");
            const i1 = document.querySelector('input[title="檢查項目"]');
            if (i1) {
                let examname = i1.value;
                const i2 = document.querySelector('input[title="顯影劑"]');
                if (i2 && i2.value && CONTRAST_STR.hasOwnProperty(i2.value)) {
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
        "#frameHistory tbody tr td:nth-child(5)"
        , highlightSimilarExam
    );

    function highlightSimilarExam(jNode) {
        const currExamName = document.querySelector('input[title="檢查項目"]').value;
        //console.log(jNode[0]);
        const prevExamName = jNode[0].textContent;
        if (prevExamName === currExamName || prevExamName === currExamName.replace(/ /g, '')) {
            jNode.first().addClass('hl-same-report');
        } else if (isSimilarExam(prevExamName, currExamName)) {
            //console.log("檢查項目: " + currExamName);
            //console.log(jNode.first());
            jNode.first().addClass('hl-sim-report');
        }
    }

    const simExam = {
        // plain film
        'Chest': ['CHEST', 'Chest AP Portable', 'Chest PA+lateral(R)', 'Chest PA+lateral(L)', 'CHEST PA+Lat(L.R)'],
        'Chest-Study': ['Chest', 'CHEST', 'Chest AP Portable', 'Chest PA+lateral(R)', 'Chest PA+lateral(L)',
                        'CHEST PA+Lat(L.R)', 'Lung Low Dose CT-Study'],
        'Chest PA+lateral(L)': ['Chest', 'CHEST', 'Chest AP Portable'],
        'Chest PA+lateral(R)': ['Chest', 'CHEST', 'Chest AP Portable'],
        'Chest AP Portable': ['Chest', 'CHEST'],
        'KUB': ['ABDOMEN KUB', 'KUB Portable'],
        'Abdomen standing': ['KUB', 'ABDOMEN KUB', 'KUB Portable'],

        'C spine dynamic': ['C spine AP', 'C spine AP+ lateral'],
        'C spine AP': ['C spine dynamic', 'C spine AP+ lateral'],
        'C spine AP+ lateral': ['C spine dynamic', 'C spine AP'],
        'T spine AP+lateral': ['TL spine AP+lateral', 'TL spine AP+lateral standing', 'T-L spine AP+Lat'],
        'TL spine AP+lateral': ['TL spine AP+lateral standing', 'T-L spine AP+Lat', 'LS spine lateral standing'],
        'LS spine AP+lateral': [
            'LS spine AP+lateral standing', 'LS spine AP Lat', 'LS spine dynamic', 'LS-spine dynamic',
            'LS spine lateral', 'T-L spine AP+Lat', 'TL spine AP+lateral'
        ],
        'LS spine AP+lateral standing': [
            'LS spine AP+lateral', 'LS spine AP Lat', 'LS spine dynamic',
            'LS spine lateral', 'T-L spine AP+Lat', 'TL spine AP+lateral'
        ],
        'LS spine dynamic': ['LS-spine dynamic', 'LS spine AP+lateral', 'LS spine AP'],
        'LS spine AP': ['LS-spine dynamic', 'LS spine AP+lateral', 'LS spine dynamic'],
        'LS spine lateral': ['LS-spine dynamic', 'LS spine AP+lateral'],
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
        'Knee AP+lateral(R)': ['JOINT Knee CT'],
        'Knee AP+lateral(L)': ['JOINT Knee CT'],
        'Pelvis THR': ['Hip lateral(R)', 'Hip lateral(L)', 'KUB'],
        'Hip lateral(R)': ['Pelvis THR'],
        'Hip lateral(L)': ['Pelvis THR'],
        'Foot AP+oblique(R)': ['Foot lateral(R)', 'Foot AP+lateral(R)'],
        'Foot AP+oblique(L)': ['Foot lateral(L)', 'Foot AP+lateral(L)'],

        // ultrasound
        'Sono Abdomen': ['腹部超音波，追蹤性', 'Abdominal ultrasound, for follow-up'],
        'Abdominal ultrasound, for follow-up': ['腹部超音波，追蹤性', 'Sono Abdomen'],
        'Sono CDU  Kideny': ['Abdominal ultrasound, for follow-up', 'Sono Abdomen'],
        'Sono Breasts': ['SonoBreasts', 'Breasts sono',
                         'Mammography L&R', 'Mammography L&R(HPA)限45歲以上', 'Mammography L&R(HPA)', 'MAMMOGRAPHY L&R'],

        // CT
        'Abdomen to Pelvis CT': ['Abdomen  Liver Triple Phase CT', 'Abdomen  Liver 4 Phase CT', 'ABDOMEN Liver MRI'],
        'Abdomen  Liver Triple Phase CT': ['Abdomen to Pelvis CT', 'Abdomen  Liver 4 Phase CT'],
        'Abdomen  Liver 4 Phase CT': ['Abdomen to Pelvis CT', 'Abdomen  Liver Triple Phase CT', 'ABDOMEN Liver MRI',
                                      'Sono Abdomen'],
        'Abdomen pancreas dual phase CT': [
            'Abdomen  Pancreas Dual Phase  CT', 'Abdomen to Pelvis CT', 'Abdomen  Liver 4 Phase CT',
            'Abdomen  Liver Triple Phase CT',
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
        'PELVIS  Hip  CT': ['Pelvis THR'],
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
                           'Knee AP+lateral standing(R)',
                           'Knee AP+lateral standing(L)'],
        'JOINT Shoulder MRI': [
            'Shoulder internal+external(L)', 'Shoulder internal+external(R)', 'Shoulder internal+external(both)',
            'Shoulder AP(both)', 'Shoulder axial(both)', 'Scapula Y view(both)',
        ],
        'JOINT Ankle MRI': ['Ankle stress view(R)'],
        'JOINT Wrist MRI': ['Wrist PA+lateral(R)', 'Wrist PA+lateral(L)'],

        // Breast
        'CHEST Breast MRI': ['Sono Breasts', 'SonoBreasts', 'Breasts sono'],

        // Angio
        'Lipiodol T.A.E.(trans-arterial embolization)-Lipiodol': ['血管阻塞術'],
    };

    function isSimilarExam(prevExamName, currExamName) {
        return (simExam[currExamName] && simExam[currExamName].includes(prevExamName));
    }

    /* highlight date by day */
    waitForKeyElements (
        "#app > main > main > div > div.flex-auto > div.px-5 > div.overflow-auto > table > tbody > tr > td:nth-child(6)"
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
        "#app > main > main > div > div.flex-auto > div.px-5 > div.overflow-auto > table > tbody > tr > td:nth-child(2)"
        , colorizeExamOrigin
    );
    waitForKeyElements (
        'div[style="height: 60px; width: 100%; left: 0%; top: 0px;"] input[title="來源"]'
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
                //console.log(jNode[0].value);
                examOriginStr = jNode[0].value;
                if (examOriginStr.match(/^住院/)) {
                    jNode.first().attr('style', 'color: #be99ff !important');
                } else if (examOriginStr == '急診') {
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
        "#app > main > main > div > div.flex-auto > div.px-5 > div.overflow-auto > table > tbody > tr > td:nth-child(5)"
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