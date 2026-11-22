class DisableTargetAction extends SwatCharacterAction implements IInterestedInDoorOpening
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

const kDisableOnFloorThreshold = 48;

var(Parameters) Actor Target;
var(Parameters) Vector DisableFromPoint;
var(Parameters) bool bUseMoveToThreshold;
var private MoveToLocationGoal CurrentMoveToLocationGoal;
var private RotateTowardRotationGoal CurrentRotateTowardRotationGoal;
var private bool bMovedToDisableTarget;
var private bool bDoorHasOpened;
var private HandheldEquipment Toolkit;
var private ISwatDoor TargetSwatDoor;
var config float DistanceFromTargetToDisable;

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
	if(NotEqual_ObjectObject(CurrentRotateTowardRotationGoal, none))
	{
		CurrentRotateTowardRotationGoal.Release();
		CurrentRotateTowardRotationGoal = none;
	}
	if(m_pawn.bIsCrouched)
	{
		m_pawn.ShouldCrouch(false);
	}
	m_pawn.EnableCollisionAvoidance();
	if(NotEqual_ObjectObject(TargetSwatDoor, none))
	{
		TargetSwatDoor.UnRegisterInterestedInDoorOpening(self);
	}
	ISwatOfficer(m_pawn).InstantReEquipFiredWeapon();
	UnsetDisableTargetAim();
	return;
}

private function SetDisableTargetAim()
{
	ISwatAI(m_pawn).SetUpperBodyAnimBehavior(2, 9);
	ISwatAI(m_pawn).AimAtActor(Target);
	return;
}

private function UnsetDisableTargetAim()
{
	ISwatAI(m_pawn).UnsetUpperBodyAnimBehavior(9);
	return;
}

private function TriggerCompletedDisableSpeech()
{
	if(Target.IsA('BombBase'))
	{
		ISwatOfficer(m_pawn).GetOfficerSpeechManagerAction().TriggerReportedBombDisabledSpeech();
	}
	else
	{
		if(Target.IsA('BoobyTrap'))
		{
			ISwatOfficer(m_pawn).GetOfficerSpeechManagerAction().TriggerReportedTrapDisabledSpeech();
		}
		else
		{
			ISwatOfficer(m_pawn).GetOfficerSpeechManagerAction().TriggerReportedGenericDisabledSpeech();
		}
	}
	return;
}

function NotifyDoorOpening(Door TargetDoor)
{
	if(Not_PreBool(bMovedToDisableTarget))
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

latent function MoveIntoPosition()
{
	CurrentMoveToLocationGoal = Class'SwatAICommon.MoveToLocationGoal'.static.Allocate(self).;
	construct_AI_ResourceIntVector(movementResource(), achievingGoal.Priority, DisableFromPoint);
	assert(NotEqual_ObjectObject(CurrentMoveToLocationGoal, none));
	CurrentMoveToLocationGoal.AddRef();
	CurrentMoveToLocationGoal.SetRotateTowardsPointsDuringMovement(true);
	CurrentMoveToLocationGoal.SetAcceptNearbyPath(true);
	if(bUseMoveToThreshold)
	{
		CurrentMoveToLocationGoal.SetMoveToThreshold(Add_FloatFloat(m_pawn.CollisionRadius, DistanceFromTargetToDisable));
	}
	CurrentMoveToLocationGoal.postGoal(self);
	J0xAD:

	if(Not_PreBool(CurrentMoveToLocationGoal.hasCompleted()))
	{
		if(OrOr_BoolBool(AndAnd_BoolBool(Target.IsA('DeployedC2ChargeBase'), Target.bHidden), bDoorHasOpened))
		{
			succeed();
		}
		yield();
		// [Loop Continue]
		goto J0xAD;
	}
	CurrentMoveToLocationGoal.unPostGoal(self);
	CurrentMoveToLocationGoal.Release();
	CurrentMoveToLocationGoal = none;
	return;
}

latent function RotateTowardsTarget()
{
	CurrentRotateTowardRotationGoal = Class'SwatAICommon.RotateTowardRotationGoal'.static.Allocate(self).;
	Construct_AI_ResourceIntRotator(movementResource(), achievingGoal.Priority, Rotator(Subtract_VectorVector(Target.Location, m_pawn.Location)));
	assert(NotEqual_ObjectObject(CurrentRotateTowardRotationGoal, none));
	CurrentRotateTowardRotationGoal.AddRef();
	CurrentRotateTowardRotationGoal.postGoal(self);
	waitForGoal(CurrentRotateTowardRotationGoal);
	CurrentRotateTowardRotationGoal.unPostGoal(self);
	CurrentRotateTowardRotationGoal.Release();
	CurrentRotateTowardRotationGoal = none;
	return;
}

latent function DisableTarget()
{
	local float ZDiff;

	m_pawn.DisableCollisionAvoidance();
	ZDiff = Subtract_FloatFloat(m_pawn.Location.Z, Target.Location.Z);
	if(Greater_FloatFloat(ZDiff, float(48)))
	{
		m_pawn.ShouldCrouch(true);
	}
	Toolkit = ISwatOfficer(m_pawn).GetItemAtSlot(8);
	assert(NotEqual_ObjectObject(Toolkit, none));
	Toolkit.LatentWaitForIdleAndEquip();
	if(Not_PreBool(bDoorHasOpened))
	{
		SetDisableTargetAim();
		IAmUsedOnOther(Toolkit).LatentUseOn(Target);
		UnsetDisableTargetAim();
	}
	ISwatOfficer(m_pawn).ReEquipFiredWeapon();
	m_pawn.EnableCollisionAvoidance();
	return;
}

state Running
{Begin:

	if(Target.IsA('DeployedC2ChargeBase'))
	{
		if(Target.bHidden)
		{
			succeed();
		}
		TargetSwatDoor = IDeployedC2Charge(Target).GetDoorDeployedOn();
		TargetSwatDoor.RegisterInterestedInDoorOpening(self);
	}
	useResources(Class'Tyrion.AI_Resource'.2);
	ISwatOfficer(m_pawn).GetOfficerSpeechManagerAction().TriggerRepliedDisablingSpeech();
	bMovedToDisableTarget = true;
	MoveIntoPosition();
	RotateTowardsTarget();
	useResources(Class'Tyrion.AI_Resource'.4);
	DisableTarget();
	if(Not_PreBool(bDoorHasOpened))
	{
		TriggerCompletedDisableSpeech();
	}
	succeed();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.DisableTargetGoal'
}