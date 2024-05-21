; HotKey

;; For all RIS related window
#IfWinActive ahk_group RIS
;; Ctrl + A
;; Go to start of line
^a::
  Send {Home}
Return

;; Ctrl + E
;; Go to end of line
^e::
  Send {End}
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
Return

;; Ctrl + D
;; Delete a character
^d::
  Send {Del}
Return

^k::
  Send +{End}
  Send {Del}
Return

^y::
  Send {Home}
  Send +{Down}
  Send {Del}
Return
#IfWinActive  ; end of ahk_group RIS


;
;
; Only for WebRIS
;
;
#IfWinActive WebRIS
#c::
  Send ^a
  Sleep 100
  Send ^c
Return

^w::
  Send +^{Left}
  Send {BS}
Return

#d::
  Send ^a
  Sleep 100
  Send {DEL}
Return

#a::
  Send ^a
Return

!d::
  Send ^!d
Return

!p::
  Send ^!p
Return

;; Alt + E
;; Paste Examname
!e::
;  PasteExamname()
  Send ^!e
Return

;; Ctrl + Alt + Shift + E
;; Paste Examname with contrast informtion
^!+e::
;  PasteExamnameAndContrast()
  Send ^!f
Return

;; Insert Indication
;; Because Quill editor has a hotkey of Ctrl+I to italic
^i::
  Send ^!i
Return

^Esc::
;  CopyReportPath := "4.1.1.4.3.1.1.3.2.1.3.1.1.1.8.1.1.2.3.1"
;  btnObj := Acc_Get("Object", CopyReportPath, 0, "WebRIS")
;  btnObj.accDoDefaultAction(0)
  Send ^0
Return

^+Esc::
;  CopyReportPath := "4.1.1.4.3.1.1.3.2.1.3.1.1.1.8.1.1.2.3.1"
;  btnObj := Acc_Get("Object", CopyReportPath, 0, "WebRIS")
;  btnObj.accDoDefaultAction(0)
  Send ^9
Return

!Esc::
  Send {F4}   ; Quit without Save
Return

;; Remap Kana Key
;;; Formatting IMPRESSION
;;;; Reorder Seleted Text And Discard SeIm
SC070::
  ReorderSelectedText()
Return

;;; Formatting FINDINGS
;;;; Reorder Seleted Text And Keep SeIm
SC079::
  ReorderSelectedText(false, true, "-", false)
Return
#IfWinActive  ; end of WebRIS


;
; Solid PACS Viewer
;
#IfWinActive ahk_exe WEBVIE~1.EXE
;; zoom in/out
^WheelUp::
  Send {NumpadAdd}
Return
^WheelDown::
  Send {NumpadSub}
Return

;; activate WebRIS and copy report
^Esc::
  If (!WinActive("WebRIS")) {
    WinActivate, WebRIS
    Send ^0
  }
Return
#IfWinActive  ; for ahk_exe WEBVIE~1.EXE



;; for INFINITT PACS
#IfWinActive ahk_exe G3PACS.exe
w::
  ControlGetFocus, FocusedControl
  WinGetTitle, OutputVar
;MsgBox, "%OutputVar%"
  If (OutputVar = "INFINITT PACS" && SubStr(FocusedControl, 1, 3) == "Afx") {
    DiffSyncBtns := ["Button1", "Button75"]
    For idx, btn in DiffSyncBtns {
      ControlGetText, t, %btn%
      if (t = "自動同步") {
        ControlClick, %btn%
        Break
      }
    }
  } Else {
    Send, w
  }
Return

f::
  ControlGetFocus, FocusedControl
  WinGetTitle, OutputVar
;MsgBox, "%OutputVar%"
  If (OutputVar = "INFINITT PACS" && SubStr(FocusedControl, 1, 3) == "Afx") {
    DiffSyncBtns := ["Button2", "Button76", "Button91"]
    For idx, btn in DiffSyncBtns {
      ControlGetText, t, %btn%
      if (t = "不同檢查同步 ") {
        ControlClick, %btn%
        Break
      }
    }
  } Else {
    Send, f
  }
Return

e::
  ControlGetFocus, FocusedControl
  ;MsgBox, "%FocusedControl%"

  WinGetTitle, OutputVar
  If (OutputVar = "INFINITT PACS" && SubStr(FocusedControl, 1, 3) == "Afx") {
    DiffSyncBtns := ["Button4", "Button78"]
    For idx, btn in DiffSyncBtns {
      ControlGetText, t, %btn%
      if (t = " Scout lines") {
        ControlClick, %btn%
        Break
      }
    }
  } Else {
    Send, e
  }
Return
#IfWinActive  ; for INFINITT PACS








;
; Global Remap
;
#^p::
  Process, Close, G3PACS.exe
Return

;; for JIS keyboard
SC029::
  If (!WinActive("WebRIS")) {
    WinActivate, WebRIS
  }
Return

SC07B::LButton

#x::^x

;; for global windows environment
#Space::
  SendEvent ^{Space}  ; Need to send event to work in VirtualBox
Return






;
;
; Probably useless?
;
;
CopyPidAndLaunchPacsWorklist()
{
  ;MsgBox, 1
  Clipboard := ""
  Send, ^c
  ClipWait, 2
  if ErrorLevel
  {
    MsgBox, The attempt to copy text onto the clipboard failed.
    return
  }
  ;load patient in INFINITT PACS
  pacs_api =
  ( LTrim Join
    http://10.2.2.30/pkg_pacs/external_interface.aspx?
      TYPE=W&
      LID=A60076&
      LPW=A60076&
      PID=%Clipboard%
  )
  ;MsgBox %pacs_api%
  Run %pacs_api%
}

;; for LibreOffice Calc
#IfWinActive ahk_exe ExmSchSys.EXE
#c::
  CopyPidAndLaunchPacsWorklist()
Return
#IfWinActive  ; for ahk_exe ExmSchSys.EXE

;; for 檢查排程系統
#IfWinActive - LibreOffice Calc
#c::
  CopyPidAndLaunchPacsWorklist()
Return
#IfWinActive  ; for LibreOffice Calc

