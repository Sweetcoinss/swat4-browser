class RemoveWedgeAction extends SwatCharacterAction implements IInterestedInDoorOpening
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

var private HandheldEquipment Toolkit;
var private Actor Wedge;
var(Parameters) Door TargetDoor;
var private MoveToDoorGoal CurrentMoveToDoorGoal;
var private RotateTowardPointGoal CurrentRotateTowardPointGoal;

function cleanup()
{
	super(AI_CharacterAction).cleanup();
	if(NotEqual_ObjectObject(Toolkit, none))
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
	ISwatOfficer(m_pawn).InstantReEquipFiredWeapon();
	if(m_pawn.bIsCrouched)
	{
		m_pawn.ShouldCrouch(false);
	}
	if(NotEqual_ObjectObject(CurrentMoveToDoorGoal, none))
	{
		CurrentMoveToDoorGoal.Release();
		CurrentMoveToDoorGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentRotateTowardPointGoal, none))
	{
		CurrentRotateTowardPointGoal.Release();
		CurrentRotateTowardPointGoal = none;
	}
	ISwatDoor(TargetDoor).UnRegisterInterestedInDoorOpening(self);
	UnsetRemoveWedgeAim();
	m_pawn.EnableCollisionAvoidance();
	return;
}

function NotifyDoorOpening(Door TargetDoor)
{
	instantSucceed();
	return;
}

private function SetRemoveWedgeAim()
{
	ISwatAI(m_pawn).SetUpperBodyAnimBehavior(2, 9);
	ISwatAI(m_pawn).AimAtActor(Wedge);
	return;
}

private function UnsetRemoveWedgeAim()
{
	ISwatAI(m_pawn).UnsetUpperBodyAnimBehavior(9);
	return;
}

function UpdateOfficersKnowledge()
{
	local SwatAIRepository SwatAIRepo;

	SwatAIRepo = SwatAIRepository(m_pawn.Level.AIRepo);
	assert(NotEqual_ObjectObject(SwatAIRepo, none));
	SwatAIRepo.NotifyOfficersDoorWedgeRemoved(TargetDoor);
	return;
}

latent function MoveToRemoveWedge()
{
	CurrentMoveToDoorGoal = Class'SwatAICommon.MoveToDoorGoal'.static.Allocate(self).;
	construct_AI_ResourceDoor(AI_Resource(m_pawn.MovementAI), TargetDoor);
	assert(NotEqual_ObjectObject(CurrentMoveToDoorGoal, none));
	CurrentMoveToDoorGoal.AddRef();
	CurrentMoveToDoorGoal.SetRotateTowardsPointsDuringMovement(true);
	CurrentMoveToDoorGoal.postGoal(self);
	waitForGoal(CurrentMoveToDoorGoal);
	CurrentMoveToDoorGoal.unPostGoal(self);
	CurrentMoveToDoorGoal.Release();
	CurrentMoveToDoorGoal = none;
	return;
}

private function Vector GetRemoveWedgePoint()
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

latent function RotateToRemoveWedgePoint()
{
	CurrentRotateTowardPointGoal = Class'SwatAICommon.RotateTowardPointGoal'.static.Allocate(self).;
	construct_AI_ResourceIntVector(movementResource(), achievingGoal.Priority, GetRemoveWedgePoint());
	assert(NotEqual_ObjectObject(CurrentRotateTowardPointGoal, none));
	CurrentRotateTowardPointGoal.AddRef();
	CurrentRotateTowardPointGoal.postGoal(self);
	waitForGoal(CurrentRotateTowardPointGoal);
	CurrentRotateTowardPointGoal.unPostGoal(self);
	CurrentRotateTowardPointGoal.Release();
	CurrentRotateTowardPointGoal = none;
	return;
}

latent function RemoveWedge()
{
	Wedge = ISwatDoor(TargetDoor).GetDeployedWedge();
	if(NotEqual_ObjectObject(Wedge, none))
	{
		m_pawn.DisableCollisionAvoidance();
		Toolkit = ISwatOfficer(m_pawn).GetItemAtSlot(8);
		assert(NotEqual_ObjectObject(Toolkit, none));
		Toolkit.LatentWaitForIdleAndEquip();
		m_pawn.ShouldCrouch(true);
		Wedge = ISwatDoor(TargetDoor).GetDeployedWedge();
		if(NotEqual_ObjectObject(Wedge, none))
		{
			SetRemoveWedgeAim();
			IAmUsedOnOther(Toolkit).LatentUseOn(Wedge);
			UnsetRemoveWedgeAim();
			ISwatOfficer(m_pawn).GetOfficerSpeechManagerAction().TriggerWedgeRemovedSpeech();
		}
		else
		{
			ISwatOfficer(m_pawn).GetOfficerSpeechManagerAction().TriggerWedgeNotFoundSpeech();
		}
		m_pawn.ShouldCrouch(false);
		m_pawn.EnableCollisionAvoidance();
		ISwatOfficer(m_pawn).ReEquipFiredWeapon();
	}
	else
	{
		ISwatOfficer(m_pawn).GetOfficerSpeechManagerAction().TriggerWedgeNotFoundSpeech();
	}
	return;
}

state Running
{Begin:

	if(AndAnd_BoolBool(AndAnd_BoolBool(TargetDoor.IsClosed(), Not_PreBool(TargetDoor.IsOpening())), Not_PreBool(TargetDoor.IsBroken())))
	{
		ISwatDoor(TargetDoor).RegisterInterestedInDoorOpening(self);
		useResources(Class'Tyrion.AI_Resource'.2);
		MoveToRemoveWedge();
		RotateToRemoveWedgePoint();
		useResources(Class'Tyrion.AI_Resource'.4);
		RemoveWedge();
	}
	UpdateOfficersKnowledge();
	succeed();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.RemoveWedgeGoal'
}