class SecureEvidenceAction extends SwatCharacterAction
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

const kSecureOnFloorThreshold = 48;

var(Parameters) private IEvidence EvidenceTarget;
var private MoveToActorGoal CurrentMoveToActorGoal;
var private RotateTowardRotationGoal CurrentRotateTowardRotationGoal;

function cleanup()
{
	super(AI_CharacterAction).cleanup();
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
	m_pawn.EnableCollisionAvoidance();
	return;
}

function IEvidence GetEvidenceTarget()
{
	return EvidenceTarget;
	return;
}

function goalNotAchievedCB(AI_Goal Goal, AI_Action Child, ActionBase.ACT_ErrorCodes errorCode)
{
	super(AI_Action).goalNotAchievedCB(Goal, Child, errorCode);
	if(EqualEqual_ObjectObject(Goal, CurrentMoveToActorGoal))
	{
		instantFail(errorCode);
	}
	return;
}

latent function MoveIntoPosition()
{
	assert(NotEqual_ObjectObject(Actor(EvidenceTarget), none));
	CurrentMoveToActorGoal = Class'SwatAICommon.MoveToActorGoal'.static.Allocate(self).;
	construct_AI_ResourceIntActor(movementResource(), achievingGoal.Priority, Actor(EvidenceTarget));
	assert(NotEqual_ObjectObject(CurrentMoveToActorGoal, none));
	CurrentMoveToActorGoal.AddRef();
	CurrentMoveToActorGoal.SetAcceptNearbyPath(true);
	CurrentMoveToActorGoal.SetRotateTowardsPointsDuringMovement(true);
	CurrentMoveToActorGoal.SetMoveToThreshold(40.0000000);
	CurrentMoveToActorGoal.postGoal(self);
	waitForGoal(CurrentMoveToActorGoal);
	CurrentMoveToActorGoal.unPostGoal(self);
	CurrentMoveToActorGoal.Release();
	CurrentMoveToActorGoal = none;
	return;
}

latent function RotateTowardsTarget()
{
	assert(NotEqual_ObjectObject(Actor(EvidenceTarget), none));
	CurrentRotateTowardRotationGoal = Class'SwatAICommon.RotateTowardRotationGoal'.static.Allocate(self).;
	Construct_AI_ResourceIntRotator(movementResource(), achievingGoal.Priority, Rotator(Subtract_VectorVector(Actor(EvidenceTarget).Location, m_pawn.Location)));
	assert(NotEqual_ObjectObject(CurrentRotateTowardRotationGoal, none));
	CurrentRotateTowardRotationGoal.AddRef();
	CurrentRotateTowardRotationGoal.postGoal(self);
	waitForGoal(CurrentRotateTowardRotationGoal);
	CurrentRotateTowardRotationGoal.unPostGoal(self);
	CurrentRotateTowardRotationGoal.Release();
	CurrentRotateTowardRotationGoal = none;
	return;
}

latent function SecureEvidence()
{
	local Actor EvidenceActor;
	local float ZDiff;
	local int AnimSpecialChannel;

	m_pawn.DisableCollisionAvoidance();
	EvidenceActor = Actor(EvidenceTarget);
	assert(NotEqual_ObjectObject(EvidenceActor, none));
	if(EvidenceTarget.CanBeUsedNow())
	{
		ZDiff = Subtract_FloatFloat(m_pawn.Location.Z, EvidenceActor.Location.Z);
		if(Greater_FloatFloat(ZDiff, float(48)))
		{
			AnimSpecialChannel = m_pawn.AnimPlaySpecial('secureWeaponFloor', 0.1000000);
		}
		else
		{
			AnimSpecialChannel = m_pawn.AnimPlaySpecial('secureWeaponTable', 0.1000000);
		}
		m_pawn.FinishAnim(AnimSpecialChannel);
		m_pawn.EnableCollisionAvoidance();
		if(EvidenceActor.IsA('FiredWeaponModel'))
		{
			ISwatOfficer(m_pawn).GetOfficerSpeechManagerAction().TriggerWeaponSecuredSpeech();
		}
		else
		{
			ISwatOfficer(m_pawn).GetOfficerSpeechManagerAction().TriggerEvidenceSecuredSpeech();
		}
	}
	else
	{
		if(EvidenceActor.IsA('FiredWeaponModel'))
		{
			ISwatOfficer(m_pawn).GetOfficerSpeechManagerAction().TriggerWeaponNotFoundSpeech();
		}
		else
		{
			ISwatOfficer(m_pawn).GetOfficerSpeechManagerAction().TriggerEvidenceNotFoundSpeech();
		}
	}
	return;
}

state Running
{Begin:

	useResources(Class'Tyrion.AI_Resource'.2);
	MoveIntoPosition();
	RotateTowardsTarget();
	useResources(Class'Tyrion.AI_Resource'.4);
	SecureEvidence();
	succeed();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.SecureEvidenceGoal'
}