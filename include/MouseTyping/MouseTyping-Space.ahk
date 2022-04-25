;*****************************************************************************************************************************************
; Hotkey
;*****************************************************************************************************************************************    
    
    #If gFSPC

        *Space Up::gFSPC := False

    #If checkMouseTypingDesktop() & !gFSPC

        *Space::
            gFSPC := True
            KeyWait, Space, T%LONG_PRESS_DELAY%
            If (!ErrorLevel) & (A_PriorKey="Space") {
                Send, {Blind}{Space}
            }
        Return