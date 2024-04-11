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

; need to reimplant
GetGenderFromRIS() {

}

GetAgeFromRIS() {

}