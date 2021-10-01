; Copy Previous Similar Report
;; by web api: https://femh.tsai.it/ris/recent-similar-report/{accno}
;; Depends on: WinHttpRequest (https://autohotkey.com/boards/viewtopic.php?t=3256)
;;             JSON (https://autohotkey.com/boards/viewtopic.php?t=627)
;;             Acc (https://autohotkey.com/boards/viewtopic.php?t=26201)
;;             GetCurrAccnoFromGeUv (own lib)

CopyPrevSimilarReport(accno, debug=False) {
  if (accno) {
    ;r := WinHttpRequest("https://femh.tsai.it/ris/recent-similar-report/" + accno, InOutData := "", InOutHeaders := "", "Timeout: 1`nNO_AUTO_REDIRECT")
    r := WinHttpRequest("http://localhost:5000/recent-similar-report/" + accno, InOutData := "", InOutHeaders := "", "Timeout: 15`nNO_AUTO_REDIRECT")
    ;MsgBox, % (r = -1) ? "successful" : (r = 0) ? "Timeout" : "No response"
    ;MsgBox, % InOutData
    ;MsgBox, % InOutHeaders
    parsedResult := JSON.Load(InOutData)
    ;MsgBox % parsedResult.report.accno
    ;MsgBox % parsedResult.info[1]
    If (debug) {
      MsgBox % parsedResult.debug[1].patid
    } Else If (parsedResult.report.accno) {
      global prevExamDate, prevPatID
      prevExamDate := StrSplit(parsedResult.report.examdate, A_Space)[1]
      prevPatID := parsedResult.debug[1].patid
      prevAccNo := parsedResult.report.accno

      ControlGet, hFdEdit, Hwnd,, TMemo6
      ControlGet, hImpEdit, Hwnd,, TMemo7
      if (hFdEdit && hImpEdit) {
        new_findings_text := Edit_GetText(hFdEdit) . parsedResult.report.findings
        new_impression_text := Edit_GetText(hImpEdit) . parsedResult.report.impression
        Edit_SetText(hFdEdit, new_findings_text)
        Edit_SetText(hImpEdit, new_impression_text)

        ;load study in INFINITT PACS
        pacs_api =
        ( LTrim Join
          http://10.2.2.30/pkg_pacs/external_interface.aspx?
            LID=A60076&
            LPW=A60076&
            AN=%prevAccNo%&
            PID=%prevPatID%
        )
        ;MsgBox % pacs_api
        ;Clipboard := pacs_api
        ;Run %pacs_api%
      }
    } Else {
      MsgBox, No Similar Report. InOutData = "%InOutData%"
    }
  }
}
