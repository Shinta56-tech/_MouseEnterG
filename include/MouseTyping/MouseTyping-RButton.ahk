;*****************************************************************************************************************************************
; Hotkey
;*****************************************************************************************************************************************    

    #If gFRB

        *RButton Up::gFRB := False
        *WheelUp::WheelLeft
        *WheelDown::WheelRight

    #If checkMouseTypingDesktop() & !gFRB

        *RButton::
            gFRB := True
            KeyWait, RButton, T%LONG_PRESS_DELAY%
            If (!ErrorLevel) & (A_PriorKey = "RButton") {
                Send, {Blind}{RButton}
            }
        Return