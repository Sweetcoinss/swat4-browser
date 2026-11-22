class UseBreachingShotgunAction extends SwatCharacterAction implements IInterestedInDoorOpening
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

var private AimAtPointGoal CurrentAimAtPointGoal;
var private MoveToLocationGoal CurrentMoveToLocationGoal;
var private MoveToActorGoal CurrentMoveToActorGoal;
var private FiredWeapon BreachingShotgun;
var private Vector BreachAimLocation;
var(Parameters) private Door TargetDoor;
var(Parameters) private NavigationPoint PostBreachPoint;

function initAction(AI_Resource R, AI_Goal Goal)
{
	local ISwatDoor SwatDoor;

	super.initAction(R, Goal);
	SwatDoor = ISwatDoor(TargetDoor);
	assert(NotEqual_ObjectObject(SwatDoor, none));
	BreachAimLocation = SwatDoor.GetBreachAimPoint(m_pawn);
	return;
}

function cleanup()
{
	local ISwatOfficer Officer;

	Officer = ISwatOfficer(m_pawn);
	assert(NotEqual_ObjectObject(Officer, none));
	super(AI_CharacterAction).cleanup();
	if(NotEqual_ObjectObject(CurrentAimAtPointGoal, none))
	{
		CurrentAimAtPointGoal.Release();
		CurrentAimAtPointGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentMoveToLocationGoal, none))
	{
		CurrentMoveToLocationGoal.Release();
		CurrentMoveToLocationGoal = none;
	}
	ISwatDoor(TargetDoor).UnRegisterInterestedInDoorOpening(self);
	m_pawn.EnableCollisionAvoidance();
	if(AndAnd_BoolBool(NotEqual_ObjectObject(BreachingShotgun, none), Not_PreBool(BreachingShotgun.IsIdle())))
	{
		BreachingShotgun.AIInterrupt();
	}
	Officer.InstantReEquipFiredWeapon();
	Officer.UnsetUpperBodyAnimBehavior(12);
	return;
}

function NotifyDoorOpening(Door TargetDoor)
{
	instantSucceed();
	return;
}

private latent function CheckBreachingShotgunAmmunition()
{
	assert(NotEqual_ObjectObject(BreachingShotgun, none));
	assert(BreachingShotgun.IsEquipped());
	if(BreachingShotgun.NeedsReload())
	{
		if(BreachingShotgun.CanReload())
		{
			BreachingShotgun.LatentReload();
		}
		else
		{
			instantFail(15);
		}
	}
	return;
}

latent function EquipBreachingShotgun()
{
	local ISwatOfficer Officer;

	Officer = ISwatOfficer(m_pawn);
	assert(NotEqual_ObjectObject(Officer, none));
	BreachingShotgun = FiredWeapon(Officer.GetItemAtSlot(7));
	assert(NotEqual_ObjectObject(BreachingShotgun, none));
	assert(BreachingShotgun.IsA('BreachingShotgun'));
	if(Not_PreBool(BreachingShotgun.IsEquipped()))
	{
		BreachingShotgun.LatentWaitForIdleAndEquip();
	}
	CheckBreachingShotgunAmmunition();
	Officer.SetUpperBodyAnimBehavior(2, 12);
	return;
}

function Vector GetLocationToBreachFrom()
{
	local ISwatDoor SwatDoorTarget;
	local Vector BreachFrom;

	SwatDoorTarget = ISwatDoor(TargetDoor);
	assert(NotEqual_ObjectObject(SwatDoorTarget, none));
	BreachFrom = SwatDoorTarget.GetBreachFromPoint(m_pawn);
	return BreachFrom;
	return;
}

latent function MoveToBreachingLocation()
{
	CurrentMoveToLocationGoal = Class'SwatAICommon.MoveToLocationGoal'.static.Allocate(self).;
	construct_AI_ResourceIntVector(movementResource(), achievingGoal.Priority, GetLocationToBreachFrom());
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

latent function MoveToPostBreachingPoint()
{
	CurrentMoveToActorGoal = Class'SwatAICommon.MoveToActorGoal'.static.Allocate(self).;
	construct_AI_ResourceIntActor(movementResource(), achievingGoal.Priority, PostBreachPoint);
	assert(NotEqual_ObjectObject(CurrentMoveToActorGoal, none));
	CurrentMoveToActorGoal.AddRef();
	CurrentMoveToActorGoal.SetRotateTowardsPointsDuringMovement(false);
	CurrentMoveToActorGoal.postGoal(self);
	waitForGoal(CurrentMoveToActorGoal);
	CurrentMoveToActorGoal.unPostGoal(self);
	CurrentMoveToActorGoal.Release();
	CurrentMoveToActorGoal = none;
	return;
}

latent function AimAtDoorKnob()
{
	CurrentAimAtPointGoal = Class'SwatAICommon.AimAtPointGoal'.static.Allocate(self).;
	construct_AI_ResourceIntVector(weaponResource(), achievingGoal.Priority, BreachAimLocation);
	assert(NotEqual_ObjectObject(CurrentAimAtPointGoal, none));
	CurrentAimAtPointGoal.AddRef();
	CurrentAimAtPointGoal.postGoal(self);
	return;
}

private function StopAimingAtDoorKnob()
{
	if(NotEqual_ObjectObject(CurrentAimAtPointGoal, none))
	{
		CurrentAimAtPointGoal.unPostGoal(self);
		CurrentAimAtPointGoal.Release();
		CurrentAimAtPointGoal = none;
	}
	return;
}

latent function BreachDoorWithShotgun()
{
	ISwatAI(m_pawn).SetWeaponTargetLocation(BreachAimLocation);
	Sleep(0.4000000);
	CheckBreachingShotgunAmmunition();
	ISwatDoor(TargetDoor).UnRegisterInterestedInDoorOpening(self);
	BreachingShotgun.SetPerfectAimNextShot();
	BreachingShotgun.LatentUse();
	if(Not_PreBool(ISwatDoor(TargetDoor).IsBroken()))
	{
		ISwatDoor(TargetDoor).Blasted(m_pawn);
	}
	return;
}

function TriggerReportedDeployingShotgunSpeech()
{
	ISwatOfficer(m_pawn).GetOfficerSpeechManagerAction().TriggerReportedDeployingShotgunSpeech();
	return;
}

state Running
{Begin:

	if(AndAnd_BoolBool(AndAnd_BoolBool(TargetDoor.IsClosed(), Not_PreBool(TargetDoor.IsOpening())), Not_PreBool(TargetDoor.IsBroken())))
	{
		ISwatDoor(TargetDoor).RegisterInterestedInDoorOpening(self);
		useResources(Class'Tyrion.AI_Resource'.2);
		TriggerReportedDeployingShotgunSpeech();
		MoveToBreachingLocation();
		useResources(Class'Tyrion.AI_Resource'.4);
		m_pawn.DisableCollisionAvoidance();
		clearDummyWeaponGoal();
		AimAtDoorKnob();
		EquipBreachingShotgun();
		BreachDoorWithShotgun();
		StopAimingAtDoorKnob();
		ISwatOfficer(m_pawn).ReEquipFiredWeapon();
		m_pawn.EnableCollisionAvoidance();
		useResources(Class'Tyrion.AI_Resource'.2);
		clearDummyMovementGoal();
		if(NotEqual_ObjectObject(PostBreachPoint, none))
		{
			MoveToPostBreachingPoint();
		}
	}
	succeed();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.UseBreachingShotgunGoal'
}