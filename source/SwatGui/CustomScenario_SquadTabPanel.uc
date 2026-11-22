class CustomScenario_SquadTabPanel extends CustomScenarioTabPanel
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

var(SwatGui) private export editinline config GUIPanel pnl_officers;
var(SwatGui) private export editinline config GUICheckBoxButton chk_lone_wolf;
var(SwatGui) private export editinline config GUILabel lbl_lone_wolf;
var(SwatGui) private export editinline config GUICheckBoxButton pnl_officers_chk_red_one;
var(SwatGui) private export editinline config GUICheckBoxButton pnl_officers_chk_red_two;
var(SwatGui) private export editinline config GUICheckBoxButton pnl_officers_chk_blue_two;
var(SwatGui) private export editinline config GUICheckBoxButton pnl_officers_chk_blue_one;
var(SwatGui) export editinline config CustomScenarioOfficerPanel pnl_officer_red_one;
var(SwatGui) export editinline config CustomScenarioOfficerPanel pnl_officer_red_two;
var(SwatGui) export editinline config CustomScenarioOfficerPanel pnl_officer_blue_one;
var(SwatGui) export editinline config CustomScenarioOfficerPanel pnl_officer_blue_two;
var private bool bLoneWolfBeingChecked;

function InitComponent(GUIComponent MyOwner)
{
	local int i;

	super(SwatGUIPanel).InitComponent(MyOwner);
	data = CustomScenarioPage.CustomScenarioCreatorData;
	chk_lone_wolf.__OnChange__Delegate = chk_lone_wolf_OnChange;
	pnl_officers_chk_red_one.__OnChange__Delegate = pnl_officers_chk_red_one_OnChange;
	pnl_officers_chk_red_two.__OnChange__Delegate = pnl_officers_chk_red_two_OnChange;
	pnl_officers_chk_blue_one.__OnChange__Delegate = pnl_officers_chk_blue_one_OnChange;
	pnl_officers_chk_blue_two.__OnChange__Delegate = pnl_officers_chk_blue_two_OnChange;
	pnl_officer_red_one.cbo.AddItem("Any",, data.AnyLoadoutString);
	i = 0;
	J0xB6:

	if(Less_IntInt(i, data.PredefinedRedOneLoadOut.Length))
	{
		pnl_officer_red_one.cbo.AddItem(data.PredefinedRedOneLoadOut[i],, GetLoadoutFriendlyName(data.PredefinedRedOneLoadOut[i], 'OfficerRedOne'));
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0xB6;
	}
	pnl_officer_red_two.cbo.AddItem("Any",, data.AnyLoadoutString);
	i = 0;
	J0x158:

	if(Less_IntInt(i, data.PredefinedRedTwoLoadOut.Length))
	{
		pnl_officer_red_two.cbo.AddItem(data.PredefinedRedTwoLoadOut[i],, GetLoadoutFriendlyName(data.PredefinedRedTwoLoadOut[i], 'OfficerRedTwo'));
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x158;
	}
	pnl_officer_blue_one.cbo.AddItem("Any",, data.AnyLoadoutString);
	i = 0;
	J0x1FA:

	if(Less_IntInt(i, data.PredefinedBlueOneLoadOut.Length))
	{
		pnl_officer_blue_one.cbo.AddItem(data.PredefinedBlueOneLoadOut[i],, GetLoadoutFriendlyName(data.PredefinedBlueOneLoadOut[i], 'OfficerBlueOne'));
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x1FA;
	}
	pnl_officer_blue_two.cbo.AddItem("Any",, data.AnyLoadoutString);
	i = 0;
	J0x29C:

	if(Less_IntInt(i, data.PredefinedBlueTwoLoadOut.Length))
	{
		pnl_officer_blue_two.cbo.AddItem(data.PredefinedBlueTwoLoadOut[i],, GetLoadoutFriendlyName(data.PredefinedBlueTwoLoadOut[i], 'OfficerBlueTwo'));
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x29C;
	}
	chk_lone_wolf.SetChecked(false);
	return;
}

function string GetLoadoutFriendlyName(string LoadOut, name Officer)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, GC.CustomEquipmentLoadouts.Length))
	{
		if(EqualEqual_StrStr(GC.CustomEquipmentLoadouts[i], LoadOut))
		{
			return GC.CustomEquipmentLoadoutFriendlyNames[i];
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	AssertWithDescription(false, Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] CustomScenario_SquadTabPanel::GetLoadoutFriendlyName() couldn't find the LoadOut named ", LoadOut), " for "), string(Officer)), " in his PredefinedLoadOut in CustomScenarioCreator.ini."));
	return;
}

function chk_lone_wolf_OnChange(GUIComponent Sender)
{
	bLoneWolfBeingChecked = true;
	pnl_officers_chk_red_one.SetChecked(Not_PreBool(chk_lone_wolf.bChecked));
	pnl_officers_chk_red_two.SetChecked(Not_PreBool(chk_lone_wolf.bChecked));
	pnl_officers_chk_blue_one.SetChecked(Not_PreBool(chk_lone_wolf.bChecked));
	pnl_officers_chk_blue_two.SetChecked(Not_PreBool(chk_lone_wolf.bChecked));
	bLoneWolfBeingChecked = false;
	return;
}

function pnl_officers_chk_red_one_OnChange(GUIComponent Sender)
{
	pnl_officer_red_one.SetEnabled(pnl_officers_chk_red_one.bChecked);
	SetLoneWolfCheck();
	return;
}

function pnl_officers_chk_red_two_OnChange(GUIComponent Sender)
{
	pnl_officer_red_two.SetEnabled(pnl_officers_chk_red_two.bChecked);
	SetLoneWolfCheck();
	return;
}

function pnl_officers_chk_blue_one_OnChange(GUIComponent Sender)
{
	pnl_officer_blue_one.SetEnabled(pnl_officers_chk_blue_one.bChecked);
	SetLoneWolfCheck();
	return;
}

function pnl_officers_chk_blue_two_OnChange(GUIComponent Sender)
{
	pnl_officer_blue_two.SetEnabled(pnl_officers_chk_blue_two.bChecked);
	SetLoneWolfCheck();
	return;
}

private function SetLoneWolfCheck()
{
	if(bLoneWolfBeingChecked)
	{
		return;
	}
	chk_lone_wolf.bChecked = Not_PreBool(OrOr_BoolBool(OrOr_BoolBool(OrOr_BoolBool(pnl_officers_chk_red_one.bChecked, pnl_officers_chk_red_two.bChecked), pnl_officers_chk_blue_one.bChecked), pnl_officers_chk_blue_two.bChecked));
	return;
}

function PopulateFieldsFromScenario(bool NewScenario)
{
	local CustomScenario Scenario;

	Scenario = CustomScenarioPage.GetCustomScenario();
	if(NewScenario)
	{
		pnl_officer_red_one.cbo.List.find("Any");
		pnl_officers_chk_red_one.SetChecked(true);
		pnl_officer_red_two.cbo.List.find("Any");
		pnl_officers_chk_red_two.SetChecked(true);
		pnl_officer_blue_one.cbo.List.find("Any");
		pnl_officers_chk_blue_one.SetChecked(true);
		pnl_officer_blue_two.cbo.List.find("Any");
		pnl_officers_chk_blue_two.SetChecked(true);
	}
	else
	{
		chk_lone_wolf.SetChecked(Scenario.LoneWolf);
		if(Not_PreBool(Scenario.LoneWolf))
		{
			pnl_officer_red_one.cbo.List.find(string(Scenario.RedOneLoadOut));
			pnl_officers_chk_red_one.SetChecked(Scenario.HasOfficerRedOne);
			pnl_officer_red_two.cbo.List.find(string(Scenario.RedTwoLoadOut));
			pnl_officers_chk_red_two.SetChecked(Scenario.HasOfficerRedTwo);
			pnl_officer_blue_one.cbo.List.find(string(Scenario.BlueOneLoadOut));
			pnl_officers_chk_blue_one.SetChecked(Scenario.HasOfficerBlueOne);
			pnl_officer_blue_two.cbo.List.find(string(Scenario.BlueTwoLoadOut));
			pnl_officers_chk_blue_two.SetChecked(Scenario.HasOfficerBlueTwo);
		}
	}
	return;
}

function GatherScenarioFromFields()
{
	local CustomScenario Scenario;

	Scenario = CustomScenarioPage.GetCustomScenario();
	Scenario.LoneWolf = chk_lone_wolf.bChecked;
	Scenario.HasOfficerRedOne = pnl_officers_chk_red_one.bChecked;
	Scenario.RedOneLoadOut = string(pnl_officer_red_one.cbo.List.Get());
	Scenario.HasOfficerRedTwo = pnl_officers_chk_red_two.bChecked;
	Scenario.RedTwoLoadOut = string(pnl_officer_red_two.cbo.List.Get());
	Scenario.HasOfficerBlueOne = pnl_officers_chk_blue_one.bChecked;
	Scenario.BlueOneLoadOut = string(pnl_officer_blue_one.cbo.List.Get());
	Scenario.HasOfficerBlueTwo = pnl_officers_chk_blue_two.bChecked;
	Scenario.BlueTwoLoadOut = string(pnl_officer_blue_two.cbo.List.Get());
	return;
}
