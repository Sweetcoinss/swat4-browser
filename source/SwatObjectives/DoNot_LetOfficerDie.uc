class DoNot_LetOfficerDie extends Objective_DoNot implements IInterested_GameEvent_PawnIncapacitated
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
	if(AndAnd_BoolBool(Not_PreBool(Pawn.IsA('SwatOfficer')), Not_PreBool(Pawn.IsA('SwatPlayer'))))
	{
		return;
	}
	if(Game.DebugObjectives)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[OBJECTIVES] The ", string(Class.Name)), " Objective named "), string(Name)), " is setting its status to Failed because the Officer named "), string(Pawn.Name)), " died."));
	}
	SetStatus(2);
	return;
}
