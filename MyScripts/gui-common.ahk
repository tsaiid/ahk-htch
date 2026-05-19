; Gui related

GuiClose:
LLDGuiEscape:
  Gui, Destroy
Return

LLDButtonOK:
  Gui, Submit, NoHide  ; Save the input from the user to each control's associated variable.
  If (LLDFormRtLL = "" || LLDFormLtLL = "") {
    MsgBox, Empty value
    Return
  }

  RtLL := Round(LLDFormRtLL / 10, 1)
  LtLL := Round(LLDFormLtLL / 10, 1)
  delta := Round(Abs(RtLL - LtLL), 1)
  MeningfulLLD := (delta >= 1 ? "Evidence of leg length discrepancy." : "No evidence of leg length discrepancy.")
  MyForm =
(
Triple film of lower extremities in standing AP projection:
Lower limb length is measured between center of femoral head and center of superior contour of talar trochlea.

- Right lower limb length: %RtLL% cm
- Left lower limb length: %LtLL% cm
- Limb length discrepancy: %delta% cm

IMPRESSION:
%MeningfulLLD%
)
  Gui, Destroy
  WinActivate, ahk_id %hParentWnd%
  Paste(MyForm)
Return

;; for LLD form

LLDForm()
{
  global LLDFormRtLL, LLDFormLtLL
  Gui, LLD: New
  Gui, font, s12, Verdana
  Gui, LLD: Add, Text, x12 y22 w160 h20, Right Leg Length
  Gui, LLD: Add, Text, x12 y72 w160 h20, Left Leg Length
  Gui, LLD: Add, Edit, x162 y20 w80 h22 vLLDFormRtLL Number,
  Gui, LLD: Add, Edit, x162 y70 w80 h22 vLLDFormLtLL Number,
  Gui, LLD: Add, Text, x252 y22 w30 h20, mm
  Gui, LLD: Add, Text, x252 y72 w30 h20, mm
  Gui, LLD: Add, Button, x12 y120 w40 h30 gLLDButtonOK default, OK

  ; ShowGUIatCurrScreenCenter
  ;get current monitor index
	CurrentMonitorIndex:=GetCurrentMonitorIndex()
	;get Hwnd of current GUI
	DetectHiddenWindows On
	Gui, +LastFound
	Gui, Show, Hide
	GUI_Hwnd := WinExist()
	;Calculate size of GUI
	GetClientSize(GUI_Hwnd,GUI_Width,GUI_Height)
	DetectHiddenWindows Off
	;Calculate where the GUI should be positioned
	GUI_X:=CoordXCenterScreen(GUI_Width,CurrentMonitorIndex)
	GUI_Y:=CoordYCenterScreen(GUI_Height,CurrentMonitorIndex)

  Gui, Show, % "x" GUI_X " y" GUI_Y, LLD Helper
}

;; Prostate size calculation form
ProstateSizeCalForm()
{
  global ProstateSizeCalFormWidth, ProstateSizeCalFormLength, ProstateSizeCalFormHeight
  Gui, PSC: New
  Gui, font, s12, Verdana
  Gui, PSC: Add, Text, x12 y22 w160 h20, Width
  Gui, PSC: Add, Text, x12 y72 w160 h20, Length
  Gui, PSC: Add, Text, x12 y122 w160 h20, Height
  Gui, PSC: Add, Edit, x162 y20 w80 h22 vProstateSizeCalFormWidth Number,
  Gui, PSC: Add, Edit, x162 y70 w80 h22 vProstateSizeCalFormLength Number,
  Gui, PSC: Add, Edit, x162 y120 w80 h22 vProstateSizeCalFormHeight Number,
  Gui, PSC: Add, Text, x252 y22 w30 h20, mm
  Gui, PSC: Add, Text, x252 y72 w30 h20, mm
  Gui, PSC: Add, Text, x252 y122 w30 h20, mm
  Gui, PSC: Add, Button, x12 y170 w40 h30 gPSCButtonOK default, OK

  ; ShowGUIatCurrScreenCenter
  ;get current monitor index
	CurrentMonitorIndex:=GetCurrentMonitorIndex()
	;get Hwnd of current GUI
	DetectHiddenWindows On
	Gui, +LastFound
	Gui, Show, Hide
	GUI_Hwnd := WinExist()
	;Calculate size of GUI
	GetClientSize(GUI_Hwnd,GUI_Width,GUI_Height)
	DetectHiddenWindows Off
	;Calculate where the GUI should be positioned
	GUI_X:=CoordXCenterScreen(GUI_Width,CurrentMonitorIndex)
	GUI_Y:=CoordYCenterScreen(GUI_Height,CurrentMonitorIndex)

  Gui, Show, % "x" GUI_X " y" GUI_Y, Prostate Size Helper
}

PSCButtonOK:
  Gui, Submit, NoHide  ; Save the input from the user to each control's associated variable.
  If (ProstateSizeCalFormWidth = "" || ProstateSizeCalFormLength = "" || ProstateSizeCalFormHeight = "") {
    MsgBox, Empty value
    Return
  }

  PrWidth := Round(ProstateSizeCalFormWidth / 10, 1)
  PrLength := Round(ProstateSizeCalFormLength / 10, 1)
  PrHeight := Round(ProstateSizeCalFormHeight / 10, 1)
  PrVol := Round(PrWidth * PrLength * PrHeight * 0.52, 1)
;  MyForm =
;(
;- Size: %PrWidth% x %PrLength% x %PrHeight% cm
;- Volume: %PrVol% ml (length x width x height x 0.52)
;)
  MyForm =
(
Prostatic size: %PrWidth% x %PrLength% x %PrHeight% cm; Volume: %PrVol% ml (length x width x height x 0.52).
)
  Gui, Destroy
  WinActivate, ahk_id %hParentWnd%
  Paste(MyForm)
Return
