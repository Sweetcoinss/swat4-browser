class AnimNotify_TriggerAISpeech extends AnimNotify_Scripted
	editinlinenew
	collapsecategories
	hidecategories(Object);

var name SpeechEffectEvent;
var bool ClearEventQueue;

event Notify(Actor Owner)
{
	local bool bEffectEventExists;

	assert(NotEqual_ObjectObject(Owner, none));
	if(Owner.IsA('SwatAI'))
	{
		bEffectEventExists = Owner.TriggerEffectEvent(SpeechEffectEvent,,,,,, true);
		if(bEffectEventExists)
		{
			SwatAI(Owner).GetSpeechManagerAction().TriggerSpeech(SpeechEffectEvent, ClearEventQueue);
		}
		else
		{
			Warn(Concat_StrStr(Concat_StrStr("AnimNotify_TriggerAISpeech - attempt to trigger effect event (", string(SpeechEffectEvent)), ") failed because the effects system has no response available"));
		}
	}
	return;
}
