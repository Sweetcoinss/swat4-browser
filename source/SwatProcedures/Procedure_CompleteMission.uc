class Procedure_CompleteMission extends Procedure implements IInterested_GameEvent_MissionCompleted
	config(Leadership);

var config int Bonus;
var int CurrentValue;

function PostInitHook()
{
	super.PostInitHook();
	GetGame().GameEvents.MissionCompleted.Register(self);
	return;
}

function OnMissionCompleted()
{
	Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[LEADERSHIP] ", string(Class.Name)), " is setting CurrentValue = Bonus = "), string(Bonus)), " because MissionCompleted."));
	CurrentValue = Bonus;
	return;
}

function int GetCurrentValue()
{
	if(GetGame().DebugLeadershipStatus)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("[LEADERSHIP] ", string(Class.Name)), " is returning CurrentValue = "), string(CurrentValue)));
	}
	return CurrentValue;
	return;
}
