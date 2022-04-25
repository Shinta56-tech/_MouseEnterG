;*****************************************************************************************************************************************
; Hotkey
;*****************************************************************************************************************************************    
    
    #If gFXB2to1 & !GetKeyState("MButton")

        *LButton::XButton1
        *RButton::XButton2
        *MButton::Send, !{F4}
        *WheelUp::PgUp
        *WheelDown::PgDn
        *Tab::WinSet, AlwaysOnTop, On, A
        *CapsLock::WinSet, AlwaysOnTop, Off, A
        *vkF0::WinSet, AlwaysOnTop, Off, A
    
    #If gFXB1to2 & !GetKeyState("MButton")

        *RButton::Send, {Tab}
        *LButton::Send, +{Tab}

    #If GetKeyState("RButton", "P")

        *MButton::WinMinimize, A