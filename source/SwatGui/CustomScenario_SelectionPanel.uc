class CustomScenario_SelectionPanel extends CustomScenarioTabPanel
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

var(SwatGui) private export editinline config GUIButton cmd_play;
var(SwatGui) private export editinline config GUIButton cmd_new;
var(SwatGui) private export editinline config GUIButton cmd_edit;
var(SwatGui) private export editinline config GUIButton cmd_delete;
var(SwatGui) private export editinline config CustomScenarioList lst_scenarios;
var private config localized string ConfirmDeleteString;

function InitComponent(GUIComponent MyOwner)
{
	super(SwatGUIPanel).InitComponent(MyOwner);
	data = CustomScenarioPage.CustomScenarioCreatorData;
	cmd_play.__OnClick__Delegate = cmd_play_OnClick;
	cmd_new.__OnClick__Delegate = cmd_new_OnClick;
	cmd_edit.__OnClick__Delegate = cmd_edit_OnClick;
	cmd_delete.__OnClick__Delegate = cmd_delete_OnClick;
	lst_scenarios.__OnChange__Delegate = lst_scenarios_OnChange;
	return;
}

event Activate()
{
	RefreshScenariosList();
	super(GUIMultiComponent).Activate();
	UpdateButtonStates();
	return;
}

function cmd_play_OnClick(GUIComponent Sender)
{
	local string Scenario, Pack;

	lst_scenarios.GetSelectedRow(Scenario, Pack);
	CustomScenarioPage.PlayScenario(Scenario, Pack);
	return;
}

function cmd_new_OnClick(GUIComponent Sender)
{
	CustomScenarioPage.CreateNewScenario();
	return;
}

function cmd_edit_OnClick(GUIComponent Sender)
{
	local string Scenario, Pack;

	lst_scenarios.GetSelectedRow(Scenario, Pack);
	CustomScenarioPage.EditScenario(Scenario, Pack);
	return;
}

function cmd_delete_OnClick(GUIComponent Sender)
{
	local string Scenario, Pack;

	lst_scenarios.GetSelectedRow(Scenario, Pack);
	Controller.TopPage().__OnDlgReturned__Delegate = ConfirmDeleteDlgReturned;
	Controller.TopPage().OpenDlg(FormatTextString(ConfirmDeleteString, Scenario, Pack), QBTN_YesNo, "");
	return;
}

function ConfirmDeleteDlgReturned(int Selection, string Passback)
{
	local string Scenario, Pack;

	if(NotEqual_IntInt(Selection, QBTN_Yes))
	{
		return;
	}
	lst_scenarios.GetSelectedRow(Scenario, Pack);
	CustomScenarioPage.DeleteScenario(Scenario, Pack);
	RefreshScenariosList();
	return;
}

function RefreshScenariosList()
{
	local int i, j;
	local string PackName;

	lst_scenarios.Clear();
	i = 0;
	J0x16:

	if(Less_IntInt(i, CustomScenarioPage.ScenarioPacks.Length))
	{
		PackName = CustomScenarioPage.ScenarioPacks[i];
		CustomScenarioPage.SetCustomScenarioPack(PackName);
		j = 0;
		J0x64:

		if(Less_IntInt(j, CustomScenarioPage.GetPack().ScenarioStrings.Length))
		{
			lst_scenarios.AddRow(CustomScenarioPage.GetPack().ScenarioStrings[j], PackName);
			AddAdd_Int(j);
			// [Loop Continue]
			goto J0x64;
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x16;
	}
	return;
}

function UpdateButtonStates()
{
	cmd_new.EnableComponent();
	cmd_edit.SetEnabled(GreaterEqual_IntInt(lst_scenarios.ActiveRowIndex, 0));
	cmd_delete.SetEnabled(GreaterEqual_IntInt(lst_scenarios.ActiveRowIndex, 0));
	cmd_play.SetEnabled(GreaterEqual_IntInt(lst_scenarios.ActiveRowIndex, 0));
	return;
}

function lst_scenarios_OnChange(GUIComponent Sender)
{
	UpdateButtonStates();
	return;
}

function PopulateFieldsFromScenario(bool NewScenario)
{
	return;
}

function GatherScenarioFromFields()
{
	return;
}

defaultproperties
{
	ConfirmDeleteString="Are you sure that you wish to delete scenario %1 from pack %2?"
}