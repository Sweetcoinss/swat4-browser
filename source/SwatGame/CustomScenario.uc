class CustomScenario extends Object
	config
	perobjectconfig;

struct IntegerRangeCow
{
	var config int Max;
	var config int Min;
};

var string ScenarioName;
var string PackName;
var config name LevelLabel;
var config string Difficulty;
var config bool UseCampaignObjectives;
var config array<name> ScenarioObjectives;
var config bool SpecifyStartPoint;
var config bool UseSecondaryStartPoint;
var config float TimeLimit;
var config bool LoneWolf;
var config bool HasOfficerRedOne;
var config name RedOneLoadOut;
var config bool HasOfficerRedTwo;
var config name RedTwoLoadOut;
var config bool HasOfficerBlueOne;
var config name BlueOneLoadOut;
var config bool HasOfficerBlueTwo;
var config name BlueTwoLoadOut;
var config bool UseCampaignHostageSettings;
var config array<name> HostageArchetypes;
var config IntegerRangeCow HostageCountRangeCow;
var config Range HostageMorale;
var config bool UseCampaignEnemySettings;
var config array<name> EnemyArchetypes;
var config IntegerRangeCow EnemyCountRangeCow;
var config Range EnemyMorale;
var config array<string> EnemyPrimaryWeaponOptions;
var config string EnemyPrimaryWeaponType;
var config string EnemyPrimaryWeaponSpecific;
var config array<string> EnemyBackupWeaponOptions;
var config string EnemyBackupWeaponType;
var config string EnemyBackupWeaponSpecific;
var config string EnemySkill;
var config localized string Notes;

function MutateLevelRosters(SpawningManager SpawningManager, out array<Roster> Rosters)
{
	local EnemyRoster EnemyRoster;
	local HostageRoster HostageRoster;
	local ChanceArchetypePair ChanceArchetypePair;
	local CustomScenarioCreatorMissionSpecificData MissionData;
	local int CampaignEnemies, CampaignHostages;
	local bool DeleteRoster;
	local int i;

	i = Subtract_IntInt(Rosters.Length, 1);
	J0x0F:

	if(GreaterEqual_IntInt(i, 0))
	{
		DeleteRoster = true;
		if(AndAnd_BoolBool(SpawningManager.IsMissionObjective(Rosters[i].SpawnerGroup), UseCampaignObjectives))
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[CUSTOM SCENARIO] Keeping Roster index ", string(i)), " with SpawnerGroup="), string(Rosters[i].SpawnerGroup)), " because IsMissionObjective && UseCampaignObjectives."));
			DeleteRoster = false;
		}
		else
		{
			if(AndAnd_BoolBool(Rosters[i].IsA('EnemyRoster'), UseCampaignEnemySettings))
			{
				Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[CUSTOM SCENARIO] Keeping Roster index ", string(i)), " with SpawnerGroup="), string(Rosters[i].SpawnerGroup)), " because IsA('EnemyRoster') && UseCampaignEnemySettings."));
				DeleteRoster = false;
			}
			else
			{
				if(AndAnd_BoolBool(Rosters[i].IsA('HostageRoster'), UseCampaignHostageSettings))
				{
					Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[CUSTOM SCENARIO] Keeping Roster index ", string(i)), " with SpawnerGroup="), string(Rosters[i].SpawnerGroup)), " because IsA('HostageRoster') && UseCampaignHostageSettings."));
					DeleteRoster = false;
				}
			}
		}
		if(DeleteRoster)
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[CUSTOM SCENARIO] Deleting Roster index ", string(i)), " with SpawnerGroup="), string(Rosters[i].SpawnerGroup)), ".  No reason to justify keeping it: UseCampaignObjectives="), string(UseCampaignObjectives)), ", Rosters[i].SpawnerGroup="), string(Rosters[i].SpawnerGroup)), ", IsMissionObjective()="), string(SpawningManager.IsMissionObjective(Rosters[i].SpawnerGroup))));
			Rosters.Remove(i, 1);
		}
		SubtractSubtract_PreInt(i);
		// [Loop Continue]
		goto J0x0F;
	}
	if(UseCampaignObjectives)
	{
		MissionData = Class'SwatGame.CustomScenarioCreatorMissionSpecificData'.static.Allocate(self, none, string(LevelLabel)).;
		Construct_Void();
		assert(NotEqual_ObjectObject(MissionData, none));
		CampaignEnemies = MissionData.CampaignObjectiveEnemySpawn.Length;
		CampaignHostages = MissionData.CampaignObjectiveHostageSpawn.Length;
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[CUSTOM SCENARIO] Specifies ", string(EnemyCountRangeCow.Min)), " to "), string(EnemyCountRangeCow.Max)), " Enemies and "), string(HostageCountRangeCow.Min)), " to "), string(HostageCountRangeCow.Max)), " Hostages, including "), string(CampaignEnemies)), " Campaign Enemies and "), string(CampaignHostages)), " Campaign Hostages."));
	}
	else
	{
		CampaignEnemies = 0;
		CampaignHostages = 0;
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[CUSTOM SCENARIO] Specifies ", string(EnemyCountRangeCow.Min)), " to "), string(EnemyCountRangeCow.Max)), " Enemies and "), string(HostageCountRangeCow.Min)), " to "), string(HostageCountRangeCow.Max)), " Hostages."));
	}
	AssertWithDescription(AndAnd_BoolBool(GreaterEqual_IntInt(CampaignEnemies, 0), GreaterEqual_IntInt(CampaignHostages, 0)), Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] CustomScenario::MutateLevelRosters() CampaignEnemies=", string(CampaignEnemies)), ", CampaignHostages="), string(CampaignHostages)));
	if(Not_PreBool(UseCampaignEnemySettings))
	{
		EnemyRoster = Class'SwatGame.EnemyRoster'.static.Allocate(self, none, "CustomScenarioEnemyRoster").;
		Construct_Void();
		i = 0;
		J0x683:

		if(Less_IntInt(i, EnemyArchetypes.Length))
		{
			ChanceArchetypePair.Archetype = EnemyArchetypes[i];
			ChanceArchetypePair.Chance = Divide_IntInt(100, EnemyArchetypes.Length);
			EnemyRoster.Archetypes[i] = ChanceArchetypePair;
			AddAdd_PreInt(i);
			// [Loop Continue]
			goto J0x683;
		}
		EnemyRoster.Count.Min = Subtract_IntInt(EnemyCountRangeCow.Min, CampaignEnemies);
		EnemyRoster.Count.Max = Subtract_IntInt(EnemyCountRangeCow.Max, CampaignEnemies);
		EnemyRoster.SpawnerGroup = 'CustomRosterSpawnerGroup';
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("[CUSTOM SCENARIO] Adding Custom Enemy Roster, Count.Min=", string(EnemyRoster.Count.Min)), ", Count.Max="), string(EnemyRoster.Count.Max)));
		Rosters[Rosters.Length] = EnemyRoster;
	}
	if(Not_PreBool(UseCampaignHostageSettings))
	{
		HostageRoster = Class'SwatGame.HostageRoster'.static.Allocate(self, none, "CustomScenarioHostageRoster").;
		Construct_Void();
		i = 0;
		J0x81D:

		if(Less_IntInt(i, HostageArchetypes.Length))
		{
			ChanceArchetypePair.Archetype = HostageArchetypes[i];
			ChanceArchetypePair.Chance = Divide_IntInt(100, HostageArchetypes.Length);
			HostageRoster.Archetypes[i] = ChanceArchetypePair;
			AddAdd_PreInt(i);
			// [Loop Continue]
			goto J0x81D;
		}
		HostageRoster.Count.Min = Subtract_IntInt(HostageCountRangeCow.Min, CampaignHostages);
		HostageRoster.Count.Max = Subtract_IntInt(HostageCountRangeCow.Max, CampaignHostages);
		HostageRoster.SpawnerGroup = 'CustomRosterSpawnerGroup';
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("[CUSTOM SCENARIO] Adding Custom Hostage Roster, Count.Min=", string(HostageRoster.Count.Min)), ", Count.Max="), string(HostageRoster.Count.Max)));
		Rosters[Rosters.Length] = HostageRoster;
	}
	return;
}

function MutateMissionObjectives(MissionObjectives MissionObjectives)
{
	local int i, j;
	local bool dupe, Found;
	local MissionObjectives CustomMissionObjectives;
	local Automatic_DoNot_Die DoNotDieObjective;
	local DoNot_LetTimerExpire TimedMissionObjective;

	CustomMissionObjectives = Class'SwatGame.MissionObjectives'.static.Allocate(self, MissionObjectives.Outer, "CustomScenario").;
	Construct_Void();
	assert(NotEqual_ObjectObject(CustomMissionObjectives, none));
	if(Not_PreBool(UseCampaignObjectives))
	{
		MissionObjectives.Objectives.Remove(0, MissionObjectives.Objectives.Length);
		DoNotDieObjective = Automatic_DoNot_Die(MissionObjectives.AddObjective(Class'SwatGame.Automatic_DoNot_Die', 'Automatic_DoNot_Die'));
		assert(NotEqual_ObjectObject(DoNotDieObjective, none));
	}
	i = 0;
	J0xAA:

	if(Less_IntInt(i, ScenarioObjectives.Length))
	{
		dupe = false;
		j = 0;
		J0xC9:

		if(Less_IntInt(j, MissionObjectives.Objectives.Length))
		{
			if(EqualEqual_NameName(ScenarioObjectives[i], MissionObjectives.Objectives[j].Name))
			{
				dupe = true;
				// [Explicit Break]
				goto J0x124;
			}
			AddAdd_PreInt(j);
			// [Loop Continue]
			goto J0xC9;
		}
		J0x124:

		if(dupe)
		{
			// [Explicit Break]
			goto J0x3E0;
		}
		Found = false;
		j = 0;
		J0x13F:

		if(Less_IntInt(j, CustomMissionObjectives.Objectives.Length))
		{
			if(EqualEqual_NameName(ScenarioObjectives[i], CustomMissionObjectives.Objectives[j].Name))
			{
				Found = true;
				MissionObjectives.AddObjective(CustomMissionObjectives.Objectives[j].Class, CustomMissionObjectives.Objectives[j].Name);
				// [Explicit Break]
				goto J0x1E3;
			}
			AddAdd_PreInt(j);
			// [Loop Continue]
			goto J0x13F;
		}
		J0x1E3:

		AssertWithDescription(Found, Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] CustomScenario::MutateMissionObjectives() Tried to add the ScenarioObjectives named ", string(ScenarioObjectives[i])), " to the list of MissionObjectives.  But an Objective by that name was not found in the list of "), "CustomMissionObjectives (the Objectives available for Custom Scenarios).  "), "** IMPORTANT ** Custom Scenarios made with older builds may _not_ be compatible with newer builds.  "), "Please DO NOT file a bug about this unless you created this Custom Scenario with this build."));
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0xAA;
	}
	J0x3E0:

	if(Greater_FloatFloat(TimeLimit, float(0)))
	{
		TimedMissionObjective = DoNot_LetTimerExpire(MissionObjectives.AddObjective(Class'SwatGame.DoNot_LetTimerExpire', 'Custom_Timed'));
		assert(NotEqual_ObjectObject(TimedMissionObjective, none));
		TimedMissionObjective.Time = TimeLimit;
	}
	if(AndAnd_BoolBool(EqualEqual_IntInt(MissionObjectives.Objectives.Length, 1), EqualEqual_NameName(MissionObjectives.Objectives[0].Name, 'Automatic_DoNot_Die')))
	{
		MissionObjectives.Objectives[0].IsHidden = false;
	}
	return;
}

function MutateArchetype(Archetype Archetype)
{
	local EnemyArchetype EnemyArchetype;
	local EnemySkillChancePair CurrentSkill;

	if(AndAnd_BoolBool(Archetype.IsA('EnemyArchetype'), Not_PreBool(UseCampaignEnemySettings)))
	{
		EnemyArchetype = EnemyArchetype(Archetype);
		EnemyArchetype.Morale = EnemyMorale;
		EnemyArchetype.Skill.Remove(0, EnemyArchetype.Skill.Length);
		CurrentSkill.Chance = 10;
		if(OrOr_BoolBool(EqualEqual_StrStr(EnemySkill, "Low"), EqualEqual_StrStr(EnemySkill, "Any")))
		{
			CurrentSkill.Skill = 0;
			EnemyArchetype.Skill[EnemyArchetype.Skill.Length] = CurrentSkill;
		}
		if(OrOr_BoolBool(EqualEqual_StrStr(EnemySkill, "Medium"), EqualEqual_StrStr(EnemySkill, "Any")))
		{
			CurrentSkill.Skill = 1;
			EnemyArchetype.Skill[EnemyArchetype.Skill.Length] = CurrentSkill;
		}
		if(OrOr_BoolBool(EqualEqual_StrStr(EnemySkill, "High"), EqualEqual_StrStr(EnemySkill, "Any")))
		{
			CurrentSkill.Skill = 2;
			EnemyArchetype.Skill[EnemyArchetype.Skill.Length] = CurrentSkill;
		}
	}
	else
	{
		if(AndAnd_BoolBool(Archetype.IsA('HostageArchetype'), Not_PreBool(UseCampaignHostageSettings)))
		{
			HostageArchetype(Archetype).Morale = HostageMorale;
		}
	}
	return;
}

function MutateEnemyWeapons(out array<WeaponClipcountChanceSet> ArchetypeWeapons, array<string> ScenarioWeapons)
{
	local WeaponClipcountChanceSet ArchetypeWeapon;
	local int i;

	ArchetypeWeapons.Remove(0, ArchetypeWeapons.Length);
	i = 0;
	J0x14:

	if(Less_IntInt(i, ScenarioWeapons.Length))
	{
		ArchetypeWeapon.Weapon = ScenarioWeapons[i];
		ArchetypeWeapon.Chance = 10;
		ArchetypeWeapons[i] = ArchetypeWeapon;
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x14;
	}
	return;
}
