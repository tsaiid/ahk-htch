#Requires AutoHotkey v2.0

/*
  Function: hotstrings
    Dynamically adds regular expression hotstrings.

  Parameters:
    c - regular expression hotstring
    a - (optional) text to replace hotstring with or a label to call,
      leave blank to remove hotstring definition from triggering an action
    opts - (optional) options string; include "*" to trigger immediately without EndChars.
      By default (opts == ""), triggering follows AutoHotkey's Hotstring("EndChars") setting.

  Examples:
    hotstrings("([1-9])t([1-9])", "nr") ; follows Hotstring("EndChars") (e.g. Tab or Enter)
    hotstrings("i)omg", "oh my god{!}", "*") ; type 'OMG' in any case, triggers immediately
    hotstrings("\bcolou?r", "rgb(128, 255, 0);") ; '\b' prevents matching with anything before the word, e.g. 'multicololoured'

  License:
    - Version 2.59 <http://www.autohotkey.net/~polyethene/#hotstrings>
    - Dedicated to the public domain (CC0 1.0) <http://creativecommons.org/publicdomain/zero/1.0/>
    - Converted to AHK v2 by Gemini
*/

/*
  Function: hotstrings
    Dynamically adds regular expression hotstrings.
    AHK v2 Version.
*/

; 初始化全域變數，用於儲存 RegEx 捕獲結果
global hsMatch := ""

hotstrings(k, a := "", opts := "") {
    static z := false, m := "*~$", s := "", t := "", w := 2000, sd := "", d :=
        "Left,Right,Up,Down,Home,End,RButton,LButton", sendFn := "", sleepMs := 50

    ; 內部 callback 函數
    __hs(*) {
        hotstrings("", "")
    }

    __hsSend(str) {
        if (sendFn != "") {
            sendFn(str)
        } else {
            SendInput(str)
        }
    }

    __hsNormalizeKey(rawKey, applyPhysicalCase := false) {
        if (rawKey = "Space") {
            return " "
        }
        if (rawKey = "Tab") {
            return "`t"
        }
        if (rawKey = "Enter" || rawKey = "NumpadEnter") {
            return "`n"
        }
        if (RegExMatch(rawKey, "Numpad(.+)", &n)) {
            n1 := n[1]
            mapped := (n1 == "Div" ? "/" : n1 == "Mult" ? "*" : n1 == "Add" ? "+" : n1 == "Sub" ? "-" : n1 == "Dot" ? sd : "")
            if IsNumber(n1) {
                mapped := n1
            }
            return mapped
        }
        if (StrLen(rawKey) != 1) {
            return "{" . rawKey . "}"
        }
        if (applyPhysicalCase && (GetKeyState("Shift") ^ GetKeyState("CapsLock", "T"))) {
            return StrUpper(rawKey)
        }
        return rawKey
    }

    __hsFindMatch(buf, requireEndChar) {
        targetFlag := requireEndChar ? "1" : "0"
        loop parse, t, "`n" {
            if (A_LoopField == "") {
                continue
            }

            x := StrSplit(A_LoopField, "`r")
            if (x.Length < 2) {
                continue
            }

            pattern := x[1]
            action := x[2]
            useEndChars := (x.Length >= 3) ? x[3] : "1"
            if (useEndChars != targetFlag) {
                continue
            }

            ; --- 修正點：加入 "i)" 使其不區分大小寫 ---
            if (RegExMatch(buf, "i)" . pattern . "$", &match)) {
                return { pattern: pattern, action: action, match: match }
            }
        }
        return ""
    }

    __hsExecuteMatch(found, bsCount) {
        ; 發送退格鍵刪除觸發字串
        if (bsCount > 0) {
            __hsSend("{BS " . bsCount . "}")
        }

        ; 【關鍵修正】強制等待 50ms，確保應用程式處理完 Backspace
        ; 如果不加這個，後續 Paste() 使用 EditPaste 時會發生 race condition
        if (sleepMs > 0) {
            Sleep(sleepMs)
        }

        action := found.action
        match := found.match
        replacement := action
        loop match.Count {
            replacement := StrReplace(replacement, "%$" . A_Index . "%", match[A_Index])
        }

        global hsMatch := match

        try {
            %action%()
        } catch {
            __hsSend(replacement)
        }

        Hotstring("Reset")
    }

    if (k == "#Reset#") {
        s := ""
        return true
    }
    if (k == "#ClearRules#") {
        t := ""
        s := ""
        return true
    }
    if (k == "#GetBuffer#") {
        return s
    }
    if (k == "#SetBuffer#") {
        s := a
        return s
    }
    if (k == "#SetSendFn#") {
        sendFn := a
        if (opts != "") {
            sleepMs := Integer(opts)
        } else {
            sleepMs := (a == "" ? 50 : 0)
        }
        return true
    }
    if (k == "#CanTrigger#") {
        if (s == "" || StrLen(a) != 1) {
            return false
        }
        if (!InStr(Hotstring("EndChars"), a, true)) {
            return false
        }
        return IsObject(__hsFindMatch(s, true))
    }

    isTrigger := false
    isFeed := false
    q := ""
    if (k == "#TriggerKey#") {
        isTrigger := true
        q := a
    } else if (k == "#FeedKey#") {
        isFeed := true
        q := a
    }

    if (!z && !InStr(opts, "#NoHook#")) {
        try {
            sd := RegRead("HKCU\Control Panel\International", "sDecimal")
        } catch {
            sd := "."
        }

        HotIf()

        ; 註冊所有 ASCII 可見字元
        loop 94 {
            c := Chr(A_Index + 32)
            if (c == " ") { ; Space 會在下方單獨註冊
                continue
            }
            try {
                Hotkey(m . c, __hs)
            }
        }

        ; 註冊數字鍵盤
        e := "0,1,2,3,4,5,6,7,8,9,Dot,Div,Mult,Add,Sub,Enter"
        loop parse, e, "," {
            try {
                Hotkey(m . "Numpad" . A_LoopField, __hs)
            }
        }

        ; 註冊功能鍵
        e := "BS,Space,Enter,Tab," . d
        loop parse, e, "," {
            try {
                Hotkey(m . A_LoopField, __hs)
            }
        }

        ; 針對空白類終止鍵註冊條件攔截，僅在匹配規則且符合 Hotstring("EndChars") 時攔截原按鍵（避免 Tab 跳離輸入框）
        HotIf((*) => hotstrings("#CanTrigger#", "`t"))
        try {
            Hotkey("$Tab", (*) => hotstrings("#TriggerKey#", "Tab"))
        }
        HotIf((*) => hotstrings("#CanTrigger#", "`n"))
        try {
            Hotkey("$Enter", (*) => hotstrings("#TriggerKey#", "Enter"))
            Hotkey("$NumpadEnter", (*) => hotstrings("#TriggerKey#", "NumpadEnter"))
        }
        HotIf((*) => hotstrings("#CanTrigger#", " "))
        try {
            Hotkey("$Space", (*) => hotstrings("#TriggerKey#", "Space"))
        }
        HotIf()

        z := true
    }

    if (isTrigger || isFeed || (a == "" && k == "")) {
        if (!isTrigger && !isFeed) {
            if (GetKeyState("Ctrl") || GetKeyState("Alt") || GetKeyState("LWin") || GetKeyState("RWin")) {
                s := ""
                return false
            }
            ; 取得觸發按鍵
            q := SubStr(A_ThisHotkey, StrLen(m) + 1)
        }

        if (q = "BS") {
            if (SubStr(s, -1) != "}") {
                s := SubStr(s, 1, -1)
            }
            return false
        }
        if (InStr("," . d . ",", "," . q . ",")) { ; 精確比對功能鍵，清空 Buffer
            s := ""
            return false
        }

        ch := __hsNormalizeKey(q, !isTrigger && !isFeed)
        isEndChar := (StrLen(ch) == 1 && InStr(Hotstring("EndChars"), ch, true) > 0)

        ; 檢查跟隨 Hotstring("EndChars") 的規則
        if (isEndChar && s != "") {
            found := __hsFindMatch(s, true)
            if (IsObject(found)) {
                len := found.match.Len
                s := SubStr(s, 1, -len)
                bsCount := isTrigger ? len : (len + StrLen(ch))
                __hsExecuteMatch(found, bsCount)
                return true
            }
        }

        ; 未觸發 EndChars 規則時寫入緩衝區，並檢查即時觸發 (*) 規則
        s .= ch
        foundImmediate := __hsFindMatch(s, false)
        if (IsObject(foundImmediate)) {
            len := foundImmediate.match.Len
            s := SubStr(s, 1, -len)
            bsCount := isTrigger ? (len - StrLen(ch)) : len
            __hsExecuteMatch(foundImmediate, bsCount)
            return true
        }

        if (StrLen(s) > w) {
            s := SubStr(s, (w // 2) + 1)
        }
        return false
    } else {
        ; 註冊模式
        k := StrReplace(k, "`n", "\n")
        k := StrReplace(k, "`r", "\r")
        useEndCharsFlag := InStr(opts, "*") ? "0" : "1"

        newT := ""
        loop parse, t, "`n" {
            if (A_LoopField == "") {
                continue
            }
            l := A_LoopField
            if (SubStr(l, 1, InStr(l, "`r") - 1) != k) {
                newT .= l . "`n"
            }
        }
        t := newT

        if (a != "") {
            t .= k . "`r" . a . "`r" . useEndCharsFlag . "`n"
        }
    }
}
