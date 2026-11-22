class ColoredSquadInfo extends OfficerTeamInfo
	native
	config(AI)
	hidecategories(Karma);

var private Timer NeedOrdersTimer;
var private config float NeedOrdersTriggerTimeDelta;

event Destroyed()
{
	super.Destroyed();
	DestroyNeedOrdersTimer();
	return;
}

private function DestroyNeedOrdersTimer()
{
	if(NotEqual_ObjectObject(NeedOrdersTimer, none))
	{
		NeedOrdersTimer.__TimerDelegate__Delegate = None;
		NeedOrdersTimer.Destroy();
	}
	return;
}

protected function UnpostCommandGoals()
{
	ClearCommandGoal();
	SwatAIRepo.GetElementSquad().RemoveCommandGoalsFor(self);
	return;
}

function bool IsSubElement()
{
	return true;
	return;
}

function TriggerNeedOrdersSpeech()
{
	if(NotEqual_ObjectObject(NeedOrdersTimer, none))
	{
		NeedOrdersTimer.Destroy();
	}
	NeedOrdersTimer = Spawn(Class'Engine.Timer', self);
	NeedOrdersTimer.__TimerDelegate__Delegate = InternalTriggerNeedOrdersSpeech;
	NeedOrdersTimer.StartTimer(NeedOrdersTriggerTimeDelta, false);
	return;
}

function InternalTriggerNeedOrdersSpeech()
{
	local int i;
	local Pawn Officer;

	if(Not_PreBool(IsExecutingCommandGoal()))
	{
		i = 0;
		J0x12:

		if(Less_IntInt(i, pawns.Length))
		{
			Officer = pawns[i];
			if(Class'Engine.Pawn'.static.checkConscious(Officer))
			{
				TriggerSquadSpecificNeedOrdersSpeech(Officer);
				// [Explicit Break]
				goto J0x62;
			}
			AddAdd_PreInt(i);
			// [Loop Continue]
			goto J0x12;
		}
	}
	J0x62:

	DestroyNeedOrdersTimer();
	return;
}

protected function TriggerSquadSpecificNeedOrdersSpeech(Pawn OfficerSpeaker)
{
	return;
}
