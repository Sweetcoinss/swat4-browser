class Procedure_NoOfficerIncapacitated extends Procedure implements IInterested_GameEvent_PawnIncapacitated, IInterested_GameEvent_PawnDied
	config(Leadership);

var config int PenaltyPerOfficer;
var array<SwatOfficer> IncapacitatedOfficers;

function PostInitHook()
{
	super.PostInitHook();
	GetGame().GameEvents.PawnIncapacitated.Register(self);
	GetGame().GameEvents.PawnDied.Register(self);
	return;
}

function OnPawnDied(Pawn Pawn, Actor Killer, bool WasAThreat)
{
	if(Not_PreBool(Pawn.IsA('SwatPlayer')))
	{
		return;
	}
	OnOfficerIncapacitated(Pawn, Killer);
	return;
}

function OnPawnIncapacitated(Pawn Pawn, Actor Incapacitator, bool WasAThreat)
{
	if(Not_PreBool(Pawn.IsA('SwatOfficer')))
	{
		return;
	}
	OnOfficerIncapacitated(Pawn, Incapacitator);
	return;
}

function OnOfficerIncapacitated(Pawn Pawn, Actor Incapacitator)
{
	if(Not_PreBool(Incapacitator.IsA('SwatPlayer')))
	{
		if(GetGame().DebugLeadership)
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[LEADERSHIP] ", string(Class.Name)), "::OnOfficerIncapacitated() did *not* add "), string(Pawn.Name)), " to its list of IncapacitatedOfficers because Incapacitator was not the local player."));
		}
		return;
	}
	AssertNotInArray(Pawn, IncapacitatedOfficers, 'IncapacitatedOfficers');
	Add(Pawn, IncapacitatedOfficers);
	if(GetGame().DebugLeadership)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[LEADERSHIP] ", string(Class.Name)), " added "), string(Pawn.Name)), " to its list of IncapacitatedOfficers because PawnIncapacitated, Incapacitator="), string(Incapacitator)), ". IncapacitatedOfficers.length="), string(IncapacitatedOfficers.Length)));
	}
	return;
}

function string Status()
{
	return string(IncapacitatedOfficers.Length);
	return;
}

function int GetCurrentValue()
{
	if(GetGame().DebugLeadershipStatus)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[LEADERSHIP] ", string(Class.Name)), " is returning CurrentValue = PenaltyPerOfficer * IncapacitatedOfficers.length\n"), "                           = "), string(PenaltyPerOfficer)), " * "), string(IncapacitatedOfficers.Length)), "\n"), "                           = "), string(Multiply_IntInt(PenaltyPerOfficer, IncapacitatedOfficers.Length))));
	}
	return Multiply_IntInt(PenaltyPerOfficer, IncapacitatedOfficers.Length);
	return;
}
