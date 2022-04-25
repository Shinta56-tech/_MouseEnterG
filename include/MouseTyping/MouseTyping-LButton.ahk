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

    #If gFLB

        *LButton Up::
            vTime := LONG_PRESS_DELAY * 1000
            If (A_TimeSincePriorHotkey < vTime) & (A_PriorHotkey == "*RButton Up") {
                moveMPoseNextMonitor()
            }
            gFLB := False
        Return

    #If gFRB & !gFLB

        *LButton::gFLB := True