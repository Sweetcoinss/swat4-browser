class Procedure_NoOfficerInjured extends Procedure implements IInterested_GameEvent_PawnDamaged
	config(Leadership);

var config int PenaltyPerOfficer;
var array<SwatOfficer> InjuredOfficers;

function PostInitHook()
{
	super.PostInitHook();
	GetGame().GameEvents.PawnDamaged.Register(self);
	return;
}

function OnPawnDamaged(Pawn Pawn, Actor Damager)
{
	if(AndAnd_BoolBool(Not_PreBool(Pawn.IsA('SwatOfficer')), Not_PreBool(Pawn.IsA('SwatPlayer'))))
	{
		return;
	}
	if(AndAnd_BoolBool(Pawn.IsA('SwatPlayer'), EqualEqual_ObjectObject(Pawn, Damager)))
	{
		return;
	}
	if(Not_PreBool(Damager.IsA('SwatPlayer')))
	{
		if(GetGame().DebugLeadership)
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[LEADERSHIP] ", string(Class.Name)), "::OnPawnDamaged() did *not* add "), string(Pawn.Name)), " to its list of InjuredOfficers because Damager was not the local player."));
		}
		return;
	}
	Add(Pawn, InjuredOfficers);
	if(GetGame().DebugLeadership)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[LEADERSHIP] ", string(Class.Name)), " added "), string(Pawn.Name)), " to its list of InjuredOfficers because PawnDamaged, Damager="), string(Damager)), ". InjuredOfficers.length="), string(InjuredOfficers.Length)));
	}
	return;
}

function string Status()
{
	return string(InjuredOfficers.Length);
	return;
}

function int GetCurrentValue()
{
	if(GetGame().DebugLeadershipStatus)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[LEADERSHIP] ", string(Class.Name)), " is returning CurrentValue = PenaltyPerOfficer * InjuredOfficers.length\n"), "                           = "), string(PenaltyPerOfficer)), " * "), string(InjuredOfficers.Length)), "\n"), "                           = "), string(Multiply_IntInt(PenaltyPerOfficer, InjuredOfficers.Length))));
	}
	return Multiply_IntInt(PenaltyPerOfficer, InjuredOfficers.Length);
	return;
}
