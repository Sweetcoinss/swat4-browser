class SwatCampaignMenu extends SwatGUIPage
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
var(SwatGui) private export editinline config GUIEditBox MyNameEntry;
var(SwatGui) private export editinline config GUIButton MyCreateCampaignButton;
var(SwatGui) private export editinline config GUIComboBox MyCampaignSelectionBox;
var(SwatGui) private export editinline config GUIButton MyDeleteCampaignButton;
var(SwatGui) private export editinline config GUIButton MyUseCampaignButton;
var private config localized string StringA;
var private config localized string StringB;
var private config localized string StringC;
var private config localized string StringE;
var private config localized string StringJ;
var private config localized string StringK;

function InitComponent(GUIComponent MyOwner)
{
	local int Index;
	local array<Campaign> TheCampaigns;

	super.InitComponent(MyOwner);
	TheCampaigns = SwatGUIController(Controller).GetCampaigns().GetCampaigns();
	MyCampaignSelectionBox.Clear();
	Index = 0;
	J0x45:

	if(Less_IntInt(Index, TheCampaigns.Length))
	{
		MyCampaignSelectionBox.List.Add(TheCampaigns[Index].StringName, TheCampaigns[Index]);
		AddAdd_Int(Index);
		// [Loop Continue]
		goto J0x45;
	}
	MyCampaignSelectionBox.List.Sort();
	MyCampaignSelectionBox.__OnChange__Delegate = InternalOnChange;
	MyNameEntry.__OnEntryCompleted__Delegate = InternalOnClick;
	MyNameEntry.__OnChange__Delegate = InternalOnChange;
	MyNameEntry.__OnEntryCancelled__Delegate = InternalEntryCancelled;
	MyCreateCampaignButton.__OnClick__Delegate = InternalOnClick;
	MyUseCampaignButton.__OnClick__Delegate = InternalOnClick;
	MyDeleteCampaignButton.__OnClick__Delegate = InternalOnClick;
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
	if(EqualEqual_StrStr(MyCampaignSelectionBox.find(SwatGUIController(Controller).GetCampaigns().CurCampaignName), ""))
	{
		MyCampaignSelectionBox.setIndex(0);
	}
	MyCampaignSelectionBox.SetEnabled(NotEqual_IntInt(MyCampaignSelectionBox.List.ItemCount, 0));
	MyUseCampaignButton.SetEnabled(NotEqual_IntInt(MyCampaignSelectionBox.List.ItemCount, 0));
	MyDeleteCampaignButton.SetEnabled(NotEqual_IntInt(MyCampaignSelectionBox.List.ItemCount, 0));
	MyCreateCampaignButton.SetEnabled(IsCampaignNameValid(MyNameEntry.GetText()));
	return;
}

private function InternalOnFocused(GUIComponent Sender)
{
	MyNameEntry.SetText(StringK);
	MyNameEntry.Focus();
	return;
}

private function InternalOnChange(GUIComponent Sender)
{
	switch(Sender)
	{
		case MyCampaignSelectionBox:
			SetCampaign(Campaign(MyCampaignSelectionBox.GetObject()));
			break;
		case MyNameEntry:
			MyCreateCampaignButton.SetEnabled(IsCampaignNameValid(MyNameEntry.GetText()));
			break;
		default:
			break;
	}
	return;
}

private function InternalOnClick(GUIComponent Sender)
{
	switch(Sender)
	{
		case MyQuitButton:
			Quit();
			break;
		case MyNameEntry:
		case MyCreateCampaignButton:
			AttemptCreateCampaign(MyNameEntry.GetText());
			break;
		case MyUseCampaignButton:
			GC.SetCustomScenarioPackData(none);
			Controller.OpenMenu("SwatGui.SwatMissionSetupMenu", "SwatMissionSetupMenu");
			break;
		case MyMainMenuButton:
			PerformClose();
			break;
		case MyDeleteCampaignButton:
			__OnDlgReturned__Delegate = InternalOnDlgReturned;
			OpenDlg(Concat_StrStr(StringJ, MyCampaignSelectionBox.Get()), QBTN_YesNo, "DeleteCampaign");
			break;
		default:
			break;
	}
	return;
}

private function InternalEntryCancelled(GUIComponent Sender)
{
	PerformClose();
	return;
}

private function InternalOnDlgReturned(int Selection, string Passback)
{
	local string campName;

	switch(Passback)
	{
		case "DeleteCampaign":
			if(EqualEqual_IntInt(Selection, QBTN_Yes))
			{
				campName = MyCampaignSelectionBox.Get();
				DeleteCampaign(campName);
				MyCampaignSelectionBox.SetEnabled(NotEqual_IntInt(MyCampaignSelectionBox.List.ItemCount, 0));
				MyUseCampaignButton.SetEnabled(NotEqual_IntInt(MyCampaignSelectionBox.List.ItemCount, 0));
				MyDeleteCampaignButton.SetEnabled(NotEqual_IntInt(MyCampaignSelectionBox.List.ItemCount, 0));
			}
			break;
		case "OverwriteCampaign":
			if(EqualEqual_IntInt(Selection, QBTN_Yes))
			{
				campName = MyNameEntry.GetText();
				DeleteCampaign(campName);
				CreateCampaign(campName);
			}
			break;
		default:
			break;
	}
	return;
}

private function SetCampaign(Campaign theCampaign)
{
	if(EqualEqual_ObjectObject(theCampaign, none))
	{
		return;
	}
	SwatGUIController(Controller).UseCampaign(theCampaign.StringName);
	return;
}

private function AttemptCreateCampaign(string campName)
{
	if(Not_PreBool(IsCampaignNameValid(campName)))
	{
		__OnDlgReturned__Delegate = InternalOnDlgReturned;
		OpenDlg(Concat_StrStr(campName, StringA), QBTN_Ok, "InvalidName");
	}
	else
	{
		if(SwatGUIController(Controller).CampaignExists(campName))
		{
			__OnDlgReturned__Delegate = InternalOnDlgReturned;
			OpenDlg(Concat_StrStr(Concat_StrStr(StringC, campName), StringE), QBTN_YesNo, "OverwriteCampaign");
		}
		else
		{
			CreateCampaign(campName);
		}
	}
	return;
}

private function CreateCampaign(string campName)
{
	local Campaign NewCampaign;

	NewCampaign = SwatGUIController(Controller).AddCampaign(campName);
	AssertWithDescription(NotEqual_ObjectObject(NewCampaign, none), Concat_StrStr("Could not create campaign with name: ", campName));
	MyCampaignSelectionBox.AddItem(NewCampaign.StringName, NewCampaign);
	SetCampaign(NewCampaign);
	MyNameEntry.SetText("");
	Controller.OpenMenu("SwatGui.SwatMissionSetupMenu", "SwatMissionSetupMenu");
	return;
}

private function DeleteCampaign(string campName)
{
	SwatGUIController(Controller).super(SwatCampaignMenu).DeleteCampaign(campName);
	MyCampaignSelectionBox.List.RemoveItem(campName);
	return;
}

private function bool IsCampaignNameValid(string Campaign)
{
	local int i;

	if(EqualEqual_StrStr(Campaign, ""))
	{
		return false;
	}
	i = Subtract_IntInt(Len(Campaign), 1);
	J0x1E:

	if(GreaterEqual_IntInt(i, 0))
	{
		if(NotEqual_StrStr(Mid(Campaign, i, 1), " "))
		{
			return true;
		}
		SubtractSubtract_Int(i);
		// [Loop Continue]
		goto J0x1E;
	}
	return false;
	return;
}

defaultproperties
{
	StringA=" is not a valid campaign name."
	StringB="Campaign: "
	StringC="A campaign with the name "
	StringE=" already exists.  Do you wish to overwrite it?"
	StringJ="Are you sure that you want to delete campaign "
	StringK="Officer Default"
	OnActivate=SwatCampaignMenu.InternalOnActivate
	OnFocused=SwatCampaignMenu.InternalOnFocused
}