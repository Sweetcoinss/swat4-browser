class SwatServerFiltersPopup extends SwatGUIPopup
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

var(SwatGui) private export editinline config GUICheckBoxButton MyPingCheck;
var(SwatGui) private export editinline config GUINumericEdit MyPingEdit;
var(SwatGui) private export editinline config GUIComboBox MyGameTypeCombo;
var(SwatGui) private export editinline config GUICheckBoxButton MyGameTypeCheck;
var(SwatGui) private export editinline config GUICheckBoxButton MyPasswordedCheck;
var(SwatGui) private export editinline config GUICheckBoxButton MyFullCheck;
var(SwatGui) private export editinline config GUICheckBoxButton MyHideIncompatibleVersionsCheck;
var(SwatGui) private export editinline config GUICheckBoxButton MyHideIncompatibleModsCheck;

function InitComponent(GUIComponent MyOwner)
{
	local int i;

	super.InitComponent(MyOwner);
	MyPingCheck.__OnChange__Delegate = InternalOnChange;
	MyGameTypeCheck.__OnChange__Delegate = InternalOnChange;
	i = 0;
	J0x3A:

	if(Less_IntInt(i, int(4)))
	{
		MyGameTypeCombo.AddItem(GC.GetGameModeName(byte(i)));
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x3A;
	}
	return;
}

function InternalOnActivate()
{
	MyPingEdit.SetValue(GC.theServerFilters.MaxPing, true);
	MyPingCheck.bForceUpdate = true;
	MyPingCheck.SetChecked(GreaterEqual_IntInt(GC.theServerFilters.MaxPing, 0));
	MyGameTypeCombo.List.setIndex(int(GC.theServerFilters.GameType));
	MyGameTypeCheck.bForceUpdate = true;
	MyGameTypeCheck.SetChecked(GC.theServerFilters.bFilterGametype);
	MyPasswordedCheck.SetChecked(GC.theServerFilters.bPassworded);
	MyFullCheck.SetChecked(GC.theServerFilters.bFull);
	MyHideIncompatibleVersionsCheck.SetChecked(GC.theServerFilters.bHideIncompatibleVersions);
	MyHideIncompatibleModsCheck.SetChecked(GC.theServerFilters.bHideIncompatibleMods);
	return;
}

protected function Confirm()
{
	if(MyPingCheck.bChecked)
	{
		GC.theServerFilters.MaxPing = MyPingEdit.Value;
	}
	else
	{
		GC.theServerFilters.MaxPing = -1;
	}
	GC.theServerFilters.GameType = byte(MyGameTypeCombo.GetIndex());
	GC.theServerFilters.bFilterGametype = MyGameTypeCheck.bChecked;
	GC.theServerFilters.bPassworded = MyPasswordedCheck.bChecked;
	GC.theServerFilters.bFull = MyFullCheck.bChecked;
	GC.theServerFilters.bHideIncompatibleVersions = MyHideIncompatibleVersionsCheck.bChecked;
	GC.theServerFilters.bHideIncompatibleMods = MyHideIncompatibleModsCheck.bChecked;
	GC.SaveConfig();
	return;
}

function InternalOnChange(GUIComponent Sender)
{
	switch(Sender)
	{
		case MyPingCheck:
			MyPingEdit.SetEnabled(MyPingCheck.bChecked);
			break;
		case MyGameTypeCheck:
			MyGameTypeCombo.SetEnabled(MyGameTypeCheck.bChecked);
			break;
		default:
			break;
	}
	return;
}

defaultproperties
{
	Passback="Filters"
	OnActivate=SwatServerFiltersPopup.InternalOnActivate
}