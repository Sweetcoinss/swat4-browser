class MirrorDoorGoal extends OfficerCommandGoal
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) Door TargetDoor;

overloaded function Construct(AI_Resource R)
{
	assert(false);
	return;
}

overloaded function Construct(AI_Resource R, Door inTargetDoor)
{
	construct_AI_Resource(R);
	assert(NotEqual_ObjectObject(inTargetDoor, none));
	TargetDoor = inTargetDoor;
	return;
}

defaultproperties
{
	Priority=80
	goalName="MirrorDoor"
}