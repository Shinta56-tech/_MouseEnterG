;*****************************************************************************************************************************************
; Standard Setting
;*****************************************************************************************************************************************

    #Persistent
    #SingleInstance, IGNORE
    #NoEnv
    #UseHook
    #InstallKeybdHook
    #InstallMouseHook
    #HotkeyInterval, 2000
    #MaxHotkeysPerInterval, 200

    Process, Priority, , Realtime
    SendMode, Input
    SetWorkingDir %A_ScriptDir%
    SetTitleMatchMode, 2
    SetMouseDelay -1
    SetKeyDelay, -1
    SetBatchLines, -1
    CoordMode, Mouse, Screen

;*****************************************************************************************************************************************
; Const
;*****************************************************************************************************************************************

    Global DIR_AHK := RegExReplace(A_AhkPath, "[^\\]+?$")
    Global INI_PROP := "ini\Property.ini"
    Global LONG_PRESS_DELAY := 0.2
    Global DUBL_CLICK_DELAY := 250
    Global KeyFlag := Object()

;*****************************************************************************************************************************************
; Init
;*****************************************************************************************************************************************

    Gosub, Init

    Gosub, IniEditor

    Gosub, MouseApp
    Gosub, MouseGesture

    Menu, Tray, Add
    Menu, Tray, Add, Setting, :SettingMenu

    Return

    Init:
        IniRead, LONG_PRESS_DELAY, %INI_PROP%, PROP, LONG_PRESS_DELAY
        IniRead, DUBL_CLICK_DELAY, %INI_PROP%, PROP, DUBL_CLICK_DELAY
        Menu, SettingMenu, Add, WorkingDirectory
    Return

;*****************************************************************************************************************************************
; Function
;*****************************************************************************************************************************************

    ; Check Mouse-Typing Desktop
    checkOnDesktop() {
        vIni := "ini\NoDesktop.ini"
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
; Default Hotkey
;*****************************************************************************************************************************************

    !LWin::Run, % DIR_AHK . "\WindowSpy.ahk"

    ^!Escape::ExitApp
    !Escape::Reload

;*****************************************************************************************************************************************
; Default Label
;*****************************************************************************************************************************************

    WorkingDirectory:
        Run, % A_ScriptDir
    Return

;*****************************************************************************************************************************************
; Include
;*****************************************************************************************************************************************

    #Include toolbox\IniEditor.ahk

    #Include include\MouseTyping\MouseTyping_main.ahk
    #Include include\MouseApp\MouseApp_main.ahk
    #Include include\MouseGesture\MouseGesture_main.ahk