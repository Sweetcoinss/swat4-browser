class StunnedByC2Action extends StunnedAction
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

function TriggerStunnedSpeech()
{
	ISwatAI(m_pawn).GetSpeechManagerAction().TriggerStunnedByC2Speech();
	return;
}

protected function bool ShouldTriggerStunnedSpeech()
{
	return Not_PreBool(bPlayedReaction);
	return;
}

protected function float GetMoraleModificationAmount()
{
	return ISwatAI(m_pawn).GetCommanderAction().GetStunnedByC2DetonationMoraleModification();
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
	satisfiesGoal=Class'SwatAICommon.StunnedByC2Goal'
}