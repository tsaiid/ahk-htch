#Requires AutoHotkey v2.0

Paste(text, convertCRLF := true) {
    ; --- 0. 內容前處理 ---
    if (convertCRLF) {
        ; 確保換行符號是 Windows 標準 (CRLF)
        text := StrReplace(text, "`r`n", "`n")
        text := StrReplace(text, "`n", "`r`n")
    }

    ; --- 1. 傳統剪貼簿貼上 ---
    ; 使用 Ctrl+V 讓貼上動作維持在鍵盤事件序列內，避免搶在 hotstring
    ; 內建 backspacing 前直接寫入 control，造成 abbreviation 殘留。

    ; 字數少直接打字
    if (StrLen(text) < 50) {
        SendText(text)
        return
    }

    ; 剪貼簿貼上流程
    SavedClip := ClipboardAll()
    A_Clipboard := ""
    A_Clipboard := text

    if !ClipWait(1) {
        MsgBox "Clipboard failed to set."
        A_Clipboard := SavedClip
        return
    }

    SetKeyDelay 50, 50
    SendEvent "^v"

    Sleep 300
    A_Clipboard := SavedClip
}
