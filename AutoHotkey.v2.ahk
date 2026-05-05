; Settings
#Requires AutoHotkey v2.0

#Hotstring EndChars `t
#Hotstring O
SendMode "Input"
SetTitleMatchMode 2
SetControlDelay -1

; Group Control For RIS
GroupAdd "RIS", "WebRIS"
GroupAdd "RIS", "報告管理系統"
GroupAdd "RIS", "ahk_exe AdmOrder1.EXE"
GroupAdd "Login", "報告管理系統"
GroupAdd "Login", "會診醫師登入"
GroupAdd "Login", "新醫療系統登出"
GroupAdd "Login", "ahk_exe loginscreen.exe"
GroupAdd "Login", "Lotus Notes"
GroupAdd "Login", "ahk_exe chrome.exe"
GroupAdd "Login", "慈濟病歷電子書"
GroupAdd "Login", "ahk_exe AdmOrder1.EXE"
GroupAdd "Login", "ahk_exe Code.exe"
GroupAdd "Login", "ahk_exe WebViewer.exe"
GroupAdd "Login", "WebRIS - 個人 - Microsoft​ Edge"
GroupAdd "Login", "花蓮慈院上網認證"

; External Libraries
#Include <WBGet.v2>
#Include <Paste.v2>
#Include <JSON.v2>
#Include <WinHttpRequest.v2>
#Include <AccV2.v2>
#Include <ShowGUIatCurrScreenCenter.v2>

; Options
ENABLE_KEY_COUNTER := 0
PRESERVE_CLIPBOARD := 0

; Global Variables
#Include MyScripts\vars.v2.ahk

; RegEx Hotstrings
;; Bug: need to be included first ???
#Include MyScripts\regex-hotstrings.v2.ahk

#Include *i MyScripts\private.v2.ahk

;; My Own Lib
#Include MyScripts\lib\date.v2.ahk
#Include MyScripts\lib\string.v2.ahk
#Include MyScripts\lib\ris-common.v2.ahk

#HotIf WinActive("ahk_group RIS")
  ;;; HotStrings
#Include MyScripts\neuro.v2.ahk

#Include MyScripts\ajcc.v2.ahk

#Include MyScripts\sono.v2.ahk

#Include MyScripts\chest-x-ray.v2.ahk
#Include MyScripts\kub.v2.ahk
#Include MyScripts\bone-x-ray.v2.ahk
#Include MyScripts\other-x-ray.v2.ahk
#Include MyScripts\comparisons.v2.ahk
#Include MyScripts\sono-guide.v2.ahk

#Include MyScripts\abdomen-ct.v2.ahk
#Include MyScripts\abdomen-mr.v2.ahk
#Include MyScripts\chest-ct.v2.ahk
#Include MyScripts\breast-mr.v2.ahk

#Include MyScripts\ct-guide.v2.ahk

#Include MyScripts\barium-enema.v2.ahk
#Include MyScripts\esophagraphy.v2.ahk
#Include MyScripts\ugi-small-intestine.v2.ahk
#Include MyScripts\intravenous-pyelogram.v2.ahk
#Include MyScripts\special.v2.ahk
#Include MyScripts\angio.v2.ahk

#Include MyScripts\ms-mri.v2.ahk
#Include MyScripts\ms-ct.v2.ahk

#Include MyScripts\mri.v2.ahk
#Include MyScripts\abbreviations.v2.ahk
#Include MyScripts\others.v2.ahk

#Include MyScripts\spg.v2.ahk
#Include MyScripts\bone-density.v2.ahk

  ;;; Gui
#Include MyScripts\gui-common.v2.ahk
#HotIf

; HotKeys Lib
#Include MyScripts\hotkey\reorder-selected-text.v2.ahk
#Include MyScripts\hotkey\remapping-original-hotkeys.v2.ahk

; Define hotkeys
#HotIf WinActive("ahk_group RIS")

; Reorder Seleted Text And Discard SeIm
^!o:: {
  ReorderSelectedText()
}

; Reorder Seleted Text And Keep SeIm
^!+o:: {
  ReorderSelectedText(,,, false)
}

; Unorder Seleted Text
^+*:: {
  ReorderSelectedText(false, true, "*")
}

^+-:: {
  ReorderSelectedText(false, true, "-")
}

^++:: {
  ReorderSelectedText(false, true, "+")
}

^!>:: {
  ReorderSelectedText(false, true, "->")
}
#HotIf

^!r::Reload()  ; Assign Ctrl-Alt-R as a hotkey to restart the script.
