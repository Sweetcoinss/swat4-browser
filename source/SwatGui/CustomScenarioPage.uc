class CustomScenarioPage extends SwatCustomScenarioPageBase
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

var(SwatGui) private export editinline config GUIButton cmd_main;
var(SwatGui) private export editinline config CustomScenarioTabControl tabs;
var(SwatGui) export editinline config GUILabel pnl_enemies_pnl_body_lbl_count;
var(SwatGui) export editinline config GUINumericEdit pnl_enemies_spin_count_min;
var(SwatGui) export editinline config GUINumericEdit pnl_enemies_spin_count_max;
var(SwatGui) export editinline config GUILabel pnl_hostages_pnl_body_lbl_count;
var(SwatGui) export editinline config GUINumericEdit pnl_hostages_spin_count_min;
var(SwatGui) export editinline config GUINumericEdit pnl_hostages_spin_count_max;
var private CustomScenario CustomScenario;
var private config localized string ConfirmationString;
var private config localized string ConfirmOverwriteExistingScenarioString;
var private bool bCheckForOverwrite;

function InitComponent(GUIComponent MyOwner)
{
	super.InitComponent(MyOwner);
	cmd_main.__OnClick__Delegate = cmd_main_OnClick;
	return;
}

function cmd_main_OnClick(GUIComponent Sender)
{
	PerformClose();
	return;
}

function PerformClose()
{
	if(CustomScenarioCreatorData.IsCurrentMisisonDirty())
	{
		ConfirmQuitOrSave("MainMenu");
	}
	else
	{
		super(SwatGUIPage).PerformClose();
	}
	return;
}

function ConfirmQuitOrSave(string Passback)
{
	__OnDlgReturned__Delegate = ConfirmedQuitOrSave;
	OpenDlg(ConfirmationString, QBTN_YesNo, Passback);
	return;
}

private function ConfirmedQuitOrSave(int returnButton, optional string Passback)
{
	if(EqualEqual_IntInt(returnButton, QBTN_Yes))
	{
		if(EqualEqual_StrStr(Passback, "MainMenu"))
		{
			PerformClose();
		}
		else
		{
			if(EqualEqual_StrStr(Passback, "Selection"))
			{
				OnActivate();
			}
		}
	}
	return;
}

function OnActivate()
{
	CustomScenarioCreatorData.ClearCurrentMissionDirty();
	RefreshCustomScenarioPackList();
	tabs.OpenTabByIndex(int(0));
	return;
}

function CreateNewScenario()
{
	Controller.OpenWaitDialog();
	NewCustomScenario();
	InternalEditScenario(false);
	CustomScenario_SavePanel(tabs.MyTabs[int(6)].TabPanel).LocalizeNewScenarioName();
	Controller.CloseWaitDialog();
	bCheckForOverwrite = true;
	return;
}

function EditScenario(string Scenario, string Pack)
{
	Controller.OpenWaitDialog();
	CustomScenarioPack.LoadCustomScenarioInPlace(NewCustomScenario(), Scenario, PackPlusExtension(Pack), CustomScenarioCreatorData.ScenariosPath);
	InternalEditScenario(false);
	Controller.CloseWaitDialog();
	bCheckForOverwrite = false;
	return;
}

function DeleteScenario(string Scenario, string Pack)
{
	CustomScenarioPack.DeleteCustomScenario(Scenario, PackPlusExtension(Pack), CustomScenarioCreatorData.ScenariosPath);
	OnActivate();
	return;
}

function SaveCurrentScenario()
{
	local string Scenario, Pack;

	GatherScenarioFromFields();
	if(bCheckForOverwrite)
	{
		Scenario = GetCustomScenario().ScenarioName;
		Pack = GetCustomScenario().PackName;
		CustomScenarioPack.Reset(PackPlusExtension(Pack), CustomScenarioCreatorData.ScenariosPath);
		if(CustomScenarioPack.HasScenario(Scenario))
		{
			__OnDlgReturned__Delegate = ConfirmOverwriteExistingScenario;
			OpenDlg(FormatTextString(ConfirmOverwriteExistingScenarioString, Scenario, Pack), QBTN_YesNo, "Overwrite");
			return;
		}
	}
	ReallySaveCurrentScenario();
	return;
}

function ReallySaveCurrentScenario()
{
	local string Scenario, Pack;

	Scenario = GetCustomScenario().ScenarioName;
	Pack = GetCustomScenario().PackName;
	CustomScenarioPack.SaveCustomScenario(GetCustomScenario(), Scenario, PackPlusExtension(Pack), CustomScenarioCreatorData.ScenariosPath);
	OnActivate();
	return;
}

private function ConfirmOverwriteExistingScenario(int returnButton, optional string Passback)
{
	if(EqualEqual_IntInt(returnButton, QBTN_Yes))
	{
		ReallySaveCurrentScenario();
	}
	return;
}

function SetCheckForOverwrite()
{
	bCheckForOverwrite = true;
	return;
}

private function InternalEditScenario(bool NewScenario)
{
	PopulateFieldsFromScenario(NewScenario);
	OpenInitialTab();
	return;
}

function OpenInitialTab()
{
	tabs.OpenTabByIndex(int(1));
	return;
}

function PopulateFieldsFromScenario(bool NewScenario)
{
	local int i;

	assert(Not_PreBool(NewScenario));
	i = 0;
	J0x12:

	if(Less_IntInt(i, int(7)))
	{
		CustomScenarioTabPanel(tabs.MyTabs[i].TabPanel).PopulateFieldsFromScenario(NewScenario);
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x12;
	}
	return;
}

function GatherScenarioFromFields()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, int(7)))
	{
		CustomScenarioTabPanel(tabs.MyTabs[i].TabPanel).GatherScenarioFromFields();
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

function CustomScenario NewCustomScenario()
{
	CustomScenario = Class'SwatGame.CustomScenario'.static.Allocate(self).;
	Construct_Void();
	assert(NotEqual_ObjectObject(CustomScenario, none));
	CustomScenarioPack.LoadCustomScenarioInPlace(CustomScenario, "New Scenario", "Default.pak", "..\\..\\Content\\Classes\\");
	return CustomScenario;
	return;
}

function CustomScenario GetCustomScenario()
{
	return CustomScenario;
	return;
}

function PlayScenario(string ScenarioName, string PackName)
{
	SetCustomScenarioPack(PackName);
	GC.SetCustomScenarioPackData(CustomScenarioPack, PackPlusExtension(PackName), PackMinusExtension(PackName), CustomScenarioCreatorData.ScenariosPath);
	GC.SetScenarioName(ScenarioName);
	Controller.CloseMenu();
	SwatGUIController(Controller).Repo.RoleChange(2);
	Controller.OpenMenu("SwatGui.SwatCustomMenu", "SwatCustomMenu");
	Controller.OpenMenu("SwatGui.SwatMissionSetupMenu", "SwatMissionSetupMenu");
	return;
}

defaultproperties
{
	ConfirmationString="There are unsaved changes.  Are you sure you want to leave and lose those changes?"
	ConfirmOverwriteExistingScenarioString="A scenario named '%1' already exists in pack '%2'.  Are you sure you wish to overwrite it?"
}