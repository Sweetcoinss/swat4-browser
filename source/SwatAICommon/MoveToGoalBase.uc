class MoveToGoalBase extends AI_MovementGoal implements IMoveToInformation
	abstract
	collapsecategories
	hidecategories(Object,InternalParameters);

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
var private bool bShouldWalkEntireMove;
var private bool bShouldWalk;
//var delegate<ShouldStopMovingDelegate> __ShouldStopMovingDelegate__Delegate;
//var delegate<ShouldWalkDelegate> __ShouldWalkDelegate__Delegate;

overloaded function Construct(AI_Resource R, int PRI)
{
	construct_AI_Resource(R);
	Priority = PRI;
	return;
}

delegate bool ShouldStopMovingDelegate(Pawn MovingPawn)
{
	return false;
	return;
}

delegate bool ShouldWalkDelegate()
{
	return bShouldWalk;
	return;
}

function bool ShouldWalkEntireMove()
{
	return bShouldWalkEntireMove;
	return;
}

function SetRotateTowardsFirstPoint(bool bInRotateTowardsFirstPoint)
{
	bRotateTowardsFirstPoint = bInRotateTowardsFirstPoint;
	return;
}

function SetRotateTowardsPointsDuringMovement(bool bInRotateTowardsPointsDuringMovement)
{
	bRotateTowardsPointsDuringMovement = bInRotateTowardsPointsDuringMovement;
	return;
}

function SetAcceptNearbyPath(bool bInAcceptNearbyPath)
{
	bAcceptNearbyPath = bInAcceptNearbyPath;
	return;
}

function SetShouldCloseOpenedDoors(bool bInShouldCloseOpenedDoors)
{
	bShouldCloseOpenedDoors = bInShouldCloseOpenedDoors;
	return;
}

function SetShouldNotCloseInitiallyOpenDoors(bool bInShouldNotCloseInitiallyOpenDoors)
{
	bShouldNotCloseInitiallyOpenDoors = bInShouldNotCloseInitiallyOpenDoors;
	return;
}

function SetAllowDirectMoveFailure(bool bInAllowDirectMoveFailure)
{
	bAllowDirectMoveFailure = bInAllowDirectMoveFailure;
	return;
}

function SetShouldCrouch(bool bInShouldCrouch)
{
	bShouldCrouch = bInShouldCrouch;
	return;
}

function SetMoveToThreshold(float inMoveToThreshold)
{
	AssertWithDescription(Greater_FloatFloat(inMoveToThreshold, 0.0000000), Concat_StrStr(Concat_StrStr("MoveToGoalBase::SetMoveToThreshold - inMoveToThreshold (", string(inMoveToThreshold)), ") must be greater than 0.0!"));
	MoveToThreshold = inMoveToThreshold;
	return;
}

function SetUseCoveredPaths()
{
	bUseCoveredPaths = true;
	return;
}

function SetOpenDoorsFrantically(bool bInOpenDoorsFrantically)
{
	bOpenDoorsFrantically = bInOpenDoorsFrantically;
	return;
}

function SetWalkThreshold(float inWalkThreshold)
{
	assert(GreaterEqual_FloatFloat(inWalkThreshold, 0.0000000));
	WalkThreshold = inWalkThreshold;
	return;
}

function SetWalkThresholdTarget(Actor inTarget)
{
	assert(NotEqual_ObjectObject(inTarget, none));
	WalkThresholdTarget = inTarget;
	return;
}

function SetShouldWalkEntireMove(bool bInShouldWalkEntireMove)
{
	bShouldWalkEntireMove = bInShouldWalkEntireMove;
	bShouldWalk = bInShouldWalkEntireMove;
	return;
}

function SetShouldWalk(bool bInShouldWalk)
{
	if(Not_PreBool(bShouldWalkEntireMove))
	{
		bShouldWalk = bInShouldWalk;
	}
	return;
}

function SetUseNavigationDistanceOnSensor(bool inUseNavigationDistanceOnSensor)
{
	bUseNavigationDistanceOnSensor = inUseNavigationDistanceOnSensor;
	return;
}

function SetShouldSucceedWhenDestinationBlocked(bool inShouldSucceedWhenDestinationBlocked)
{
	bShouldSucceedWhenDestinationBlocked = inShouldSucceedWhenDestinationBlocked;
	return;
}

defaultproperties
{
	WalkThreshold=64.0000000
}