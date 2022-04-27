 
;*****************************************************************************************************************************************
; Function
;*****************************************************************************************************************************************

    IniEditor:
        Global IniEditorVals
        Global IniEditor_EditTitle := "Row Editor"
        Global IniEditor_SplitText := "\|\|"
        Global IniEditor_SplitText2 := "||"
        Global IniEditor_RowEdit1, IniEditor_RowEdit2, IniEditor_RowEdit3, IniEditor_RowEdit4, IniEditor_RowEdit5
        Global IniEditor_ShowFlag := False
        ; Create Edit Row Gui
        Gui, IniEditorEdit:New
        Loop 5
        {
            Gui, IniEditorEdit:Add, Edit, vIniEditor_RowEdit%A_Index% gIniEditor_RowEdit%A_Index% w250
        }
        GuiControl, Disable, IniEditor_RowEdit1
        ; Create Mene
        Menu, IniEditorMenu, Add, Edit, IniEditor_EditRow
        Menu, IniEditorMenu, Add
        Menu, IniEditorMenu, Add, Insert, _IniEditor_insertRow
        Menu, IniEditorMenu, Add, Copy, IniEditor_CopyRow
        Menu, IniEditorMenu, Add, Delete, IniEditor_DeleteRow
        ; Create Template
        Gui, IniEditorTemp:New
    Return

;*****************************************************************************************************************************************
; Function
;*****************************************************************************************************************************************

    IniEditor_setVals(pVals) {
        ; pVals := Object()
        ; pVals.GuiDefault := Function
        ; pVals.Inis := Object() Text Array
        ; pVals.IniSections := Object() Text Array
        ; pVals.Tab := Global Value Name
        ; pVals.TabName := Text
        ; pVals.Lists := Global Value Name Array
        ; pVals.ListCols := Object() Text Array
        ; pVals.ListColCounts := Object() Num Array
        IniEditorVals := pVals
        IniEditorVals.ListVals := Object()
    }

    IniEditor_getTempVals() {
        Global IniEditor_TempVals := Object()
        Global IniEditor_TabTemp
        Global IniEditor_TextTemp
        Global IniEditor_ListTemp
        IniEditor_TempVals.GuiDefault := "IniEditor_GuiDefault"
        IniEditor_TempVals.Inis := Object()
        IniEditor_TempVals.Inis[1] := "ini\Property.ini"
        IniEditor_TempVals.IniSections := Object()
        IniEditor_TempVals.IniSections[1] := "PROP"
        IniEditor_TempVals.Tab := "IniEditor_TabTemp"
        IniEditor_TempVals.TabName := "Tab1|Tab2"
        IniEditor_TempVals.IniTexts := Object()
        IniEditor_TempVals.IniTexts[1] := "IniEditor_TextTemp"
        IniEditor_TempVals.Lists := Object()
        IniEditor_TempVals.Lists[1] := "IniEditor_ListTemp"
        IniEditor_TempVals.ListCols := Object()
        IniEditor_TempVals.ListCols[1] := "Col1|Col2"
        IniEditor_TempVals.Object()
        IniEditor_TempVals.ListColCounts[1] := 2

        Return IniEditor_TempVals
    }

    IniEditor_createGui() {
        ; Gui, (User Input):New
        If (IniEditorVals.Inis.MaxIndex() > 1) {
            _IniEditor_editGui_addTab()
            Loop % IniEditorVals.Inis.MaxIndex()
            {
                IniEditorVals.SelectTab := A_Index
                Gui, Tab, %A_Index%
                _IniEditor_editGui_addIniLink()
                _IniEditor_editGui_addSearchEdit()
                _IniEditor_editGui_addList()
            }
            IniEditorVals.SelectTab := 1
        } Else {
            IniEditorVals.SelectTab := 1
            _IniEditor_editGui_addIniLink()
            _IniEditor_editGui_addSearchEdit()
            _IniEditor_editGui_addList()
        }
    }

    _IniEditor_editGui_addTab() {
        vTab := IniEditorVals.Tab
        vTabName := IniEditorVals.TabName
        Gui, Add, Tab2, xm+0 w570 h380 v%vTab% gIniEditor_Tab AltSubmit, %vTabName%
        vTabs := StrSplit(vTabName, "|")
    }

    _IniEditor_editGui_addIniLink() {
        vText := IniEditorVals.IniTexts[IniEditorVals.SelectTab]
        vIni := IniEditorVals.Inis[IniEditorVals.SelectTab]
        Gui, Add, Text, w300 cBlue v%vText% gIniEditor_IniLink, %vIni%
    }

    _IniEditor_editGui_addSearchEdit() {
        Gui, Add, Text, Section, Filter
        Gui, Add, Edit, x+5 yp+0 gIniEditor_SEdit w250
        Gui, Add, Text, xs+0 Hidden, Test
    }

    _IniEditor_editGui_addList() {
        vList := IniEditorVals.Lists[IniEditorVals.SelectTab]
        vListCol := IniEditorVals.ListCols[IniEditorVals.SelectTab]
        Gui, Add, ListView, yp+0 r15 w550 v%vList% gIniEditor_List Sort Redraw AltSubmit, %vListCol%
        _IniEditor_filterList("")
    }

    _IniEditor_filterList(pText) {
        vIni := IniEditorVals.Inis[IniEditorVals.SelectTab]
        vIniSection := IniEditorVals.IniSections[IniEditorVals.SelectTab]
        vList := IniEditorVals.Lists[IniEditorVals.SelectTab]
        Gui, ListView, %vList%
        IniRead, vIniList, %vIni%, %vIniSection%
        LV_Delete()
        If (pText="") {
            key := ".*?"
        } Else {
            keyAry := StrSplit(pText)
            key := ".*?"
            Loop % keyAry.MaxIndex()
            {
                key .= keyAry[A_Index] . ".*?"
            }
        }
        Loop, Parse, vIniList, `n
        {
            If (RegExMatch(A_LoopField, "^(" key ")=.*?$"))
                || (RegExMatch(A_LoopField, "^.*?=(" key ")$")) {
                    vSplit :="@@@"
                    vText := RegExReplace(A_LoopField, "=", vSplit)
                    vText := RegExReplace(vText, IniEditor_SplitText, vSplit)
                    vElem := StrSplit(vText, vSplit)
                    LV_Add(, vElem*)
            }
        }
        LV_ModifyCol(1, "Sort")
        LV_ModifyCol()
        LV_Modify(1, "+Select")
        Loop % IniEditorVals.ListColCounts[IniEditorVals.SelectTab]
        {
            LV_GetText(vText, LV_GetNext(), A_Index)
            IniEditorVals.ListVals[A_Index] := vText
        }
    }

    IniEditor_showGui(pTitle = "Ini Editor") {
        If (!IniEditor_ShowFlag) {
            MouseGetPos, vMX, vMY
            SysGet, MonCount, MonitorCount
            Loop, %MonCount% {
                SysGet, Mon, Monitor, %A_Index%
                If ( (MonLeft <= vMX) & (MonRight >= vMX) & (MonBottom >= vMY) & (MonTop <= vMY) ) {
                    Break
                }
            }
            vX := (MonLeft+MonRight)/2 - 250
            vY := (MonTop+MonBottom)/2 - 200
            vIni := IniEditorVals.Inis[IniEditorVals.SelectTab]
            Loop % IniEditorVals.Inis.MaxIndex() {
                IniEditorVals.SelectTab := A_Index
                vText := IniEditorVals.IniTexts[A_Index]
                vIniLink := IniEditorVals.Inis[A_Index]
                GuiControl, , %vText%, %vIniLink%
                _IniEditor_filterList("")
            }
            If (IniEditorVals.Inis.MaxIndex() > 1) {
                ControlID := IniEditorVals.Tab
                GuiControlGet, vNum, , %ControlID%
                IniEditorVals.SelectTab := vNum
            } Else {
                IniEditorVals.SelectTab := 1
            }
            IniEditorVals.Title := pTitle
            Gui, Show, x%vX% y%vY%, %pTitle%
            IniEditor_ShowFlag := True
        } Else {
            vMsg := "Another inieditor is already running !"
            MsgBox, 16, Caution, %vMsg%
        }
    }

    _IniEditor_UpdateRow(pNum, pText) {
        vIni := IniEditorVals.Inis[IniEditorVals.SelectTab]
        vIniSection := IniEditorVals.IniSections[IniEditorVals.SelectTab]
        vList := IniEditorVals.Lists[IniEditorVals.SelectTab]
        Gosub, % IniEditorVals.GuiDefault
        Gui, ListView, %vList%
        vCells := Object()
        Loop % IniEditorVals.ListColCounts[IniEditorVals.SelectTab]
        {
            LV_GetText(vVal, LV_GetNext(), A_Index)
            vCells[A_Index] := vVal
        }
        vCells[pNum] := pText
        Loop % vCells.MaxIndex()
        {
            If (A_Index=1) {
                Continue
            }
            vValue .= IniEditor_SplitText2 . vCells[A_Index]
        }
        vValue := RegExReplace(vValue, "^" . IniEditor_SplitText)
        vKey := vCells[1]
        IniDelete, %vIni%, %vIniSection%, %vKey%
        IniWrite, %vValue%, %vIni%, %vIniSection%, %vKey%
        LV_Modify(LV_GetNext(), , vCells*)
        LV_ModifyCol()
    }

    _IniEditor_insertRow(pList, pIni, pIniSection, pValObj) {
        vKey := pValObj[1]
        If (vKey="") {
            vMsg := "The key you entered is null.`n Please enter a unique key !"
            MsgBox, 0x30, Caution, %vMsg%
            Return
        }
        IniRead, vResult, %pIni%, %pIniSection%, %vKey%
        If (vResult="ERROR") {
            Gosub, % IniEditorVals.GuiDefault
            Gui, ListView, %pList%
            Loop % pValObj.MaxIndex()
            {
                If (A_Index<>1) {
                    vValue .= IniEditor_SplitText2 . pValObj[A_Index]
                }
            }
            vValue := RegExReplace(vValue, "^" . IniEditor_SplitText)
            LV_Modify(LV_GetNext(), "-Select")
            IniWrite, %vValue%, %pIni%, %pIniSection%, %vKey%
            LV_Insert(1, , pValObj*)
            LV_ModifyCol(1, "Sort")
            LV_ModifyCol()
            LV_Modify(1, "+Select")
        } Else {
            vMsg := "The key you entered is already registered.`n Please enter a unique key !"
            MsgBox, 0x30, Caution, %vMsg%
        }
    }

    _IniEditor_setEditRow() {
        vList := IniEditorVals.Lists[IniEditorVals.SelectTab]
        Gosub, % IniEditorVals.GuiDefault
        Gui, ListView, %vList%
        Loop 5
        {
            LV_GetText(vText, LV_GetNext(), A_Index)
            If (vText <> "") {
                IniEditorVals.ListVals[A_Index] := vText
                GuiControl, IniEditorEdit:-g, IniEditor_RowEdit%A_Index%
                GuiControl, IniEditorEdit:Text, IniEditor_RowEdit%A_Index%, %vText%
                GuiControl, IniEditorEdit:+gIniEditor_RowEdit%A_Index%, IniEditor_RowEdit%A_Index%
            } Else {
                GuiControl, IniEditorEdit:-g, IniEditor_RowEdit%A_Index%
                GuiControl, IniEditorEdit:Text, IniEditor_RowEdit%A_Index%
                GuiControl, IniEditorEdit:+gIniEditor_RowEdit%A_Index%, IniEditor_RowEdit%A_Index%
            }
            
        }
    }

    IniEditor_showEditGui() {
        vTitle := IniEditorVals.Title
        WinGetPos, vWX, vWY, vWW, vWH, %vTitle%
        vX := (vWX+vWW) - 100
        vY := vWY + 50
        Gui, IniEditorEdit:Show, x%vX% y%vY%, %IniEditor_EditTitle%
        WinSet, AlwaysOnTop, On, %IniEditor_EditTitle%
    }

    IniEditor_sendClose(pConNum) {
        Gosub, % IniEditorVals.GuiDefault
        IniEditor_ShowFlag := False
        Gui, Cancel
        Send, % IniEditorVals.ListVals[pConNum]
    }

;*****************************************************************************************************************************************
; Label
;*****************************************************************************************************************************************

    IniEditor_Tab:
        GuiControlGet, vTab, , %A_GuiControl%
        IniEditorVals.SelectTab := vTab
        _IniEditor_setEditRow()
    Return

    IniEditor_IniLink:
        Try {
            Run, % A_ScriptDir . "\" . IniEditorVals.Inis[IniEditorVals.SelectTab]
        } Catch, e
        {
            vMsg := "IniFile does not exist"
            MsgBox, 0x30, Caution, %vMsg%
        }
        
    Return

    IniEditor_SEdit:
        _IniEditor_filterList(A_GuiControl)
    Return

    IniEditor_List:
        If (A_GuiEvent="DoubleClick") {
            IniEditor_showEditGui()
        } Else If (A_GuiEvent="Normal") {
            _IniEditor_setEditRow()
        } Else If (A_GuiEvent="RightClick") {
            MouseGetPos, vMX, vMY
            Menu, IniEditorMenu, Show
        }
    Return

    IniEditor_RowEdit1:
        Gui, IniEditorEdit:Submit, NoHide
        _IniEditor_UpdateRow(1, IniEditor_RowEdit1)
    Return

    IniEditor_RowEdit2:
        Gui, IniEditorEdit:Submit, NoHide
        _IniEditor_UpdateRow(2, IniEditor_RowEdit2)
    Return

    IniEditor_RowEdit3:
        Gui, IniEditorEdit:Submit, NoHide
        _IniEditor_UpdateRow(3, IniEditor_RowEdit3)
    Return

    IniEditor_RowEdit4:
        Gui, IniEditorEdit:Submit, NoHide
        _IniEditor_UpdateRow(4, IniEditor_RowEdit4)
    Return

    IniEditor_RowEdit5:
        Gui, IniEditorEdit:Submit, NoHide
        _IniEditor_UpdateRow(5, IniEditor_RowEdit5)
    Return

    _IniEditor_insertRow:
        vList := IniEditorVals.Lists[IniEditorVals.SelectTab]
        vIni := IniEditorVals.Inis[IniEditorVals.SelectTab]
        vIniSection := IniEditorVals.IniSections[IniEditorVals.SelectTab]
        InputBox, vKey, , Please input key !, , 300, 130
        If (ErrorLevel < 1) {
            vObj := Object()
            Loop % IniEditorVals.ListColCounts[IniEditorVals.SelectTab]
            {
                vObj[A_Index] := "Val"
            }
            vObj[1] := vKey
            _IniEditor_insertRow(vList, vIni, vIniSection, vObj)
        }
    Return

    IniEditor_CopyRow:
        vList := IniEditorVals.Lists[IniEditorVals.SelectTab]
        vIni := IniEditorVals.Inis[IniEditorVals.SelectTab]
        vIniSection := IniEditorVals.IniSections[IniEditorVals.SelectTab]
        Gosub, % IniEditorVals.GuiDefault
        Gui, ListView, %vList%
        LV_GetText(vKey, LV_GetNext(), 1)
        InputBox, vKey, , Please input key !, , 300, 130, , , , , %vKey%
        If (ErrorLevel < 1) {
            vObj := Object()
            Loop % IniEditorVals.ListColCounts[IniEditorVals.SelectTab]
            {
                LV_GetText(vVal, LV_GetNext(), A_Index)
                vObj[A_Index] := vVal
            }
            vObj[1] := vKey
            _IniEditor_insertRow(vList, vIni, vIniSection, vObj)
        }
    Return

    IniEditor_DeleteRow:
        vList := IniEditorVals.Lists[IniEditorVals.SelectTab]
        vIni := IniEditorVals.Inis[IniEditorVals.SelectTab]
        vIniSection := IniEditorVals.IniSections[IniEditorVals.SelectTab]
        Gosub, % IniEditorVals.GuiDefault
        Gui, ListView, %vList%
        LV_GetText(vKey, LV_GetNext(), 1)
        MsgBox, 33, , Are you sure you want to delete the next line?`nKey: %vKey%
        IfMsgBox, Ok
        {
            IniDelete, %vIni%, %vIniSection%, %vKey%
            vRow := LV_GetNext()
            LV_Delete(LV_GetNext())
            If (vRow <= LV_GetCount()) {
                LV_Modify(vRow, "+Select")
            } Else {
                LV_Modify((vRow-1), "+Select")
            }
        }
    Return

    IniEditor_EditRow:
        _IniEditor_setEditRow()
        IniEditor_showEditGui()
    Return

    IniEditor_GuiDefault:
        Gui, IniEditorTemp:Default
    Return

    IniEditorTempGuiClose:
        IniEditor_ShowFlag := False
        Gui, IniEditorTemp:Cancel
    Return


;*****************************************************************************************************************************************
; HotKey
;*****************************************************************************************************************************************

    #If WinActive("Ini Editor")

        *Tab::IniEditor_sendClose(2)
    
    #If