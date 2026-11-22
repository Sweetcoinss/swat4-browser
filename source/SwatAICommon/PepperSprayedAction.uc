class PepperSprayedAction extends StunnedAction
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

function TriggerStunnedSpeech()
{
	ISwatAI(m_pawn).GetSpeechManagerAction().TriggerPepperSprayedSpeech();
	return;
}

protected function float GetMoraleModificationAmount()
{
	return ISwatAI(m_pawn).GetCommanderAction().GetPepperSprayedMoraleModification();
	return;
}

function bool ShouldAffectMoraleAgain()
{
	return false;
	return;
}

protected function AddAdditionalStunnedTime(float AdditionalStunnedTime)
{
	EndTime = Add_FloatFloat(Level.TimeSeconds, AdditionalStunnedTime);
	return;
}

protected function bool ShouldDelayReaction()
{
	return false;
	return;
}

function name GetReactionAnimation()
{
	return ISwatAI(m_pawn).GetGasReactionAnimation();
	return;
}

function name GetAffectedAnimation()
{
	return ISwatAI(m_pawn).GetGasAffectedAnimation();
	return;
}

function name GetRecoveryAnimation()
{
	return ISwatAI(m_pawn).GetGasRecoveryAnimation();
	return;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.PepperSprayedGoal'
}