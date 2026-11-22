class Procedure_PlayerUninjured extends Procedure implements IInterested_GameEvent_PawnDamaged
	config(Leadership);

var config int Bonus;
var array<SwatPawn> InjuredPlayers;

function PostInitHook()
{
	super.PostInitHook();
	GetGame().GameEvents.PawnDamaged.Register(self);
	return;
}

function OnPawnDamaged(Pawn Pawn, Actor Damager)
{
	if(Not_PreBool(Pawn.IsA('SwatPlayer')))
	{
		return;
	}
	Add(Pawn, InjuredPlayers);
	if(GetGame().DebugLeadership)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[LEADERSHIP] ", string(Class.Name)), " added "), string(Pawn.Name)), " to its list of InjuredPlayers because it was injured."), " InjuredPlayers.length="), string(InjuredPlayers.Length)));
	}
	return;
}

function int GetCurrentValue()
{
	local float Modifier;
	local int total, NumPlayers;

	NumPlayers = GetNumActors(Class'SwatGame.SwatPlayer');
	Modifier = Divide_FloatFloat(float(Subtract_IntInt(NumPlayers, InjuredPlayers.Length)), float(NumPlayers));
	total = int(Multiply_FloatFloat(float(Bonus), Modifier));
	if(GetGame().DebugLeadershipStatus)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[LEADERSHIP] ", string(Class.Name)), " Bonus = "), string(Bonus)), ", NumPlayers = "), string(NumPlayers)), ", InjuredPlayers.length = "), string(InjuredPlayers.Length)), " Modifier = ( (NumPlayers-InjuredPlayers.length)/NumPlayers ) = "), string(Modifier)), " ... returning CurrentValue = Bonus * Modifier = "), string(total)));
	}
	return total;
	return;
}

function string Status()
{
	local int NumSwatPlayers;

	NumSwatPlayers = GetNumActors(Class'SwatGame.SwatPlayer');
	return Concat_StrStr(Concat_StrStr(string(Subtract_IntInt(NumSwatPlayers, InjuredPlayers.Length)), "/"), string(NumSwatPlayers));
	return;
}
