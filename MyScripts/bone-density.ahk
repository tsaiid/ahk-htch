; Hotstrings for BD
; to get bone density report by ajax.

::bmd::
  ;LiberaBMD()
  MyForm =
(
Bone density examination L-spine:

Average bone mineral density (BMD) of L1-L4 is 0.697 gm/cm2, about 67`% of the mean of young reference value (T-score = -3.2).

The BMD meets the criteria of osteoporosis, according to the WHO (World Health Organization) classification.
)

  Paste(MyForm)
  SleepThenTab()
  MyForm =
(
Osteoporosis, T-score = -3.2.
)
  Paste(MyForm)
Return

::bmd1::
  LiberaBMDSR()
Return