;*****************************************************************************************************************************************
; Init
;*****************************************************************************************************************************************

    MouseApp:
        Gosub, HotStrings
    Return

;*****************************************************************************************************************************************
; Function
;*****************************************************************************************************************************************

    setApp(pB) {
        WinGet, PID, PID, A
        FullEXEPath := getModuleFileNameEx( PID )
        IniWrite, %FullEXEPath%, ini/MouseApp.ini, APP, %pB%
        MsgBox, % "Set App !`n" . pB . "=" . FullEXEPath
    }

    runApp(pB) {
        IniRead, AppPath, ini/MouseApp.ini, APP, %pB%
        If (AppPath <> "ERROR" ) {
            Run, open %AppPath%
        } Else {
            MsgBox, No App
        }
    }

    getModuleFileNameEx(p_pid) {
        h_process := DllCall( "OpenProcess", "uint", 0x10|0x400, "int", false, "uint", p_pid )
        if ( ErrorLevel or h_process = 0 )
            return
        name_size = 255
        VarSetCapacity( name, name_size )
        result := DllCall( "psapi.dll\GetModuleFileNameEx", "uint", h_process, "uint", 0, "Str"
        , name, "uint", name_size )
        DllCall( "CloseHandle", h_process )
        return name
    }

    executeMouseApp() {
        vTime := LONG_PRESS_DELAY * 5
        KeyWait, %A_ThisLabel%, T%vTime%
        If (!ErrorLevel) & (A_PriorKey = A_ThisLabel) {
            runApp(A_ThisLabel)
        } Else {
            setApp(A_ThisLabel)
            KeyWait, %A_ThisLabel%
        }
    }

;*****************************************************************************************************************************************
; Hotkey
;*****************************************************************************************************************************************

        #If checkOnDesktop() & KeyFlag.XB21 & !MA

            q::executeMouseApp()
            w::executeMouseApp()
            e::executeMouseApp()
            r::executeMouseApp()
            t::executeMouseApp()
            a::executeMouseApp()
            s::executeMouseApp()
            d::executeMouseApp()
            f::executeMouseApp()
            g::executeMouseApp()
            z::executeMouseApp()
            x::executeMouseApp()
            c::executeMouseApp()
            v::executeMouseApp()
            b::executeMouseApp()

            1::showGuiHS()
            2::Return
            3::Return
            4::Return
            5::Return

        #If !checkOnDesktop() & GetKeyState("XButton1", "P") & GetKeyState("XButton2", "P") & GetKeyState("LShift", "P")

            1::Return
            2::Return
            3::Return
            4::Return
            5::Return

;*****************************************************************************************************************************************
; Include
;*****************************************************************************************************************************************

    #Include, include\MouseApp\MouseApp-HotStrings.ahk