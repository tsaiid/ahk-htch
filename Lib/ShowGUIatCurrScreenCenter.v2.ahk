#Requires AutoHotkey v2.0

; Show GUI at center of the current screen - multiple monitors
; https://autohotkey.com/boards/viewtopic.php?t=31716

GetCurrentMonitorIndex() {
  CoordMode "Mouse", "Screen"
  MouseGetPos &mx, &my
  monitorsCount := MonitorGetCount()

  Loop monitorsCount {
    MonitorGet A_Index, &Left, &Top, &Right, &Bottom
    if (Left <= mx && mx <= Right && Top <= my && my <= Bottom) {
      return A_Index
    }
  }
  return 1
}

CoordXCenterScreen(WidthOfGUI, ScreenNumber) {
  MonitorGet ScreenNumber, &Left, &Top, &Right, &Bottom
  return ((Right - Left - WidthOfGUI) / 2) + Left
}

CoordYCenterScreen(HeightofGUI, ScreenNumber) {
  MonitorGet ScreenNumber, &Left, &Top, &Right, &Bottom
  return (Bottom - 30 - HeightofGUI) / 2
}

GetClientSize(hwnd, &w, &h) {
  rc := Buffer(16)
  DllCall("GetClientRect", "uint", hwnd, "uint", rc.Ptr)
  w := NumGet(rc, 8, "int")
  h := NumGet(rc, 12, "int")
}