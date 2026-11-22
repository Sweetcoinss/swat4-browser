class CoverAction extends SwatCharacterAction
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

const kMinTimeToHitCoverLocation = 0.333;
const kCoverUpdateTime = 0.5;
const kMaxDistanceFromCoverFromLocation = 100.0;

var private MoveToLocationGoal CurrentMoveToLocationGoal;
var private RotateTowardRotationGoal CurrentRotateTowardRotationGoal;
var private AimAroundGoal CurrentAimAroundGoal;
var private float StartCanHitCoverLocationTime;
var private float TimeToAnnounceStillCovering;
var private Vector LastCoverFromLocation;
var(Parameters) Vector coverLocation;
var(Parameters) Vector CoverFromLocation;
var(Parameters) Vector CommandOrigin;
var(Parameters) bool bShouldAimAround;
var config float InnerAimAroundFOVDegrees;
var config float OuterAimAroundFOVDegrees;
var config float MinDeltaWaitTimeToAnnounceStillCovering;
var config float MaxDeltaWaitTimeToAnnounceStillCovering;

function cleanup()
{
	super(AI_CharacterAction).cleanup();
	if(NotEqual_ObjectObject(CurrentMoveToLocationGoal, none))
	{
		CurrentMoveToLocationGoal.Release();
		CurrentMoveToLocationGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentRotateTowardRotationGoal, none))
	{
		CurrentRotateTowardRotationGoal.Release();
		CurrentRotateTowardRotationGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentAimAroundGoal, none))
	{
		CurrentAimAroundGoal.Release();
		CurrentAimAroundGoal = none;
	}
	return;
}

latent function MoveToCoverFromLocation()
{
	CurrentMoveToLocationGoal = Class'SwatAICommon.MoveToLocationGoal'.static.Allocate(self).;
	construct_AI_ResourceIntVector(movementResource(), achievingGoal.Priority, CoverFromLocation);
	assert(NotEqual_ObjectObject(CurrentMoveToLocationGoal, none));
	CurrentMoveToLocationGoal.AddRef();
	CurrentMoveToLocationGoal.SetAcceptNearbyPath(true);
	CurrentMoveToLocationGoal.SetRotateTowardsPointsDuringMovement(true);
	CurrentMoveToLocationGoal.postGoal(self);
	J0x80:

	if(AndAnd_BoolBool(Not_PreBool(CurrentMoveToLocationGoal.hasCompleted()), Not_PreBool(MovingCanAimAtCoverLocation())))
	{
		yield();
		// [Loop Continue]
		goto J0x80;
	}
	CurrentMoveToLocationGoal.unPostGoal(self);
	CurrentMoveToLocationGoal.Release();
	CurrentMoveToLocationGoal = none;
	LastCoverFromLocation = m_pawn.Location;
	return;
}

latent function RotateToFaceCoverLocation()
{
	CurrentRotateTowardRotationGoal = Class'SwatAICommon.RotateTowardRotationGoal'.static.Allocate(self).;
	Construct_AI_ResourceIntRotator(movementResource(), achievingGoal.Priority, Rotator(Subtract_VectorVector(coverLocation, m_pawn.Location)));
	assert(NotEqual_ObjectObject(CurrentRotateTowardRotationGoal, none));
	CurrentRotateTowardRotationGoal.AddRef();
	CurrentRotateTowardRotationGoal.postGoal(self);
	waitForGoal(CurrentRotateTowardRotationGoal);
	CurrentRotateTowardRotationGoal.unPostGoal(self);
	CurrentRotateTowardRotationGoal.Release();
	CurrentRotateTowardRotationGoal = none;
	return;
}

private function bool CanAimAtCoverLocation()
{
	local Vector EyePoint;

	EyePoint = m_pawn.Location;
	AddEqual_FloatFloat(EyePoint.Z, m_pawn.BaseEyeHeight);
	return EqualEqual_BoolBool(m_pawn.FastTrace(coverLocation, EyePoint), true);
	return;
}

private function bool MovingCanAimAtCoverLocation()
{
	if(NotEqual_VectorVector(CoverFromLocation, CommandOrigin))
	{
		return false;
	}
	else
	{
		if(CanAimAtCoverLocation())
		{
			if(EqualEqual_FloatFloat(StartCanHitCoverLocationTime, 0.0000000))
			{
				StartCanHitCoverLocationTime = m_pawn.Level.TimeSeconds;
			}
			else
			{
				if(AndAnd_BoolBool(NotEqual_FloatFloat(StartCanHitCoverLocationTime, 0.0000000), GreaterEqual_FloatFloat(Level.TimeSeconds, Add_FloatFloat(StartCanHitCoverLocationTime, 0.3330000))))
				{
					return true;
				}
			}
		}
		else
		{
			StartCanHitCoverLocationTime = 0.0000000;
		}
		return false;
	}
	return;
}

function AimAroundAtCoverLocation()
{
	CurrentAimAroundGoal = Class'SwatAICommon.AimAroundGoal'.static.Allocate(self).;
	construct_AI_ResourceInt(weaponResource(), achievingGoal.Priority);
	assert(NotEqual_ObjectObject(CurrentAimAroundGoal, none));
	CurrentAimAroundGoal.AddRef();
	CurrentAimAroundGoal.SetAimWeapon(false);
	CurrentAimAroundGoal.SetDoOnce(false);
	CurrentAimAroundGoal.SetOnlyAimIfMoving(false);
	CurrentAimAroundGoal.SetAimInnerFovDegrees(InnerAimAroundFOVDegrees);
	CurrentAimAroundGoal.SetAimOuterFovDegrees(OuterAimAroundFOVDegrees);
	CurrentAimAroundGoal.postGoal(self);
	return;
}

private function SetTimeToAnnounceStillCovering()
{
	TimeToAnnounceStillCovering = Add_FloatFloat(Level.TimeSeconds, RandRange(MinDeltaWaitTimeToAnnounceStillCovering, MaxDeltaWaitTimeToAnnounceStillCovering));
	return;
}

private function bool HasMovedFarAwayFromCoverFromLocation()
{
	return Greater_FloatFloat(VSize2D(Subtract_VectorVector(LastCoverFromLocation, m_pawn.Location)), 100.0000000);
	return;
}

state Running
{Begin:

	clearDummyGoals();
	useResources(Class'Tyrion.AI_Resource'.2);
	if(Not_PreBool(CanAimAtCoverLocation()))
	{
		MoveToCoverFromLocation();
	}
	RotateToFaceCoverLocation();
	useResources(Class'Tyrion.AI_Resource'.4);
	if(bShouldAimAround)
	{
		clearDummyWeaponGoal();
		AimAroundAtCoverLocation();
	}
	SetTimeToAnnounceStillCovering();
Waiting:

	Sleep(0.5000000);
	if(AndAnd_BoolBool(Not_PreBool(bShouldAimAround), Greater_FloatFloat(Level.TimeSeconds, TimeToAnnounceStillCovering)))
	{
		ISwatOfficer(m_pawn).GetOfficerSpeechManagerAction().TriggerStillCoveringSpeech();
		SetTimeToAnnounceStillCovering();
	}
	if(AndAnd_BoolBool(Not_PreBool(CanAimAtCoverLocation()), OrOr_BoolBool(Not_PreBool(bShouldAimAround), HasMovedFarAwayFromCoverFromLocation())))
	{
		goto 'Begin';
	}
	else
	{
		goto 'Waiting';
	}
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.CoverGoal'
}