class OfficerTeamInfo extends SquadInfo
	native
	config
	hidecategories(Karma);

var SwatAIRepository SwatAIRepo;
var private SquadCommandGoal CurrentSquadCommandGoal;

event PostBeginPlay()
{
	super.PostBeginPlay();
	InitAbilities();
	return;
}

protected function InitAbilities()
{
	SquadAI.addAbility(Class'SwatAICommon.SquadMirrorCornerAction'.static.Allocate(self)., Construct_Void());
	SquadAI.addAbility(Class'SwatAICommon.SquadMirrorDoorAction'.static.Allocate(self)., Construct_Void());
	SquadAI.addAbility(Class'SwatAICommon.SquadCloseDoorAction'.static.Allocate(self)., Construct_Void());
	SquadAI.addAbility(Class'SwatAICommon.SquadFallInAction'.static.Allocate(self)., Construct_Void());
	SquadAI.addAbility(Class'SwatAICommon.SquadStackUpAction'.static.Allocate(self)., Construct_Void());
	SquadAI.addAbility(Class'SwatAICommon.SquadStackUpAndTryDoorAction'.static.Allocate(self)., Construct_Void());
	SquadAI.addAbility(Class'SwatAICommon.SquadMoveAndClearAction'.static.Allocate(self)., Construct_Void());
	SquadAI.addAbility(Class'SwatAICommon.SquadBangAndClearAction'.static.Allocate(self)., Construct_Void());
	SquadAI.addAbility(Class'SwatAICommon.SquadGasAndClearAction'.static.Allocate(self)., Construct_Void());
	SquadAI.addAbility(Class'SwatAICommon.SquadStingAndClearAction'.static.Allocate(self)., Construct_Void());
	SquadAI.addAbility(Class'SwatAICommon.SquadBreachAndClearAction'.static.Allocate(self)., Construct_Void());
	SquadAI.addAbility(Class'SwatAICommon.SquadBreachBangAndClearAction'.static.Allocate(self)., Construct_Void());
	SquadAI.addAbility(Class'SwatAICommon.SquadBreachGasAndClearAction'.static.Allocate(self)., Construct_Void());
	SquadAI.addAbility(Class'SwatAICommon.SquadBreachStingAndClearAction'.static.Allocate(self)., Construct_Void());
	SquadAI.addAbility(Class'SwatAICommon.SquadDeployThrownItemAction'.static.Allocate(self)., Construct_Void());
	SquadAI.addAbility(Class'SwatAICommon.SquadExamineAndReportAction'.static.Allocate(self)., Construct_Void());
	SquadAI.addAbility(Class'SwatAICommon.SquadPickLockAction'.static.Allocate(self)., Construct_Void());
	SquadAI.addAbility(Class'SwatAICommon.SquadPlaceWedgeAction'.static.Allocate(self)., Construct_Void());
	SquadAI.addAbility(Class'SwatAICommon.SquadRemoveWedgeAction'.static.Allocate(self)., Construct_Void());
	SquadAI.addAbility(Class'SwatAICommon.SquadDeployC2Action'.static.Allocate(self)., Construct_Void());
	SquadAI.addAbility(Class'SwatAICommon.SquadSecureAction'.static.Allocate(self)., Construct_Void());
	SquadAI.addAbility(Class'SwatAICommon.SquadDeployTaserAction'.static.Allocate(self)., Construct_Void());
	SquadAI.addAbility(Class'SwatAICommon.SquadDeployPepperSprayAction'.static.Allocate(self)., Construct_Void());
	SquadAI.addAbility(Class'SwatAICommon.SquadDisableTargetAction'.static.Allocate(self)., Construct_Void());
	SquadAI.addAbility(Class'SwatAICommon.SquadMoveToAction'.static.Allocate(self)., Construct_Void());
	SquadAI.addAbility(Class'SwatAICommon.SquadCoverAction'.static.Allocate(self)., Construct_Void());
	SquadAI.addAbility(Class'SwatAICommon.SquadDeployShotgunAction'.static.Allocate(self)., Construct_Void());
	SquadAI.addAbility(Class'SwatAICommon.SquadDeployLessLethalShotgunAction'.static.Allocate(self)., Construct_Void());
	SquadAI.addAbility(Class'SwatAICommon.SquadDeployThrownItemThroughDoorAction'.static.Allocate(self)., Construct_Void());
	SquadAI.addAbility(Class'SwatAICommon.SquadDeployPepperBallAction'.static.Allocate(self)., Construct_Void());
	return;
}

function Destroyed()
{
	super(Actor).Destroyed();
	if(NotEqual_ObjectObject(CurrentSquadCommandGoal, none))
	{
		CurrentSquadCommandGoal.Release();
		CurrentSquadCommandGoal = none;
	}
	return;
}

event AI_SquadResource GetSquadAI()
{
	return AI_SquadResource(SquadAI);
	return;
}

function bool IsOfficerOnTeam(Pawn Officer)
{
	local int i;

	assert(NotEqual_ObjectObject(Officer, none));
	i = 0;
	J0x12:

	if(Less_IntInt(i, pawns.Length))
	{
		if(EqualEqual_ObjectObject(pawns[i], Officer))
		{
			return true;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x12;
	}
	return false;
	return;
}

function bool IsMovingAndClearing()
{
	return AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(CurrentSquadCommandGoal, none), CurrentSquadCommandGoal.IsA('SquadMoveAndClearGoal')), Not_PreBool(CurrentSquadCommandGoal.hasCompleted()));
	return;
}

function name GetRoomNameToClear()
{
	assert(IsMovingAndClearing());
	return SquadMoveAndClearGoal(CurrentSquadCommandGoal).GetRoomNameToClear();
	return;
}

function Pawn GetFirstOfficer()
{
	if(Greater_IntInt(pawns.Length, 0))
	{
		return pawns[0];
	}
	else
	{
		return none;
	}
	return;
}

function Pawn GetSecondOfficer()
{
	if(Greater_IntInt(pawns.Length, 1))
	{
		return pawns[1];
	}
	else
	{
		return none;
	}
	return;
}

function Pawn GetClosestOfficerWithEquipmentTo(HandheldEquipment.EquipmentSlot Slot, Vector Point)
{
	local int i;
	local Pawn IterOfficer, ClosestOfficer;
	local float IterDistance, ClosestDistance;

	i = 0;
	J0x07:

	if(Less_IntInt(i, pawns.Length))
	{
		IterOfficer = pawns[i];
		if(NotEqual_ObjectObject(ISwatOfficer(IterOfficer).GetItemAtSlot(Slot), none))
		{
			if(IterOfficer.FastTrace(Point, IterOfficer.Location))
			{
				IterDistance = VSize(Subtract_VectorVector(Point, IterOfficer.Location));
			}
			else
			{
				IterDistance = IterOfficer.GetPathfindingDistanceToPoint(Point, true);
			}
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

function Pawn GetClosestOfficerTo(Actor Target, optional bool bRequiresLineOfSight, optional bool bUsePathfindingDistance)
{
	local int i;
	local Pawn Iter, Closest;
	local float IterDistance, ClosestDistance;

	i = 0;
	J0x07:

	if(Less_IntInt(i, pawns.Length))
	{
		Iter = pawns[i];
		if(OrOr_BoolBool(Not_PreBool(bRequiresLineOfSight), Iter.LineOfSightTo(Target)))
		{
			if(bUsePathfindingDistance)
			{
				IterDistance = Iter.GetPathfindingDistanceToActor(Target);
			}
			if(OrOr_BoolBool(Not_PreBool(bUsePathfindingDistance), AndAnd_BoolBool(EqualEqual_FloatFloat(IterDistance, 0.0000000), NotEqual_ObjectObject(Target, Iter))))
			{
				IterDistance = VSize(Subtract_VectorVector(Target.Location, Iter.Location));
			}
			if(OrOr_BoolBool(EqualEqual_ObjectObject(Closest, none), Less_FloatFloat(IterDistance, ClosestDistance)))
			{
				Closest = Iter;
				ClosestDistance = IterDistance;
			}
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return Closest;
	return;
}

function Pawn GetClosestOfficerThatCanHit(Actor Target)
{
	local int i;
	local Pawn Iter, Closest;
	local float IterDistance, ClosestDistance;

	i = 0;
	J0x07:

	if(Less_IntInt(i, pawns.Length))
	{
		Iter = pawns[i];
		if(Iter.CanHit(Target))
		{
			IterDistance = VSize(Subtract_VectorVector(Target.Location, Iter.Location));
			if(OrOr_BoolBool(EqualEqual_ObjectObject(Closest, none), Less_FloatFloat(IterDistance, ClosestDistance)))
			{
				Closest = Iter;
				ClosestDistance = IterDistance;
			}
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return Closest;
	return;
}

function Pawn GetClosestOfficerWithEquipment(Vector Location, HandheldEquipment.EquipmentSlot Slot, optional name EquipmentClassName)
{
	local int i;
	local Pawn Iter, Closest;
	local float IterDistance, ClosestDistance;
	local HandheldEquipment Equipment;

	i = 0;
	J0x07:

	if(Less_IntInt(i, pawns.Length))
	{
		Iter = pawns[i];
		Equipment = ISwatOfficer(Iter).GetItemAtSlot(Slot);
		if(NotEqual_ObjectObject(Equipment, none))
		{
			if(OrOr_BoolBool(EqualEqual_NameName(EquipmentClassName, 'None'), Equipment.IsA(EquipmentClassName)))
			{
				IterDistance = VSize(Subtract_VectorVector(Location, Iter.Location));
				if(OrOr_BoolBool(EqualEqual_ObjectObject(Closest, none), Less_FloatFloat(IterDistance, ClosestDistance)))
				{
					Closest = Iter;
					ClosestDistance = IterDistance;
				}
			}
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return Closest;
	return;
}

function bool hasActiveMembers()
{
	return GetSquadAI().hasActiveMembers();
	return;
}

function bool CanExecuteCommand()
{
	if(Not_PreBool(hasActiveMembers()))
	{
		return false;
	}
	if(SwatAIRepo.GetHive().HasTurnedOnPlayer())
	{
		return false;
	}
	if(AreOfficersBusyEngaging())
	{
		TriggerBusyEngagingSpeech();
		return false;
	}
	return true;
	return;
}

private function bool AreOfficersBusyEngaging()
{
	local int i;
	local Pawn Officer, Assignment;

	SwatAIRepo.GetHive().UpdateOfficerAssignments();
	i = 0;
	J0x20:

	if(Less_IntInt(i, pawns.Length))
	{
		Officer = pawns[i];
		Assignment = ISwatOfficer(Officer).GetOfficerCommanderAction().GetCurrentAssignment();
		if(NotEqual_ObjectObject(Assignment, none))
		{
			return true;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x20;
	}
	return false;
	return;
}

private function TriggerBusyEngagingSpeech()
{
	local Pawn Officer;

	Officer = GetClosestOfficerTo(SwatAIRepo.Level.GetLocalPlayerController().Pawn);
	if(NotEqual_ObjectObject(Officer, none))
	{
		ISwatOfficer(Officer).GetOfficerSpeechManagerAction().TriggerBusyEngagingSpeech();
	}
	return;
}

private function TriggerOtherTeamDoingBehaviorSpeech()
{
	local Pawn Officer;

	Officer = GetClosestOfficerTo(SwatAIRepo.Level.GetLocalPlayerController().Pawn);
	if(NotEqual_ObjectObject(Officer, none))
	{
		ISwatOfficer(Officer).GetOfficerSpeechManagerAction().TriggerOtherTeamOnItSpeech();
	}
	return;
}

function TriggerTeamReportedSpeech(Pawn Officer)
{
	return;
}

function bool DoesAnOfficerHaveUsableEquipment(HandheldEquipment.EquipmentSlot Slot, optional name EquipmentClassName)
{
	local int i;
	local Pawn Officer;
	local HandheldEquipment Equipment;
	local FiredWeapon Weapon;

	i = 0;
	J0x07:

	if(Less_IntInt(i, pawns.Length))
	{
		Officer = pawns[i];
		Equipment = ISwatOfficer(Officer).GetItemAtSlot(Slot);
		if(NotEqual_ObjectObject(Equipment, none))
		{
			if(OrOr_BoolBool(EqualEqual_NameName(EquipmentClassName, 'None'), Equipment.IsA(EquipmentClassName)))
			{
				Weapon = FiredWeapon(Equipment);
				return OrOr_BoolBool(EqualEqual_ObjectObject(Weapon, none), Not_PreBool(Weapon.IsEmpty()));
			}
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return false;
	return;
}

event bool CanPickLock()
{
	return DoesAnOfficerHaveUsableEquipment(8);
	return;
}

private event bool CanBreachAndClearLockedDoor()
{
	if(OrOr_BoolBool(DoesAnOfficerHaveUsableEquipment(7), DoesAnOfficerHaveUsableEquipment(8)))
	{
		return true;
	}
	else
	{
		return false;
	}
	return;
}

event bool CanBreachAndClear(bool bPlayerBelievesDoorLocked)
{
	if(bPlayerBelievesDoorLocked)
	{
		return CanBreachAndClearLockedDoor();
	}
	else
	{
		return true;
	}
	return false;
	return;
}

event bool CanBreachBangAndClear(bool bPlayerBelievesDoorLocked)
{
	return AndAnd_BoolBool(CanBreachAndClear(bPlayerBelievesDoorLocked), DoesAnOfficerHaveUsableEquipment(3));
	return;
}

event bool CanBreachGasAndClear(bool bPlayerBelievesDoorLocked)
{
	return AndAnd_BoolBool(CanBreachAndClear(bPlayerBelievesDoorLocked), DoesAnOfficerHaveUsableEquipment(4));
	return;
}

event bool CanBreachStingAndClear(bool bPlayerBelievesDoorLocked)
{
	return AndAnd_BoolBool(CanBreachAndClear(bPlayerBelievesDoorLocked), DoesAnOfficerHaveUsableEquipment(5));
	return;
}

event bool CanBangAndClear()
{
	return DoesAnOfficerHaveUsableEquipment(3);
	return;
}

event bool CanGasAndClear()
{
	return DoesAnOfficerHaveUsableEquipment(4);
	return;
}

event bool CanStingAndClear()
{
	return DoesAnOfficerHaveUsableEquipment(5);
	return;
}

event bool CanDeployThrownItem(HandheldEquipment.EquipmentSlot ThrownItemEquipmentSlot)
{
	return DoesAnOfficerHaveUsableEquipment(ThrownItemEquipmentSlot);
	return;
}

event bool CanDeployShotgun(Door TargetDoor)
{
	return AndAnd_BoolBool(TargetDoor.IsClosed(), DoesAnOfficerHaveUsableEquipment(7, 'BreachingShotgun'));
	return;
}

event bool CanDeployC2(Door TargetDoor, bool bLeftSide)
{
	local ISwatDoor SwatDoor;

	SwatDoor = ISwatDoor(TargetDoor);
	assert(NotEqual_ObjectObject(SwatDoor, none));
	return AndAnd_BoolBool(TargetDoor.IsClosed(), DoesAnOfficerHaveUsableEquipment(7, 'C2Charge'));
	return;
}

event bool CanDeployPepperSpray()
{
	return DoesAnOfficerHaveUsableEquipment(6);
	return;
}

event bool CanDeployTaser()
{
	return DoesAnOfficerHaveUsableEquipment(2, 'Taser');
	return;
}

event bool CanDeployLessLethalShotgun()
{
	return DoesAnOfficerHaveUsableEquipment(1, 'LessLethalSG');
	return;
}

event bool CanDeployPepperBallGun()
{
	return DoesAnOfficerHaveUsableEquipment(1, 'CSBallLauncher');
	return;
}

event bool CanDeployWedge(Door TargetDoor)
{
	return AndAnd_BoolBool(Not_PreBool(ISwatDoor(TargetDoor).IsWedged()), DoesAnOfficerHaveUsableEquipment(10));
	return;
}

event bool CanDisable()
{
	return DoesAnOfficerHaveUsableEquipment(8);
	return;
}

event bool CanMirror()
{
	return DoesAnOfficerHaveUsableEquipment(9);
	return;
}

protected function PostCommandGoal(SquadCommandGoal NewCommandGoal)
{
	assert(NotEqual_ObjectObject(NewCommandGoal, none));
	UnpostCommandGoals();
	InternalPostCommandGoal(NewCommandGoal);
	return;
}

protected function InternalPostCommandGoal(SquadCommandGoal NewCommandGoal)
{
	assert(NotEqual_ObjectObject(NewCommandGoal, none));
	assert(EqualEqual_ObjectObject(CurrentSquadCommandGoal, none));
	CurrentSquadCommandGoal = NewCommandGoal;
	CurrentSquadCommandGoal.AddRef();
	CurrentSquadCommandGoal.postGoal(none);
	return;
}

protected function UnpostCommandGoals()
{
	return;
}

function ClearCommandGoal()
{
	if(AndAnd_BoolBool(NotEqual_ObjectObject(GetFirstOfficer(), none), GetFirstOfficer().logAI))
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(Name), " ClearCommandGoal - "), string(CurrentSquadCommandGoal)), " will be unposted on "), string(Name)));
	}
	if(NotEqual_ObjectObject(CurrentSquadCommandGoal, none))
	{
		CurrentSquadCommandGoal.unPostGoal(none);
		CurrentSquadCommandGoal.Release();
		CurrentSquadCommandGoal = none;
	}
	return;
}

function ClearNonCharacterInteractionCommandGoal()
{
	if(AndAnd_BoolBool(NotEqual_ObjectObject(CurrentSquadCommandGoal, none), Not_PreBool(CurrentSquadCommandGoal.bIsCharacterInteractionCommandGoal)))
	{
		ClearCommandGoal();
	}
	return;
}

function bool IsExecutingCommandGoal()
{
	return AndAnd_BoolBool(NotEqual_ObjectObject(CurrentSquadCommandGoal, none), Not_PreBool(CurrentSquadCommandGoal.hasCompleted()));
	return;
}

function bool IsSubElement()
{
	return false;
	return;
}

function ColoredSquadInfo GetOtherTeam()
{
	assert(Not_PreBool(IsA('ElementSquadInfo')));
	if(EqualEqual_ObjectObject(SwatAIRepo.GetBlueSquad(), self))
	{
		return SwatAIRepo.GetRedSquad();
	}
	else
	{
		return SwatAIRepo.GetBlueSquad();
	}
	return;
}

function bool IsOtherSubElementUsingDoor(Door TestDoor)
{
	local Door DoorOtherTeamIsUsing;

	assert(NotEqual_ObjectObject(TestDoor, none));
	DoorOtherTeamIsUsing = GetOtherTeam().GetDoorBeingUsed();
	return EqualEqual_ObjectObject(DoorOtherTeamIsUsing, TestDoor);
	return;
}

function Door GetDoorBeingUsed()
{
	if(IsExecutingCommandGoal())
	{
		return CurrentSquadCommandGoal.GetDoorBeingUsed();
	}
	else
	{
		return none;
	}
	return;
}

function bool IsOtherSubElementFallingIn()
{
	return GetOtherTeam().IsFallingIn();
	return;
}

function bool IsFallingIn()
{
	if(IsExecutingCommandGoal())
	{
		return CurrentSquadCommandGoal.IsA('SquadFallInGoal');
	}
	else
	{
		return false;
	}
	return;
}

function bool IsOtherSubElementInteractingWith(Actor TestActor)
{
	return GetOtherTeam().IsTeamInteractingWith(TestActor);
	return;
}

function bool IsTeamInteractingWith(Actor TestActor)
{
	if(IsExecutingCommandGoal())
	{
		return CurrentSquadCommandGoal.IsInteractingWith(TestActor);
	}
	else
	{
		return false;
	}
	return;
}

function FallIn(Pawn CommandGiver, Vector CommandOrigin)
{
	local SquadFallInGoal SquadFallInGoal;

	if(CanExecuteCommand())
	{
		if(OrOr_BoolBool(Not_PreBool(IsSubElement()), Not_PreBool(IsOtherSubElementFallingIn())))
		{
			SquadFallInGoal = Class'SwatAICommon.SquadFallInGoal'.static.Allocate(self).;
			construct_AI_ResourcePawnVector(AI_Resource(SquadAI), CommandGiver, CommandOrigin);
			assert(NotEqual_ObjectObject(SquadFallInGoal, none));
			PostCommandGoal(SquadFallInGoal);
		}
		else
		{
			SwatAIRepo.GetElementSquad().FallIn(CommandGiver, CommandOrigin);
		}
	}
	return;
}

function StackUpAt(Pawn CommandGiver, Vector CommandOrigin, Door TargetDoor)
{
	local SquadStackUpGoal SquadStackUpGoal;

	if(CanExecuteCommand())
	{
		if(OrOr_BoolBool(Not_PreBool(IsSubElement()), Not_PreBool(IsOtherSubElementUsingDoor(TargetDoor))))
		{
			SquadStackUpGoal = Class'SwatAICommon.SquadStackUpGoal'.static.Allocate(self).;
			construct_AI_ResourcePawnVectorDoorBool(AI_Resource(SquadAI), CommandGiver, CommandOrigin, TargetDoor);
			assert(NotEqual_ObjectObject(SquadStackUpGoal, none));
			PostCommandGoal(SquadStackUpGoal);
		}
		else
		{
			TriggerOtherTeamDoingBehaviorSpeech();
		}
	}
	return;
}

function StackUpAndTryDoorAt(Pawn CommandGiver, Vector CommandOrigin, Door TargetDoor, optional bool bTriggerCouldntBreachLockedSpeech)
{
	local SquadStackUpAndTryDoorGoal SquadStackUpAndTryDoorGoal;

	if(CanExecuteCommand())
	{
		if(OrOr_BoolBool(Not_PreBool(IsSubElement()), Not_PreBool(IsOtherSubElementUsingDoor(TargetDoor))))
		{
			SquadStackUpAndTryDoorGoal = Class'SwatAICommon.SquadStackUpAndTryDoorGoal'.static.Allocate(self).;
			construct_AI_ResourcePawnVectorDoorBool(AI_Resource(SquadAI), CommandGiver, CommandOrigin, TargetDoor, bTriggerCouldntBreachLockedSpeech);
			assert(NotEqual_ObjectObject(SquadStackUpAndTryDoorGoal, none));
			PostCommandGoal(SquadStackUpAndTryDoorGoal);
		}
		else
		{
			TriggerOtherTeamDoingBehaviorSpeech();
		}
	}
	return;
}

function MoveAndClear(Pawn CommandGiver, Vector CommandOrigin, Door TargetDoor)
{
	local SquadMoveAndClearGoal SquadMoveAndClearGoal;

	if(CanExecuteCommand())
	{
		if(OrOr_BoolBool(Not_PreBool(IsSubElement()), Not_PreBool(IsOtherSubElementUsingDoor(TargetDoor))))
		{
			SquadMoveAndClearGoal = Class'SwatAICommon.SquadMoveAndClearGoal'.static.Allocate(self).;
			construct_AI_ResourcePawnVectorDoorBool(AI_Resource(SquadAI), CommandGiver, CommandOrigin, TargetDoor);
			assert(NotEqual_ObjectObject(SquadMoveAndClearGoal, none));
			PostCommandGoal(SquadMoveAndClearGoal);
		}
		else
		{
			TriggerOtherTeamDoingBehaviorSpeech();
		}
	}
	return;
}

function BangAndClear(Pawn CommandGiver, Vector CommandOrigin, Door TargetDoor)
{
	local SquadBangAndClearGoal SquadBangAndClearGoal;

	if(CanExecuteCommand())
	{
		if(OrOr_BoolBool(Not_PreBool(IsSubElement()), Not_PreBool(IsOtherSubElementUsingDoor(TargetDoor))))
		{
			if(CanBangAndClear())
			{
				SquadBangAndClearGoal = Class'SwatAICommon.SquadBangAndClearGoal'.static.Allocate(self).;
				construct_AI_ResourcePawnVectorDoorBool(AI_Resource(SquadAI), CommandGiver, CommandOrigin, TargetDoor);
				assert(NotEqual_ObjectObject(SquadBangAndClearGoal, none));
				PostCommandGoal(SquadBangAndClearGoal);
			}
			else
			{
				ISwatOfficer(GetFirstOfficer()).GetOfficerSpeechManagerAction().TriggerFlashbangUnavailableSpeech();
			}
		}
		else
		{
			TriggerOtherTeamDoingBehaviorSpeech();
		}
	}
	return;
}

function GasAndClear(Pawn CommandGiver, Vector CommandOrigin, Door TargetDoor)
{
	local SquadGasAndClearGoal SquadGasAndClearGoal;

	if(CanExecuteCommand())
	{
		if(OrOr_BoolBool(Not_PreBool(IsSubElement()), Not_PreBool(IsOtherSubElementUsingDoor(TargetDoor))))
		{
			if(CanGasAndClear())
			{
				SquadGasAndClearGoal = Class'SwatAICommon.SquadGasAndClearGoal'.static.Allocate(self).;
				construct_AI_ResourcePawnVectorDoorBool(AI_Resource(SquadAI), CommandGiver, CommandOrigin, TargetDoor);
				assert(NotEqual_ObjectObject(SquadGasAndClearGoal, none));
				PostCommandGoal(SquadGasAndClearGoal);
			}
			else
			{
				ISwatOfficer(GetFirstOfficer()).GetOfficerSpeechManagerAction().TriggerGasUnavailableSpeech();
			}
		}
		else
		{
			TriggerOtherTeamDoingBehaviorSpeech();
		}
	}
	return;
}

function StingAndClear(Pawn CommandGiver, Vector CommandOrigin, Door TargetDoor)
{
	local SquadStingAndClearGoal SquadStingAndClearGoal;

	if(CanExecuteCommand())
	{
		if(OrOr_BoolBool(Not_PreBool(IsSubElement()), Not_PreBool(IsOtherSubElementUsingDoor(TargetDoor))))
		{
			if(CanStingAndClear())
			{
				SquadStingAndClearGoal = Class'SwatAICommon.SquadStingAndClearGoal'.static.Allocate(self).;
				construct_AI_ResourcePawnVectorDoorBool(AI_Resource(SquadAI), CommandGiver, CommandOrigin, TargetDoor);
				assert(NotEqual_ObjectObject(SquadStingAndClearGoal, none));
				PostCommandGoal(SquadStingAndClearGoal);
			}
			else
			{
				ISwatOfficer(GetFirstOfficer()).GetOfficerSpeechManagerAction().TriggerStingUnavailableSpeech();
			}
		}
		else
		{
			TriggerOtherTeamDoingBehaviorSpeech();
		}
	}
	return;
}

function BreachAndClear(Pawn CommandGiver, Vector CommandOrigin, Door TargetDoor)
{
	local SquadBreachAndClearGoal SquadBreachAndClearGoal;

	if(CanExecuteCommand())
	{
		if(OrOr_BoolBool(Not_PreBool(IsSubElement()), Not_PreBool(IsOtherSubElementUsingDoor(TargetDoor))))
		{
			if(ISwatPawn(CommandGiver).DoesBelieveDoorLocked(TargetDoor))
			{
				if(CanBreachAndClearLockedDoor())
				{
					SquadBreachAndClearGoal = Class'SwatAICommon.SquadBreachAndClearGoal'.static.Allocate(self).;
					construct_AI_ResourcePawnVectorDoorBool(AI_Resource(SquadAI), CommandGiver, CommandOrigin, TargetDoor);
					assert(NotEqual_ObjectObject(SquadBreachAndClearGoal, none));
					PostCommandGoal(SquadBreachAndClearGoal);
				}
				else
				{
					ISwatOfficer(GetFirstOfficer()).GetOfficerSpeechManagerAction().TriggerDoorBreachingEquipmentUnavailableSpeech();
				}
			}
			else
			{
				if(ISwatDoor(TargetDoor).IsLocked())
				{
					StackUpAndTryDoorAt(CommandGiver, CommandOrigin, TargetDoor, true);
				}
				else
				{
					MoveAndClear(CommandGiver, CommandOrigin, TargetDoor);
				}
			}
		}
		else
		{
			TriggerOtherTeamDoingBehaviorSpeech();
		}
	}
	return;
}

function BreachBangAndClear(Pawn CommandGiver, Vector CommandOrigin, Door TargetDoor)
{
	local SquadBreachBangAndClearGoal SquadBreachBangAndClearGoal;

	if(CanExecuteCommand())
	{
		if(OrOr_BoolBool(Not_PreBool(IsSubElement()), Not_PreBool(IsOtherSubElementUsingDoor(TargetDoor))))
		{
			if(AndAnd_BoolBool(NotEqual_ObjectObject(pawns[0], none), pawns[0].logAI))
			{
				Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("BreachBangAndClear - CommandGiver believes door locked: ", string(ISwatPawn(CommandGiver).DoesBelieveDoorLocked(TargetDoor))), " is door locked: "), string(ISwatDoor(TargetDoor).IsLocked())));
			}
			if(ISwatPawn(CommandGiver).DoesBelieveDoorLocked(TargetDoor))
			{
				if(Not_PreBool(DoesAnOfficerHaveUsableEquipment(3)))
				{
					ISwatOfficer(GetFirstOfficer()).GetOfficerSpeechManagerAction().TriggerFlashbangUnavailableSpeech();
				}
				else
				{
					if(Not_PreBool(CanBreachAndClearLockedDoor()))
					{
						ISwatOfficer(GetFirstOfficer()).GetOfficerSpeechManagerAction().TriggerDoorBreachingEquipmentUnavailableSpeech();
					}
					else
					{
						SquadBreachBangAndClearGoal = Class'SwatAICommon.SquadBreachBangAndClearGoal'.static.Allocate(self).;
						construct_AI_ResourcePawnVectorDoorBool(AI_Resource(SquadAI), CommandGiver, CommandOrigin, TargetDoor);
						assert(NotEqual_ObjectObject(SquadBreachBangAndClearGoal, none));
						PostCommandGoal(SquadBreachBangAndClearGoal);
					}
				}
			}
			else
			{
				if(ISwatDoor(TargetDoor).IsLocked())
				{
					StackUpAndTryDoorAt(CommandGiver, CommandOrigin, TargetDoor, true);
				}
				else
				{
					BangAndClear(CommandGiver, CommandOrigin, TargetDoor);
				}
			}
		}
		else
		{
			TriggerOtherTeamDoingBehaviorSpeech();
		}
	}
	return;
}

function BreachGasAndClear(Pawn CommandGiver, Vector CommandOrigin, Door TargetDoor)
{
	local SquadBreachGasAndClearGoal SquadBreachGasAndClearGoal;

	if(CanExecuteCommand())
	{
		if(OrOr_BoolBool(Not_PreBool(IsSubElement()), Not_PreBool(IsOtherSubElementUsingDoor(TargetDoor))))
		{
			if(ISwatPawn(CommandGiver).DoesBelieveDoorLocked(TargetDoor))
			{
				if(Not_PreBool(DoesAnOfficerHaveUsableEquipment(4)))
				{
					ISwatOfficer(GetFirstOfficer()).GetOfficerSpeechManagerAction().TriggerGasUnavailableSpeech();
				}
				else
				{
					if(Not_PreBool(CanBreachAndClearLockedDoor()))
					{
						ISwatOfficer(GetFirstOfficer()).GetOfficerSpeechManagerAction().TriggerDoorBreachingEquipmentUnavailableSpeech();
					}
					else
					{
						SquadBreachGasAndClearGoal = Class'SwatAICommon.SquadBreachGasAndClearGoal'.static.Allocate(self).;
						construct_AI_ResourcePawnVectorDoorBool(AI_Resource(SquadAI), CommandGiver, CommandOrigin, TargetDoor);
						assert(NotEqual_ObjectObject(SquadBreachGasAndClearGoal, none));
						PostCommandGoal(SquadBreachGasAndClearGoal);
					}
				}
			}
			else
			{
				if(ISwatDoor(TargetDoor).IsLocked())
				{
					StackUpAndTryDoorAt(CommandGiver, CommandOrigin, TargetDoor, true);
				}
				else
				{
					GasAndClear(CommandGiver, CommandOrigin, TargetDoor);
				}
			}
		}
		else
		{
			TriggerOtherTeamDoingBehaviorSpeech();
		}
	}
	return;
}

function BreachStingAndClear(Pawn CommandGiver, Vector CommandOrigin, Door TargetDoor)
{
	local SquadBreachStingAndClearGoal SquadBreachStingAndClearGoal;

	if(CanExecuteCommand())
	{
		if(OrOr_BoolBool(Not_PreBool(IsSubElement()), Not_PreBool(IsOtherSubElementUsingDoor(TargetDoor))))
		{
			if(ISwatPawn(CommandGiver).DoesBelieveDoorLocked(TargetDoor))
			{
				if(Not_PreBool(DoesAnOfficerHaveUsableEquipment(5)))
				{
					ISwatOfficer(GetFirstOfficer()).GetOfficerSpeechManagerAction().TriggerStingUnavailableSpeech();
				}
				else
				{
					if(Not_PreBool(CanBreachAndClearLockedDoor()))
					{
						ISwatOfficer(GetFirstOfficer()).GetOfficerSpeechManagerAction().TriggerDoorBreachingEquipmentUnavailableSpeech();
					}
					else
					{
						SquadBreachStingAndClearGoal = Class'SwatAICommon.SquadBreachStingAndClearGoal'.static.Allocate(self).;
						construct_AI_ResourcePawnVectorDoorBool(AI_Resource(SquadAI), CommandGiver, CommandOrigin, TargetDoor);
						assert(NotEqual_ObjectObject(SquadBreachStingAndClearGoal, none));
						PostCommandGoal(SquadBreachStingAndClearGoal);
					}
				}
			}
			else
			{
				if(ISwatDoor(TargetDoor).IsLocked())
				{
					StackUpAndTryDoorAt(CommandGiver, CommandOrigin, TargetDoor, true);
				}
				else
				{
					StingAndClear(CommandGiver, CommandOrigin, TargetDoor);
				}
			}
		}
		else
		{
			TriggerOtherTeamDoingBehaviorSpeech();
		}
	}
	return;
}

function DeployThrownItemAt(Pawn CommandGiver, Vector CommandOrigin, HandheldEquipment.EquipmentSlot ThrownItemSlot, Vector TargetLocation, optional Door TargetDoor)
{
	local SquadDeployThrownItemGoal SquadDeployThrownItemGoal;
	local SquadDeployThrownItemThroughDoorGoal SquadDeployThrownItemThroughDoorGoal;

	if(CanExecuteCommand())
	{
		if(OrOr_BoolBool(OrOr_BoolBool(EqualEqual_ObjectObject(TargetDoor, none), Not_PreBool(IsSubElement())), Not_PreBool(IsOtherSubElementUsingDoor(TargetDoor))))
		{
			if(CanDeployThrownItem(ThrownItemSlot))
			{
				if(NotEqual_ObjectObject(TargetDoor, none))
				{
					if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(TargetDoor.IsClosed(), Not_PreBool(TargetDoor.IsOpening())), Not_PreBool(TargetDoor.IsBroken())), TargetDoor.IsLocked()))
					{
						StackUpAndTryDoorAt(CommandGiver, CommandOrigin, TargetDoor, true);
					}
					else
					{
						SquadDeployThrownItemThroughDoorGoal = Class'SwatAICommon.SquadDeployThrownItemThroughDoorGoal'.static.Allocate(self).;
						construct_AI_ResourcePawnVectorDoorByte(AI_Resource(SquadAI), CommandGiver, CommandOrigin, TargetDoor, ThrownItemSlot);
						assert(NotEqual_ObjectObject(SquadDeployThrownItemThroughDoorGoal, none));
						PostCommandGoal(SquadDeployThrownItemThroughDoorGoal);
					}
				}
				else
				{
					SquadDeployThrownItemGoal = Class'SwatAICommon.SquadDeployThrownItemGoal'.static.Allocate(self).;
					construct_AI_ResourcePawnVectorByteVector(AI_Resource(SquadAI), CommandGiver, CommandOrigin, ThrownItemSlot, TargetLocation);
					assert(NotEqual_ObjectObject(SquadDeployThrownItemGoal, none));
					PostCommandGoal(SquadDeployThrownItemGoal);
				}
			}
			else
			{
				switch(ThrownItemSlot)
				{
					case 3:
						ISwatOfficer(GetFirstOfficer()).GetOfficerSpeechManagerAction().TriggerFlashbangUnavailableSpeech();
						break;
					case 4:
						ISwatOfficer(GetFirstOfficer()).GetOfficerSpeechManagerAction().TriggerGasUnavailableSpeech();
						break;
					case 5:
						ISwatOfficer(GetFirstOfficer()).GetOfficerSpeechManagerAction().TriggerStingUnavailableSpeech();
						break;
					default:
						break;
				}
			}
		}
		else
		{
			TriggerOtherTeamDoingBehaviorSpeech();
		}
	}
	return;
}

function PickLock(Pawn CommandGiver, Vector CommandOrigin, Door TargetDoor)
{
	local SquadPickLockGoal SquadPickLockGoal;

	if(CanExecuteCommand())
	{
		if(OrOr_BoolBool(Not_PreBool(IsSubElement()), Not_PreBool(IsOtherSubElementUsingDoor(TargetDoor))))
		{
			if(CanPickLock())
			{
				SquadPickLockGoal = Class'SwatAICommon.SquadPickLockGoal'.static.Allocate(self).;
				construct_AI_ResourcePawnVectorDoorBool(AI_Resource(SquadAI), CommandGiver, CommandOrigin, TargetDoor);
				assert(NotEqual_ObjectObject(SquadPickLockGoal, none));
				PostCommandGoal(SquadPickLockGoal);
			}
			else
			{
				ISwatOfficer(GetFirstOfficer()).GetOfficerSpeechManagerAction().TriggerToolkitUnavailableSpeech();
			}
		}
		else
		{
			TriggerOtherTeamDoingBehaviorSpeech();
		}
	}
	return;
}

function DeployWedge(Pawn CommandGiver, Vector CommandOrigin, Door TargetDoor)
{
	local SquadPlaceWedgeGoal SquadPlaceWedgeGoal;

	if(CanExecuteCommand())
	{
		if(OrOr_BoolBool(Not_PreBool(IsSubElement()), Not_PreBool(IsOtherSubElementUsingDoor(TargetDoor))))
		{
			if(CanDeployWedge(TargetDoor))
			{
				SquadPlaceWedgeGoal = Class'SwatAICommon.SquadPlaceWedgeGoal'.static.Allocate(self).;
				construct_AI_ResourcePawnVectorDoorBool(AI_Resource(SquadAI), CommandGiver, CommandOrigin, TargetDoor);
				assert(NotEqual_ObjectObject(SquadPlaceWedgeGoal, none));
				PostCommandGoal(SquadPlaceWedgeGoal);
			}
			else
			{
				if(Not_PreBool(DoesAnOfficerHaveUsableEquipment(10)))
				{
					ISwatOfficer(GetFirstOfficer()).GetOfficerSpeechManagerAction().TriggerWedgeUnavailableSpeech();
				}
				else
				{
					assert(ISwatDoor(TargetDoor).IsWedged());
					ISwatOfficer(GetFirstOfficer()).GetOfficerSpeechManagerAction().TriggerDoorIsAlreadyWedgedSpeech();
				}
			}
		}
		else
		{
			TriggerOtherTeamDoingBehaviorSpeech();
		}
	}
	return;
}

function RemoveWedge(Pawn CommandGiver, Vector CommandOrigin, Door WedgedDoor)
{
	local SquadRemoveWedgeGoal SquadRemoveWedgeGoal;

	if(CanExecuteCommand())
	{
		if(OrOr_BoolBool(Not_PreBool(IsSubElement()), Not_PreBool(IsOtherSubElementUsingDoor(WedgedDoor))))
		{
			if(CanPickLock())
			{
				SquadRemoveWedgeGoal = Class'SwatAICommon.SquadRemoveWedgeGoal'.static.Allocate(self).;
				construct_AI_ResourcePawnVectorDoorBool(AI_Resource(SquadAI), CommandGiver, CommandOrigin, WedgedDoor);
				assert(NotEqual_ObjectObject(SquadRemoveWedgeGoal, none));
				PostCommandGoal(SquadRemoveWedgeGoal);
			}
			else
			{
				ISwatOfficer(GetFirstOfficer()).GetOfficerSpeechManagerAction().TriggerToolkitUnavailableSpeech();
			}
		}
		else
		{
			TriggerOtherTeamDoingBehaviorSpeech();
		}
	}
	return;
}

function DeployC2(Pawn CommandGiver, Vector CommandOrigin, Door TargetDoor)
{
	local SquadDeployC2Goal CurrentSquadDeployC2Goal;
	local ISwatDoor SwatDoorTarget;

	if(CanExecuteCommand())
	{
		if(OrOr_BoolBool(Not_PreBool(IsSubElement()), Not_PreBool(IsOtherSubElementUsingDoor(TargetDoor))))
		{
			SwatDoorTarget = ISwatDoor(TargetDoor);
			assert(NotEqual_ObjectObject(SwatDoorTarget, none));
			if(Not_PreBool(TargetDoor.IsClosed()))
			{
				ISwatOfficer(GetFirstOfficer()).GetOfficerSpeechManagerAction().TriggerDoorNotClosedSpeech();
			}
			else
			{
				if(CanDeployC2(TargetDoor, SwatDoorTarget.PointIsToMyLeft(CommandOrigin)))
				{
					CurrentSquadDeployC2Goal = Class'SwatAICommon.SquadDeployC2Goal'.static.Allocate(self).;
					construct_AI_ResourcePawnVectorDoorBool(AI_Resource(SquadAI), CommandGiver, CommandOrigin, TargetDoor);
					assert(NotEqual_ObjectObject(CurrentSquadDeployC2Goal, none));
					PostCommandGoal(CurrentSquadDeployC2Goal);
				}
				else
				{
					ISwatOfficer(GetFirstOfficer()).GetOfficerSpeechManagerAction().TriggerC2UnavailableSpeech();
				}
			}
		}
		else
		{
			TriggerOtherTeamDoingBehaviorSpeech();
		}
	}
	return;
}

function CloseDoor(Pawn CommandGiver, Vector CommandOrigin, Door TargetDoor)
{
	local SquadCloseDoorGoal CurrentSquadCloseDoorGoal;

	if(CanExecuteCommand())
	{
		if(OrOr_BoolBool(Not_PreBool(IsSubElement()), Not_PreBool(IsOtherSubElementUsingDoor(TargetDoor))))
		{
			CurrentSquadCloseDoorGoal = Class'SwatAICommon.SquadCloseDoorGoal'.static.Allocate(self).;
			construct_AI_ResourcePawnVectorDoor(AI_Resource(SquadAI), CommandGiver, CommandOrigin, TargetDoor);
			assert(NotEqual_ObjectObject(CurrentSquadCloseDoorGoal, none));
			PostCommandGoal(CurrentSquadCloseDoorGoal);
		}
		else
		{
			TriggerOtherTeamDoingBehaviorSpeech();
		}
	}
	return;
}

function Secure(Pawn CommandGiver, Vector CommandOrigin, Actor SecureTarget)
{
	local SquadSecureGoal CurrentSquadSecureGoal;

	if(CanExecuteCommand())
	{
		if(OrOr_BoolBool(Not_PreBool(IsSubElement()), Not_PreBool(IsOtherSubElementInteractingWith(SecureTarget))))
		{
			CurrentSquadSecureGoal = SquadSecureGoal(CurrentSquadCommandGoal);
			if(AndAnd_BoolBool(NotEqual_ObjectObject(CurrentSquadSecureGoal, none), Not_PreBool(CurrentSquadSecureGoal.hasCompleted())))
			{
				CurrentSquadSecureGoal.AddSecureTarget(SecureTarget);
			}
			else
			{
				CurrentSquadSecureGoal = Class'SwatAICommon.SquadSecureGoal'.static.Allocate(self).;
				construct_AI_ResourcePawnVector(AI_Resource(SquadAI), CommandGiver, CommandOrigin);
				assert(NotEqual_ObjectObject(CurrentSquadSecureGoal, none));
				CurrentSquadSecureGoal.AddSecureTarget(SecureTarget);
				PostCommandGoal(CurrentSquadSecureGoal);
			}
		}
		else
		{
			TriggerOtherTeamDoingBehaviorSpeech();
		}
	}
	return;
}

function Restrain(Pawn CommandGiver, Vector CommandOrigin, Pawn TargetPawn)
{
	Secure(CommandGiver, CommandOrigin, TargetPawn);
	return;
}

function SecureEvidence(Pawn CommandGiver, Vector CommandOrigin, Actor Evidence)
{
	Secure(CommandGiver, CommandOrigin, Evidence);
	return;
}

function MoveTo(Pawn CommandGiver, Vector CommandOrigin, Vector TargetLocation)
{
	local SquadMoveToGoal CurrentSquadMoveToGoal;

	if(CanExecuteCommand())
	{
		CurrentSquadMoveToGoal = Class'SwatAICommon.SquadMoveToGoal'.static.Allocate(self).;
		construct_AI_ResourcePawnVectorVector(AI_Resource(SquadAI), CommandGiver, CommandOrigin, TargetLocation);
		assert(NotEqual_ObjectObject(CurrentSquadMoveToGoal, none));
		PostCommandGoal(CurrentSquadMoveToGoal);
	}
	return;
}

function Cover(Pawn CommandGiver, Vector CommandOrigin, Vector TargetLocation)
{
	local SquadCoverGoal CurrentSquadCoverGoal;

	if(CanExecuteCommand())
	{
		CurrentSquadCoverGoal = Class'SwatAICommon.SquadCoverGoal'.static.Allocate(self).;
		construct_AI_ResourcePawnVectorVector(AI_Resource(SquadAI), CommandGiver, CommandOrigin, TargetLocation);
		assert(NotEqual_ObjectObject(CurrentSquadCoverGoal, none));
		PostCommandGoal(CurrentSquadCoverGoal);
	}
	return;
}

private function InternalMirrorRoom(Pawn CommandGiver, Vector CommandOrigin, Door TargetDoor)
{
	local SquadMirrorDoorGoal CurrentSquadMirrorDoorGoal;

	if(CanExecuteCommand())
	{
		if(OrOr_BoolBool(Not_PreBool(IsSubElement()), Not_PreBool(IsOtherSubElementUsingDoor(TargetDoor))))
		{
			if(CanMirror())
			{
				CurrentSquadMirrorDoorGoal = Class'SwatAICommon.SquadMirrorDoorGoal'.static.Allocate(self).;
				construct_AI_ResourcePawnVectorDoorBool(AI_Resource(SquadAI), CommandGiver, CommandOrigin, TargetDoor, false);
				assert(NotEqual_ObjectObject(CurrentSquadMirrorDoorGoal, none));
				PostCommandGoal(CurrentSquadMirrorDoorGoal);
			}
			else
			{
				ISwatOfficer(GetFirstOfficer()).GetOfficerSpeechManagerAction().TriggerMirrorUnavailableSpeech();
			}
		}
		else
		{
			TriggerOtherTeamDoingBehaviorSpeech();
		}
	}
	return;
}

function MirrorRoom(Pawn CommandGiver, Vector CommandOrigin, Door TargetDoor)
{
	InternalMirrorRoom(CommandGiver, CommandOrigin, TargetDoor);
	return;
}

function MirrorUnderDoor(Pawn CommandGiver, Vector CommandOrigin, Door TargetDoor)
{
	InternalMirrorRoom(CommandGiver, CommandOrigin, TargetDoor);
	return;
}

function MirrorCorner(Pawn CommandGiver, Vector CommandOrigin, Actor MirrorPoint)
{
	local SquadMirrorCornerGoal CurrentSquadMirrorCornerGoal;

	assert(NotEqual_ObjectObject(MirrorPoint, none));
	AssertWithDescription(MirrorPoint.IsA('IMirrorPoint'), "OfficerTeamInfo::MirrorCorner - Actor passed in is not a IMirrorPoint");
	if(CanExecuteCommand())
	{
		if(OrOr_BoolBool(Not_PreBool(IsSubElement()), Not_PreBool(IsOtherSubElementInteractingWith(MirrorPoint))))
		{
			if(CanMirror())
			{
				CurrentSquadMirrorCornerGoal = Class'SwatAICommon.SquadMirrorCornerGoal'.static.Allocate(self).;
				construct_AI_ResourcePawnVectorActor(AI_Resource(SquadAI), CommandGiver, CommandOrigin, MirrorPoint);
				assert(NotEqual_ObjectObject(CurrentSquadMirrorCornerGoal, none));
				PostCommandGoal(CurrentSquadMirrorCornerGoal);
			}
			else
			{
				ISwatOfficer(GetFirstOfficer()).GetOfficerSpeechManagerAction().TriggerMirrorUnavailableSpeech();
			}
		}
		else
		{
			TriggerOtherTeamDoingBehaviorSpeech();
		}
	}
	return;
}

function DeployTaser(Pawn CommandGiver, Vector CommandOrigin, Pawn TargetPawn)
{
	local SquadDeployTaserGoal CurrentSquadDeployTaserGoal;

	if(CanExecuteCommand())
	{
		if(OrOr_BoolBool(Not_PreBool(IsSubElement()), Not_PreBool(IsOtherSubElementInteractingWith(TargetPawn))))
		{
			if(CanDeployTaser())
			{
				CurrentSquadDeployTaserGoal = Class'SwatAICommon.SquadDeployTaserGoal'.static.Allocate(self).;
				construct_AI_ResourcePawnVectorPawn(AI_Resource(SquadAI), CommandGiver, CommandOrigin, TargetPawn);
				assert(NotEqual_ObjectObject(CurrentSquadDeployTaserGoal, none));
				PostCommandGoal(CurrentSquadDeployTaserGoal);
			}
			else
			{
				ISwatOfficer(GetFirstOfficer()).GetOfficerSpeechManagerAction().TriggerTaserUnavailableSpeech();
			}
		}
		else
		{
			TriggerOtherTeamDoingBehaviorSpeech();
		}
	}
	return;
}

function DeployPepperSpray(Pawn CommandGiver, Vector CommandOrigin, Pawn TargetPawn)
{
	local SquadDeployPepperSprayGoal CurrentSquadDeployPepperSprayGoal;

	if(CanExecuteCommand())
	{
		if(OrOr_BoolBool(Not_PreBool(IsSubElement()), Not_PreBool(IsOtherSubElementInteractingWith(TargetPawn))))
		{
			if(CanDeployPepperSpray())
			{
				CurrentSquadDeployPepperSprayGoal = Class'SwatAICommon.SquadDeployPepperSprayGoal'.static.Allocate(self).;
				construct_AI_ResourcePawnVectorPawn(AI_Resource(SquadAI), CommandGiver, CommandOrigin, TargetPawn);
				assert(NotEqual_ObjectObject(CurrentSquadDeployPepperSprayGoal, none));
				PostCommandGoal(CurrentSquadDeployPepperSprayGoal);
			}
			else
			{
				ISwatOfficer(GetFirstOfficer()).GetOfficerSpeechManagerAction().TriggerPepperSprayUnavailableSpeech();
			}
		}
		else
		{
			TriggerOtherTeamDoingBehaviorSpeech();
		}
	}
	return;
}

function DisableTarget(Pawn CommandGiver, Vector CommandOrigin, Actor Target)
{
	local SquadDisableTargetGoal CurrentSquadDisableTargetGoal;

	if(CanExecuteCommand())
	{
		if(OrOr_BoolBool(Not_PreBool(IsSubElement()), Not_PreBool(IsOtherSubElementInteractingWith(Target))))
		{
			CurrentSquadDisableTargetGoal = Class'SwatAICommon.SquadDisableTargetGoal'.static.Allocate(self).;
			construct_AI_ResourcePawnVectorActor(AI_Resource(SquadAI), CommandGiver, CommandOrigin, Target);
			assert(NotEqual_ObjectObject(CurrentSquadDisableTargetGoal, none));
			PostCommandGoal(CurrentSquadDisableTargetGoal);
		}
		else
		{
			TriggerOtherTeamDoingBehaviorSpeech();
		}
	}
	return;
}

function DeployShotgun(Pawn CommandGiver, Vector CommandOrigin, Door TargetDoor)
{
	local SquadDeployShotgunGoal CurrentSquadDeployShotgunGoal;
	local ISwatDoor SwatDoorTarget;

	if(CanExecuteCommand())
	{
		if(OrOr_BoolBool(Not_PreBool(IsSubElement()), Not_PreBool(IsOtherSubElementUsingDoor(TargetDoor))))
		{
			if(CanDeployShotgun(TargetDoor))
			{
				SwatDoorTarget = ISwatDoor(TargetDoor);
				assert(NotEqual_ObjectObject(SwatDoorTarget, none));
				if(Not_PreBool(TargetDoor.IsClosed()))
				{
					ISwatOfficer(GetFirstOfficer()).GetOfficerSpeechManagerAction().TriggerDoorNotClosedSpeech();
				}
				else
				{
					CurrentSquadDeployShotgunGoal = Class'SwatAICommon.SquadDeployShotgunGoal'.static.Allocate(self).;
					construct_AI_ResourcePawnVectorDoorBool(AI_Resource(SquadAI), CommandGiver, CommandOrigin, TargetDoor);
					assert(NotEqual_ObjectObject(CurrentSquadDeployShotgunGoal, none));
					PostCommandGoal(CurrentSquadDeployShotgunGoal);
				}
			}
			else
			{
				ISwatOfficer(GetFirstOfficer()).GetOfficerSpeechManagerAction().TriggerShotgunUnavailableSpeech();
			}
		}
		else
		{
			TriggerOtherTeamDoingBehaviorSpeech();
		}
	}
	return;
}

function DeployLessLethalShotgun(Pawn CommandGiver, Vector CommandOrigin, Pawn TargetPawn)
{
	local SquadDeployLessLethalShotgunGoal CurrentSquadDeployLessLethalShotgunGoal;

	if(CanExecuteCommand())
	{
		if(OrOr_BoolBool(Not_PreBool(IsSubElement()), Not_PreBool(IsOtherSubElementInteractingWith(TargetPawn))))
		{
			if(CanDeployLessLethalShotgun())
			{
				CurrentSquadDeployLessLethalShotgunGoal = Class'SwatAICommon.SquadDeployLessLethalShotgunGoal'.static.Allocate(self).;
				construct_AI_ResourcePawnVectorPawn(AI_Resource(SquadAI), CommandGiver, CommandOrigin, TargetPawn);
				assert(NotEqual_ObjectObject(CurrentSquadDeployLessLethalShotgunGoal, none));
				PostCommandGoal(CurrentSquadDeployLessLethalShotgunGoal);
			}
			else
			{
				ISwatOfficer(GetFirstOfficer()).GetOfficerSpeechManagerAction().TriggerLessLethalShotgunUnavailableSpeech();
			}
		}
		else
		{
			TriggerOtherTeamDoingBehaviorSpeech();
		}
	}
	return;
}

function DeployPepperBallGun(Pawn CommandGiver, Vector CommandOrigin, Pawn TargetPawn)
{
	local SquadDeployPepperBallGoal CurrentSquadDeployPepperBallGoal;

	if(CanExecuteCommand())
	{
		if(OrOr_BoolBool(Not_PreBool(IsSubElement()), Not_PreBool(IsOtherSubElementInteractingWith(TargetPawn))))
		{
			if(CanDeployPepperBallGun())
			{
				CurrentSquadDeployPepperBallGoal = Class'SwatAICommon.SquadDeployPepperBallGoal'.static.Allocate(self).;
				construct_AI_ResourcePawnVectorPawn(AI_Resource(SquadAI), CommandGiver, CommandOrigin, TargetPawn);
				assert(NotEqual_ObjectObject(CurrentSquadDeployPepperBallGoal, none));
				PostCommandGoal(CurrentSquadDeployPepperBallGoal);
			}
			else
			{
				ISwatOfficer(GetFirstOfficer()).GetOfficerSpeechManagerAction().TriggerPepperBallUnavailableSpeech();
			}
		}
		else
		{
			TriggerOtherTeamDoingBehaviorSpeech();
		}
	}
	return;
}

defaultproperties
{
	tickTimeUpdateRange=(Min=0.0000000,Max=0.0000000)
}