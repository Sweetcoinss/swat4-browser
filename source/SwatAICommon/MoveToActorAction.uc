class MoveToActorAction extends MoveToActionBase
	collapsecategories
	hidecategories(Object,InternalParameters);

var private bool bSucceeded;

function Actor GetDestinationActor()
{
	assert(NotEqual_ObjectObject(MoveToActorGoal(achievingGoal), none));
	return MoveToActorGoal(achievingGoal).GetDestinationActor();
	return;
}

function Vector GetDestination()
{
	assert(NotEqual_ObjectObject(MoveToActorGoal(achievingGoal), none));
	return MoveToActorGoal(achievingGoal).GetDestination();
	return;
}

protected function bool IsInPosition()
{
	local bool bIsInPosition;

	SetOverriddenMoveToThreshold();
	bIsInPosition = m_pawn.ReachedDestination(GetDestinationActor());
	ResetOverriddenMoveToThreshold();
	return bIsInPosition;
	return;
}

protected function SetDistanceSensorParameters()
{
	if(EqualEqual_ObjectObject(WalkThresholdTarget, none))
	{
		WalkThresholdTarget = GetDestinationActor();
	}
	if(NotEqual_ObjectObject(WalkThresholdTarget, none))
	{
		DistanceSensor.setParameters_FloatActorBool(WalkThreshold, WalkThresholdTarget, ShouldUseNavigationDistanceOnSensor());
	}
	return;
}

latent function MoveToActor()
{
	local Actor Destination, currentDestination;
	local bool bCloseFromLeft;

	Destination = GetDestinationActor();
	if(NotEqual_ObjectObject(Destination, none))
	{
		DropToGround();
		J0x1D:

		if(AndAnd_BoolBool(Not_PreBool(ShouldStopMoving()), NotEqual_ObjectObject(Destination, none)))
		{
			if(m_pawn.IsActorReachable(Destination))
			{
				m_pawn.ClearRouteCache();
				m_pawn.Controller.RouteGoal = Destination;
				m_pawn.Controller.RouteGoalPoint = vect(0.0000000, 0.0000000, 0.0000000);
				SetOverriddenMoveToThreshold();
				currentDestination = Destination;
			}
			else
			{
				currentDestination = FindPathToActor(Destination, bAcceptNearbyPath);
			}
			if(NotEqual_ObjectObject(currentDestination, none))
			{
				m_pawn.Controller.MoveTarget = currentDestination;
				RotateTowardsMovementActor_Actor(currentDestination);
				if(EqualEqual_ObjectObject(currentDestination, none))
				{
					// [Explicit Break]
					goto J0x35E;
				}
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
						goto J0x35B;
					}
				}
				assert(EqualEqual_ObjectObject(m_pawn.Controller.MoveTarget, currentDestination));
				MoveTowardActor(m_pawn.Controller.MoveTarget);
				if(EqualEqual_ObjectObject(currentDestination, none))
				{
					// [Explicit Break]
					goto J0x35E;
				}
				assert(NotEqual_ObjectObject(m_pawn.Controller.MoveTarget, none));
				assert(EqualEqual_ObjectObject(m_pawn.Controller.MoveTarget, currentDestination));
				if(ShouldCloseDoor(currentDestination))
				{
					PostCloseDoorGoal(Door(currentDestination), bCloseFromLeft);
					m_pawn.Controller.MoveTarget = currentDestination;
				}
				assert(NotEqual_ObjectObject(m_pawn.Controller.MoveTarget, none));
				if(OrOr_BoolBool(OrOr_BoolBool(bAllowDirectMoveFailure, HasReachedNearbyPath(currentDestination)), IsInPosition()))
				{
					bSucceeded = true;
				}
				ResetOverriddenMoveToThreshold();
				if(bSucceeded)
				{
					// [Explicit Break]
					goto J0x35E;
				}
			}
			else
			{
				// [Explicit Break]
				goto J0x35E;
			}
			J0x35B:

			// [Loop Continue]
			goto J0x1D;
		}
	}
	J0x35E:

	if(AndAnd_BoolBool(Not_PreBool(bSucceeded), ShouldStopMoving()))
	{
		bSucceeded = true;
	}
	return;
}

state Running
{Begin:

	bSucceeded = false;
	MoveToActor();
	ReportMoveToOutcome(bSucceeded);
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.MoveToActorGoal'
}