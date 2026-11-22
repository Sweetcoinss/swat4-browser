class Do_ArrestTargetEnemies extends Objective_Do implements IInterested_GameEvent_GameStarted, IInterested_GameEvent_PawnDied, IInterested_GameEvent_PawnIncapacitated, IInterested_GameEvent_PawnArrested
	config(ObjectiveSpecs)
	perobjectconfig;

var config name SpawnerGroup;
var array<SwatEnemy> Targets;

function Initialize()
{
	super(Objective).Initialize();
	Game.GameEvents.GameStarted.Register(self);
	Game.GameEvents.PawnDied.Register(self);
	Game.GameEvents.PawnIncapacitated.Register(self);
	Game.GameEvents.PawnArrested.Register(self);
	SwatRepo(Game.Level.GetRepo()).MissionObjectives.AddMissionObjectiveSpawnerGroup(self, SpawnerGroup);
	return;
}

function UnRegisterGameEventsHook()
{
	Game.GameEvents.GameStarted.UnRegister(self);
	Game.GameEvents.PawnDied.UnRegister(self);
	Game.GameEvents.PawnIncapacitated.UnRegister(self);
	Game.GameEvents.PawnArrested.UnRegister(self);
	return;
}

function OnGameStarted()
{
	local SwatEnemy Current;

	foreach Game.DynamicActors(Class'SwatGame.SwatEnemy', Current)
	{
		if(EqualEqual_NameName(Current.GetSpawner().SpawnedFromGroup(), SpawnerGroup))
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

function OnPawnDied(Pawn Pawn, Actor Killer, bool WasAThreat)
{
	if(Not_PreBool(Pawn.IsA('SwatEnemy')))
	{
		return;
	}
	if(NotEqual_NameName(ICanBeSpawned(Pawn).GetSpawner().SpawnedFromGroup(), SpawnerGroup))
	{
		return;
	}
	RemoveTarget(Pawn, 'PawnDied');
	SetStatus(2);
	return;
}

function OnPawnIncapacitated(Pawn Pawn, Actor Incapacitator, bool WasAThreat)
{
	if(Not_PreBool(Pawn.IsA('SwatEnemy')))
	{
		return;
	}
	if(RemoveTarget(Pawn, 'PawnIncapacitated'))
	{
		SetStatus(1);
	}
	return;
}

function OnPawnArrested(Pawn Pawn, Pawn Arrester)
{
	if(Not_PreBool(Pawn.IsA('SwatEnemy')))
	{
		return;
	}
	if(RemoveTarget(Pawn, 'PawnArrested'))
	{
		SetStatus(1);
	}
	return;
}

private function bool RemoveTarget(Pawn Pawn, name DebugWhy)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, Targets.Length))
	{
		if(EqualEqual_ObjectObject(Targets[i], Pawn))
		{
			if(Game.DebugObjectives)
			{
				Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[OBJECTIVES] The ", string(Class.Name)), " Objective named "), string(Name)), " is removing "), string(Targets[i].Name)), " from its list of Targets because "), string(DebugWhy)), ".  Number of remaining Targets: "), string(Subtract_IntInt(Targets.Length, 1))));
			}
			Targets.Remove(i, 1);
			return EqualEqual_IntInt(Targets.Length, 0);
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	if(Game.DebugObjectives)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[OBJECTIVES] The ", string(Class.Name)), " Objective named "), string(Name)), " was called to RemoveTarget("), string(Pawn.Name)), ") because "), string(DebugWhy)), ", but "), string(Pawn.Name)), " is not in its list of Targets."));
	}
	if(Game.DebugObjectives)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[OBJECTIVES] The ", string(Class.Name)), " Objective named "), string(Name)), " was called to RemoveTarget("), string(Pawn.Name)), ") because "), string(DebugWhy)), ", but "), string(Pawn.Name)), " is not in its list of Targets."));
	}
	return;
}
