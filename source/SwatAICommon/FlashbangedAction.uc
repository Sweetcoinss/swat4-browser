class FlashbangedAction extends StunnedAction
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

function TriggerStunnedSpeech()
{
	ISwatAI(m_pawn).GetSpeechManagerAction().TriggerFlashbangedSpeech();
	return;
}

protected function float GetMoraleModificationAmount()
{
	return ISwatAI(m_pawn).GetCommanderAction().GetFlashbangedMoraleModification();
	return;
}

function bool ShouldAffectMoraleAgain()
{
	return true;
	return;
}

protected function AddAdditionalStunnedTime(float AdditionalStunnedTime)
{
	AddEqual_FloatFloat(EndTime, AdditionalStunnedTime);
	return;
}

function name GetReactionAnimation()
{
	return ISwatAI(m_pawn).GetFBReactionAnimation();
	return;
}

function name GetAffectedAnimation()
{
	return ISwatAI(m_pawn).GetFBAffectedAnimation();
	return;
}

function name GetRecoveryAnimation()
{
	return ISwatAI(m_pawn).GetFBRecoveryAnimation();
	return;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.FlashbangedGoal'
}