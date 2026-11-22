class Procedure_ArrestSuspects extends Procedure_NeutralizeSuspects implements IInterested_GameEvent_PawnDied, IInterested_GameEvent_PawnIncapacitated
	abstract
	config(Leadership);

var array<SwatEnemy> IncapacitatedEnemies;

function PostInitHook()
{
	super.PostInitHook();
	GetGame().GameEvents.PawnDied.Register(self);
	GetGame().GameEvents.PawnIncapacitated.Register(self);
	return;
}

function OnPawnDied(Pawn Pawn, Actor Killer, bool WasAThreat)
{
	if(Not_PreBool(Pawn.IsA('SwatEnemy')))
	{
		return;
	}
	Remove(Pawn, IncapacitatedEnemies);
	if(GetGame().DebugLeadership)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[LEADERSHIP] ", string(Class.Name)), " removed "), string(Pawn.Name)), " from its list of IncapacitatedEnemies because PawnDied."), " IncapacitatedEnemies.length="), string(IncapacitatedEnemies.Length)));
	}
	Remove(Pawn, NeutralizedEnemies);
	if(GetGame().DebugLeadership)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[LEADERSHIP] ", string(Class.Name)), " removed "), string(Pawn.Name)), " from its list of NeutralizedEnemies because PawnDied."), " NeutralizedEnemies.length="), string(NeutralizedEnemies.Length)));
	}
	return;
}

function OnPawnIncapacitated(Pawn Pawn, Actor Incapacitator, bool WasAThreat)
{
	if(Not_PreBool(Pawn.IsA('SwatEnemy')))
	{
		return;
	}
	Add(Pawn, IncapacitatedEnemies);
	if(GetGame().DebugLeadership)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[LEADERSHIP] ", string(Class.Name)), " added "), string(Pawn.Name)), " to its list of IncapacitatedEnemies because PawnIncapacitated."), " IncapacitatedEnemies.length="), string(IncapacitatedEnemies.Length)));
	}
	return;
}
