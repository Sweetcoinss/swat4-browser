class DoNot_LetOfficerGetInjured extends Objective_DoNot implements IInterested_GameEvent_PawnDamaged
	config(ObjectiveSpecs)
	perobjectconfig;

function Initialize()
{
	super(Objective).Initialize();
	Game.GameEvents.PawnDamaged.Register(self);
	return;
}

function UnRegisterGameEventsHook()
{
	Game.GameEvents.PawnDamaged.UnRegister(self);
	return;
}

function OnPawnDamaged(Pawn Pawn, Actor Damager)
{
	if(AndAnd_BoolBool(Not_PreBool(Pawn.IsA('SwatOfficer')), Not_PreBool(Pawn.IsA('SwatPlayer'))))
	{
		return;
	}
	if(Game.DebugObjectives)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[OBJECTIVES] The ", string(Class.Name)), " Objective named "), string(Name)), " is setting its status to Failed because the Officer named "), string(Pawn.Name)), " was damaged."));
	}
	SetStatus(2);
	return;
}
