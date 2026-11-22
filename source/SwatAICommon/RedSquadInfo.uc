class RedSquadInfo extends ColoredSquadInfo
	native
	config(AI)
	hidecategories(Karma);

protected function TriggerSquadSpecificNeedOrdersSpeech(Pawn OfficerSpeaker)
{
	assert(Class'Engine.Pawn'.static.checkConscious(OfficerSpeaker));
	ISwatOfficer(OfficerSpeaker).GetOfficerSpeechManagerAction().TriggerRedTeamNeedsOrdersSpeech();
	return;
}

function TriggerTeamReportedSpeech(Pawn Officer)
{
	ISwatOfficer(Officer).GetOfficerSpeechManagerAction().TriggerRedTeamReportedSpeech();
	return;
}
