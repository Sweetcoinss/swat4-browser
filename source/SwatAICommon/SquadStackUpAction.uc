class SquadStackUpAction extends OfficerSquadAction
	collapsecategories
	hidecategories(Object,InternalParameters);

const kDistanceToUseClosestStackUpPoint = 150.0;

struct StackUpInfo
{
	var Pawn Officer;
	var float Weight;
	var int PointIndex;
};

var private StackUpGoal CurrentStackUpGoal;
var array<StackUpGoal> StackUpGoals;
var array<StackedUpGoal> StackedUpGoals;
var array<StackupPoint> StackUpPoints;
var array<Pawn> UnorderedOfficers;
var array<Pawn> OfficersInStackUpOrder;
var array<Pawn> MatchedOfficersToStackupPoints;
var private PickLockGoal CurrentPickLockGoal;
var private CloseDoorGoal CurrentCloseDoorGoal;
var(Parameters) Door TargetDoor;
var(Parameters) bool bTriggerCouldntBreachLockedSpeech;

function cleanup()
{
	super(ActionBase).cleanup();
	if(NotEqual_ObjectObject(CurrentStackUpGoal, none))
	{
		CurrentStackUpGoal.Release();
		CurrentStackUpGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentPickLockGoal, none))
	{
		CurrentPickLockGoal.Release();
		CurrentPickLockGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentCloseDoorGoal, none))
	{
		CurrentCloseDoorGoal.Release();
		CurrentCloseDoorGoal = none;
	}
	ClearOutStackUpGoals();
	ClearOutStackedUpGoals();
	ClearStackupPointClaims();
	return;
}

private function ClearOutStackUpGoals()
{
	J0x00:
	if(Greater_IntInt(StackUpGoals.Length, 0))
	{
		if(NotEqual_ObjectObject(StackUpGoals[0], none))
		{
			StackUpGoals[0].Release();
			StackUpGoals[0] = none;
		}
		StackUpGoals.Remove(0, 1);
		// [Loop Continue]
		goto J0x00;
	}
	return;
}

protected function ClearOutStackedUpGoals()
{
	J0x00:
	if(Greater_IntInt(StackedUpGoals.Length, 0))
	{
		if(NotEqual_ObjectObject(StackedUpGoals[0], none))
		{
			StackedUpGoals[0].unPostGoal(self);
			StackedUpGoals[0].Release();
			StackedUpGoals[0] = none;
		}
		StackedUpGoals.Remove(0, 1);
		// [Loop Continue]
		goto J0x00;
	}
	return;
}

protected function ClearStackupPointClaims()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, StackUpPoints.Length))
	{
		StackUpPoints[i].ClearClaims();
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

function float selectionHeuristic(AI_Goal Goal)
{
	if(EqualEqual_ObjectObject(satisfiesGoal, Goal.Class))
	{
		return 1.0000000;
	}
	else
	{
		return 0.0000000;
	}
	return;
}

function Pawn GetFirstOfficer()
{
	local Pawn Officer;
	local int i;

	if(EqualEqual_IntInt(OfficersInStackUpOrder.Length, 0))
	{
		return squad().pawns[0];
	}
	else
	{
		i = 0;
		J0x28:

		if(Less_IntInt(i, OfficersInStackUpOrder.Length))
		{
			Officer = OfficersInStackUpOrder[i];
			if(Class'Engine.Pawn'.static.checkConscious(Officer))
			{
				return Officer;
			}
			AddAdd_PreInt(i);
			// [Loop Continue]
			goto J0x28;
		}
	}
	assert(false);
	return none;
	return;
}

function Pawn GetSecondOfficer()
{
	local Pawn Officer;
	local int i;

	i = 1;
	J0x07:

	if(Less_IntInt(i, OfficersInStackUpOrder.Length))
	{
		Officer = OfficersInStackUpOrder[i];
		if(Class'Engine.Pawn'.static.checkConscious(Officer))
		{
			return Officer;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return none;
	return;
}

function Pawn GetThirdOfficer()
{
	if(GreaterEqual_IntInt(OfficersInStackUpOrder.Length, 3))
	{
		return OfficersInStackUpOrder[2];
	}
	else
	{
		return none;
	}
	return;
}

function Pawn GetFourthOfficer()
{
	if(EqualEqual_IntInt(OfficersInStackUpOrder.Length, 4))
	{
		return OfficersInStackUpOrder[3];
	}
	else
	{
		return none;
	}
	return;
}

function StackupPoint GetStackupPointForOrderedOfficer(Pawn OrderedOfficer)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, OfficersInStackUpOrder.Length))
	{
		if(EqualEqual_ObjectObject(OrderedOfficer, OfficersInStackUpOrder[i]))
		{
			return StackUpPoints[i];
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	assert(false);
	return none;
	return;
}

function int GetStackupPointIndexForOrderedOfficer(Pawn OrderedOfficer)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, OfficersInStackUpOrder.Length))
	{
		if(EqualEqual_ObjectObject(OrderedOfficer, OfficersInStackUpOrder[i]))
		{
			return i;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	assert(false);
	return -1;
	return;
}

latent function PickLock(bool bMoveToPostPickLockDestination)
{
	local Pawn Officer;
	local StackupPoint OfficerStackUpPoint;
	local int i;

	assert(Greater_IntInt(OfficersInStackUpOrder.Length, 0));
	i = 0;
	J0x13:

	if(Less_IntInt(i, OfficersInStackUpOrder.Length))
	{
		Officer = OfficersInStackUpOrder[i];
		if(AndAnd_BoolBool(Class'Engine.Pawn'.static.checkConscious(Officer), NotEqual_ObjectObject(ISwatOfficer(Officer).GetItemAtSlot(8), none)))
		{
			// [Explicit Break]
			goto J0x76;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x13;
	}
	J0x76:

	if(bMoveToPostPickLockDestination)
	{
		OfficerStackUpPoint = ISwatDoor(TargetDoor).GetStackupPoints(CommandOrigin)[i];
		assert(NotEqual_ObjectObject(OfficerStackUpPoint, none));
	}
	CurrentPickLockGoal = Class'SwatAICommon.PickLockGoal'.static.Allocate(self).;
	construct_AI_ResourceDoorNavigationPoint(AI_Resource(Officer.CharacterAI), TargetDoor, OfficerStackUpPoint);
	assert(NotEqual_ObjectObject(CurrentPickLockGoal, none));
	CurrentPickLockGoal.AddRef();
	CurrentPickLockGoal.postGoal(self);
	waitForGoal(CurrentPickLockGoal);
	CurrentPickLockGoal.unPostGoal(self);
	CurrentPickLockGoal.Release();
	CurrentPickLockGoal = none;
	return;
}

latent function StackUpOfficer(Pawn Officer, StackupPoint Destination)
{
	assert(Class'Engine.Pawn'.static.checkConscious(Officer));
	assert(NotEqual_ObjectObject(Destination, none));
	CurrentStackUpGoal = Class'SwatAICommon.StackUpGoal'.static.Allocate(self).;
	construct_AI_ResourceStackupPoint(AI_CharacterResource(Officer.CharacterAI), Destination);
	assert(NotEqual_ObjectObject(CurrentStackUpGoal, none));
	CurrentStackUpGoal.AddRef();
	CurrentStackUpGoal.postGoal(self);
	waitForGoal(CurrentStackUpGoal);
	CurrentStackUpGoal.unPostGoal(self);
	CurrentStackUpGoal.Release();
	CurrentStackUpGoal = none;
	PostStackedUpGoal(Officer, Destination);
	return;
}

protected function NotifyPawnDied(Pawn Pawn)
{
	local int i;

	super.NotifyPawnDied(Pawn);
	i = 0;
	J0x12:

	if(Less_IntInt(i, UnorderedOfficers.Length))
	{
		if(EqualEqual_ObjectObject(UnorderedOfficers[i], Pawn))
		{
			UnorderedOfficers.Remove(i, 1);
			return;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x12;
	}
	i = 0;
	J0x56:

	if(Less_IntInt(i, OfficersInStackUpOrder.Length))
	{
		if(EqualEqual_ObjectObject(OfficersInStackUpOrder[i], Pawn))
		{
			OfficersInStackUpOrder.Remove(i, 1);
			StackUpPoints[i].ClearClaims();
			return;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x56;
	}
	return;
}

private function PopulateUnorderedOfficers()
{
	local int i;

	assert(EqualEqual_IntInt(UnorderedOfficers.Length, 0));
	i = 0;
	J0x13:

	if(Less_IntInt(i, squad().pawns.Length))
	{
		UnorderedOfficers[UnorderedOfficers.Length] = squad().pawns[i];
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x13;
	}
	return;
}

protected function int GetNumberLivingOfficersInSquad()
{
	return squad().pawns.Length;
	return;
}

private function float DeflateWeightByCloserUnorderedOfficersTo(Pawn Officer, float OfficerNavDistanceToPoint, StackupPoint Point)
{
	local int i;
	local float IterDistance, DeflatedDistance;
	local Pawn OfficerIter;

	assert(NotEqual_ObjectObject(Officer, none));
	DeflatedDistance = OfficerNavDistanceToPoint;
	i = 0;
	J0x1D:

	if(Less_IntInt(i, UnorderedOfficers.Length))
	{
		OfficerIter = UnorderedOfficers[i];
		IterDistance = OfficerIter.GetPathfindingDistanceToActor(Point, true);
		SubtractEqual_FloatFloat(DeflatedDistance, Subtract_FloatFloat(OfficerNavDistanceToPoint, IterDistance));
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x1D;
	}
	return DeflatedDistance;
	return;
}

private function bool IsPositionedOnWrongSideOfDoor(Pawn Officer, StackupPoint Destination)
{
	local bool IterPointDotDoorSign, OfficerDotDoorSign, OfficerIterDotDoorSign;
	local Vector DoorDirection;
	local int i;
	local Pawn OfficerIter;

	DoorDirection = Vector(TargetDoor.Rotation);
	IterPointDotDoorSign = Greater_FloatFloat(Dot_VectorVector(DoorDirection, Normal(Subtract_VectorVector(Destination.Location, TargetDoor.Location))), 0.0000000);
	OfficerDotDoorSign = Greater_FloatFloat(Dot_VectorVector(DoorDirection, Normal(Subtract_VectorVector(Destination.Location, Officer.Location))), 0.0000000);
	if(EqualEqual_BoolBool(IterPointDotDoorSign, OfficerDotDoorSign))
	{
		i = 0;
		J0x98:

		if(Less_IntInt(i, UnorderedOfficers.Length))
		{
			OfficerIter = UnorderedOfficers[i];
			if(AndAnd_BoolBool(NotEqual_ObjectObject(OfficerIter, Officer), Class'Engine.Pawn'.static.checkConscious(OfficerIter)))
			{
				OfficerIterDotDoorSign = Greater_FloatFloat(Dot_VectorVector(DoorDirection, Normal(Subtract_VectorVector(Destination.Location, OfficerIter.Location))), 0.0000000);
				if(NotEqual_BoolBool(OfficerIterDotDoorSign, IterPointDotDoorSign))
				{
					return true;
				}
			}
			AddAdd_PreInt(i);
			// [Loop Continue]
			goto J0x98;
		}
	}
	return false;
	return;
}

latent function DetermineOfficerStackupPoints()
{
	local int i, j, HighestWeightStackUpIndex;
	local Pawn BestOfficer;
	local array<StackUpInfo> StackUpInfos;
	local StackUpInfo IterInfo;
	local float HighestWeight;
	local array<int> StackupInfosToRemove;

	j = 0;
	J0x07:

	if(Less_IntInt(j, UnorderedOfficers.Length))
	{
		IterInfo.Officer = UnorderedOfficers[j];
		i = 0;
		J0x34:

		if(AndAnd_BoolBool(Less_IntInt(i, StackUpPoints.Length), Less_IntInt(i, GetNumberLivingOfficersInSquad())))
		{
			if(Not_PreBool(StackUpPoints[i].IsClaimedByOfficer()))
			{
				IterInfo.PointIndex = i;
				IterInfo.Weight = GetStackupWeightForOfficer(IterInfo.Officer, StackUpPoints[i]);
				StackUpInfos[StackUpInfos.Length] = IterInfo;
			}
			yield();
			AddAdd_PreInt(i);
			// [Loop Continue]
			goto J0x34;
		}
		AddAdd_PreInt(j);
		// [Loop Continue]
		goto J0x07;
	}
	J0xD2:

	if(Greater_IntInt(StackUpInfos.Length, 0))
	{
		StackupInfosToRemove.Remove(0, StackupInfosToRemove.Length);
		i = 0;
		J0xF2:

		if(Less_IntInt(i, StackUpInfos.Length))
		{
			if(OrOr_BoolBool(EqualEqual_IntInt(i, 0), Greater_FloatFloat(StackUpInfos[i].Weight, HighestWeight)))
			{
				HighestWeight = StackUpInfos[i].Weight;
				BestOfficer = StackUpInfos[i].Officer;
				HighestWeightStackUpIndex = StackUpInfos[i].PointIndex;
			}
			AddAdd_PreInt(i);
			// [Loop Continue]
			goto J0xF2;
		}
		MatchedOfficersToStackupPoints[HighestWeightStackUpIndex] = BestOfficer;
		i = 0;
		J0x18D:

		if(Less_IntInt(i, StackUpInfos.Length))
		{
			if(OrOr_BoolBool(EqualEqual_ObjectObject(StackUpInfos[i].Officer, BestOfficer), EqualEqual_IntInt(StackUpInfos[i].PointIndex, HighestWeightStackUpIndex)))
			{
				StackupInfosToRemove[StackupInfosToRemove.Length] = i;
			}
			AddAdd_PreInt(i);
			// [Loop Continue]
			goto J0x18D;
		}
		i = 0;
		J0x1F6:

		if(Less_IntInt(i, StackupInfosToRemove.Length))
		{
			StackUpInfos.Remove(Subtract_IntInt(StackupInfosToRemove[i], i), 1);
			AddAdd_PreInt(i);
			// [Loop Continue]
			goto J0x1F6;
		}
		// [Loop Continue]
		goto J0xD2;
	}
	return;
}

event float GetStackupWeightForOfficer(Pawn Officer, StackupPoint Point)
{
	local float Weight;

	Weight = Officer.GetPathfindingDistanceToActor(Point, true);
	Weight = DeflateWeightByCloserUnorderedOfficersTo(Officer, Weight, Point);
	if(IsPositionedOnWrongSideOfDoor(Officer, Point))
	{
		SubtractEqual_FloatFloat(Weight, 512.0000000);
	}
	return Weight;
	return;
}

private function int GetUnorderedOfficerIndex(Pawn Officer)
{
	local int i;

	assert(NotEqual_ObjectObject(Officer, none));
	assert(Not_PreBool(IsOfficerOrdered(Officer)));
	i = 0;
	J0x22:

	if(Less_IntInt(i, UnorderedOfficers.Length))
	{
		if(EqualEqual_ObjectObject(Officer, UnorderedOfficers[i]))
		{
			return i;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x22;
	}
	assert(false);
	return -1;
	return;
}

private function bool IsOfficerOrdered(Pawn Officer)
{
	local int i;

	assert(NotEqual_ObjectObject(Officer, none));
	i = 0;
	J0x12:

	if(Less_IntInt(i, UnorderedOfficers.Length))
	{
		if(EqualEqual_ObjectObject(Officer, UnorderedOfficers[i]))
		{
			return false;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x12;
	}
	return true;
	return;
}

protected function bool ShouldFirstOfficerBeStackedUp()
{
	return true;
	return;
}

private function SetOrderedStackUpPointForOfficer(Pawn Officer, StackupPoint OfficerDestination)
{
	local int i;
	local Pawn OfficerIter;

	if(Officer.logAI)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("SetOrderedStackUpPointForOfficer - Officer: ", string(Officer.Name)), " OfficerDestination: "), string(OfficerDestination.Name)));
	}
	OfficerDestination.SetClaimedByOfficer(Officer);
	i = 0;
	J0x9A:

	if(Less_IntInt(i, StackUpPoints.Length))
	{
		if(EqualEqual_ObjectObject(StackUpPoints[i], OfficerDestination))
		{
			OfficersInStackUpOrder[i] = Officer;
			// [Explicit Break]
			goto J0xDD;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x9A;
	}
	J0xDD:

	i = 0;
	J0xE4:

	if(Less_IntInt(i, UnorderedOfficers.Length))
	{
		OfficerIter = UnorderedOfficers[i];
		assert(Class'Engine.Pawn'.static.checkConscious(OfficerIter));
		if(EqualEqual_ObjectObject(OfficerIter, Officer))
		{
			UnorderedOfficers.Remove(i, 1);
			// [Explicit Break]
			goto J0x144;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0xE4;
	}
	J0x144:

	return;
}

private function PostStackUpGoalOnOfficer(Pawn Officer, StackupPoint OfficerDestination, optional bool bRunToPoint)
{
	local int StackupGoalIndex;

	assert(Class'Engine.Pawn'.static.checkConscious(Officer));
	assert(NotEqual_ObjectObject(OfficerDestination, none));
	SetOrderedStackUpPointForOfficer(Officer, OfficerDestination);
	if(OrOr_BoolBool(NotEqual_ObjectObject(Officer, OfficersInStackUpOrder[0]), ShouldFirstOfficerBeStackedUp()))
	{
		StackupGoalIndex = StackUpGoals.Length;
		StackUpGoals[StackupGoalIndex] = Class'SwatAICommon.StackUpGoal'.static.Allocate(self).;
		construct_AI_ResourceStackupPoint(AI_CharacterResource(Officer.CharacterAI), OfficerDestination);
		assert(NotEqual_ObjectObject(StackUpGoals[StackupGoalIndex], none));
		StackUpGoals[StackupGoalIndex].AddRef();
		if(bRunToPoint)
		{
			StackUpGoals[StackupGoalIndex].SetRunToStackupPoint(true);
		}
		StackUpGoals[StackupGoalIndex].bWakeUpPoster = true;
		StackUpGoals[StackupGoalIndex].postGoal(self);
		PostStackedUpGoal(Officer, OfficerDestination);
	}
	return;
}

private function PopulateStackUpPoints()
{
	local int i;

	StackUpPoints = ISwatDoor(TargetDoor).GetStackupPoints(CommandOrigin);
	AssertWithDescription(LessEqual_IntInt(squad().pawns.Length, StackUpPoints.Length), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("SquadStackUpAction::PopulateStackUpPoints - ", string(TargetDoor)), " has less StackUpPoints ("), string(StackUpPoints.Length)), ") than squad members ("), string(squad().pawns.Length)), ").  This is bad!"));
	assert(EqualEqual_IntInt(StackUpPoints.Length, 4));
	i = 0;
	J0xF1:

	if(Less_IntInt(i, StackUpPoints.Length))
	{
		assert(NotEqual_ObjectObject(StackUpPoints[i], none));
		StackUpPoints[i].ClearClaims();
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0xF1;
	}
	return;
}

protected function bool IsOfficerAtSideOpenPoint(Pawn Officer)
{
	local bool bIsOnLeftSide;

	bIsOnLeftSide = ISwatDoor(TargetDoor).PointIsToMyLeft(CommandOrigin);
	return ISwatDoor(TargetDoor).IsOfficerAtSideOpenPoint(Officer, bIsOnLeftSide);
	return;
}

private function TestForAlreadyStackedUpOfficers()
{
	local int i, j, NumLivingOfficers;
	local Pawn OfficerIter;

	NumLivingOfficers = UnorderedOfficers.Length;
	assert(LessEqual_IntInt(NumLivingOfficers, StackUpPoints.Length));
	i = 0;
	J0x23:

	if(Less_IntInt(i, NumLivingOfficers))
	{
		j = 0;
		J0x39:

		if(Less_IntInt(j, UnorderedOfficers.Length))
		{
			OfficerIter = UnorderedOfficers[j];
			if(OfficerIter.ReachedDestination(StackUpPoints[i]))
			{
				if(OfficerIter.logAI)
				{
					Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("OfficerIter (", string(OfficerIter.Name)), ") is already stacked up at point index: "), string(i)));
				}
				OfficersInStackUpOrder[i] = OfficerIter;
				StackUpPoints[i].SetClaimedByOfficer(OfficerIter);
				UnorderedOfficers.Remove(j, 1);
				PostStackedUpGoal(OfficerIter, StackUpPoints[i]);
				// [Explicit Break]
				goto J0x13B;
			}
			AddAdd_PreInt(j);
			// [Loop Continue]
			goto J0x39;
		}
		J0x13B:

		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x23;
	}
	return;
}

private function bool AreOfficersAlreadyStackedUp()
{
	local int i;

	if(resource.Pawn().logAI)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("OfficersInStackUpOrder.Length: ", string(OfficersInStackUpOrder.Length)), " GetNumberLivingOfficersInSquad: "), string(GetNumberLivingOfficersInSquad())));
	}
	i = 0;
	J0x7F:

	if(Less_IntInt(i, OfficersInStackUpOrder.Length))
	{
		if(Not_PreBool(Class'Engine.Pawn'.static.checkConscious(OfficersInStackUpOrder[i])))
		{
			return false;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x7F;
	}
	return GreaterEqual_IntInt(OfficersInStackUpOrder.Length, GetNumberLivingOfficersInSquad());
	return;
}

function bool CanInteractWithTargetDoor()
{
	return AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(Not_PreBool(TargetDoor.IsEmptyDoorway()), TargetDoor.IsClosed()), Not_PreBool(TargetDoor.IsOpening())), Not_PreBool(ISwatDoor(TargetDoor).IsBroken()));
	return;
}

function bool IsDoorOpenTowardsStackupSide()
{
	local bool bStackUpOnLeft, bDoorOpenLeft;
	local ISwatDoor SwatTargetDoor;

	SwatTargetDoor = ISwatDoor(TargetDoor);
	if(AndAnd_BoolBool(AndAnd_BoolBool(Not_PreBool(TargetDoor.IsEmptyDoorway()), SwatTargetDoor.IsOpen()), Not_PreBool(SwatTargetDoor.IsBroken())))
	{
		bStackUpOnLeft = SwatTargetDoor.PointIsToMyLeft(CommandOrigin);
		bDoorOpenLeft = SwatTargetDoor.IsOpenLeft();
		if(EqualEqual_BoolBool(bStackUpOnLeft, bDoorOpenLeft))
		{
			return true;
		}
	}
	return false;
	return;
}

protected function bool NeedsToStackUp()
{
	PopulateStackUpPoints();
	PopulateUnorderedOfficers();
	TestForAlreadyStackedUpOfficers();
	if(AreOfficersAlreadyStackedUp())
	{
		if(resource.Pawn().logAI)
		{
			Log("AI believes everyone already stacked up.");
		}
		return false;
	}
	return true;
	return;
}

protected function TriggerOrderedToStackUpReplySpeech()
{
	local Pawn ClosestOfficerToCommandGiver;

	ClosestOfficerToCommandGiver = GetClosestOfficerTo(CommandGiver, false, false);
	if(NotEqual_ObjectObject(ClosestOfficerToCommandGiver, none))
	{
		ISwatOfficer(ClosestOfficerToCommandGiver).GetOfficerSpeechManagerAction().TriggerGenericOrderReplySpeech();
	}
	return;
}

protected latent function StackUpSquad(optional bool bTriggerGenericOrderReply)
{
	if(NeedsToStackUp())
	{
		if(bTriggerGenericOrderReply)
		{
			TriggerOrderedToStackUpReplySpeech();
		}
		InternalStackUpSquad();
	}
	return;
}

protected function bool ShouldRunToStackupPoint()
{
	return false;
	return;
}

protected latent function InternalStackUpSquad()
{
	local int i;
	local Pawn OfficerIter;
	local StackupPoint PointIter;

	DetermineOfficerStackupPoints();
	if(resource.Pawn().logAI)
	{
		Log(Concat_StrStr("MatchedOfficersToStackupPoints.Length is: ", string(MatchedOfficersToStackupPoints.Length)));
	}
	i = 0;
	J0x61:

	if(Less_IntInt(i, MatchedOfficersToStackupPoints.Length))
	{
		OfficerIter = MatchedOfficersToStackupPoints[i];
		PointIter = StackUpPoints[i];
		if(NotEqual_ObjectObject(OfficerIter, none))
		{
			if(resource.Pawn().logAI)
			{
				Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("posting initial stack up goal for ", string(OfficerIter.Name)), " to go to "), string(StackUpPoints[i])));
			}
			PostStackUpGoalOnOfficer(OfficerIter, PointIter, ShouldRunToStackupPoint());
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x61;
	}
	waitForAllGoalsInList(StackUpGoals);
	ClearOutStackUpGoals();
	return;
}

function PostStackedUpGoal(Pawn Officer, StackupPoint inStackupPoint)
{
	local int NextStackedUpGoalIndex;

	assert(NotEqual_ObjectObject(inStackupPoint, none));
	assert(Class'Engine.Pawn'.static.checkConscious(Officer));
	NextStackedUpGoalIndex = StackedUpGoals.Length;
	StackedUpGoals[NextStackedUpGoalIndex] = Class'SwatAICommon.StackedUpGoal'.static.Allocate(self).;
	construct_AI_ResourceStackupPoint(AI_Resource(Officer.CharacterAI), inStackupPoint);
	assert(NotEqual_ObjectObject(StackedUpGoals[NextStackedUpGoalIndex], none));
	StackedUpGoals[NextStackedUpGoalIndex].AddRef();
	StackedUpGoals[NextStackedUpGoalIndex].postGoal(self);
	return;
}

protected latent function SwapStackUpPositions(Pawn OfficerOne, Pawn OfficerTwo)
{
	local int i, NewOfficerOneStackupPointIndex, NewOfficerTwoStackupPointIndex;
	local StackupPoint NewOfficerOneStackupPoint, NewOfficerTwoStackupPoint;

	assert(Class'Engine.Pawn'.static.checkConscious(OfficerOne));
	assert(Class'Engine.Pawn'.static.checkConscious(OfficerTwo));
	NewOfficerOneStackupPointIndex = GetStackupPointIndexForOrderedOfficer(OfficerTwo);
	NewOfficerOneStackupPoint = StackUpPoints[NewOfficerOneStackupPointIndex];
	assert(NotEqual_ObjectObject(NewOfficerOneStackupPoint, none));
	NewOfficerTwoStackupPointIndex = GetStackupPointIndexForOrderedOfficer(OfficerOne);
	NewOfficerTwoStackupPoint = StackUpPoints[NewOfficerTwoStackupPointIndex];
	assert(NotEqual_ObjectObject(NewOfficerTwoStackupPoint, none));
	NewOfficerOneStackupPoint.ClearClaims();
	OfficersInStackUpOrder[NewOfficerOneStackupPointIndex] = OfficerOne;
	NewOfficerTwoStackupPoint.ClearClaims();
	OfficersInStackUpOrder[NewOfficerTwoStackupPointIndex] = OfficerTwo;
	i = 0;
	J0xCF:

	if(Less_IntInt(i, OfficersInStackUpOrder.Length))
	{
		RemoveStackedUpGoalOnOfficer(OfficersInStackUpOrder[i]);
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0xCF;
	}
	StackUpGoals.Remove(0, StackUpGoals.Length);
	if(OfficerOne.logAI)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("Moving ", string(OfficerOne.Name)), " from "), string(NewOfficerTwoStackupPoint.Name)), " to "), string(NewOfficerOneStackupPoint.Name)));
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("Moving ", string(OfficerTwo.Name)), " from "), string(NewOfficerOneStackupPoint.Name)), " to "), string(NewOfficerTwoStackupPoint.Name)));
	}
	PostStackUpGoalOnOfficer(OfficerOne, NewOfficerOneStackupPoint, true);
	PostStackUpGoalOnOfficer(OfficerTwo, NewOfficerTwoStackupPoint, true);
	waitForAllGoalsInList(StackUpGoals);
	i = 0;
	J0x1F3:

	if(Less_IntInt(i, OfficersInStackUpOrder.Length))
	{
		PostStackedUpGoal(OfficersInStackUpOrder[i], StackUpPoints[i]);
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x1F3;
	}
	return;
}

protected function RemoveStackedUpGoalOnOfficer(Pawn Officer)
{
	local int i;
	local StackedUpGoal OfficerStackedUpGoal;

	StackUpGoal(AI_Resource(Officer.CharacterAI).findGoalByName("StackUp"));
	OfficerStackedUpGoal = StackedUpGoal(AI_Resource(Officer.CharacterAI).findGoalByName("StackedUp"));
	if(NotEqual_ObjectObject(OfficerStackedUpGoal, none))
	{
		i = 0;
		J0x70:

		if(Less_IntInt(i, StackedUpGoals.Length))
		{
			if(EqualEqual_ObjectObject(OfficerStackedUpGoal, StackedUpGoals[i]))
			{
				StackedUpGoals[i].unPostGoal(self);
				StackedUpGoals[i].Release();
				StackedUpGoals[i] = none;
				StackedUpGoals.Remove(i, 1);
			}
			AddAdd_PreInt(i);
			// [Loop Continue]
			goto J0x70;
		}
	}
	return;
}

protected function TriggerCompletedSpeech()
{
	if(AndAnd_BoolBool(bTriggerCouldntBreachLockedSpeech, CanInteractWithTargetDoor()))
	{
		ISwatOfficer(GetFirstOfficer()).GetOfficerSpeechManagerAction().TriggerCouldntBreachLockedDoorSpeech();
	}
	else
	{
		ISwatOfficer(GetFirstOfficer()).GetOfficerSpeechManagerAction().TriggerReachedStackUpSpeech();
	}
	return;
}

protected function bool IsC2ChargeDeployedOnThisSideOfDoor()
{
	local ISwatDoor SwatDoorTarget;

	SwatDoorTarget = ISwatDoor(TargetDoor);
	assert(NotEqual_ObjectObject(SwatDoorTarget, none));
	if(SwatDoorTarget.PointIsToMyLeft(CommandOrigin))
	{
		return SwatDoorTarget.IsChargePlacedOnLeft();
	}
	else
	{
		return SwatDoorTarget.IsChargePlacedOnRight();
	}
	return;
}

protected function Pawn GetC2BreachingOfficer()
{
	local int i;
	local Pawn Officer;
	local bool bCanUseOfficer;
	local HandheldEquipment Equipment;
	local bool bIsC2ChargeDeployedOnThisSideOfDoor;

	bIsC2ChargeDeployedOnThisSideOfDoor = IsC2ChargeDeployedOnThisSideOfDoor();
	assert(Greater_IntInt(OfficersInStackUpOrder.Length, 0));
	i = 0;
	J0x20:

	if(Less_IntInt(i, OfficersInStackUpOrder.Length))
	{
		Officer = OfficersInStackUpOrder[i];
		if(Class'Engine.Pawn'.static.checkConscious(Officer))
		{
			if(bIsC2ChargeDeployedOnThisSideOfDoor)
			{
				Equipment = ISwatOfficer(Officer).GetItemAtSlot(12);
				bCanUseOfficer = NotEqual_ObjectObject(Equipment, none);
			}
			else
			{
				Equipment = ISwatOfficer(Officer).GetItemAtSlot(7);
				bCanUseOfficer = AndAnd_BoolBool(NotEqual_ObjectObject(Equipment, none), Equipment.IsA('C2Charge'));
			}
			if(bCanUseOfficer)
			{
				return Officer;
			}
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x20;
	}
	return none;
	return;
}

protected latent function MoveUpC2Breacher(Pawn Breacher)
{
	assert(Class'Engine.Pawn'.static.checkConscious(Breacher));
	if(NotEqual_ObjectObject(Breacher, GetFirstOfficer()))
	{
		ISwatOfficer(Breacher).GetOfficerSpeechManagerAction().TriggerMoveUpC2Speech();
		MoveUpBreacher(Breacher);
	}
	return;
}

protected latent function MoveUpShotgunBreacher(Pawn Breacher)
{
	assert(Class'Engine.Pawn'.static.checkConscious(Breacher));
	if(NotEqual_ObjectObject(Breacher, GetFirstOfficer()))
	{
		ISwatOfficer(Breacher).GetOfficerSpeechManagerAction().TriggerMoveUpBreachSGSpeech();
		MoveUpBreacher(Breacher);
	}
	return;
}

private latent function MoveUpBreacher(Pawn Breacher)
{
	assert(Class'Engine.Pawn'.static.checkConscious(Breacher));
	assert(NotEqual_ObjectObject(Breacher, GetFirstOfficer()));
	SwapOfficerRoles(Breacher, GetFirstOfficer());
	SwapStackUpPositions(Breacher, GetFirstOfficer());
	return;
}

protected function SwapOfficerRoles(Pawn OfficerA, Pawn OfficerB)
{
	return;
}

state Running
{Begin:

	StackUpSquad(true);
	TriggerCompletedSpeech();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.SquadStackUpGoal'
}