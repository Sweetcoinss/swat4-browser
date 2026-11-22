class EnemyCowerAction extends SwatCharacterAction
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

var config array<name> CrouchedInitialEnemyCowerAnimations;
var private RotateTowardActorGoal CurrentRotateTowardActorGoal;

function cleanup()
{
	super(AI_CharacterAction).cleanup();
	if(NotEqual_ObjectObject(CurrentRotateTowardActorGoal, none))
	{
		CurrentRotateTowardActorGoal.Release();
		CurrentRotateTowardActorGoal = none;
	}
	return;
}

function Pawn GetOfficerTarget()
{
	return ISwatEnemy(m_pawn).GetEnemyCommanderAction().GetCurrentEnemy();
	return;
}

function float selectionHeuristic(AI_Goal Goal)
{
	if(EqualEqual_ObjectObject(m_pawn, none))
	{
		m_pawn = AI_CharacterResource(Goal.resource).m_pawn;
		assert(NotEqual_ObjectObject(m_pawn, none));
	}
	assert(m_pawn.IsA('SwatEnemy'));
	if(Not_PreBool(ISwatAI(m_pawn).HasUsableWeapon()))
	{
		if(ISwatEnemy(m_pawn).GetEnemyCommanderAction().HasFledWithoutUsableWeapon())
		{
			return 1.0000000;
		}
		else
		{
			return FRand();
		}
	}
	else
	{
		return 0.0000000;
	}
	return;
}

function name GetInitialCowerAnimation()
{
	return CrouchedInitialEnemyCowerAnimations[Rand(CrouchedInitialEnemyCowerAnimations.Length)];
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

private function bool ShouldFaceTargetOfficer()
{
	return AndAnd_BoolBool(Class'Engine.Pawn'.static.checkConscious(GetOfficerTarget()), m_pawn.LineOfSightTo(GetOfficerTarget()));
	return;
}

private latent function FaceTargetOfficer()
{
	CurrentRotateTowardActorGoal = Class'SwatAICommon.RotateTowardActorGoal'.static.Allocate(self).;
	construct_AI_ResourceIntActor(movementResource(), achievingGoal.Priority, GetOfficerTarget());
	assert(NotEqual_ObjectObject(CurrentRotateTowardActorGoal, none));
	CurrentRotateTowardActorGoal.AddRef();
	CurrentRotateTowardActorGoal.postGoal(self);
	waitForGoal(CurrentRotateTowardActorGoal);
	CurrentRotateTowardActorGoal.unPostGoal(self);
	CurrentRotateTowardActorGoal.Release();
	CurrentRotateTowardActorGoal = none;
	return;
}

state Running
{Begin:

	waitForResourcesAvailable(achievingGoal.Priority, achievingGoal.Priority);
	useResources(Class'Tyrion.AI_Resource'.2);
	if(ShouldFaceTargetOfficer())
	{
		FaceTargetOfficer();
	}
	useResources(Class'Tyrion.AI_Resource'.4);
	m_pawn.ShouldCrouch(true);
	yield();
	PlayCowerAnimation();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.EngageOfficerGoal'
}