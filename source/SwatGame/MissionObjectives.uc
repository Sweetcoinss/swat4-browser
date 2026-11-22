class MissionObjectives extends Object
	config(MissionObjectives)
	perobjectconfig;

var editconst editinline config array<editinline name> ObjectiveName;
var editconst editinline config array<editinline string> ObjectiveClass;
var editconst editinline array<editinline Objective> Objectives;
var editconst editinline array<editinline name> MissionObjectiveSpawnerGroups;
var editconst editinline SwatGameInfo Game;

overloaded function Construct()
{
	local Class<Objective> CurrentClass;
	local int i;

	AssertWithDescription(EqualEqual_IntInt(ObjectiveName.Length, ObjectiveClass.Length), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] The list of ", string(Class.Name)), " for the level ["), string(Name)), "] has a different number of ObjectiveNames and ObjectiveClasses."), "  There should be one ObjectiveClass for every ObjectiveName and vice-versa."));
	AddObjective(Class'SwatGame.Automatic_DoNot_Die', 'Automatic_DoNot_Die');
	i = 0;
	J0x105:

	if(Less_IntInt(i, ObjectiveClass.Length))
	{
		CurrentClass = Class<Objective>(DynamicLoadObject(ObjectiveClass[i], Class'Core.Class'));
		AssertWithDescription(NotEqual_ObjectObject(CurrentClass, none), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] ObjectiveClass number ", string(Add_IntInt(i, 1))), " in the "), string(Class.Name)), " for level ["), string(Name)), "], specified as "), ObjectiveClass[i]), ", is not a valid Objective class."));
		AddObjective(CurrentClass, ObjectiveName[i]);
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x105;
	}
	return;
}

function Initialize(SwatGameInfo GameInfo)
{
	local int i;

	Game = GameInfo;
	assert(NotEqual_ObjectObject(Game, none));
	i = 0;
	J0x1D:

	if(Less_IntInt(i, Objectives.Length))
	{
		Objectives[i].InitializeObjective(Game);
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x1D;
	}
	return;
}

function Objective AddObjective(Class<Objective> CurrentClass, name CurrentName)
{
	local Objective CurrentObjective;

	CurrentObjective = CurrentClass.static.Allocate(self, none, string(CurrentName), 0).;
	Construct_Void();
	assert(NotEqual_ObjectObject(CurrentObjective, none));
	assert(CurrentObjective.IsA(CurrentClass.Name));
	Objectives[Objectives.Length] = CurrentObjective;
	return CurrentObjective;
	return;
}

function AddMissionObjectiveSpawnerGroup(Objective MissionObjective, name SpawnerGroup)
{
	local int i;

	Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("[OBJECTIVES] Adding Mission Objective SpawnerGroup: SpawnerGroup ", string(SpawnerGroup)), " for MissionObjective "), string(MissionObjective.Name)));
	i = 0;
	J0x81:

	if(Less_IntInt(i, Objectives.Length))
	{
		if(EqualEqual_ObjectObject(Objectives[i], MissionObjective))
		{
			MissionObjectiveSpawnerGroups[i] = SpawnerGroup;
			return;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x81;
	}
	assert(false);
	return;
}

function bool AnyVisibleObjectivesInProgress()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, Objectives.Length))
	{
		if(AndAnd_BoolBool(Not_PreBool(Objectives[i].IsHidden), EqualEqual_IntInt(int(Objectives[i].GetStatus()), int(0))))
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
