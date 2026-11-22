class Procedure_NoOfficersDown extends Procedure implements IInterested_GameEvent_PawnIncapacitated, IInterested_GameEvent_PawnDied
	config(Leadership);

var config int Bonus;
var array<SwatPawn> DownedOfficers;

function PostInitHook()
{
	super.PostInitHook();
	GetGame().GameEvents.PawnIncapacitated.Register(self);
	GetGame().GameEvents.PawnDied.Register(self);
	return;
}

function OnPawnIncapacitated(Pawn Pawn, Actor Incapacitator, bool WasAThreat)
{
	if(Not_PreBool(Pawn.IsA('SwatOfficer')))
	{
		return;
	}
	AssertNotInArray(Pawn, DownedOfficers, 'DownedOfficers');
	Add(Pawn, DownedOfficers);
	return;
}

function OnPawnDied(Pawn Pawn, Actor Killer, bool WasAThreat)
{
	if(Not_PreBool(Pawn.IsA('SwatPlayer')))
	{
		return;
	}
	AssertNotInArray(Pawn, DownedOfficers, 'DownedOfficers');
	Add(Pawn, DownedOfficers);
	return;
}

function int GetCurrentValue()
{
	local float Modifier;
	local int total, NumOfficers;

	NumOfficers = Add_IntInt(GetNumActors(Class'SwatGame.SwatPlayer'), GetNumActors(Class'SwatGame.SwatOfficer'));
	Modifier = Divide_FloatFloat(float(Subtract_IntInt(NumOfficers, DownedOfficers.Length)), float(NumOfficers));
	total = int(Multiply_FloatFloat(float(Bonus), Modifier));
	return total;
	return;
}

function string Status()
{
	return Concat_StrStr(Concat_StrStr(string(DownedOfficers.Length), "/"), string(Add_IntInt(GetNumActors(Class'SwatGame.SwatPlayer'), GetNumActors(Class'SwatGame.SwatOfficer'))));
	return;
}
