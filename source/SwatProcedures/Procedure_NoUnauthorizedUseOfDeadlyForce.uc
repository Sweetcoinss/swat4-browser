class Procedure_NoUnauthorizedUseOfDeadlyForce extends Procedure implements IInterested_GameEvent_PawnDied
	config(Leadership);

var config int PenaltyPerEnemy;
var array<SwatEnemy> KilledEnemies;

function PostInitHook()
{
	super.PostInitHook();
	GetGame().GameEvents.PawnDied.Register(self);
	return;
}

function OnPawnDied(Pawn Pawn, Actor Killer, bool WasAThreat)
{
	if(Not_PreBool(Pawn.IsA('SwatEnemy')))
	{
		return;
	}
	if(WasAThreat)
	{
		if(GetGame().DebugLeadership)
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[LEADERSHIP] ", string(Class.Name)), "::OnPawnDied() did *not* add "), string(Pawn.Name)), " to its list of KilledEnemies because the SwatEnemy was a threat (so the deadly force was authorized)."));
		}
		return;
	}
	if(Not_PreBool(Killer.IsA('SwatPlayer')))
	{
		if(GetGame().DebugLeadership)
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[LEADERSHIP] ", string(Class.Name)), "::OnPawnDied() did *not* add "), string(Pawn.Name)), " to its list of KilledEnemies because Killer ("), string(Killer)), ") was not the local player."));
		}
		return;
	}
	AssertNotInArray(Pawn, KilledEnemies, 'KilledEnemies');
	Add(Pawn, KilledEnemies);
	if(GetGame().DebugLeadership)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[LEADERSHIP] ", string(Class.Name)), " added "), string(Pawn.Name)), " to its list of KilledEnemies because PawnDied, Killer="), string(Killer)), ". KilledEnemies.length="), string(KilledEnemies.Length)));
	}
	return;
}

function string Status()
{
	return string(KilledEnemies.Length);
	return;
}

function int GetCurrentValue()
{
	if(GetGame().DebugLeadershipStatus)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[LEADERSHIP] ", string(Class.Name)), " is returning CurrentValue = PenaltyPerEnemy * KilledEnemies.length\n"), "                           = "), string(PenaltyPerEnemy)), " * "), string(KilledEnemies.Length)), "\n"), "                           = "), string(Multiply_IntInt(PenaltyPerEnemy, KilledEnemies.Length))));
	}
	return Multiply_IntInt(PenaltyPerEnemy, KilledEnemies.Length);
	return;
}
