;*****************************************************************************************************************************************
; Init
;*****************************************************************************************************************************************

    HotStrings:
        Global INI_HS := "ini\HotStrings.ini"
        Global gHSFilter, gHSList, gHSNum, gKHSey, gHSVal
        Global gFlagHSNumRe:=False, gFlagHSValRe:=False
        ; Create Gui
        Gui, HS:New
        Gui, HS:Add, Text, Section, Filter
        Gui, HS:Add, Edit, gHSFilter vgHSFilter w500 x+0 ys+0
        Gui, HS:Add, ListView, r14 w600 xm+0 Sort AltSubmit gHSList vgHSList, Num|Key|Value
        Gui, HS:Add, Text, xm+0 Section, Num
        Gui, HS:Add, Edit, gHSNum vgHSNum w40 x+0 ys+0
        Gui, HS:Add, Text, x+15 Section, Val
        Gui, HS:Add, Edit, gHSVal vgHSVal w440 x+0 ys+0
        ; Create Mene
        Menu, menuHS, Add, Insert, HSInsert
        Menu, menuHS, Add, Delete, HSDelete
        ; Input List
        Gosub, HSFilter
    Return

;*****************************************************************************************************************************************
; Function
;*****************************************************************************************************************************************

    showGuiHS() {
        Gui, HS:Show, , MouseApp HotStrings
        Gui, HS:Default
        Gui, HS:ListView, gHSList
        LV_ModifyCol()
        LV_Modify(1, "+Select")
    }

;*****************************************************************************************************************************************
; Label
;*****************************************************************************************************************************************

        HSList:
            If (A_GuiEvent="I") & (InStr(ErrorLevel,"S",true)) {
                LV_GetText(vNum, LV_GetNext(), 1)
                LV_GetText(vKey, LV_GetNext(), 2)
                LV_GetText(vVal, LV_GetNext(), 3)
                gFlagHSNumRe := True
                gFlagHSValRe := True
                GuiControl, HS:Text, gHSNum, %vNum%
                Sleep, 50
                GuiControl, HS:Text, gHSKey, %vKey%
                GuiControl, HS:Text, gHSVal, %vVal%
                Sleep, 50
                gFlagHSNumRe := False
                gFlagHSValRe := False
            }
        Return

        HSFilter:
            Gui, HS:Submit, NoHide
            Gui, HS:Default
            Gui, HS:ListView, gHSList
            LV_Delete()
            If (gHSFilter="") {
                key := ".*?"
            } Else {
                keyAry := StrSplit(gHSFilter)
                key := ".*?"
                Loop % keyAry.MaxIndex()
                {
                    key .= keyAry[A_Index] . ".*?"
                }
            }
            IniRead, vList, %INI_HS%, HS
            Loop, Parse, vList, `n
            {
                If (RegExMatch(A_LoopField, "^(" key ")=(.*?);(.*?)$", elem)) {
                    LV_Add(, elem2, elem1, elem3)
                } Else If (RegExMatch(A_LoopField, "^(.*?)=(.*?);(" key ")$", elem)) {
                    LV_Add(, elem2, elem1, elem3)
                } 
            }
            LV_ModifyCol()
            LV_Modify(1, "+Select")
        Return

        HSNum:
            If (!gFlagHSNumRe) {
                Gui, HS:Submit, NoHide
                LV_GetText(vKey, LV_GetNext(), 2)
                LV_GetText(vVal, LV_GetNext(), 3)
                LV_Modify(LV_GetNext(), , gHSNum, vKey, vVal)
                IniDelete, %INI_HS%, HN, %vKey%
                vValue := gHSNum . ";" . vVal
                IniWrite, %vValue%, %INI_HS%, HS, %vKey%
                LV_ModifyCol()
            }
        Return

        HSVal:
            If (!gFlagHSValRe) {
                Gui, HS:Submit, NoHide
                LV_GetText(vKey, LV_GetNext(), 2)
                LV_GetText(vNum, LV_GetNext(), 1)
                LV_Modify(LV_GetNext(), , vNum, vKey, gHSVal)
                IniDelete, %INI_HS%, HS, %vKey%
                vValue := vNum . ";" . gHSVal
                IniWrite, %vValue%, %INI_HS%, HS, %vKey%
                LV_ModifyCol()
            }
        Return

        HSSend:
            Gui, HS:Default
            Gui, HS:ListView, gHSList
            Gui, HS:Cancel
            SelectedRow := LV_GetNext()
            If (SelectedRow != 0) {
                LV_GetText(vVal, SelectedRow, 3)
                Send, % vVal
            }
        Return

        HSGuiContextMenu:
            Menu, menuHS, Show, %A_GuiX%, %A_GuiY%
        Return

        HSInsert:
            InputBox, vKey, , Please input key !, , 300, 130
            If (ErrorLevel < 1) {
                IniRead, vResult, %INI_HS%, HS, %vKey%
                If (vResult="ERROR") {
                    Gui, HS:Default
                    Gui, HS:ListView, gHSList
                    LV_Modify(LV_GetNext(), "-Select")
                    IniWrite, 0;Value, %INI_HS%, HS, %vKey%
                    LV_Insert(1, , 0, vKey, "Value")
                    LV_ModifyCol()
                    LV_Modify(1, "+Select")
                } Else {
                    vMsg := "The key you entered is already registered.`n Please enter a unique key !"
                    MsgBox, 0x30, Caution, %vMsg%
                }
                
            }
        Return

        HSDelete:
            Gui, HS:Default
            Gui, HS:ListView, gHSList
            LV_GetText(vKey, LV_GetNext(), 2)
            IniDelete, %INI_HS%, HS, %vKey%
            vRow := LV_GetNext()
            LV_Delete(LV_GetNext())
            If (vRow <= LV_GetCount()) {
                LV_Modify(vRow, "+Select")
            } Else {
                LV_Modify((vRow-1), "+Select")
            }
        Return

        HSUpdate:
            MsgBox update
        Return

;*****************************************************************************************************************************************
; Hotkey
;*****************************************************************************************************************************************

    #IfWinActive, MouseApp HotStrings

        *Tab::Gosub, HSSend

;*****************************************************************************************************************************************
; Include
;*****************************************************************************************************************************************