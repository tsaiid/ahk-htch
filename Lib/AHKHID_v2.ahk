#Requires AutoHotkey v2.0

AHKHID_UseConstants() {
    static initialized := false
    global RIM_TYPEHID, RIDEV_INPUTSINK, DI_HID_VENDORID, DI_HID_PRODUCTID
    if initialized {
        return
    }
    RIM_TYPEHID := 2
    RIDEV_INPUTSINK := 0x00000100
    DI_HID_VENDORID := 8
    DI_HID_PRODUCTID := 12
    initialized := true
}

AHKHID_Register(UsagePage := 0, Usage := 0, Handle := 0, Flags := 0) {
    structSize := 8 + A_PtrSize
    buffer := Buffer(structSize, 0)
    if ((Flags & 0x00000001) || (Flags & 0x00000010)) {
        Handle := 0
    }
    NumPut("UShort", UsagePage, buffer, 0)
    NumPut("UShort", Usage, buffer, 2)
    NumPut("UInt", Flags, buffer, 4)
    NumPut("Ptr", Handle, buffer, 8)
    result := DllCall("RegisterRawInputDevices", "ptr", buffer, "uint", 1, "uint", structSize)
    if !result {
        throw OSError(A_LastError, result, "RegisterRawInputDevices failed")
    }
    return 0
}

AHKHID_GetInputInfo(InputHandle, Flag) {
    static cache := { handle: 0, data: 0 }
    headerSize := 8 + A_PtrSize * 2
    if cache.handle != InputHandle {
        size := 0
        result := DllCall("GetRawInputData", "ptr", InputHandle, "uint", 0x10000003, "ptr", 0, "uint*", size, "uint", headerSize)
        if (result = -1) {
            throw OSError(A_LastError, result, "GetRawInputData (size) failed")
        }
        cache.data := Buffer(size)
        result := DllCall("GetRawInputData", "ptr", InputHandle, "uint", 0x10000003, "ptr", cache.data, "uint*", size, "uint", headerSize)
        if (result = -1 || result != size) {
            throw OSError(A_LastError, result, "GetRawInputData (data) failed")
        }
        cache.handle := InputHandle
    }
    flagCopy := Flag
    isShort := AHKHID_NumIsShort(&flagCopy)
    isSigned := AHKHID_NumIsSigned(&flagCopy)
    if isShort {
        type := isSigned ? "Short" : "UShort"
    } else {
        if isSigned {
            type := "Int"
        } else if (flagCopy = 8) {
            type := "Ptr"
        } else {
            type := "UInt"
        }
    }
    return NumGet(cache.data, flagCopy, type)
}

AHKHID_GetInputData(InputHandle, &uData) {
    headerSize := 8 + A_PtrSize * 2
    size := 0
    result := DllCall("GetRawInputData", "ptr", InputHandle, "uint", 0x10000003, "ptr", 0, "uint*", size, "uint", headerSize)
    if (result = -1) {
        throw OSError(A_LastError, result, "GetRawInputData (size) failed")
    }
    raw := Buffer(size)
    result := DllCall("GetRawInputData", "ptr", InputHandle, "uint", 0x10000003, "ptr", raw, "uint*", size, "uint", headerSize)
    if (result = -1 || result != size) {
        throw OSError(A_LastError, result, "GetRawInputData (data) failed")
    }
    dataSize := NumGet(raw, headerSize + 0, "UInt")
    dataCount := NumGet(raw, headerSize + 4, "UInt")
    total := dataSize * dataCount
    uData := Buffer(total)
    DllCall("RtlMoveMemory", "ptr", uData.Ptr, "ptr", raw.Ptr + headerSize + 8, "uptr", total)
    return total
}

AHKHID_GetDevInfo(i, Flag, IsHandle := false) {
    if !IsHandle {
        throw ValueError("AHKHID_GetDevInfo in this implementation requires a handle")
    }
    static cache := { handle: 0, info: 0 }
    handle := i
    if cache.handle != handle {
        length := 0
        result := DllCall("GetRawInputDeviceInfo", "ptr", handle, "uint", 0x2000000b, "ptr", 0, "uint*", length)
        if (result = -1) {
            throw OSError(A_LastError, result, "GetRawInputDeviceInfo (size) failed")
        }
        cache.info := Buffer(length, 0)
        NumPut("UInt", length, cache.info, 0)
        result := DllCall("GetRawInputDeviceInfo", "ptr", handle, "uint", 0x2000000b, "ptr", cache.info, "uint*", length)
        if (result = -1) {
            throw OSError(A_LastError, result, "GetRawInputDeviceInfo (data) failed")
        }
        cache.handle := handle
    }
    flagCopy := Flag
    type := AHKHID_NumIsShort(&flagCopy) ? "UShort" : "UInt"
    return NumGet(cache.info, flagCopy, type)
}

AHKHID_NumIsShort(&Flag) {
    if (Flag & 0x0100) {
        Flag ^= 0x0100
        return true
    }
    return false
}

AHKHID_NumIsSigned(&Flag) {
    if (Flag & 0x1000) {
        Flag ^= 0x1000
        return true
    }
    return false
}
