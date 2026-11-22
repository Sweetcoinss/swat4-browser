class EngageForComplianceAction extends SwatCharacterAction
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

const kMinComplianceUpdateTime = 0.1;
const kMaxComplianceUpdateTime = 0.25;

var(Parameters) Pawn TargetPawn;
var private OrderComplianceGoal CurrentOrderComplianceGoal;
var private MoveOfficerToEngageGoal CurrentMoveOfficerToEngageGoal;
var config float MinComplianceOrderSleepTime;
var config float MaxComplianceOrderSleepTime;

function cleanup()
{
	super(AI_CharacterAction).cleanup();
	if(NotEqual_ObjectObject(CurrentOrderComplianceGoal, none))
	{
		CurrentOrderComplianceGoal.Release();
		CurrentOrderComplianceGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentMoveOfficerToEngageGoal, none))
	{
		CurrentMoveOfficerToEngageGoal.Release();
		CurrentMoveOfficerToEngageGoal = none;
	}
	return;
}

function goalNotAchievedCB(AI_Goal Goal, AI_Action Child, ActionBase.ACT_ErrorCodes errorCode)
{
	super(AI_Action).goalNotAchievedCB(Goal, Child, errorCode);
	if(OrOr_BoolBool(EqualEqual_ObjectObject(Goal, CurrentOrderComplianceGoal), EqualEqual_ObjectObject(Goal, CurrentMoveOfficerToEngageGoal)))
	{
		instantSucceed();
	}
	return;
}

private function bool ShouldMoveTowardsComplianceTarget()
{
	local SwatAIRepository SwatAIRepo;

	SwatAIRepo = SwatAIRepository(Level.AIRepo);
	return Not_PreBool(SwatAIRepo.IsOfficerMovingAndClearing(m_pawn));
	return;
}

private function MoveTowardsComplianceTarget()
{
	if(m_pawn.logAI)
	{
		Log(Concat_StrStr(string(m_pawn.Name), " will move to engage the target for compliance"));
	}
	assert(EqualEqual_ObjectObject(CurrentMoveOfficerToEngageGoal, none));
	CurrentMoveOfficerToEngageGoal = Class'SwatAICommon.MoveOfficerToEngageGoal'.static.Allocate(self).;
	Construct_AI_ResourceIntPawn(movementResource(), achievingGoal.Priority, TargetPawn);
	assert(NotEqual_ObjectObject(CurrentMoveOfficerToEngageGoal, none));
	CurrentMoveOfficerToEngageGoal.AddRef();
	CurrentMoveOfficerToEngageGoal.SetRotateTowardsPointsDuringMovement(true);
	CurrentMoveOfficerToEngageGoal.postGoal(self);
	return;
}

private function OrderTargetToComply()
{
	assert(EqualEqual_ObjectObject(CurrentOrderComplianceGoal, none));
	CurrentOrderComplianceGoal = Class'SwatAICommon.OrderComplianceGoal'.static.Allocate(self).;
	construct_AI_ResourcePawn(weaponResource(), TargetPawn);
	assert(NotEqual_ObjectObject(CurrentOrderComplianceGoal, none));
	CurrentOrderComplianceGoal.AddRef();
	CurrentOrderComplianceGoal.postGoal(self);
	return;
}

state Running
{Begin:

	OrderTargetToComply();
	J0x06:

	if(Not_PreBool(CurrentOrderComplianceGoal.hasCompleted()))
	{
		if(AndAnd_BoolBool(EqualEqual_ObjectObject(CurrentMoveOfficerToEngageGoal, none), ShouldMoveTowardsComplianceTarget()))
		{
			MoveTowardsComplianceTarget();
		}
		Sleep(RandRange(0.1000000, 0.2500000));
		// [Loop Continue]
		goto J0x06;
	}
	succeed();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.EngageForComplianceGoal'
}