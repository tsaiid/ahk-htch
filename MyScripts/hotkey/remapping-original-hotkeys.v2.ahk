#Requires AutoHotkey v2.0
A_MaxHotkeysPerInterval := 200

;; for INFINITT PACS
#HotIf MouseIsOverG3Pacs()
$WheelUp::FocusG3PacsUnderMouseAndScroll("WheelUp")
$WheelDown::FocusG3PacsUnderMouseAndScroll("WheelDown")
#HotIf

#HotIf IsG3PacsHotkeyContext()
^s::SelectG3PacsSortBySliceLocationDesc()
#HotIf

MouseIsOverG3Pacs() {
    MouseGetPos(,, &hwnd)
    try return WinGetProcessName("ahk_id " hwnd) = "G3PACS.exe"
    return false
}

IsG3PacsHotkeyContext() {
    return WinActive("ahk_exe G3PACS.exe") && MouseIsOverG3Pacs()
}

FocusG3PacsUnderMouseAndScroll(direction) {
    MouseGetPos(,, &hwnd)
    if (hwnd && !WinActive("ahk_id " hwnd)) {
        WinActivate("ahk_id " hwnd)
    }
    Click(direction)
}

SelectG3PacsSortBySliceLocationDesc() {
    Click("Right")
    Sleep(250)
    popupHwnd := WaitForG3PacsPopupMenu("排序")
    if !popupHwnd {
        NotifyG3PacsHotkeyError("找不到 G3PACS 右鍵選單")
        return
    }

    hMenu := SendMessage(0x01E1, 0, 0,, "ahk_id " popupHwnd) ; MN_GETHMENU
    if !hMenu {
        NotifyG3PacsHotkeyError("無法取得右鍵選單 HMENU")
        return
    }

    sortItem := FindMenuItemByText(hMenu, "排序")
    if !sortItem || !sortItem.submenu {
        NotifyG3PacsHotkeyError("找不到選單項目: 排序", hMenu)
        return
    }

    HoverMenuItem(popupHwnd, hMenu, sortItem.index)

    subMenuHwnd := WaitForG3PacsPopupMenu("切面位置 (遞減)", popupHwnd)
    if !subMenuHwnd {
        NotifyG3PacsHotkeyError("找不到排序子選單")
        return
    }

    subMenu := SendMessage(0x01E1, 0, 0,, "ahk_id " subMenuHwnd) ; MN_GETHMENU
    if !subMenu {
        NotifyG3PacsHotkeyError("無法取得排序子選單 HMENU")
        return
    }

    sliceDescItem := FindMenuItemByText(subMenu, "切面位置 (遞減)")
    if !sliceDescItem {
        NotifyG3PacsHotkeyError("找不到選單項目: 切面位置 (遞減)", subMenu)
        return
    }

    ClickMenuItem(subMenuHwnd, subMenu, sliceDescItem.index)
}

WaitForG3PacsPopupMenu(requiredItemText := "", excludeHwnd := 0, timeoutMs := 1500) {
    deadline := A_TickCount + timeoutMs
    while A_TickCount < deadline {
        for hwnd in WinGetList("ahk_class #32768 ahk_exe G3PACS.exe") {
            if hwnd = excludeHwnd
                continue
            if IsG3PacsPopupMenu(hwnd) && PopupMenuHasItem(hwnd, requiredItemText)
                return hwnd
        }

        Sleep(20)
    }
    return 0
}

IsG3PacsPopupMenu(hwnd) {
    if !hwnd
        return false

    try return WinGetClass("ahk_id " hwnd) = "#32768"
        && WinGetProcessName("ahk_id " hwnd) = "G3PACS.exe"
    return false
}

PopupMenuHasItem(hwnd, itemText) {
    if itemText = ""
        return true

    hMenu := SendMessage(0x01E1, 0, 0,, "ahk_id " hwnd) ; MN_GETHMENU
    return hMenu && FindMenuItemByText(hMenu, itemText)
}

FindMenuItemByText(hMenu, targetText) {
    itemCount := DllCall("GetMenuItemCount", "Ptr", hMenu, "Int")
    selectableOffset := 0
    normalizedTargetText := NormalizeMenuItemText(targetText)

    loop itemCount {
        index := A_Index - 1
        itemText := GetMenuItemText(hMenu, index)
        if !IsSelectableMenuItem(hMenu, index, itemText)
            continue

        subMenu := DllCall("GetSubMenu", "Ptr", hMenu, "Int", index, "Ptr")
        if NormalizeMenuItemText(itemText) = normalizedTargetText
            return {index: index, offset: selectableOffset, submenu: subMenu}

        selectableOffset += 1
    }

    return false
}

IsSelectableMenuItem(hMenu, index, itemText) {
    return itemText != ""
}

NormalizeMenuItemText(itemText) {
    itemText := StrReplace(itemText, "&")
    itemText := StrReplace(itemText, "‧‧", "..")
    itemText := RegExReplace(itemText, "\t.*$")
    return Trim(itemText)
}

GetMenuItemText(hMenu, index) {
    length := DllCall("GetMenuString", "Ptr", hMenu, "UInt", index, "Ptr", 0, "Int", 0, "UInt", 0x0400, "Int") ; MF_BYPOSITION
    if length < 1
        return ""

    textBuffer := Buffer((length + 1) * 2, 0)
    DllCall("GetMenuString", "Ptr", hMenu, "UInt", index, "Ptr", textBuffer, "Int", length + 1, "UInt", 0x0400, "Int")
    return StrGet(textBuffer, "UTF-16")
}

HoverMenuItem(hwnd, hMenu, index) {
    point := GetMenuItemCenter(hwnd, hMenu, index)
    if !point {
        Send("{Home}")
        return
    }

    MouseMove(point.x, point.y, 0)
    Sleep(250)
}

ClickMenuItem(hwnd, hMenu, index) {
    point := GetMenuItemCenter(hwnd, hMenu, index)
    if !point {
        Send("{Enter}")
        return
    }

    Click(point.x, point.y)
}

GetMenuItemCenter(hwnd, hMenu, index) {
    rect := Buffer(16, 0)
    if !DllCall("GetMenuItemRect", "Ptr", hwnd, "Ptr", hMenu, "UInt", index, "Ptr", rect, "Int")
        return false

    left := NumGet(rect, 0, "Int")
    top := NumGet(rect, 4, "Int")
    right := NumGet(rect, 8, "Int")
    bottom := NumGet(rect, 12, "Int")
    return {x: (left + right) // 2, y: (top + bottom) // 2}
}

DumpMenuItems(hMenu) {
    itemCount := DllCall("GetMenuItemCount", "Ptr", hMenu, "Int")
    if itemCount < 1
        return "(no items)"

    lines := ""
    loop itemCount {
        index := A_Index - 1
        itemText := GetMenuItemText(hMenu, index)
        subMenu := DllCall("GetSubMenu", "Ptr", hMenu, "Int", index, "Ptr")
        lines .= Format("{:02}", A_Index) ". submenu: " (subMenu ? subMenu : "no") " text: " (itemText != "" ? itemText : "(blank)") "`n"
    }
    return RTrim(lines, "`n")
}

NotifyG3PacsHotkeyError(message, hMenu := 0) {
    if hMenu
        A_Clipboard := message "`n`nMenu items:`n" DumpMenuItems(hMenu)
    ToolTip(message)
    SetTimer(() => ToolTip(), -3000)
}

#HotIf WinActive("ahk_exe G3PACS.exe")
w::
{
    try {
        ; v2 的 ControlGetFocus 回傳 HWND，需轉為 ClassNN 才能做字串比對
        hCtl := ControlGetFocus("A")
        PacsFocusedControl := ControlGetClassNN(hCtl)
    } catch {
        PacsFocusedControl := ""
    }

    OutputVar := WinGetTitle("A")
    ;MsgBox(OutputVar)

    if (OutputVar = "INFINITT PACS" && SubStr(PacsFocusedControl, 1, 3) = "Afx") {
        DiffSyncBtns := ["Button1", "Button85", "Button90", "Button102"]
        for idx, btn in DiffSyncBtns {
            try {
                t := ControlGetText(btn)
                if (t == " Auto sync" || t == "自動同步") {
                    ControlClick(btn)
                    break
                }
            }
        }
    } else {
        Send("w")
    }
}

f::
{
    try {
        hCtl := ControlGetFocus("A")
        PacsFocusedControl := ControlGetClassNN(hCtl)
    } catch {
        PacsFocusedControl := ""
    }

    OutputVar := WinGetTitle("A")
    ;MsgBox(OutputVar)

    if (OutputVar = "INFINITT PACS" && SubStr(PacsFocusedControl, 1, 3) = "Afx") {
        DiffSyncBtns := ["Button2", "Button86", "Button91", "Button103"]
        for idx, btn in DiffSyncBtns {
            try {
                t := ControlGetText(btn)
                if (t == " Sync with other exams" || t == "不同檢查同步 ") {
                    ControlClick(btn)
                    break
                }
            }
        }
    } else {
        Send("f")
    }
}

e::
{
    try {
        hCtl := ControlGetFocus("A")
        PacsFocusedControl := ControlGetClassNN(hCtl)
    } catch {
        PacsFocusedControl := ""
    }
    ;MsgBox(PacsFocusedControl)

    OutputVar := WinGetTitle("A")
    if (OutputVar = "INFINITT PACS" && SubStr(PacsFocusedControl, 1, 3) = "Afx") {
        DiffSyncBtns := ["Button4", "Button78"]
        for idx, btn in DiffSyncBtns {
            try {
                t := ControlGetText(btn)
                if (t = " Scout lines") { ; 注意這裡原代碼有一個前導空白
                    ControlClick(btn)
                    break
                }
            }
        }
    } else {
        Send("e")
    }
}

/*
;; activate RIS and insert exam name
!e::
{
    global FINDING_CONTROL ; 引用外部全域變數
    if (!WinActive("報告作業(frmRISReport)")) {
        ; 檢查視窗是否存在，避免報錯
        if (WinExist("報告作業(frmRISReport)")) {
            WinActivate("報告作業(frmRISReport)")
            WinWaitActive("報告作業(frmRISReport)")

            ; 確保 FINDING_CONTROL 已定義且控制項存在
            if IsSet(FINDING_CONTROL) {
                try ControlFocus(FINDING_CONTROL)
            }

            ; 假設 InsertExamname() 是一個已定義的函數
            try InsertExamname()
        }
    }
}
*/
#HotIf ; end for INFINITT PACS
