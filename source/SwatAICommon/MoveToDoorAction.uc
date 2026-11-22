class MoveToDoorAction extends MoveToLocationAction
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

var private Vector Destination;
var private Vector OpenPoint;
var(Parameters) Door TargetDoor;
var(Parameters) bool bPreferSides;
var config float MoveToDoorThreshold;

protected function SetDistanceSensorParameters()
{
	DistanceSensor.setParameters_FloatActorBool(WalkThreshold, TargetDoor, ShouldUseNavigationDistanceOnSensor());
	return;
}

protected function SetUsageSide(ISwatAI.AIDoorUsageSide inDoorUsageSide)
{
	MoveToDoorGoal(achievingGoal).DoorUsageSide = inDoorUsageSide;
	return;
}

protected function ISwatAI.AIDoorUsageSide GetDoorUsageSide()
{
	return MoveToDoorGoal(achievingGoal).DoorUsageSide;
	return;
}

protected function SetDoorUsageRotation(Rotator inDoorUsageRotation)
{
	MoveToDoorGoal(achievingGoal).DoorUsageRotation = inDoorUsageRotation;
	return;
}

protected function Rotator GetDoorUsageRotation()
{
	return MoveToDoorGoal(achievingGoal).DoorUsageRotation;
	return;
}

event bool ShouldStopMoving()
{
	return false;
	return;
}

function Vector GetDestination()
{
	return Destination;
	return;
}

protected function bool IsInPosition()
{
	return m_pawn.ReachedLocation(Destination);
	return;
}

latent function MoveToDoor(Door Target, Vector inDestination)
{
	OverriddenMoveToThreshold = MoveToDoorThreshold;
	SetOverriddenMoveToThreshold();
	Destination = inDestination;
	MoveToLocation();
	ResetOverriddenMoveToThreshold();
	m_pawn.DisableCollisionAvoidance();
	RotateTowardRotation(GetDoorUsageRotation());
	return;
}

latent function MoveToOpenDoor(Door Target)
{
	local ISwatDoor SwatDoorTarget;
	local Rotator DoorUsageRotation;

	SwatDoorTarget = ISwatDoor(Target);
	assert(NotEqual_ObjectObject(SwatDoorTarget, none));
	SetUsageSide(SwatDoorTarget.GetOpenPositions(m_pawn, bPreferSides, OpenPoint, DoorUsageRotation));
	SetDoorUsageRotation(DoorUsageRotation);
	if(m_pawn.logTyrion)
	{
		Log(At_StrStr(At_StrStr(At_StrStr(At_StrStr(string(m_pawn), " moving to OpenPoint:"), string(OpenPoint)), " Target.Location is:"), string(Target.Location)));
	}
	MoveToDoor(Target, OpenPoint);
	if(m_pawn.logTyrion)
	{
		Log(At_StrStr(At_StrStr(string(m_pawn), " finished moving to OpenPoint:"), string(OpenPoint)));
	}
	return;
}

latent function MoveToCloseDoor(Door Target, bool bCloseFromLeftSide, bool bCloseFromBehind)
{
	local Vector ClosePoint;
	local ISwatDoor SwatDoorTarget;

	SwatDoorTarget = ISwatDoor(Target);
	assert(NotEqual_ObjectObject(SwatDoorTarget, none));
	ClosePoint = SwatDoorTarget.GetClosePoint(bCloseFromLeftSide);
	if(bCloseFromBehind)
	{
		SetDoorUsageRotation(Rotator(Subtract_VectorVector(ClosePoint, Target.Location)));
	}
	else
	{
		SetDoorUsageRotation(Rotator(Subtract_VectorVector(Target.Location, ClosePoint)));
	}
	MoveToDoor(Target, ClosePoint);
	return;
}

protected latent function RotateAndLockToDoorUsageRotation()
{
	ISwatAI(m_pawn).AimToRotation(GetDoorUsageRotation());
	ISwatAI(m_pawn).LockAim();
	FinishRotation();
	ISwatAI(m_pawn).AnimSnapBaseToAim();
	return;
}

protected latent function ReportMoveToOutcome(bool succeeded)
{
	if(EqualEqual_BoolBool(succeeded, false))
	{
		if(m_pawn.logTyrion)
		{
			Log(Concat_StrStr(Concat_StrStr("[AI WARNING] - ", string(m_pawn.Name)), " cannot pathfind to our current destination!"));
		}
		fail(4);
	}
	return;
}

state Running
{Begin:

	MoveToOpenDoor(TargetDoor);
	succeed();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.MoveToDoorGoal'
}