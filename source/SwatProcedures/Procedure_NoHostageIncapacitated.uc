class Procedure_NoHostageIncapacitated extends Procedure implements IInterested_GameEvent_PawnDied, IInterested_GameEvent_PawnIncapacitated
	config(Leadership);

var config int PenaltyPerHostage;
var array<SwatHostage> IncapacitatedHostages;

function PostInitHook()
{
	super.PostInitHook();
	GetGame().GameEvents.PawnDied.Register(self);
	GetGame().GameEvents.PawnIncapacitated.Register(self);
	return;
}

function OnPawnDied(Pawn Pawn, Actor Killer, bool WasAThreat)
{
	if(Not_PreBool(Pawn.IsA('SwatHostage')))
	{
		return;
	}
	if(AndAnd_BoolBool(GetGame().DebugLeadership, IsInArray(Pawn, IncapacitatedHostages)))
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[LEADERSHIP] ", string(Class.Name)), " removed "), string(Pawn.Name)), " from its list of IncapacitatedHostages because PawnDied."));
	}
	Remove(Pawn, IncapacitatedHostages);
	return;
}

function OnPawnIncapacitated(Pawn Pawn, Actor Incapacitator, bool WasAThreat)
{
	if(Not_PreBool(Pawn.IsA('SwatHostage')))
	{
		return;
	}
	if(Not_PreBool(Incapacitator.IsA('SwatPlayer')))
	{
		if(GetGame().DebugLeadership)
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[LEADERSHIP] ", string(Class.Name)), "::OnPawnIncapacitated() did *not* add "), string(Pawn.Name)), " to its list of IncapacitatedHostages because Incapacitator was not the local player."));
		}
		return;
	}
	AssertNotInArray(Pawn, IncapacitatedHostages, 'IncapacitatedHostages');
	Add(Pawn, IncapacitatedHostages);
	if(GetGame().DebugLeadership)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[LEADERSHIP] ", string(Class.Name)), " added "), string(Pawn.Name)), " to its list of IncapacitatedHostages because PawnIncapacitated, Incapacitator="), string(Incapacitator)), ". IncapacitatedHostages.length="), string(IncapacitatedHostages.Length)));
	}
	return;
}

function string Status()
{
	return string(IncapacitatedHostages.Length);
	return;
}

function int GetCurrentValue()
{
	if(GetGame().DebugLeadershipStatus)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[LEADERSHIP] ", string(Class.Name)), " is returning CurrentValue = PenaltyPerHostage * IncapacitatedHostages.length\n"), "                           = "), string(PenaltyPerHostage)), " * "), string(IncapacitatedHostages.Length)), "\n"), "                           = "), string(Multiply_IntInt(PenaltyPerHostage, IncapacitatedHostages.Length))));
	}
	return Multiply_IntInt(PenaltyPerHostage, IncapacitatedHostages.Length);
	return;
}
