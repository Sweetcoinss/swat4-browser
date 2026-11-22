class UseBreachingChargeAction extends SwatCharacterAction implements IInterestedInDoorOpening
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

var private RotateTowardPointGoal CurrentRotateTowardPointGoal;
var private RotateTowardActorGoal CurrentRotateTowardActorGoal;
var private MoveToActorGoal CurrentMoveToActorGoal;
var private MoveToLocationGoal CurrentMoveToLocationGoal;
var private HandheldEquipment BreachingCharge;
var private HandheldEquipment Detonator;
var(Parameters) private Door TargetDoor;
var(Parameters) private NavigationPoint SafeLocation;
var(Parameters) IInterestedInDetonatorEquipping InterestedInDetonatorEquippingClient;

function cleanup()
{
	super(AI_CharacterAction).cleanup();
	if(NotEqual_ObjectObject(BreachingCharge, none))
	{
		if(BreachingCharge.IsBeingUsed())
		{
			IAmAQualifiedUseEquipment(BreachingCharge).InstantInterrupt();
		}
		else
		{
			BreachingCharge.AIInterrupt();
		}
	}
	if(AndAnd_BoolBool(NotEqual_ObjectObject(Detonator, none), Not_PreBool(Detonator.IsIdle())))
	{
		Detonator.AIInterrupt();
	}
	ISwatOfficer(m_pawn).InstantReEquipFiredWeapon();
	if(NotEqual_ObjectObject(CurrentRotateTowardActorGoal, none))
	{
		CurrentRotateTowardActorGoal.Release();
		CurrentRotateTowardActorGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentRotateTowardPointGoal, none))
	{
		CurrentRotateTowardPointGoal.Release();
		CurrentRotateTowardPointGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentMoveToActorGoal, none))
	{
		CurrentMoveToActorGoal.Release();
		CurrentMoveToActorGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentMoveToLocationGoal, none))
	{
		CurrentMoveToLocationGoal.Release();
		CurrentMoveToLocationGoal = none;
	}
	if(m_pawn.bIsCrouched)
	{
		m_pawn.ShouldCrouch(false);
	}
	ISwatDoor(TargetDoor).UnRegisterInterestedInDoorOpening(self);
	m_pawn.EnableCollisionAvoidance();
	return;
}

function NotifyDoorOpening(Door TargetDoor)
{
	instantSucceed();
	return;
}

function bool IsC2ChargeDeployedOnThisSideOfDoor()
{
	local ISwatDoor SwatDoorTarget;

	SwatDoorTarget = ISwatDoor(TargetDoor);
	assert(NotEqual_ObjectObject(SwatDoorTarget, none));
	if(SwatDoorTarget.PointIsToMyLeft(m_pawn.Location))
	{
		return SwatDoorTarget.IsChargePlacedOnLeft();
	}
	else
	{
		return SwatDoorTarget.IsChargePlacedOnRight();
	}
	return;
}

function Vector GetDeployPoint()
{
	local ISwatDoor SwatDoorTarget;
	local Vector DeployPoint;
	local Rotator DummyRotation;

	SwatDoorTarget = ISwatDoor(TargetDoor);
	assert(NotEqual_ObjectObject(SwatDoorTarget, none));
	SwatDoorTarget.GetOpenPositions(m_pawn, false, DeployPoint, DummyRotation);
	return DeployPoint;
	return;
}

latent function MoveToDeployPoint()
{
	CurrentMoveToLocationGoal = Class'SwatAICommon.MoveToLocationGoal'.static.Allocate(self).;
	construct_AI_ResourceIntVector(movementResource(), achievingGoal.Priority, GetDeployPoint());
	assert(NotEqual_ObjectObject(CurrentMoveToLocationGoal, none));
	CurrentMoveToLocationGoal.AddRef();
	CurrentMoveToLocationGoal.SetRotateTowardsPointsDuringMovement(true);
	CurrentMoveToLocationGoal.postGoal(self);
	waitForGoal(CurrentMoveToLocationGoal);
	CurrentMoveToLocationGoal.unPostGoal(self);
	CurrentMoveToLocationGoal.Release();
	CurrentMoveToLocationGoal = none;
	return;
}

private function Vector GetPlacementPoint()
{
	local Vector PlacementPoint;

	if(ISwatDoor(TargetDoor).ActorIsToMyLeft(TargetDoor))
	{
		PlacementPoint = TargetDoor.GetBoneCoords('C2ChargeLeft', true).Origin;
	}
	else
	{
		PlacementPoint = TargetDoor.GetBoneCoords('C2ChargeRight', true).Origin;
	}
	return PlacementPoint;
	return;
}

latent function RotateToPlacementPoint()
{
	assert(NotEqual_ObjectObject(TargetDoor, none));
	CurrentRotateTowardPointGoal = Class'SwatAICommon.RotateTowardPointGoal'.static.Allocate(self).;
	construct_AI_ResourceIntVector(movementResource(), achievingGoal.Priority, GetPlacementPoint());
	assert(NotEqual_ObjectObject(CurrentRotateTowardPointGoal, none));
	CurrentRotateTowardPointGoal.AddRef();
	CurrentRotateTowardPointGoal.postGoal(self);
	waitForGoal(CurrentRotateTowardPointGoal);
	CurrentRotateTowardPointGoal.unPostGoal(self);
	CurrentRotateTowardPointGoal.Release();
	CurrentRotateTowardPointGoal = none;
	return;
}

latent function RotateToDoor()
{
	assert(NotEqual_ObjectObject(TargetDoor, none));
	CurrentRotateTowardActorGoal = Class'SwatAICommon.RotateTowardActorGoal'.static.Allocate(self).;
	construct_AI_ResourceIntActor(movementResource(), achievingGoal.Priority, TargetDoor);
	assert(NotEqual_ObjectObject(CurrentRotateTowardActorGoal, none));
	CurrentRotateTowardActorGoal.AddRef();
	CurrentRotateTowardActorGoal.postGoal(self);
	waitForGoal(CurrentRotateTowardActorGoal);
	CurrentRotateTowardActorGoal.unPostGoal(self);
	CurrentRotateTowardActorGoal.Release();
	CurrentRotateTowardActorGoal = none;
	return;
}

function EquipBreachingCharge()
{
	BreachingCharge = ISwatOfficer(m_pawn).GetItemAtSlot(7);
	assert(NotEqual_ObjectObject(BreachingCharge, none));
	assert(BreachingCharge.IsA('C2Charge'));
	BreachingCharge.AIInstantEquip();
	return;
}

latent function UseBreachingCharge()
{
	assert(NotEqual_ObjectObject(TargetDoor, none));
	assert(NotEqual_ObjectObject(BreachingCharge, none));
	J0x16:

	if(BreachingCharge.IsBeingEquipped())
	{
		yield();
		// [Loop Continue]
		goto J0x16;
	}
	if(Not_PreBool(BreachingCharge.IsEquipped()))
	{
		BreachingCharge.LatentWaitForIdleAndEquip();
	}
	m_pawn.ShouldCrouch(true);
	IAmUsedOnOther(BreachingCharge).LatentUseOn(TargetDoor);
	m_pawn.ShouldCrouch(false);
	return;
}

latent function MoveToSafeLocation()
{
	CurrentMoveToActorGoal = Class'SwatAICommon.MoveToActorGoal'.static.Allocate(self).;
	construct_AI_ResourceIntActor(movementResource(), achievingGoal.Priority, SafeLocation);
	assert(NotEqual_ObjectObject(CurrentMoveToActorGoal, none));
	CurrentMoveToActorGoal.AddRef();
	CurrentMoveToActorGoal.SetRotateTowardsPointsDuringMovement(true);
	CurrentMoveToActorGoal.postGoal(self);
	EquipDetonator();
	waitForGoal(CurrentMoveToActorGoal);
	CurrentMoveToActorGoal.unPostGoal(self);
	CurrentMoveToActorGoal.Release();
	CurrentMoveToActorGoal = none;
	return;
}

function EquipDetonator()
{
	local ISwatOfficer Officer;

	Officer = ISwatOfficer(m_pawn);
	assert(NotEqual_ObjectObject(Officer, none));
	Detonator = Officer.GetItemAtSlot(12);
	assert(NotEqual_ObjectObject(Detonator, none));
	if(NotEqual_ObjectObject(InterestedInDetonatorEquippingClient, none))
	{
		InterestedInDetonatorEquippingClient.NotifyDetonatorEquipping();
	}
	Detonator.AIInstantEquip();
	return;
}

latent function BlowDoor()
{
	local ISwatOfficer Officer;

	Officer = ISwatOfficer(m_pawn);
	assert(NotEqual_ObjectObject(Officer, none));
	Officer.SetDoorToBlowC2On(TargetDoor);
	assert(NotEqual_ObjectObject(Detonator, none));
	J0x3A:

	if(Detonator.IsBeingEquipped())
	{
		yield();
		// [Loop Continue]
		goto J0x3A;
	}
	if(Not_PreBool(Detonator.IsEquipped()))
	{
		if(NotEqual_ObjectObject(InterestedInDetonatorEquippingClient, none))
		{
			InterestedInDetonatorEquippingClient.NotifyDetonatorEquipping();
		}
		Detonator.LatentWaitForIdleAndEquip();
	}
	ISwatDoor(TargetDoor).UnRegisterInterestedInDoorOpening(self);
	Detonator.LatentUse();
	Officer.SetDoorToBlowC2On(none);
	return;
}

function TriggerReportedDeployingC2Speech()
{
	ISwatOfficer(m_pawn).GetOfficerSpeechManagerAction().TriggerReportedDeployingC2Speech();
	return;
}

state Running
{Begin:

	if(AndAnd_BoolBool(AndAnd_BoolBool(TargetDoor.IsClosed(), Not_PreBool(TargetDoor.IsOpening())), Not_PreBool(TargetDoor.IsBroken())))
	{
		ISwatDoor(TargetDoor).RegisterInterestedInDoorOpening(self);
		useResources(Class'Tyrion.AI_Resource'.2);
		if(Not_PreBool(IsC2ChargeDeployedOnThisSideOfDoor()))
		{
			TriggerReportedDeployingC2Speech();
			EquipBreachingCharge();
			MoveToDeployPoint();
			m_pawn.DisableCollisionAvoidance();
			RotateToPlacementPoint();
			useResources(Class'Tyrion.AI_Resource'.4);
			UseBreachingCharge();
			m_pawn.EnableCollisionAvoidance();
			clearDummyMovementGoal();
		}
		MoveToSafeLocation();
		RotateToDoor();
		useResources(Class'Tyrion.AI_Resource'.4);
		BlowDoor();
	}
	succeed();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.UseBreachingChargeGoal'
}