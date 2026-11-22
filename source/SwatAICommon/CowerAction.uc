class CowerAction extends SwatCharacterAction
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

var config array<name> CrouchedInitialCowerAnimations;
var config array<name> StandingInitialCowerAnimations;

function name GetInitialCowerAnimation()
{
	if(m_pawn.bIsCrouched)
	{
		return CrouchedInitialCowerAnimations[Rand(CrouchedInitialCowerAnimations.Length)];
	}
	else
	{
		return StandingInitialCowerAnimations[Rand(StandingInitialCowerAnimations.Length)];
	}
	return;
}

latent function PlayCowerAnimation()
{
	local int IdleChannel;
	local name InitialCowerAnimation;

	if(NotEqual_NameName(InitialCowerAnimation, 'None'))
	{
		IdleChannel = m_pawn.AnimPlaySpecial(GetInitialCowerAnimation(), 0.2000000);
		m_pawn.FinishAnim(IdleChannel);
	}
	ISwatAI(m_pawn).SetIdleCategory('Cower');
	return;
}

state Running
{	J0x00:
	if(Not_PreBool(resource.requiredResourcesAvailable(achievingGoal.Priority, achievingGoal.Priority)))
	{
		yield();
		// [Loop Continue]
		goto J0x00;
	}
	useResources(Or_IntInt(Class'Tyrion.AI_Resource'.2, Class'Tyrion.AI_Resource'.4));
	PlayCowerAnimation();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.CowerGoal'
}