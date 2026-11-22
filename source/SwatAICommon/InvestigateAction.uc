class InvestigateAction extends SuspiciousAction
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

const kMinInvestigateTime = 8.0;
const kMaxInvestigateTime = 15.0;
const kMinLookAtInvestigateDistance = 100.0;

var private AimAroundGoal CurrentAimAroundGoal;
var private AimAtPointGoal CurrentAimAtPointGoal;
var private MoveToLocationGoal CurrentMoveToLocationGoal;
var private RotateTowardPointGoal CurrentRotateTowardPointGoal;
var config float MinInvestigateDelayTime;
var config float MaxInvestigateDelayTime;
var config float ReactionSpeechChance;
var config float MinInvestigateTime;
var config float MaxInvestigateTime;
var private Timer InvestigateTimeoutTimer;
var(Parameters) Vector InvestigateLocation;
var(Parameters) bool bShouldWalkToInvestigate;

function cleanup()
{
	super(AI_CharacterAction).cleanup();
	if(NotEqual_ObjectObject(CurrentAimAroundGoal, none))
	{
		CurrentAimAroundGoal.Release();
		CurrentAimAroundGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentAimAtPointGoal, none))
	{
		CurrentAimAtPointGoal.Release();
		CurrentAimAtPointGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentMoveToLocationGoal, none))
	{
		CurrentMoveToLocationGoal.Release();
		CurrentMoveToLocationGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentRotateTowardPointGoal, none))
	{
		CurrentRotateTowardPointGoal.Release();
		CurrentRotateTowardPointGoal = none;
	}
	if(NotEqual_ObjectObject(InvestigateTimeoutTimer, none))
	{
		InvestigateTimeoutTimer.__TimerDelegate__Delegate = None;
		InvestigateTimeoutTimer.Destroy();
		InvestigateTimeoutTimer = none;
	}
	return;
}

function goalNotAchievedCB(AI_Goal Goal, AI_Action Child, ActionBase.ACT_ErrorCodes errorCode)
{
	super(AI_Action).goalNotAchievedCB(Goal, Child, errorCode);
	instantFail(errorCode);
	return;
}

function goalAchievedCB(AI_Goal Goal, AI_Action Child)
{
	super(AI_Action).goalAchievedCB(Goal, Child);
	if(EqualEqual_ObjectObject(Goal, CurrentMoveToLocationGoal))
	{
		if(IsIdle())
		{
			runAction();
		}
	}
	return;
}

latent function MoveToInvestigationDestination()
{
	CurrentMoveToLocationGoal = Class'SwatAICommon.MoveToLocationGoal'.static.Allocate(self).;
	construct_AI_ResourceIntVector(movementResource(), achievingGoal.Priority, InvestigateLocation);
	assert(NotEqual_ObjectObject(CurrentMoveToLocationGoal, none));
	CurrentMoveToLocationGoal.AddRef();
	CurrentMoveToLocationGoal.SetRotateTowardsFirstPoint(true);
	CurrentMoveToLocationGoal.SetRotateTowardsPointsDuringMovement(true);
	CurrentMoveToLocationGoal.SetAcceptNearbyPath(true);
	CurrentMoveToLocationGoal.SetShouldWalkEntireMove(bShouldWalkToInvestigate);
	CurrentMoveToLocationGoal.postGoal(self);
	return;
}

latent function AimAtInvestigationLocation()
{
	if(NotEqual_ObjectObject(CurrentAimAroundGoal, none))
	{
		CurrentAimAroundGoal.unPostGoal(self);
		CurrentAimAroundGoal.Release();
		CurrentAimAroundGoal = none;
	}
	CurrentAimAtPointGoal = Class'SwatAICommon.AimAtPointGoal'.static.Allocate(self).;
	construct_AI_ResourceVector(weaponResource(), InvestigateLocation);
	assert(NotEqual_ObjectObject(CurrentAimAtPointGoal, none));
	CurrentAimAtPointGoal.AddRef();
	CurrentAimAtPointGoal.postGoal(self);
	return;
}

function AimAround(float InnerFOVDegrees, float OuterFOVDegrees, bool bOnlyAimIfMoving)
{
	if(NotEqual_ObjectObject(CurrentAimAtPointGoal, none))
	{
		CurrentAimAtPointGoal.unPostGoal(self);
		CurrentAimAtPointGoal.Release();
		CurrentAimAtPointGoal = none;
	}
	CurrentAimAroundGoal = Class'SwatAICommon.AimAroundGoal'.static.Allocate(self).;
	construct_AI_ResourceInt(weaponResource());
	assert(NotEqual_ObjectObject(CurrentAimAroundGoal, none));
	CurrentAimAroundGoal.AddRef();
	CurrentAimAroundGoal.SetAimInnerFovDegrees(InnerFOVDegrees);
	CurrentAimAroundGoal.SetAimOuterFovDegrees(OuterFOVDegrees);
	CurrentAimAroundGoal.SetAimWeapon(true);
	CurrentAimAroundGoal.SetOnlyAimIfMoving(bOnlyAimIfMoving);
	CurrentAimAroundGoal.postGoal(self);
	return;
}

function bool CanLookAtInvestigateLocation()
{
	return OrOr_BoolBool(m_pawn.FastTrace(m_pawn.Location, InvestigateLocation), Less_FloatFloat(VSize(Subtract_VectorVector(m_pawn.Location, InvestigateLocation)), 100.0000000));
	return;
}

private function StartInvestigateTimeoutTimer()
{
	assert(EqualEqual_ObjectObject(InvestigateTimeoutTimer, none));
	InvestigateTimeoutTimer = m_pawn.Spawn(Class'Engine.Timer', m_pawn);
	InvestigateTimeoutTimer.__TimerDelegate__Delegate = instantSucceed;
	InvestigateTimeoutTimer.StartTimer(RandRange(MinInvestigateTime, MaxInvestigateTime), false);
	return;
}

state Running
{Begin:

	useResources(Or_IntInt(Class'Tyrion.AI_Resource'.2, Class'Tyrion.AI_Resource'.4));
	Sleep(RandRange(MinInvestigateDelayTime, MaxInvestigateDelayTime));
	if(Less_FloatFloat(FRand(), ReactionSpeechChance))
	{
		ISwatEnemy(m_pawn).GetEnemySpeechManagerAction().TriggerInvestigateSpeech();
	}
	StartInvestigateTimeoutTimer();
	CheckWeaponStatus();
	clearDummyWeaponGoal();
	clearDummyMovementGoal();
	AimAround(45.0000000, 60.0000000, true);
	MoveToInvestigationDestination();
	useResources(Class'Tyrion.AI_Resource'.2);
	J0x9B:

	if(Not_PreBool(CanLookAtInvestigateLocation()))
	{
		yield();
		// [Loop Continue]
		goto J0x9B;
	}
	clearDummyWeaponGoal();
	AimAtInvestigationLocation();
	Pause();
	AimAround(180.0000000, 360.0000000, false);
	Sleep(RandRange(8.0000000, 15.0000000));
	succeed();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.InvestigateGoal'
}