#Requires AutoHotkey v2.0

/*
  Function: hotstrings
    Dynamically adds regular expression hotstrings.

  Parameters:
    c - regular expression hotstring
    a - (optional) text to replace hotstring with or a label to call,
      leave blank to remove hotstring definition from triggering an action

  Examples:
    hotstrings("(B|b)tw\s", "%$1%y the way") ; type 'btw' followed by space, tab or return
    hotstrings("i)omg", "oh my god{!}") ; type 'OMG' in any case, upper, lower or mixed
    hotstrings("\bcolou?r", "rgb(128, 255, 0);") ; '\b' prevents matching with anything before the word, e.g. 'multicololoured'

  License:
    - Version 2.59 <http://www.autohotkey.net/~polyethene/#hotstrings>
    - Dedicated to the public domain (CC0 1.0) <http://creativecommons.org/publicdomain/zero/1.0/>
    - Converted to AHK v2 by Gemini
*/

; 初始化全域變數
global hsMatch := ""

/*
  Function: hotstrings
    Dynamically adds regular expression hotstrings.
    AHK v2 Version.
*/

; 初始化全域變數，用於儲存 RegEx 捕獲結果
global hsMatch := ""

hotstrings(k, a := "") {
    static z := false, m := "*~$", s := "", t := "", w := 2000, sd := "", d :=
        "Left,Right,Up,Down,Home,End,RButton,LButton"

    ; 內部 callback 函數
    __hs(*) {
        hotstrings("", "")
    }

    if !z {
        try {
            sd := RegRead("HKCU\Control Panel\International", "sDecimal")
        } catch {
            sd := "."
        }

        ; 註冊所有 ASCII 可見字元
        loop 94 {
            c := Chr(A_Index + 32)
            if (c == " ") ; Space 會在下方單獨註冊
                continue
            try Hotkey(m . c, __hs)
        }

        ; 註冊數字鍵盤
        e := "0,1,2,3,4,5,6,7,8,9,Dot,Div,Mult,Add,Sub,Enter"
        loop parse, e, ","
            try Hotkey(m . "Numpad" . A_LoopField, __hs)

        ; 註冊功能鍵
        e := "BS,Space,Enter,Tab," . d
        loop parse, e, ","
            try Hotkey(m . A_LoopField, __hs)

        z := true
    }

    if (a == "" and k == "") {
        ; 取得觸發按鍵
        q := SubStr(A_ThisHotkey, StrLen(m) + 1)

        if (q = "BS") {
            if (SubStr(s, -1) != "}")
                s := SubStr(s, 1, -1)
        }
        else if (InStr("," . d . ",", "," . q . ",")) ; 精確比對功能鍵，清空 Buffer
            s := ""
        else {
            if (q = "Space")
                q := " "
            else if (q = "Tab")
                q := "`t"
            else if (q = "Enter" || q = "NumpadEnter")
                q := "`n"
            else if (RegExMatch(q, "Numpad(.+)", &n)) {
                n1 := n[1]
                q := (n1 == "Div" ? "/" : n1 == "Mult" ? "*" : n1 == "Add" ? "+" : n1 == "Sub" ? "-" : n1 == "Dot" ? sd :
                    "")
                if IsNumber(n1)
                    q := n1
            }
            else if (StrLen(q) != 1)
                q := "{" . q . "}"
            else if (GetKeyState("Shift") ^ GetKeyState("CapsLock", "T"))
                q := StrUpper(q)

            s .= q
        }

        ; 檢查是否匹配
        loop parse, t, "`n" {
            if (A_LoopField == "")
                continue

            x := StrSplit(A_LoopField, "`r")
            if (x.Length < 2)
                continue

            pattern := x[1]
            action := x[2]

            ; --- 修正點：加入 "i)" 使其不區分大小寫 ---
            if (RegExMatch(s, "i)" . pattern . "$", &match)) {

                len := match.Len
                s := SubStr(s, 1, -len)

                ; --- 修正點開始 ---
                ; 發送退格鍵刪除觸發字串
                SendInput("{BS " . len . "}")

                ; 【關鍵修正】強制等待 50ms，確保應用程式處理完 Backspace
                ; 如果不加這個，後續 Paste() 使用 EditPaste 時會發生 race condition
                Sleep(50)
                ; --- 修正點結束 ---

                replacement := action
                loop match.Count {
                    replacement := StrReplace(replacement, "%$" . A_Index . "%", match[A_Index])
                }

                global hsMatch := match

                try {
                    %action%()
                }
                catch {
                    SendInput(replacement)
                }
            }
        }

        if (StrLen(s) > w)
            s := SubStr(s, (w // 2) + 1)
    }
    else {
        ; 註冊模式
        k := StrReplace(k, "`n", "\n")
        k := StrReplace(k, "`r", "\r")

        new_t := ""
        loop parse, t, "`n" {
            if (A_LoopField == "")
                continue
            l := A_LoopField
            if (SubStr(l, 1, InStr(l, "`r") - 1) != k)
                new_t .= l . "`n"
        }
        t := new_t

        if (a != "")
            t .= k . "`r" . a . "`n"
    }
}
