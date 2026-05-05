#Requires AutoHotkey v2.0

#Include ..\Lib\Hotstrings.v2.ahk
#Include ..\Lib\Paste.v2.ahk

; My RegEx HotStrings
hotstrings("plsp(\d)(\d)\n", "plsp")
hotstrings("pcsp(\d)(\d)\n", "pcsp")
hotstrings("sb([rl])l(1[0-2](-\d+)?|[1-9](-\d+)?)\/(\d+)\n", "sbl")
hotstrings("([RL])(1[0-2](-\d+)?|[1-9](-\d+)?)\/(\d+)\n", "bl")
hotstrings("ca([1-9]|[1-8][0-9])\n", "ca")
hotstrings("([1-9]|[1][0-2])t([1-9]|[1][0-2])\n", "nr")
hotstrings("\b(\d{1,2})y(([0-9]|1[01])m)?\n", "age")

global ORDINAL_NUM_STR := Map(
    "1", "1st", "2", "2nd", "3", "3rd", "4", "4th", "5", "5th",
    "6", "6th", "7", "7th", "8", "8th", "9", "9th", "10", "10th",
    "11", "11th", "12", "12th"
)

plsp() {
    global hsMatch ; 使用合法的變數名稱
    start := Integer(hsMatch[1])
    end_val := Integer(hsMatch[2])

    if (end_val <= start && end_val != 1) {
        return
    }

    ; L1~S1
    if (start == 1 && start == end_val) {
        range := "L1~S1"
        cage := "L1-2, L2-3, L3-4, L4-5, L5-S1"
    } else {
        range := "L" . start . "~"
        if (end_val == 1) {
            range .= "S1"
        } else {
            range .= "L" . end_val
        }

        cage := "L" . start
        loop {
            startStr := start
            start += 1
            if (start == end_val) {
                cage .= "-" . end_val
                break
            } else {
                if (end_val == 1 && start == 6) {
                    cage .= "-S1"
                    break
                } else {
                    endStr := start
                }
            }

            cage .= "-" . endStr . ", L" . endStr
        }
    }

    finalStr := Format("
(
Status post laminectomy, transpedicular screws, rods fixation at {1}.
Status post interbody cage placement at {2}.
)",
        range, cage)
    Paste(finalStr)
}

pcsp() {
    global hsMatch
    start := Integer(hsMatch[1])
    end_val := Integer(hsMatch[2])

    if (end_val <= start && end_val != 1)
        return

    if (start == 1 && start == end_val) { ; C1-T1
        range := "C1~T1"
        cage := "C1-2, C2-3, C3-4, C4-5, C5-6, C6-7, C7-T1"
    } else {
        range := "C" . start . "~"
        if (end_val == 1) {
            range .= "T1"
        } else {
            range .= "C" . end_val
        }

        cage := "C" . start
        loop {
            startStr := start
            start += 1
            if (start == end_val) {
                cage .= "-" . end_val
                break
            } else {
                if (end_val == 1 && start == 8) {
                    cage .= "-T1"
                    break
                } else {
                    endStr := start
                }
            }

            cage .= "-" . endStr . ", C" . endStr
        }
    }

    finalStr := Format("
(
Status post anterior cervical plate fixation at {1}.
Status post interbody cage placement at {2}.
)", range, cage)
    Paste(finalStr)
}

sbl() {
    global hsMatch
    laterality := (hsMatch[1] = "r" ? "right" : "left")
    oclock := hsMatch[2]
    distance := hsMatch[5]

    if (distance != "") {
        finalStr := Format("
(
in the {1} breast, {2}'/{3}cm.
)", laterality, oclock, distance)
    } else {
        finalStr := Format("
(
in the {1} breast, {2}'/subareolar.
)", laterality, oclock)
    }
    Paste(finalStr)
}

bl() {
    global hsMatch
    laterality := (hsMatch[1] = "R" ? "Right" : "Left")
    oclock := hsMatch[2]
    distance := hsMatch[5]

    if (distance != "") {
        finalStr := Format("
(
{1} {2}'/{3}cm.
)", laterality, oclock, distance)
    } else {
        finalStr := Format("
(
{1} {2}'/subareolar.
)", laterality, oclock)
    }
    Paste(finalStr)
}

ca() {
    global hsMatch
    ca_degree := hsMatch[1]
    finalStr := Format("
(
Cobb angle: {1} degree.
)", ca_degree)
    Paste(finalStr)
}

nr() {
    global hsMatch
    global ORDINAL_NUM_STR
    if IsSet(ORDINAL_NUM_STR) {
        ; 注意：Map 取值時，key 的型別很重要。RegEx 抓出來的是字串。
        n_start := ORDINAL_NUM_STR.Has(hsMatch[1]) ? ORDINAL_NUM_STR[hsMatch[1]] : hsMatch[1]
        n_end := ORDINAL_NUM_STR.Has(hsMatch[2]) ? ORDINAL_NUM_STR[hsMatch[2]] : hsMatch[2]
        finalStr := n_start . " to " . n_end . " "
        Paste(finalStr)
    }
}

age() {
    global hsMatch
    Years := Integer(hsMatch[1])
    Months := (hsMatch[3] != "") ? Integer(hsMatch[3]) : 0

    ; Validate month range
    if (hsMatch[3] != "" && (Months < 0 || Months > 11)) {
        return
    }

    ; Handle year pluralization
    if (Years == 1) {
        YearPart := Years . " year"
    } else {
        YearPart := Years . " years"
    }

    ; Handle month pluralization
    finalStr := YearPart
    if (hsMatch[3] != "") {
        if (Months == 1) {
            MonthPart := Months . " month"
        } else {
            MonthPart := Months . " months"
        }
        finalStr .= " " . MonthPart
    }

    Paste(finalStr)
}
