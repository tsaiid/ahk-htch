; HotKey
;#IfWinActive ahk_exe Helios.exe
ClickReportList() {
  global reportListObj
  reportListObj.accDoDefaultAction(0)
}

ClickExamList() {
  global examListObj
  examListObj.accDoDefaultAction(0)
}

ClickOpdList() {
  global opdListObj
  opdListObj.accDoDefaultAction(0)
}

ClickPathoList() {
  global pathoListObj
  pathoListObj.accDoDefaultAction(0)
}
#IfWinActive

;; for SmartWonder
#IfWinActive ahk_group SmartWonder
;;; Select Tabs
ClickReportEditing() {
  wb := WBGet()
  frmWork := wb.document.frames["frameWork"]
  frmTabIframe2 := frmWork.document.frames["tabIframe2"]

  tabEditReport := frmWork.document.getElementById("tabCaption0").children[1]
  ; 切換至編輯報告頁
  tabEditReport.click()
}

ClickPreviousReports() {
  wb := WBGet()
  frmWork := wb.document.frames["frameWork"]
  frmTabIframe2 := frmWork.document.frames["tabIframe2"]

  tabPrevReport := frmWork.document.getElementById("tabCaption0").children[7]
  ; 切換至歷史報告頁
  tabPrevReport.click()
}
;#IfWinActive