class DoNot_LetHostageDie extends Objective_DoNot implements IInterested_GameEvent_PawnDied
	config(ObjectiveSpecs)
	perobjectconfig;

function Initialize()
{
	super(Objective).Initialize();
	Game.GameEvents.PawnDied.Register(self);
	return;
}

function UnRegisterGameEventsHook()
{
	Game.GameEvents.PawnDied.UnRegister(self);
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
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[OBJECTIVES] The ", string(Class.Name)), " Objective named "), string(Name)), " is setting its status to Failed because the Hostage named "), string(Pawn.Name)), " died."));
	}
	SetStatus(2);
	return;
}
