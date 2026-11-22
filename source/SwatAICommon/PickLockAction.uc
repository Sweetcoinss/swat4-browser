class PickLockAction extends SwatCharacterAction implements IInterestedInDoorOpening
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) Door TargetDoor;
var(Parameters) NavigationPoint PostPickLockDestination;
var private RotateTowardPointGoal CurrentRotateTowardPointGoal;
var private RotateTowardRotationGoal CurrentRotateTowardRotationGoal;
var private MoveToActorGoal CurrentMoveToActorGoal;
var private MoveToLocationGoal CurrentMoveToLocationGoal;
var private HandheldEquipment Toolkit;
var private bool bDoorHasOpened;
var private bool bMovedToPickLock;

function cleanup()
{
	super(AI_CharacterAction).cleanup();
	if(AndAnd_BoolBool(NotEqual_ObjectObject(Toolkit, none), Not_PreBool(Toolkit.IsIdle())))
	{
		if(Toolkit.IsBeingUsed())
		{
			IAmAQualifiedUseEquipment(Toolkit).InstantInterrupt();
		}
		else
		{
			Toolkit.AIInterrupt();
		}
	}
	if(NotEqual_ObjectObject(CurrentMoveToLocationGoal, none))
	{
		CurrentMoveToLocationGoal.Release();
		CurrentMoveToLocationGoal = none;
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
	if(NotEqual_ObjectObject(CurrentRotateTowardRotationGoal, none))
	{
		CurrentRotateTowardRotationGoal.Release();
		CurrentRotateTowardRotationGoal = none;
	}
	UnsetPickLockAim();
	ISwatDoor(TargetDoor).UnRegisterInterestedInDoorOpening(self);
	m_pawn.EnableCollisionAvoidance();
	ISwatOfficer(m_pawn).InstantReEquipFiredWeapon();
	return;
}

function NotifyDoorOpening(Door TargetDoor)
{
	if(Not_PreBool(bMovedToPickLock))
	{
		instantSucceed();
	}
	else
	{
		bDoorHasOpened = true;
		if(AndAnd_BoolBool(NotEqual_ObjectObject(Toolkit, none), Toolkit.IsBeingUsed()))
		{
			IAmAQualifiedUseEquipment(Toolkit).InstantInterrupt();
		}
	}
	return;
}

private function SetPickLockAim()
{
	ISwatAI(m_pawn).SetUpperBodyAnimBehavior(2, 9);
	ISwatAI(m_pawn).AimAtPoint(GetLockPickPoint());
	return;
}

private function UnsetPickLockAim()
{
	ISwatAI(m_pawn).UnsetUpperBodyAnimBehavior(9);
	return;
}

function Vector GetPickLockPoint()
{
	local ISwatDoor SwatDoorTarget;
	local Vector LockPickPoint;
	local Rotator DummyRotation;

	SwatDoorTarget = ISwatDoor(TargetDoor);
	assert(NotEqual_ObjectObject(SwatDoorTarget, none));
	SwatDoorTarget.GetOpenPositions(m_pawn, false, LockPickPoint, DummyRotation);
	return LockPickPoint;
	return;
}

latent function MoveToPickLockPoint()
{
	CurrentMoveToLocationGoal = Class'SwatAICommon.MoveToLocationGoal'.static.Allocate(self).;
	construct_AI_ResourceIntVector(movementResource(), achievingGoal.Priority, GetPickLockPoint());
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

private function Vector GetLockPickPoint()
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

latent function RotateToLockPickPoint()
{
	CurrentRotateTowardPointGoal = Class'SwatAICommon.RotateTowardPointGoal'.static.Allocate(self).;
	construct_AI_ResourceIntVector(movementResource(), achievingGoal.Priority, GetLockPickPoint());
	assert(NotEqual_ObjectObject(CurrentRotateTowardPointGoal, none));
	CurrentRotateTowardPointGoal.AddRef();
	CurrentRotateTowardPointGoal.postGoal(self);
	waitForGoal(CurrentRotateTowardPointGoal);
	CurrentRotateTowardPointGoal.unPostGoal(self);
	CurrentRotateTowardPointGoal.Release();
	CurrentRotateTowardPointGoal = none;
	return;
}

latent function EquipToolkit()
{
	Toolkit = ISwatOfficer(m_pawn).GetItemAtSlot(8);
	assert(NotEqual_ObjectObject(Toolkit, none));
	Toolkit.LatentWaitForIdleAndEquip();
	return;
}

latent function PickLock()
{
	EquipToolkit();
	if(Not_PreBool(bDoorHasOpened))
	{
		SetPickLockAim();
		IAmUsedOnOther(Toolkit).LatentUseOn(TargetDoor);
		UnsetPickLockAim();
	}
	ISwatOfficer(m_pawn).ReEquipFiredWeapon();
	return;
}

latent function MoveToPostPickLockLocation()
{
	if(NotEqual_ObjectObject(PostPickLockDestination, none))
	{
		CurrentMoveToActorGoal = Class'SwatAICommon.MoveToActorGoal'.static.Allocate(self).;
		construct_AI_ResourceIntActor(movementResource(), achievingGoal.Priority, PostPickLockDestination);
		assert(NotEqual_ObjectObject(CurrentMoveToActorGoal, none));
		CurrentMoveToActorGoal.AddRef();
		CurrentMoveToActorGoal.SetRotateTowardsPointsDuringMovement(true);
		CurrentMoveToActorGoal.postGoal(self);
		waitForGoal(CurrentMoveToActorGoal);
		CurrentMoveToActorGoal.unPostGoal(self);
		CurrentMoveToActorGoal.Release();
		CurrentMoveToActorGoal = none;
	}
	return;
}

latent function RotateToPostPickLockRotation()
{
	if(NotEqual_ObjectObject(PostPickLockDestination, none))
	{
		CurrentRotateTowardRotationGoal = Class'SwatAICommon.RotateTowardRotationGoal'.static.Allocate(self).;
		Construct_AI_ResourceIntRotator(movementResource(), achievingGoal.Priority, PostPickLockDestination.Rotation);
		assert(NotEqual_ObjectObject(CurrentRotateTowardRotationGoal, none));
		CurrentRotateTowardRotationGoal.AddRef();
		CurrentRotateTowardRotationGoal.postGoal(self);
		waitForGoal(CurrentRotateTowardRotationGoal);
		CurrentRotateTowardRotationGoal.unPostGoal(self);
		CurrentRotateTowardRotationGoal.Release();
		CurrentRotateTowardRotationGoal = none;
	}
	return;
}

state Running
{Begin:

	if(AndAnd_BoolBool(AndAnd_BoolBool(TargetDoor.IsClosed(), Not_PreBool(TargetDoor.IsOpening())), Not_PreBool(TargetDoor.IsBroken())))
	{
		ISwatDoor(TargetDoor).RegisterInterestedInDoorOpening(self);
		useResources(Class'Tyrion.AI_Resource'.2);
		ISwatOfficer(m_pawn).GetOfficerSpeechManagerAction().TriggerDeployingToolkitSpeech();
		bMovedToPickLock = true;
		MoveToPickLockPoint();
		if(Not_PreBool(bDoorHasOpened))
		{
			m_pawn.DisableCollisionAvoidance();
			RotateToLockPickPoint();
			if(Not_PreBool(bDoorHasOpened))
			{
				useResources(Class'Tyrion.AI_Resource'.4);
				PickLock();
				clearDummyMovementGoal();
				ISwatOfficer(m_pawn).GetOfficerSpeechManagerAction().TriggerFinishedLockPickSpeech();
			}
			m_pawn.EnableCollisionAvoidance();
		}
		MoveToPostPickLockLocation();
		RotateToPostPickLockRotation();
	}
	succeed();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.PickLockGoal'
}