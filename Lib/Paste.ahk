﻿; Paste(text, convertCRLF)
; 在送出 Ctrl-V 貼上後，可能要給系統一些等待的時間，
; 如果直接把 Clipboard 復原，會貼到舊的內容
; Source: http://www.autohotkey.com/board/topic/44917-paste-but-preserve-clipboard-simple/

Paste(text, convertCRLF = True) {
  global PRESERVE_CLIPBOARD

  If (convertCRLF) {
    text := RegExReplace(text, "(?<!\r)\n", "`n")
  }

  If (PRESERVE_CLIPBOARD) {
    ClipSaved := ClipboardAll
    Clipboard := text
    Send ^v
    Sleep 400 ; Probably more than enough. Depends on the system.
    Clipboard := ClipSaved
  } Else {
    Clipboard := text
    Send ^v
  }
}

; 原本的方法以為：
;; 因為把資料存入 Clipboard 要一點時間，
;; 所以用一個 Loop 來確保資料已經 copy 進去
