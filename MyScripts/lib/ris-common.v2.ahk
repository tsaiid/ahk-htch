; RIS specific functions

SleepThenTab(sleepTime := 400, shiftTab := true)
{
  Sleep sleepTime
  if (shiftTab) {
    Send "+{Tab}"
  } else {
    Send "{Tab}"
  }
}

; need to reimplant
GetGenderFromRIS() {
}

GetAgeFromRIS() {
}

; ==============================================================================
; [核心邏輯] 檢查是否存在陽性詞，且「未被否定詞修飾」 (精準排除當行前贅詞判斷)
; 參數:
;   text: 完整的報告內容
;   keywords: 關鍵字陣列 (例如 ["scoliosis", "curve"])
; 回傳:
;   true (只要有任何一行出現該關鍵字且未被否定，即回傳 true)
; ==============================================================================
HasPositiveFinding(text, keywords) {
    for kw in keywords {
        ; 建立正規表達式，確保比對的是完整單字 (\b)
        pattern := "i)\b" . kw . "\b"

        startPos := 1
        Loop {
            ; 尋找關鍵字的位置
            foundPos := RegExMatch(text, pattern, &match, startPos)
            if (!foundPos)
                break ; 找不到此關鍵字了，換下一個關鍵字測試

            ; === 1. 取得關鍵字「之前」的所有文字 ===
            precedingAll := SubStr(text, 1, foundPos - 1)

            ; === 2. 取得「當前這行」的前半段 ===
            ; 往前找最近的一個換行符號 (`n 或 `r)，以此截斷
            ; 這樣可以確保我們的否定詞只會管到「同一行」的 No
            lastLineBreak := Max(InStr(precedingAll, "`n", , -1), InStr(precedingAll, "`r", , -1))

            ; 取得該行開頭 (或文字開頭) 至關鍵字「之間」的文字
            currentLinePreceding := SubStr(precedingAll, lastLineBreak + 1)

            ; === 3. 否定詞判斷 (只針對 currentLinePreceding) ===
            ; 正則語法說明：
            ; \b(no|without|negative|free|unremarkable|absence)\b  -> 否定關鍵字
            ; [^,.;:]*$  -> 否定詞之後，直到行尾不能有「逗號、句號、分號、冒號」
            ;              (注意：這裡不需要加 \n，因為步驟 2 已經把換行截掉了)

            isNegated := RegExMatch(currentLinePreceding, "i)\b(no|without|negative|neg|free|unremarkable|absence)\b[^,.;:]*$")

            if (!isNegated) {
                ; 找到了一個「未被否定」的實體！
                ; 依照邏輯：只要文中有一處提及是陽性，就認定為陽性。
                return true
            }

            ; 如果這次出現的實體被判定為否定 (例如 "No scoliosis")
            ; 我們不回傳 false，而是更新 startPos，繼續往後找下一次出現的位置
            ; 因為下一行可能接著 "Mild scoliosis is noted."
            startPos := foundPos + StrLen(match[0])
        }
    }
    ; 跑完所有關鍵字的所有出現實體，都沒有發現陽性證據，回傳 false
    return false
}

; --- 輔助函式：標準 Oxford Comma 格式化 ---
FormatList(arr) {
    if (arr.Length == 0)
        return ""

    ; 只有 1 個項目，直接回傳
    if (arr.Length == 1)
        return arr[1]

    ; 只有 2 個項目：A and B (中間不加逗號)
    if (arr.Length == 2)
        return arr[1] " and " arr[2]

    ; 3 個或以上項目：使用 Oxford Comma (A, B, and C)
    str := ""
    loop arr.Length {
        if (A_Index == 1) {
            str .= arr[A_Index]
        } else if (A_Index == arr.Length) {
            str .= ", and " arr[A_Index] ; 最後一個加逗號與 and
        } else {
            str .= ", " arr[A_Index]
        }
    }
    return str
}
