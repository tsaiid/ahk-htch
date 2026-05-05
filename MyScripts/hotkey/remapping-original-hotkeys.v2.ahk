#Requires AutoHotkey v2.0

; HotKey

;; For all RIS related window
#HotIf WinActive("ahk_group RIS")
;; Ctrl + A
;; Go to start of line
^a::Send("{Home}")

;; Ctrl + E
;; Go to end of line
^e::
{
  Send("{End}")
  /*
  ControlGetFocus, FocusedControl
  If (FocusedControl = "TMemo6" || FocusedControl = "TMemo7") {
    ControlGet, hEdit, Hwnd,, %FocusedControl%
    Edit_GetSel(hEdit, startSel)
    ;MsgBox % startSel
    l_text := Edit_GetTextRange(hEdit, startSel)
    ;MsgBox % l_text
    l_FoundPos:=InStr(l_Text, "`r`n")
    ;a:=Edit_FindText(hEdit, "`n")
    ;MsgBox % l_FoundPos
    If (l_FoundPos > 0) {
      endSel := startSel + l_FoundPos - 1
      Edit_SetSel(hEdit, endSel, endSel)
    } Else {
      endSel := Edit_GetTextLength(hEdit)
      Edit_SetSel(hEdit, endSel, -1)
    }
    ;p_LineIdx:=Edit_LineFromChar(hEdit,Edit_LineIndex(hEdit))
    ;l_StartSelPos:=Edit_LineIndex(hEdit,p_LineIdx)
    ;l_EndSelPos  :=l_StartSelPos+Edit_LineLength(hEdit,p_LineIdx)
    ;Edit_SetSel(hEdit,l_EndSelPos,l_EndSelPos)
  }
  */
}

;; Ctrl + D
;; Delete a character
^d::Send("{Del}")

^k::
{
  Send("+{End}")
  Send("{Del}")
}

^y::
{
  Send("{Home}")
  Send("+{Down}")
  Send("{Del}")
}
#HotIf  ; end of ahk_group RIS


;
;
; Only for WebRIS
;
;
#HotIf WinActive("WebRIS")
#c::
{
  Send("^a")
  Sleep(100)
  Send("^c")
}

^w::Send("^{BS}")

#d::
{
  Send("^a")
  Sleep(100)
  Send("{Del}")
}

#a::Send("^a")

!d::Send("^!d")

!+d::Send("^!+d")

!p::Send("^!p")

;; Alt + E
;; Paste Examname
!e::
{
;  PasteExamname()
  Send("^!e")
}

;; Ctrl + Alt + Shift + E
;; Paste Examname with contrast informtion
^!+e::
{
;  PasteExamnameAndContrast()
  Send("^!f")
}

;; Insert Indication
;; Because Quill editor has a hotkey of Ctrl+I to italic
^i::Send("^!i")

^Esc::
{
;  CopyReportPath := "4.1.1.4.3.1.1.3.2.1.3.1.1.1.8.1.1.2.3.1"
;  btnObj := Acc_Get("Object", CopyReportPath, 0, "WebRIS")
;  btnObj.accDoDefaultAction(0)
  Send("^0")
  Sleep(500)
  Send("^{Home}")
}

!Esc::
{
;  CopyReportPath := "4.1.1.4.3.1.1.3.2.1.3.1.1.1.8.1.1.2.3.1"
;  btnObj := Acc_Get("Object", CopyReportPath, 0, "WebRIS")
;  btnObj.accDoDefaultAction(0)
  Send("^9")
}

!q::Send("{F4}")   ; Quit without Save

;; Remap Kana Key
;;; Formatting IMPRESSION
;;;; Reorder Seleted Text And Discard SeIm
SC070::ReorderSelectedText()

;;; Formatting FINDINGS
;;;; Reorder Seleted Text And Keep SeIm
SC079::ReorderSelectedText(false, true, "-", false)
#HotIf  ; end of WebRIS


;
; Solid PACS Viewer
;
#HotIf WinActive("ahk_exe WEBVIE~1.EXE")
;; zoom in/out
^WheelUp::Send("{NumpadAdd}")
^WheelDown::Send("{NumpadSub}")

;; activate WebRIS and copy report
^Esc::
{
  if (!WinActive("WebRIS")) {
    WinActivate("WebRIS")
    Send("^0")
  }
}

;; activate WebRIS and insert exam name
!e::
{
  if (!WinActive("WebRIS")) {
    WinActivate("WebRIS")
    Send("^!e")
  }
}
#HotIf  ; for ahk_exe WEBVIE~1.EXE



;; for INFINITT PACS
#HotIf WinActive("ahk_exe G3PACS.exe")
w::
{
  pacsFocusedControl := GetFocusedControlClassNN()
  OutputVar := WinGetTitle("A")
;MsgBox, "%OutputVar%"
  if (OutputVar = "INFINITT PACS" && SubStr(pacsFocusedControl, 1, 3) == "Afx") {
    DiffSyncBtns := ["Button1", "Button75"]
    for idx, btn in DiffSyncBtns {
      try {
        t := ControlGetText(btn)
        if (t = "自動同步") {
          ControlClick(btn)
          break
        }
      }
    }
  } else {
    Send("w")
  }
}

f::
{
  pacsFocusedControl := GetFocusedControlClassNN()
  OutputVar := WinGetTitle("A")
;MsgBox, "%OutputVar%"
  if (OutputVar = "INFINITT PACS" && SubStr(pacsFocusedControl, 1, 3) == "Afx") {
    DiffSyncBtns := ["Button2", "Button76", "Button91"]
    for idx, btn in DiffSyncBtns {
      try {
        t := ControlGetText(btn)
        if (t = "不同檢查同步 ") {
          ControlClick(btn)
          break
        }
      }
    }
  } else {
    Send("f")
  }
}

e::
{
  pacsFocusedControl := GetFocusedControlClassNN()
  ;MsgBox, "%FocusedControl%"

  OutputVar := WinGetTitle("A")
  if (OutputVar = "INFINITT PACS" && SubStr(pacsFocusedControl, 1, 3) == "Afx") {
    DiffSyncBtns := ["Button4", "Button78"]
    for idx, btn in DiffSyncBtns {
      try {
        t := ControlGetText(btn)
        if (t = " Scout lines") {
          ControlClick(btn)
          break
        }
      }
    }
  } else {
    Send("e")
  }
}
#HotIf  ; for INFINITT PACS








;
; Global Remap
;
#^p::ProcessClose("G3PACS.exe")

;; for JIS keyboard
SC029::
{
  if (!WinActive("WebRIS")) {
    WinActivate("WebRIS")
  }
}

SC07B::LButton

#x::^x

;; for global windows environment
#Space::SendEvent("^{Space}")  ; Need to send event to work in VirtualBox






;
;
; Probably useless?
;
;
CopyPidAndLaunchPacsWorklist()
{
  ;MsgBox, 1
  A_Clipboard := ""
  Send("^c")
  if !ClipWait(2)
  {
    MsgBox("The attempt to copy text onto the clipboard failed.")
    return
  }
  ;load patient in INFINITT PACS
  pacs_api := "http://10.2.2.30/pkg_pacs/external_interface.aspx?"
    . "TYPE=W&"
    . "LID=A60076&"
    . "LPW=A60076&"
    . "PID=" A_Clipboard
  ;MsgBox %pacs_api%
  Run("msedge.exe --app=" pacs_api)
}

;; for 檢查排程系統
#HotIf WinActive("ahk_exe ExmSchSys.EXE")
#c::CopyPidAndLaunchPacsWorklist()
#HotIf  ; for ahk_exe ExmSchSys.EXE

;; for LibreOffice Calc
#HotIf WinActive("- LibreOffice Calc")
#c::CopyPidAndLaunchPacsWorklist()
#HotIf  ; for LibreOffice Calc

GetFocusedControlClassNN()
{
  try {
    hCtl := ControlGetFocus("A")
    return ControlGetClassNN(hCtl)
  }
  return ""
}
