class SquadBreachAndClearAction extends SquadMoveAndClearAction implements IInterestedInDetonatorEquipping
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

var private UseBreachingShotgunGoal CurrentUseBreachingShotgunGoal;
var private UseBreachingChargeGoal CurrentUseBreachingChargeGoal;

function cleanup()
{
	super.cleanup();
	if(NotEqual_ObjectObject(CurrentUseBreachingShotgunGoal, none))
	{
		CurrentUseBreachingShotgunGoal.Release();
		CurrentUseBreachingShotgunGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentUseBreachingChargeGoal, none))
	{
		CurrentUseBreachingChargeGoal.Release();
		CurrentUseBreachingChargeGoal = none;
	}
	return;
}

function goalAchievedCB(AI_Goal Goal, AI_Action Child)
{
	super.goalAchievedCB(Goal, Child);
	if(EqualEqual_ObjectObject(Goal, CurrentUseBreachingShotgunGoal))
	{
		CurrentUseBreachingShotgunGoal.unPostGoal(self);
		CurrentUseBreachingShotgunGoal.Release();
		CurrentUseBreachingShotgunGoal = none;
	}
	else
	{
		if(EqualEqual_ObjectObject(Goal, CurrentUseBreachingChargeGoal))
		{
			CurrentUseBreachingChargeGoal.unPostGoal(self);
			CurrentUseBreachingChargeGoal.Release();
			CurrentUseBreachingChargeGoal = none;
		}
	}
	return;
}

function NotifyDetonatorEquipping()
{
	if(AndAnd_BoolBool(IsIdle(), NotEqual_ObjectObject(Breacher, Thrower)))
	{
		runAction();
	}
	return;
}

protected function bool ShouldStackUpIfOfficersInRoomToClear()
{
	return true;
	return;
}

protected function SetBreacher()
{
	Breacher = GetFirstOfficer();
	return;
}

private function bool CanOfficerBreachWithShotgun(Pawn Officer)
{
	local HandheldEquipment Equipment;
	local FiredWeapon Weapon;

	Equipment = ISwatOfficer(Officer).GetItemAtSlot(7);
	if(AndAnd_BoolBool(NotEqual_ObjectObject(Equipment, none), Equipment.IsA('BreachingShotgun')))
	{
		Weapon = FiredWeapon(Equipment);
		assert(NotEqual_ObjectObject(Weapon, none));
		if(OrOr_BoolBool(Not_PreBool(Weapon.NeedsReload()), Weapon.CanReload()))
		{
			return true;
		}
	}
	return false;
	return;
}

latent function UseBreachingShotgun()
{
	assert(NotEqual_ObjectObject(Breacher, none));
	ISwatDoor(TargetDoor).RegisterInterestedInDoorOpening(self);
	CurrentUseBreachingShotgunGoal = Class'SwatAICommon.UseBreachingShotgunGoal'.static.Allocate(self).;
	construct_AI_ResourceDoorNavigationPoint(AI_Resource(Breacher.CharacterAI), TargetDoor);
	assert(NotEqual_ObjectObject(CurrentUseBreachingShotgunGoal, none));
	CurrentUseBreachingShotgunGoal.AddRef();
	CurrentUseBreachingShotgunGoal.postGoal(self);
	if(NotEqual_ObjectObject(GetSecondOfficer(), none))
	{
		Pause();
	}
	else
	{
		waitForGoal(CurrentUseBreachingShotgunGoal);
	}
	CurrentUseBreachingShotgunGoal.unPostGoal(self);
	CurrentUseBreachingShotgunGoal.Release();
	CurrentUseBreachingShotgunGoal = none;
	return;
}

private function bool CanOfficerBreachWithC2(Pawn Officer)
{
	local ISwatDoor SwatDoorTarget;
	local bool bIsChargeAlreadyPlacedOnDoor;
	local HandheldEquipment Equipment;

	assert(Class'Engine.Pawn'.static.checkConscious(Officer));
	SwatDoorTarget = ISwatDoor(TargetDoor);
	assert(NotEqual_ObjectObject(SwatDoorTarget, none));
	if(SwatDoorTarget.PointIsToMyLeft(CommandOrigin))
	{
		bIsChargeAlreadyPlacedOnDoor = SwatDoorTarget.IsChargePlacedOnLeft();
	}
	else
	{
		bIsChargeAlreadyPlacedOnDoor = SwatDoorTarget.IsChargePlacedOnRight();
	}
	if(bIsChargeAlreadyPlacedOnDoor)
	{
		return NotEqual_ObjectObject(ISwatOfficer(Officer).GetItemAtSlot(12), none);
	}
	else
	{
		Equipment = ISwatOfficer(Officer).GetItemAtSlot(7);
		return AndAnd_BoolBool(NotEqual_ObjectObject(Equipment, none), Equipment.IsA('C2Charge'));
	}
	return;
}

latent function PlaceAndUseBreachingCharge()
{
	local NavigationPoint SafeLocation;

	assert(NotEqual_ObjectObject(Breacher, none));
	ISwatDoor(TargetDoor).RegisterInterestedInDoorOpening(self);
	SafeLocation = StackUpPoints[0];
	assert(NotEqual_ObjectObject(SafeLocation, none));
	CurrentUseBreachingChargeGoal = Class'SwatAICommon.UseBreachingChargeGoal'.static.Allocate(self).;
	construct_AI_ResourceDoorNavigationPoint(AI_Resource(Breacher.CharacterAI), TargetDoor, SafeLocation);
	assert(NotEqual_ObjectObject(CurrentUseBreachingChargeGoal, none));
	CurrentUseBreachingChargeGoal.AddRef();
	CurrentUseBreachingChargeGoal.SetInterestedInDetonatorEquippingClient(self);
	CurrentUseBreachingChargeGoal.postGoal(self);
	if(NotEqual_ObjectObject(Thrower, Breacher))
	{
		Pause();
		PreTargetDoorBreached();
		J0xC7:

		if(AndAnd_BoolBool(TargetDoor.IsClosed(), Not_PreBool(ISwatDoor(TargetDoor).IsBroken())))
		{
			yield();
			// [Loop Continue]
			goto J0xC7;
		}
	}
	else
	{
		waitForGoal(CurrentUseBreachingChargeGoal);
		CurrentUseBreachingChargeGoal.unPostGoal(self);
		CurrentUseBreachingChargeGoal.Release();
		CurrentUseBreachingChargeGoal = none;
	}
	return;
}

latent function PrepareToMoveSquad()
{
	local ISwatDoor SwatDoorTarget;

	super.PrepareToMoveSquad();
	SwatDoorTarget = ISwatDoor(TargetDoor);
	assert(NotEqual_ObjectObject(SwatDoorTarget, none));
	J0x21:

	if(AndAnd_BoolBool(SwatDoorTarget.IsLocked(), Not_PreBool(SwatDoorTarget.IsBroken())))
	{
		if(CanOfficerBreachWithShotgun(Breacher))
		{
			PreTargetDoorBreached();
			UseBreachingShotgun();
			PostTargetDoorBreached();
		}
		else
		{
			if(CanOfficerBreachWithC2(Breacher))
			{
				PlaceAndUseBreachingCharge();
				PostTargetDoorBreached();
			}
			else
			{
				assert(DoesAnOfficerHaveUsableEquipment(8));
				PreTargetDoorBreached();
				PickLock(NotEqual_ObjectObject(GetSecondOfficer(), none));
				if(NotEqual_ObjectObject(Thrower, none))
				{
					OpenDoorForThrowingGrenade();
				}
				PostTargetDoorBreached();
			}
		}
		yield();
		// [Loop Continue]
		goto J0x21;
	}
	return;
}

protected latent function PreTargetDoorBreached()
{
	return;
}

protected latent function PostTargetDoorBreached()
{
	return;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.SquadBreachAndClearGoal'
}