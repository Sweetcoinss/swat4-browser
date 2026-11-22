class BlueSquadInfo extends ColoredSquadInfo
	native
	config(AI)
	hidecategories(Karma);

protected function TriggerSquadSpecificNeedOrdersSpeech(Pawn OfficerSpeaker)
{
	assert(Class'Engine.Pawn'.static.checkConscious(OfficerSpeaker));
	ISwatOfficer(OfficerSpeaker).GetOfficerSpeechManagerAction().TriggerBlueTeamNeedsOrdersSpeech();
	return;
}

function TriggerTeamReportedSpeech(Pawn Officer)
{
	ISwatOfficer(Officer).GetOfficerSpeechManagerAction().TriggerBlueTeamReportedSpeech();
	return;
}
