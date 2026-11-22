class SwatCustomMenu extends SwatCustomScenarioPageBase
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

var(SwatGui) private export editinline config GUIButton MyMainMenuButton;
var(SwatGui) private export editinline config GUIButton MyQuitButton;
var(SwatGui) private export editinline config GUIButton CampaignTabButton;
var(SwatGui) private export editinline config GUIButton MissionTabButton;
var(SwatGui) private export editinline config GUIButton BriefingTabButton;
var(SwatGui) private export editinline config GUIButton LoadoutTabButton;
var(SwatGui) private export editinline config GUIButton StartButton;
var(SwatGui) private export editinline config GUIComboBox MyCustomSelectionBox;
var(SwatGui) private export editinline config GUIButton MyUseCustomButton;
var private bool bRefreshingPaks;

function InitComponent(GUIComponent MyOwner)
{
	super.InitComponent(MyOwner);
	MyCustomSelectionBox.__OnChange__Delegate = CustomSelectionChange;
	MyUseCustomButton.__OnClick__Delegate = InternalOnClick;
	MyQuitButton.__OnClick__Delegate = InternalOnClick;
	MyMainMenuButton.__OnClick__Delegate = InternalOnClick;
	CampaignTabButton.bNeverFocus = false;
	return;
}

private function InternalOnActivate()
{
	MyQuitButton.__OnClick__Delegate = InternalOnClick;
	MyMainMenuButton.__OnClick__Delegate = InternalOnClick;
	CampaignTabButton.Focus();
	MissionTabButton.DisableComponent();
	BriefingTabButton.DisableComponent();
	LoadoutTabButton.DisableComponent();
	StartButton.DisableComponent();
	PopulatePakList();
	if(EqualEqual_StrStr(MyCustomSelectionBox.find(GC.GetPakFriendlyName()), ""))
	{
		MyCustomSelectionBox.setIndex(0);
	}
	MyCustomSelectionBox.SetEnabled(NotEqual_IntInt(MyCustomSelectionBox.List.ItemCount, 0));
	MyUseCustomButton.SetEnabled(NotEqual_IntInt(MyCustomSelectionBox.List.ItemCount, 0));
	return;
}

private function CustomSelectionChange(GUIComponent Sender)
{
	if(bRefreshingPaks)
	{
		return;
	}
	SetCustomScenarioPack(MyCustomSelectionBox.Get());
	return;
}

private function InternalOnClick(GUIComponent Sender)
{
	switch(Sender)
	{
		case MyQuitButton:
			Quit();
			break;
		case MyUseCustomButton:
			GC.SetCustomScenarioPackData(CustomScenarioPack, PackPlusExtension(MyCustomSelectionBox.Get()), PackMinusExtension(MyCustomSelectionBox.Get()), CustomScenarioCreatorData.ScenariosPath);
			Controller.OpenMenu("SwatGui.SwatMissionSetupMenu", "SwatMissionSetupMenu");
			break;
		case MyMainMenuButton:
			Controller.CloseMenu();
			break;
		default:
			break;
	}
	return;
}

private function PopulatePakList()
{
	local int PackIterator;
	local string PackName;

	bRefreshingPaks = true;
	RefreshCustomScenarioPackList();
	MyCustomSelectionBox.Clear();
	PackIterator = -1;
	J0x28:

	PackName = PackMinusExtension(NextCustomScenarioPack(PackIterator));
	SetCustomScenarioPack(PackName);
	if(AndAnd_BoolBool(GreaterEqual_IntInt(PackIterator, 0), Greater_IntInt(GetPack().GetScenarioCount(), 0)))
	{
		MyCustomSelectionBox.AddItem(PackName);
	}
	if(!(Less_IntInt(PackIterator, 0)))
		goto J0x28;
	bRefreshingPaks = false;
	return;
}

defaultproperties
{
	OnActivate=SwatCustomMenu.InternalOnActivate
}