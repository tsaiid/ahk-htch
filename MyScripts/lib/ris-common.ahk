; RIS specific functions

SleepThenTab(sleepTime = 400, shiftTab = True)
{
  Sleep %sleepTime%
  If (shiftTab) {
    Send +{Tab}
  } Else {
    Send {Tab}
  }
}

GetGenderFromRIS()
{
  global AllGenderLists
  PossibleGenderEdits := ["TLabeledEdit11", "TLabeledEdit12"]
  For idx, box in PossibleGenderEdits {
    ControlGetText, t, %box%
    if t in %AllGenderLists%
      Return t
  }
}

GetAgeFromRIS()
{
  PossibleAgeEdits := ["TLabeledEdit3", "TLabeledEdit4"]
  For idx, box in PossibleAgeEdits {
    ControlGetText, t, %box%
    if (RegExMatch(t, "(\d+)((\D)+(\d+))?"))
      Return t
  }
}

GetExamTypeFromRIS()
{
  global AllExamTypeLists
  PossibleExamTypeEdits := ["TLabeledEdit10", "TLabeledEdit11"]
  For idx, box in PossibleExamTypeEdits {
    ControlGetText, t, %box%
    if t in %AllExamTypeLists%
      Return t
  }
}

GetAccNoFromRIS()
{
  PossibleAccNoEdits := ["TLabeledEdit15", "TLabeledEdit16"]
  For idx, box in PossibleAccNoEdits {
    ControlGetText, t, %box%
    if (RegExMatch(t, "A\d{15}"))
      Return t
  }
}

GetExamnameFromRIS()
{
  PossibleExamnameEdits := ["TEdit2", "TEdit3"]
  For idx, box in PossibleExamnameEdits {
    ControlGetPos, x, y, w, h, %box%
    if (x = 24 && y = 246) {
      ControlGetText, t, %box%
      Return t
    }
  }
}

GetContrastFromRIS()
{
  PossibleContrastEdits := ["TLabeledEdit3"]
  For idx, box in PossibleContrastEdits {
    ControlGetPos, x, y, w, h, %box%
    if (x = 512 && y = 246) {
      ControlGetText, t, %box%
      Return t
    }
  }
}

GetObjectiveFromRIS()
{
  PossibleObjectiveEdits := ["TMemo4"]
  For idx, box in PossibleObjectiveEdits {
    ControlGetPos, x, y, w, h, %box%
    if (x = 352 && y = 294) {
      ControlGetText, t, %box%
      Return t
    }
  }
}
