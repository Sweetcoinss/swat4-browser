class Procedure_NoUnauthorizedUseOfForce extends Procedure implements IInterested_GameEvent_PawnDied, IInterested_GameEvent_PawnIncapacitated
	config(Leadership);

var config int PenaltyPerEnemy;
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
	if(AndAnd_BoolBool(GetGame().DebugLeadership, IsInArray(Pawn, IncapacitatedEnemies)))
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[LEADERSHIP] ", string(Class.Name)), " removed "), string(Pawn.Name)), " from its list of IncapacitatedEnemies because PawnDied."));
	}
	Remove(Pawn, IncapacitatedEnemies);
	return;
}

function OnPawnIncapacitated(Pawn Pawn, Actor Incapacitator, bool WasAThreat)
{
	if(Not_PreBool(Pawn.IsA('SwatEnemy')))
	{
		return;
	}
	if(WasAThreat)
	{
		if(GetGame().DebugLeadership)
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[LEADERSHIP] ", string(Class.Name)), "::OnPawnIncapacitated() did *not* add "), string(Pawn.Name)), " to its list of IncapacitatedEnemies because the SwatEnemy was a threat (so the force was authorized)."));
		}
		return;
	}
	if(Not_PreBool(Incapacitator.IsA('SwatPlayer')))
	{
		if(GetGame().DebugLeadership)
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[LEADERSHIP] ", string(Class.Name)), "::OnPawnDied() did *not* add "), string(Pawn.Name)), " to its list of KilledEnemies because Incapacitator was not the local player."));
		}
		return;
	}
	AssertNotInArray(Pawn, IncapacitatedEnemies, 'IncapacitatedEnemies');
	Add(Pawn, IncapacitatedEnemies);
	if(GetGame().DebugLeadership)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[LEADERSHIP] ", string(Class.Name)), " added "), string(Pawn.Name)), " to its list of IncapacitatedEnemies because PawnIncapacitated, Incapacitator="), string(Incapacitator)), ". IncapacitatedEnemies.length="), string(IncapacitatedEnemies.Length)));
	}
	return;
}

function string Status()
{
	return string(IncapacitatedEnemies.Length);
	return;
}

function int GetCurrentValue()
{
	if(GetGame().DebugLeadershipStatus)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[LEADERSHIP] ", string(Class.Name)), " is returning CurrentValue = PenaltyPerEnemy * IncapacitatedEnemies.length\n"), "                           = "), string(PenaltyPerEnemy)), " * "), string(IncapacitatedEnemies.Length)), "\n"), "                           = "), string(Multiply_IntInt(PenaltyPerEnemy, IncapacitatedEnemies.Length))));
	}
	return Multiply_IntInt(PenaltyPerEnemy, IncapacitatedEnemies.Length);
	return;
}
