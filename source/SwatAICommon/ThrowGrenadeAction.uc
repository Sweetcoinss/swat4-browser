class ThrowGrenadeAction extends SwatCharacterAction
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) Vector TargetLocation;
var(Parameters) Vector ThrowFromLocation;
var(Parameters) HandheldEquipment.EquipmentSlot GrenadeSlot;
var(Parameters) ISwatAI.AIThrowSide ThrowSide;
var(Parameters) Rotator ThrowRotation;
var(Parameters) bool ThrowRotationOverridden;
var(Parameters) bool bWaitToThrowGrenade;
var(Parameters) IInterestedGrenadeThrowing ThrowClient;
var private MoveToLocationGoal CurrentMoveToLocationGoal;
var private RotateTowardRotationGoal CurrentRotateTowardRotationGoal;
var private UseGrenadeGoal CurrentUseGrenadeGoal;

function cleanup()
{
	super(AI_CharacterAction).cleanup();
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
	if(NotEqual_ObjectObject(CurrentUseGrenadeGoal, none))
	{
		CurrentUseGrenadeGoal.Release();
		CurrentUseGrenadeGoal = none;
	}
	return;
}

function goalNotAchievedCB(AI_Goal Goal, AI_Action Child, ActionBase.ACT_ErrorCodes errorCode)
{
	super(AI_Action).goalNotAchievedCB(Goal, Child, errorCode);
	if(m_pawn.logTyrion)
	{
		Log(Concat_StrStr(string(Goal.Name), " was not achieved.  succeeding!"));
	}
	instantSucceed();
	return;
}

function NotifyThrowGrenade()
{
	assert(EqualEqual_BoolBool(bWaitToThrowGrenade, true));
	assert(NotEqual_ObjectObject(CurrentUseGrenadeGoal, none));
	CurrentUseGrenadeGoal.NotifyThrowGrenade();
	return;
}

latent function RotateToThrowGrenade()
{
	if(Not_PreBool(ThrowRotationOverridden))
	{
		ThrowRotation = Rotator(Subtract_VectorVector(TargetLocation, Pawn.Location));
	}
	CurrentRotateTowardRotationGoal = Class'SwatAICommon.RotateTowardRotationGoal'.static.Allocate(self).;
	Construct_AI_ResourceIntRotator(movementResource(), achievingGoal.Priority, ThrowRotation);
	assert(NotEqual_ObjectObject(CurrentRotateTowardRotationGoal, none));
	CurrentRotateTowardRotationGoal.AddRef();
	CurrentRotateTowardRotationGoal.postGoal(self);
	waitForGoal(CurrentRotateTowardRotationGoal);
	CurrentRotateTowardRotationGoal.unPostGoal(self);
	CurrentRotateTowardRotationGoal.Release();
	CurrentRotateTowardRotationGoal = none;
	return;
}

private function bool IsRotatedToThrowRotation()
{
	return EqualEqual_IntInt(WrapAngle0To2Pi(ISwatAI(m_pawn).GetAimOrientation().Yaw), WrapAngle0To2Pi(int(ISwatAI(m_pawn).GetAnimBaseYaw())));
	return;
}

latent function MoveToThrowFromLocation()
{
	CurrentMoveToLocationGoal = Class'SwatAICommon.MoveToLocationGoal'.static.Allocate(self).;
	construct_AI_ResourceIntVector(movementResource(), achievingGoal.Priority, ThrowFromLocation);
	assert(NotEqual_ObjectObject(CurrentMoveToLocationGoal, none));
	CurrentMoveToLocationGoal.AddRef();
	CurrentMoveToLocationGoal.SetRotateTowardsPointsDuringMovement(false);
	CurrentMoveToLocationGoal.SetShouldWalkEntireMove(false);
	CurrentMoveToLocationGoal.postGoal(self);
	waitForGoal(CurrentMoveToLocationGoal);
	CurrentMoveToLocationGoal.unPostGoal(self);
	CurrentMoveToLocationGoal.Release();
	CurrentMoveToLocationGoal = none;
	if(Not_PreBool(IsRotatedToThrowRotation()))
	{
		RotateToThrowGrenade();
	}
	return;
}

function ThrowGrenade()
{
	ISwatAI(m_pawn).SetThrowSide(ThrowSide);
	CurrentUseGrenadeGoal = Class'SwatAICommon.UseGrenadeGoal'.static.Allocate(self).;
	construct_AI_ResourceByteVector(weaponResource(), GrenadeSlot, TargetLocation);
	assert(NotEqual_ObjectObject(CurrentUseGrenadeGoal, none));
	CurrentUseGrenadeGoal.AddRef();
	CurrentUseGrenadeGoal.SetWaitToThrowGrenade(bWaitToThrowGrenade);
	if(NotEqual_ObjectObject(ThrowClient, none))
	{
		CurrentUseGrenadeGoal.RegisterForGrenadeThrowing(ThrowClient);
	}
	CurrentUseGrenadeGoal.postGoal(self);
	return;
}

state Running
{Begin:

	useResources(Class'Tyrion.AI_Resource'.2);
	RotateToThrowGrenade();
	useResources(Class'Tyrion.AI_Resource'.4);
	clearDummyWeaponGoal();
	ThrowGrenade();
	J0x34:

	if(AndAnd_BoolBool(Class'Engine.Pawn'.static.checkConscious(m_pawn), Not_PreBool(CurrentUseGrenadeGoal.hasCompleted())))
	{
		if(Not_PreBool(m_pawn.ReachedLocation(ThrowFromLocation)))
		{
			clearDummyMovementGoal();
			MoveToThrowFromLocation();
			useResources(Class'Tyrion.AI_Resource'.4);
		}
		else
		{
			if(Not_PreBool(IsRotatedToThrowRotation()))
			{
				clearDummyMovementGoal();
				RotateToThrowGrenade();
				useResources(Class'Tyrion.AI_Resource'.4);
			}
		}
		yield();
		// [Loop Continue]
		goto J0x34;
	}
	succeed();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.ThrowGrenadeGoal'
}