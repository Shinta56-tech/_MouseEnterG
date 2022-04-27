;*****************************************************************************************************************************************
; Init
;*****************************************************************************************************************************************

    MouseGestureGui:
        Global MGG_IniEditor_Title := "MouseGesture Setting"
        Global MGG_IniEditor_Vals := IniEditor_getTempVals()
        Global MGG_Tab
        Global MGG_Text1, MGG_Text2, MGG_Text3
        Global MGG_List1, MGG_List2, MGG_List3
        MGG_IniEditor_Vals.GuiDefault := "MGG_GuiDefault"
        MGG_IniEditor_Vals.Inis[1] := "ini\profile\Default.ini"
        MGG_IniEditor_Vals.Inis[2] := "ini\profile\Default.ini"
        MGG_IniEditor_Vals.Inis[3] := "ini\profile\Default.ini"
        MGG_IniEditor_Vals.IniSections[1] := "HotKey"
        MGG_IniEditor_Vals.IniSections[2] := "WTitle"
        MGG_IniEditor_Vals.IniSections[3] := "HotKey"
        MGG_IniEditor_Vals.Tab := "MGG_Tab"
        MGG_IniEditor_Vals.TabName := "Exe|Win Title|Default"
        IniEditor_TempVals.IniTexts[1] := "MGG_Text1"
        IniEditor_TempVals.IniTexts[2] := "MGG_Text2"
        IniEditor_TempVals.IniTexts[3] := "MGG_Text3"
        MGG_IniEditor_Vals.Lists[1] := "MGG_List1"
        MGG_IniEditor_Vals.Lists[2] := "MGG_List2"
        MGG_IniEditor_Vals.Lists[3] := "MGG_List3"
        MGG_IniEditor_Vals.ListCols[1] := "HotKey|Send Text|Caption"
        MGG_IniEditor_Vals.ListCols[2] := "WinTitle|IniFile"
        MGG_IniEditor_Vals.ListCols[3] := "HotKey|Send Text|Caption"
        MGG_IniEditor_Vals.ListColCounts[1] := 3
        MGG_IniEditor_Vals.ListColCounts[2] := 2
        MGG_IniEditor_Vals.ListColCounts[3] := 3
        IniEditor_setVals(MGG_IniEditor_Vals)
        Gui, MGG_MAIN:New
        Gosub, MGG_GuiDefault
        IniEditor_createGui()
    Return

;*****************************************************************************************************************************************
; Function
;*****************************************************************************************************************************************

    showMouseGestureSettingGui() {
        WinGet, vAhkExe, ProcessName, A
        MGG_IniEditor_Vals.Inis[1] := "ini\profile\" vAhkExe ".ini"
        MGG_IniEditor_Vals.Inis[2] := "ini\profile\" vAhkExe ".ini"
        IniEditor_setVals(MGG_IniEditor_Vals)
        Gui, MGG_MAIN:Default
        IniEditor_showGui(MGG_IniEditor_Title)
    }


;*****************************************************************************************************************************************
; Label
;*****************************************************************************************************************************************

    MGG_GuiDefault:
        Gui, MGG_MAIN:Default
    Return

    MGG_MAINGuiClose:
        IniEditor_ShowFlag := False
        Gui, MGG_MAIN:Cancel
    Return

;*****************************************************************************************************************************************
; Hotkey
;*****************************************************************************************************************************************
    
    #If MouseGes.Run & !mgg

        *Tab::
            MouseGes.Run := False
            Gosub, MG_END
            showMouseGestureSettingGui()
        Return