class StackedUpAction extends SwatCharacterAction
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

const kStackedUpUpdateTime = 0.333;

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
	ISwatAI(m_pawn).UnsetUpperBodyAnimBehavior(4);
	return;
}

function StackupPoint GetStackUpPoint()
{
	return StackedUpGoal(achievingGoal).GetStackUpPoint();
	return;
}

latent function StackUp()
{
	CurrentMoveToActorGoal = Class'SwatAICommon.MoveToActorGoal'.static.Allocate(self).;
	construct_AI_ResourceIntActor(movementResource(), achievingGoal.Priority, GetStackUpPoint());
	assert(NotEqual_ObjectObject(CurrentMoveToActorGoal, none));
	CurrentMoveToActorGoal.AddRef();
	CurrentMoveToActorGoal.SetRotateTowardsPointsDuringMovement(false);
	CurrentMoveToActorGoal.SetShouldWalkEntireMove(false);
	CurrentMoveToActorGoal.postGoal(self);
	J0x81:

	if(AndAnd_BoolBool(AndAnd_BoolBool(Not_PreBool(CurrentMoveToActorGoal.hasCompleted()), Not_PreBool(m_pawn.IsAvoidingCollision())), Not_PreBool(IsStackUpPointBlocked())))
	{
		yield();
		// [Loop Continue]
		goto J0x81;
	}
	CurrentMoveToActorGoal.unPostGoal(self);
	CurrentMoveToActorGoal.Release();
	CurrentMoveToActorGoal = none;
	if(Not_PreBool(IsRotatedToStackUpPointRotation()))
	{
		RotateToStackUpPointRotation();
	}
	return;
}

latent function RotateToStackUpPointRotation()
{
	local StackupPoint StackupPoint;

	StackupPoint = GetStackUpPoint();
	assert(NotEqual_ObjectObject(StackupPoint, none));
	CurrentRotateTowardRotationGoal = Class'SwatAICommon.RotateTowardRotationGoal'.static.Allocate(self).;
	Construct_AI_ResourceIntRotator(movementResource(), achievingGoal.Priority, StackupPoint.Rotation);
	assert(NotEqual_ObjectObject(CurrentRotateTowardRotationGoal, none));
	CurrentRotateTowardRotationGoal.AddRef();
	CurrentRotateTowardRotationGoal.postGoal(self);
	waitForGoal(CurrentRotateTowardRotationGoal);
	CurrentRotateTowardRotationGoal.unPostGoal(self);
	CurrentRotateTowardRotationGoal.Release();
	CurrentRotateTowardRotationGoal = none;
	return;
}

function bool IsRotatedToStackUpPointRotation()
{
	local StackupPoint StackupPoint;

	StackupPoint = GetStackUpPoint();
	assert(NotEqual_ObjectObject(StackupPoint, none));
	return EqualEqual_IntInt(WrapAngle0To2Pi(ISwatAI(m_pawn).GetAimOrientation().Yaw), WrapAngle0To2Pi(int(ISwatAI(m_pawn).GetAnimBaseYaw())));
	return;
}

private function bool IsBlockedByAnotherOfficerAtCenterPoint()
{
	local Vector CenterPoint, OfficerIterCenterPoint;
	local ISwatAI.AIDoorUsageSide DummyUsageSide;
	local int i;
	local ElementSquadInfo Element;
	local Pawn OfficerIter;
	local Door TargetDoor;

	TargetDoor = GetStackUpPoint().ParentDoor;
	CenterPoint = ISwatDoor(TargetDoor).GetCenterOpenPoint(m_pawn, DummyUsageSide);
	if(Less_FloatFloat(VSize2D(Subtract_VectorVector(CenterPoint, GetStackUpPoint().Location)), Multiply_FloatFloat(Add_FloatFloat(m_pawn.CollisionRadius, m_pawn.CollisionSoftRadiusOffset), 2.0000000)))
	{
		Element = SwatAIRepository(Level.AIRepo).GetElementSquad();
		i = 0;
		J0xA5:

		if(Less_IntInt(i, Element.pawns.Length))
		{
			OfficerIter = Element.pawns[i];
			if(AndAnd_BoolBool(NotEqual_ObjectObject(OfficerIter, m_pawn), Class'Engine.Pawn'.static.checkConscious(OfficerIter)))
			{
				OfficerIterCenterPoint = ISwatDoor(TargetDoor).GetCenterOpenPoint(OfficerIter, DummyUsageSide);
				if(AndAnd_BoolBool(EqualEqual_VectorVector(OfficerIterCenterPoint, CenterPoint), OfficerIter.ReachedLocation(CenterPoint)))
				{
					return true;
				}
			}
			AddAdd_PreInt(i);
			// [Loop Continue]
			goto J0xA5;
		}
	}
	return false;
	return;
}

private function bool IsStackUpPointBlocked()
{
	local int i;
	local ElementSquadInfo Element;
	local Pawn OfficerIter, Player;
	local StackupPoint StackupPoint;

	StackupPoint = GetStackUpPoint();
	assert(NotEqual_ObjectObject(StackupPoint, none));
	Element = SwatAIRepository(Level.AIRepo).GetElementSquad();
	i = 0;
	J0x41:

	if(Less_IntInt(i, Element.pawns.Length))
	{
		OfficerIter = Element.pawns[i];
		if(AndAnd_BoolBool(NotEqual_ObjectObject(OfficerIter, m_pawn), Class'Engine.Pawn'.static.checkConscious(OfficerIter)))
		{
			if(OfficerIter.ReachedDestination(StackupPoint))
			{
				return true;
			}
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x41;
	}
	Player = Level.GetLocalPlayerController().Pawn;
	if(Class'Engine.Pawn'.static.checkConscious(Player))
	{
		if(Player.ReachedDestination(StackupPoint))
		{
			return true;
		}
	}
	return false;
	return;
}

latent function WaitLoop()
{
	local bool ReachedStackUpPoint;

	J0x00:
	if(Class'Engine.Pawn'.static.checkConscious(m_pawn))
	{
		ReachedStackUpPoint = m_pawn.ReachedDestination(GetStackUpPoint());
		if(AndAnd_BoolBool(Not_PreBool(IsStackUpPointBlocked()), Not_PreBool(m_pawn.IsAvoidingCollision())))
		{
			if(AndAnd_BoolBool(Not_PreBool(ReachedStackUpPoint), Not_PreBool(IsBlockedByAnotherOfficerAtCenterPoint())))
			{
				ISwatAI(m_pawn).SetUpperBodyAnimBehavior(1, 4);
				clearDummyMovementGoal();
				StackUp();
				useResources(Class'Tyrion.AI_Resource'.4);
				ISwatAI(m_pawn).UnsetUpperBodyAnimBehavior(4);
			}
			else
			{
				if(AndAnd_BoolBool(ReachedStackUpPoint, Not_PreBool(IsRotatedToStackUpPointRotation())))
				{
					ISwatAI(m_pawn).SetUpperBodyAnimBehavior(1, 4);
					clearDummyMovementGoal();
					RotateToStackUpPointRotation();
					useResources(Class'Tyrion.AI_Resource'.4);
					ISwatAI(m_pawn).UnsetUpperBodyAnimBehavior(4);
				}
			}
		}
		Sleep(0.3330000);
		// [Loop Continue]
		goto J0x00;
	}
	return;
}

state Running
{	J0x00:
	if(Not_PreBool(resource.requiredResourcesAvailable(achievingGoal.Priority, achievingGoal.Priority)))
	{
		yield();
		// [Loop Continue]
		goto J0x00;
	}
	useResources(Or_IntInt(Class'Tyrion.AI_Resource'.4, Class'Tyrion.AI_Resource'.2));
	WaitLoop();
	succeed();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.StackedUpGoal'
}