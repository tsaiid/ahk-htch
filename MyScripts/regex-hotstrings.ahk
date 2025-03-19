; My RegEx HotStrings
#Include Lib\Hotstrings.ahk
hotstrings("plsp(\d)(\d)\s", "plsp")
hotstrings("pcsp(\d)(\d)\s", "pcsp")
hotstrings("sb([rl])l(1[0-2](-\d+)?|[1-9](-\d+)?)\/(\d+)\s", "sbl")
hotstrings("([RL])(1[0-2](-\d+)?|[1-9](-\d+)?)\/(\d+)\s", "bl")
hotstrings("ca([1-9]|[1-8][0-9])\s", "ca")
hotstrings("([1-9]|[1][0-2])t([1-9]|[1][0-2])\s", "nr")
Return

plsp:
  start := $1
  end := $2
  if (end <= start && end != 1) {
    return
  }
  ; L1~S1
  if (start = 1 && start = end) {
    range := "L1~S1"
    cage := "L1-2, L2-3, L3-4, L4-5, L5-S1"
  } else {
    range = L%start%~
  if (end = 1) {
    range = %range%S1
  } else {
    range = %range%L%end%
  }
    cage = L%start%
    Loop {
      startStr = %start%
      if (++start = end) {
        cage = %cage%-%end%
        break
      } else {
        if (end = 1 and start = 6) {
          cage = %cage%-S1
          break
        } else {
          endStr = %start%
        }
      }

      cage = %cage%-%endStr%, L%endStr%
    }
  }
  finalStr =
(
Status post laminectomy, transpedicular screws, rods fixation at %range%.
Status post interbody cage placement at %cage%.
)
  Paste(finalStr)
Return

pcsp:
  start := $1
  end := $2
  if (end <= start and end != 1)
    return
  if (start = 1 and start = end) { ; C1-T1
    range := "C1~T1"
    cage := "C1-2, C2-3, C3-4, C4-5, C5-6, C6-7, C7-T1"
  } else {
    range = C%start%~
    if (end = 1) {
      range = %range%T1
    } else {
      range = %range%C%end%
    }
    cage = C%start%
    Loop {
      startStr = %start%
      if (++start = end) {
        cage = %cage%-%end%
        break
      } else {
        if (end = 1 and start = 8) {
          cage = %cage%-T1
          break
        } else {
          endStr = %start%
        }
      }

      cage = %cage%-%endStr%, C%endStr%
    }
  }
  finalStr =
(
Status post anterior cervical plate fixation at %range%.
Status post interbody cage placement at %cage%.
)
  Paste(finalStr)
Return

sbl:
  laterality := ($1 == "r" ? "right" : "left")
  oclock := $2
  distance := $5

  if (distance) {
    finalStr =
(
in the %laterality% breast, %oclock%'/%distance%cm.
)
  } else {
    finalStr =
(
in the %laterality% breast, %oclock%'/subareolar.
)
  }
  Paste(finalStr)
Return

bl:
  laterality := ($1 == "R" ? "Right" : "Left")
  oclock := $2
  distance := $5

  if (distance) {
    finalStr =
(
%laterality% %oclock%'/%distance%cm.
)
  } else {
    finalStr =
(
%laterality% %oclock%'/subareolar.
)
  }
  Paste(finalStr)
Return


ca:
  ca_degree := $1
  finalStr =
(
Cobb angle: %ca_degree% degree.
)
  Paste(finalStr)
Return

nr:
  global ORDINAL_NUM_STR
  n_start := ORDINAL_NUM_STR[$1]
  n_end := ORDINAL_NUM_STR[$2]
  finalStr =
(
%n_start% to %n_end%
)
  Paste(finalStr)
Return
