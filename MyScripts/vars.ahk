﻿; Global Variables
prevExamDate := ""
currExamDate := ""
currAccNo := ""
prevPatID := ""

WebRISisInit := 0

hParentWnd := 0
hHeliosWnd := 0
findingObj := 0
impObj := 0
abnormalValueObjs := {}
mismatchValueObjs := {}
reportListObj := 0
examListObj := 0
opdListObj := 0
pathoListObj := 0
reportStatusObj := 0
prevReportStatusObj := 0
findingScrollBarUpObj := 0
findingScrollBarDownObj := 0
impScrollBarUpObj := 0
impScrollBarDownObj := 0

LLDFormRtLD := 0
LLDFormLtLD := 0
FsgRadioGroup := 0
ProstateSizeCalFormWidth := 0
ProstateSizeCalFormLength := 0
ProstateSizeCalFormHeight := 0

;; RIS related
FocusedControl =

AllExamTypeLists = BMD,CR,DX,CT,MG,MR,MRI,NM,OT,PT,RF,SC,US,XA
AllGenderLists = M,F

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


;; Helios Related
REPORT_STATUS_PATH              := "4.9.1.1"
FINDING_INPUT_PATH              := "4.9.32.1"
IMPRESSION_INPUT_PATH           := "4.9.35"
FINDING_SCROLLBAR_DOWN_PATH     := "4.9.32.2.3"
FINDING_SCROLLBAR_UP_PATH       := "4.9.32.2.4"
IMPRESSION_SCROLLBAR_DOWN_PATH  := "4.9.35.1.3"
IMPRESSION_SCROLLBAR_UP_PATH    := "4.9.35.1.4"
__ABNORMAL_VALUE_EMPTY            := "4.9.10.2"
__ABNORMAL_VALUE_A                := "4.9.10.3"
__ABNORMAL_VALUE_B                := "4.9.10.4"
__ABNORMAL_VALUE_C                := "4.9.10.5"
__ABNORMAL_VALUE_D                := "4.9.10.6"
__ABNORMAL_VALUE_R                := "4.9.10.7"
ABNORMAL_VALUE_PATH := {  0:  __ABNORMAL_VALUE_EMPTY
                         ,A:  __ABNORMAL_VALUE_A
                         ,B:  __ABNORMAL_VALUE_B
                         ,C:  __ABNORMAL_VALUE_C
                         ,D:  __ABNORMAL_VALUE_D
                         ,R:  __ABNORMAL_VALUE_R      }
__MISMATCH_VALUE_EMPTY            := "4.9.12.2"
__MISMATCH_VALUE_A                := "4.9.12.3"
__MISMATCH_VALUE_B                := "4.9.12.4"
__MISMATCH_VALUE_C                := "4.9.12.5"
MISMATCH_VALUE_PATH := {  0:  __MISMATCH_VALUE_EMPTY
                         ,A:  __MISMATCH_VALUE_A
                         ,B:  __MISMATCH_VALUE_B
                         ,C:  __MISMATCH_VALUE_C      }

PREV_REPORT_TAB_PATH            := "4.7.2.1"
LIS_TAB_PATH                    := "4.7.2.2"
EXAM_TAB_PATH                   := "4.7.2.3"
CONVERSATION_TAB_PATH           := "4.7.2.4"
INF_CONTROL_TAB_PATH            := "4.7.2.5"
OPD_TAB_PATH                    := "4.7.2.6"
PNOTE_TAB_PATH                  := "4.7.2.7"
OP_ADM_PATHO_TAB_PATH           := "4.7.2.8"

PREV_REPORT_STATUS_PATH         := "4.7.2.1.4"
PREV_FINDING_TEXT_PATH          := "4.7.2.1.6"
PREV_IMPRESSION_TEXT_PATH       := "4.7.2.1.9"

;; counters for statistics
cntGetPreviousReport := 0
cntGetPreviousReportSuccess := 0
v_Count := 0
m_Count_Lt := 0
m_Count_Md := 0
m_Count_Rt := 0
