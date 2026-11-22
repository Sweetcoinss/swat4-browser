class MoveInFormationAction extends MoveToActorAction
	collapsecategories
	hidecategories(Object,InternalParameters);

const kDistanceSensorCollisionHeightMultiplier = 2.0;

var(Parameters) float InnerMoveToThreshold;
var(Parameters) float OuterMoveToThreshold;
var(Parameters) float InnerWalkThreshold;
var(Parameters) float OuterWalkThreshold;
var private Pawn FormationDestination;

function Actor GetDestinationActor()
{
	assert(NotEqual_ObjectObject(FormationDestination, none));
	return FormationDestination;
	return;
}

function Vector GetDestination()
{
	return FormationDestination.Location;
	return;
}

protected function SetDistanceSensorParameters()
{
	SetFormationDestination();
	WalkThresholdTarget = FormationDestination;
	DistanceSensor.setParameters_FloatActorBool(WalkThreshold, WalkThresholdTarget, ShouldUseNavigationDistanceOnSensor());
	DistanceSensor.SetCollisionHeightMultiplier(2.0000000);
	DistanceSensor.__UpdateTarget__Delegate = UpdateDistanceSensorTarget;
	return;
}

private function SetFormationDestination()
{
	local Formation CurrentFormation;

	CurrentFormation = ISwatOfficer(m_pawn).GetCurrentFormation();
	assert(NotEqual_ObjectObject(CurrentFormation, none));
	FormationDestination = CurrentFormation.GetDestinationForMember(m_pawn);
	assert(NotEqual_ObjectObject(FormationDestination, none));
	return;
}

function UpdateDistanceSensorTarget()
{
	SetFormationDestination();
	WalkThresholdTarget = FormationDestination;
	DistanceSensor.ResetTargetActor(WalkThresholdTarget);
	return;
}

function HandleDistanceSensorMessage(AI_SensorData Value)
{
	local Formation CurrentFormation;
	local Pawn PawnInFront;
	local bool bWillWalk, bPawnInFrontIsMoving, bIsWithinRequiredDistance;

	CurrentFormation = ISwatOfficer(m_pawn).GetCurrentFormation();
	assert(NotEqual_ObjectObject(CurrentFormation, none));
	if(CurrentFormation.IsLeader(m_pawn))
	{
	}
	else
	{
		PawnInFront = FormationDestination;
		bIsWithinRequiredDistance = DistanceSensor.IsWithinRequiredDistance();
		WalkThresholdTarget = PawnInFront;
		if(Not_PreBool(bIsWithinRequiredDistance))
		{
			OverriddenMoveToThreshold = OuterMoveToThreshold;
			WalkThreshold = OuterWalkThreshold;
			bWillWalk = false;
		}
		else
		{
			if(AndAnd_BoolBool(bIsWithinRequiredDistance, OrOr_BoolBool(Not_PreBool(bPawnInFrontIsMoving), Not_PreBool(PawnInFront.IsAtRunningSpeed()))))
			{
				OverriddenMoveToThreshold = InnerMoveToThreshold;
				WalkThreshold = InnerWalkThreshold;
				bWillWalk = true;
			}
		}
		DistanceSensor.ResetRequiredDistance(WalkThreshold);
	}
	MoveToGoalBase(achievingGoal).SetShouldWalk(bWillWalk);
	SetMovement(bWillWalk, bShouldCrouch);
	return;
}

function NotifyFinishedMovingToLocation()
{
	local Pawn Leader;
	local Formation CurrentFormation;

	if(DistanceSensor.IsWithinRequiredDistance())
	{
		CurrentFormation = ISwatOfficer(m_pawn).GetCurrentFormation();
		assert(NotEqual_ObjectObject(CurrentFormation, none));
		if(CurrentFormation.IsLeader(m_pawn))
		{
		}
		else
		{
			Leader = CurrentFormation.GetLeader();
			if(AndAnd_BoolBool(Not_PreBool(Leader.IsAtRunningSpeed()), Not_PreBool(m_pawn.bIsWalking)))
			{
				MoveToGoalBase(achievingGoal).SetShouldWalk(true);
				SetMovement(true, bShouldCrouch);
			}
		}
	}
	return;
}

state Running
{Begin:

	MoveToActor();
	NotifyFinishedMovingToLocation();
	yield();
	goto 'Begin';
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.MoveInFormationGoal'
}