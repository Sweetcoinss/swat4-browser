class Procedure_KillSuspects extends Procedure_NeutralizeSuspects implements IInterested_GameEvent_PawnDied, IInterested_GameEvent_PawnArrested, IInterested_GameEvent_PawnIncapacitated
	config(Leadership);

function PostInitHook()
{
	super.PostInitHook();
	GetGame().GameEvents.PawnDied.Register(self);
	GetGame().GameEvents.PawnArrested.Register(self);
	GetGame().GameEvents.PawnIncapacitated.Register(self);
	return;
}

function OnPawnDied(Pawn Pawn, Actor Killer, bool WasAThreat)
{
	if(Not_PreBool(Pawn.IsA('SwatEnemy')))
	{
		return;
	}
	Add(Pawn, NeutralizedEnemies);
	if(GetGame().DebugLeadership)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[LEADERSHIP] ", string(Class.Name)), " added "), string(Pawn.Name)), " to its list of NeutralizedEnemies because PawnDied."), " NeutralizedEnemies.length="), string(NeutralizedEnemies.Length)));
	}
	return;
}

function OnPawnArrested(Pawn Pawn, Pawn Arrester)
{
	if(Not_PreBool(Pawn.IsA('SwatEnemy')))
	{
		return;
	}
	AssertNotInArray(Pawn, NeutralizedEnemies, 'KilledEnemies');
	return;
}

function OnPawnIncapacitated(Pawn Pawn, Actor Incapacitator, bool WasAThreat)
{
	if(Not_PreBool(Pawn.IsA('SwatEnemy')))
	{
		return;
	}
	AssertNotInArray(Pawn, NeutralizedEnemies, 'KilledEnemies');
	return;
}
