class HostageSpeechManagerAction extends CharacterSpeechManagerAction
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

var config array<name> InDangerSpeechEffectEvents;

function TriggerUncompliantSpeech()
{
	TriggerSpeech('AnnouncedNonCompliant', true);
	return;
}

function TriggerDoorBlockedSpeech()
{
	TriggerSpeech('DoorBlocked', true);
	return;
}

function TriggerInDangerSpeech()
{
	TriggerSpeech(InDangerSpeechEffectEvents[Rand(InDangerSpeechEffectEvents.Length)], true);
	return;
}

function TriggerSpottedOfficerNormalSpeech()
{
	TriggerSpeech('AnnouncedSpottedOfficer');
	return;
}

function TriggerSpottedOfficerScaredSpeech()
{
	TriggerSpeech('AnnouncedSpottedOfficerScared');
	return;
}
