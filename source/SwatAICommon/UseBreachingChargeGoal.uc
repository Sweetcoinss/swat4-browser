class UseBreachingChargeGoal extends OfficerCommandGoal
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) private Door TargetDoor;
var(Parameters) private NavigationPoint SafeLocation;
var(Parameters) IInterestedInDetonatorEquipping InterestedInDetonatorEquippingClient;

overloaded function Construct(AI_Resource R, int PRI)
{
	assert(false);
	return;
}

overloaded function Construct(AI_Resource R, Door inTargetDoor, NavigationPoint inSafeLocation)
{
	construct_AI_ResourceInt(R, Priority);
	assert(NotEqual_ObjectObject(inTargetDoor, none));
	TargetDoor = inTargetDoor;
	SafeLocation = inSafeLocation;
	return;
}

function SetInterestedInDetonatorEquippingClient(IInterestedInDetonatorEquipping inClient)
{
	assert(NotEqual_ObjectObject(inClient, none));
	InterestedInDetonatorEquippingClient = inClient;
	return;
}

defaultproperties
{
	Priority=60
	goalName="UseBreachingCharge"
}