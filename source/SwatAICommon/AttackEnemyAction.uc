class AttackEnemyAction extends SwatCharacterAction
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

const kMinAttackEnemyUpdateTime = 0.1;
const kMaxAttackEnemyUpdateTime = 0.25;

var(Parameters) Pawn Enemy;
var private MoveOfficerToEngageGoal CurrentMoveOfficerToEngageGoal;
var private AttackTargetGoal CurrentAttackTargetGoal;

function float selectionHeuristic(AI_Goal Goal)
{
	return FRand();
	return;
}

function Pawn GetEnemy()
{
	if(NotEqual_ObjectObject(Enemy, none))
	{
		return Enemy;
	}
	return ISwatOfficer(m_pawn).GetOfficerCommanderAction().GetCurrentAssignment();
	return;
}

function cleanup()
{
	super(AI_CharacterAction).cleanup();
	if(NotEqual_ObjectObject(CurrentMoveOfficerToEngageGoal, none))
	{
		CurrentMoveOfficerToEngageGoal.Release();
		CurrentMoveOfficerToEngageGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentAttackTargetGoal, none))
	{
		CurrentAttackTargetGoal.Release();
		CurrentAttackTargetGoal = none;
	}
	return;
}

function goalNotAchievedCB(AI_Goal Goal, AI_Action Child, ActionBase.ACT_ErrorCodes errorCode)
{
	super(AI_Action).goalNotAchievedCB(Goal, Child, errorCode);
	if(OrOr_BoolBool(EqualEqual_ObjectObject(Goal, CurrentAttackTargetGoal), EqualEqual_ObjectObject(Goal, CurrentMoveOfficerToEngageGoal)))
	{
		instantSucceed();
	}
	return;
}

function bool ShouldMoveToAttackEnemy()
{
	local SwatAIRepository SwatAIRepo;

	SwatAIRepo = SwatAIRepository(Level.AIRepo);
	return Not_PreBool(SwatAIRepo.IsOfficerMovingAndClearing(m_pawn));
	return;
}

function bool IsMovingToAttack()
{
	return OrOr_BoolBool(Not_PreBool(ShouldMoveToAttackEnemy()), AndAnd_BoolBool(NotEqual_ObjectObject(CurrentMoveOfficerToEngageGoal, none), Not_PreBool(CurrentMoveOfficerToEngageGoal.hasCompleted())));
	return;
}

private function MoveToAttackEnemy()
{
	if(m_pawn.logAI)
	{
		Log(Concat_StrStr(string(m_pawn.Name), " will move to attack the enemy"));
	}
	CurrentMoveOfficerToEngageGoal = Class'SwatAICommon.MoveOfficerToEngageGoal'.static.Allocate(self).;
	Construct_AI_ResourceIntPawn(movementResource(), achievingGoal.Priority, GetEnemy());
	assert(NotEqual_ObjectObject(CurrentMoveOfficerToEngageGoal, none));
	CurrentMoveOfficerToEngageGoal.AddRef();
	CurrentMoveOfficerToEngageGoal.SetRotateTowardsPointsDuringMovement(true);
	CurrentMoveOfficerToEngageGoal.postGoal(self);
	return;
}

private function AttackEnemyWithWeapon()
{
	CurrentAttackTargetGoal = Class'SwatAICommon.AttackTargetGoal'.static.Allocate(self).;
	construct_AI_ResourceActor(weaponResource(), GetEnemy());
	assert(NotEqual_ObjectObject(CurrentAttackTargetGoal, none));
	CurrentAttackTargetGoal.AddRef();
	CurrentAttackTargetGoal.postGoal(self);
	return;
}

state Running
{Begin:

	waitForResourcesAvailable(achievingGoal.Priority, achievingGoal.Priority);
	AttackEnemyWithWeapon();
	J0x28:

	if(Not_PreBool(CurrentAttackTargetGoal.hasCompleted()))
	{
		if(AndAnd_BoolBool(EqualEqual_ObjectObject(CurrentMoveOfficerToEngageGoal, none), ShouldMoveToAttackEnemy()))
		{
			MoveToAttackEnemy();
		}
		Sleep(RandRange(0.1000000, 0.2500000));
		// [Loop Continue]
		goto J0x28;
	}
	succeed();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.AttackEnemyGoal'
}