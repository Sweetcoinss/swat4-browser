class ThrowGrenadeGoal extends OfficerCommandGoal
	collapsecategories
	hidecategories(Object,InternalParameters);

const kBreachThrowGrenadeGoalPriority = 86;

var(Parameters) Vector TargetLocation;
var(Parameters) Vector ThrowFromLocation;
var(Parameters) HandheldEquipment.EquipmentSlot GrenadeSlot;
var(Parameters) ISwatAI.AIThrowSide ThrowSide;
var(Parameters) Rotator ThrowRotation;
var(Parameters) bool ThrowRotationOverridden;
var(Parameters) bool bWaitToThrowGrenade;
var(Parameters) IInterestedGrenadeThrowing ThrowClient;

overloaded function Construct(AI_Resource R, int PRI)
{
	assert(false);
	return;
}

overloaded function Construct(AI_Resource R, Vector inTargetLocation, Vector inThrowFromLocation, HandheldEquipment.EquipmentSlot inGrenadeSlot, optional bool bIsBreachingThrow)
{
	if(bIsBreachingThrow)
	{
		Priority = 86;
	}
	construct_AI_ResourceInt(R, Priority);
	TargetLocation = inTargetLocation;
	ThrowFromLocation = inThrowFromLocation;
	GrenadeSlot = inGrenadeSlot;
	return;
}

function SetThrowRotation(Rotator inThrowRotation)
{
	ThrowRotation = inThrowRotation;
	ThrowRotationOverridden = true;
	return;
}

function SetThrowSide(ISwatAI.AIThrowSide inThrowSide)
{
	ThrowSide = inThrowSide;
	return;
}

function SetWaitToThrowGrenade(bool inWaitToThrowGrenade)
{
	bWaitToThrowGrenade = inWaitToThrowGrenade;
	return;
}

function RegisterForGrenadeThrowing(IInterestedGrenadeThrowing inThrowClient)
{
	ThrowClient = inThrowClient;
	return;
}

function NotifyThrowGrenade()
{
	assert(EqualEqual_BoolBool(bWaitToThrowGrenade, true));
	if(NotEqual_ObjectObject(achievingAction, none))
	{
		ThrowGrenadeAction(achievingAction).NotifyThrowGrenade();
	}
	return;
}

defaultproperties
{
	Priority=80
	goalName="ThrowGrenade"
}