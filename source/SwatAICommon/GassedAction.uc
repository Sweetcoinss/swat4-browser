class GassedAction extends StunnedAction
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

function TriggerStunnedSpeech()
{
	ISwatAI(m_pawn).GetSpeechManagerAction().TriggerGassedSpeech();
	return;
}

protected function UnTriggerStunnedSpeech()
{
	m_pawn.BroadcastUnTriggerEffectEvent('ReactedGas', m_pawn.Tag);
	return;
}

protected function bool ShouldReTriggerStunnedSpeech()
{
	return false;
	return;
}

protected function float GetMoraleModificationAmount()
{
	return ISwatAI(m_pawn).GetCommanderAction().GetGassedMoraleModification();
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
	satisfiesGoal=Class'SwatAICommon.GassedGoal'
}