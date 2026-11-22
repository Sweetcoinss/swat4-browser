class AttackOfficerAction extends SwatCharacterAction
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

var private MoveToAttackOfficerGoal CurrentMoveToAttackOfficerGoal;
var private AttackTargetGoal CurrentAttackTargetGoal;
var private config float MinPassiveAttackOfficerPercentageChance;
var private config float MaxPassiveAttackOfficerPercentageChance;
var private config float MinAggressiveAttackOfficerPercentageChance;
var private config float MaxAggressiveAttackOfficerPercentageChance;
var private config float LowSkillSuccessAfterFiringChance;
var private config float MediumSkillSuccessAfterFiringChance;
var private config float HighSkillSuccessAfterFiringChance;

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
	if(AndAnd_BoolBool(ISwatAI(m_pawn).HasUsableWeapon(), NotEqual_ObjectObject(GetOfficerTarget(), none)))
	{
		if(ISwatAI(m_pawn).IsAggressive())
		{
			return FClamp(FRand(), MinAggressiveAttackOfficerPercentageChance, MaxAggressiveAttackOfficerPercentageChance);
		}
		else
		{
			return FClamp(FRand(), MinPassiveAttackOfficerPercentageChance, MaxPassiveAttackOfficerPercentageChance);
		}
	}
	else
	{
		return 0.0000000;
	}
	return;
}

function cleanup()
{
	super(AI_CharacterAction).cleanup();
	if(NotEqual_ObjectObject(CurrentMoveToAttackOfficerGoal, none))
	{
		CurrentMoveToAttackOfficerGoal.Release();
		CurrentMoveToAttackOfficerGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentAttackTargetGoal, none))
	{
		CurrentAttackTargetGoal.Release();
		CurrentAttackTargetGoal = none;
	}
	return;
}

function float GetSkillSpecificSuccessAfterFiringChance()
{
	local ISwatEnemy.EnemySkill CurrentEnemySkill;

	CurrentEnemySkill = ISwatEnemy(m_pawn).GetEnemySkill();
	switch(CurrentEnemySkill)
	{
		case 0:
			return LowSkillSuccessAfterFiringChance;
		case 1:
			return MediumSkillSuccessAfterFiringChance;
		case 2:
			return HighSkillSuccessAfterFiringChance;
		default:
			assert(false);
			return 0.0000000;
			break;
	}
	return;
}

latent function MoveToAttackEnemy()
{
	CurrentMoveToAttackOfficerGoal = Class'SwatAICommon.MoveToAttackOfficerGoal'.static.Allocate(self).;
	construct_AI_ResourceIntActor(movementResource(), achievingGoal.Priority, GetOfficerTarget());
	assert(NotEqual_ObjectObject(CurrentMoveToAttackOfficerGoal, none));
	CurrentMoveToAttackOfficerGoal.AddRef();
	CurrentMoveToAttackOfficerGoal.SetRotateTowardsPointsDuringMovement(true);
	CurrentMoveToAttackOfficerGoal.SetUseCoveredPaths();
	CurrentMoveToAttackOfficerGoal.postGoal(self);
	return;
}

latent function AttackEnemyWithWeapon()
{
	CurrentAttackTargetGoal = Class'SwatAICommon.AttackTargetGoal'.static.Allocate(self).;
	construct_AI_ResourceActor(weaponResource(), GetOfficerTarget());
	assert(NotEqual_ObjectObject(CurrentAttackTargetGoal, none));
	CurrentAttackTargetGoal.AddRef();
	CurrentAttackTargetGoal.SetChanceToSucceedAfterFiring(GetSkillSpecificSuccessAfterFiringChance());
	waitForGoal(CurrentAttackTargetGoal.postGoal(self));
	CurrentAttackTargetGoal.unPostGoal(self);
	if(Not_PreBool(Class'Engine.Pawn'.static.checkConscious(GetOfficerTarget())))
	{
		ISwatEnemy(m_pawn).GetEnemySpeechManagerAction().TriggerDownedOfficerSpeech();
	}
	return;
}

private latent function FinishUpMoveToAttackBehavior()
{
	if(NotEqual_ObjectObject(CurrentMoveToAttackOfficerGoal, none))
	{
		if(NotEqual_ObjectObject(CurrentMoveToAttackOfficerGoal.achievingAction, none))
		{
			MoveToAttackOfficerAction(CurrentMoveToAttackOfficerGoal.achievingAction).FinishUp();
			waitForGoal(CurrentMoveToAttackOfficerGoal);
		}
		CurrentMoveToAttackOfficerGoal.unPostGoal(self);
		CurrentMoveToAttackOfficerGoal.Release();
		CurrentMoveToAttackOfficerGoal = none;
	}
	return;
}

state Running
{Begin:

	waitForResourcesAvailable(achievingGoal.Priority, achievingGoal.Priority);
	MoveToAttackEnemy();
	AttackEnemyWithWeapon();
	FinishUpMoveToAttackBehavior();
	succeed();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.EngageOfficerGoal'
}