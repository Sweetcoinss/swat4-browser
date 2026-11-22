class PickLockGoal extends OfficerCommandGoal
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) Door TargetDoor;
var(Parameters) NavigationPoint PostPickLockDestination;

overloaded function Construct(AI_Resource R, int PRI)
{
	assert(false);
	return;
}

overloaded function Construct(AI_Resource R, Door inTargetDoor, NavigationPoint inPostPickLockDestination)
{
	construct_AI_ResourceInt(R, Priority);
	assert(NotEqual_ObjectObject(inTargetDoor, none));
	TargetDoor = inTargetDoor;
	PostPickLockDestination = inPostPickLockDestination;
	return;
}

defaultproperties
{
	Priority=80
	goalName="PickLock"
}