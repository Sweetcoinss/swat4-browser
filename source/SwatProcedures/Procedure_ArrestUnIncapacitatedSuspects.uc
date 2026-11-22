class Procedure_ArrestUnIncapacitatedSuspects extends Procedure_ArrestSuspects implements IInterested_GameEvent_PawnArrested, IInterested_GameEvent_PawnIncapacitated
	config(Leadership);

function PostInitHook()
{
	super.PostInitHook();
	GetGame().GameEvents.PawnArrested.Register(self);
	return;
}

function OnPawnArrested(Pawn Pawn, Pawn Arrester)
{
	if(Not_PreBool(Pawn.IsA('SwatEnemy')))
	{
		return;
	}
	if(Not_PreBool(IsInArray(Pawn, IncapacitatedEnemies)))
	{
		Add(Pawn, NeutralizedEnemies);
		if(GetGame().DebugLeadership)
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[LEADERSHIP] ", string(Class.Name)), " added "), string(Pawn.Name)), " to its list of NeutralizedEnemies because PawnArrested (and was not previously Incapacitated)."), " NeutralizedEnemies.length="), string(NeutralizedEnemies.Length)));
		}
	}
	return;
}

function OnPawnIncapacitated(Pawn Pawn, Actor Incapacitator, bool WasAThreat)
{
	super.OnPawnIncapacitated(Pawn, Incapacitator, WasAThreat);
	if(Not_PreBool(Pawn.IsA('SwatEnemy')))
	{
		return;
	}
	Remove(Pawn, NeutralizedEnemies);
	if(GetGame().DebugLeadership)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[LEADERSHIP] ", string(Class.Name)), " removed "), string(Pawn.Name)), " from its list of NeutralizedEnemies because PawnDied."), " NeutralizedEnemies.length="), string(NeutralizedEnemies.Length)));
	}
	return;
}

function int AdditionalBonus()
{
	if(EqualEqual_IntInt(TotalEnemies, 0))
	{
		return TotalBonus;
	}
	return super(Procedure_NeutralizeSuspects).AdditionalBonus();
	return;
}
