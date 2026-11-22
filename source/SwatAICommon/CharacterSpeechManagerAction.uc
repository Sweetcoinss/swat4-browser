class CharacterSpeechManagerAction extends SwatCharacterAction
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

var array<name> EventQueue;
var private bool bInterrupted;

function TriggerSpeech(name SpeechEffectEvent, optional bool bClearEventQueue)
{
	assert(NotEqual_NameName(SpeechEffectEvent, 'None'));
	if(bClearEventQueue)
	{
		ClearEventQueue();
	}
	EventQueue[EventQueue.Length] = SpeechEffectEvent;
	if(IsIdle())
	{
		runAction();
	}
	return;
}

private function DebugTriggerSpeech(name SpeechEffectEvent, bool bClearEventQueue)
{
	local int i;

	Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(m_pawn.Name), " DebugTriggerSpeech - SpeechEffectEvent: "), string(SpeechEffectEvent)), " bClearEventQueue: "), string(bClearEventQueue)));
	i = 0;
	J0x70:

	if(Less_IntInt(i, EventQueue.Length))
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("EventQueue[", string(i)), "] is: "), string(EventQueue[i])));
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x70;
	}
	return;
}

private function ClearEventQueue()
{
	EventQueue.Remove(0, EventQueue.Length);
	bInterrupted = true;
	if(Not_PreBool(IsIdle()))
	{
		m_pawn.StopWaiting();
	}
	return;
}

function TriggerCompliantSpeech()
{
	TriggerSpeech('AnnouncedCompliant', true);
	return;
}

function TriggerRestrainedSpeech()
{
	TriggerSpeech('AnnouncedRestrained', true);
	return;
}

function TriggerHitByDoorSpeech()
{
	TriggerSpeech('ReactedHitByDoor', true);
	return;
}

function TriggerIncapacitatedSpeech()
{
	TriggerSpeech('ReactedDown', true);
	return;
}

function TriggerDiedSpeech()
{
	TriggerSpeech('Died', true);
	return;
}

function TriggerNormalInjuredSpeech()
{
	TriggerSpeech('ReactedInjuryNormal', true);
	return;
}

function TriggerIntenseInjuredSpeech()
{
	TriggerSpeech('ReactedInjuryIntense', true);
	return;
}

function TriggerGassedSpeech()
{
	TriggerSpeech('ReactedGas', true);
	return;
}

function TriggerFlashbangedSpeech()
{
	TriggerSpeech('ReactedBang', true);
	return;
}

function TriggerPepperSprayedSpeech()
{
	TriggerSpeech('ReactedPepper', true);
	return;
}

function TriggerTasedSpeech()
{
	TriggerSpeech('ReactedTaser', true);
	return;
}

function TriggerStunnedByC2Speech()
{
	TriggerSpeech('ReactedBreach', true);
	return;
}

function TriggerStingSpeech()
{
	TriggerSpeech('ReactedSting', true);
	return;
}

function TriggerBeanBagSpeech()
{
	TriggerSpeech('ReactedBeanBag', true);
	return;
}

function TriggerScreamSpeech()
{
	TriggerSpeech('Screamed', true);
	return;
}

state Running
{Begin:

	if(m_pawn.logTyrion)
	{
		Log(Concat_StrStr(Concat_StrStr(string(Name), " started at time "), string(Level.TimeSeconds)));
	}
	if(EqualEqual_IntInt(EventQueue.Length, 0))
	{
		Pause();
	}
	J0x54:

	if(Greater_IntInt(EventQueue.Length, 0))
	{
		bInterrupted = false;
		ISwatAI(m_pawn).LatentAITriggerEffectEvent(EventQueue[0],,,,,, true);
		if(Not_PreBool(bInterrupted))
		{
			EventQueue.Remove(0, 1);
		}
		// [Loop Continue]
		goto J0x54;
	}
	goto 'Begin';
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.SpeechManagerGoal'
}