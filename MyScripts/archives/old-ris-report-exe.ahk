;
;
; For old RIS Report.exe
;
;

;; Only specific to the main Helios window
#IfWinActive ahk_exe Report.exe
;; Ctrl + 8
;; Reset window position and size
^8::
  WinGetPos, X, Y, Width, Height, ahk_exe Report.exe
  ;MsgBox, %X% %Y% %Width% %Height%
  WinMove, ahk_exe Report.exe, , 10, 400, 1026, 805
Return

ClearRISBugFindingsImpressions() {
  ControlGetText, t, TMemo6
  If (t = " ") {
    ClearAllFindings()
    ;MsgBox, %l%
  }
  ControlGetText, t, TMemo7
  If (t = " ") {
    ClearAllImpressions()
    ;MsgBox, b
  }
}

;; Ctrl + 0
;; Copy previous similar report
^Esc::
  ; Get Accno From Edit
  accno := GetAccNoFromRIS()
  If (accno) {
    ; For RIS bug, check if not empty, clear findings and impressions first.
    ClearRISBugFindingsImpressions()
    CopyPrevSimilarReport(accno)
  } Else {
    MsgBox, No AccNo!
  }
Return

;; Win + A
;; Select all
#a::
  ControlGetFocus, FocusedControl
  If (FocusedControl = "TMemo6" || FocusedControl = "TMemo7") {
    ControlGet, FocusedControlId, Hwnd,, %FocusedControl%
    Edit_SelectAll(	FocusedControlId )
  }
Return

;; Win + V
;; Copy current line or selection to Impression Edit
#v::
  ControlGetFocus, FocusedControl
  If (FocusedControl = "TMemo6") {
    ControlGet, hEdit, Hwnd,, %FocusedControl%
    Edit_GetSel(hEdit, currStartSel, currEndSel)
    ;msgbox, %currStartSel% %currEndSel%
    ; If a selection has already been made,
    ;   do not extent the selection to whole line,
    ;   just copy it.
    If (currStartSel == currEndSel) {
      l_text := Edit_GetTextRange(hEdit, 0, currStartSel)
      l_FoundPos:=InStr(l_Text, "`r`n",, 0)
      If (l_FoundPos > 0) {
        startSel := l_FoundPos + 1
      } Else {
        startSel := 0
      }
      r_text := Edit_GetTextRange(hEdit, currStartSel, -1)
      r_FoundPos:=InStr(r_Text, "`r`n")
      If (r_FoundPos > 0) {
        endSel := currStartSel + r_FoundPos + 1
      } Else {
        endSel := -1
      }
      Edit_SetSel(hEdit, startSel, endSel)
    }
    Edit_Copy(hEdit)
    Edit_SetSel(hEdit, currStartSel, currEndSel)

    ControlGet, ImpEditId, Hwnd,, TMemo7
    Edit_SetSel(ImpEditId, Edit_GetTextLength(ImpEditId))
    Edit_Paste(ImpEditId)
  }

  ;SendEvent {Home}+{End}^c
Return

;; Win + C
;; Copy and combine Findings and Impressions
#c::
  ControlGetFocus, FocusedControl
  If (FocusedControl = "TMemo6" || FocusedControl = "TMemo7") {
    ControlGet, hEdit6, Hwnd,, TMemo6
    ControlGet, hEdit7, Hwnd,, TMemo7
    allText := Edit_GetText(hEdit6)
    If (Edit_GetTextLength(hEdit7)) {
      allText .= "`r`n`r`nIMPRESSION:`r`n" . Edit_GetText(hEdit7)
    }
    ;MsgBox, %allText%
    Clipboard := allText
  }
Return

;; Remap Kana Key
SC070::
  OrderListForImpression()
Return

SC079::
  OrderListForFindings()
Return

StrPutVar(string, ByRef var, encoding)
{
    ; Ensure capacity.
    VarSetCapacity( var, StrPut(string, encoding)
        ; StrPut returns char count, but VarSetCapacity needs bytes.
        * ((encoding="utf-16"||encoding="cp1200") ? 2 : 1) )
    ; Copy or convert the string.
    return StrPut(string, &var, encoding)
}

InitEdgeAcc() {
  global WebRISisInit

  EXAMNAME_PATH := "4.1.1.4.3.1.1.3.2.1.3.1.1.1.8.1.1.1.11.2"

  If WinActive("WebRIS") {
    hWnd := WinExist("A")
    SendMessage, WM_GETOBJECT := 0x003D, 0, 1, Chrome_RenderWidgetHostHWND1, % "ahk_id " hWnd
    ; first time, all acc children need to be gone through
    cbAcc := Acc_Get("Object", EXAMNAME_PATH, 0, "ahk_id " hWnd)
    if !IsObject(cbAcc) {
      accChrome := Acc_ObjectFromWindow(hWnd)
      GoThroughAcc(accChrome)
      Loop 50 {
        Sleep, 100
        cbAcc := Acc_Get("Object", EXAMNAME_PATH, 0, "ahk_id " hWnd)
        ;if (StrLen(cbAcc.accDefaultAction(0))) {
        if (StrLen(cbAcc.accName(0))) {
          WebRISisInit := 1
          break
        }
      }
    }
  }
}

PasteExamname()
{
  If WinActive("WebRIS") {
    examname := GetExamnameFromRIS()
    If (examname) {
      examname_text := Examname . ":`n`n`n"
      Paste(examname_text)
    } Else {
      MsgBox, No examname found.
    }
  }
}

PasteExamname_Old()
{
  If WinActive("ahk_exe Report.exe") {
    ControlGetFocus, FocusedControl
    If (FocusedControl = "TMemo6" || FocusedControl = "TMemo7") {
      ControlGet, hFindingEdit, Hwnd,, TMemo6
      Edit_GetSel(hFindingEdit, currStartSel, currEndSel)
      examname := GetExamnameFromRIS()
      If (examname) {
        examname_text := Examname . ":`r`n`r`n"
        Edit_SetText(hFindingEdit, examname_text . Edit_GetText(hFindingEdit))
        newStartSel := currStartSel + StrLen(examname_text)
        newEndSel := currEndSel + StrLen(examname_text)
        Edit_SetSel(hFindingEdit, newStartSel, newEndSel)
      } Else {
        MsgBox, No examname found.
      }
    }
  }
}

PasteExamnameAndContrast()
{
  global CONTRAST_STR
  If WinActive("WebRIS") {
    examname := GetExamnameFromRIS()
    contrast := GetContrastFromRIS()
    If (examname) {
      examname_text := Examname
      If (contrast) {
        examname_text .= CONTRAST_STR[contrast]
      }
      examname_text .= ":`n`n`n"
      Paste(examname_text)
    } Else {
      MsgBox, No examname found.
    }
  }
}

PasteExamnameAndContrast_Old()
{
  global CONTRAST_STR
  If WinActive("ahk_exe Report.exe") {
    ControlGetFocus, FocusedControl
    If (FocusedControl = "TMemo6" || FocusedControl = "TMemo7") {
      ControlGet, hFindingEdit, Hwnd,, TMemo6
      Edit_GetSel(hFindingEdit, currStartSel, currEndSel)
      examname := GetExamnameFromRIS()
      contrast := GetContrastFromRIS()
      If (examname) {
        examname_text := Examname
        If (contrast) {
          examname_text .= CONTRAST_STR[contrast]
        }
        examname_text .= ":`r`n`r`n"
        Edit_SetText(hFindingEdit, examname_text . Edit_GetText(hFindingEdit))
        newStartSel := currStartSel + StrLen(examname_text)
        newEndSel := currEndSel + StrLen(examname_text)
        Edit_SetSel(hFindingEdit, newStartSel, newEndSel)
      } Else {
        MsgBox, No examname found.
      }
    }
  }
}

ReplaceExamname()
{
  If WinActive("ahk_exe Report.exe") {
    ControlFocus, TMemo6  ; need to get focus. ReorderSelectedText() use focused edit.
    ControlGet, hEdit, Hwnd,, TMemo6
    endSel := Edit_FindText(hEdit, ".+show(s|ed)?[:\.\s]*|.+\R{1,2}", , , "RegEx", matchedText)
    If (endSel > -1) {
      endSel += StrLen(matchedText)
      Edit_SetSel(hEdit, 0, endSel)
      Edit_Clear(hEdit)
      PasteExamname()
    }
  }
}

;; Alt + E
;; Paste Examname
!e::
  ; For RIS bug, check if not empty, clear findings and impressions first.
  ClearRISBugFindingsImpressions()
  PasteExamname()
Return

;; Ctrl + Alt + Shift + E
;; Paste Examname with contrast informtion
^!+e::
  ; For RIS bug, check if not empty, clear findings and impressions first.
  ClearRISBugFindingsImpressions()
  PasteExamnameAndContrast()
Return

;; Ctrl + Alt + E
;; Replace Examname
^!e::
  ; For RIS bug, check if not empty, clear findings and impressions first.
  ClearRISBugFindingsImpressions()
  ReplaceExamname()
Return


;; Alt + D
;; Paste PrevExamDate
;!d::
;  global prevExamDate
;  ControlGetFocus, FocusedControl
;  If (FocusedControl = "TMemo6" || FocusedControl = "TMemo7") {
;    ControlGet, hEdit, Hwnd,, %FocusedControl%
;    Edit_ReplaceSel(hEdit, SplitDate(prevExamDate))
;  }
;Return

#x::
;SendMessage, 0x100, 0x28,, TDBGrid1
;SendMessage, 0x101, 0x28,, TDBGrid1
;ControlSend, TDBGrid1, {Down}
ControlGet, hFindingEdit, Hwnd,, TInplaceEdit1
MsgBox % hFindingEdit
return

;; Ctrl + Y
;; Delete current line
^y::
  ControlGetFocus, FocusedControl
  If (FocusedControl = "TMemo6" || FocusedControl = "TMemo7") {
    ControlGet, hEdit, Hwnd,, %FocusedControl%
    ;p_LineIdx:=Edit_LineFromChar(hEdit,Edit_LineIndex(hEdit))
    ;l_StartSelPos:=Edit_LineIndex(hEdit,p_LineIdx)
    Edit_GetSel(hEdit, currStartSel)
    l_text := Edit_GetTextRange(hEdit, 0, currStartSel)
    l_FoundPos:=InStr(l_Text, "`r`n",, 0)
    If (l_FoundPos > 0) {
      startSel := l_FoundPos + 1
    } Else {
      startSel := 0
    }
    r_text := Edit_GetTextRange(hEdit, currStartSel, -1)
    r_FoundPos:=InStr(r_Text, "`r`n")
    If (r_FoundPos > 0) {
      endSel := currStartSel + r_FoundPos + 1
    } Else {
      endSel := -1
      ;MsgBox, %currStartSel% %r_FoundPos%
    }
    Edit_SetSel(hEdit, startSel, endSel)
    ;text_len := Edit_GetTextLength(hEdit)
    ;MsgBox, %startSel% %endSel% %text_len%
    Edit_Clear(hEdit)
  }
Return

;; Ctrl + Shift + Y
;; Delete to end of file
^+y::
  ControlGetFocus, FocusedControl
  If (FocusedControl = "TMemo6" || FocusedControl = "TMemo7") {
    ControlGet, hEdit, Hwnd,, %FocusedControl%
    Edit_GetSel(hEdit, currStartSel)
    Edit_SetSel(hEdit, currStartSel, -1)
    Edit_Clear(hEdit)
  }
Return

;; Ctrl + K
;; delete to the end of line
^k::
  ControlGetFocus, FocusedControl
  If (FocusedControl = "TMemo6" || FocusedControl = "TMemo7") {
    ControlGet, hEdit, Hwnd,, %FocusedControl%
    Edit_GetSel(hEdit, startSel)
    l_text := Edit_GetTextRange(hEdit, startSel)
    l_FoundPos:=InStr(l_Text, "`r`n")
    ;MsgBox % l_FoundPos
    If (l_FoundPos > 0) {
      endSel := startSel + l_FoundPos - 1
    } Else {
      endSel := Edit_GetTextLength(hEdit)
    }
    Edit_SetSel(hEdit, startSel, endSel)
    Edit_Clear(hEdit)
    ;Edit_DeleteLine(	FocusedControlId )
  }
Return

FindPrevCRLF(text) {
  found_pos := InStr(text, "`r`n",, 0)
  If (found_pos > 0) {
    found_pos := found_pos + 1
  } Else {
    found_pos := 0
  }
  Return found_pos
}

;; Ctrl + U
;; delete to the start of line
^u::
  ControlGetFocus, FocusedControl
  If (FocusedControl = "TMemo6" || FocusedControl = "TMemo7") {
    ControlGet, hEdit, Hwnd,, %FocusedControl%
    Edit_GetSel(hEdit, currStartSel)
    l_text := Edit_GetTextRange(hEdit, 0, currStartSel)
    l_FoundPosCRLF := FindPrevCRLF(l_text)
    Edit_SetSel(hEdit, l_FoundPosCRLF, currStartSel)
    Edit_Clear(hEdit)
  }
Return

FindPrevText(text_to_find, needle_text, start_pos) {
  found_pos_space := InStr(text_to_find, needle_text,, 0)
  If (found_pos_space > 0) {
    If (found_pos_space = start_pos) {
      sub_text := SubStr(text_to_find, 1, found_pos_space - 1)
      found_pos_space := FindPrevText(sub_text, needle_text, found_pos_space - 1)
    }
  }

  ; should not cross to previous line
  found_pos_crlf := FindPrevCRLF(text_to_find)
  If (found_pos_crlf >= found_pos_space) {
    found_pos_space := found_pos_crlf
  }

  Return found_pos_space
}
;; Ctrl + W
;; delete previous word
^w::
  ControlGetFocus, FocusedControl
  If (FocusedControl = "TMemo6" || FocusedControl = "TMemo7") {
    ControlGet, hEdit, Hwnd,, %FocusedControl%
    Edit_GetSel(hEdit, currStartSel)
      ;MsgBox % currStartSel
    If (currStartSel > 0) { ; if at the beginning of text, do nothing
      l_text := Edit_GetTextRange(hEdit, 0, currStartSel - 1)
      l_FoundPos := FindPrevText(l_text, " ", currStartSel)
      ;MsgBox, %currStartSel% %l_FoundPos%
      Edit_SetSel(hEdit, l_FoundPos, currStartSel)
      Edit_Clear(hEdit)
    }
  }
Return
;; Ctrl + Shift + W
;; delete previous sentence
^+w::
  ControlGetFocus, FocusedControl
  If (FocusedControl = "TMemo6" || FocusedControl = "TMemo7") {
    ControlGet, hEdit, Hwnd,, %FocusedControl%
    Edit_GetSel(hEdit, currStartSel)
      ;MsgBox % currStartSel
    If (currStartSel > 0) { ; if at the beginning of text, do nothing
      l_text := Edit_GetTextRange(hEdit, 0, currStartSel - 1)
      l_FoundPosPeriod := FindPrevText(l_text, ".", currStartSel)
      l_FoundPosComma := FindPrevText(l_text, ",", currStartSel)
      l_FoundPosColon := FindPrevText(l_text, ";", currStartSel)
      l_FoundPos := Max(l_FoundPosPeriod, l_FoundPosComma, l_FoundPosColon)
      ;MsgBox, %currStartSel% %l_FoundPos%
      Edit_SetSel(hEdit, l_FoundPos, currStartSel)
      Edit_Clear(hEdit)
    }
  }
Return

^+Up::
  Send +{PgUp}
Return

^+Down::
  ControlGetFocus, FocusedControl
  If (FocusedControl = "TMemo6" || FocusedControl = "TMemo7") {
    ControlGet, hEdit, Hwnd,, %FocusedControl%
    Edit_GetSel(hEdit, prevStartSel, prevEndSel)
    Send +{PgDn}
    Edit_GetSel(hEdit, newStartSel, newEndSel)
    If (newEndSel = prevEndSel) {
      ;Send +{Down}
      r_text := Edit_GetTextRange(hEdit, prevEndSel)
      r_FoundPos:=InStr(r_Text, "`r`n")
      If (r_FoundPos > 0) {
        newEndSel := prevEndSel + r_FoundPos + 1
      } Else {
        newEndSel := Edit_GetTextLength(hEdit)
      }
      Edit_SetSel(hEdit, prevStartSel, newEndSel)
    }
  }
  ;Send +{PgDn}
Return

+Down::
  ControlGetFocus, FocusedControl
  If (FocusedControl = "TMemo6" || FocusedControl = "TMemo7") {
    ControlGet, hEdit, Hwnd,, %FocusedControl%
    Edit_GetSel(hEdit, prevStartSel, prevEndSel)
    Send +{Down}
    Edit_GetSel(hEdit, newStartSel, newEndSel)
    If (newEndSel = prevEndSel) {
      newEndSel := Edit_GetTextLength(hEdit)
      Edit_SetSel(hEdit, prevStartSel, newEndSel)
    }
  }
Return

;;; https://autohotkey.com/board/topic/9885-control-tab-n/
SwitchToTabN(t_TabControl, t_TabNumber, t_Wintitle="")
{
  If t_TabControl is not number
    ControlGet, t_TabControl, Hwnd,, %t_TabControl%, %t_WinTitle%
  WinGet, t_tabStyle, Style, ahk_id %t_TabControl%
  If (t_tabStyle & 0x100) { ; buttons are enabled - remove TCS_BUTTONS style
    WinSet, Style, -0x100, ahk_id %t_TabControl%
    t_tbuttons = 1
  }
  SendMessage, 0x1330, %t_TabNumber%,,, ahk_id %t_TabControl%  ; 0x1330 is TCM_SETCURFOCUS
  sleep, 0 ; to prevent redraw issues
  SendMessage, 0x130C, %t_TabNumber%,,, ahk_id %t_TabControl%  ; 0x130C is TCM_SETCURSEL
  If (t_tbuttons)
    WinSet, Style, +0x100, ahk_id %t_TabControl%
}

^1::
  SwitchToTabN("TPageControl1", 0)
Return

^2::
  SwitchToTabN("TPageControl1", 1)
Return

^3::
  global FocusedControl
  ControlGetFocus, FocusedControl

  DiffHistoryBtns := ["TBitBtn3", "TBitBtn5", "TBitBtn7", "TBitBtn9"]
  For idx, btn in DiffHistoryBtns {
    ControlGetText, t, %btn%
    if (t = "F3)看歷史報告" || t = "查歷史報告") {
      ControlClick, %btn%
      Return
    }
  }

  MsgBox, btnHistory's Class(NN) may be changed.
Return

!1::
  ControlClick, TRadioButton4
Return

!2::
  ControlClick, TRadioButton3
Return

!3::
  ControlClick, TRadioButton2
Return

!4::
  ControlClick, TRadioButton1
Return

Esc:: ;; use ESC to close some windows
  If (WinActive("查詢歷史報告")) {
    global FocusedControl
    ControlGet, isPopHisReport, Visible,, TBitBtn6
    ;MsgBox % isPopHisReport
    If (isPopHisReport) {
      ControlClick, TBitBtn6
    } Else {
      ControlClick, TBitBtn1
      ;MsgBox % FocusedControl
      Sleep, 100
      ControlFocus, %FocusedControl%, ahk_exe Report.exe
    }
  } Else If (WinActive("醫師報告 ahk_exe Helios.exe")) {
    hHeliosReportSumWnd := WinExist("醫師報告 ahk_exe Helios.exe")
    If (hHeliosReportSumWnd) {
      reportSumWinCloseBtnObj := Acc_Get("Object", "4.1", 0, "ahk_id " hHeliosReportSumWnd)
      reportSumWinCloseBtnObj.accDoDefaultAction(0)
    }
  } Else If (WinActive("SOA ahk_exe Helios.exe")) {
    WinClose
  } Else {
    ;MsgBox, else
    Send {Esc}
  }
Return

WheelUp::
  MouseGetPos, , , , nameControlUnderCursor
  If (nameControlUnderCursor = "TDBGrid1") {
    ControlSend, TDBGrid1, {PgUp}
  } Else {
    Send {WheelUp}
  }
Return

WheelDown::
  MouseGetPos, , , , nameControlUnderCursor
  If (nameControlUnderCursor = "TDBGrid1") {
    ControlSend, TDBGrid1, {PgDn}
  } Else {
    Send {WheelDown}
  }
Return

AddNewlineToEndOfFile() {
  ControlGet, hEdit, Hwnd,, TMemo6
  if (hEdit) {
    fdTxt := Edit_GetText(hEdit)
    eof := SubStr(fdTxt, -1)  ; get last two chars
    if (eof != "`r`n") {
      ;MsgBox, ""%eof%""
      ;MsgBox, ""%fdTxt%""
      Edit_SetText(hEdit, fdTxt . "`r`n")
    }
  }
}

FillImpression() {
  ControlGet, hEdit, Hwnd,, TMemo7
  if (hEdit) {
    len := Edit_GetTextLength(hEdit)
    if (!len) {
      Edit_SetText(hEdit, "As aforementioned.")
    }
  }
}

;; Make Unorder List of Finding Edit Before Saving for DX only
UnorderListForFindingsOfDxUs()
{
  ;startSel := Edit_FindText(hEdit, ":`r`n`r`n")
  str := Clipboard
  FoundPos := RegExMatch(str, "O`as)^(\S+:\s+)(\S.+)", SubPat)
  ;FoundPos := RegExMatch(str, "O):\s*`a\s*`a(.+)", SubPat)
  ;MsgBox % SubPat.Count() ": " SubPat.Value(1)
  re := __ReorderSelectedText(SubPat.Value(2), false, false, "-")
  MsgBox % SubPat.Value(1) . re
  Return
  startSel := Edit_FindText(hEdit, "FINDINGS:`r`n", , , "RegEx", matchedText)
  If (startSel == -1) {
    startSel := Edit_FindText(hEdit, "FINDINGS:`r`n|:\s*`r`n\s*`r`n", , , "RegEx", matchedText)
  }
  If (startSel > -1) {
    ;startSel += 5
    startSel += StrLen(matchedText)
    ;MsgBox % startSel
    Edit_SetSel(hEdit, startSel, -1)
    __ReorderSelectedText(false, false, "-")
  }
}

UnorderListForFindingsOfDxUs_Old()
{
  examtype := GetExamTypeFromRIS()
  ;MsgBox, %examtype%
  If (examtype = "DX" || examtype = "US") {
    ControlFocus, TMemo6  ; need to get focus. ReorderSelectedText() use focused edit.
    ControlGet, hEdit, Hwnd,, TMemo6
    ;startSel := Edit_FindText(hEdit, ":`r`n`r`n")
    startSel := Edit_FindText(hEdit, "FINDINGS:`r`n", , , "RegEx", matchedText)
    If (startSel == -1) {
      startSel := Edit_FindText(hEdit, "FINDINGS:`r`n|:\s*`r`n\s*`r`n", , , "RegEx", matchedText)
    }
    If (startSel > -1) {
      ;startSel += 5
      startSel += StrLen(matchedText)
      ;MsgBox % startSel
      Edit_SetSel(hEdit, startSel, -1)
      ReorderSelectedText(false, false, "-")
    }
  }
}

UnorderListForFindingsOfCtOrMr()
{
  examtype := GetExamTypeFromRIS()
  If (examtype = "CT" || examtype = "MR" || examtype = "MRI") {
    ControlGet, hEdit, Hwnd,, TMemo6
    startSel := Edit_FindText(hEdit, "FINDINGS:`r`n|The study shows:`r`n`r`n|show the following findings:`r`n`r`n|which revealed:`r`n`r`n", , , "RegEx", matchedText)
    ;startSel := Edit_FindText(hEdit, "(FINDINGS:`r`n|COMPARISON:)", , , "RegEx", matchedText)
    If (startSel > -1) {
      ;startSel += 11
      startSel += StrLen(matchedText)
      Loop, 3 {
        newStartSel := startSel
        startText := Edit_GetTextRange(hEdit, newStartSel, newStartSel + 1)
        ;MsgBox % startText
        if (startText = "* ") {
          newStartSel := Edit_FindText(hEdit, "`r`n", newStartSel)
          ;MsgBox % startSel
          if (newStartSel > -1) {
            startSel := newStartSel + 2
          }
        } else {
          break
        }
      }

      endSel := Edit_FindText(hEdit, "REMARKS?:|RECOMMENDATION:", , , "RegEx")  ; -1 if not found
      if (endSel > -1) {
        endSel -= 2
      }
      Edit_SetFocus(hEdit)
      Edit_SetSel(hEdit, startSel, endSel)
      ReorderSelectedText(false, true, "-")
      ;MsgBox % regex_out
    }
  }
}

OrderListForFindings()
{
  ;ControlGetText, examtype, TLabeledEdit11
  examtype := GetExamTypeFromRIS()
  ;MsgBox, "%examtype%"
  Switch examtype
  {
    case "CT", "MR", "MRI":
      UnorderListForFindingsOfCtOrMr()

    case "DX", "US":
      UnorderListForFindingsOfDxUs()
  }
}

OrderListForImpression()
{
  ControlGet, hEdit, Hwnd,, TMemo7
  impStr := Edit_GetText(hEdit)
  If (StrLen(impStr)) {
    impStrArr := StrSplit(impStr, "`r`n")
    CRLFCount := 0
    For i, v in impStrArr {
      If (StrLen(v)) {
        CRLFCount++
      }
    }
    Edit_SetFocus(hEdit)
    Edit_SetSel(hEdit)
    If (CRLFCount > 1) {
      ReorderSelectedText()
    } Else {
      ReorderSelectedText(true)
    }
  }
}

^6::
  OrderListForFindings()
Return

^7::
  OrderListForImpression()
Return

CheckAutoNextReportCheckBox() {
  CheckUncheckAutoNextReportCheckBox(True)
}
UncheckAutoNextReportCheckBox() {
  CheckUncheckAutoNextReportCheckBox(False)
}
CheckUncheckAutoNextReportCheckBox(check = True) {
  DiffNextChkBoxs := ["TCheckBox2", "TCheckBox17", "TCheckBox18"]
  For idx, box in DiffNextChkBoxs {
    ControlGetText, t, %box%
    if (t = "自動帶入下一筆未打報告") {
      If (check) {
        Control, Check, , %box%
      } Else {
        Control, Uncheck, , %box%
      }
      Return
    }
  }

  MsgBox, NextChkBox's Class(NN) may be changed.
}

!c::
  UncheckAutoNextReportCheckBox()
  FillImpression()
  AddNewlineToEndOfFile()

  DiffSaveBtns := ["TBitBtn12", "TBitBtn14", "TBitBtn16"]
  For idx, btn in DiffSaveBtns {
    ControlGetText, t, %btn%
    if (t = "F2)存檔") {
      ControlClick, %btn%
      Return
    }
  }

  MsgBox, btnSave's Class(NN) may be changed.
Return

ReactivateRisAfterReady(timeOut = 10) {
  maxLoopCount := timeOut * 10
  reactiveCount := 0
  Loop, %maxLoopCount% {
    If (WinActive("INFINITT PACS") || reactiveCount > 4) {
      WinActivate, ahk_exe Report.exe
      reactiveCount += 1
      ;MsgBox, A
      Break
    }

    Sleep, 100
  }
  ;WinGetTitle, t, A
  ;MsgBox % t
}

^s::
  CheckAutoNextReportCheckBox()
  AddNewlineToEndOfFile()
  UnorderListForFindingsOfDxUs()
  OrderListForImpression()
  FillImpression()

  DiffSaveBtns := ["TBitBtn12", "TBitBtn14", "TBitBtn16"]
  For idx, btn in DiffSaveBtns {
    ControlGetText, t, %btn%
    if (t = "F2)存檔") {
      ControlClick, %btn%
      Return
    }
  }

  MsgBox, btnSave's Class(NN) may be changed.
  ;ReactivateRisAfterReady()
Return

!x::
  ControlClick, TBitBtn11
  ;ReactivateRisAfterReady()
Return

!Up::
  ControlFocus, TMemo6, ahk_exe Report.exe
Return

!Down::
  ControlFocus, TMemo7, ahk_exe Report.exe
Return

MoveCaretToFindings()
{
  examtype := GetExamTypeFromRIS()
  ;MsgBox % examtype
  If (examtype = "CT" || examtype = "MR") {
    ControlGet, hEdit, Hwnd,, TMemo6
    curr_line := Edit_GetFirstVisibleLine(hEdit)
    startSel := Edit_FindText(hEdit, "FINDINGS:`r`n")
    ;startSel := Edit_FindText(hEdit, "(FINDINGS:`r`n|COMPARISON:)", , , "RegEx", matchedText)
    If (startSel > -1) {
      startSel += 11
      Edit_SetSel(hEdit, startSel, startSel)
      Edit_ScrollCaret(hEdit)
      new_line := Edit_GetFirstVisibleLine(hEdit)
      ;MsgBox, %curr_line% %new_line%
      If (new_line != curr_line) {
        Edit_Scroll(hEdit, 0, -1)
      }
      Edit_SetFocus(hEdit)
    }
  }
}

^t::
  MoveCaretToFindings()
Return

ClearAllFindings()
{
  ControlGet, hEdit, Hwnd,, TMemo6
  Edit_SetSel(hEdit)
  Edit_Clear(hEdit)
}

ClearAllImpressions()
{
  ControlGet, hEdit, Hwnd,, TMemo7
  Edit_SetSel(hEdit)
  Edit_Clear(hEdit)
}

#d::
  ControlGetFocus, FocusedControl
  If (FocusedControl = "TMemo6" || FocusedControl = "TMemo7") {
    ClearAllFindings()
    ClearAllImpressions()
  }
Return

#+d::
  ControlGetFocus, FocusedControl
  If (FocusedControl = "TMemo6" || FocusedControl = "TMemo7") {
    ClearAllImpressions()
  }
Return
#IfWinActive  ; ahk_exe Report.exe




;SC029::
;  If (!WinActive("ahk_exe Report.exe")) {
;    WinActivate, ahk_exe Report.exe
;    ControlFocus, TMemo6, ahk_exe Report.exe
;  }
;  ControlGetFocus, FocusedControl
;  If (FocusedControl = "TMemo6") {
;    ControlFocus, TMemo7
;  } Else {
;    ControlFocus, TMemo6
;  }
;Return






; RIS specific functions

SleepThenTab(sleepTime = 400, shiftTab = True)
{
  Sleep %sleepTime%
  If (shiftTab) {
    Send +{Tab}
  } Else {
    Send {Tab}
  }
}

GetGenderFromRIS()
{
  global AllGenderLists
  PossibleGenderEdits := ["TLabeledEdit11", "TLabeledEdit12"]
  For idx, box in PossibleGenderEdits {
    ControlGetText, t, %box%
    if t in %AllGenderLists%
      Return t
  }
}

GetAgeFromRIS()
{
  PossibleAgeEdits := ["TLabeledEdit3", "TLabeledEdit4"]
  For idx, box in PossibleAgeEdits {
    ControlGetText, t, %box%
    if (RegExMatch(t, "(\d+)((\D)+(\d+))?"))
      Return t
  }
}

GetExamTypeFromRIS()
{
  global AllExamTypeLists
  PossibleExamTypeEdits := ["TLabeledEdit10", "TLabeledEdit11"]
  For idx, box in PossibleExamTypeEdits {
    ControlGetText, t, %box%
    if t in %AllExamTypeLists%
      Return t
  }
}

GetAccNoFromRIS()
{
  PossibleAccNoEdits := ["TLabeledEdit15", "TLabeledEdit16"]
  For idx, box in PossibleAccNoEdits {
    ControlGetText, t, %box%
    if (RegExMatch(t, "A\d{15}"))
      Return t
  }
}

GetExamnameFromRIS()
{
  PossibleExamnameEdits := ["TEdit2", "TEdit3"]
  For idx, box in PossibleExamnameEdits {
    ControlGetPos, x, y, w, h, %box%
    if (x = 24 && y = 246) {
      ControlGetText, t, %box%
      Return t
    }
  }
}

GetContrastFromRIS()
{
  PossibleContrastEdits := ["TLabeledEdit3"]
  For idx, box in PossibleContrastEdits {
    ControlGetPos, x, y, w, h, %box%
    if (x = 512 && y = 246) {
      ControlGetText, t, %box%
      Return t
    }
  }
}

GetObjectiveFromRIS()
{
  PossibleObjectiveEdits := ["TMemo4"]
  For idx, box in PossibleObjectiveEdits {
    ControlGetPos, x, y, w, h, %box%
    if (x = 352 && y = 294) {
      ControlGetText, t, %box%
      Return t
    }
  }
}




__ReorderSelectedText(str, deOrder = False, keepEmptyLine = False, itemChar = "", discardSeIm = True){
  isSpine := false

  selectedText := str

  StringReplace, selectedText, selectedText, `r`n, `n, All

  StringRight, strRight, selectedText, 1
  If (Ord(strRight) == Ord("`n")) {
    StringTrimRight, selectedText, selectedText, 1
    hadTrimmedRight := True
  }

  StringSplit, txtAry, selectedText, `n
  endLine := txtAry0

  ;msgbox % selectedText

  ; get selected text
  If (StrLen(selectedText) > 0) {
    finalText := ""
    isFirstLineEmpty := false
    ; check if first chars are numbers, than use as start line no.
    If (RegExMatch(selectedText, "^(\d+)", existLineNo)) {
      startLineNo := existLineNo1
    } Else {
      startLineNo := 1
    }
    Loop, Parse, selectedText, `n
    {
      ;MsgBox, %A_Index%: "%A_Loopfield%"
      ; check if first line is empty, than discard even lines.
      If (A_Index == 1 && !StrLen(A_LoopField)) {
        ;MsgBox, first line is empty.
        isFirstLineEmpty := true
      }
      ;MsgBox % A_LoopField
      If (!RegExMatch(A_LoopField, "^\s*$")) {
        ; check if is a spine report
        If (RegExMatch(A_LoopField, "^\s*[-\+\*]*\s*[Vv]arying degree")) {
          isSpine := true
        }
        If (!deOrder) {
          orderChar := (StrLen(itemChar) > 0 ? itemChar : startLineNo++ . ".")
          ; second order indentation if a spine level line
          If (isSpine && RegExMatch(A_LoopField, "^\s*[-\+\*]*\s*[CcTtLl]\d{1,2}-")) {
            finalText .= "--+ "
          } Else {
            finalText .= orderChar . " "
          }
        }

        tmpText := A_LoopField
        ; remove (Se/Im: ...) string
        If (StrLen(itemChar) = 0 && discardSeIm) {
          tmpText := RegExReplace(tmpText, "\s*\(Srs\/Img:[\s,-\/\d;]+\)", "")
          tmpText := RegExReplace(tmpText, "Mark L\d+:\s*", "")
        }

        ; remove unintended itemChar and uppercase the first char
        finalText .= RegExReplace(tmpText, "^(\s*)((\d+\.)|([-\+\*>=])|(\(?\d+\)))?(\s*)(\w?)(.*)", "$u7$8")

        If (A_Index < endLine || hadTrimmedRight) {
          finalText .= "`r`n"
        }
      } Else {
        ; use a para to control if all line is empty, ignore it, and do not append an \n
        ; Workaround for copying from WebRIS report area. <p> causes doubling the newlines.
        ; Keep only 1 newline
        ;If (keepEmptyLine && ((isFirstLineEmpty && !Mod(A_Index, 2)) || (!isFirstLineEmpty && Mod(A_Index, 2)))) {
        ;If (keepEmptyLine && Mod(A_Index, 2)) {
        If (isFirstLineEmpty) {
          If (A_Index == 1) {
            finalText .= A_LoopField . "`n"
          }
        }
        If (keepEmptyLine) {
          If (isFirstLineEmpty) {
            If (!Mod(A_Index, 2)) {
              finalText .= A_LoopField . "`n"
            }
          } Else {
            If (Mod(A_Index, 2)) {
              finalText .= A_LoopField . "`n"
            }
          }
          ;MsgBox, %A_Index%: empty line: "%A_LoopField%"
          ;finalText .= A_LoopField . "`r`n"
        }
      }
    }
    ;MsgBox, "%finalText%"
    ;MsgBox, %leftText%%finalText%%rightText%
    ;Edit_SetText(hEdit, leftText . finalText . rightText)
    ;Edit_SetSel(hEdit, currStartSel, currStartSel)
    Return finalText
  } Else {
    ; No selection. Do nothing.
    ;MsgBox, No content in the selection.
    Return
  }
}


ReorderSelectedText_Old(deOrder = False, keepEmptyLine = False, itemChar = "", discardSeIm = True){
  isSpine := false
  /*
  Clipboard := ""
  Send ^c
  Sleep, 400
  */
  ControlGetFocus, FocusedControl
  If (FocusedControl != "TMemo6" && FocusedControl != "TMemo7") {
    MsgBox, %FocusedControl%
    Return
  }

  ; get selected text
  ControlGet, hEdit, Hwnd,, %FocusedControl%
  Edit_GetSel(hEdit, currStartSel, currEndSel)
  selectedText := Edit_GetTextRange(hEdit, currStartSel, currEndSel - 1)
  ;leftText := Edit_GetTextRange(hEdit, 0, currStartSel - 1)
  ;rightText := Edit_GetTextRange(hEdit, currEndSel + 1, -1)

  StringReplace, selectedText, selectedText, `r`n, `n, All

  StringRight, strRight, selectedText, 1
  If (Ord(strRight) == Ord("`n")) {
    StringTrimRight, selectedText, selectedText, 1
    hadTrimmedRight := True
  }

  StringSplit, txtAry, selectedText, `n
  endLine := txtAry0

;  MsgBox, endLine = %endLine%, strRight = %ascStrRight%, ``n = %ascNewLine%

/*
  Loop, parse, clipboard, `n, `r
  {
    MsgBox, 4, , File number %A_Index% is %A_LoopField%.`n`nContinue?
    IfMsgBox, No, break
  }
*/

  If (StrLen(selectedText) > 0) {
    finalText := ""
    ; check if first chars are numbers, than use as start line no.
    If (RegExMatch(selectedText, "^(\d+)", existLineNo)) {
      startLineNo := existLineNo1
    } Else {
      startLineNo := 1
    }
    Loop, Parse, selectedText, `n
    {
      If (!RegExMatch(A_LoopField, "^\s*$")) {
        ; check if is a spine report
        If (RegExMatch(A_LoopField, "^\s*[-\+\*]*\s*[Vv]arying degree")) {
          isSpine := true
        }
        If (!deOrder) {
          orderChar := (StrLen(itemChar) > 0 ? itemChar : startLineNo++ . ".")
          ; second order indentation if a spine level line
          If (isSpine && RegExMatch(A_LoopField, "^\s*[-\+\*]*\s*[CcTtLl]\d{1,2}-")) {
            finalText .= "  + "
          } Else {
            finalText .= orderChar . " "
          }
        }

        tmpText := A_LoopField
        ; remove (Se/Im: ...) string
        If (StrLen(itemChar) = 0 && discardSeIm) {
          tmpText := RegExReplace(tmpText, "\s*\(Srs\/Img:[\s,-\/\d;]+\)", "")
          tmpText := RegExReplace(tmpText, "Mark L\d+:\s*", "")
        }

        ; remove unintended itemChar and uppercase the first char
        finalText .= RegExReplace(tmpText, "^(\s*)((\d+\.)|([-\+\*>=])|(\(?\d+\)))?(\s*)(\w?)(.*)", "$u7$8")

        If (A_Index < endLine || hadTrimmedRight) {
          finalText .= "`r`n"
        }
      } Else {
        ; use a para to control if all line is empty, ignore it, and do not append an \n
        If (keepEmptyLine) {
          finalText .= A_LoopField . "`r`n"
        }
      }
    }
    /*
    If (isEndNewLine){
      finalText .= "`n"
    }
    */

    ;textRange.text := finalText
    ;MsgBox % finalText
    ;Clipboard := finalText
    ;Send ^v
    ;MsgBox, %leftText%%finalText%%rightText%
    ;Edit_SetText(hEdit, leftText . finalText . rightText)
    ;Edit_SetSel(hEdit, currStartSel, currStartSel)
    Edit_ReplaceSel(hEdit, finalText)
    Return 0
  } Else {
    ; No selection. Do nothing.
    ;MsgBox, No content in the selection.
    Return -1
  }
}