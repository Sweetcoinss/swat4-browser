class Do_NeutralizeAllEnemies extends Objective_Do implements IInterested_GameEvent_MissionStarted, IInterested_GameEvent_PawnDied, IInterested_GameEvent_PawnIncapacitated, IInterested_GameEvent_PawnArrested
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
	if(Not_PreBool(Pawn.IsA('SwatEnemy')))
	{
		return;
	}
	CheckComplete('PawnDied');
	return;
}

function OnPawnIncapacitated(Pawn Pawn, Actor Incapacitator, bool WasAThreat)
{
	if(Not_PreBool(Pawn.IsA('SwatEnemy')))
	{
		return;
	}
	CheckComplete('PawnIncapacitated');
	return;
}

function OnPawnArrested(Pawn Pawn, Pawn Arrester)
{
	if(Not_PreBool(Pawn.IsA('SwatEnemy')))
	{
		return;
	}
	CheckComplete('PawnArrested');
	return;
}

private function CheckComplete(name DebugWhy)
{
	local Pawn PawnIter;
	local SwatEnemy CurrentEnemy;

	if(Game.DebugObjectives)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[OBJECTIVES] The ", string(Class.Name)), " Objective named "), string(Name)), " was called to CheckComplete() because "), string(DebugWhy)), "..."));
	}
	PawnIter = Game.Level.PawnList;
	J0xAF:

	if(NotEqual_ObjectObject(PawnIter, none))
	{
		CurrentEnemy = SwatEnemy(PawnIter);
		if(AndAnd_BoolBool(NotEqual_ObjectObject(CurrentEnemy, none), Not_PreBool(CurrentEnemy.IsNeutralized())))
		{
			if(AndAnd_BoolBool(Game.DebugObjectives, NotEqual_ObjectObject(CurrentEnemy, none)))
			{
				Log(Concat_StrStr(Concat_StrStr("[OBJECTIVES] ... It is not yet complete because ", string(CurrentEnemy)), " is not neutralized."));
			}
			return;
		}
		PawnIter = PawnIter.nextPawn;
		// [Loop Continue]
		goto J0xAF;
	}
	if(Game.DebugObjectives)
	{
		Log("[OBJECTIVES] ... It is complete because all enemies are neutralized.");
	}
	SetStatus(1);
	return;
}
