class TasedAction extends StunnedAction
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

const kPostAffectedGoalPriority = 95;

function TriggerStunnedSpeech()
{
	ISwatAI(m_pawn).GetSpeechManagerAction().TriggerTasedSpeech();
	return;
}

protected function float GetMoraleModificationAmount()
{
	return ISwatAI(m_pawn).GetCommanderAction().GetTasedMoraleModification();
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
	return ISwatAI(m_pawn).GetTasedReactionAnimation();
	return;
}

function name GetAffectedAnimation()
{
	return ISwatAI(m_pawn).GetTasedAffectedAnimation();
	return;
}

function name GetRecoveryAnimation()
{
	return ISwatAI(m_pawn).GetTasedRecoveryAnimation();
	return;
}

protected latent function NotifyFinishedAffectedAnimation()
{
	if(NotEqual_IntInt(achievingGoal.Priority, 95))
	{
		achievingGoal.changePriority(95);
		clearDummyGoals();
		useResources(Or_IntInt(Class'Tyrion.AI_Resource'.2, Class'Tyrion.AI_Resource'.4));
	}
	return;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.TasedGoal'
}