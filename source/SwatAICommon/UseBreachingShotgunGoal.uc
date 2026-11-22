class UseBreachingShotgunGoal extends OfficerCommandGoal
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) private Door TargetDoor;
var(Parameters) private NavigationPoint PostBreachPoint;

overloaded function Construct(AI_Resource R, int PRI)
{
	assert(false);
	return;
}

overloaded function Construct(AI_Resource R, Door inTargetDoor, optional NavigationPoint inPostBreachPoint)
{
	construct_AI_ResourceInt(R, Priority);
	assert(NotEqual_ObjectObject(inTargetDoor, none));
	TargetDoor = inTargetDoor;
	PostBreachPoint = inPostBreachPoint;
	return;
}

defaultproperties
{
	Priority=80
	goalName="UseBreachingShotgun"
}