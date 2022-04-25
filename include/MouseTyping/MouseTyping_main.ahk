;*****************************************************************************************************************************************
; Initialize
;*****************************************************************************************************************************************

    MouseTyping:
        Global INI_NODESKTOP := "ini\NoDesktop.ini"
        Global gFRB := False
        Global gFLB := False
        Global gFXB1 := False
        Global gFXB2 := False
        Global gFSPC := False
        Global gFXB1to2 := False
        Global gFXB2to1 := False
    Return

;*****************************************************************************************************************************************
; Function
;*****************************************************************************************************************************************

    ; Check Mouse-Typing Desktop
    checkMouseTypingDesktop() {
        vIni := INI_NODESKTOP
        WinGetClass, vAhkClass, A
        IniRead, vResultClass, %vIni%, AhkClass, %vAhkClass%
        If (vResultClass <> "ERROR") {
            Return False
        }
        WinGet, vAhkExe, ProcessName, A
        IniRead, vResultExe, %vIni%, AhkExe, %vAhkExe%
        If (vResultExe <> "ERROR") {
            Return False
        }
        Return True
    }

;*****************************************************************************************************************************************
; Hotkey
;*****************************************************************************************************************************************

        *CapsLock::BackSpace
        *vkF0::BackSpace
        *RAlt::vk1D

;*****************************************************************************************************************************************
; Button Setting
;*****************************************************************************************************************************************

    #Include include\MouseTyping\MouseTyping-KeyShift1.ahk
    #Include include\MouseTyping\MouseTyping-KeyShift2.ahk
    #Include include\MouseTyping\MouseTyping-KeyShift3.ahk
    #Include include\MouseTyping\MouseTyping-KeyShiftNum.ahk
    #Include include\MouseTyping\MouseTyping-MButton.ahk
    #Include include\MouseTyping\MouseTyping-RButton.ahk
    #Include include\MouseTyping\MouseTyping-LButton.ahk
    #Include include\MouseTyping\MouseTyping-XButton1.ahk
    #Include include\MouseTyping\MouseTyping-XButton2.ahk
    #Include include\MouseTyping\MouseTyping-Space.ahk