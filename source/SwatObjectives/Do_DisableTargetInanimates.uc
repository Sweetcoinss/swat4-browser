class Do_DisableTargetInanimates extends Objective_Do implements IInterested_GameEvent_GameStarted, IInterested_GameEvent_InanimateDisabled
	config(ObjectiveSpecs)
	perobjectconfig;

var config name SpawnerGroup;
var array<ICanBeDisabled> Targets;

function Initialize()
{
	super(Objective).Initialize();
	Game.GameEvents.GameStarted.Register(self);
	Game.GameEvents.InanimateDisabled.Register(self);
	SwatRepo(Game.Level.GetRepo()).MissionObjectives.AddMissionObjectiveSpawnerGroup(self, SpawnerGroup);
	return;
}

function UnRegisterGameEventsHook()
{
	Game.GameEvents.GameStarted.UnRegister(self);
	Game.GameEvents.InanimateDisabled.UnRegister(self);
	return;
}

function OnGameStarted()
{
	local ICanBeDisabled Current;

	foreach Game.DynamicActors(Class'SwatGame.ICanBeDisabled', Current)
	{
		if(AndAnd_BoolBool(Current.IsA('ICanBeSpawned'), EqualEqual_NameName(ICanBeSpawned(Current).GetSpawner().SpawnedFromGroup(), SpawnerGroup)))
		{
			if(Game.DebugObjectives)
			{
				Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[OBJECTIVES] The ", string(Class.Name)), " Objective named "), string(Name)), " is adding "), string(Current.Name)), " from SpawnerGroup "), string(SpawnerGroup)), " to its list of Targets."));
			}
			Targets[Targets.Length] = Current;
		}
	}
	AssertWithDescription(Greater_IntInt(Targets.Length, 0), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] The ", string(Class.Name)), " named "), string(Name)), " can't be completed because it doesn't have any Targets.  Check that the SpawnerGroup specified in the Objective ("), string(SpawnerGroup)), ") matches a SpawnerGroup specified in the SpawningManager's Roster."));
	return;
}

function OnInanimateDisabled(ICanBeDisabled Disabled, Pawn Disabler)
{
	RemoveTarget(Disabled, 'InanimateDisabled');
	Game.dispatchMessage(Class'SwatObjectives.MessageTargetInanimateDisabled'.static.Allocate(self)., construct_NameNameInt(Name, Disabler.Label, Targets.Length));
	return;
}

private function RemoveTarget(ICanBeDisabled Disabled, name DebugWhy)
{
	local int i;
	local bool Found;

	i = 0;
	J0x07:

	if(Less_IntInt(i, Targets.Length))
	{
		if(EqualEqual_ObjectObject(Targets[i], Disabled))
		{
			Found = true;
			if(Game.DebugObjectives)
			{
				Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[OBJECTIVES] The ", string(Class.Name)), " Objective named "), string(Name)), " is removing "), string(Targets[i].Name)), " from its list of Targets because "), string(DebugWhy)), ".  Number of remaining Targets: "), string(Subtract_IntInt(Targets.Length, 1))));
			}
			Targets.Remove(i, 1);
			// [Explicit Break]
			goto J0x12D;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	J0x12D:

	if(EqualEqual_IntInt(Targets.Length, 0))
	{
		SetStatus(1);
	}
	if(AndAnd_BoolBool(Game.DebugObjectives, Not_PreBool(Found)))
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[OBJECTIVES] The ", string(Class.Name)), " Objective named "), string(Name)), " was called to RemoveTarget("), string(Disabled.Name)), ") from its list of Targets because "), string(DebugWhy)), ", but that wasn't found in its list of Targets."));
	}
	return;
}
