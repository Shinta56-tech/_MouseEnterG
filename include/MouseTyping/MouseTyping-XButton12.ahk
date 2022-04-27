;*****************************************************************************************************************************************
; Function
;*****************************************************************************************************************************************

    actionMouseMoveA(pSleep) {
        Sleep, %pSleep%
        WinGetPos, vWX, vWY, vWW, vWH, A
        vMX := vWX + (vWW / 2)
        vMY := vWY + (vWH / 2)
        MouseMove, %vMX%, %vMY%
        Send, {LControl}
    }

;*****************************************************************************************************************************************
; Hotkey
;*****************************************************************************************************************************************

    #If checkOnDesktop() & !xb12

        *XButton1::
            KeyFlag.XB1 := True
            If (GetKeyState("LShift")) {
                KeyFlag.XB21 := True
                Send, {LShift Up}
                KeyWait, XButton1, T%LONG_PRESS_DELAY%
                If (!ErrorLevel) & (A_PriorKey="XButton1") {
                    Send, ^{Space}
                }
            } Else If (A_PriorKey="XButton1") & (A_TimeSincePriorHotkey<DUBL_CLICK_DELAY) {
                Send, {LAlt Down}
            } Else {
                Send, {LControl Down}
            }
            KeyWait, XButton1
        Return

        *XButton2::
            KeyFlag.XB2 := True
            If (GetKeyState("LControl")) {
                KeyFlag.XB12 := True
                Send, {LControl Up}{LAlt Down}{Tab}
            } Else If (A_PriorKey="XButton2") & (A_TimeSincePriorHotkey<DUBL_CLICK_DELAY) {
                Send, {LWin Down}
            } Else {
                Send, {LShift Down}
            }
            KeyWait, XButton2
        Return

    #If KeyFlag.XB2 & !xb12

        *XButton2 Up::
            If (KeyFlag.XB12) {
                Send, {LAlt Up}
                KeyFlag.XB12 := False
                actionMouseMoveA(50)
            } Else If (GetKeyState("LWin")) {
                Send, {LWin Up}
            } Else {
                Send, {LShift Up}
            }
            KeyFlag.XB2 := False
        Return

    #If KeyFlag.XB1 & !xb12

        *XButton1 Up::
            If (KeyFlag.XB21) {
                KeyFlag.XB21 := False
            } Else If (GetKeyState("LAlt")) {
                Send, {LAlt Up}
            } Else {
                Send, {LControl Up}
            }
            KeyFlag.XB1 := False
        Return
    
    #If KeyFlag.XB12

        *RButton::Send, {Tab}
        *LButton::Send, +{Tab}
    
    #If KeyFlag.XB21 & !else

        *LButton::XButton1
        *RButton::XButton2
        *MButton::Send, !{F4}
        *WheelUp::PgUp
        *WheelDown::PgDn
        *Tab::WinSet, AlwaysOnTop, On, A
        *CapsLock::WinSet, AlwaysOnTop, Off, A
        *vkF0::WinSet, AlwaysOnTop, Off, A