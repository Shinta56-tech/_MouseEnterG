
;*****************************************************************************************************************************************
; Hotkey
;*****************************************************************************************************************************************

    #If gFRB

        *LButton::gFLB := True

        *LButton Up::gFLB := False
    
    #If gFLB

        *LButton Up::
            vTime := LONG_PRESS_DELAY * 1000
            If (A_TimeSincePriorHotkey < vTime) & (A_PriorHotkey == "*LButton") {
                moveMPoseNextMonitor()
            }
            gFLB := False
        Return

    #If gFRCtoRS

        *LButton::Send, +{Tab}

        *Space::
            gFSP := True
            KeyWait, Space, T%LONG_PRESS_DELAY%
            If (!ErrorLevel) & (A_PriorKey="Space") {
                Send, {Blind}{Space}
            }
        Return