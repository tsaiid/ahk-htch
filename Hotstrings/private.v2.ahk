; Private
;; it will be ignored from the repo

Acc_Children(oAcc) {
  return []
}

SearchElement(parentElement, params) {
   found := true
   for k, v in params {
      try {
         if (parentElement["acc" . k](0) != v)
            found := false
      } catch {
         found := false
      }
   } until !found

   if found
      return parentElement

   for k, v in Acc_Children(parentElement)
      if obj := SearchElement(v, params)
         return obj
}

GoThroughAcc(oAcc) {
  try oAcc["accName"](0)
  for k, v in Acc_Children(oAcc)
    GoThroughAcc(v)
}

;; Login
#HotIf WinActive("ahk_group Login")
^!l:: {
  if (WinActive("ahk_exe loginscreen.exe")
      || WinActive("ahk_exe AdmOrder1.EXE")
      || WinActive("ahk_exe OORMAIN.exe")
      || WinActive("ahk_exe WebViewer.exe")
      || WinActive("WebRIS - 個人 - Microsoft? Edge")
      || WinActive("EBM UniSchedule - Google Chrome")) {
    Send "60076{Tab}htch60076{Enter}"
  } else if (WinActive("花蓮慈院上網認證")) {
    Send "000008496{Tab}60076htch{Enter}"
  } else if (WinActive("慈濟病歷電子書")) {
    Send "60076{Tab}htch60076{Tab}{Space}{Enter}"
  } else if (WinActive("Lotus Notes")) {
    Send "pass1234{Enter}"
  } else if (WinActive("ahk_exe chrome.exe") || WinActive("ahk_exe Code.exe")) {
    Send "817119{Tab}"
    Sleep 500
    Send "60076htch{Enter}"
  } else {
    Send "A60076{Tab}A60076{Enter}"
  }
}
#HotIf

ConvertToEmrDateStr(AhkDateStr) {
  y := FormatTime(AhkDateStr, "yyyy")
  md := FormatTime(AhkDateStr, "MMdd")
  return (y - 1911) . md
}

;; for LibreOffice Calc
#HotIf WinActive("- LibreOffice Calc")

CopyPidAndLaunchEmr() {
  A_Clipboard := ""
  Send "^c"
  if !ClipWait(2) {
    MsgBox "The attempt to copy text onto the clipboard failed."
    return
  }

  EmrEndDateStr := A_YYYY - 1911 . A_MM . A_DD
  EmrStartDateStr := ConvertToEmrDateStr(DateAdd(A_Now, -360, "Days"))
  EmrApi := "http://10.2.0.160/TzuStore/TestWeb.aspx?"
      . "Uid=60076,蔡依達,"
      . A_Clipboard . ","
      . EmrStartDateStr . ","
      . EmrEndDateStr . ","
      . "vbp_Mrd_Nosology,"

  Run 'chrome.exe "' EmrApi '"'
}

#+c:: {
  CopyPidAndLaunchEmr()
}

#HotIf
