class Procedure_NoSuspectsIncapacitated extends Procedure implements IInterested_GameEvent_PawnIncapacitated, IInterested_GameEvent_MissionCompleted
	config(Leadership);

var config int Bonus;
var bool AnyoneIncapacitated;
var bool MissionCompleted;

function PostInitHook()
{
	super.PostInitHook();
	GetGame().GameEvents.PawnIncapacitated.Register(self);
	GetGame().GameEvents.MissionCompleted.Register(self);
	return;
}

function OnPawnIncapacitated(Pawn Pawn, Actor Incapacitator, bool WasAThreat)
{
	if(Not_PreBool(Pawn.IsA('SwatEnemy')))
	{
		return;
	}
	if(GetGame().DebugLeadership)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[LEADERSHIP] ", string(Class.Name)), " is setting AnyoneIncapacitated=true because PawnIncapacitated, Pawn="), string(Pawn.Name)), ", Incapacitator="), string(Incapacitator)), "."));
	}
	AnyoneIncapacitated = true;
	return;
}

function OnMissionCompleted()
{
	MissionCompleted = true;
	return;
}

function int GetCurrentValue()
{
	if(AndAnd_BoolBool(MissionCompleted, Not_PreBool(AnyoneIncapacitated)))
	{
		if(GetGame().DebugLeadershipStatus)
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[LEADERSHIP] ", string(Class.Name)), " is returning CurrentValue = Bonus = "), string(Bonus)), " because MissionCompleted && !AnyoneIncapacitated."));
		}
		return Bonus;
	}
	else
	{
		if(GetGame().DebugLeadershipStatus)
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[LEADERSHIP] ", string(Class.Name)), " is returning CurrentValue = 0"), " because MissionCompleted="), string(MissionCompleted)), ", AnyoneIncapacitated="), string(AnyoneIncapacitated)));
		}
		return 0;
	}
	return;
}
