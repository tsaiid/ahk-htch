; WBGet()
; Access an IE object by WinTitle and Internet Explorer_Server Number
; By jethrow
; http://www.autohotkey.com/board/topic/47052-basic-webpage-controls-with-javascript-com-tutorial/

WBGet(WinTitle := "ahk_class IEFrame", Svr := 1) {               ;// based on ComObjQuery docs
  static msg := DllCall("RegisterWindowMessage", "str", "WM_HTML_GETOBJECT")
       , IID := "{0002DF05-0000-0000-C000-000000000046}"   ;// IID_IWebBrowserApp
;//    , IID := "{332C4427-26CB-11D0-B483-00C04FD90119}"   ;// IID_IHTMLWindow2
  try {
    lResult := SendMessage(msg, 0, 0, "Internet Explorer_Server" Svr, WinTitle)
    GUID := Buffer(16, 0)
    if DllCall("ole32\CLSIDFromString", "wstr","{332C4425-26CB-11D0-B483-00C04FD90119}", "ptr", GUID) >= 0 {
       DllCall("oleacc\ObjectFromLresult", "ptr",lResult, "ptr",GUID, "ptr",0, "ptr*", &pdoc := 0)
       wb := ComValue(9, ComObjQuery(pdoc, IID, IID), 1)
       ObjRelease(pdoc)
       return wb
    }
  } catch {
  }
}
