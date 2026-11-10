#Requires AutoHotkey v2.0

#Include ..\Lib\Paste.v2.ahk

; Breast MRI Hotstrings
::bmrlapok::No definite lymphadenopathy at both axillae or internal mammary regions.

::bmr::
{
    MyForm := "
(
MRI of breast without and with IV Gadolinium.

SCANNING PROTOCOL:
- Axial T1, STIR, DWI/ADC.
- Axial dynamic study without/with subtraction, coronal and sagittal MIP collections
- Axial thin slice T1 postcontrast, coronal and sagittal reconstruction
- Enhancement kinetic curves for focal lesions

COMPARISON: no

FINDINGS:
A 2.1 cm nodular lesion at 12 o'clock position of right breast, 2 cm from the nipple, shows T1 hypointensity, T2 hyperintensity, restricted diffusion, post-contrast enhancement with type III curve, suggestive of breast cancer.

A 6 mm nodule at 12 o'clock position of left breast, 2 cm from the nipple. Follow-up is suggested.

No definite lymphadenopathy at both axillae.
No definite lymphadenopathy at both axillae or internal mammary regions.

)"
    Paste(MyForm)
}