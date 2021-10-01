; Settings
#NoEnv
;#Hotstring EndChars `t
#Hotstring EndChars |
#Hotstring O
#MaxHotkeysPerInterval 200
SetBatchLines -1  ; better performance: http://scsnake.blogspot.tw/2016/03/hotstring.html
SendMode, Input
SetTitleMatchMode, 2
SetControlDelay -1  ; improve reliability for ControlClick, reduces interference from the user's physical movement of the mouse

; Group Control For RIS
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

; External Libraries
#Include <WBGet>
#Include <Paste>
#Include <varExist>
#Include <JSON>
#Include <StdOutStream>
#Include <WinHttpRequest>
#Include <AccV2>
#Include <ShowGUIatCurrScreenCenter>
#Include <Edit>
#Include <Edit_DeleteLine>
#Include <Edit_SelectLine>
#Include <AutoXYWH>

; Options
ENABLE_KEY_COUNTER := 0
PRESERVE_CLIPBOARD := 0

; Global Variables
#Include MyScripts\vars.ahk

; Key/Mouse Counter
;; Bug: shoule be before RegEx HotStrings
;#Include MyScripts\lib\keystroke-counter.ahk

; RegEx Hotstrings
;; Bug: need to be included first ???
#Include MyScripts\regex-hotstrings.ahk

#Include MyScripts\private.ahk

;; My Own Lib
#Include MyScripts\lib\frame-wait.ahk
#Include MyScripts\lib\dicom-sr.ahk
#Include MyScripts\lib\dicom-sr-ocr.ahk
#Include MyScripts\lib\date.ahk
#Include MyScripts\lib\string.ahk
#Include MyScripts\lib\supported-exam-patterns.ahk
#Include MyScripts\lib\libera-bmd.ahk
#Include MyScripts\lib\smartwonder-common.ahk
#Include MyScripts\lib\ris-common.ahk
;#Include MyScripts\lib\smart-card.ahk

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

#Include MyScripts\debug.ahk

; HotKeys Lib
#Include MyScripts\hotkey\get-side-str.ahk
#Include MyScripts\hotkey\reorder-selected-text.ahk
#Include MyScripts\hotkey\remapping-original-hotkeys.ahk
#Include MyScripts\hotkey\backup-helios-report-to-file.ahk
#Include MyScripts\hotkey\start-edit-after-ready.ahk
#Include MyScripts\hotkey\selecting-tabs.ahk
#Include MyScripts\hotkey\get-curr-accno-from-ge-uv.ahk
#Include MyScripts\hotkey\get-curr-patid-from-ge-uv.ahk
#Include MyScripts\hotkey\selecting-abnormal-value.ahk
#Include MyScripts\hotkey\selecting-mismatch-value.ahk
#Include MyScripts\hotkey\copy-prev-similar-report.ahk

; Mouse Macro
#Include MyScripts\mouse\magnify-ge-uv-grid.ahk

; Previously enabled but now disabled functions
;; The checking mechanism changed. No need to active current image before submitting since 2014-02.
;;#Include MyScripts\active-current-image-before-submit.ahk

; Define hotkeys
#IfWinActive ahk_group RIS

; Trigger hotstring by Tab key
#InputLevel 1
Tab::
  ;Send %A_PriorHotkey%
  Send |
  ;Send %A_ThisHotkey% %A_PriorHotkey%
  ;MsgBox, %A_PriorHotkey%

  ;if (A_PriorHotkey = "Tab") {
  ;  ; hotstring not triggered, clear | char
  ;  Sleep, 500
  ;  Send {BackSpace}
  ;}
Return
/*
Tab::|
*/
#InputLevel 0

; Delete current line
;^y::
;  Send {Home}+{End}{Del}
;Return

; Reorder Seleted Text
^!o::
  ControlGetFocus, FocusedControl
  discardSeIm := (FocusedControl = "TMemo7")
  ReorderSeletedText(, , , discardSeIm)
Return

; Deorder Seleted Text
^!+o::
  ReorderSeletedText(true)
Return

; Unorder Seleted Text
^+*::
  ReorderSeletedText(false, true, "*")
Return

^+-::
  ReorderSeletedText(false, true, "-")
Return

^++::
  ReorderSeletedText(false, true, "+")
Return

^!*::
  ReorderSeletedText(false, true, "  *")
Return

^!-::
  ReorderSeletedText(false, true, "  -")
Return

^!+::
  ReorderSeletedText(false, true, "  +")
Return
#IfWinActive  ; ahk_group RIS

^!r::Reload  ; Assign Ctrl-Alt-R as a hotkey to restart the script.
