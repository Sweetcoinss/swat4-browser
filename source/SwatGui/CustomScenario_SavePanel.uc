class CustomScenario_SavePanel extends CustomScenarioTabPanel
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

var(SwatGui) private export editinline config GUIEditBox txt_name;
var(SwatGui) private export editinline config GUIComboBox cbo_pack;
var(SwatGui) private export editinline config GUIButton cmd_save_OK;
var(SwatGui) private export editinline config GUIButton cmd_save_Cancel;

function InitComponent(GUIComponent MyOwner)
{
	super(SwatGUIPanel).InitComponent(MyOwner);
	cmd_save_OK.__OnClick__Delegate = cmd_save_OK_OnClick;
	cmd_save_Cancel.__OnClick__Delegate = cmd_save_Cancel_OnClick;
	txt_name.__OnChange__Delegate = OnSaveNameChanged;
	cbo_pack.__OnChange__Delegate = OnSaveNameChanged;
	data = CustomScenarioPage.CustomScenarioCreatorData;
	return;
}

function OnSaveNameChanged(GUIComponent Sender)
{
	cmd_save_OK.SetEnabled(AndAnd_BoolBool(NotEqual_StrStr(txt_name.GetText(), ""), NotEqual_StrStr(cbo_pack.GetText(), "")));
	CustomScenarioPage.SetCheckForOverwrite();
	return;
}

function cmd_save_OK_OnClick(GUIComponent Sender)
{
	CustomScenarioPage.SaveCurrentScenario();
	return;
}

function cmd_save_Cancel_OnClick(GUIComponent Sender)
{
	CustomScenarioPage.OpenInitialTab();
	return;
}

function LocalizeNewScenarioName()
{
	txt_name.SetText(data.NewScenarioString);
	cbo_pack.SetText(CustomScenarioPage.PackMinusExtension(data.DefaultPackString));
	return;
}

function PopulateFieldsFromScenario(bool NewScenario)
{
	local CustomScenario Scenario;
	local int i;

	cbo_pack.Clear();
	i = 0;
	J0x16:

	if(Less_IntInt(i, CustomScenarioPage.ScenarioPacks.Length))
	{
		cbo_pack.AddItem(CustomScenarioPage.ScenarioPacks[i]);
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x16;
	}
	if(NewScenario)
	{
		txt_name.SetText(data.NewScenarioString);
		cbo_pack.SetText(CustomScenarioPage.PackMinusExtension(data.DefaultPackString));
	}
	else
	{
		Scenario = CustomScenarioPage.GetCustomScenario();
		txt_name.SetText(Scenario.ScenarioName);
		cbo_pack.Edit.SetText(CustomScenarioPage.PackMinusExtension(Scenario.PackName));
	}
	return;
}

function GatherScenarioFromFields()
{
	local CustomScenario Scenario;

	Scenario = CustomScenarioPage.GetCustomScenario();
	Scenario.ScenarioName = txt_name.GetText();
	Scenario.PackName = cbo_pack.Edit.GetText();
	return;
}
