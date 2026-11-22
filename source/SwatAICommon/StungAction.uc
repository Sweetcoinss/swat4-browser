class StungAction extends StunnedAction
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) Actor stingGrenade;

function TriggerStunnedSpeech()
{
	if(NotEqual_ObjectObject(stingGrenade, none))
	{
		ISwatAI(m_pawn).GetSpeechManagerAction().TriggerStingSpeech();
	}
	else
	{
		ISwatAI(m_pawn).GetSpeechManagerAction().TriggerBeanBagSpeech();
	}
	return;
}

protected function float GetMoraleModificationAmount()
{
	return ISwatAI(m_pawn).GetCommanderAction().GetStungMoraleModification();
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
	return ISwatAI(m_pawn).GetStungReactionAnimation();
	return;
}

function name GetAffectedAnimation()
{
	return ISwatAI(m_pawn).GetStungAffectedAnimation();
	return;
}

function name GetRecoveryAnimation()
{
	return ISwatAI(m_pawn).GetStungRecoveryAnimation();
	return;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.StungGoal'
}