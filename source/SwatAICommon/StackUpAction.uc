class StackUpAction extends SwatCharacterAction
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

var private MoveToActorGoal CurrentMoveToActorGoal;
var private AimAtTargetGoal CurrentAimAtTargetGoal;
var config float DistanceToStartWalking;
var private bool bShouldWalk;
var config float MinDistanceToAimAtDoor;
var(Parameters) StackupPoint StackupPoint;
var(Parameters) bool bRunToStackupPoint;

function SetStackUpPoint(StackupPoint NewStackUpPoint)
{
	StackupPoint = NewStackUpPoint;
	return;
}

function cleanup()
{
	super(AI_CharacterAction).cleanup();
	if(NotEqual_ObjectObject(CurrentMoveToActorGoal, none))
	{
		CurrentMoveToActorGoal.Release();
		CurrentMoveToActorGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentAimAtTargetGoal, none))
	{
		CurrentAimAtTargetGoal.Release();
		CurrentAimAtTargetGoal = none;
	}
	return;
}

function PostAimAtTargetGoal()
{
	assert(EqualEqual_ObjectObject(CurrentAimAtTargetGoal, none));
	CurrentAimAtTargetGoal = Class'SwatAICommon.AimAtTargetGoal'.static.Allocate(self).;
	construct_AI_ResourceIntActor(weaponResource(), achievingGoal.Priority, StackupPoint.ParentDoor);
	assert(NotEqual_ObjectObject(CurrentAimAtTargetGoal, none));
	CurrentAimAtTargetGoal.AddRef();
	CurrentAimAtTargetGoal.SetAimOnlyWhenCanHitTarget(true);
	CurrentAimAtTargetGoal.SetShouldFinishOnSuccess(false);
	CurrentAimAtTargetGoal.SetAimWeapon(false);
	CurrentAimAtTargetGoal.SetMinDistanceToTargetToAim(MinDistanceToAimAtDoor);
	CurrentAimAtTargetGoal.postGoal(self);
	return;
}

function RemoveAimAtTargetGoal()
{
	assert(NotEqual_ObjectObject(CurrentAimAtTargetGoal, none));
	CurrentAimAtTargetGoal.unPostGoal(self);
	CurrentAimAtTargetGoal.Release();
	CurrentAimAtTargetGoal = none;
	return;
}

latent function MoveToStackUpPoint()
{
	CurrentMoveToActorGoal = Class'SwatAICommon.MoveToActorGoal'.static.Allocate(self).;
	construct_AI_ResourceIntActor(movementResource(), achievingGoal.Priority, StackupPoint);
	assert(NotEqual_ObjectObject(CurrentMoveToActorGoal, none));
	CurrentMoveToActorGoal.AddRef();
	CurrentMoveToActorGoal.SetRotateTowardsPointsDuringMovement(true);
	if(bRunToStackupPoint)
	{
		CurrentMoveToActorGoal.SetWalkThreshold(0.0000000);
	}
	else
	{
		CurrentMoveToActorGoal.SetWalkThreshold(DistanceToStartWalking);
	}
	CurrentMoveToActorGoal.postGoal(self);
	waitForGoal(CurrentMoveToActorGoal);
	CurrentMoveToActorGoal.unPostGoal(self);
	CurrentMoveToActorGoal.Release();
	CurrentMoveToActorGoal = none;
	return;
}

state Running
{Begin:

	SleepInitialDelayTime(true);
	PostAimAtTargetGoal();
	MoveToStackUpPoint();
	RemoveAimAtTargetGoal();
	succeed();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.StackUpGoal'
}