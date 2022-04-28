;*****************************************************************************************************************************************
; Function
;*****************************************************************************************************************************************

    moveMPoseNextMonitor() {
        MouseGetPos, vMX, vMY
        SysGet, MonCount, MonitorCount
        Loop, %MonCount% {
            SysGet, Mon, Monitor, %A_Index%
            If ( (MonLeft <= vMX) & (MonRight >= vMX) & (MonBottom >= vMY) & (MonTop <= vMY) ) {
                If (A_Index <> MonCount) {
                    vNextMonNum := A_Index + 1
                } Else {
                    vNextMonNum := 1
                }
                SysGet, Mon, Monitor, %vNextMonNum%
                vTMX := ( MonLeft + MonRight ) / 2
                vTMY := ( MonTop + MonBottom ) / 2
                MouseMove, %vTMX%, %vTMY%
                Break
            }
        }
    }

;*****************************************************************************************************************************************
; Hotkey
;*****************************************************************************************************************************************    

    #If checkOnDesktop() & !rlb

        *RButton::
            KeyFlag.RB := True
            KeyWait, RButton, T%LONG_PRESS_DELAY%
            If (!ErrorLevel) & (A_PriorKey = "RButton") {
                Send, {Blind}{RButton}
            }
        Return

    #If KeyFlag.RB & !rlb

        *LButton::
            KeyFlag.LB := True
        Return

        *RButton Up::
            KeyFlag.RB := False
        Return

        *WheelDown::WheelRight
        *WheelUp::WheelLeft
    
    #If KeyFlag.LB & !rlb

        *LButton Up::
            KeyWait, LButton, T%LONG_PRESS_DELAY%
            If (!ErrorLevel)
                & (A_PriorHotkey = "**RButton Up")
                & (A_TimeSincePriorHotkey < (LONG_PRESS_DELAY * 1000))
                & !KeyFlag.RB {
                    moveMPoseNextMonitor()
            }
            KeyFlag.LB := False
        Return
