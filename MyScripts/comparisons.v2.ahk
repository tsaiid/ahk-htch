#Requires AutoHotkey v2.0

#Include lib\date.v2.ahk

; Comparisons
; need other string and date lib
::nic:: {
  StringWithPrevExamDate("No obvious interval changes compared to the previous study")
}

::nip:: {
  StringWithPrevExamDate("No obvious improvement compared to the previous study")
}

::mip:: {
  StringWithPrevExamDate("Mild improvement compared to the previous study")
}

::pc:: {
  StringWithPrevExamDate("Progressive changes compared to the previous study")
}

::mpc:: {
  StringWithPrevExamDate("Mild progressive changes compared to the previous study")
}

::rc:: {
  StringWithPrevExamDate("Regressive changes compared to the previous study")
}

::mrc:: {
  StringWithPrevExamDate("Mild regressive changes compared to the previous study")
}