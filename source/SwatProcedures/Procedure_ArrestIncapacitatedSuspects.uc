class Procedure_ArrestIncapacitatedSuspects extends Procedure_ArrestSuspects implements IInterested_GameEvent_PawnIncapacitated
	config(Leadership);

function OnPawnIncapacitated(Pawn Pawn, Actor Incapacitator, bool WasAThreat)
{
	super.OnPawnIncapacitated(Pawn, Incapacitator, WasAThreat);
	if(Not_PreBool(Pawn.IsA('SwatEnemy')))
	{
		return;
	}
	Add(Pawn, NeutralizedEnemies);
	if(GetGame().DebugLeadership)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[LEADERSHIP] ", string(Class.Name)), " added "), string(Pawn.Name)), " to its list of NeutralizedEnemies because PawnIncapacitated."), " NeutralizedEnemies.length="), string(IncapacitatedEnemies.Length)));
	}
	return;
}
