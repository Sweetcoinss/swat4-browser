class MoveToActionBase extends SwatMovementAction implements ISensorNotification
	abstract
	native
	collapsecategories
	hidecategories(Object,InternalParameters);

const kMovementTimeOutFudge = 2.0;
const kMovementPointZOffset = 32.0;

var private bool bHasRotatedTowardFirstPoint;
var private bool bWasAvoidingCollision;
var private bool bIsMoving;
var private float MovementTimeOut;
var(Parameters) bool bShouldCrouch;
var(Parameters) float MoveToThreshold;
var(Parameters) bool bRotateTowardsFirstPoint;
var(Parameters) bool bRotateTowardsPointsDuringMovement;
var(Parameters) bool bAcceptNearbyPath;
var(Parameters) bool bShouldCloseOpenedDoors;
var(Parameters) bool bShouldNotCloseInitiallyOpenDoors;
var(Parameters) bool bAllowDirectMoveFailure;
var(Parameters) bool bUseCoveredPaths;
var(Parameters) bool bOpenDoorsFrantically;
var(Parameters) bool bUseNavigationDistanceOnSensor;
var(Parameters) bool bShouldSucceedWhenDestinationBlocked;
var(Parameters) float WalkThreshold;
var(Parameters) Actor WalkThresholdTarget;
var private float OriginalMoveToThreshold;
var private float OverriddenMoveToThreshold;
var private OpenDoorGoal CurrentOpenDoorGoal;
var private CloseDoorGoal CurrentCloseDoorGoal;
var DistanceSensor DistanceSensor;

function float selectionHeuristic(AI_Goal Goal)
{
	if(EqualEqual_ObjectObject(satisfiesGoal, Goal.Class))
	{
		return 1.0000000;
	}
	else
	{
		return 0.1000000;
	}
	return;
}

function goalNotAchievedCB(AI_Goal Goal, AI_Action Child, ActionBase.ACT_ErrorCodes errorCode)
{
	super(AI_Action).goalNotAchievedCB(Goal, Child, errorCode);
	if(AndAnd_BoolBool(NotEqual_IntInt(int(errorCode), int(3)), OrOr_BoolBool(EqualEqual_ObjectObject(Goal, CurrentOpenDoorGoal), EqualEqual_ObjectObject(Goal, CurrentCloseDoorGoal))))
	{
		instantFail(errorCode);
	}
	return;
}

function Vector GetDestination()
{
	assert(NotEqual_ObjectObject(IMoveToInformation(achievingGoal), none));
	return IMoveToInformation(achievingGoal).GetDestination();
	return;
}

event bool ShouldStopMoving()
{
	assert(NotEqual_ObjectObject(achievingGoal, none));
	AssertWithDescription(achievingGoal.IsA('MoveToGoalBase'), At_StrStr("achievingGoal is:", string(achievingGoal)));
	return OrOr_BoolBool(MoveToGoalBase(achievingGoal).ShouldStopMovingDelegate(m_pawn), IsInPosition());
	return;
}

protected function bool IsInPosition()
{
	return false;
	return;
}

event bool ShouldWalk()
{
	assert(NotEqual_ObjectObject(achievingGoal, none));
	AssertWithDescription(achievingGoal.IsA('MoveToGoalBase'), At_StrStr("achievingGoal is:", string(achievingGoal)));
	return MoveToGoalBase(achievingGoal).ShouldWalkDelegate();
	return;
}

protected function ActivateDistanceSensor()
{
	DistanceSensor = DistanceSensor(Class'Tyrion.AI_Sensor'.static.activateSensor(self, Class'SwatAICommon.DistanceSensor', movementResource(), 0.0000000, 1000000.0000000));
	assert(NotEqual_ObjectObject(DistanceSensor, none));
	SetDistanceSensorParameters();
	return;
}

protected function SetDistanceSensorParameters()
{
	assert(false);
	return;
}

protected function bool ShouldUseNavigationDistanceOnSensor()
{
	return bUseNavigationDistanceOnSensor;
	return;
}

function OnSensorMessage(AI_Sensor sensor, AI_SensorData Value, Object userData)
{
	if(m_pawn.logTyrion)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("MoveToActionBase received sensor message from ", string(sensor.Name)), " value is "), string(Value.integerData)));
	}
	assert(EqualEqual_ObjectObject(sensor, DistanceSensor));
	HandleDistanceSensorMessage(Value);
	return;
}

function HandleDistanceSensorMessage(AI_SensorData Value)
{
	local bool bShouldWalk;

	if(Not_PreBool(MoveToGoalBase(achievingGoal).ShouldWalkEntireMove()))
	{
		if(EqualEqual_IntInt(Value.integerData, 1))
		{
			bShouldWalk = true;
		}
		else
		{
			bShouldWalk = false;
		}
		MoveToGoalBase(achievingGoal).SetShouldWalk(bShouldWalk);
		SetMovement(bShouldWalk, bShouldCrouch);
	}
	return;
}

event SetMovement(bool bWalkWhileMoving, bool bCrouchWhileMoving)
{
	if(NotEqual_BoolBool(m_pawn.bIsWalking, bWalkWhileMoving))
	{
		m_pawn.bIsWalking = bWalkWhileMoving;
	}
	if(NotEqual_BoolBool(m_pawn.bWantsToCrouch, bCrouchWhileMoving))
	{
		m_pawn.ShouldCrouch(bCrouchWhileMoving);
	}
	return;
}

// Export UMoveToActionBase::execMoveTowardActor(FFrame&, void* const)
native final latent function MoveTowardActor(Actor Actor, optional Actor viewFocus, optional float DestinationOffset, optional bool bUseStrafing);

// Export UMoveToActionBase::execMoveTowardLocation(FFrame&, void* const)
native final latent function MoveTowardLocation(Vector Location, optional Actor viewFocus);

// Export UMoveToActionBase::execFindPathToActor(FFrame&, void* const)
native final function Actor FindPathToActor(Actor Actor, bool bAcceptNearbyPath);

// Export UMoveToActionBase::execFindPathToLocation(FFrame&, void* const)
native final function Actor FindPathToLocation(Vector Location, bool bAcceptNearbyPath);

function initAction(AI_Resource R, AI_Goal Goal)
{
	local ISwatAI.EUpperBodyAnimBehavior MovementUpperBodyAimBehavior;

	super.initAction(R, Goal);
	OriginalMoveToThreshold = m_pawn.ReachedDestinationThreshold;
	OverriddenMoveToThreshold = MoveToThreshold;
	if(bUseCoveredPaths)
	{
		ISwatAI(m_pawn).EnableFavorCoveredPath(SwatCharacterResource(m_pawn.CharacterAI).CommonSensorAction.GetVisionSensor().pawns);
	}
	ActivateDistanceSensor();
	MovementUpperBodyAimBehavior = ISwatAI(m_pawn).GetMovementUpperBodyAimBehavior();
	ISwatAI(m_pawn).SetUpperBodyAnimBehavior(MovementUpperBodyAimBehavior, 5);
	return;
}

function cleanup()
{
	super.cleanup();
	ISwatAI(m_pawn).UnsetUpperBodyAnimBehavior(5);
	if(NotEqual_ObjectObject(CurrentOpenDoorGoal, none))
	{
		CurrentOpenDoorGoal.Release();
		CurrentOpenDoorGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentCloseDoorGoal, none))
	{
		CurrentCloseDoorGoal.Release();
		CurrentCloseDoorGoal = none;
	}
	if(NotEqual_ObjectObject(DistanceSensor, none))
	{
		DistanceSensor.__UpdateTarget__Delegate = None;
		DistanceSensor.deactivateSensor(self);
		DistanceSensor = none;
	}
	MoveToGoalBase(achievingGoal).__ShouldStopMovingDelegate__Delegate = None;
	MoveToGoalBase(achievingGoal).__ShouldWalkDelegate__Delegate = None;
	ResetOverriddenMoveToThreshold();
	ISwatAI(m_pawn).DisableFavorCoveredPath();
	m_pawn.ClearRouteCache();
	return;
}

protected function SetOverriddenMoveToThreshold()
{
	if(Greater_FloatFloat(OverriddenMoveToThreshold, 0.0000000))
	{
		m_pawn.ReachedDestinationThreshold = OverriddenMoveToThreshold;
	}
	return;
}

protected function ResetOverriddenMoveToThreshold()
{
	m_pawn.ReachedDestinationThreshold = OriginalMoveToThreshold;
	return;
}

overloaded function RotateTowardsMovementActor()
{
	return;
}

overloaded latent function RotateTowardsMovementActor(Actor MovementActor)
{
	assert(NotEqual_ObjectObject(MoveToGoalBase(achievingGoal), none));
	if(ShouldRotateTowardsPointsDuringMovement())
	{
		if(AndAnd_BoolBool(bRotateTowardsFirstPoint, Not_PreBool(bHasRotatedTowardFirstPoint)))
		{
			RotateTowardActor(MovementActor);
			bHasRotatedTowardFirstPoint = true;
		}
		if(bRotateTowardsPointsDuringMovement)
		{
			ISwatAI(m_pawn).AimAtActor(MovementActor);
		}
	}
	return;
}

overloaded function RotateTowardsMovementPoint()
{
	return;
}

overloaded latent function RotateTowardsMovementPoint(Vector MovementPoint)
{
	assert(NotEqual_ObjectObject(MoveToGoalBase(achievingGoal), none));
	if(ShouldRotateTowardsPointsDuringMovement())
	{
		AddEqual_FloatFloat(MovementPoint.Z, 32.0000000);
		if(AndAnd_BoolBool(bRotateTowardsFirstPoint, Not_PreBool(bHasRotatedTowardFirstPoint)))
		{
			RotateTowardPoint(MovementPoint);
			bHasRotatedTowardFirstPoint = true;
		}
		if(bRotateTowardsPointsDuringMovement)
		{
			ISwatAI(m_pawn).AimAtPoint(MovementPoint);
		}
	}
	return;
}

private function bool ShouldRotateTowardsPointsDuringMovement()
{
	local AI_Goal AimAroundGoal;

	AimAroundGoal = AI_Resource(m_pawn.WeaponAI).findGoalByName("AimAround");
	return OrOr_BoolBool(OrOr_BoolBool(EqualEqual_ObjectObject(AimAroundGoal, none), AimAroundGoal.hasCompleted()), Not_PreBool(AimAroundGoal.beingAchieved()));
	return;
}

function bool HasReachedNearbyPath(Actor ReachedActor)
{
	return AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(bAcceptNearbyPath, m_pawn.Controller.bNearbyPathFound), EqualEqual_ObjectObject(ReachedActor, m_pawn.Controller.RouteGoal)), m_pawn.ReachedDestination(ReachedActor));
	return;
}

protected latent function ReportMoveToOutcome(bool succeeded)
{
	if(EqualEqual_BoolBool(succeeded, true))
	{
		succeed();
	}
	else
	{
		if(m_pawn.logTyrion)
		{
			Log(Concat_StrStr(Concat_StrStr("[AI WARNING] - ", string(m_pawn.Name)), " cannot pathfind to our current destination!"));
		}
		fail(4);
	}
	return;
}

private latent function PostOpenDoorGoal(Door Target)
{
	if(NotEqual_ObjectObject(CurrentOpenDoorGoal, none))
	{
		CurrentOpenDoorGoal.unPostGoal(self);
		CurrentOpenDoorGoal.Release();
		CurrentOpenDoorGoal = none;
	}
	CurrentOpenDoorGoal = Class'SwatAICommon.OpenDoorGoal'.static.Allocate(self).;
	construct_AI_ResourceIntDoor(AI_Resource(m_pawn.MovementAI), Add_IntInt(achievingGoal.Priority, 1), Target);
	assert(NotEqual_ObjectObject(CurrentOpenDoorGoal, none));
	CurrentOpenDoorGoal.AddRef();
	CurrentOpenDoorGoal.SetShouldWalkEntireMove(ShouldWalk());
	CurrentOpenDoorGoal.SetWalkThreshold(0.0000000);
	CurrentOpenDoorGoal.SetOpenFrantically(bOpenDoorsFrantically);
	CurrentOpenDoorGoal.SetRotateTowardsPointsDuringMovement(true);
	CurrentOpenDoorGoal.postGoal(self);
	waitForGoal(CurrentOpenDoorGoal);
	CurrentOpenDoorGoal.unPostGoal(self);
	CurrentOpenDoorGoal.Release();
	CurrentOpenDoorGoal = none;
	return;
}

function bool ShouldCloseDoor(Actor Destination)
{
	local ISwatDoor SwatDoorDestination;
	local Door DoorDestination;
	local bool bPointAheadToLeft;

	if(AndAnd_BoolBool(Destination.IsA('Door'), bShouldCloseOpenedDoors))
	{
		assert(Destination.IsA('ISwatDoor'));
		SwatDoorDestination = ISwatDoor(Destination);
		DoorDestination = Door(Destination);
		if(AndAnd_BoolBool(AndAnd_BoolBool(Not_PreBool(Door(Destination).IsEmptyDoorway()), Not_PreBool(SwatDoorDestination.IsBroken())), OrOr_BoolBool(DoorDestination.IsOpen(), DoorDestination.IsOpening())))
		{
			if(OrOr_BoolBool(Not_PreBool(bShouldNotCloseInitiallyOpenDoors), Not_PreBool(ISwatDoor(Destination).WasDoorInitiallyOpen())))
			{
				if(EqualEqual_ObjectObject(Destination, m_pawn.Controller.RouteCache[0]))
				{
					if(NotEqual_ObjectObject(m_pawn.Controller.RouteCache[1], none))
					{
						bPointAheadToLeft = SwatDoorDestination.ActorIsToMyLeft(m_pawn.Controller.RouteCache[1]);
						return OrOr_BoolBool(AndAnd_BoolBool(DoorDestination.IsOpen(), EqualEqual_BoolBool(DoorDestination.IsOpenLeft(), bPointAheadToLeft)), AndAnd_BoolBool(DoorDestination.IsOpening(), EqualEqual_BoolBool(DoorDestination.IsOpeningLeft(), bPointAheadToLeft)));
					}
					else
					{
						if(NotEqual_VectorVector(Destination.Location, GetDestination()))
						{
							bPointAheadToLeft = SwatDoorDestination.PointIsToMyLeft(GetDestination());
							return OrOr_BoolBool(AndAnd_BoolBool(DoorDestination.IsOpen(), EqualEqual_BoolBool(DoorDestination.IsOpenLeft(), bPointAheadToLeft)), AndAnd_BoolBool(DoorDestination.IsOpening(), EqualEqual_BoolBool(DoorDestination.IsOpeningLeft(), bPointAheadToLeft)));
						}
					}
				}
			}
		}
	}
	return false;
	return;
}

protected latent function PostCloseDoorGoal(Door Target, bool bCloseFromLeft)
{
	if(NotEqual_ObjectObject(CurrentCloseDoorGoal, none))
	{
		CurrentCloseDoorGoal.unPostGoal(self);
		CurrentCloseDoorGoal.Release();
		CurrentCloseDoorGoal = none;
	}
	CurrentCloseDoorGoal = Class'SwatAICommon.CloseDoorGoal'.static.Allocate(self).;
	construct_AI_ResourceIntDoor(AI_Resource(m_pawn.MovementAI), Add_IntInt(achievingGoal.Priority, 1), Target);
	assert(NotEqual_ObjectObject(CurrentCloseDoorGoal, none));
	CurrentCloseDoorGoal.AddRef();
	CurrentCloseDoorGoal.SetShouldWalkEntireMove(ShouldWalk());
	CurrentCloseDoorGoal.SetCloseDoorFromBehind(true);
	CurrentCloseDoorGoal.SetCloseDoorFromLeft(bCloseFromLeft);
	CurrentCloseDoorGoal.SetRotateTowardsPointsDuringMovement(true);
	CurrentCloseDoorGoal.SetWalkThreshold(0.0000000);
	CurrentCloseDoorGoal.postGoal(self);
	waitForGoal(CurrentCloseDoorGoal);
	CurrentCloseDoorGoal.unPostGoal(self);
	CurrentCloseDoorGoal.Release();
	CurrentCloseDoorGoal = none;
	return;
}

protected latent function NavigateThroughDoor(Door Target)
{
	local ISwatDoor SwatDoorTarget;
	local Pawn PendingDoorInteractor;

	SwatDoorTarget = ISwatDoor(Target);
	assert(NotEqual_ObjectObject(SwatDoorTarget, none));
	PendingDoorInteractor = SwatDoorTarget.GetPendingInteractor();
	if(m_pawn.logTyrion)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(m_pawn.Name), " attempting to navigate through door "), string(Target.Name)), " IsClosed() "), string(Target.IsClosed())), " IsClosing() "), string(Target.IsClosing())), " IsBroken "), string(SwatDoorTarget.IsBroken())), " PendingDoorInteractor: "), string(PendingDoorInteractor)));
	}
	J0x11C:

	if(Target.IsClosing())
	{
		yield();
		// [Loop Continue]
		goto J0x11C;
	}
	if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(Target.IsClosed(), Not_PreBool(SwatDoorTarget.IsBroken())), Not_PreBool(Target.IsOpening())), OrOr_BoolBool(EqualEqual_ObjectObject(PendingDoorInteractor, none), EqualEqual_ObjectObject(PendingDoorInteractor, m_pawn))))
	{
		PostOpenDoorGoal(Target);
	}
	return;
}
