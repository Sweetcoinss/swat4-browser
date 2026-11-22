class MoveToAction extends SwatCharacterAction
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

var private MoveToActorGoal CurrentMoveToActorGoal;
var private AimAroundGoal CurrentAimAroundGoal;
var(Parameters) Actor Destination;
var config float DistanceFromDestinationToStartWalking;
var config float MoveToMinAimHoldTime;
var config float MoveToMaxAimHoldTime;

function cleanup()
{
	super(AI_CharacterAction).cleanup();
	if(NotEqual_ObjectObject(CurrentMoveToActorGoal, none))
	{
		CurrentMoveToActorGoal.Release();
		CurrentMoveToActorGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentAimAroundGoal, none))
	{
		CurrentAimAroundGoal.Release();
		CurrentAimAroundGoal = none;
	}
	return;
}

function goalNotAchievedCB(AI_Goal Goal, AI_Action Child, ActionBase.ACT_ErrorCodes errorCode)
{
	super(AI_Action).goalNotAchievedCB(Goal, Child, errorCode);
	if(EqualEqual_ObjectObject(Goal, CurrentMoveToActorGoal))
	{
		assert(m_pawn.IsA('SwatOfficer'));
		ISwatOfficer(m_pawn).GetOfficerSpeechManagerAction().TriggerCouldntCompleteMoveSpeech();
		instantSucceed();
	}
	return;
}

function AimAround()
{
	CurrentAimAroundGoal = Class'SwatAICommon.AimAroundGoal'.static.Allocate(self).;
	construct_AI_ResourceFloatFloat(weaponResource(), MoveToMinAimHoldTime, MoveToMaxAimHoldTime);
	assert(NotEqual_ObjectObject(CurrentAimAroundGoal, none));
	CurrentAimAroundGoal.AddRef();
	CurrentAimAroundGoal.SetOnlyAimIfMoving(true);
	CurrentAimAroundGoal.postGoal(self);
	return;
}

latent function MoveToDestination()
{
	CurrentMoveToActorGoal = Class'SwatAICommon.MoveToActorGoal'.static.Allocate(self).;
	construct_AI_ResourceIntActor(movementResource(), achievingGoal.Priority, Destination);
	assert(NotEqual_ObjectObject(CurrentMoveToActorGoal, none));
	CurrentMoveToActorGoal.AddRef();
	CurrentMoveToActorGoal.SetRotateTowardsPointsDuringMovement(true);
	CurrentMoveToActorGoal.SetWalkThreshold(DistanceFromDestinationToStartWalking);
	CurrentMoveToActorGoal.SetUseNavigationDistanceOnSensor(true);
	CurrentMoveToActorGoal.SetShouldSucceedWhenDestinationBlocked(true);
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
	AimAround();
	MoveToDestination();
	succeed();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.MoveToGoal'
}