#Requires AutoHotkey v2.0
#SingleInstance Force
SendMode("Input")
SetWorkingDir(A_ScriptDir)
SetControlDelay(-1)
CoordMode("Mouse", "Screen")

#Include <AHKHID_v2>

AHKHID_UseConstants()

gui := Gui("+LastFound -Resize -MaximizeBox -MinimizeBox")
gui.SetFont("w700 s8", "Courier New")
lbxInput := gui.AddListBox("h300 w300")
GuiHandle := gui.Hwnd
hlbxInput := lbxInput.Hwnd

if (AHKHID_Register(12, 1, GuiHandle, RIDEV_INPUTSINK) = -1) {
    MsgBox "Failed to register ShuttlePRO." 
    ExitApp
}

shuttlepro_speed_saved := 0
shuttlepro_shuttle_start := true
shuttlepro_old_4 := 0
shuttlepro_old_5 := 0
shuttlepro_keys := []
speed_loop_running := false
timer_active_hwnd := -1
a := ""
shuttlepro_shuttle_saved := 0

gui.OnEvent("Close", (*) => ExitApp())
OnMessage(0xFF, Func("ShuttleProIntercept"))

gui.Show()
return

ShuttleProIntercept(wParam, lParam, msg, hwnd) {
    global shuttlepro_speed_saved, shuttlepro_shuttle_start, shuttlepro_shuttle_saved
    global shuttlepro_old_4, shuttlepro_old_5, shuttlepro_keys
    global timer_active_hwnd, hlbxInput, lbxInput, a

    Critical("On")

    devicetype := AHKHID_GetInputInfo(lParam, 0)
    if (devicetype != RIM_TYPEHID) {
        return
    }

    hid_handle := AHKHID_GetInputInfo(lParam, 8)
    length := AHKHID_GetInputData(lParam, &uData) - 1
    vendor_id := AHKHID_GetDevInfo(hid_handle, DI_HID_VENDORID, true)
    product_id := AHKHID_GetDevInfo(hid_handle, DI_HID_PRODUCTID, true)

    if (vendor_id != 2867 || product_id != 48) {
        return
    }

    bytes := []
    loop length {
        bytes[A_Index] := NumGet(uData, A_Index, "UChar")
    }

    byte1 := bytes.Has(1) ? bytes[1] : 0
    byte2 := bytes.Has(2) ? bytes[2] : 0
    byte4 := bytes.Has(4) ? bytes[4] : 0
    byte5 := bytes.Has(5) ? bytes[5] : 0

    a := ""
    layer := 1

    byte4_new := byte4 & shuttlepro_old_4
    byte5_new := byte5 & shuttlepro_old_5
    shuttlepro_old_4 := ~byte4
    shuttlepro_old_5 := ~byte5

    loop 8 {
        shuttlepro_keys[A_Index] := byte4_new & 1
        byte4_new >>= 1
    }

    i := 9
    loop 7 {
        shuttlepro_keys[i] := byte5_new & 1
        byte5_new >>= 1
        i += 1
    }

    if (byte1 != shuttlepro_speed_saved) {
        stop_all_speed_timers()
        execute_shuttlepro_speed(byte1, layer)
    }
    shuttlepro_speed_saved := byte1

    a .= byte1 " " byte2 " " byte4 " " byte5

    if (shuttlepro_shuttle_start) {
        shuttlepro_shuttle_saved := byte2
        shuttlepro_shuttle_start := false
    } else if (byte2 != shuttlepro_shuttle_saved) {
        execute_shuttlepro_shuttle(byte2, layer)
    }
    shuttlepro_shuttle_saved := byte2

    loop 15 {
        keyIndex := A_Index
        if (shuttlepro_keys.Has(keyIndex) && shuttlepro_keys[keyIndex]) {
            execute_shuttlepro(keyIndex, layer)
        }
    }

    UpdateDisplay(a)
}

execute_shuttlepro(key, layer) {
    global a

    if (key = 12) {
        Reload()
    }

    if WinActive("ahk_exe WEBVIE~1.EXE") {
        if (key = 1) {
            Send "q"
        } else if (key = 2) {
            Send "{F4}"
        } else if (key = 3) {
            Send "{F3}"
        } else if (key = 4) {
            Send "{F1}"
        } else if (key = 5) {
            Send "!t"
        } else if (key = 8) {
            Send "{F5}"
        } else if (key = 9) {
            Send "{F2}"
        } else if (key = 10) {
            Send "^{F12}"
        } else if (key = 11) {
            Send "f"
        } else if (key = 13) {
            Send "w"
        } else if (key = 14) {
            Send "!p"
        } else if (key = 15) {
            Send "^!w"
        }
    } else if WinActive("ahk_exe G3PACS.exe") {
        if (key = 1) {
            Send "q"
        } else if (key = 2) {
            Send "7"
        } else if (key = 3) {
            Send "5"
        } else if (key = 4) {
            Send "6"
        } else if (key = 5) {
            Send "d"
        } else if (key = 6) {
            Send "l"
        } else if (key = 7) {
            Send "1"
        } else if (key = 8) {
            Send "9"
        } else if (key = 9) {
            Send "4"
        } else if (key = 10) {
            Send "x"
        } else if (key = 11) {
            ToggleDiffExamSync()
        } else if (key = 13) {
            ToggleSync()
        } else if (key = 14) {
            Send "o"
        } else if (key = 15) {
            Send "{Down}"
        }
    } else if WinActive("ahk_exe Report.exe") {
        if (key = 4) {
            if WinActive("查詢歷史報告") {
                isPopHisReport := ControlGetVisible("TBitBtn6")
                if (isPopHisReport) {
                    ControlClick("TBitBtn6")
                } else {
                    ControlClick("TBitBtn1")
                    Sleep(100)
                    ControlFocus("TMemo6", "ahk_exe Report.exe")
                }
            }
        }
    }

    a .= "key: " key " in layer " layer
}

execute_shuttlepro_speed(speed, layer) {
    global shuttlepro_speed_saved, timer_active_hwnd, a

    if (speed > 200) {
        speed -= 256
    }
    corrected_speed_saved := shuttlepro_speed_saved
    if (corrected_speed_saved > 200) {
        corrected_speed_saved -= 256
    }

    timer_active_hwnd := WinExist("A")

    if WinActive("ahk_exe G3PACS.exe") {
        set_scroll_speed(corrected_speed_saved, speed, 800, 600, 333, 200, 100, 50, 20)
    } else if WinActive("ahk_exe WEBVIE~1.EXE") {
        set_scroll_speed(corrected_speed_saved, speed, 800, 600, 333, 200, 100, 50, 20)
    } else if WinActive("ahk_exe XWinGEAWE32.exe") {
        set_scroll_speed(corrected_speed_saved, speed, 800, 600, 333, 200, 100, 50, 20)
    }

    a .= "corrected_speed_saved: " corrected_speed_saved ", speed: " speed
}

execute_shuttlepro_shuttle(shuttle_value, layer) {
    global shuttlepro_shuttle_saved, a

    if WinActive("ahk_exe G3PACS.exe") {
        if is_shuttle_clockwise(shuttle_value, shuttlepro_shuttle_saved) {
            Click("WheelDown")
        } else {
            Click("WheelUp")
        }
    } else if WinActive("ahk_exe XWinGEAWE32.exe") {
        if is_shuttle_clockwise(shuttle_value, shuttlepro_shuttle_saved) {
            Click("WheelDown")
        } else {
            Click("WheelUp")
        }
    } else {
        MouseGetPos(, , &id)
        title := WinGetTitle("ahk_id " id)
        if is_shuttle_clockwise(shuttle_value, shuttlepro_shuttle_saved) {
            Click("WheelDown")
        } else {
            Click("WheelUp")
        }
    }

    a .= "shuttle: " shuttle_value "(prev: " shuttlepro_shuttle_saved ") in layer " layer
}

is_shuttle_clockwise(shuttle_value, shuttlepro_shuttle_saved) {
    if (shuttle_value = 0) {
        return shuttlepro_shuttle_saved > 127
    } else if (shuttlepro_shuttle_saved = 0) {
        return shuttle_value < 128
    } else {
        return shuttle_value > shuttlepro_shuttle_saved
    }
}

stop_all_speed_timers() {
    SetTimer("UpScroll", 0)
    SetTimer("DownScroll", 0)
}

set_scroll_speed(corrected_speed_saved, speed, s1, s2, s3, s4, s5, s6, s7) {
    if (corrected_speed_saved < speed && speed > 0) {
        Click("WheelDown")
    } else if (corrected_speed_saved > speed && speed < 0) {
        Click("WheelUp")
    }

    scrollFunc := speed < 0 ? "UpScroll" : "DownScroll"
    abs_speed := Abs(speed)

    if (abs_speed = 1) {
        SetTimer(scrollFunc, s1)
    } else if (abs_speed = 2) {
        SetTimer(scrollFunc, s2)
    } else if (abs_speed = 3) {
        SetTimer(scrollFunc, s3)
    } else if (abs_speed = 4) {
        SetTimer(scrollFunc, s4)
    } else if (abs_speed = 5) {
        SetTimer(scrollFunc, s5)
    } else if (abs_speed = 6) {
        SetTimer(scrollFunc, s6)
    } else if (abs_speed = 7) {
        SetTimer(scrollFunc, s7)
    }
}

UpScroll(*) {
    global timer_active_hwnd
    curr_hwnd := WinExist("A")
    if (curr_hwnd != timer_active_hwnd) {
        SetTimer("UpScroll", 0)
    } else {
        Click("WheelUp")
    }
}

DownScroll(*) {
    global timer_active_hwnd
    curr_hwnd := WinExist("A")
    if (curr_hwnd != timer_active_hwnd) {
        SetTimer("DownScroll", 0)
    } else {
        Click("WheelDown")
    }
}

ToggleSync() {
    FocusedControl := ControlGetFocus()
    OutputVar := WinGetTitle()
    if (OutputVar = "INFINITT PACS" && SubStr(FocusedControl, 1, 3) = "Afx") {
        DiffSyncBtns := ["Button1", "Button75"]
        for btn in DiffSyncBtns {
            t := ControlGetText(btn)
            if (t = "自動同步") {
                ControlClick(btn)
                break
            }
        }
    }
}

ToggleDiffExamSync() {
    FocusedControl := ControlGetFocus()
    OutputVar := WinGetTitle()
    if (OutputVar = "INFINITT PACS" && SubStr(FocusedControl, 1, 3) = "Afx") {
        DiffSyncBtns := ["Button2", "Button76", "Button91"]
        for btn in DiffSyncBtns {
            t := ControlGetText(btn)
            if (t = "不同檢查同步 ") {
                ControlClick(btn)
                break
            }
        }
    }
}

UpdateDisplay(text) {
    global lbxInput, hlbxInput
    lbxInput.Delete()
    lbxInput.Add(text)
    count := SendMessage(0x018B, 0, 0, "", "ahk_id " hlbxInput)
    SendMessage(0x0186, count - 1, 0, "", "ahk_id " hlbxInput)
}
