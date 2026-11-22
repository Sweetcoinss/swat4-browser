class SwatKeyControlSettingsPanel extends SwatSettingsPanel
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

var(SwatGui) private export editinline config GUIMultiColumnListBox MyKeyBindingsBox;
var(SwatGui) private export editinline config GUIButton MyKeyChoose;
var(SwatGui) editinline config array<export editinline GUIButton> MyCategoryButtons;
var(SwatGui) private SwatGUIConfig.eCommandCategory LastCategory;
var(DEBUG) array<string> RestrictedKeys;
var(SwatGui) private config int MaxKeysLength;
var private config localized string ReMappingQuery;
var private int SelectedIndex;

function InitComponent(GUIComponent MyOwner)
{
	local int i;

	super.InitComponent(MyOwner);
	MyKeyChoose.__OnClick__Delegate = InternalOnClick;
	i = 0;
	J0x26:

	if(Less_IntInt(i, MyCategoryButtons.Length))
	{
		MyCategoryButtons[i].__OnClick__Delegate = CategorySelectorOnClick;
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x26;
	}
	i = 0;
	J0x61:

	if(Less_IntInt(i, MyKeyBindingsBox.MultiColumnList.Length))
	{
		MyKeyBindingsBox.MultiColumnList[i].MCList.__OnDblClick__Delegate = InternalOnClick;
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x61;
	}
	MyKeyBindingsBox.__OnChange__Delegate = OnListSelectionChanged;
	SelectedIndex = -1;
	RestrictKeys();
	return;
}

function SaveSettings()
{
	return;
}

function LoadSettings()
{
	LoadCategory(LastCategory);
	return;
}

private function RestrictKeys()
{
	local int i;
	local string newRestrictedKeys;

	i = 0;
	J0x07:

	if(Less_IntInt(i, GC.CommandString.Length))
	{
		if(NotEqual_IntInt(int(GC.CommandCategory[i]), int(3)))
		{
			// [Explicit Continue]
			goto J0xAB;
		}
		newRestrictedKeys = PlayerOwner().ConsoleCommand(At_StrStr("GETKEYFORBINDING", GC.CommandString[i]));
		J0x80:

		if(NotEqual_StrStr(newRestrictedKeys, ""))
		{
			RestrictedKeys[RestrictedKeys.Length] = GetFirstField(newRestrictedKeys, ", ");
			// [Loop Continue]
			goto J0x80;
		}
		J0xAB:

		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

private function LoadCategory(SwatGUIConfig.eCommandCategory category)
{
	local int i;
	local string boundKeys;

	LastCategory = category;
	MyKeyBindingsBox.Clear();
	i = 0;
	J0x21:

	if(Less_IntInt(i, GC.CommandString.Length))
	{
		if(NotEqual_IntInt(int(GC.CommandCategory[i]), int(category)))
		{
			// [Explicit Continue]
			goto J0x131;
		}
		boundKeys = PlayerOwner().ConsoleCommand(At_StrStr("GETLOCALIZEDKEYFORBINDING", GC.CommandString[i]));
		if(EqualEqual_StrStr(boundKeys, ""))
		{
			boundKeys = "----";
		}
		MyKeyBindingsBox.AddNewRowElement("Functions",, GC.LocalizedCommandString[i], i);
		MyKeyBindingsBox.AddNewRowElement("MappedKey",, boundKeys, i);
		MyKeyBindingsBox.PopulateRow("Functions");
		J0x131:

		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x21;
	}
	MyKeyBindingsBox.SetActiveColumn("Functions");
	MyKeyBindingsBox.Sort();
	MyKeyBindingsBox.setIndex(SelectedIndex);
	SelectedIndex = -1;
	MyKeyBindingsBox.SetEnabled(NotEqual_IntInt(int(category), int(3)));
	i = 0;
	J0x1A6:

	if(Less_IntInt(i, MyCategoryButtons.Length))
	{
		MyCategoryButtons[i].SetEnabled(NotEqual_IntInt(i, int(category)));
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x1A6;
	}
	return;
}

private function bool IsRestricted(string Key)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, RestrictedKeys.Length))
	{
		if(ComplementEqual_StrStr(RestrictedKeys[i], Key))
		{
			return true;
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	return false;
	return;
}

function OnListSelectionChanged(GUIComponent Sender)
{
	MyKeyChoose.SetEnabled(AndAnd_BoolBool(NotEqual_IntInt(int(LastCategory), int(3)), GreaterEqual_IntInt(MyKeyBindingsBox.GetIndex(), 0)));
	return;
}

function InternalOnClick(GUIComponent Sender)
{
	local string LocalizedFunc, Func, Bound;

	LocalizedFunc = MyKeyBindingsBox.GetColumn("Functions").GetExtra();
	Func = GC.CommandString[MyKeyBindingsBox.GetColumn("Functions").GetExtraIntData()];
	Bound = MyKeyBindingsBox.GetColumn("MappedKey").GetExtra();
	if(NotEqual_StrStr(Func, ""))
	{
		Controller.OpenMenu("SwatGui.SwatKeyMappingPopup", "SwatKeyMappingPopup", FormatTextString(ReMappingQuery, LocalizedFunc, Bound), Func, Len(Bound));
	}
	return;
}

function InternalOnPopupReturned(GUIListElem returnObj, optional string Passback)
{
	if(IsRestricted(returnObj.ExtraStrData))
	{
		return;
	}
	SelectedIndex = MyKeyBindingsBox.GetIndex();
	if(EqualEqual_StrStr(PlayerOwner().ConsoleCommand(At_StrStr("KEYBINDING", returnObj.ExtraStrData)), Passback))
	{
		Passback = "";
	}
	if(AndAnd_BoolBool(NotEqual_StrStr(Passback, ""), GreaterEqual_IntInt(Add_IntInt(returnObj.ExtraIntData, Len(returnObj.ExtraStrData)), MaxKeysLength)))
	{
		return;
	}
	Controller.StaticExec(At_StrStr(At_StrStr("SET Input", returnObj.ExtraStrData), Passback));
	return;
}

private function CategorySelectorOnClick(GUIComponent Sender)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, MyCategoryButtons.Length))
	{
		if(EqualEqual_ObjectObject(MyCategoryButtons[i], Sender))
		{
			LoadCategory(byte(i));
			return;
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

protected function ResetToDefaults()
{
	PlayerOwner().ConsoleCommand("REMOVEALLKEYBINDINGS");
	Class'SwatGui.SwatInputReset'.static.Allocate(self).;
	Construct_GUIController(Controller);
	LoadCategory(LastCategory);
	return;
}

defaultproperties
{
	MaxKeysLength=50
	ReMappingQuery="The current bindings for %1 are %2. Press a different key to add it to the list of bindings, or press a currently bound key to remove it from the bindings."
	ConfirmResetString="Are you sure that you wish to reset all key bindings to their defaults? This may take a few moments."
}