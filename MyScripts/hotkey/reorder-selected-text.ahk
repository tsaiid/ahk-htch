; HotKey
;; Reordering the selected text

ReorderSelectedText(deOrder = False, keepEmptyLine = False, itemChar = "", discardSeIm = True){
  global PRESERVE_CLIPBOARD

  isSpine := false

  If (PRESERVE_CLIPBOARD) {
    ClipSaved := ClipboardAll
    Clipboard := ""
    Send ^c
    Sleep 400 ; Probably more than enough. Depends on the system.
  } Else {
    Clipboard := ""
    Send ^c
    Sleep, 400
  }
  selectedText := Clipboard

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
    Clipboard := finalText
    Send ^v
    ;MsgBox, %leftText%%finalText%%rightText%
    ;Edit_SetText(hEdit, leftText . finalText . rightText)
    ;Edit_SetSel(hEdit, currStartSel, currStartSel)
    If (PRESERVE_CLIPBOARD) {
      Clipboard := ClipSaved
    }
    Return 0
  } Else {
    ; No selection. Do nothing.
    ;MsgBox, No content in the selection.
    Return -1
  }
}
