#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force
SetControlDelay -1  ; improve reliability for ControlClick, reduces interference from the user's physical movement of the mouse
CoordMode, Mouse, Screen


#Include <AHKHID>

AHKHID_UseConstants() ;Set up the constants

	/*
Define a simple Gui
we need some sort of gui for the messages
it doesn't have to be visible, though

*/


Gui +LastFound -Resize -MaximizeBox -MinimizeBox
Gui, Font, w700 s8, Courier New
Gui, Add, ListBox, h300 w300 vlbxInput hwndhlbxInput,


GuiHandle := WinExist() ;Keep handle

r := AHKHID_Register(12,1, GuiHandle, RIDEV_INPUTSINK) ; register shuttlepro page 12 usage 1
;r := AHKHID_Register(12,1) ; register shuttlepro page 12 usage 1

; set initial values for the two jog wheels
shuttlepro_speed_saved:=0 ; for the speed dial
shuttlepro_shuttle_start:=True ; for the inner wheel
shuttlepro_old_4:=shuttlepro_old_5:=0 ; initial state assumes no key pressed
speed_loop_running:=False
timer_active_hwnd:=-1

/*
; Set the layerkeys
; kill this and further below if you don't want to have any layer keys
; this is just an example
; simple list of the keys used as layerkeys.
shuttlepro_layerkeys_2=14,11
shuttlepro_layerkeys_3=15,10

; create the layermasks
; a layermask has a 1 in the bit if the key represents a layer key
; for byte 4
shuttlepro_layermask_4_2:=0
shuttlepro_layermask_4_3:=0

Loop,8
	{
		If A_Index in %shuttlepro_layerkeys_2%
				shuttlepro_layermask_4_2|=2**(A_Index-1)

		If A_Index in %shuttlepro_layerkeys_3%
				shuttlepro_layermask_4_3|=2**(A_Index-1)
	}


; for byte 5
shuttlepro_layermask_5_2:=0
shuttlepro_layermask_5_3:=0

Loop,7
	{
		i:=8+A_Index
		If i in %shuttlepro_layerkeys_2%
				shuttlepro_layermask_5_2|=2**(A_Index-1)

		If i in %shuttlepro_layerkeys_3%
				shuttlepro_layermask_5_3|=2**(A_Index-1)
	}

; calculate inverse masks once so we save time later
shuttlepro_inverse_layermask_4:=~(shuttlepro_layermask_4_2|shuttlepro_layermask_4_3)
shuttlepro_inverse_layermask_5:=~(shuttlepro_layermask_5_2|shuttlepro_layermask_5_3)

; kill up to here if you don't need layers
*/


;Intercept WM_INPUT
OnMessage(0xFF, "ShuttleProIntercept")


Gui, Show
Return


GuiClose:
	ExitApp

;########## If Anything happens on the Shuttlepro, this function is called automagically from onMessage #####

ShuttleProIntercept(wParam, lParam)
	{
		local devicetype, hid_handle,length,vendor_id,product_id, layer
		Critical

		r := AHKHID_GetInputInfo(lParam, 0) ;Get device type

		If (r = RIM_TYPEHID) ; this is how the SHuttlepro identifies
			{
				hid_handle := AHKHID_GetInputInfo(lParam, 8) ; Handle to device
				length := AHKHID_GetInputData(lParam, uData)-1 ; input length
				Vendor_id:=AHKHID_GetDevInfo(hid_handle, DI_HID_VENDORID,     True)
				product_id:=AHKHID_GetDevInfo(hid_handle, DI_HID_PRODUCTID,    True)

				If (vendor_id=2867 And product_id=48)
					{
						; shuttlepro 2

						; get the data and convert to bytes
						Loop, %length%
								byte%A_Index%:=NumGet(uData,A_Index,"uchar")


						; byte 1 : Outer ring goes 1-7 (right) and 249-255 (left)
						; byte 2 : Innner ring goes 0-255 and rotates through 0 absolute
						; byte 3 : unused
						; byte 4 : has keys 1-8 as bits ; 1 = key is pressed
						; byte 5 : has keys 9-15 as bits ; 1 = key is pressed

						; the bits are set for all keys that are being held down

						a:="" ; global string for demo

						; deal with layers here
						; start deleting here if you don't need layers

/*

						layer2:=layer3:=False ; reset

						; see whether a layer key is pressed and set the appropriate flag
						If ((byte4 & shuttlepro_layermask_4_2))
								layer2:=True

						If ((byte4 & shuttlepro_layermask_4_3))
								layer3:=True

						If ((byte5 & shuttlepro_layermask_5_2))
								layer2:=True

						If ((byte5 & shuttlepro_layermask_5_3))
								layer3:=True

						; set the layer variable accordingly
						If (layer2 && layer3)
								layer:=4
						Else if layer3
								layer:=3
						Else if layer2
								layer:=2
						Else
								layer:=1

						; mask out the layerkeys
						; so they do not appear pushed below
						byte4&=shuttlepro_inverse_layermask_4
						byte5&=shuttlepro_inverse_layermask_5


*/
						; if you don't need layers, delete until here

						; compare to old ket to see only new keys pressed
						byte4_new:=byte4&shuttlepro_old_4
						byte5_new:=byte5&shuttlepro_old_5
						shuttlepro_old_4:=~byte4 ; invert for quick mask next time around
						shuttlepro_old_5:=~byte5  ; invert for quick mask next time around

						; sort out the keys
						; loops through the bytes and sets the variable shuttlepro%keynbumber% to true if the key was pressed
						; byte 4 has 8 keys
						Loop,8
							{
								shuttlepro%A_Index%:=byte4_new&1
								byte4_new>>=1
							}
						; byte 5 has 7 keys
						i:=9
						Loop,7
							{
								shuttlepro%i%:=byte5_new&1
								byte5_new>>=1
								i++
							}

						; now we know the exact state
						; byte 1 and 2 have the wheel states
						; shuttlepro%keynumber% is true if the key was just pressed


						; byte 1: outer wheel reports 1-7 or -1 to -7 (signed byte)
						If (byte1<>shuttlepro_speed_saved) { ; value has changed
                stop_all_speed_timers()
								execute_shuttlepro_speed(byte1,layer) ; execute function
            }

						shuttlepro_speed_saved:=byte1 ; save value


						; byte2 : reports absolute value of shuttle wheel
						a.= byte1 . " " . byte2 . " " . byte4 . " " . byte5
						If shuttlepro_shuttle_start ; this is the first time we run it
							{
								shuttlepro_shuttle_saved:=byte2
								shuttlepro_shuttle_start:=False
							}

						Else
							{
								If (byte2<>shuttlepro_shuttle_saved) ; value has changed
										execute_shuttlepro_shuttle(byte2,layer) ; execute function
							}

						shuttlepro_shuttle_saved:=byte2 ; save value


						;loop through 15 buttons
						Loop, 15
								If (shuttlepro%A_Index%)
										execute_shuttlepro(A_Index,layer) ; replace accordingly if you don't want layers



						; for demo, update the gui
						GuiControl,, lbxInput, %a%

					}
			}
		SendMessage, 0x018B, 0, 0,, ahk_id %hlbxInput%
		SendMessage, 0x0186, ErrorLevel - 1, 0,, ahk_id %hlbxInput%
	}


;############### Functions that are called when something happens on the Shuttlepro #########

; A Key was pressed
execute_shuttlepro(key,layer)
	{
		global
		; Do what needs to be done here
		; at the moment, just add to the global string

		If (key = 12) {
			Reload
		}
		If (WinActive("ahk_exe WEBVIE~1.EXE")) {
      If (key = 1) {
        Send, q				; selection mode
      } Else If (key = 2) {
        Send, {F4}		; skull window
      } Else If (key = 3) {
        Send, {F3}		; Bone window
      } Else If (key = 4) {
        Send, {F1}		; Chest window
      } Else If (key = 5) {
				Send, !t			; Toggle OST
      } Else If (key = 6) {
      } Else If (key = 7) {
      } Else If (key = 8) {
        Send, {F5}		; Liver window
      } Else If (key = 9) {
        Send, {F2}		; Abdomen window
      } Else If (key = 10) {
				Send, ^{F12}	; 合併所有序列
      } Else If (key = 11) {
        Send, f				; Sync others
      } Else If (key = 12) {
				;Reload settings in global scale
      } Else If (key = 13) {
        Send, w				; Sync
      } Else If (key = 14) {
        Send, !p			; Sync Sizing
      } Else If (key = 15) {
        Send, ^!w			; Sync Window Center/Level
      }
    } Else If (WinActive("ahk_exe G3PACS.exe")) {
      If (key = 1) {
        Send, q
      } Else If (key = 2) {
        Send, 7
      } Else If (key = 3) {
        Send, 5
      } Else If (key = 4) {
        Send, 6
      } Else If (key = 5) {
				/*
				; move mouse to RIS finding edit
				If (WinExist("ahk_exe Report.exe")) {
					WinGetPos, Xw, Yw, , , ahk_exe Report.exe
					ControlGetPos, x, y, w, h, TMemo6, ahk_exe Report.exe
					;MsgBox, %Xw% %x% %w%`,%Yw% %y% %h%
					MouseMove, Xw + x + w/2, Yw + y + h/2
					WinActivate
				}
				*/
        Send, d
      } Else If (key = 6) {
				Send, l
      } Else If (key = 7) {
        Send, 1
      } Else If (key = 8) {
        Send, 9
      } Else If (key = 9) {
        Send, 4
      } Else If (key = 10) {
        Send, x
      } Else If (key = 11) {
        ;Send, f
				ToggleDiffExamSync()
      } Else If (key = 12) {
				;Reload
      } Else If (key = 13) {
        ;Send, w
				ToggleSync()
      } Else If (key = 14) {
        ;Send, {Up}
				Send, o
      } Else If (key = 15) {
        Send, {Down}
      }
    } Else If (WinActive("ahk_exe Report.exe")) {
      If (key = 4) {	; Close prev exam list window
				If (WinActive("查詢歷史報告")) {
					ControlGet, isPopHisReport, Visible,, TBitBtn6
					If (isPopHisReport) {
						ControlClick, TBitBtn6
					} Else {
						ControlClick, TBitBtn1
						Sleep, 100
						ControlFocus, TMemo6, ahk_exe Report.exe
					}
				}
      } Else If (key = 5) {
				/*
				; move mouse to PACS window
				If (WinExist("ahk_exe G3PACS.exe")) {
					WinGetPos, x, y, w, h, ahk_exe G3PACS.exe
					;MsgBox, Calculator is at %X%`,%Y%
					MouseMove, x - w/2, y + h * 3/4
					WinActivate
				}
				*/
			}
    }

		a.= "key: " . key . " in layer " . layer
		Return
	}

; the outer wheel was turned
execute_shuttlepro_speed(speed,layer)
	{
		global
		; do what needs to be done here
		; at the moment, just add to the global string
		If (speed>200)
				speed:=speed-256 ; make negative
		corrected_speed_saved := shuttlepro_speed_saved
		If (corrected_speed_saved>200)
				corrected_speed_saved:=corrected_speed_saved-256 ; make negative

		timer_active_hwnd := WinExist("A")
		;a .= "timer_active_hwnd: " . timer_active_hwnd

    If (WinActive("ahk_exe G3PACS.exe")) {
      a .= "GEUV: "
      ; send the first key, because SetTimer will wait for the first period
			set_scroll_speed(corrected_speed_saved, speed, 800, 600, 333, 200, 100, 50, 20)
    } Else If (WinActive("ahk_exe WEBVIE~1.EXE")) {
      a .= "EBM: "
      ; send the first key, because SetTimer will wait for the first period
			set_scroll_speed(corrected_speed_saved, speed, 800, 600, 333, 200, 100, 50, 20)
    } Else If (WinActive("ahk_exe XWinGEAWE32.exe")) {
      a .= "AWS: "
      ; send the first key, because SetTimer will wait for the first period
			set_scroll_speed(corrected_speed_saved, speed, 800, 600, 333, 200, 100, 50, 20)
    }

    a .= "corrected_speed_saved: " . corrected_speed_saved . ", speed: " . speed

		Return
	}

; the inner wheel was turned
execute_shuttlepro_shuttle(shuttle_value,layer)
	{
		global
		; Do what needs to be done here
		; at the moment, just add to the global string
    If (WinActive("ahk_exe G3PACS.exe")) {
      a .= "GEUV "
      If (is_shuttle_clockwise(shuttle_value, shuttlepro_shuttle_saved)) {
        Click, WheelDown
      } Else {
        Click, WheelUp
      }
    } Else If (WinActive("ahk_exe XWinGEAWE32.exe")) {
      a .= "AWS "
      If (is_shuttle_clockwise(shuttle_value, shuttlepro_shuttle_saved)) {
        Click, WheelDown
      } Else {
        Click, WheelUp
      }
    } Else {
			MouseGetPos, , , id
			WinGetTitle, title, ahk_id %id%
      a .= """" title """ "
      If (is_shuttle_clockwise(shuttle_value, shuttlepro_shuttle_saved)) {
        Click, WheelDown
      } Else {
        Click, WheelUp
      }
    }

		a.="shuttle: " . shuttle_value . "(prev: " . shuttlepro_shuttle_saved . ") in layer " . layer

		Return
	}
;

is_shuttle_clockwise(shuttle_value, shuttlepro_shuttle_saved) {
	if (shuttle_value = 0) {
		return (shuttlepro_shuttle_saved > 127)
	} else if (shuttlepro_shuttle_saved = 0) {
		return (shuttle_value < 128)
	} else {
		return (shuttle_value > shuttlepro_shuttle_saved)
	}
}

stop_all_speed_timers()
{
  ;SetTimer, UpKey, Off
  ;SetTimer, DownKey, Off
  SetTimer, UpScroll, Off
  SetTimer, DownScroll, Off
}

UpKey:
Send, {Up}
return

DownKey:
Send, {Down}
return

set_scroll_speed(corrected_speed_saved, speed, s1, s2, s3, s4, s5, s6, s7)
{
	If (corrected_speed_saved < speed && speed > 0) {
		;Send, {Down}
		Click, WheelDown
	} Else If (corrected_speed_saved > speed && speed < 0) {
		;Send, {Up}
		Click, WheelUp
	}
	If (speed < 0) {
		scroll_direction := "UpScroll"
	} Else {
		scroll_direction := "DownScroll"
	}
	abs_speed := Abs(speed)
	If (abs_speed = 1) {
		SetTimer, %scroll_direction%, %s1%
	} Else If (abs_speed = 2) {
		SetTimer, %scroll_direction%, %s2%
	} Else If (abs_speed = 3) {
		SetTimer, %scroll_direction%, %s3%
	} Else If (abs_speed = 4) {
		SetTimer, %scroll_direction%, %s4%
	} Else If (abs_speed = 5) {
		SetTimer, %scroll_direction%, %s5%
	} Else If (abs_speed = 6) {
		SetTimer, %scroll_direction%, %s6%
	} Else If (abs_speed = 7) {
		SetTimer, %scroll_direction%, %s7%
	}
}

UpScroll:
curr_hwnd := WinExist("A")
;MsgBox % curr_hwnd
;a .= "curr_hwnd: " . curr_hwnd
If (curr_hwnd != timer_active_hwnd) {
	SetTimer, UpScroll, Off
} Else {
	Click, WheelUp
}
return

DownScroll:
curr_hwnd := WinExist("A")
;MsgBox % timer_active_hwnd
;a .= "curr_hwnd: " . curr_hwnd
If (curr_hwnd != timer_active_hwnd) {
	SetTimer, DownScroll, Off
} Else {
	Click, WheelDown
}
return

ToggleSync() {
  ControlGetFocus, FocusedControl
  WinGetTitle, OutputVar
;MsgBox, "%OutputVar%"
  If (OutputVar = "INFINITT PACS" && SubStr(FocusedControl, 1, 3) == "Afx") {
    DiffSyncBtns := ["Button1", "Button75"]
    For idx, btn in DiffSyncBtns {
      ControlGetText, t, %btn%
      if (t = "自動同步") {
        ControlClick, %btn%
        Break
      }
    }
  }
}

ToggleDiffExamSync() {
  ControlGetFocus, FocusedControl
  WinGetTitle, OutputVar
;MsgBox, "%OutputVar%"
  If (OutputVar = "INFINITT PACS" && SubStr(FocusedControl, 1, 3) == "Afx") {
    DiffSyncBtns := ["Button2", "Button76", "Button91"]
    For idx, btn in DiffSyncBtns {
      ControlGetText, t, %btn%
      if (t = "不同檢查同步 ") {
        ControlClick, %btn%
        Break
      }
    }
  }
}
