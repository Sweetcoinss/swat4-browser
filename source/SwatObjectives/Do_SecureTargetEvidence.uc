class Do_SecureTargetEvidence extends Objective_Do implements IInterested_GameEvent_GameStarted, IInterested_GameEvent_EvidenceSecured
	config(ObjectiveSpecs)
	perobjectconfig;

var config name SpawnerGroup;
var array<IEvidence> Targets;

function Initialize()
{
	super(Objective).Initialize();
	Game.GameEvents.GameStarted.Register(self);
	Game.GameEvents.EvidenceSecured.Register(self);
	SwatRepo(Game.Level.GetRepo()).MissionObjectives.AddMissionObjectiveSpawnerGroup(self, SpawnerGroup);
	return;
}

function UnRegisterGameEventsHook()
{
	Game.GameEvents.GameStarted.UnRegister(self);
	Game.GameEvents.EvidenceSecured.UnRegister(self);
	return;
}

function OnGameStarted()
{
	local IEvidence Current;

	foreach Game.DynamicActors(Class'Engine.IEvidence', Current)
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

function OnEvidenceSecured(IEvidence Secured)
{
	RemoveTarget(Secured, 'EvidenceSecured');
	return;
}

private function RemoveTarget(IEvidence Secured, name DebugWhy)
{
	local int i;
	local bool Found;

	i = 0;
	J0x07:

	if(Less_IntInt(i, Targets.Length))
	{
		if(EqualEqual_ObjectObject(Targets[i], Secured))
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

	if(AndAnd_BoolBool(Found, EqualEqual_IntInt(Targets.Length, 0)))
	{
		SetStatus(1);
	}
	if(AndAnd_BoolBool(Game.DebugObjectives, Not_PreBool(Found)))
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[OBJECTIVES] The ", string(Class.Name)), " Objective named "), string(Name)), " was called to RemoveTarget("), string(Secured.Name)), ") from its list of Targets because "), string(DebugWhy)), ", but that wasn't found in its list of Targets."));
	}
	return;
}
