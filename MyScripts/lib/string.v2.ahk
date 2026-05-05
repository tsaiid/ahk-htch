; my Lib
;; Join Array Strings in English style

ArrayStrJoin(Arr) {
  JoinedStr := ""
  totalItem := Arr.Length
  Loop totalItem {
    if (A_Index > 1) {
      if (totalItem = 2) {
        JoinedStr .= " and "
      } else {
        if (A_Index = totalItem) {
          JoinedStr .= ", and "
        } else {
          JoinedStr .= ", "
        }
      }
    }
    JoinedStr .= Arr[A_Index]
  }
  return JoinedStr
}
