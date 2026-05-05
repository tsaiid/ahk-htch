; RIS specific functions

SleepThenTab(sleepTime := 400, shiftTab := true)
{
  Sleep sleepTime
  if (shiftTab) {
    Send "+{Tab}"
  } else {
    Send "{Tab}"
  }
}

; need to reimplant
GetGenderFromRIS() {
}

GetAgeFromRIS() {
}
