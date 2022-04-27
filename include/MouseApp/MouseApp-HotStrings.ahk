;*****************************************************************************************************************************************
; Init
;*****************************************************************************************************************************************

    HotStrings:
        Global HS_IniEditor_Title := "HotString Library"
        Global HS_IniEditor_Vals := IniEditor_getTempVals()
        Global HS_Tab
        Global HS_Text
        Global HS_List
        HS_IniEditor_Vals.GuiDefault := "HS_GuiDefault"
        HS_IniEditor_Vals.Inis[1] := "ini\HotStrings.ini"
        HS_IniEditor_Vals.IniSections[1] := "HS"
        HS_IniEditor_Vals.Tab := "HS_Tab"
        HS_IniEditor_Vals.TabName := "HotKey|Send Text"
        IniEditor_TempVals.IniTexts[1] := "HS_Text"
        HS_IniEditor_Vals.Lists[1] := "HS_List"
        HS_IniEditor_Vals.ListCols[1] := "HotKey|Send Text"
        HS_IniEditor_Vals.ListColCounts[1] := 2
        IniEditor_setVals(HS_IniEditor_Vals)
        Gui, HG_MAIN:New
        Gosub, HS_GuiDefault
        IniEditor_createGui()
    Return

;*****************************************************************************************************************************************
; Function
;*****************************************************************************************************************************************

    showHotStringGui() {
        IniEditor_setVals(HS_IniEditor_Vals)
        Gui, HG_MAIN:Default
        IniEditor_showGui(HS_IniEditor_Title)
    }


;*****************************************************************************************************************************************
; Label
;*****************************************************************************************************************************************

    HS_GuiDefault:
        Gui, HG_MAIN:Default
    Return

    HG_MAINGuiClose:
        IniEditor_ShowFlag := False
        Gui, HG_MAIN:Cancel
    Return

;*****************************************************************************************************************************************
; Hotkey
;*****************************************************************************************************************************************

    #If WinActive(HS_IniEditor_Title)

        *Tab::IniEditor_sendClose(2)