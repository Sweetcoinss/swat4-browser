class MirrorDoorAction extends SwatCharacterAction
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) Door TargetDoor;
var private MoveToLocationGoal CurrentMoveToLocationGoal;
var private RotateTowardRotationGoal CurrentRotateTowardRotationGoal;
var private UseOptiwandGoal CurrentUseOptiwandGoal;
var private bool bCrouchWhileMirroring;
var private bool bMirrorAroundCorner;
var private ISwatDoor SwatTargetDoor;
var private Rotator MirroringRotation;
var private Vector MirroringFromPoint;
var private Rotator MirroringFromRotation;

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
	if(NotEqual_ObjectObject(CurrentUseOptiwandGoal, none))
	{
		CurrentUseOptiwandGoal.Release();
		CurrentUseOptiwandGoal = none;
	}
	m_pawn.EnableCollisionAvoidance();
	return;
}

function SetMirroringType()
{
	if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(Not_PreBool(TargetDoor.IsEmptyDoorway()), TargetDoor.IsClosed()), Not_PreBool(TargetDoor.IsOpening())), Not_PreBool(TargetDoor.IsBroken())))
	{
		bMirrorAroundCorner = false;
		bCrouchWhileMirroring = true;
	}
	else
	{
		bCrouchWhileMirroring = false;
		bMirrorAroundCorner = true;
	}
	return;
}

function SetMirroringOrientation()
{
	local Vector CenterOpenPoint;
	local Rotator CenterOpenRotation;

	SwatTargetDoor.GetOpenPositions(m_pawn, false, CenterOpenPoint, CenterOpenRotation);
	MirroringFromPoint = CenterOpenPoint;
	MirroringFromRotation = CenterOpenRotation;
	MirroringRotation = CenterOpenRotation;
	return;
}

latent function MoveToMirroringPosition()
{
	CurrentMoveToLocationGoal = Class'SwatAICommon.MoveToLocationGoal'.static.Allocate(self).;
	construct_AI_ResourceIntVector(movementResource(), achievingGoal.Priority, MirroringFromPoint);
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

latent function RotateToMirroringRotation()
{
	assert(EqualEqual_ObjectObject(CurrentRotateTowardRotationGoal, none));
	CurrentRotateTowardRotationGoal = Class'SwatAICommon.RotateTowardRotationGoal'.static.Allocate(self).;
	Construct_AI_ResourceIntRotator(movementResource(), achievingGoal.Priority, MirroringFromRotation);
	assert(NotEqual_ObjectObject(CurrentRotateTowardRotationGoal, none));
	CurrentRotateTowardRotationGoal.AddRef();
	CurrentRotateTowardRotationGoal.postGoal(self);
	waitForGoal(CurrentRotateTowardRotationGoal);
	CurrentRotateTowardRotationGoal.unPostGoal(self);
	CurrentRotateTowardRotationGoal.Release();
	CurrentRotateTowardRotationGoal = none;
	return;
}

function Vector GetMirrorViewOrigin()
{
	if(SwatTargetDoor.ActorIsToMyLeft(m_pawn))
	{
		return TargetDoor.GetBoneCoords('OptiwandRIGHT', true).Origin;
	}
	else
	{
		return TargetDoor.GetBoneCoords('OptiwandLEFT', true).Origin;
	}
	return;
}

latent function UseMirror()
{
	assert(EqualEqual_ObjectObject(CurrentUseOptiwandGoal, none));
	CurrentUseOptiwandGoal = Class'SwatAICommon.UseOptiwandGoal'.static.Allocate(self).;
	construct_AI_ResourceVector(weaponResource(), Vector(MirroringRotation));
	assert(NotEqual_ObjectObject(CurrentUseOptiwandGoal, none));
	CurrentUseOptiwandGoal.AddRef();
	CurrentUseOptiwandGoal.SetOverloadedViewOrigin(GetMirrorViewOrigin());
	if(bMirrorAroundCorner)
	{
		CurrentUseOptiwandGoal.SetMirrorAroundCorner();
	}
	CurrentUseOptiwandGoal.postGoal(self);
	waitForGoal(CurrentUseOptiwandGoal);
	CurrentUseOptiwandGoal.unPostGoal(self);
	CurrentUseOptiwandGoal.Release();
	CurrentUseOptiwandGoal = none;
	return;
}

latent function MirrorDoor()
{
	useResources(Class'Tyrion.AI_Resource'.2);
	SwatTargetDoor = ISwatDoor(TargetDoor);
	assert(NotEqual_ObjectObject(SwatTargetDoor, none));
	SetMirroringType();
	SetMirroringOrientation();
	MoveToMirroringPosition();
	m_pawn.DisableCollisionAvoidance();
	RotateToMirroringRotation();
	useResources(Class'Tyrion.AI_Resource'.4);
	clearDummyWeaponGoal();
	UseMirror();
	m_pawn.EnableCollisionAvoidance();
	return;
}

state Running
{Begin:

	MirrorDoor();
	succeed();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.MirrorDoorGoal'
}