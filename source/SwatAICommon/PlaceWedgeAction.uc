class PlaceWedgeAction extends SwatCharacterAction implements IInterestedInDoorOpening
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

var private HandheldEquipment Wedge;
var(Parameters) Door TargetDoor;
var private MoveToDoorGoal CurrentMoveToDoorGoal;
var private RotateTowardPointGoal CurrentRotateTowardPointGoal;

function cleanup()
{
	super(AI_CharacterAction).cleanup();
	if(NotEqual_ObjectObject(Wedge, none))
	{
		if(Wedge.IsBeingUsed())
		{
			IAmAQualifiedUseEquipment(Wedge).InstantInterrupt();
		}
		else
		{
			Wedge.AIInterrupt();
		}
	}
	ISwatOfficer(m_pawn).InstantReEquipFiredWeapon();
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

function UpdateOfficersKnowledge()
{
	local SwatAIRepository SwatAIRepo;

	SwatAIRepo = SwatAIRepository(m_pawn.Level.AIRepo);
	assert(NotEqual_ObjectObject(SwatAIRepo, none));
	SwatAIRepo.NotifyOfficersDoorWedged(TargetDoor);
	return;
}

private function Vector GetPlaceWedgePoint()
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

latent function RotateToPlaceWedgePoint()
{
	CurrentRotateTowardPointGoal = Class'SwatAICommon.RotateTowardPointGoal'.static.Allocate(self).;
	construct_AI_ResourceIntVector(movementResource(), achievingGoal.Priority, GetPlaceWedgePoint());
	assert(NotEqual_ObjectObject(CurrentRotateTowardPointGoal, none));
	CurrentRotateTowardPointGoal.AddRef();
	CurrentRotateTowardPointGoal.postGoal(self);
	waitForGoal(CurrentRotateTowardPointGoal);
	CurrentRotateTowardPointGoal.unPostGoal(self);
	CurrentRotateTowardPointGoal.Release();
	CurrentRotateTowardPointGoal = none;
	return;
}

latent function MoveToPlaceWedge()
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

latent function PlaceWedge()
{
	assert(NotEqual_ObjectObject(TargetDoor, none));
	Wedge = ISwatOfficer(m_pawn).GetItemAtSlot(10);
	assert(NotEqual_ObjectObject(Wedge, none));
	Wedge.LatentWaitForIdleAndEquip();
	m_pawn.ShouldCrouch(true);
	IAmUsedOnOther(Wedge).LatentUseOn(TargetDoor);
	m_pawn.ShouldCrouch(false);
	ISwatOfficer(m_pawn).ReEquipFiredWeapon();
	return;
}

state Running
{Begin:

	if(AndAnd_BoolBool(AndAnd_BoolBool(TargetDoor.IsClosed(), Not_PreBool(TargetDoor.IsOpening())), Not_PreBool(TargetDoor.IsBroken())))
	{
		ISwatDoor(TargetDoor).RegisterInterestedInDoorOpening(self);
		useResources(Class'Tyrion.AI_Resource'.2);
		MoveToPlaceWedge();
		m_pawn.DisableCollisionAvoidance();
		RotateToPlaceWedgePoint();
		useResources(Class'Tyrion.AI_Resource'.4);
		PlaceWedge();
		m_pawn.EnableCollisionAvoidance();
		ISwatOfficer(m_pawn).GetOfficerSpeechManagerAction().TriggerWedgePlacedSpeech();
	}
	UpdateOfficersKnowledge();
	succeed();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.PlaceWedgeGoal'
}