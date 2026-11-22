class MoveToLocationAction extends MoveToActionBase
	collapsecategories
	hidecategories(Object,InternalParameters);

function Vector GetDestination()
{
	assert(NotEqual_ObjectObject(MoveToLocationGoal(achievingGoal), none));
	return MoveToLocationGoal(achievingGoal).GetDestination();
	return;
}

protected function bool IsInPosition()
{
	local bool bIsInPosition;

	SetOverriddenMoveToThreshold();
	bIsInPosition = m_pawn.ReachedLocation(GetDestination());
	ResetOverriddenMoveToThreshold();
	return bIsInPosition;
	return;
}

protected function SetDistanceSensorParameters()
{
	if(EqualEqual_ObjectObject(WalkThresholdTarget, none))
	{
		DistanceSensor.SetIgnoreHeightDistance(true);
		DistanceSensor.setParameters_FloatVectorBool(WalkThreshold, MoveToLocationGoal(achievingGoal).GetDestination(), ShouldUseNavigationDistanceOnSensor());
	}
	else
	{
		DistanceSensor.setParameters_FloatActorBool(WalkThreshold, WalkThresholdTarget, ShouldUseNavigationDistanceOnSensor());
	}
	return;
}

latent function MoveToLocation()
{
	local bool succeeded;
	local Vector Destination;
	local Actor currentDestination;
	local bool bCloseFromLeft;

	Destination = GetDestination();
	DropToGround();
	succeeded = false;
	J0x1A:

	if(Not_PreBool(ShouldStopMoving()))
	{
		if(m_pawn.IsLocationReachable(Destination))
		{
			m_pawn.ClearRouteCache();
			m_pawn.Controller.Destination = Destination;
			m_pawn.Controller.RouteGoal = none;
			m_pawn.Controller.RouteGoalPoint = Destination;
			RotateTowardsMovementPoint_Vector(Destination);
			MoveTowardLocation(m_pawn.Controller.Destination);
			if(OrOr_BoolBool(bAllowDirectMoveFailure, IsInPosition()))
			{
				succeeded = true;
				// [Explicit Break]
				goto J0x31A;
			}
		}
		else
		{
			currentDestination = FindPathToLocation(Destination, bAcceptNearbyPath);
			if(NotEqual_ObjectObject(currentDestination, none))
			{
				m_pawn.Controller.MoveTarget = currentDestination;
				RotateTowardsMovementActor_Actor(currentDestination);
				if(currentDestination.IsA('Door'))
				{
					bCloseFromLeft = Not_PreBool(ISwatDoor(currentDestination).PointIsToMyLeft(m_pawn.Location));
					if(m_pawn.logTyrion)
					{
						Log(Concat_StrStr(Concat_StrStr(string(m_pawn.Name), " calling NavigateThroughDoor - bCloseFromLeft is: "), string(bCloseFromLeft)));
					}
					NavigateThroughDoor(Door(currentDestination));
					m_pawn.Controller.MoveTarget = currentDestination;
					if(AndAnd_BoolBool(AndAnd_BoolBool(Door(currentDestination).IsClosed(), Not_PreBool(Door(currentDestination).IsOpening())), Not_PreBool(ISwatDoor(currentDestination).IsBroken())))
					{
						yield();
						// [Explicit Continue]
						goto J0x317;
					}
				}
				assert(EqualEqual_ObjectObject(m_pawn.Controller.MoveTarget, currentDestination));
				MoveTowardActor(m_pawn.Controller.MoveTarget);
				assert(NotEqual_ObjectObject(m_pawn.Controller.MoveTarget, none));
				assert(EqualEqual_ObjectObject(m_pawn.Controller.MoveTarget, currentDestination));
				if(ShouldCloseDoor(currentDestination))
				{
					PostCloseDoorGoal(Door(currentDestination), bCloseFromLeft);
				}
				if(HasReachedNearbyPath(currentDestination))
				{
					succeeded = true;
					// [Explicit Break]
					goto J0x31A;
				}
			}
			else
			{
				// [Explicit Break]
				goto J0x31A;
			}
		}
		J0x317:

		// [Loop Continue]
		goto J0x1A;
	}
	J0x31A:

	if(ShouldStopMoving())
	{
		succeeded = true;
	}
	ReportMoveToOutcome(succeeded);
	return;
}

state Running
{Begin:

	MoveToLocation();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.MoveToLocationGoal'
}