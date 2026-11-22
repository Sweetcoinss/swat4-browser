class DoNot_LetHostageGetIncapacitated extends Objective_DoNot implements IInterested_GameEvent_PawnIncapacitated
	config(ObjectiveSpecs)
	perobjectconfig;

function Initialize()
{
	super(Objective).Initialize();
	Game.GameEvents.PawnIncapacitated.Register(self);
	return;
}

function UnRegisterGameEventsHook()
{
	Game.GameEvents.PawnIncapacitated.UnRegister(self);
	return;
}

function OnPawnIncapacitated(Pawn Pawn, Actor Incapacitator, bool WasAThreat)
{
	if(Not_PreBool(Pawn.IsA('SwatHostage')))
	{
		return;
	}
	if(Game.DebugObjectives)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[OBJECTIVES] The ", string(Class.Name)), " Objective named "), string(Name)), " is setting its status to Failed because the Hostage named "), string(Pawn.Name)), " was incapacitated."));
	}
	SetStatus(2);
	return;
}
