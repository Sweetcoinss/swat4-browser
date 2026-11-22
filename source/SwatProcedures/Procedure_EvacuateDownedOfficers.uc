class Procedure_EvacuateDownedOfficers extends Procedure implements IInterested_GameEvent_PawnIncapacitated, IInterested_GameEvent_PawnDied, IInterested_GameEvent_ReportableReportedToTOC
	config(Leadership);

var config int PenaltyPerDownedOfficer;
var array<SwatPawn> UnevacuatedDownedOfficers;

function PostInitHook()
{
	super.PostInitHook();
	GetGame().GameEvents.PawnIncapacitated.Register(self);
	GetGame().GameEvents.PawnDied.Register(self);
	GetGame().GameEvents.ReportableReportedToTOC.Register(self);
	return;
}

function OnPawnIncapacitated(Pawn Pawn, Actor Incapacitator, bool WasAThreat)
{
	if(Not_PreBool(Pawn.IsA('SwatOfficer')))
	{
		return;
	}
	AssertNotInArray(Pawn, UnevacuatedDownedOfficers, 'UnevacuatedDownedOfficers');
	Add(Pawn, UnevacuatedDownedOfficers);
	return;
}

function OnPawnDied(Pawn Pawn, Actor Killer, bool WasAThreat)
{
	if(Not_PreBool(Pawn.IsA('SwatPlayer')))
	{
		return;
	}
	AssertNotInArray(Pawn, UnevacuatedDownedOfficers, 'UnevacuatedDownedOfficers');
	Add(Pawn, UnevacuatedDownedOfficers);
	return;
}

function OnReportableReportedToTOC(IAmReportableCharacter ReportedCharacter, Pawn Reporter)
{
	if(AndAnd_BoolBool(Not_PreBool(ReportedCharacter.IsA('SwatOfficer')), Not_PreBool(ReportedCharacter.IsA('SwatPlayer'))))
	{
		return;
	}
	AssertWithDescription(IsInArray(SwatPawn(ReportedCharacter), UnevacuatedDownedOfficers), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[LEADERSHIP] ", string(Class.Name)), " Character "), string(ReportedCharacter.Name)), " was reported to TOC but was not in the UnevacuatedDownedOfficers array"));
	if(GetGame().DebugLeadership)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[LEADERSHIP] ", string(Class.Name)), " removed "), string(ReportedCharacter.Name)), " from the list of UnevacuatedDownedOfficers because ReportableReportedToTOC"), ". UnevacuatedDownedOfficers.length="), string(UnevacuatedDownedOfficers.Length)));
	}
	Remove(SwatPawn(ReportedCharacter), UnevacuatedDownedOfficers);
	return;
}

function bool AnyPlayersAlive()
{
	local SwatPlayer Player;

	foreach GetGame().AllActors(Class'SwatGame.SwatPlayer', Player)
	{
		if(Player.isAlive())
		{
			return true;
		}
	}
	return false;
	return;
}

function string Status()
{
	local int ReportableDownedOfficers;

	ReportableDownedOfficers = UnevacuatedDownedOfficers.Length;
	if(Not_PreBool(AnyPlayersAlive()))
	{
		SubtractSubtract_Int(ReportableDownedOfficers);
	}
	return string(ReportableDownedOfficers);
	return;
}

function int GetCurrentValue()
{
	local int ReportableDownedOfficers;

	ReportableDownedOfficers = UnevacuatedDownedOfficers.Length;
	if(Not_PreBool(AnyPlayersAlive()))
	{
		SubtractSubtract_Int(ReportableDownedOfficers);
	}
	if(GetGame().DebugLeadershipStatus)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[LEADERSHIP] ", string(Class.Name)), " is returning CurrentValue = PenaltyPerDownedOfficer * ReportableDownedOfficers\n"), "                           = "), string(PenaltyPerDownedOfficer)), " * "), string(ReportableDownedOfficers)), "\n"), "                           = "), string(Multiply_IntInt(PenaltyPerDownedOfficer, ReportableDownedOfficers))));
	}
	return Multiply_IntInt(PenaltyPerDownedOfficer, ReportableDownedOfficers);
	return;
}
