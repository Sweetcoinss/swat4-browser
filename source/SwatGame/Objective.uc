class Objective extends Object implements IInterested_GameEvent_MissionEnded
	config(ObjectiveSpecs)
	perobjectconfig;

enum ObjectiveStatus
{
	ObjectiveStatus_InProgress,     // 0
	ObjectiveStatus_Completed,      // 1
	ObjectiveStatus_Failed          // 2
};

var config bool IsHidden;
var config bool UnhideIfFailed;
var config bool IsTerminal;
var config bool IsPrimaryObjective;
var config localized string Description;
var config float Time;
var config localized string TimerCaption;
var private Objective.ObjectiveStatus CurrentStatus;
var private Objective.ObjectiveStatus DefaultStatus;
var Objective.ObjectiveStatus EndgameStatus;
var SwatGameInfo Game;

final function InitializeObjective(SwatGameInfo GameInfo)
{
	Game = GameInfo;
	assert(NotEqual_ObjectObject(Game, none));
	Initialize();
	return;
}

function Initialize()
{
	Game.GameEvents.MissionEnded.Register(self);
	assert(Greater_IntInt(int(GetDefaultStatus()), int(0)));
	if(AndAnd_BoolBool(Greater_FloatFloat(Time, float(0)), Not_PreBool(IsHidden)))
	{
		StartTimer();
	}
	return;
}

function Objective.ObjectiveStatus GetStatus()
{
	return CurrentStatus;
	return;
}

protected function SetStatus(Objective.ObjectiveStatus newStatus)
{
	CurrentStatus = newStatus;
	switch(newStatus)
	{
		case 1:
			Game.OnMissionObjectiveCompleted(self);
			if(Greater_FloatFloat(Time, float(0)))
			{
				StopTimer();
			}
			break;
		case 2:
			Game.OnMissionObjectiveFailed(self);
			if(Greater_FloatFloat(Time, float(0)))
			{
				StopTimer();
			}
			if(UnhideIfFailed)
			{
				IsHidden = false;
			}
			break;
		case 0:
			AssertWithDescription(EqualEqual_IntInt(int(CurrentStatus), int(0)), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] The mission objective of class ", string(Class.Name)), " named "), string(Name)), " was set to status InProgress.  An Objective status should never be set to InProgress (they all start-out that way!)."));
		default:
			break;
	}
	return;
}

function Objective.ObjectiveStatus GetDefaultStatus()
{
	return default.DefaultStatus;
	return;
}

function string GetStatusString()
{
	return ObjectiveStatusToString(CurrentStatus);
	return;
}

private function string ObjectiveStatusToString(Objective.ObjectiveStatus Status)
{
	switch(Status)
	{
		case 0:
			return "In Progress";
		case 1:
			return "Completed";
		case 2:
			return "Failed";
		default:
			assert(false);
			return;
			break;
	}
}

function OnMissionEnded()
{
	if(EqualEqual_IntInt(int(CurrentStatus), int(0)))
	{
		if(Game.DebugObjectives)
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("[OBJECTIVES] OnMissionEnded(), ", string(Name)), " is going to its default status: "), string(GetEnum(Enum'SwatGame.Objective.ObjectiveStatus', int(DefaultStatus)))));
		}
		CurrentStatus = DefaultStatus;
	}
	if(Greater_FloatFloat(Time, float(0)))
	{
		StopTimer();
	}
	UnRegisterGameEventsHook();
	Game.GameEvents.MissionEnded.UnRegister(self);
	Game = none;
	return;
}

function UnRegisterGameEventsHook()
{
	return;
}

function SetVisibility(bool Visible)
{
	local name EffectEvent;

	if(NotEqual_BoolBool(Visible, IsHidden))
	{
		return;
	}
	if(AndAnd_BoolBool(IsHidden, Visible))
	{
		Game.Broadcast(Game, "", 'ObjectiveShown');
		if(Greater_FloatFloat(Time, float(0)))
		{
			StartTimer();
		}
	}
	IsHidden = Not_PreBool(Visible);
	if(Visible)
	{
		EffectEvent = 'ObjectiveShown';
	}
	else
	{
		EffectEvent = 'ObjectiveHidden';
	}
	Game.TriggerEffectEvent(EffectEvent,,,,,,,, Name);
	return;
}

function OnTimeExpired()
{
	SetStatus(2);
	return;
}

function StartTimer()
{
	Game.SetTimedMissionObjective(self);
	return;
}

function StopTimer()
{
	Game.ClearTimedMissionObjective();
	return;
}

defaultproperties
{
	IsPrimaryObjective=true
}