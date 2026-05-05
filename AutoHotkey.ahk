; Settings
#Requires AutoHotkey v1.1
#NoEnv
#Hotstring EndChars `t
#Hotstring O
#MaxHotkeysPerInterval 200
SetBatchLines -1  ; better performance: http://scsnake.blogspot.tw/2016/03/hotstring.html
SendMode, Input
SetTitleMatchMode, 2
SetControlDelay -1  ; improve reliability for ControlClick, reduces interference from the user's physical movement of the mouse

; Group Control For RIS
GroupAdd, RIS, WebRIS
GroupAdd, RIS, 報告管理系統
GroupAdd, RIS, ahk_exe AdmOrder1.EXE
GroupAdd, Login, 報告管理系統
GroupAdd, Login, 會診醫師登入
GroupAdd, Login, 新醫療系統登出
GroupAdd, Login, ahk_exe loginscreen.exe
GroupAdd, Login, Lotus Notes
GroupAdd, Login, ahk_exe chrome.exe
GroupAdd, Login, 慈濟病歷電子書
GroupAdd, Login, ahk_exe AdmOrder1.EXE
GroupAdd, Login, ahk_exe Code.exe
GroupAdd, Login, ahk_exe WebViewer.exe
GroupAdd, Login, WebRIS - 個人 - Microsoft​ Edge
GroupAdd, Login, 花蓮慈院上網認證

; External Libraries
#Include <WBGet>
#Include <Paste>
#Include <JSON>
#Include <WinHttpRequest>
#Include <AccV2>
#Include <ShowGUIatCurrScreenCenter>

; Options
ENABLE_KEY_COUNTER := 0
PRESERVE_CLIPBOARD := 0

; Global Variables
#Include MyScripts\vars.ahk

; RegEx Hotstrings
;; Bug: need to be included first ???
#Include MyScripts\regex-hotstrings.ahk

#Include *i MyScripts\private.ahk

;; My Own Lib
#Include MyScripts\lib\date.ahk
#Include MyScripts\lib\string.ahk
#Include MyScripts\lib\ris-common.ahk

#IfWinActive ahk_group RIS
  ;;; HotStrings
  #Include MyScripts\neuro.ahk

  #Include MyScripts\ajcc.ahk

  #Include MyScripts\sono.ahk

  #Include MyScripts\chest-x-ray.ahk
  #Include MyScripts\kub.ahk
  #Include MyScripts\bone-x-ray.ahk
  #Include MyScripts\other-x-ray.ahk
  #Include MyScripts\comparisons.ahk
  #Include MyScripts\sono-guide.ahk

  #Include MyScripts\abdomen-ct.ahk
  #Include MyScripts\abdomen-mr.ahk
  #Include MyScripts\chest-ct.ahk
  #Include MyScripts\breast-mr.ahk

  #Include MyScripts\ct-guide.ahk

  #Include MyScripts\barium-enema.ahk
  #Include MyScripts\esophagraphy.ahk
  #Include MyScripts\ugi-small-intestine.ahk
  #Include MyScripts\intravenous-pyelogram.ahk
  #Include MyScripts\special.ahk
  #Include MyScripts\angio.ahk

  #Include MyScripts\ms-mri.ahk
  #Include MyScripts\ms-ct.ahk

  #Include MyScripts\mri.ahk
  #Include MyScripts\abbreviations.ahk
  #Include MyScripts\others.ahk

  #Include MyScripts\spg.ahk
  #Include MyScripts\bone-density.ahk

  ;;; Gui
  #Include MyScripts\gui-common.ahk
#IfWinActive

; HotKeys Lib
#Include MyScripts\hotkey\reorder-selected-text.ahk
#Include MyScripts\hotkey\remapping-original-hotkeys.ahk

; Define hotkeys
#IfWinActive ahk_group RIS

; Reorder Seleted Text And Discard SeIm
^!o::
  ReorderSelectedText()
Return

; Reorder Seleted Text And Keep SeIm
^!+o::
  ReorderSelectedText(,,, false)
Return

; Unorder Seleted Text
^+*::
  ReorderSelectedText(false, true, "*")
Return

^+-::
  ReorderSelectedText(false, true, "-")
Return

^++::
  ReorderSelectedText(false, true, "+")
Return

^!>::
  ReorderSelectedText(false, true, "->")
Return
#IfWinActive  ; ahk_group RIS

^!r::Reload  ; Assign Ctrl-Alt-R as a hotkey to restart the script.
