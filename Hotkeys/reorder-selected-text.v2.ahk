#Requires AutoHotkey v2.0

; HotKey
;; Reordering the selected text

ReorderSelectedText(deOrder := false, keepEmptyLine := false, itemChar := "", discardSeIm := true) {
  global PRESERVE_CLIPBOARD

  isSpine := false
  hadTrimmedRight := false

  if (PRESERVE_CLIPBOARD) {
    ClipSaved := ClipboardAll()
    A_Clipboard := ""
    Send "^c"
    Sleep 400
  } else {
    A_Clipboard := ""
    Send "^c"
    Sleep 400
  }

  selectedText := StrReplace(A_Clipboard, "`r`n", "`n")

  if (SubStr(selectedText, -1) = "`n") {
    selectedText := SubStr(selectedText, 1, -1)
    hadTrimmedRight := true
  }

  txtAry := StrSplit(selectedText, "`n")
  endLine := txtAry.Length

  if (StrLen(selectedText) > 0) {
    finalText := ""
    isFirstLineEmpty := false
    startLineNo := RegExMatch(selectedText, "^(\d+)", &existLineNo) ? Integer(existLineNo[1]) : 1

    for index, line in txtAry {
      if (index == 1 && !StrLen(line))
        isFirstLineEmpty := true

      if (!RegExMatch(line, "^\s*$")) {
        if (RegExMatch(line, "^\s*[-\+\*]*\s*([Vv]arying degree|[Mm]ild).+causing:"))
          isSpine := true

        tmpText := line
        if (!deOrder) {
          orderChar := (StrLen(itemChar) > 0 ? itemChar : startLineNo++ . ".")
          if (isSpine && RegExMatch(line, "^\s*([-\+\*]*|-->)\s*([CcTtLl]\d{1,2}-.+$)", &matchedSpineLevel)) {
            finalText .= "-> "
            tmpText := matchedSpineLevel[2]
          } else {
            finalText .= orderChar . " "
          }
        }

        if (StrLen(itemChar) = 0 && discardSeIm) {
          tmpText := RegExReplace(tmpText, "\s*\(Srs\/Img:[\s,-\/\d;]+\)", "")
          tmpText := RegExReplace(tmpText, "Mark L\d+:\s*", "")
        }

        finalText .= RegExReplace(tmpText, "^(\s*)((\d+\.)|([-\+\*>=])|(\(?\d+\)))?(\s*)(\w?)(.*)", "$U7$8")

        if (index < endLine || hadTrimmedRight)
          finalText .= "`r`n"
      } else {
        if (isFirstLineEmpty && index == 1)
          finalText .= line . "`n"

        if (keepEmptyLine) {
          if (isFirstLineEmpty) {
            if (!Mod(index, 2))
              finalText .= line . "`n"
          } else if (Mod(index, 2)) {
            finalText .= line . "`n"
          }
        }
      }
    }

    A_Clipboard := finalText
    Send "^v"
    if (PRESERVE_CLIPBOARD)
      A_Clipboard := ClipSaved
    return 0
  }

  return -1
}
