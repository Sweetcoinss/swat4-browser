class Procedure_NoCiviliansInjured extends Procedure implements IInterested_GameEvent_PawnDamaged, IInterested_GameEvent_MissionCompleted
	config(Leadership);

var config int Bonus;
var bool AnyoneDamaged;
var bool MissionCompleted;

function PostInitHook()
{
	super.PostInitHook();
	GetGame().GameEvents.PawnDamaged.Register(self);
	GetGame().GameEvents.MissionCompleted.Register(self);
	return;
}

function OnPawnDamaged(Pawn Pawn, Actor Damager)
{
	if(Not_PreBool(Pawn.IsA('SwatHostage')))
	{
		return;
	}
	if(GetGame().DebugLeadership)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[LEADERSHIP] ", string(Class.Name)), " is setting AnyoneDamaged=true because PawnDamaged, Pawn="), string(Pawn.Name)), ", Damager="), string(Damager.Name)), "."));
	}
	AnyoneDamaged = true;
	return;
}

function OnMissionCompleted()
{
	MissionCompleted = true;
	return;
}

function int GetCurrentValue()
{
	if(AndAnd_BoolBool(MissionCompleted, Not_PreBool(AnyoneDamaged)))
	{
		if(GetGame().DebugLeadershipStatus)
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[LEADERSHIP] ", string(Class.Name)), " is returning CurrentValue = Bonus = "), string(Bonus)), " because MissionCompleted && !AnyoneDamaged."));
		}
		return Bonus;
	}
	else
	{
		if(GetGame().DebugLeadershipStatus)
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[LEADERSHIP] ", string(Class.Name)), " is returning CurrentValue = 0"), " because MissionCompleted="), string(MissionCompleted)), ", AnyoneDamaged="), string(AnyoneDamaged)));
		}
		return 0;
	}
	return;
}
