class BarricadeAction extends SuspiciousAction
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

const kMinAimAroundTime = 1.5;
const kMaxAimAroundTime = 4.0;

var(Parameters) Vector StimuliOrigin;
var(Parameters) bool bDelayBarricade;
var(Parameters) bool bCanCloseDoors;
var private AimAroundGoal CurrentAimAroundGoal;
var private MoveToActorGoal CurrentMoveToActorGoal;
var private CloseDoorGoal CurrentCloseDoorGoal;
var private MoveToDoorGoal CurrentMoveToDoorGoal;
var private AttackTargetGoal AttackDoorGoal;
var private AimAtTargetGoal CurrentAimAtTargetGoal;
var array<Door> DoorsInRoom;
var array<Door> ClosableDoorsInRoom;
var private NavigationPoint BarricadePoint;
var private Door DoorOpening;
var private DoorOpeningSensor DoorOpeningSensor;
var config float ShootAtDoorsChance;
var config float MinShootingAtDoorsTime;
var config float MaxShootingAtDoorsTime;
var config float CloseAndLockInitialDoorChance;
var config float CloseAndLockSubsequentDoorChance;
var config float MinBarricadeDelayTime;
var config float MaxBarricadeDelayTime;
var config float ReactionSpeechChance;
var config float CrouchAtFleePointChance;
var config float AimAtClosestDoorTime;

function cleanup()
{
	super(AI_CharacterAction).cleanup();
	if(AndAnd_BoolBool(NotEqual_ObjectObject(BarricadePoint, none), BarricadePoint.IsA('FleePoint')))
	{
		if(EqualEqual_ObjectObject(FleePoint(BarricadePoint).GetFleePointUser(), m_pawn))
		{
			FleePoint(BarricadePoint).UnclaimPoint();
		}
	}
	if(NotEqual_ObjectObject(CurrentAimAroundGoal, none))
	{
		CurrentAimAroundGoal.Release();
		CurrentAimAroundGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentMoveToActorGoal, none))
	{
		CurrentMoveToActorGoal.Release();
		CurrentMoveToActorGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentCloseDoorGoal, none))
	{
		CurrentCloseDoorGoal.Release();
		CurrentCloseDoorGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentMoveToDoorGoal, none))
	{
		CurrentMoveToDoorGoal.Release();
		CurrentMoveToDoorGoal = none;
	}
	if(NotEqual_ObjectObject(AttackDoorGoal, none))
	{
		AttackDoorGoal.Release();
		AttackDoorGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentAimAtTargetGoal, none))
	{
		CurrentAimAtTargetGoal.Release();
		CurrentAimAtTargetGoal = none;
	}
	if(NotEqual_ObjectObject(DoorOpeningSensor, none))
	{
		DoorOpeningSensor.deactivateSensor(self);
		DoorOpeningSensor = none;
	}
	if(m_pawn.bIsCrouched)
	{
		m_pawn.ShouldCrouch(false);
	}
	return;
}

function goalNotAchievedCB(AI_Goal Goal, AI_Action Child, ActionBase.ACT_ErrorCodes errorCode)
{
	super(AI_Action).goalNotAchievedCB(Goal, Child, errorCode);
	if(m_pawn.logTyrion)
	{
		Log(Concat_StrStr(Concat_StrStr("barricading - goal ", string(Goal.Name)), " failed"));
	}
	instantFail(errorCode);
	return;
}

function OnSensorMessage(AI_Sensor sensor, AI_SensorData Value, Object userData)
{
	super(AI_Action).OnSensorMessage(sensor, Value, userData);
	if(EqualEqual_ObjectObject(sensor, DoorOpeningSensor))
	{
		if(m_pawn.logAI)
		{
			Log(Concat_StrStr(string(m_pawn.Name), " noticed a door opening."));
		}
		assert(Value.objectData.IsA('Door'));
		if(IsIdle())
		{
			DoorOpening = Door(Value.objectData);
			runAction();
		}
	}
	return;
}

private function FindBarricadePoint()
{
	m_pawn.FindAnchor(true);
	if(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(m_pawn.Anchor, none), m_pawn.Anchor.IsA('FleePoint')), OrOr_BoolBool(EqualEqual_ObjectObject(FleePoint(m_pawn.Anchor).GetFleePointUser(), none), EqualEqual_ObjectObject(FleePoint(m_pawn.Anchor).GetFleePointUser(), m_pawn))))
	{
		BarricadePoint = Pawn.Anchor;
	}
	else
	{
		BarricadePoint = SwatAIRepository(m_pawn.Level.AIRepo).FindUnclaimedFleePointInRoom(m_pawn.GetRoomName());
		if(EqualEqual_ObjectObject(BarricadePoint, none))
		{
			BarricadePoint = SwatAIRepository(m_pawn.Level.AIRepo).FindRandomPointInRoom(m_pawn.GetRoomName(), 'PathNode');
		}
	}
	AssertWithDescription(NotEqual_ObjectObject(BarricadePoint, none), Concat_StrStr(Concat_StrStr(At_StrStr(At_StrStr("AI:", string(m_pawn)), " has no FleePoints in the room he is in (\""), string(m_pawn.GetRoomName())), "\") to barricade himself!  Add Flee Points to this room!"));
	if(BarricadePoint.IsA('FleePoint'))
	{
		FleePoint(BarricadePoint).ClaimPoint(m_pawn);
	}
	return;
}

latent function MoveToBarricadePoint()
{
	if(NotEqual_ObjectObject(BarricadePoint, none))
	{
		CurrentMoveToActorGoal = Class'SwatAICommon.MoveToActorGoal'.static.Allocate(self).;
		construct_AI_ResourceIntActor(movementResource(), achievingGoal.Priority, BarricadePoint);
		assert(NotEqual_ObjectObject(CurrentMoveToActorGoal, none));
		CurrentMoveToActorGoal.AddRef();
		CurrentMoveToActorGoal.SetRotateTowardsFirstPoint(true);
		CurrentMoveToActorGoal.SetRotateTowardsPointsDuringMovement(true);
		CurrentMoveToActorGoal.SetWalkThreshold(0.0000000);
		CurrentMoveToActorGoal.postGoal(self);
		waitForGoal(CurrentMoveToActorGoal);
		CurrentMoveToActorGoal.unPostGoal(self);
		CurrentMoveToActorGoal.Release();
		CurrentMoveToActorGoal = none;
	}
	return;
}

private function bool ShouldCrouchAtFleePoint()
{
	local FleePoint BarricadeFleePoint;

	if(NotEqual_ObjectObject(BarricadePoint, none))
	{
		BarricadeFleePoint = FleePoint(BarricadePoint);
		if(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(BarricadeFleePoint, none), BarricadeFleePoint.ShouldCrouchAtPoint), LessEqual_FloatFloat(FRand(), CrouchAtFleePointChance)))
		{
			return true;
		}
	}
	return false;
	return;
}

latent function AimAround()
{
	CurrentAimAroundGoal = Class'SwatAICommon.AimAroundGoal'.static.Allocate(self).;
	construct_AI_ResourceFloatFloat(weaponResource(), 1.5000000, 4.0000000);
	assert(NotEqual_ObjectObject(CurrentAimAroundGoal, none));
	CurrentAimAroundGoal.AddRef();
	CurrentAimAroundGoal.SetAimInnerFovDegrees(180.0000000);
	CurrentAimAroundGoal.SetAimOuterFovDegrees(360.0000000);
	CurrentAimAroundGoal.SetExtraDoorWeight(0.3330000);
	CurrentAimAroundGoal.SetAimWeapon(true);
	CurrentAimAroundGoal.postGoal(self);
	return;
}

private function PopulateDoorsInRoom()
{
	local NavigationPointList DoorPointsInRoom;
	local SwatAIRepository SwatAIRepo;
	local int i;
	local Door IterDoor;
	local ISwatDoor IterSwatDoor;

	SwatAIRepo = SwatAIRepository(m_pawn.Level.AIRepo);
	DoorPointsInRoom = SwatAIRepo.GetRoomNavigationPointsOfType(BarricadePoint.GetRoomName(m_pawn), 'Door');
	i = 0;
	J0x57:

	if(Less_IntInt(i, DoorPointsInRoom.GetSize()))
	{
		IterDoor = Door(DoorPointsInRoom.GetEntryAt(i));
		assert(NotEqual_ObjectObject(IterDoor, none));
		IterSwatDoor = ISwatDoor(IterDoor);
		assert(NotEqual_ObjectObject(IterSwatDoor, none));
		DoorsInRoom[DoorsInRoom.Length] = IterDoor;
		if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(Not_PreBool(IterDoor.IsEmptyDoorway()), Not_PreBool(IterSwatDoor.IsBroken())), Not_PreBool(IterDoor.IsOpening())), Not_PreBool(IterDoor.IsClosing())), Not_PreBool(IterSwatDoor.IsLocked())))
		{
			ClosableDoorsInRoom[ClosableDoorsInRoom.Length] = IterDoor;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x57;
	}
	SwatAIRepo.ReleaseNavigationPointList(DoorPointsInRoom);
	return;
}

private function bool DoesRoomHaveDoorsToCloseAndLock()
{
	return Greater_IntInt(ClosableDoorsInRoom.Length, 0);
	return;
}

private function Door GetClosestDoorToStimuliOrigin()
{
	local int i;
	local Door ClosestDoor, IterDoor;
	local float ClosestDistance, IterDistance;

	i = 0;
	J0x07:

	if(Less_IntInt(i, DoorsInRoom.Length))
	{
		IterDoor = DoorsInRoom[i];
		IterDistance = VSize2D(Subtract_VectorVector(IterDoor.Location, StimuliOrigin));
		if(OrOr_BoolBool(EqualEqual_ObjectObject(ClosestDoor, none), Less_FloatFloat(IterDistance, ClosestDistance)))
		{
			ClosestDoor = IterDoor;
			ClosestDistance = IterDistance;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return ClosestDoor;
	return;
}

private function Door GetClosestClosableDoorToStimuliOrigin()
{
	local int i;
	local Door ClosestDoor, IterDoor;
	local float ClosestDistance, IterDistance;

	i = 0;
	J0x07:

	if(Less_IntInt(i, ClosableDoorsInRoom.Length))
	{
		IterDoor = ClosableDoorsInRoom[i];
		IterDistance = VSize2D(Subtract_VectorVector(IterDoor.Location, StimuliOrigin));
		if(OrOr_BoolBool(EqualEqual_ObjectObject(ClosestDoor, none), Less_FloatFloat(IterDistance, ClosestDistance)))
		{
			ClosestDoor = IterDoor;
			ClosestDistance = IterDistance;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return ClosestDoor;
	return;
}

private function RemoveDoorFromCloseAndLockList(Door DoorToRemove)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, ClosableDoorsInRoom.Length))
	{
		if(EqualEqual_ObjectObject(ClosableDoorsInRoom[i], DoorToRemove))
		{
			ClosableDoorsInRoom.Remove(i, 1);
			// [Explicit Break]
			goto J0x45;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	J0x45:

	return;
}

latent function AimAtClosestDoor()
{
	local Door ClosestDoor;

	ClosestDoor = GetClosestDoorToStimuliOrigin();
	if(AndAnd_BoolBool(NotEqual_ObjectObject(ClosestDoor, none), m_pawn.CanHit(ClosestDoor)))
	{
		RemoveAimAroundGoal();
		CurrentAimAtTargetGoal = Class'SwatAICommon.AimAtTargetGoal'.static.Allocate(self).;
		construct_AI_ResourceIntActor(weaponResource(), achievingGoal.Priority, ClosestDoor);
		assert(NotEqual_ObjectObject(CurrentAimAtTargetGoal, none));
		CurrentAimAtTargetGoal.AddRef();
		CurrentAimAtTargetGoal.SetAimOnlyWhenCanHitTarget(true);
		CurrentAimAtTargetGoal.SetAimWeapon(true);
		CurrentAimAtTargetGoal.SetShouldFinishOnSuccess(true);
		CurrentAimAtTargetGoal.postGoal(self);
		Sleep(AimAtClosestDoorTime);
		CurrentAimAtTargetGoal.unPostGoal(self);
		CurrentAimAtTargetGoal.Release();
		CurrentAimAtTargetGoal = none;
	}
	return;
}

latent function CloseDoor(Door TargetDoor)
{
	if(ISwatDoor(TargetDoor).IsOpen())
	{
		assert(EqualEqual_ObjectObject(CurrentCloseDoorGoal, none));
		CurrentCloseDoorGoal = Class'SwatAICommon.CloseDoorGoal'.static.Allocate(self).;
		construct_AI_ResourceIntDoor(movementResource(), achievingGoal.Priority, TargetDoor);
		assert(NotEqual_ObjectObject(CurrentCloseDoorGoal, none));
		CurrentCloseDoorGoal.AddRef();
		CurrentCloseDoorGoal.SetRotateTowardsFirstPoint(true);
		CurrentCloseDoorGoal.SetRotateTowardsPointsDuringMovement(true);
		CurrentCloseDoorGoal.SetShouldWalkEntireMove(false);
		CurrentCloseDoorGoal.SetWalkThreshold(0.0000000);
		CurrentCloseDoorGoal.postGoal(self);
		waitForGoal(CurrentCloseDoorGoal);
		CurrentCloseDoorGoal.unPostGoal(self);
		CurrentCloseDoorGoal.Release();
		CurrentCloseDoorGoal = none;
	}
	return;
}

latent function LockDoor(Door TargetDoor)
{
	if(ISwatDoor(TargetDoor).CanBeLocked())
	{
		CurrentMoveToDoorGoal = Class'SwatAICommon.MoveToDoorGoal'.static.Allocate(self).;
		construct_AI_ResourceDoor(movementResource(), TargetDoor);
		assert(NotEqual_ObjectObject(CurrentMoveToDoorGoal, none));
		CurrentMoveToDoorGoal.AddRef();
		CurrentMoveToDoorGoal.SetRotateTowardsFirstPoint(true);
		CurrentMoveToDoorGoal.SetRotateTowardsPointsDuringMovement(true);
		CurrentMoveToDoorGoal.SetShouldWalkEntireMove(false);
		CurrentMoveToDoorGoal.SetWalkThreshold(0.0000000);
		CurrentMoveToDoorGoal.postGoal(self);
		waitForGoal(CurrentMoveToDoorGoal);
		CurrentMoveToDoorGoal.unPostGoal(self);
		CurrentMoveToDoorGoal.Release();
		CurrentMoveToDoorGoal = none;
		if(ISwatDoor(TargetDoor).CanBeLocked())
		{
			ISwatDoor(TargetDoor).Lock();
		}
	}
	return;
}

latent function CloseAndLockDoorsInRoom()
{
	local Door CurrentDoor;

	if(Less_FloatFloat(FRand(), CloseAndLockInitialDoorChance))
	{
		J0x0C:

		if(Greater_IntInt(ClosableDoorsInRoom.Length, 0))
		{
			CurrentDoor = GetClosestDoorToStimuliOrigin();
			RemoveDoorFromCloseAndLockList(CurrentDoor);
			CloseDoor(CurrentDoor);
			LockDoor(CurrentDoor);
			if(Greater_FloatFloat(FRand(), CloseAndLockSubsequentDoorChance))
			{
				// [Explicit Break]
				goto J0x57;
			}
			// [Loop Continue]
			goto J0x0C;
		}
	}
	J0x57:

	return;
}

function CreateDoorOpeningSensor()
{
	local int i;

	if(Greater_IntInt(ClosableDoorsInRoom.Length, 0))
	{
		DoorOpeningSensor = DoorOpeningSensor(Class'Tyrion.AI_Sensor'.static.activateSensor(self, Class'SwatAICommon.DoorOpeningSensor', characterResource(), 0.0000000, 1000000.0000000));
		assert(NotEqual_ObjectObject(DoorOpeningSensor, none));
		i = 0;
		J0x4E:

		if(Less_IntInt(i, ClosableDoorsInRoom.Length))
		{
			DoorOpeningSensor.AddDoor(ClosableDoorsInRoom[i]);
			AddAdd_PreInt(i);
			// [Loop Continue]
			goto J0x4E;
		}
	}
	return;
}

function RemoveAimAroundGoal()
{
	if(NotEqual_ObjectObject(CurrentAimAroundGoal, none))
	{
		CurrentAimAroundGoal.unPostGoal(self);
		CurrentAimAroundGoal.Release();
		CurrentAimAroundGoal = none;
	}
	return;
}

latent function ShootAtOpeningDoor()
{
	local float EndShootingTime;

	assert(EqualEqual_ObjectObject(AttackDoorGoal, none));
	assert(NotEqual_ObjectObject(DoorOpening, none));
	AttackDoorGoal = Class'SwatAICommon.AttackTargetGoal'.static.Allocate(self).;
	construct_AI_ResourceActor(weaponResource(), DoorOpening);
	assert(NotEqual_ObjectObject(AttackDoorGoal, none));
	AttackDoorGoal.AddRef();
	AttackDoorGoal.postGoal(self);
	EndShootingTime = Add_FloatFloat(Level.TimeSeconds, RandRange(MinShootingAtDoorsTime, MaxShootingAtDoorsTime));
	J0x8E:

	if(AndAnd_BoolBool(Less_FloatFloat(Level.TimeSeconds, EndShootingTime), m_pawn.CanHit(DoorOpening)))
	{
		yield();
		// [Loop Continue]
		goto J0x8E;
	}
	AttackDoorGoal.unPostGoal(self);
	AttackDoorGoal.Release();
	AttackDoorGoal = none;
	return;
}

private latent function AimAtOpeningDoor()
{
	assert(NotEqual_ObjectObject(DoorOpening, none));
	CurrentAimAtTargetGoal = Class'SwatAICommon.AimAtTargetGoal'.static.Allocate(self).;
	construct_AI_ResourceActor(weaponResource(), DoorOpening);
	assert(NotEqual_ObjectObject(CurrentAimAtTargetGoal, none));
	CurrentAimAtTargetGoal.AddRef();
	CurrentAimAtTargetGoal.SetAimOnlyWhenCanHitTarget(true);
	CurrentAimAtTargetGoal.postGoal(self);
	J0x6D:

	if(DoorOpening.IsOpening())
	{
		yield();
		// [Loop Continue]
		goto J0x6D;
	}
	CurrentAimAtTargetGoal.unPostGoal(self);
	CurrentAimAtTargetGoal.Release();
	CurrentAimAtTargetGoal = none;
	return;
}

state Running
{	J0x00:
	if(Not_PreBool(resource.requiredResourcesAvailable(achievingGoal.Priority, achievingGoal.Priority)))
	{
		yield();
		// [Loop Continue]
		goto J0x00;
	}
	useResources(Class'Tyrion.AI_Resource'.4);
	FindBarricadePoint();
	PopulateDoorsInRoom();
	AimAtClosestDoor();
	useResources(Class'Tyrion.AI_Resource'.2);
	if(bDelayBarricade)
	{
		Sleep(RandRange(MinBarricadeDelayTime, MaxBarricadeDelayTime));
	}
	CheckWeaponStatus();
	clearDummyMovementGoal();
	CreateDoorOpeningSensor();
	if(AndAnd_BoolBool(bCanCloseDoors, DoesRoomHaveDoorsToCloseAndLock()))
	{
		CloseAndLockDoorsInRoom();
	}
	MoveToBarricadePoint();
	useResources(Class'Tyrion.AI_Resource'.4);
	clearDummyWeaponGoal();
	AimAround();
	if(Less_FloatFloat(FRand(), ReactionSpeechChance))
	{
		ISwatEnemy(m_pawn).GetEnemySpeechManagerAction().TriggerBarricadeSpeech();
	}
	if(ShouldCrouchAtFleePoint())
	{
		m_pawn.ShouldCrouch(true);
	}
	Pause();
	if(m_pawn.CanHit(DoorOpening))
	{
		RemoveAimAroundGoal();
		if(AndAnd_BoolBool(Less_FloatFloat(FRand(), ShootAtDoorsChance), Not_PreBool(m_pawn.IsA('SwatUndercover'))))
		{
			ShootAtOpeningDoor();
		}
		else
		{
			AimAtOpeningDoor();
		}
		AimAround();
	}
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.BarricadeGoal'
}