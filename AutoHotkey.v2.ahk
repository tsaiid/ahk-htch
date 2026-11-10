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
#Include Hotstrings\vars.v2.ahk

; RegEx Hotstrings
;; Bug: need to be included first ???
#Include Hotstrings\regex-hotstrings.v2.ahk

#Include *i Hotstrings\private.v2.ahk

;; My Own Lib
#Include Hotstrings\lib\date.v2.ahk
#Include Hotstrings\lib\string.v2.ahk
#Include Hotstrings\lib\ris-common.v2.ahk

#HotIf WinActive("ahk_group RIS")
  ;;; HotStrings
#Include Hotstrings\neuro.v2.ahk

#Include Hotstrings\ajcc.v2.ahk

#Include Hotstrings\sono.v2.ahk

#Include Hotstrings\chest-x-ray.v2.ahk
#Include Hotstrings\kub.v2.ahk
#Include Hotstrings\bone-x-ray.v2.ahk
#Include Hotstrings\other-x-ray.v2.ahk
#Include Hotstrings\comparisons.v2.ahk
#Include Hotstrings\sono-guide.v2.ahk

#Include Hotstrings\abdomen-ct.v2.ahk
#Include Hotstrings\abdomen-mr.v2.ahk
#Include Hotstrings\chest-ct.v2.ahk
#Include Hotstrings\breast-mr.v2.ahk

#Include Hotstrings\ct-guide.v2.ahk

#Include Hotstrings\barium-enema.v2.ahk
#Include Hotstrings\esophagraphy.v2.ahk
#Include Hotstrings\ugi-small-intestine.v2.ahk
#Include Hotstrings\intravenous-pyelogram.v2.ahk
#Include Hotstrings\special.v2.ahk
#Include Hotstrings\angio.v2.ahk

#Include Hotstrings\ms-mri.v2.ahk
#Include Hotstrings\ms-ct.v2.ahk

#Include Hotstrings\mri.v2.ahk
#Include Hotstrings\abbreviations.v2.ahk
#Include Hotstrings\others.v2.ahk

#Include Hotstrings\bone-density.v2.ahk

#HotIf

; HotKeys Lib
#Include Hotkeys\remapping-original-hotkeys.v2.ahk

; Define hotkeys
#HotIf WinActive("ahk_group RIS")
#HotIf

^!r::Reload()  ; Assign Ctrl-Alt-R as a hotkey to restart the script.
