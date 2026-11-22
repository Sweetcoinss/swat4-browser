class GUIMultiColumnListBox extends GUIListBoxBase
	native
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

cpptext
{
	void PreDraw(UCanvas* Canvas);
	void UpdateComponent(UCanvas* Canvas);
	int MouseOverColumnBorder();
	UGUIComponent* UnderCursor(FLOAT MouseX, FLOAT MouseY);
	UBOOL MousePressed(UBOOL IsRepeat);
	UBOOL MouseReleased();

}

var(MultiColumnListBox) editconst editinline array<export editinline GUIMultiColumnList> MultiColumnList "The Array of lists of data";
var(MultiColumnListBox) config localized array<localized string> ListNames "Name of the lists to polulate this MCLB";
var(MultiColumnListBox) config int ActiveIndex "Index of the active column";
var(MultiColumnListBox) editconst int ActiveRowIndex "Index of the active row";
var(MultiColumnListBox) private editconst export editinline GUIButton ActiveButton;
var(MultiColumnListBox) editconst editinline array<editinline GUIListElem> ActiveRow;
var(MultiColumnListBox) config bool bResizable "If true, MultiColumnList box columns are resizable.";
var(MultiColumnListBox) config float DragSpacing "Number of pixels of leeway allowed for column resizing";
var(DEBUG) editconst int ColumnBorder;

function OnConstruct(GUIController MyController)
{
	local int i;

	super.OnConstruct(MyController);
	i = 0;
	J0x12:

	if(Less_IntInt(i, ListNames.Length))
	{
		AddComponent("GUI.GUIMultiColumnList", Concat_StrStr(Concat_StrStr(string(self.Name), "_"), ListNames[i]));
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x12;
	}
	return;
}

function InitComponent(GUIComponent MyOwner)
{
	local int i;

	super.InitComponent(MyOwner);
	i = 0;
	J0x12:

	if(Less_IntInt(i, ListNames.Length))
	{
		InitColumn(ListNames[i]);
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x12;
	}
	ClearRow();
	return;
}

private function InitColumn(string ListName)
{
	local export editinline GUIMultiColumnList newList;

	newList = FindColumn(ListName, true);
	if(EqualEqual_ObjectObject(newList, none))
	{
		newList = GUIMultiColumnList(AddComponent("GUI.GUIMultiColumnList", Concat_StrStr(Concat_StrStr(string(self.Name), "_"), ListName), true));
	}
	assert(NotEqual_ObjectObject(newList, none));
	newList.IndexID = MultiColumnList.Length;
	InitBaseList(newList.MCList);
	newList.MCList.__OnChange__Delegate = InternalOnChange;
	newList.MCList.__OnAdjustTop__Delegate = InternalOnAdjustTop;
	newList.MCList.__SwapIndices__Delegate = SwapMCLBIndices;
	newList.MCButton.__OnClick__Delegate = InternalOnClick;
	MultiColumnList[MultiColumnList.Length] = newList;
	if(EqualEqual_IntInt(ActiveIndex, newList.IndexID))
	{
		ActiveButton = newList.MCButton;
		SetActiveList(newList.MCList);
	}
	return;
}

function SetActiveColumn(string theName, optional bool bExact)
{
	local export editinline GUIMultiColumnList Column;

	Column = FindColumn(theName, bExact);
	if(EqualEqual_ObjectObject(Column, none))
	{
		return;
	}
	ActiveIndex = Column.IndexID;
	ActiveButton = Column.MCButton;
	SetActiveList(Column.MCList);
	return;
}

function GUIList GetColumn(string Header)
{
	local export editinline GUIMultiColumnList GMCList;

	GMCList = FindColumn(Header);
	AssertWithDescription(NotEqual_ObjectObject(GMCList, none), Concat_StrStr(Concat_StrStr(Concat_StrStr("Specified column \"", Header), "\" not found in "), string(self.Name)));
	return GMCList.MCList;
	return;
}

private function GUIMultiColumnList FindColumn(string theName, optional bool bExact)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, MultiColumnList.Length))
	{
		if(OrOr_BoolBool(ComplementEqual_StrStr(theName, string(MultiColumnList[i].Name)), AndAnd_BoolBool(Not_PreBool(bExact), GreaterEqual_IntInt(InStr(Caps(string(MultiColumnList[i].Name)), Caps(theName)), 0))))
		{
			return MultiColumnList[i];
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	return none;
	return;
}

function Clear()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, MultiColumnList.Length))
	{
		MultiColumnList[i].MCList.Clear();
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

private function InternalOnClick(GUIComponent Sender)
{
	ActiveButton = GUIButton(Sender);
	ActiveIndex = GUIMultiColumnList(ActiveButton.MenuOwner).IndexID;
	if(MultiColumnList[ActiveIndex].bIgnoreHeader)
	{
		Click();
		return;
	}
	SetActiveList(MultiColumnList[ActiveIndex].MCList);
	if(GUIList(MyActiveList).bListIsDirty)
	{
		GUIList(MyActiveList).Sort();
	}
	else
	{
		GUIList(MyActiveList).ReverseList();
	}
	MyScrollBar.AlignThumb();
	Click();
	return;
}

private function InternalOnChange(GUIComponent Sender)
{
	local int i, curTop;

	SetActiveList(GUIListBase(Sender));
	ActiveRowIndex = GetIndex();
	curTop = MyActiveList.Top;
	i = 0;
	J0x37:

	if(Less_IntInt(i, MultiColumnList.Length))
	{
		MultiColumnList[i].MCList.setIndex(ActiveRowIndex, true, true);
		MultiColumnList[i].MCList.Top = curTop;
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x37;
	}
	SetDirty();
	OnChange(self);
	return;
}

private function InternalOnAdjustTop(GUIComponent Sender)
{
	local int i, curTop;

	SetActiveList(GUIListBase(Sender));
	curTop = MyActiveList.Top;
	i = 0;
	J0x2B:

	if(Less_IntInt(i, MultiColumnList.Length))
	{
		MultiColumnList[i].MCList.Top = curTop;
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x2B;
	}
	return;
}

function AddNewRowElement(string ColumnHeader, optional Object Obj, optional string Str, optional int intData, optional bool bData)
{
	AddRowElement(CreateElement(ColumnHeader, Obj, Str, intData, bData));
	return;
}

function AddRowElement(GUIListElem theElem)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, MultiColumnList.Length))
	{
		if(ComplementEqual_StrStr(Controller.FixGUIComponentName(Concat_StrStr(Concat_StrStr(string(self.Name), "_"), theElem.Item)), string(MultiColumnList[i].Name)))
		{
			ActiveRow[i] = theElem;
			// [Explicit Continue]
			goto J0x8E;
		}
		if(EqualEqual_IntInt(i, ActiveRow.Length))
		{
			ActiveRow.Insert(i, 1);
		}
		J0x8E:

		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

function ClearRow()
{
	ActiveRow.Remove(0, ActiveRow.Length);
	ActiveRow[MultiColumnList.Length] = CreateElement("");
	return;
}

function int PopulateRow(optional string DontReplaceHeader)
{
	local int i, rowIndex;
	local export editinline GUIMultiColumnList Column;

	if(NotEqual_StrStr(DontReplaceHeader, ""))
	{
		Column = FindColumn(DontReplaceHeader);
		if(NotEqual_ObjectObject(Column, none))
		{
			i = Column.MCList.FindElement(ActiveRow[Column.IndexID]);
			if(GreaterEqual_IntInt(i, 0))
			{
				return i;
			}
		}
	}
	rowIndex = MultiColumnList[ActiveIndex].MCList.AddElement(ActiveRow[ActiveIndex], false, true);
	if(Less_IntInt(rowIndex, 0))
	{
		return rowIndex;
	}
	i = 0;
	J0xB4:

	if(Less_IntInt(i, MultiColumnList.Length))
	{
		if(EqualEqual_IntInt(i, ActiveIndex))
		{
			// [Explicit Continue]
			goto J0x106;
		}
		MultiColumnList[i].MCList.InsertElement(rowIndex, ActiveRow[i], false, true);
		J0x106:

		AddAdd_Int(i);
		// [Loop Continue]
		goto J0xB4;
	}
	ClearRow();
	SetDirty();
	return rowIndex;
	return;
}

private function SwapMCLBIndices(int indexA, int indexB)
{
	local int j;

	j = 0;
	J0x07:

	if(Less_IntInt(j, MultiColumnList.Length))
	{
		MultiColumnList[j].MCList.Swap(indexA, indexB, EqualEqual_IntInt(j, ActiveIndex));
		AddAdd_Int(j);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

function Sort(optional string byColumn)
{
	local int oldColumnIndex;

	oldColumnIndex = ActiveIndex;
	SetActiveColumn(byColumn);
	GUIList(MyActiveList).Sort();
	SetActiveColumn(string(MultiColumnList[oldColumnIndex].Name), true);
	return;
}

defaultproperties
{
	ActiveRowIndex=-1
	DragSpacing=2.0000000
	bPropagateStyle=false
}