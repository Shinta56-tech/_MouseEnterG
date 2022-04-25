;*****************************************************************************************************************************************
; Hotkey
;*****************************************************************************************************************************************    
    
    #If gFXB1to2 & !gFXB2

        *XButton2 Up::
            Send, {LAlt Up}
            gFXB1to2 := False
        Return
    
    #If gFXB2 & !GetKeyState("LControl")

        *XButton2 Up::
            If (GetKeyState("LWin")) {
                Send, {LWin Up}
            } Else {
                Send, {LShift Up}
            }
            gFXB2 := False
        Return

    #If checkMouseTypingDesktop() & !gFXB2 & !GetKeyState("LControl")

        *XButton2::
            gFXB2 := True
            If (A_PriorKey="XButton2") & (A_TimeSincePriorHotkey < DUBL_CLICK_DELAY) {
                Send, {LWin Down}                
            } Else {
                Send, {LShift Down}
            }
        Return
    
    #If checkMouseTypingDesktop() & !gFXB1to2 & GetKeyState("LControl")

        *XButton2::
            gFXB1to2 := True
            gFXB1 := False
            Send, {LControl Up}{LAlt Down}{Tab} 
        Return