;*****************************************************************************************************************************************
; Hotkey
;*****************************************************************************************************************************************

    #If checkOnDesktop() & !spc

        *Space::
            KeyFlag.SPC := True
            KeyWait, Space, T%LONG_PRESS_DELAY%
            If (!ErrorLevel) & (A_PriorKey="Space") {
                Send, {Blind}{Space}
            }
            KeyWait, Space
        Return

    #If KeyFlag.SPC & !spc

        *Space Up::
            KeyFlag.SPC := False
        Return
