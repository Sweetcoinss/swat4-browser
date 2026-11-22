class MoveAndClearAction extends SwatCharacterAction
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

const kClearedRoomUpdateTime = 0.333;
const kDummyBehaviorPriority = 84;

var(Parameters) ClearPoint TargetClearPoint;
var(Parameters) Vector CommandOrigin;
var(Parameters) bool bShouldAnnounceClear;
var private MoveToActorGoal CurrentMoveToActorGoal;
var private RotateTowardActorGoal CurrentRotateTowardActorGoal;
var private RotateTowardRotationGoal CurrentRotateTowardRotationGoal;
var private AimAroundGoal CurrentAimAroundGoal;
var array<NavigationPoint> ClearRoute;
var private int CurrentClearRouteIndex;
var private bool bPauseMovement;
var private float EndHoldClearPositionTime;
var config float DistanceToStopMovingWithUncompliantCharacter;
var config float MoveAndClearMinAimHoldTime;
var config float MoveAndClearMaxAimHoldTime;
var config float MoveAndClearAimAroundInnerRadius;
var config float MoveAndClearAimAroundOuterRadius;
var config float MoveAndClearAimAroundPointTooCloseDistance;
var config float MinHoldClearPositionTime;
var config float MaxHoldClearPositionTime;
var private DistanceToUncomplaintCharactersSensor DistanceToUncomplaintCharactersSensor;

function cleanup()
{
	super(AI_CharacterAction).cleanup();
	if(NotEqual_ObjectObject(CurrentMoveToActorGoal, none))
	{
		CurrentMoveToActorGoal.Release();
		CurrentMoveToActorGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentRotateTowardRotationGoal, none))
	{
		CurrentRotateTowardRotationGoal.Release();
		CurrentRotateTowardRotationGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentRotateTowardActorGoal, none))
	{
		CurrentRotateTowardActorGoal.Release();
		CurrentRotateTowardActorGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentAimAroundGoal, none))
	{
		CurrentAimAroundGoal.Release();
		CurrentAimAroundGoal = none;
	}
	if(NotEqual_ObjectObject(DistanceToUncomplaintCharactersSensor, none))
	{
		DistanceToUncomplaintCharactersSensor.deactivateSensor(self);
		DistanceToUncomplaintCharactersSensor = none;
	}
	return;
}

function resourceStolenCB(AI_Goal Goal, AI_Resource stolenResource)
{
	if(OrOr_BoolBool(Not_PreBool(HasCurrentAssignment()), AndAnd_BoolBool(Not_PreBool(Goal.IsA('AI_DummyWeaponGoal')), Not_PreBool(Goal.IsA('AI_DummyMovementGoal')))))
	{
		super(AI_Action).resourceStolenCB(Goal, stolenResource);
	}
	return;
}

private function SetupDistanceToUncomplaintCharactersSensor()
{
	DistanceToUncomplaintCharactersSensor = DistanceToUncomplaintCharactersSensor(Class'Tyrion.AI_Sensor'.static.activateSensor(self, Class'SwatAICommon.DistanceToUncomplaintCharactersSensor', characterResource(), 0.0000000, 1000000.0000000));
	assert(NotEqual_ObjectObject(DistanceToUncomplaintCharactersSensor, none));
	DistanceToUncomplaintCharactersSensor.setParameters_Float(DistanceToStopMovingWithUncompliantCharacter);
	return;
}

function OnSensorMessage(AI_Sensor sensor, AI_SensorData Value, Object userData)
{
	if(m_pawn.logTyrion)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("MoveAndClearAction received sensor message from ", string(sensor.Name)), " value is "), string(Value.integerData)));
	}
	assert(EqualEqual_ObjectObject(sensor, DistanceToUncomplaintCharactersSensor));
	if(NotEqual_ObjectObject(Value.objectData, none))
	{
		assert(Value.objectData.IsA('Pawn'));
		PauseMovement(Pawn(Value.objectData));
	}
	else
	{
		if(EqualEqual_ObjectObject(Value.objectData, none))
		{
			if(bPauseMovement)
			{
				UnPauseMovement();
			}
		}
	}
	return;
}

private function PauseMovement(Pawn PausingCharacter)
{
	bPauseMovement = true;
	if(AndAnd_BoolBool(NotEqual_ObjectObject(CurrentMoveToActorGoal, none), NotEqual_ObjectObject(CurrentMoveToActorGoal.achievingAction, none)))
	{
		CurrentMoveToActorGoal.achievingAction.instantSucceed();
	}
	RotateToFacePausingCharacter(PausingCharacter);
	return;
}

private function UnPauseMovement()
{
	bPauseMovement = false;
	RemoveRotateToFacePausingCharacterGoal();
	if(IsIdle())
	{
		runAction();
	}
	return;
}

private function RemoveRotateToFacePausingCharacterGoal()
{
	if(NotEqual_ObjectObject(CurrentRotateTowardActorGoal, none))
	{
		CurrentRotateTowardActorGoal.unPostGoal(self);
		CurrentRotateTowardActorGoal.Release();
		CurrentRotateTowardActorGoal = none;
	}
	return;
}

function RotateToFacePausingCharacter(Pawn PausingCharacter)
{
	RemoveRotateToFacePausingCharacterGoal();
	CurrentRotateTowardActorGoal = Class'SwatAICommon.RotateTowardActorGoal'.static.Allocate(self).;
	construct_AI_ResourceIntActor(movementResource(), achievingGoal.Priority, PausingCharacter);
	assert(NotEqual_ObjectObject(CurrentRotateTowardActorGoal, none));
	CurrentRotateTowardActorGoal.AddRef();
	CurrentRotateTowardActorGoal.postGoal(self);
	return;
}

function AimAround()
{
	CurrentAimAroundGoal = Class'SwatAICommon.AimAroundGoal'.static.Allocate(self).;
	construct_AI_ResourceFloatFloat(weaponResource(), MoveAndClearMinAimHoldTime, MoveAndClearMaxAimHoldTime);
	assert(NotEqual_ObjectObject(CurrentAimAroundGoal, none));
	CurrentAimAroundGoal.AddRef();
	CurrentAimAroundGoal.SetAimInnerFovDegrees(MoveAndClearAimAroundInnerRadius);
	CurrentAimAroundGoal.SetAimOuterFovDegrees(MoveAndClearAimAroundOuterRadius);
	CurrentAimAroundGoal.SetPointTooCloseRadius(MoveAndClearAimAroundPointTooCloseDistance);
	CurrentAimAroundGoal.SetOnlyAimIfMoving(true);
	CurrentAimAroundGoal.postGoal(self);
	return;
}

latent function RotateToClearPointRotation()
{
	CurrentRotateTowardRotationGoal = Class'SwatAICommon.RotateTowardRotationGoal'.static.Allocate(self).;
	Construct_AI_ResourceIntRotator(movementResource(), achievingGoal.Priority, TargetClearPoint.Rotation);
	assert(NotEqual_ObjectObject(CurrentRotateTowardRotationGoal, none));
	CurrentRotateTowardRotationGoal.AddRef();
	CurrentRotateTowardRotationGoal.postGoal(self);
	waitForGoal(CurrentRotateTowardRotationGoal);
	CurrentRotateTowardRotationGoal.unPostGoal(self);
	CurrentRotateTowardRotationGoal.Release();
	CurrentRotateTowardRotationGoal = none;
	return;
}

function BuildClearRoute()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, TargetClearPoint.ClearRoutePoints.Length))
	{
		ClearRoute[ClearRoute.Length] = TargetClearPoint.ClearRoutePoints[i];
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	ClearRoute[ClearRoute.Length] = TargetClearPoint;
	assert(Greater_IntInt(ClearRoute.Length, 0));
	return;
}

latent function MoveToClearRoutePoint(NavigationPoint ClearRoutePoint)
{
	assert(NotEqual_ObjectObject(ClearRoutePoint, none));
	CurrentMoveToActorGoal = Class'SwatAICommon.MoveToActorGoal'.static.Allocate(self).;
	construct_AI_ResourceIntActor(movementResource(), achievingGoal.Priority, ClearRoutePoint);
	assert(NotEqual_ObjectObject(CurrentMoveToActorGoal, none));
	CurrentMoveToActorGoal.AddRef();
	CurrentMoveToActorGoal.SetShouldWalkEntireMove(false);
	CurrentMoveToActorGoal.SetWalkThreshold(0.0000000);
	CurrentMoveToActorGoal.SetRotateTowardsPointsDuringMovement(true);
	CurrentMoveToActorGoal.postGoal(self);
	J0x9F:

	if(Not_PreBool(CurrentMoveToActorGoal.hasCompleted()))
	{
		if(AndAnd_BoolBool(AndAnd_BoolBool(EqualEqual_ObjectObject(CurrentAimAroundGoal, none), Not_PreBool(HasCurrentAssignment())), m_pawn.IsInRoom(TargetClearPoint.GetRoomName(m_pawn))))
		{
			clearDummyWeaponGoal();
			AimAround();
		}
		yield();
		// [Loop Continue]
		goto J0x9F;
	}
	CurrentMoveToActorGoal.unPostGoal(self);
	CurrentMoveToActorGoal.Release();
	CurrentMoveToActorGoal = none;
	return;
}

latent function MoveToNextClearRoutePoint()
{
	local NavigationPoint NextClearRoutePoint;

	NextClearRoutePoint = ClearRoute[CurrentClearRouteIndex];
	assert(NotEqual_ObjectObject(NextClearRoutePoint, none));
	MoveToClearRoutePoint(NextClearRoutePoint);
	return;
}

latent function MoveToClearRoutePoints()
{
	BuildClearRoute();
	SetupDistanceToUncomplaintCharactersSensor();
	CurrentClearRouteIndex = 0;
	J0x13:

	if(Less_IntInt(CurrentClearRouteIndex, ClearRoute.Length))
	{
		if(Not_PreBool(bPauseMovement))
		{
			MoveToNextClearRoutePoint();
		}
		if(bPauseMovement)
		{
			Pause();
		}
		else
		{
			AddAdd_PreInt(CurrentClearRouteIndex);
		}
		// [Loop Continue]
		goto J0x13;
	}
	return;
}

private function bool IsClearPointOnSameSideAsCommandOrigin()
{
	local ISwatDoor Door;

	Door = ISwatDoor(TargetClearPoint.ParentDoor);
	assert(NotEqual_ObjectObject(Door, none));
	if(Door.PointIsToMyLeft(CommandOrigin))
	{
		return EqualEqual_NameName(Door.GetLeftRoomName(), TargetClearPoint.GetRoomName(m_pawn));
	}
	else
	{
		return EqualEqual_NameName(Door.GetRightRoomName(), TargetClearPoint.GetRoomName(m_pawn));
	}
	return;
}

private function bool HasCurrentAssignment()
{
	local Pawn CurrentAssignment;

	CurrentAssignment = ISwatOfficer(m_pawn).GetOfficerCommanderAction().GetCurrentAssignment();
	return AndAnd_BoolBool(Class'Engine.Pawn'.static.checkConscious(CurrentAssignment), OrOr_BoolBool(CurrentAssignment.IsA('SwatPlayer'), AndAnd_BoolBool(Not_PreBool(ISwatAI(CurrentAssignment).IsCompliant()), Not_PreBool(ISwatAI(CurrentAssignment).IsArrested()))));
	return;
}

private function bool ShouldAnnounceClear()
{
	return AndAnd_BoolBool(bShouldAnnounceClear, Not_PreBool(HasCurrentAssignment()));
	return;
}

function bool IsRotatedToClearPointRotation()
{
	return EqualEqual_IntInt(WrapAngle0To2Pi(ISwatAI(m_pawn).GetAimOrientation().Yaw), WrapAngle0To2Pi(int(ISwatAI(m_pawn).GetAnimBaseYaw())));
	return;
}

state Running
{Begin:

	if(AndAnd_BoolBool(Not_PreBool(HasCurrentAssignment()), weaponResource().requiredResourcesAvailable(0, 84)))
	{
		useResources(Class'Tyrion.AI_Resource'.2, 84);
	}
	MoveToClearRoutePoints();
	if(NotEqual_ObjectObject(CurrentAimAroundGoal, none))
	{
		CurrentAimAroundGoal.unPostGoal(self);
		CurrentAimAroundGoal.Release();
		CurrentAimAroundGoal = none;
		if(AndAnd_BoolBool(Not_PreBool(HasCurrentAssignment()), weaponResource().requiredResourcesAvailable(0, 84)))
		{
			useResources(Class'Tyrion.AI_Resource'.2, 84);
		}
	}
	if(Not_PreBool(HasCurrentAssignment()))
	{
		RotateToClearPointRotation();
		if(Not_PreBool(HasCurrentAssignment()))
		{
			if(ShouldAnnounceClear())
			{
				ISwatOfficer(m_pawn).GetOfficerSpeechManagerAction().TriggerClearAnnouncement();
			}
			useResources(Class'Tyrion.AI_Resource'.4, 84);
			EndHoldClearPositionTime = Add_FloatFloat(Level.TimeSeconds, RandRange(MinHoldClearPositionTime, MaxHoldClearPositionTime));
			J0x11B:

			if(AndAnd_BoolBool(AndAnd_BoolBool(Class'Engine.Pawn'.static.checkConscious(m_pawn), Less_FloatFloat(Level.TimeSeconds, EndHoldClearPositionTime)), Not_PreBool(HasCurrentAssignment())))
			{
				if(AndAnd_BoolBool(Not_PreBool(m_pawn.ReachedDestination(TargetClearPoint)), Not_PreBool(m_pawn.IsAvoidingCollision())))
				{
					clearDummyMovementGoal();
					MoveToClearRoutePoint(TargetClearPoint);
					useResources(Class'Tyrion.AI_Resource'.4, 84);
				}
				if(Not_PreBool(IsRotatedToClearPointRotation()))
				{
					clearDummyMovementGoal();
					RotateToClearPointRotation();
					useResources(Class'Tyrion.AI_Resource'.4, 84);
				}
				Sleep(0.3330000);
				// [Loop Continue]
				goto J0x11B;
			}
		}
	}
	succeed();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.MoveAndClearGoal'
}