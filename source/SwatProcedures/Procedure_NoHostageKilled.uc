class Procedure_NoHostageKilled extends Procedure implements IInterested_GameEvent_PawnDied
	config(Leadership);

var config int PenaltyPerHostage;
var array<SwatHostage> KilledHostages;

function PostInitHook()
{
	super.PostInitHook();
	GetGame().GameEvents.PawnDied.Register(self);
	return;
}

function OnPawnDied(Pawn Pawn, Actor Killer, bool WasAThreat)
{
	if(Not_PreBool(Pawn.IsA('SwatHostage')))
	{
		return;
	}
	if(Not_PreBool(Killer.IsA('SwatPlayer')))
	{
		if(GetGame().DebugLeadership)
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[LEADERSHIP] ", string(Class.Name)), "::OnPawnDied() did *not* add "), string(Pawn.Name)), " to its list of KilledHostages because Killer was not the local player."));
		}
		return;
	}
	AssertNotInArray(Pawn, KilledHostages, 'KilledHostages');
	Add(Pawn, KilledHostages);
	if(GetGame().DebugLeadership)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[LEADERSHIP] ", string(Class.Name)), " added "), string(Pawn.Name)), " to its list of KilledHostages because PawnDied, Killer="), string(Killer)), ". KilledHostages.length="), string(KilledHostages.Length)));
	}
	return;
}

function string Status()
{
	return string(KilledHostages.Length);
	return;
}

function int GetCurrentValue()
{
	if(GetGame().DebugLeadershipStatus)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[LEADERSHIP] ", string(Class.Name)), " is returning CurrentValue = PenaltyPerHostage * KilledHostages.length\n"), "                           = "), string(PenaltyPerHostage)), " * "), string(KilledHostages.Length)), "\n"), "                           = "), string(Multiply_IntInt(PenaltyPerHostage, KilledHostages.Length))));
	}
	return Multiply_IntInt(PenaltyPerHostage, KilledHostages.Length);
	return;
}
