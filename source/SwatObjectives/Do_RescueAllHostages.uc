class Do_RescueAllHostages extends Objective_Do implements IInterested_GameEvent_MissionStarted, IInterested_GameEvent_PawnDied, IInterested_GameEvent_PawnIncapacitated, IInterested_GameEvent_PawnArrested
	config(ObjectiveSpecs)
	perobjectconfig;

function Initialize()
{
	super(Objective).Initialize();
	Game.GameEvents.MissionStarted.Register(self);
	Game.GameEvents.PawnDied.Register(self);
	Game.GameEvents.PawnIncapacitated.Register(self);
	Game.GameEvents.PawnArrested.Register(self);
	return;
}

function UnRegisterGameEventsHook()
{
	Game.GameEvents.MissionStarted.UnRegister(self);
	Game.GameEvents.PawnDied.UnRegister(self);
	Game.GameEvents.PawnIncapacitated.UnRegister(self);
	Game.GameEvents.PawnArrested.UnRegister(self);
	return;
}

function OnMissionStarted()
{
	CheckComplete('MissionStarted');
	return;
}

function OnPawnDied(Pawn Pawn, Actor Killer, bool WasAThreat)
{
	if(Not_PreBool(Pawn.IsA('SwatHostage')))
	{
		return;
	}
	if(Game.DebugObjectives)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[OBJECTIVES] The ", string(Class.Name)), " Objective named "), string(Name)), " is setting its status to Failed because the Hostage named "), string(Pawn.Name)), " died.  (If a Hostage dies, then you can't Do_RescueAllHostages.)"));
	}
	SetStatus(2);
	return;
}

function OnPawnIncapacitated(Pawn Pawn, Actor Incapacitator, bool WasAThreat)
{
	if(Not_PreBool(Pawn.IsA('SwatHostage')))
	{
		return;
	}
	if(SwatHostage(Pawn).WasHostageSpawnedIncapacitated())
	{
		return;
	}
	CheckComplete('PawnIncapacitated');
	return;
}

function OnPawnArrested(Pawn Pawn, Pawn Arrester)
{
	if(Not_PreBool(Pawn.IsA('SwatHostage')))
	{
		return;
	}
	CheckComplete('PawnArrested');
	return;
}

private function CheckComplete(name DebugWhy)
{
	local Pawn PawnIter;
	local SwatHostage CurrentHostage;

	if(Game.DebugObjectives)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[OBJECTIVES] The ", string(Class.Name)), " Objective named "), string(Name)), " was called to CheckComplete() because "), string(DebugWhy)), "..."));
	}
	PawnIter = Game.Level.PawnList;
	J0xAF:

	if(NotEqual_ObjectObject(PawnIter, none))
	{
		CurrentHostage = SwatHostage(PawnIter);
		if(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(CurrentHostage, none), Not_PreBool(CurrentHostage.IsArrested())), Not_PreBool(CurrentHostage.IsIncapacitated())))
		{
			if(AndAnd_BoolBool(Game.DebugObjectives, NotEqual_ObjectObject(CurrentHostage, none)))
			{
				Log(Concat_StrStr(Concat_StrStr("[OBJECTIVES] ... It is not yet complete because ", string(CurrentHostage)), " is not rescued (not arrested and not incapacitated)."));
			}
			return;
		}
		PawnIter = PawnIter.nextPawn;
		// [Loop Continue]
		goto J0xAF;
	}
	if(Game.DebugObjectives)
	{
		Log("[OBJECTIVES] ... It is complete because all hostages are rescued (arrested or incapacitated).");
	}
	SetStatus(1);
	return;
}
