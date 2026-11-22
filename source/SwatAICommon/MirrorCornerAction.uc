class MirrorCornerAction extends SwatCharacterAction
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) Actor TargetMirrorPoint;
var private MoveToLocationGoal CurrentMoveToLocationGoal;
var private RotateTowardRotationGoal CurrentRotateTowardRotationGoal;
var private UseOptiwandGoal CurrentUseOptiwandGoal;
var private Rotator MirrorCornerRotation;

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
	ISwatAI(m_pawn).UnlockAim();
	m_pawn.EnableCollisionAvoidance();
	return;
}

latent function MoveToMirrorPoint()
{
	CurrentMoveToLocationGoal = Class'SwatAICommon.MoveToLocationGoal'.static.Allocate(self).;
	construct_AI_ResourceIntVector(movementResource(), achievingGoal.Priority, IMirrorPoint(TargetMirrorPoint).GetMirroringFromPoint());
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

latent function RotateToMirrorCorner()
{
	local Vector MirrorToPoint;

	MirrorToPoint = IMirrorPoint(TargetMirrorPoint).GetMirroringToPoint();
	MirrorCornerRotation = Rotator(Subtract_VectorVector(MirrorToPoint, m_pawn.Location));
	CurrentRotateTowardRotationGoal = Class'SwatAICommon.RotateTowardRotationGoal'.static.Allocate(self).;
	Construct_AI_ResourceIntRotator(movementResource(), achievingGoal.Priority, MirrorCornerRotation);
	assert(NotEqual_ObjectObject(CurrentRotateTowardRotationGoal, none));
	CurrentRotateTowardRotationGoal.AddRef();
	CurrentRotateTowardRotationGoal.postGoal(self);
	waitForGoal(CurrentRotateTowardRotationGoal);
	CurrentRotateTowardRotationGoal.unPostGoal(self);
	CurrentRotateTowardRotationGoal.Release();
	CurrentRotateTowardRotationGoal = none;
	ISwatAI(m_pawn).AimToRotation(MirrorCornerRotation);
	ISwatAI(m_pawn).LockAim();
	ISwatAI(m_pawn).AnimSnapBaseToAim();
	return;
}

latent function MirrorAroundCorner()
{
	CurrentUseOptiwandGoal = Class'SwatAICommon.UseOptiwandGoal'.static.Allocate(self).;
	construct_AI_ResourceVector(weaponResource(), Vector(MirrorCornerRotation));
	assert(NotEqual_ObjectObject(CurrentUseOptiwandGoal, none));
	CurrentUseOptiwandGoal.AddRef();
	CurrentUseOptiwandGoal.SetMirrorAroundCorner();
	CurrentUseOptiwandGoal.postGoal(self);
	waitForGoal(CurrentUseOptiwandGoal);
	CurrentUseOptiwandGoal.unPostGoal(self);
	CurrentUseOptiwandGoal.Release();
	CurrentUseOptiwandGoal = none;
	return;
}

state Running
{Begin:

	useResources(Class'Tyrion.AI_Resource'.2);
	MoveToMirrorPoint();
	m_pawn.DisableCollisionAvoidance();
	RotateToMirrorCorner();
	useResources(Class'Tyrion.AI_Resource'.4);
	clearDummyWeaponGoal();
	MirrorAroundCorner();
	succeed();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.MirrorCornerGoal'
}