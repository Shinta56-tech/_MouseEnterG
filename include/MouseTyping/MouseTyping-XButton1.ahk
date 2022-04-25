;*****************************************************************************************************************************************
; Hotkey
;*****************************************************************************************************************************************    

    #If gFXB2to1 & !gFXB1

        *XButton1 Up::gFXB2to1 := False

    #If gFXB1

        *XButton1 Up::
            If (GetKeyState("LAlt")) {
                Send, {LAlt Up}
            } Else {
                Send, {LControl Up}
            }
            gFXB1 := False
        Return

    #If checkMouseTypingDesktop() & !gFXB1 & !GetKeyState("LShift")

        *XButton1::
            gFXB1 := True
            If (A_PriorKey="XButton1") & (A_TimeSincePriorHotkey < DUBL_CLICK_DELAY) {
                Send, {LAlt Down}
            } Else {
                Send, {LControl Down}
            }
        Return

    #If checkMouseTypingDesktop() & !gFXB2to1 & GetKeyState("LShift")

        *XButton1::
            gFXB2to1 := True
            gFXB2 := False
            Send, {LShift Up}
            KeyWait, XButton1, T%LONG_PRESS_DELAY%
            If (!ErrorLevel) & (A_PriorKey="XButton1") {
                Send, ^{Space}
            }
        Return