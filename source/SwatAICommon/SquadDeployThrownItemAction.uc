class SquadDeployThrownItemAction extends OfficerSquadAction
	collapsecategories
	hidecategories(Object,InternalParameters);

const kMinDistanceToTarget = 64.0;

var private ThrowGrenadeGoal CurrentThrowGrenadeGoal;
var private MoveToActorGoal CurrentMoveToActorGoal;
var(Parameters) HandheldEquipment.EquipmentSlot ThrownItemSlot;
var(Parameters) Vector TargetThrowLocation;
var private Actor ThrowFrom;

function cleanup()
{
	super(ActionBase).cleanup();
	if(NotEqual_ObjectObject(CurrentThrowGrenadeGoal, none))
	{
		CurrentThrowGrenadeGoal.Release();
		CurrentThrowGrenadeGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentMoveToActorGoal, none))
	{
		CurrentMoveToActorGoal.__ShouldStopMovingDelegate__Delegate = None;
		CurrentMoveToActorGoal.Release();
		CurrentMoveToActorGoal = none;
	}
	return;
}

protected function NotifyPawnDied(Pawn Pawn)
{
	super.NotifyPawnDied(Pawn);
	assert(NotEqual_ObjectObject(Pawn, none));
	instantFail(1);
	return;
}

function goalNotAchievedCB(AI_Goal Goal, AI_Action Child, ActionBase.ACT_ErrorCodes errorCode)
{
	super(AI_Action).goalNotAchievedCB(Goal, Child, errorCode);
	if(EqualEqual_ObjectObject(Goal, CurrentMoveToActorGoal))
	{
		instantSucceed();
	}
	return;
}

latent function DeployThrownItem()
{
	local Pawn ThrowingOfficer;
	local NavigationPoint PointToThrowFrom;

	ThrowingOfficer = GetThrowingOfficer(ThrownItemSlot);
	if(NotEqual_ObjectObject(ThrowingOfficer, none))
	{
		GetPointToThrowFromForOfficer(ThrowingOfficer);
		PointToThrowFrom = ;
		return if(NotEqual_ObjectObject(PointToThrowFrom, none))
		{
			MoveOfficerToThrowingPosition(ThrowingOfficer, PointToThrowFrom);
			ThrowGrenadeAtTargetLocation(ThrowingOfficer, ThrownItemSlot);
		}
		else
		{
			ISwatOfficer(ThrowingOfficer).GetOfficerSpeechManagerAction().TriggerCantDeployThrownSpeech();
			instantSucceed();
		}
	}
	else
	{
		instantFail(11);
	}
	return;
}

latent function MoveOfficerToThrowingPosition(Pawn Officer, NavigationPoint Destination)
{
	CurrentMoveToActorGoal = Class'SwatAICommon.MoveToActorGoal'.static.Allocate(self).;
	construct_AI_ResourceIntActor(AI_Resource(Officer.MovementAI), 80, Destination);
	assert(NotEqual_ObjectObject(CurrentMoveToActorGoal, none));
	CurrentMoveToActorGoal.AddRef();
	CurrentMoveToActorGoal.SetRotateTowardsPointsDuringMovement(true);
	CurrentMoveToActorGoal.SetShouldWalkEntireMove(false);
	CurrentMoveToActorGoal.__ShouldStopMovingDelegate__Delegate = CanThrowGrenade;
	CurrentMoveToActorGoal.postGoal(self);
	waitForGoal(CurrentMoveToActorGoal);
	CurrentMoveToActorGoal.unPostGoal(self);
	CurrentMoveToActorGoal.__ShouldStopMovingDelegate__Delegate = None;
	CurrentMoveToActorGoal.Release();
	CurrentMoveToActorGoal = none;
	return;
}

latent function ThrowGrenadeAtTargetLocation(Pawn Officer, HandheldEquipment.EquipmentSlot ThrownItemSlot)
{
	CurrentThrowGrenadeGoal = Class'SwatAICommon.ThrowGrenadeGoal'.static.Allocate(self).;
	construct_AI_ResourceVectorVectorByteBool(AI_Resource(Officer.CharacterAI), TargetThrowLocation, Officer.Location, ThrownItemSlot);
	assert(NotEqual_ObjectObject(CurrentThrowGrenadeGoal, none));
	CurrentThrowGrenadeGoal.AddRef();
	CurrentThrowGrenadeGoal.SetThrowSide(0);
	CurrentThrowGrenadeGoal.postGoal(self);
	waitForGoal(CurrentThrowGrenadeGoal);
	CurrentThrowGrenadeGoal.unPostGoal(self);
	CurrentThrowGrenadeGoal.Release();
	CurrentThrowGrenadeGoal = none;
	return;
}

function Pawn GetThrowingOfficer(HandheldEquipment.EquipmentSlot ThrownItemSlot)
{
	local int i;
	local Pawn IterOfficer, ClosestOfficer;
	local float IterDistance, ClosestDistance;

	i = 0;
	J0x07:

	if(Less_IntInt(i, squad().pawns.Length))
	{
		IterOfficer = squad().pawns[i];
		if(NotEqual_ObjectObject(ISwatOfficer(IterOfficer).GetThrownWeapon(ThrownItemSlot), none))
		{
			IterDistance = VSize(Subtract_VectorVector(IterOfficer.Location, TargetThrowLocation));
			if(OrOr_BoolBool(EqualEqual_ObjectObject(ClosestOfficer, none), Less_FloatFloat(IterDistance, ClosestDistance)))
			{
				ClosestOfficer = IterOfficer;
				ClosestDistance = IterDistance;
			}
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return ClosestOfficer;
	return;
}

private function bool CanOfficerThrowFromNavigationPoint(Pawn Officer, NavigationPoint Point)
{
	local bool bIsUnderhandThrow;
	local Vector ThrowOrigin;
	local Rotator ThrowOrientation;

	assert(NotEqual_ObjectObject(Point, none));
	assert(Class'Engine.Pawn'.static.checkConscious(Officer));
	bIsUnderhandThrow = ISwatAI(Officer).IsUnderhandThrow(Point.Location, TargetThrowLocation);
	ThrowOrientation = Rotator(Subtract_VectorVector(TargetThrowLocation, Point.Location));
	ThrowOrigin = Add_VectorVector(Point.Location, ISwatAI(Officer).GetThrowOriginOffset(bIsUnderhandThrow, ThrowOrientation));
	return CanThrowGrenadeFromPoint(Officer, ThrowOrigin);
	return;
}

private latent function NavigationPoint GetPointToThrowFromForOfficer(Pawn Officer)
{
	local NavigationPointList PointsInOfficersRoom, PointsInPlayersRoom;
	local int i;
	local NavigationPoint Iter;
	local name OfficerRoomName, PlayerRoomName;
	local SwatAIRepository SwatAIRepo;

	SwatAIRepo = SwatAIRepository(Officer.Level.AIRepo);
	assert(NotEqual_ObjectObject(SwatAIRepo, none));
	OfficerRoomName = Officer.GetRoomName();
	PointsInOfficersRoom = SwatAIRepo.GetRoomNavigationPoints(OfficerRoomName);
	i = 0;
	J0x63:

	if(Less_IntInt(i, PointsInOfficersRoom.GetSize()))
	{
		Iter = PointsInOfficersRoom.GetEntryAt(i);
		if(CanOfficerThrowFromNavigationPoint(Officer, Iter))
		{
			return Iter;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x63;
	}
	yield();
	PlayerRoomName = SwatAIRepo.GetClosestRoomNameToPoint(CommandOrigin, CommandGiver);
	yield();
	if(NotEqual_NameName(PlayerRoomName, OfficerRoomName))
	{
		PointsInPlayersRoom = SwatAIRepo.GetRoomNavigationPoints(PlayerRoomName);
		i = 0;
		J0x114:

		if(Less_IntInt(i, PointsInPlayersRoom.GetSize()))
		{
			Iter = PointsInPlayersRoom.GetEntryAt(i);
			if(CanOfficerThrowFromNavigationPoint(Officer, Iter))
			{
				return Iter;
			}
			AddAdd_PreInt(i);
			// [Loop Continue]
			goto J0x114;
		}
	}
	return none;
	return;
}

function Vector GetThrowMidpoint(Pawn Officer, Vector ThrowOrigin)
{
	local Vector ThrowMidpoint;

	ThrowMidpoint = Divide_VectorFloat(Subtract_VectorVector(TargetThrowLocation, ThrowOrigin), 2.0000000);
	AddEqual_FloatFloat(ThrowMidpoint.Z, Multiply_FloatFloat(VSize(ThrowMidpoint), Sin(ISwatAI(Officer).GetThrowAngle())));
	return Add_VectorVector(ThrowOrigin, ThrowMidpoint);
	return;
}

private function bool TraceToThrowGrenade(Pawn Officer, Vector Start, Vector End, bool bUseExtent)
{
	local Vector HitLocation, HitNormal;
	local Actor HitActor;

	if(bUseExtent)
	{
		HitActor = Officer.Trace(HitLocation, HitNormal, End, Start, true, vect(10.0000000, 10.0000000, 10.0000000),,,, true);
		return OrOr_BoolBool(EqualEqual_ObjectObject(HitActor, none), LessEqual_FloatFloat(VSize(Subtract_VectorVector(HitLocation, TargetThrowLocation)), 64.0000000));
	}
	else
	{
		HitActor = Officer.Trace(HitLocation, HitNormal, End, Start, true,,,,, true);
		return EqualEqual_ObjectObject(HitActor, none);
	}
	return;
}

function bool CanThrowGrenadeFromPoint(Pawn Officer, Vector ThrowOrigin)
{
	local Vector ThrowMidpoint;

	ThrowMidpoint = GetThrowMidpoint(Officer, ThrowOrigin);
	return AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(TraceToThrowGrenade(Officer, ThrowOrigin, ThrowMidpoint, false), TraceToThrowGrenade(Officer, ThrowMidpoint, TargetThrowLocation, false)), TraceToThrowGrenade(Officer, ThrowOrigin, ThrowMidpoint, true)), TraceToThrowGrenade(Officer, ThrowMidpoint, TargetThrowLocation, true));
	return;
}

function bool CanThrowGrenade(Pawn MovingPawn)
{
	local Vector ThrowOrigin;
	local Rotator ThrowOrientation;
	local bool bIsUnderhandThrow;

	bIsUnderhandThrow = ISwatAI(MovingPawn).IsUnderhandThrowTo(TargetThrowLocation);
	ThrowOrientation = Rotator(Subtract_VectorVector(TargetThrowLocation, MovingPawn.Location));
	ThrowOrigin = ISwatAI(MovingPawn).GetThrowOrigin(bIsUnderhandThrow, ThrowOrientation);
	return CanThrowGrenadeFromPoint(MovingPawn, ThrowOrigin);
	return;
}

state Running
{Begin:

	DeployThrownItem();
	succeed();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.SquadDeployThrownItemGoal'
}