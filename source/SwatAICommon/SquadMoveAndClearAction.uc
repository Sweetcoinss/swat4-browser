class SquadMoveAndClearAction extends SquadStackUpAction implements ISensorNotification, IInterestedInDoorOpening, IInterestedGrenadeThrowing
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

const kLeaderClearPointIndex = 1;
const kFollowerClearPointIndex = 0;
const kMoveToDoorPriority = 90;
const kMoveToThrowGrenadePriority = 86;
const kGrenadeThrowOffsetFromDoor = 20.0;

var private MoveToActorGoal CurrentMoveToActorGoal;
var private OpenDoorGoal CurrentOpenDoorGoal;
var private MoveToLocationGoal CurrentMoveToLocationGoal;
var private ThrowGrenadeGoal CurrentThrowGrenadeGoal;
var private RemoveWedgeGoal CurrentRemoveWedgeGoal;
var array<MoveAndClearGoal> MoveAndClearGoals;
var array<StackUpGoal> MoveUpStackupGoals;
var array<ClearPoint> ClearPoints;
var private bool bClearingRoomIsOnRight;
var private bool bShouldStackUpBeforeClearing;
var private Formation ClearFormation;
var private MoveInFormationGoal FollowerMoveInFormationGoal;
var private DistanceSensor LeaderDistanceSensor;
var private DistanceSensor FollowerDistanceSensor;
var private MoveAndClearGoal LeaderMoveAndClearGoal;
var private MoveAndClearGoal FollowerMoveAndClearGoal;
var private Timer WaitForFirstTwoOfficersTimer;
var private StackUpGoal ThirdOfficerStackUpGoal;
var private StackUpGoal FourthOfficerStackUpGoal;
var private DoorSideSensor LeaderDoorSideSensor;
var private DoorSideSensor FollowerDoorSideSensor;
var private bool bLeaderReachedOtherSide;
var private bool bFollowerReachedOtherSide;
var private int NumClearPointsInClearingRoom;
var private Pawn Leader;
var private Pawn Follower;
var private Pawn DoorOpener;
var private Pawn Thrower;
var private Pawn Breacher;
var private Pawn ThirdOfficer;
var private Pawn FourthOfficer;
var config float InitialClearPauseTime;
var config float MaxWaitForFirstTwoOfficersTime;
var config float FormationMoveToThreshold;
var config float FormationWalkThreshold;
var config float DoorOpenedFromSideDelayTime;
var private SwatGrenadeProjectile Projectile;

function float selectionHeuristic(AI_Goal Goal)
{
	if(EqualEqual_ObjectObject(satisfiesGoal, Goal.Class))
	{
		return 1.0000000;
	}
	else
	{
		return 0.0000000;
	}
	return;
}

function initAction(AI_Resource R, AI_Goal Goal)
{
	super(AI_Action).initAction(R, Goal);
	ClearPoints = ISwatDoor(TargetDoor).GetClearPoints(CommandOrigin);
	DetermineClearRoomSide();
	bShouldStackUpBeforeClearing = ShouldStackUpBeforeClearing();
	FindNumberOfClearPointsInClearingRoom();
	return;
}

private function DetermineClearRoomSide()
{
	if(ISwatDoor(TargetDoor).PointIsToMyLeft(CommandOrigin))
	{
		bClearingRoomIsOnRight = true;
	}
	else
	{
		bClearingRoomIsOnRight = false;
	}
	return;
}

function cleanup()
{
	super.cleanup();
	if(NotEqual_ObjectObject(CurrentMoveToActorGoal, none))
	{
		CurrentMoveToActorGoal.Release();
		CurrentMoveToActorGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentOpenDoorGoal, none))
	{
		CurrentOpenDoorGoal.Release();
		CurrentOpenDoorGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentMoveToLocationGoal, none))
	{
		CurrentMoveToLocationGoal.Release();
		CurrentMoveToLocationGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentThrowGrenadeGoal, none))
	{
		CurrentThrowGrenadeGoal.Release();
		CurrentThrowGrenadeGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentRemoveWedgeGoal, none))
	{
		CurrentRemoveWedgeGoal.Release();
		CurrentRemoveWedgeGoal = none;
	}
	if(NotEqual_ObjectObject(ClearFormation, none))
	{
		ClearFormation.cleanup();
		ClearFormation.Release();
		ClearFormation = none;
	}
	if(NotEqual_ObjectObject(FollowerMoveInFormationGoal, none))
	{
		FollowerMoveInFormationGoal.Release();
		FollowerMoveInFormationGoal = none;
	}
	if(NotEqual_ObjectObject(ThirdOfficerStackUpGoal, none))
	{
		ThirdOfficerStackUpGoal.Release();
		ThirdOfficerStackUpGoal = none;
	}
	if(NotEqual_ObjectObject(FourthOfficerStackUpGoal, none))
	{
		FourthOfficerStackUpGoal.Release();
		FourthOfficerStackUpGoal = none;
	}
	DeactivateDistanceSensors();
	DeactivateDoorSideSensors();
	ClearOutMoveAndClearGoals();
	ClearFirstTwoOfficersTimer();
	ISwatDoor(TargetDoor).UnRegisterInterestedInDoorOpening(self);
	if(NotEqual_ObjectObject(Projectile, none))
	{
		Projectile.UnRegisterInterestedGrenadeRegistrant(self);
	}
	return;
}

function ClearOutMoveAndClearGoals()
{
	if(NotEqual_ObjectObject(LeaderMoveAndClearGoal, none))
	{
		LeaderMoveAndClearGoal.Release();
		LeaderMoveAndClearGoal = none;
	}
	if(NotEqual_ObjectObject(FollowerMoveAndClearGoal, none))
	{
		FollowerMoveAndClearGoal.Release();
		FollowerMoveAndClearGoal = none;
	}
	J0x3A:

	if(Greater_IntInt(MoveAndClearGoals.Length, 0))
	{
		if(NotEqual_ObjectObject(MoveAndClearGoals[0], none))
		{
			MoveAndClearGoals[0].Release();
			MoveAndClearGoals[0] = none;
		}
		MoveAndClearGoals.Remove(0, 1);
		// [Loop Continue]
		goto J0x3A;
	}
	return;
}

function OnSensorMessage(AI_Sensor sensor, AI_SensorData Value, Object userData)
{
	if(OrOr_BoolBool(EqualEqual_ObjectObject(sensor, LeaderDistanceSensor), EqualEqual_ObjectObject(sensor, FollowerDistanceSensor)))
	{
		if(EqualEqual_ObjectObject(sensor, LeaderDistanceSensor))
		{
			assert(NotEqual_ObjectObject(Leader, none));
			if(AndAnd_BoolBool(EqualEqual_IntInt(Value.integerData, 0), EqualEqual_NameName(Leader.GetRoomName(), ClearPoints[1].GetRoomName(none))))
			{
				LeaderDistanceSensor.deactivateSensor(self);
				LeaderDistanceSensor = none;
				PauseLeadingOfficer();
				if(EqualEqual_ObjectObject(Follower, none))
				{
					if(IsIdle())
					{
						runAction();
					}
				}
				else
				{
					StartFollowerMoveAndClear();
				}
			}
		}
		else
		{
			if(EqualEqual_ObjectObject(sensor, FollowerDistanceSensor))
			{
				assert(NotEqual_ObjectObject(Follower, none));
				if(AndAnd_BoolBool(EqualEqual_IntInt(Value.integerData, 0), EqualEqual_NameName(Follower.GetRoomName(), ClearPoints[0].GetRoomName(none))))
				{
					FollowerDistanceSensor.deactivateSensor(self);
					FollowerDistanceSensor = none;
					if(IsIdle())
					{
						runAction();
					}
				}
			}
		}
	}
	else
	{
		if(sensor.IsA('DoorSideSensor'))
		{
			HandleDoorSideSensorMessage(sensor);
		}
		else
		{
			super(AI_Action).OnSensorMessage(sensor, Value, userData);
		}
	}
	return;
}

private function DeactivateDistanceSensors()
{
	if(NotEqual_ObjectObject(LeaderDistanceSensor, none))
	{
		PauseLeadingOfficer();
		LeaderDistanceSensor.deactivateSensor(self);
		LeaderDistanceSensor = none;
	}
	if(NotEqual_ObjectObject(FollowerDistanceSensor, none))
	{
		FollowerDistanceSensor.deactivateSensor(self);
		FollowerDistanceSensor = none;
	}
	return;
}

private function DeactivateDoorSideSensors()
{
	if(NotEqual_ObjectObject(LeaderDoorSideSensor, none))
	{
		LeaderDoorSideSensor.deactivateSensor(self);
		LeaderDoorSideSensor = none;
	}
	if(NotEqual_ObjectObject(FollowerDoorSideSensor, none))
	{
		FollowerDoorSideSensor.deactivateSensor(self);
		FollowerDoorSideSensor = none;
	}
	return;
}

function goalAchievedCB(AI_Goal Goal, AI_Action Child)
{
	super(AI_Action).goalAchievedCB(Goal, Child);
	if(EqualEqual_ObjectObject(Goal, CurrentOpenDoorGoal))
	{
		CurrentOpenDoorGoal.unPostGoal(self);
		CurrentOpenDoorGoal.Release();
		CurrentOpenDoorGoal = none;
	}
	return;
}

protected function NotifyPawnDied(Pawn Pawn)
{
	super.NotifyPawnDied(Pawn);
	if(Pawn.logAI)
	{
		Log(Concat_StrStr("MoveAndClearAction::NotifyPawnDied called - pawn is: ", string(Pawn)));
	}
	assert(NotEqual_ObjectObject(Pawn, none));
	if(OrOr_BoolBool(Pawn.bPendingDelete, AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(Not_PreBool(AreAnyOfficersInRoomToClear()), EqualEqual_ObjectObject(LeaderMoveAndClearGoal, none)), EqualEqual_ObjectObject(FollowerMoveAndClearGoal, none)), EqualEqual_ObjectObject(Projectile, none)), OrOr_BoolBool(OrOr_BoolBool(OrOr_BoolBool(EqualEqual_ObjectObject(Pawn, Leader), EqualEqual_ObjectObject(Pawn, Follower)), EqualEqual_ObjectObject(Pawn, Thrower)), EqualEqual_ObjectObject(Pawn, Breacher)))))
	{
		instantFail(1);
	}
	else
	{
		SetupOfficerRoles();
	}
	return;
}

function NotifyGrenadeDetonated(SwatGrenadeProjectile Grenade)
{
	Grenade.UnRegisterInterestedGrenadeRegistrant(self);
	if(IsIdle())
	{
		runAction();
	}
	return;
}

function NotifyDoorOpening(Door TargetDoor)
{
	if(AndAnd_BoolBool(IsIdle(), Not_PreBool(IsFirstOfficerThrower())))
	{
		runAction();
	}
	return;
}

function NotifyGrenadeReadyToThrow()
{
	if(IsIdle())
	{
		runAction();
	}
	return;
}

function NotifyRegisteredOnProjectile(SwatGrenadeProjectile Grenade)
{
	Projectile = Grenade;
	return;
}

private latent function LatentMoveOfficerToActor(Pawn Officer, Actor Destination, int Priority)
{
	J0x00:
	if(Not_PreBool(Officer.ReachedDestination(Destination)))
	{
		CurrentMoveToActorGoal = Class'SwatAICommon.MoveToActorGoal'.static.Allocate(self).;
		construct_AI_ResourceIntActor(AI_Resource(Officer.MovementAI), Priority, Destination);
		assert(NotEqual_ObjectObject(CurrentMoveToActorGoal, none));
		CurrentMoveToActorGoal.AddRef();
		CurrentMoveToActorGoal.SetRotateTowardsPointsDuringMovement(true);
		CurrentMoveToActorGoal.SetWalkThreshold(0.0000000);
		CurrentMoveToActorGoal.postGoal(self);
		waitForGoal(CurrentMoveToActorGoal);
		CurrentMoveToActorGoal.unPostGoal(self);
		CurrentMoveToActorGoal.Release();
		CurrentMoveToActorGoal = none;
		// [Loop Continue]
		goto J0x00;
	}
	return;
}

protected function bool ShouldRunToStackupPoint()
{
	return OrOr_BoolBool(OrOr_BoolBool(OrOr_BoolBool(TargetDoor.IsEmptyDoorway(), Not_PreBool(TargetDoor.IsClosed())), TargetDoor.IsOpening()), TargetDoor.IsBroken());
	return;
}

latent function OpenTargetDoor(Pawn Officer)
{
	assert(NotEqual_ObjectObject(Officer, none));
	if(CanInteractWithTargetDoor())
	{
		ISwatDoor(TargetDoor).RegisterInterestedInDoorOpening(self);
		CurrentOpenDoorGoal = Class'SwatAICommon.OpenDoorGoal'.static.Allocate(self).;
		construct_AI_ResourceDoor(AI_Resource(Officer.MovementAI), TargetDoor);
		assert(NotEqual_ObjectObject(CurrentOpenDoorGoal, none));
		CurrentOpenDoorGoal.AddRef();
		CurrentOpenDoorGoal.SetPreferSides();
		CurrentOpenDoorGoal.postGoal(self);
	}
	return;
}

function FirstOfficerReadyToOpenDoor()
{
	return;
}

protected function bool ShouldThrowerBeFirstOfficer()
{
	return OrOr_BoolBool(OrOr_BoolBool(OrOr_BoolBool(TargetDoor.IsEmptyDoorway(), ISwatDoor(TargetDoor).IsOpen()), TargetDoor.IsOpening()), ISwatDoor(TargetDoor).IsBroken());
	return;
}

function Pawn GetThrowingOfficer(HandheldEquipment.EquipmentSlot ThrownItemSlot)
{
	local int i;
	local Pawn Officer;

	if(ShouldThrowerBeFirstOfficer())
	{
		i = 0;
	}
	else
	{
		i = 1;
	}
	J0x1A:

	if(Less_IntInt(i, OfficersInStackUpOrder.Length))
	{
		Officer = OfficersInStackUpOrder[i];
		if(AndAnd_BoolBool(Class'Engine.Pawn'.static.checkConscious(Officer), NotEqual_ObjectObject(Officer, Breacher)))
		{
			if(NotEqual_ObjectObject(ISwatOfficer(Officer).GetThrownWeapon(ThrownItemSlot), none))
			{
				if(Officer.logAI)
				{
					Log(Concat_StrStr("Officer to throw is: ", string(Officer)));
				}
				return Officer;
			}
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x1A;
	}
	Officer = OfficersInStackUpOrder[0];
	if(Class'Engine.Pawn'.static.checkConscious(Officer))
	{
		if(NotEqual_ObjectObject(ISwatOfficer(Officer).GetThrownWeapon(ThrownItemSlot), none))
		{
			return Officer;
		}
	}
	i = 0;
	J0x116:

	if(Less_IntInt(i, OfficersInStackUpOrder.Length))
	{
		Officer = OfficersInStackUpOrder[i];
		if(Class'Engine.Pawn'.static.checkConscious(Officer))
		{
			if(NotEqual_ObjectObject(ISwatOfficer(Officer).GetThrownWeapon(ThrownItemSlot), none))
			{
				if(Officer.logAI)
				{
					Log(Concat_StrStr("Officer to throw is: ", string(Officer)));
				}
				return Officer;
			}
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x116;
	}
	return none;
	return;
}

private latent function MoveOfficerToThrowingPoint(Pawn Officer, Vector ThrowingPoint)
{
	if(Not_PreBool(Officer.ReachedLocation(ThrowingPoint)))
	{
		CurrentMoveToLocationGoal = Class'SwatAICommon.MoveToLocationGoal'.static.Allocate(self).;
		construct_AI_ResourceIntVector(AI_Resource(Officer.MovementAI), 80, ThrowingPoint);
		assert(NotEqual_ObjectObject(CurrentMoveToLocationGoal, none));
		CurrentMoveToLocationGoal.AddRef();
		CurrentMoveToLocationGoal.SetRotateTowardsPointsDuringMovement(true);
		CurrentMoveToLocationGoal.postGoal(self);
		waitForGoal(CurrentMoveToLocationGoal);
		CurrentMoveToLocationGoal.unPostGoal(self);
		CurrentMoveToLocationGoal.Release();
		CurrentMoveToLocationGoal = none;
	}
	return;
}

private function Vector GetTargetDoorEdge(Pawn Officer)
{
	local Vector FarDoorEdge, NearDoorEdge, TargetEdge;

	FarDoorEdge = Add_VectorVector(TargetDoor.Location, Multiply_VectorFloat(Vector(TargetDoor.Rotation), 20.0000000));
	NearDoorEdge = Subtract_VectorVector(TargetDoor.Location, Multiply_VectorFloat(Vector(TargetDoor.Rotation), 20.0000000));
	if(Greater_FloatFloat(VSize(Subtract_VectorVector(FarDoorEdge, Officer.Location)), VSize(Subtract_VectorVector(NearDoorEdge, Officer.Location))))
	{
		TargetEdge = FarDoorEdge;
	}
	else
	{
		TargetEdge = NearDoorEdge;
	}
	return TargetEdge;
	return;
}

private function ISwatAI.AIThrowSide GetThrowSide(Vector CenterOpenPoint, Vector ThrowingPoint)
{
	local Vector LeftDirection;

	LeftDirection = Cross_VectorVector(Normal(Subtract_VectorVector(TargetDoor.Location, CenterOpenPoint)), vect(0.0000000, 0.0000000, 1.0000000));
	if(Greater_FloatFloat(Dot_VectorVector(Normal(Subtract_VectorVector(CenterOpenPoint, ThrowingPoint)), LeftDirection), 0.0000000))
	{
		return 2;
	}
	else
	{
		return 1;
	}
	return;
}

private function Vector GetTargetThrowPoint(Vector ThrowOrigin)
{
	local float AdditionalGrenadeThrowDistance;
	local Vector TargetThrowPoint;

	AdditionalGrenadeThrowDistance = ISwatDoor(TargetDoor).GetAdditionalGrenadeThrowDistance(CommandOrigin);
	TargetThrowPoint = Add_VectorVector(TargetDoor.Location, Multiply_VectorFloat(Normal(Subtract_VectorVector(TargetDoor.Location, ThrowOrigin)), AdditionalGrenadeThrowDistance));
	return TargetThrowPoint;
	return;
}

latent function PrepareToThrowGrenade(HandheldEquipment.EquipmentSlot GrenadeSlot, bool bWaitToThrowGrenade)
{
	local Vector TargetThrowPoint, ThrowFromPoint, CenterPoint;
	local Rotator ThrowRotation;
	local ISwatAI.AIDoorUsageSide DoorUsageSide;
	local ISwatAI.AIThrowSide ThrowSide;
	local StackupPoint ThrowerStackUpPoint;
	local PlacedThrowPoint PlacedThrowPointToUse;

	PlacedThrowPointToUse = ISwatDoor(TargetDoor).GetPlacedThrowPoint(CommandOrigin);
	RemoveStackedUpGoalOnOfficer(Thrower);
	CenterPoint = ISwatDoor(TargetDoor).GetCenterOpenPoint(Thrower, DoorUsageSide);
	if(NotEqual_ObjectObject(PlacedThrowPointToUse, none))
	{
		LatentMoveOfficerToActor(Thrower, PlacedThrowPointToUse, 86);
		ThrowSide = PlacedThrowPointToUse.ThrowSide;
		ThrowFromPoint = PlacedThrowPointToUse.Location;
		TargetThrowPoint = GetTargetThrowPoint(ThrowFromPoint);
		if(EqualEqual_IntInt(int(ThrowSide), int(0)))
		{
			ThrowRotation = Rotator(Subtract_VectorVector(TargetThrowPoint, ThrowFromPoint));
		}
		else
		{
			ThrowRotation = ISwatDoor(TargetDoor).GetSidesOpenRotation(ThrowFromPoint);
		}
	}
	else
	{
		TargetThrowPoint = GetTargetThrowPoint(CenterPoint);
		DoorUsageSide = ISwatDoor(TargetDoor).GetOpenPositions(Thrower, true, ThrowFromPoint, ThrowRotation);
		ThrowerStackUpPoint = GetStackupPointForOrderedOfficer(Thrower);
		if(ThrowerStackUpPoint.CanThrowFromPoint)
		{
			ThrowFromPoint = ThrowerStackUpPoint.Location;
			TargetThrowPoint = GetTargetThrowPoint(ThrowFromPoint);
			ThrowSide = ThrowerStackUpPoint.ThrowSide;
			if(EqualEqual_IntInt(int(ThrowSide), int(0)))
			{
				ThrowRotation = Rotator(Subtract_VectorVector(TargetThrowPoint, ThrowFromPoint));
			}
			else
			{
				ThrowRotation = ISwatDoor(TargetDoor).GetSidesOpenRotation(ThrowFromPoint);
			}
		}
		else
		{
			if(AndAnd_BoolBool(NotEqual_IntInt(int(DoorUsageSide), int(2)), Not_PreBool(TargetDoor.IsEmptyDoorway())))
			{
				ThrowSide = GetThrowSide(CenterPoint, ThrowFromPoint);
			}
			else
			{
				ThrowFromPoint = CenterPoint;
				ThrowSide = 0;
				ThrowRotation = Rotator(Subtract_VectorVector(TargetThrowPoint, ThrowFromPoint));
			}
		}
		MoveOfficerToThrowingPoint(Thrower, ThrowFromPoint);
	}
	CurrentThrowGrenadeGoal = Class'SwatAICommon.ThrowGrenadeGoal'.static.Allocate(self).;
	construct_AI_ResourceVectorVectorByteBool(AI_Resource(Thrower.CharacterAI), TargetThrowPoint, Thrower.Location, GrenadeSlot, true);
	assert(NotEqual_ObjectObject(CurrentThrowGrenadeGoal, none));
	CurrentThrowGrenadeGoal.AddRef();
	CurrentThrowGrenadeGoal.SetThrowSide(ThrowSide);
	CurrentThrowGrenadeGoal.SetThrowRotation(ThrowRotation);
	CurrentThrowGrenadeGoal.SetWaitToThrowGrenade(AndAnd_BoolBool(AndAnd_BoolBool(TargetDoor.IsClosed(), Not_PreBool(TargetDoor.IsOpening())), bWaitToThrowGrenade));
	CurrentThrowGrenadeGoal.RegisterForGrenadeThrowing(self);
	CurrentThrowGrenadeGoal.postGoal(self);
	Pause();
	return;
}

latent function ThrowGrenade()
{
	if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(TargetDoor.IsClosed(), Not_PreBool(TargetDoor.IsOpening())), Not_PreBool(TargetDoor.IsBroken())), Not_PreBool(TargetDoor.IsEmptyDoorway())))
	{
		instantFail(1);
	}
	else
	{
		assert(NotEqual_ObjectObject(CurrentThrowGrenadeGoal, none));
		if(CurrentThrowGrenadeGoal.bWaitToThrowGrenade)
		{
			CurrentThrowGrenadeGoal.NotifyThrowGrenade();
		}
		Pause();
	}
	return;
}

latent function FinishUpThrowBehavior()
{
	if(NotEqual_ObjectObject(CurrentThrowGrenadeGoal, none))
	{
		J0x0B:

		if(AndAnd_BoolBool(Not_PreBool(CurrentThrowGrenadeGoal.hasCompleted()), Class'Engine.Pawn'.static.checkConscious(Thrower)))
		{
			yield();
			// [Loop Continue]
			goto J0x0B;
		}
		CurrentThrowGrenadeGoal.unPostGoal(self);
		CurrentThrowGrenadeGoal.Release();
		CurrentThrowGrenadeGoal = none;
	}
	return;
}

protected function TriggerThrowGrenadeMoveUpSpeech()
{
	return;
}

protected latent function MoveUpThrower()
{
	local Pawn FirstOfficer, SecondOfficer, OriginalThrower;

	if(NotEqual_ObjectObject(Thrower, none))
	{
		if(ShouldThrowerBeFirstOfficer())
		{
			if(NotEqual_ObjectObject(Thrower, GetFirstOfficer()))
			{
				TriggerThrowGrenadeMoveUpSpeech();
				OriginalThrower = Thrower;
				FirstOfficer = GetFirstOfficer();
				SwapOfficerRoles(OriginalThrower, FirstOfficer);
				SwapStackUpPositions(OriginalThrower, FirstOfficer);
			}
		}
		else
		{
			if(AndAnd_BoolBool(NotEqual_ObjectObject(GetSecondOfficer(), none), NotEqual_ObjectObject(Thrower, GetSecondOfficer())))
			{
				TriggerThrowGrenadeMoveUpSpeech();
				OriginalThrower = Thrower;
				SecondOfficer = GetSecondOfficer();
				SwapOfficerRoles(OriginalThrower, SecondOfficer);
				SwapStackUpPositions(OriginalThrower, SecondOfficer);
			}
		}
	}
	return;
}

protected function SwapOfficerRoles(Pawn OfficerA, Pawn OfficerB)
{
	if(EqualEqual_ObjectObject(OfficerA, Leader))
	{
		Leader = OfficerB;
	}
	else
	{
		if(EqualEqual_ObjectObject(OfficerB, Leader))
		{
			Leader = OfficerA;
		}
	}
	if(EqualEqual_ObjectObject(OfficerA, Follower))
	{
		Follower = OfficerB;
	}
	else
	{
		if(EqualEqual_ObjectObject(OfficerB, Follower))
		{
			Follower = OfficerA;
		}
	}
	if(EqualEqual_ObjectObject(OfficerA, DoorOpener))
	{
		DoorOpener = OfficerB;
	}
	else
	{
		if(EqualEqual_ObjectObject(OfficerB, DoorOpener))
		{
			DoorOpener = OfficerA;
		}
	}
	if(EqualEqual_ObjectObject(OfficerA, Breacher))
	{
		Breacher = OfficerB;
	}
	else
	{
		if(EqualEqual_ObjectObject(OfficerB, Breacher))
		{
			Breacher = OfficerA;
		}
	}
	return;
}

latent function RemoveWedge()
{
	local Pawn Officer;
	local int i;

	assert(Greater_IntInt(OfficersInStackUpOrder.Length, 0));
	i = 0;
	J0x13:

	if(Less_IntInt(i, OfficersInStackUpOrder.Length))
	{
		if(Class'Engine.Pawn'.static.checkConscious(OfficersInStackUpOrder[i]))
		{
			Officer = OfficersInStackUpOrder[i];
			// [Explicit Break]
			goto J0x5E;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x13;
	}
	J0x5E:

	if(NotEqual_ObjectObject(Officer, none))
	{
		CurrentRemoveWedgeGoal = Class'SwatAICommon.RemoveWedgeGoal'.static.Allocate(self).;
		construct_AI_ResourceDoor(AI_Resource(Officer.CharacterAI), TargetDoor);
		assert(NotEqual_ObjectObject(CurrentRemoveWedgeGoal, none));
		CurrentRemoveWedgeGoal.AddRef();
		CurrentRemoveWedgeGoal.postGoal(self);
		waitForGoal(CurrentRemoveWedgeGoal);
		CurrentRemoveWedgeGoal.unPostGoal(self);
		CurrentRemoveWedgeGoal.Release();
		CurrentRemoveWedgeGoal = none;
	}
	return;
}

latent function WaitToFinishOpeningDoor()
{
	if(AndAnd_BoolBool(NotEqual_ObjectObject(CurrentOpenDoorGoal, none), Not_PreBool(CurrentOpenDoorGoal.hasCompleted())))
	{
		waitForGoal(CurrentOpenDoorGoal);
	}
	return;
}

latent function OpenDoorForThrowingGrenade()
{
	OpenTargetDoor(GetFirstOfficer());
	if(IsFirstOfficerThrower())
	{
		WaitToFinishOpeningDoor();
	}
	else
	{
		if(AndAnd_BoolBool(AndAnd_BoolBool(TargetDoor.IsClosed(), Not_PreBool(TargetDoor.IsOpening())), Not_PreBool(ISwatDoor(TargetDoor).IsBroken())))
		{
			Pause();
		}
	}
	return;
}

latent function PrepareToMoveSquad()
{
	local ISwatDoor SwatDoor;

	SwatDoor = ISwatDoor(TargetDoor);
	assert(NotEqual_ObjectObject(SwatDoor, none));
	if(SwatDoor.IsWedged())
	{
		RemoveWedge();
	}
	return;
}

function FindNumberOfClearPointsInClearingRoom()
{
	local int i;
	local name ClearingRoomName;

	ClearingRoomName = GetClearingRoomName();
	i = 0;
	J0x13:

	if(Less_IntInt(i, ClearPoints.Length))
	{
		if(EqualEqual_NameName(ClearPoints[i].GetRoomName(none), ClearingRoomName))
		{
			AddAdd_Int(NumClearPointsInClearingRoom);
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x13;
	}
	if(resource.Pawn().logAI)
	{
		Log(Concat_StrStr("NumClearPointsInClearingRoom is: ", string(NumClearPointsInClearingRoom)));
	}
	return;
}

private function AddMoveAndClearGoalToList(Pawn Officer, ClearPoint Destination, bool bAnnounceClear)
{
	local int NextOpenMoveAndClearIndex;

	NextOpenMoveAndClearIndex = MoveAndClearGoals.Length;
	MoveAndClearGoals[NextOpenMoveAndClearIndex] = PostMoveAndClearGoalOnOfficer(Officer, Destination, bAnnounceClear);
	assert(NotEqual_ObjectObject(MoveAndClearGoals[NextOpenMoveAndClearIndex], none));
	MoveAndClearGoals[NextOpenMoveAndClearIndex].AddRef();
	return;
}

function MoveAndClearGoal PostMoveAndClearGoalOnOfficer(Pawn Officer, ClearPoint Destination, bool bAnnounceClear)
{
	local MoveAndClearGoal OfficerMoveAndClearGoal;

	assert(NotEqual_ObjectObject(Officer, none));
	OfficerMoveAndClearGoal = Class'SwatAICommon.MoveAndClearGoal'.static.Allocate(self).;
	construct_AI_ResourceClearPointVectorBool(AI_CharacterResource(Officer.CharacterAI), Destination, CommandOrigin, bAnnounceClear);
	OfficerMoveAndClearGoal.postGoal(self);
	return OfficerMoveAndClearGoal;
	return;
}

function CreateClearFormation()
{
	assert(NotEqual_ObjectObject(Leader, none));
	assert(NotEqual_ObjectObject(Follower, none));
	assert(EqualEqual_ObjectObject(ClearFormation, none));
	ClearFormation = Class'SwatAICommon.Formation'.static.Allocate(self).;
	construct_Pawn(Leader);
	ClearFormation.AddRef();
	ClearFormation.AddMember(Follower);
	ISwatOfficer(Leader).SetCurrentFormation(ClearFormation);
	ISwatOfficer(Follower).SetCurrentFormation(ClearFormation);
	FollowerMoveInFormationGoal = Class'SwatAICommon.MoveInFormationGoal'.static.Allocate(self).;
	construct_AI_Resource(AI_MovementResource(Follower.MovementAI));
	assert(NotEqual_ObjectObject(FollowerMoveInFormationGoal, none));
	FollowerMoveInFormationGoal.AddRef();
	FollowerMoveInFormationGoal.SetRotateTowardsPointsDuringMovement(true);
	FollowerMoveInFormationGoal.SetMoveToThresholds(FormationMoveToThreshold, FormationMoveToThreshold, FormationMoveToThreshold);
	FollowerMoveInFormationGoal.SetWalkThresholds(FormationWalkThreshold, FormationWalkThreshold, FormationWalkThreshold);
	FollowerMoveInFormationGoal.postGoal(self);
	return;
}

function StopFollowingLeader()
{
	if(NotEqual_ObjectObject(FollowerMoveInFormationGoal, none))
	{
		FollowerMoveInFormationGoal.unPostGoal(self);
		FollowerMoveInFormationGoal.Release();
		FollowerMoveInFormationGoal = none;
	}
	if(NotEqual_ObjectObject(ClearFormation, none))
	{
		ClearFormation.cleanup();
		ClearFormation.Release();
		ClearFormation = none;
	}
	return;
}

protected function SetupOfficerRoles()
{
	local Pawn FirstOfficer, SecondOfficer;

	FirstOfficer = GetFirstOfficer();
	SecondOfficer = GetSecondOfficer();
	ThirdOfficer = GetThirdOfficer();
	FourthOfficer = GetFourthOfficer();
	if(FirstOfficer.logAI)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("SetupOfficerRoles - FirstOfficer: ", string(FirstOfficer)), " SecondOfficer: "), string(SecondOfficer)), " ThirdOfficer: "), string(ThirdOfficer)), " FourthOfficer: "), string(FourthOfficer)));
	}
	if(EqualEqual_ObjectObject(FirstOfficer, SecondOfficer))
	{
		if(NotEqual_ObjectObject(ThirdOfficer, none))
		{
			SecondOfficer = ThirdOfficer;
			ThirdOfficer = FourthOfficer;
		}
		else
		{
			if(NotEqual_ObjectObject(FourthOfficer, none))
			{
				SecondOfficer = FourthOfficer;
				FourthOfficer = none;
			}
			else
			{
				SecondOfficer = none;
			}
		}
	}
	if(EqualEqual_ObjectObject(SecondOfficer, ThirdOfficer))
	{
		ThirdOfficer = none;
	}
	if(EqualEqual_ObjectObject(SecondOfficer, FourthOfficer))
	{
		FourthOfficer = none;
	}
	if(EqualEqual_ObjectObject(ThirdOfficer, FourthOfficer))
	{
		FourthOfficer = none;
	}
	assert(NotEqual_ObjectObject(FirstOfficer, SecondOfficer));
	assert(NotEqual_ObjectObject(FirstOfficer, ThirdOfficer));
	assert(NotEqual_ObjectObject(FirstOfficer, FourthOfficer));
	assert(OrOr_BoolBool(EqualEqual_ObjectObject(FourthOfficer, none), NotEqual_ObjectObject(ThirdOfficer, FourthOfficer)));
	assert(OrOr_BoolBool(EqualEqual_ObjectObject(ThirdOfficer, none), NotEqual_ObjectObject(SecondOfficer, ThirdOfficer)));
	assert(OrOr_BoolBool(EqualEqual_ObjectObject(FourthOfficer, none), NotEqual_ObjectObject(SecondOfficer, FourthOfficer)));
	if(NotEqual_ObjectObject(SecondOfficer, none))
	{
		if(CanInteractWithTargetDoor())
		{
			if(GreaterEqual_IntInt(NumClearPointsInClearingRoom, 2))
			{
				Leader = SecondOfficer;
				Follower = FirstOfficer;
				DoorOpener = FirstOfficer;
			}
			else
			{
				Leader = SecondOfficer;
				Follower = none;
				DoorOpener = FirstOfficer;
			}
		}
		else
		{
			if(GreaterEqual_IntInt(NumClearPointsInClearingRoom, 2))
			{
				Leader = FirstOfficer;
				Follower = SecondOfficer;
			}
			else
			{
				Leader = FirstOfficer;
				Follower = none;
			}
			DoorOpener = FirstOfficer;
		}
	}
	else
	{
		Leader = FirstOfficer;
		DoorOpener = FirstOfficer;
	}
	SetBreacher();
	SetThrower();
	if(Leader.logAI)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("Leader is: ", string(Leader)), " Follower is: "), string(Follower)));
	}
	return;
}

protected function SetThrower()
{
	return;
}

protected function SetBreacher()
{
	return;
}

latent function MoveFirstTwoOfficersThroughDoor()
{
	if(CanInteractWithTargetDoor())
	{
		OpenTargetDoor(DoorOpener);
		Pause();
		if(Not_PreBool(CurrentOpenDoorGoal.WasOpenedFromSide()))
		{
			waitForGoal(CurrentOpenDoorGoal);
			if(AndAnd_BoolBool(NotEqual_ObjectObject(Follower, none), EqualEqual_ObjectObject(DoorOpener, Follower)))
			{
				Follower = Leader;
				Leader = DoorOpener;
			}
		}
		else
		{
			Sleep(DoorOpenedFromSideDelayTime);
		}
		ISwatDoor(TargetDoor).UnRegisterInterestedInDoorOpening(self);
	}
	TriggerStartedClearingSpeech(Leader);
	if(Not_PreBool(TargetDoor.IsEmptyDoorway()))
	{
		if(AndAnd_BoolBool(AndAnd_BoolBool(EqualEqual_ObjectObject(Leader, Thrower), NotEqual_ObjectObject(CurrentThrowGrenadeGoal, none)), Not_PreBool(CurrentThrowGrenadeGoal.hasCompleted())))
		{
			waitForGoal(CurrentThrowGrenadeGoal);
		}
		LatentMoveOfficerToActor(Leader, TargetDoor, 90);
	}
	if(NotEqual_ObjectObject(Follower, none))
	{
		CreateClearFormation();
	}
	LeaderMoveAndClearGoal = PostMoveAndClearGoalOnOfficer(Leader, ClearPoints[1], true);
	assert(NotEqual_ObjectObject(LeaderMoveAndClearGoal, none));
	LeaderMoveAndClearGoal.AddRef();
	if(NotEqual_ObjectObject(Follower, none))
	{
		LeaderDistanceSensor = DistanceSensor(Class'Tyrion.AI_Sensor'.static.activateSensor(self, Class'SwatAICommon.DistanceSensor', AI_Resource(Leader.CharacterAI), 0.0000000, 1000000.0000000));
		LeaderDistanceSensor.setParameters_FloatActorBool(ISwatDoor(TargetDoor).GetMoveAndClearPauseThreshold(), TargetDoor);
	}
	return;
}

private function MoveUpSecondTwoOfficers()
{
	local StackupPoint ThirdOfficerStackupPoint, FourthOfficerStackupPoint;

	ThirdOfficerStackupPoint = StackUpPoints[0];
	FourthOfficerStackupPoint = StackUpPoints[1];
	if(NotEqual_ObjectObject(ThirdOfficer, none))
	{
		RemoveStackedUpGoalOnOfficer(ThirdOfficer);
		ThirdOfficerStackUpGoal = Class'SwatAICommon.StackUpGoal'.static.Allocate(self).;
		construct_AI_ResourceStackupPoint(AI_Resource(ThirdOfficer.CharacterAI), ThirdOfficerStackupPoint);
		assert(NotEqual_ObjectObject(ThirdOfficerStackUpGoal, none));
		ThirdOfficerStackUpGoal.AddRef();
		ThirdOfficerStackUpGoal.postGoal(self);
	}
	if(NotEqual_ObjectObject(FourthOfficer, none))
	{
		RemoveStackedUpGoalOnOfficer(FourthOfficer);
		FourthOfficerStackUpGoal = Class'SwatAICommon.StackUpGoal'.static.Allocate(self).;
		construct_AI_ResourceStackupPoint(AI_Resource(FourthOfficer.CharacterAI), FourthOfficerStackupPoint);
		assert(NotEqual_ObjectObject(FourthOfficerStackUpGoal, none));
		FourthOfficerStackUpGoal.AddRef();
		FourthOfficerStackUpGoal.postGoal(self);
	}
	return;
}

private function StartFollowerMoveAndClear()
{
	assert(NotEqual_ObjectObject(Follower, none));
	FollowerMoveAndClearGoal = PostMoveAndClearGoalOnOfficer(Follower, ClearPoints[0], true);
	FollowerMoveAndClearGoal.AddRef();
	ActivateFollowingSensor();
	return;
}

private function PauseLeadingOfficer()
{
	StopLeadingOfficer();
	ISwatAI(Leader).AimAtActor(ClearPoints[1]);
	if(NotEqual_ObjectObject(Follower, none))
	{
		StopFollowingLeader();
	}
	return;
}

private function ActivateFollowingSensor()
{
	FollowerDistanceSensor = DistanceSensor(Class'Tyrion.AI_Sensor'.static.activateSensor(self, Class'SwatAICommon.DistanceSensor', AI_Resource(Follower.CharacterAI), 0.0000000, 1000000.0000000));
	FollowerDistanceSensor.setParameters_FloatActorBool(ISwatDoor(TargetDoor).GetMoveAndClearPauseThreshold(), TargetDoor);
	return;
}

private function StopLeadingOfficer()
{
	LeaderMoveAndClearGoal.unPostGoal(self);
	LeaderMoveAndClearGoal.Release();
	LeaderMoveAndClearGoal = none;
	return;
}

private function PauseFollowingOfficer()
{
	if(NotEqual_ObjectObject(Follower, none))
	{
		StopFollowingOfficer();
		ISwatAI(Follower).AimAtActor(ClearPoints[0]);
	}
	return;
}

private function StopFollowingOfficer()
{
	if(NotEqual_ObjectObject(FollowerMoveAndClearGoal, none))
	{
		FollowerMoveAndClearGoal.unPostGoal(self);
		FollowerMoveAndClearGoal.Release();
		FollowerMoveAndClearGoal = none;
	}
	return;
}

private latent function MoveFirstTwoOfficersToClearPoints()
{
	AddMoveAndClearGoalToList(Leader, ClearPoints[1], true);
	if(NotEqual_ObjectObject(Follower, none))
	{
		AddMoveAndClearGoalToList(Follower, ClearPoints[0], true);
	}
	return;
}

latent function MoveRemainingOfficersThroughDoor()
{
	local Pawn Officer;
	local int ClearPointIndex, PawnIterIndex;

	if(bShouldStackUpBeforeClearing)
	{
		ClearPointIndex = 2;
	}
	else
	{
		ClearPointIndex = 0;
	}
	PawnIterIndex = 0;
	J0x22:

	if(Less_IntInt(PawnIterIndex, squad().pawns.Length))
	{
		Officer = squad().pawns[PawnIterIndex];
		assert(NotEqual_ObjectObject(Officer, none));
		if(AndAnd_BoolBool(NotEqual_ObjectObject(Officer, Leader), NotEqual_ObjectObject(Officer, Follower)))
		{
			if(OrOr_BoolBool(Not_PreBool(bShouldStackUpBeforeClearing), NotEqual_NameName(Officer.GetRoomName(), ClearPoints[ClearPointIndex].GetRoomName(none))))
			{
				AddMoveAndClearGoalToList(Officer, ClearPoints[ClearPointIndex], true);
			}
			AddAdd_PreInt(ClearPointIndex);
		}
		AddAdd_PreInt(PawnIterIndex);
		// [Loop Continue]
		goto J0x22;
	}
	return;
}

function WaitForFirstTwoOfficersTimerCompleted()
{
	if(IsIdle())
	{
		runAction();
	}
	return;
}

latent function WaitForFirstTwoOfficers()
{
	assert(EqualEqual_ObjectObject(WaitForFirstTwoOfficersTimer, none));
	StartWaitForFirstTwoOfficersTimer();
	Pause();
	ClearFirstTwoOfficersTimer();
	DeactivateDistanceSensors();
	return;
}

function StartWaitForFirstTwoOfficersTimer()
{
	WaitForFirstTwoOfficersTimer = Leader.Spawn(Class'Engine.Timer');
	WaitForFirstTwoOfficersTimer.__TimerDelegate__Delegate = WaitForFirstTwoOfficersTimerCompleted;
	WaitForFirstTwoOfficersTimer.StartTimer(MaxWaitForFirstTwoOfficersTime, false);
	return;
}

function ClearFirstTwoOfficersTimer()
{
	if(NotEqual_ObjectObject(WaitForFirstTwoOfficersTimer, none))
	{
		WaitForFirstTwoOfficersTimer.StopTimer();
		WaitForFirstTwoOfficersTimer.__TimerDelegate__Delegate = None;
		WaitForFirstTwoOfficersTimer.Destroy();
		WaitForFirstTwoOfficersTimer = none;
	}
	return;
}

private function ClearSecondTwoOfficersMoveUpBehavior()
{
	if(NotEqual_ObjectObject(ThirdOfficerStackUpGoal, none))
	{
		ThirdOfficerStackUpGoal.unPostGoal(self);
		ThirdOfficerStackUpGoal.Release();
		ThirdOfficerStackUpGoal = none;
	}
	if(NotEqual_ObjectObject(FourthOfficerStackUpGoal, none))
	{
		FourthOfficerStackUpGoal.unPostGoal(self);
		FourthOfficerStackUpGoal.Release();
		FourthOfficerStackUpGoal = none;
	}
	return;
}

private function ActivateDoorSideSensors()
{
	if(Greater_IntInt(NumClearPointsInClearingRoom, 2))
	{
		LeaderDoorSideSensor = DoorSideSensor(Class'Tyrion.AI_Sensor'.static.activateSensor(self, Class'SwatAICommon.DoorSideSensor', AI_Resource(Leader.CharacterAI), 0.0000000, 1000000.0000000));
		LeaderDoorSideSensor.setParameters(Leader, TargetDoor, Not_PreBool(bClearingRoomIsOnRight));
		if(NotEqual_ObjectObject(Follower, none))
		{
			FollowerDoorSideSensor = DoorSideSensor(Class'Tyrion.AI_Sensor'.static.activateSensor(self, Class'SwatAICommon.DoorSideSensor', AI_Resource(Leader.CharacterAI), 0.0000000, 1000000.0000000));
			FollowerDoorSideSensor.setParameters(Follower, TargetDoor, Not_PreBool(bClearingRoomIsOnRight));
		}
		else
		{
			bFollowerReachedOtherSide = true;
		}
	}
	return;
}

private function HandleDoorSideSensorMessage(AI_Sensor DoorSideSensor)
{
	if(EqualEqual_ObjectObject(DoorSideSensor, LeaderDoorSideSensor))
	{
		bLeaderReachedOtherSide = true;
		LeaderDoorSideSensor.deactivateSensor(self);
		LeaderDoorSideSensor = none;
	}
	else
	{
		assert(EqualEqual_ObjectObject(DoorSideSensor, FollowerDoorSideSensor));
		bFollowerReachedOtherSide = true;
		FollowerDoorSideSensor.deactivateSensor(self);
		FollowerDoorSideSensor = none;
	}
	if(AndAnd_BoolBool(bLeaderReachedOtherSide, bFollowerReachedOtherSide))
	{
		MoveUpSecondTwoOfficers();
	}
	return;
}

latent function MoveStackedUpSquad()
{
	MoveFirstTwoOfficersThroughDoor();
	if(NotEqual_ObjectObject(Follower, none))
	{
		ActivateDoorSideSensors();
		WaitForFirstTwoOfficers();
		PauseFollowingOfficer();
		TriggerReportedThresholdClearSpeech(Leader);
		Sleep(InitialClearPauseTime);
		TriggerReportedContinuingClear(Leader);
		MoveFirstTwoOfficersToClearPoints();
		ClearSecondTwoOfficersMoveUpBehavior();
		MoveRemainingOfficersThroughDoor();
	}
	return;
}

protected function name GetClearingRoomName()
{
	if(bClearingRoomIsOnRight)
	{
		return ISwatDoor(TargetDoor).GetRightRoomName();
	}
	else
	{
		return ISwatDoor(TargetDoor).GetLeftRoomName();
	}
	return;
}

protected function bool IsOfficerInRoomToClear(Pawn Officer)
{
	assert(Class'Engine.Pawn'.static.checkConscious(Officer));
	if(EqualEqual_NameName(Officer.GetRoomName(), GetClearingRoomName()))
	{
		return true;
	}
	else
	{
		return false;
	}
	return;
}

protected function bool ShouldStackUpBeforeClearing()
{
	return OrOr_BoolBool(Not_PreBool(AreAnyOfficersInRoomToClear()), ShouldStackUpIfOfficersInRoomToClear());
	return;
}

protected function bool ShouldStackUpIfOfficersInRoomToClear()
{
	return false;
	return;
}

private function bool AreAnyOfficersInRoomToClear()
{
	local int i;
	local Pawn OfficerIter;

	i = 0;
	J0x07:

	if(Less_IntInt(i, squad().pawns.Length))
	{
		OfficerIter = squad().pawns[i];
		if(IsOfficerInRoomToClear(OfficerIter))
		{
			return true;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return false;
	return;
}

function bool IsFirstOfficerThrower()
{
	return EqualEqual_ObjectObject(GetFirstOfficer(), Thrower);
	return;
}

function TriggerStartedClearingSpeech(Pawn Officer)
{
	ISwatOfficer(Officer).GetOfficerSpeechManagerAction().TriggerStartedClearingSpeech();
	return;
}

private function bool ShouldAnnounceClearThreshold()
{
	local int i;
	local Pawn Officer, CurrentAssignment;

	i = 0;
	J0x07:

	if(Less_IntInt(i, squad().pawns.Length))
	{
		Officer = squad().pawns[i];
		CurrentAssignment = ISwatOfficer(Officer).GetOfficerCommanderAction().GetCurrentAssignment();
		if(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(CurrentAssignment, none), Not_PreBool(ISwatAI(CurrentAssignment).IsCompliant())), Not_PreBool(ISwatAI(CurrentAssignment).IsArrested())))
		{
			return false;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return true;
	return;
}

function TriggerReportedThresholdClearSpeech(Pawn Officer)
{
	if(ShouldAnnounceClearThreshold())
	{
		ISwatOfficer(Officer).GetOfficerSpeechManagerAction().TriggerReportedThresholdClearSpeech();
	}
	return;
}

function TriggerReportedContinuingClear(Pawn Officer)
{
	if(Greater_IntInt(GetNumberLivingOfficersInSquad(), 2))
	{
		ISwatOfficer(Officer).GetOfficerSpeechManagerAction().TriggerReportedContinuingClear2Plus();
	}
	else
	{
		ISwatOfficer(Officer).GetOfficerSpeechManagerAction().TriggerReportedContinuingClear2Minus();
	}
	return;
}

state Running
{Begin:

	if(bShouldStackUpBeforeClearing)
	{
		StackUpSquad(true);
		SetupOfficerRoles();
		PrepareToMoveSquad();
		FinishUpThrowBehavior();
		ClearOutStackedUpGoals();
		MoveStackedUpSquad();
	}
	else
	{
		TriggerStartedClearingSpeech(GetFirstOfficer());
		MoveRemainingOfficersThroughDoor();
	}
	if(resource.Pawn().logAI)
	{
		Log(Concat_StrStr("waiting for all goals - MoveAndClearGoals: ", string(MoveAndClearGoals.Length)));
	}
	yield();
	waitForAllGoalsInList(MoveAndClearGoals);
	ClearOutMoveAndClearGoals();
	succeed();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.SquadMoveAndClearGoal'
}