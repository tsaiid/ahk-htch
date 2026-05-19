; Global Variables
prevExamDate := ""
currExamDate := ""
currAccNo := ""
prevPatID := ""

WebRISisInit := 0

hParentWnd := 0
opdListObj := 0
pathoListObj := 0

LLDFormRtLD := 0
LLDFormLtLD := 0
FsgRadioGroup := 0
ProstateSizeCalFormWidth := 0
ProstateSizeCalFormLength := 0
ProstateSizeCalFormHeight := 0

;; RIS related
FocusedControl := ""

AllExamTypeLists := "BMD,CR,DX,CT,MG,MR,MRI,NM,OT,PT,RF,SC,US,XA"
AllGenderLists := "M,F"

ABD_CT_GENDER_SPECIFIC_STR := { M: "Prostate: Unremarkable"
                               ,F: "GYN organ: Unremarkable" }
ABD_CT_GENDER_SPECIFIC_STR_WITH_LIST := { M: "- Prostate: Unremarkable"
                                         ,F: "- GYN organ: Unremarkable" }
CONTRAST_STR := { X5A: " without contrast medium"
                 ,X5B: " with contrast medium"
                 ,X5C: " without and with contrast medium"
                 ,X6A: " without contrast medium"
                 ,X6B: " with contrast medium"
                 ,X6C: " without and with contrast medium" }

ORDINAL_NUM_STR := { 1:   "1st"
                    ,2:   "2nd"
                    ,3:   "3rd"
                    ,4:   "4th"
                    ,5:   "5th"
                    ,6:   "6th"
                    ,7:   "7th"
                    ,8:   "8th"
                    ,9:   "9th"
                    ,10:  "10th"
                    ,11:  "11th"
                    ,12:  "12th"  }


;; counters for statistics
cntGetPreviousReport := 0
cntGetPreviousReportSuccess := 0
v_Count := 0
m_Count_Lt := 0
m_Count_Md := 0
m_Count_Rt := 0
