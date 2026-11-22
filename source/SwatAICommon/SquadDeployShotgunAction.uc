class SquadDeployShotgunAction extends SquadStackUpAction
	collapsecategories
	hidecategories(Object,InternalParameters);

var private UseBreachingShotgunGoal CurrentUseBreachingShotgunGoal;

function cleanup()
{
	super.cleanup();
	if(NotEqual_ObjectObject(CurrentUseBreachingShotgunGoal, none))
	{
		CurrentUseBreachingShotgunGoal.Release();
		CurrentUseBreachingShotgunGoal = none;
	}
	return;
}

private function bool CanOfficerUseBreachingShotgun(Pawn Officer)
{
	local HandheldEquipment Equipment;
	local FiredWeapon Weapon;

	assert(Class'Engine.Pawn'.static.checkConscious(Officer));
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

latent function DeployShotgun()
{
	local Pawn Officer, BreachingOfficer;
	local int i, BreacherStackUpIndex;
	local StackupPoint BreacherStackUpPoint;

	assert(Greater_IntInt(OfficersInStackUpOrder.Length, 0));
	i = 0;
	J0x13:

	if(Less_IntInt(i, OfficersInStackUpOrder.Length))
	{
		Officer = OfficersInStackUpOrder[i];
		if(CanOfficerUseBreachingShotgun(Officer))
		{
			BreacherStackUpIndex = i;
			BreachingOfficer = Officer;
			// [Explicit Break]
			goto J0x65;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x13;
	}
	J0x65:

	if(NotEqual_ObjectObject(BreachingOfficer, none))
	{
		MoveUpShotgunBreacher(BreachingOfficer);
		BreacherStackUpPoint = StackUpPoints[BreacherStackUpIndex];
		assert(NotEqual_ObjectObject(BreacherStackUpPoint, none));
		CurrentUseBreachingShotgunGoal = Class'SwatAICommon.UseBreachingShotgunGoal'.static.Allocate(self).;
		construct_AI_ResourceDoorNavigationPoint(AI_Resource(BreachingOfficer.CharacterAI), TargetDoor, BreacherStackUpPoint);
		assert(NotEqual_ObjectObject(CurrentUseBreachingShotgunGoal, none));
		CurrentUseBreachingShotgunGoal.AddRef();
		CurrentUseBreachingShotgunGoal.postGoal(self);
		waitForGoal(CurrentUseBreachingShotgunGoal);
		CurrentUseBreachingShotgunGoal.unPostGoal(self);
		CurrentUseBreachingShotgunGoal.Release();
		CurrentUseBreachingShotgunGoal = none;
	}
	return;
}

state Running
{Begin:

	StackUpSquad(true);
	DeployShotgun();
	succeed();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.SquadDeployShotgunGoal'
}