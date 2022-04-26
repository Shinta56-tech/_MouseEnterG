;*****************************************************************************************************************************************
; Init
;*****************************************************************************************************************************************

    MouseGesture:
        Global INI_MouseGesture := "ini\MouseGesture.ini"
        Global DIR_PROFILE := "ini\profile\"
        Global MouseGes := Object()
        IniRead, HOTKEY_START, %INI_MouseGesture%, SETTING, HOTKEY_START
        IniRead, HOTKEY_END, %INI_MouseGesture%, SETTING, HOTKEY_END
        Hotkey, If
        Hotkey, %HOTKEY_END%, MG_END
        Hotkey, %HOTKEY_START%, MG_START
        Global MGLENX := 0
        Global MGLENY := 0
        Global MGLENV := 0
        IniRead, MGLENX, %INI_MouseGesture%, FEELING, MGLENX, 150
        IniRead, MGLENY, %INI_MouseGesture%, FEELING, MGLENY, 100
        IniRead, MGLENV, %INI_MouseGesture%, FEELING, MGLENV, 3.3
        MouseGes.MoveR := "'R"
        MouseGes.MoveL := "'L"
        MouseGes.MoveD := "'D"
        MouseGes.MoveU := "'U"
    Return

;*****************************************************************************************************************************************
; Function
;*****************************************************************************************************************************************

    checkTargetPos(pXPos, pYPos) {
        ; Right move check
        if !(RegExMatch(MouseGes.Text, "^.*(" . MouseGes.MoveR . "){2}$"))
            & (pXPos>MouseGes.TRPos) {
                MouseGes.Text .= MouseGes.MoveR
                MouseGes.TRPos := pXPos + (MGLENX * MGLENV)
                MouseGes.TLPos := pXPos - MGLENX
                MouseGes.TDPos := pYPos + MGLENY
                MouseGes.TUPos := pYPos - MGLENY
        ; Left move check
        } else if !(RegExMatch(MouseGes.Text, "^.*(" . MouseGes.MoveL . "){2}$"))
            & (pXPos<MouseGes.TLPos) {
                MouseGes.Text .= MouseGes.MoveL
                MouseGes.TRPos := pXPos + MGLENX
                MouseGes.TLPos := pXPos - (MGLENX * MGLENV)
                MouseGes.TDPos := pYPos + MGLENY
                MouseGes.TUPos := pYPos - MGLENY
        ; Down move check
        } else if !(RegExMatch(MouseGes.Text, "^.*(" . MouseGes.MoveD . "){2}$"))
            & (pYPos>MouseGes.TDPos) {
                MouseGes.Text .= MouseGes.MoveD
                MouseGes.TRPos := pXPos + MGLENX
                MouseGes.TLPos := pXPos - MGLENX
                MouseGes.TDPos := pYPos + (MGLENY * MGLENV)
                MouseGes.TUPos := pYPos - MGLENY
        ; Up move check
        } else if !(RegExMatch(MouseGes.Text, "^.*(" . MouseGes.MoveU . "){2}$"))
            & (pYPos<MouseGes.TUPos) {
                MouseGes.Text .= MouseGes.MoveU
                MouseGes.TRPos := pXPos + MGLENX
                MouseGes.TLPos := pXPos - MGLENX
                MouseGes.TDPos := pYPos + MGLENY
                MouseGes.TUPos := pYPos - (MGLENY * MGLENV)
        } Else {
            Return False
        }
        Return True
    }

    getGesNameSend() {
        ; Text Check
        If (MouseGes.Text="") {
            vGesText := "P"
        } Else {
            vGesText := MouseGes.Text
        }
        ; WinTitle Profile Check
        If (MouseGes.WTitle<>"") {
            vIni := DIR_PROFILE . MouseGes.Exe . ".ini"
            vKey := MouseGes.WTitle
            IniRead, vPlofile, %vIni%, WTitle, %vKey%
            If (vPlofile="ERROR") {
                vPlofile := MouseGes.Exe . ".ini"
            }
        } Else {
            vPlofile := MouseGes.Exe . ".ini"
        }
        ; Get SendText
        vIni := DIR_PROFILE . vPlofile
        vKey := vGesText
        IniRead, vValue, %vIni%, HotKey, %vKey%
        If (vValue<>"ERROR") {
            RegExMatch(vValue, "^(.*?)::(.*?)$", elem)
            MouseGes.Send := elem1
            MouseGes.Name := elem2
            Return
        }
        MouseGes.Send := ""
        MouseGes.Name := ""
    }

    getGesNameSendDefault() {
        ; Text Check
        If (MouseGes.Text="") {
            vGesText := "P"
        } Else {
            vGesText := MouseGes.Text
        }
        ; Get SendText
        vIni := DIR_PROFILE . "Default.ini"
        vKey := vGesText
        IniRead, vValue, %vIni%, HotKey, %vKey%
        If (vValue<>"ERROR") {
            RegExMatch(vValue, "^(.*?)::(.*?)$", elem)
            MouseGes.Send := elem1
            MouseGes.Name := elem2
            Return
        }
        MouseGes.Send := ""
        MouseGes.Name := ""
    }

    addGesStr(pStr) {
        MouseGes.Text .= pStr
        If (MouseGes.Default) {
            getGesNameSendDefault()TEST
        } Else {
            getGesNameSend()
        }
        Gosub, MG_TOOLTIP
    }

;*****************************************************************************************************************************************
; Label
;*****************************************************************************************************************************************

    MG_START:
        If (GetKeyState("LShift")) || (GetKeyState("LControl")) {
            MouseGes.Default := True
        } Else {
            MouseGes.Default := False
        }
        Gosub, MG_RUN
        If (MouseGes.Default) {
            getGesNameSendDefault()
        } Else {
            getGesNameSend()
        }
        Gosub, MG_TOOLTIP
        vButton := RegExReplace(HOTKEY_START, "\W")
        KeyWait, %vButton%
    Return

    MG_RUN:
        MouseGes.Run := True
        WinGet, vAhkExe, ProcessName, A
        WinGetTitle, vWinTitle, A
        MouseGetPos, vXPos, vYPos
        MouseGes.Exe := vAhkExe
        MouseGes.WTitle := vWinTitle
        MouseGes.Text := ""
        MouseGetPos, vXPos, vYPos
        MouseGes.TRPos := vXPos + MGLENX
        MouseGes.TLPos := vXPos - MGLENX
        MouseGes.TDPos := vYPos + MGLENY
        MouseGes.TUPos := vYPos - MGLENY
        SetTimer, MG_MAIN, 0
    Return

    MG_END:
        SetTimer, MG_MAIN, Off
        ToolTip
        If (MouseGes.Run) & (MouseGes.Send<>"") {
            Send, % MouseGes.Send
        }
        MouseGes.Run := False
        MouseGes.Send := ""
        MouseGes.Name := ""
    Return

    MG_MAIN:
        MouseGetPos, vXPos, vYPos
        If (checkTargetPos(vXPos, vYPos)) {
            If (MouseGes.Default) {
                getGesNameSendDefault()TEST
            } Else {
                getGesNameSend()
            }
            Gosub, MG_TOOLTIP
        }
    Return

    MG_TOOLTIP:
        ToolTip, % MouseGes.Text . "`n" . MouseGes.Name
    Return

;*****************************************************************************************************************************************
; HotKey
;*****************************************************************************************************************************************

    #If MouseGes.Run

        q::addGesStr("Q")
        w::addGesStr("W")
        e::addGesStr("E")
        r::addGesStr("R")
        t::addGesStr("T")
        a::addGesStr("A")
        s::addGesStr("S")
        d::addGesStr("D")
        f::addGesStr("F")
        g::addGesStr("G")
        z::addGesStr("Z")
        x::addGesStr("X")
        c::addGesStr("C")
        v::addGesStr("V")
        b::addGesStr("B")
        RButton::addGesStr("Rb")
        LButton::addGesStr("Lb")
        MButton::addGesStr("Mb")
        XButton1::addGesStr("Xb1")
        XButton2::addGesStr("Xb2")
        Space::addGesStr("Spc")
        CapsLock::addGesStr("Cap")
        vkF0::addGesStr("Cap")

;*****************************************************************************************************************************************
; Include
;*****************************************************************************************************************************************
