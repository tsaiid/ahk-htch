﻿; HotKey
;; Reordering the selected text

ReorderSelectedText(deOrder = False, keepEmptyLine = False, itemChar = "", discardSeIm = True){
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
