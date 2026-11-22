class CustomScenario_MissionTabPanel extends CustomScenarioTabPanel
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

var(SwatGui) export editinline config GUIComboBox cbo_mission;
var(SwatGui) private export editinline config GUICheckBoxButton chk_campaign_objectives;
var(SwatGui) export editinline config GUIDualSelectionLists dlist_objectives;
var(SwatGui) private export editinline config GUILabel lbl_mission;
var(SwatGui) private export editinline config GUILabel lbl_spawn_point;
var(SwatGui) private export editinline config GUIRadioButton opt_primary;
var(SwatGui) private export editinline config GUILabel lbl_primary;
var(SwatGui) private export editinline config GUIRadioButton opt_either;
var(SwatGui) private export editinline config GUIRadioButton opt_secondary;
var(SwatGui) private export editinline config GUICheckBoxButton chk_time_limit;
var(SwatGui) private export editinline config GUILabel lbl_time_limit;
var(SwatGui) private export editinline config GUILabel lbl_no_limit;
var(SwatGui) private export editinline config GUILabel lbl_either;
var(SwatGui) private export editinline config GUILabel lbl_secondary;
var(SwatGui) private export editinline config GUILabel lbl_primary_detail;
var(SwatGui) private export editinline config GUILabel lbl_secondary_detail;
var(SwatGui) private export editinline config GUINumericEdit time_limit;
var(SwatGui) private export editinline config GUIComboBox cbo_difficulty;
var MissionObjectives CustomMissionObjectives;

function InitComponent(GUIComponent MyOwner)
{
	local int i;

	super(SwatGUIPanel).InitComponent(MyOwner);
	data = CustomScenarioPage.CustomScenarioCreatorData;
	chk_time_limit.__OnChange__Delegate = chk_time_limit_OnChange;
	chk_campaign_objectives.__OnChange__Delegate = chk_campaign_objectives_OnChange;
	cbo_mission.__OnChange__Delegate = cbo_mission_OnListIndexChanged;
	i = 0;
	J0x62:

	if(Less_IntInt(i, GC.MissionName.Length))
	{
		cbo_mission.AddItem(string(GC.MissionName[i]),, GC.FriendlyName[i]);
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x62;
	}
	cbo_difficulty.AddItem("Any",, data.AnyString);
	cbo_difficulty.AddItem("Easy",, data.EasyString);
	cbo_difficulty.AddItem("Normal",, data.NormalString);
	cbo_difficulty.AddItem("Hard",, data.HardString);
	cbo_difficulty.AddItem("Elite",, data.EliteString);
	return;
}

function chk_time_limit_OnChange(GUIComponent Sender)
{
	time_limit.SetEnabled(Not_PreBool(chk_time_limit.bChecked));
	return;
}

function chk_campaign_objectives_OnChange(GUIComponent Sender)
{
	local CustomScenarioCreatorMissionSpecificData MissionData;

	MissionData = data.GetMissionData_Slow(string(cbo_mission.List.Get()));
	UpdateSpawnCounts(MissionData);
	return;
}

function cbo_mission_OnListIndexChanged(GUIComponent Sender)
{
	local CustomScenarioCreatorMissionSpecificData MissionData;

	MissionData = data.GetMissionData_Slow(string(cbo_mission.List.Get()));
	UpdateSpawnCounts(MissionData);
	AssertWithDescription(NotEqual_StrStr(MissionData.PrimarySpawnPoint, ""), "Error! There is no Primary Spawn point available for this Map!");
	lbl_primary_detail.SetCaption(MissionData.PrimarySpawnPoint);
	opt_primary.EnableComponent();
	if(NotEqual_StrStr(MissionData.SecondarySpawnPoint, ""))
	{
		lbl_secondary_detail.SetCaption(MissionData.SecondarySpawnPoint);
		opt_secondary.EnableComponent();
		opt_either.EnableComponent();
		opt_either.SelectRadioButton();
	}
	else
	{
		lbl_secondary_detail.SetCaption(data.UnavailableString);
		opt_secondary.DisableComponent();
		opt_either.DisableComponent();
		opt_primary.SelectRadioButton();
	}
	return;
}

function UpdateSpawnCounts(CustomScenarioCreatorMissionSpecificData MissionData)
{
	local int NumEnemies, NumHostages;

	NumEnemies = MissionData.CampaignObjectiveEnemySpawn.Length;
	if(AndAnd_BoolBool(chk_campaign_objectives.bChecked, Greater_IntInt(NumEnemies, 0)))
	{
		CustomScenarioPage.pnl_enemies_pnl_body_lbl_count.SetCaption(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(data.NumberOfEnemiesString, data.CommaIncludingString), " "), string(NumEnemies)), " "), data.CampaignObjectivesString));
		CustomScenarioPage.pnl_enemies_spin_count_min.SetMinValue(NumEnemies);
	}
	else
	{
		CustomScenarioPage.pnl_enemies_pnl_body_lbl_count.SetCaption(data.NumberOfEnemiesString);
		CustomScenarioPage.pnl_enemies_spin_count_min.SetMinValue(0);
	}
	CustomScenarioPage.pnl_enemies_spin_count_min.SetMaxValue(MissionData.EnemySpawners);
	CustomScenarioPage.pnl_enemies_spin_count_max.SetMaxValue(MissionData.EnemySpawners);
	NumHostages = MissionData.CampaignObjectiveHostageSpawn.Length;
	if(AndAnd_BoolBool(chk_campaign_objectives.bChecked, Greater_IntInt(NumHostages, 0)))
	{
		CustomScenarioPage.pnl_hostages_pnl_body_lbl_count.SetCaption(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(data.NumberOfHostagesString, data.CommaIncludingString), " "), string(MissionData.CampaignObjectiveHostageSpawn.Length)), " "), data.CampaignObjectivesString));
		CustomScenarioPage.pnl_hostages_spin_count_min.SetMinValue(NumHostages);
	}
	else
	{
		CustomScenarioPage.pnl_hostages_pnl_body_lbl_count.SetCaption(data.NumberOfHostagesString);
		CustomScenarioPage.pnl_hostages_spin_count_min.SetMinValue(0);
	}
	CustomScenarioPage.pnl_hostages_spin_count_min.SetMaxValue(MissionData.HostageSpawners);
	CustomScenarioPage.pnl_hostages_spin_count_max.SetMaxValue(MissionData.HostageSpawners);
	return;
}

function InitializeObjectives()
{
	local int i;

	if(EqualEqual_ObjectObject(CustomMissionObjectives, none))
	{
		CustomMissionObjectives = Class'SwatGame.MissionObjectives'.static.Allocate(self, none, "CustomScenario").;
		Construct_Void();
		assert(NotEqual_ObjectObject(CustomMissionObjectives, none));
	}
	dlist_objectives.ListBoxA.List.Clear();
	dlist_objectives.ListBoxB.List.Clear();
	i = 0;
	J0x91:

	if(Less_IntInt(i, CustomMissionObjectives.Objectives.Length))
	{
		if(NotEqual_NameName(CustomMissionObjectives.Objectives[i].Name, 'Automatic_DoNot_Die'))
		{
			dlist_objectives.ListBoxA.List.Add(string(CustomMissionObjectives.Objectives[i].Name),, CustomMissionObjectives.Objectives[i].Description);
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x91;
	}
	return;
}

function PopulateFieldsFromScenario(bool NewScenario)
{
	local int i;
	local CustomScenario Scenario;
	local string Found;

	Scenario = CustomScenarioPage.GetCustomScenario();
	cbo_mission.List.find(string(Scenario.LevelLabel), true);
	InitializeObjectives();
	chk_campaign_objectives.SetChecked(Scenario.UseCampaignObjectives);
	i = 0;
	J0x6A:

	if(Less_IntInt(i, Scenario.ScenarioObjectives.Length))
	{
		Found = dlist_objectives.ListBoxA.List.find(string(Scenario.ScenarioObjectives[i]));
		AssertWithDescription(NotEqual_StrStr(Found, ""), Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] CustomScenario_MissionTabPanel::PopulateFieldsFromScenario()", " Couldn't find selected Objective named "), string(Scenario.ScenarioObjectives[i])), " in dlist_objectives.ListBoxA."));
		dlist_objectives.MoveAB(none);
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x6A;
	}
	if(Not_PreBool(NewScenario))
	{
		if(Scenario.SpecifyStartPoint)
		{
			if(Scenario.UseSecondaryStartPoint)
			{
				opt_secondary.SelectRadioButton();
			}
			else
			{
				opt_primary.SelectRadioButton();
			}
		}
		else
		{
			opt_either.SelectRadioButton();
		}
	}
	if(NewScenario)
	{
		cbo_difficulty.setIndex(0);
	}
	else
	{
		cbo_difficulty.List.find(Scenario.Difficulty, true);
	}
	chk_time_limit.SetChecked(EqualEqual_FloatFloat(Scenario.TimeLimit, float(0)));
	if(Greater_FloatFloat(Scenario.TimeLimit, float(0)))
	{
		time_limit.SetValue(int(Scenario.TimeLimit), true);
	}
	else
	{
		time_limit.SetValue(int(data.DefaultTimeLimit), true);
	}
	return;
}

function GatherScenarioFromFields()
{
	local int i;
	local CustomScenario Scenario;

	Scenario = CustomScenarioPage.GetCustomScenario();
	Scenario.LevelLabel = string(cbo_mission.List.Get());
	Scenario.UseCampaignObjectives = chk_campaign_objectives.bChecked;
	Scenario.ScenarioObjectives.Remove(0, Scenario.ScenarioObjectives.Length);
	i = 0;
	J0x83:

	if(Less_IntInt(i, dlist_objectives.ListBoxB.List.Elements.Length))
	{
		Scenario.ScenarioObjectives[i] = string(dlist_objectives.ListBoxB.List.GetItemAtIndex(i));
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x83;
	}
	Scenario.Difficulty = cbo_difficulty.List.Get();
	Scenario.SpecifyStartPoint = Not_PreBool(opt_either.bChecked);
	if(Not_PreBool(opt_either.bChecked))
	{
		Scenario.UseSecondaryStartPoint = opt_secondary.bChecked;
	}
	if(chk_time_limit.bChecked)
	{
		Scenario.TimeLimit = 0.0000000;
	}
	else
	{
		Scenario.TimeLimit = float(time_limit.Value);
	}
	return;
}

event Activate()
{
	data.SetCurrentMissionDirty();
	super(GUIMultiComponent).Activate();
	return;
}
