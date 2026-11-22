class UseGrenadeGoal extends SwatWeaponGoal
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) Vector vTargetLocation;
var(Parameters) HandheldEquipment.EquipmentSlot GrenadeSlot;
var(Parameters) bool bWaitToThrowGrenade;
var(Parameters) IInterestedGrenadeThrowing ThrowClient;

overloaded function Construct(AI_Resource R)
{
	assert(false);
	return;
}

overloaded function Construct(AI_Resource R, HandheldEquipment.EquipmentSlot inGrenadeSlot, Vector inTargetLocation)
{
	construct_AI_ResourceInt(R, Priority);
	vTargetLocation = inTargetLocation;
	GrenadeSlot = inGrenadeSlot;
	return;
}

function RegisterForGrenadeThrowing(IInterestedGrenadeThrowing inThrowClient)
{
	ThrowClient = inThrowClient;
	return;
}

function SetWaitToThrowGrenade(bool inWaitToThrowGrenade)
{
	bWaitToThrowGrenade = inWaitToThrowGrenade;
	return;
}

function NotifyThrowGrenade()
{
	assert(EqualEqual_BoolBool(bWaitToThrowGrenade, true));
	if(NotEqual_ObjectObject(achievingAction, none))
	{
		if(achievingAction.IsIdle())
		{
			achievingAction.runAction();
		}
		else
		{
			UseGrenadeAction(achievingAction).SetContinueToThrowGrenade();
		}
	}
	return;
}

defaultproperties
{
	Priority=80
	goalName="UseGrenade"
}