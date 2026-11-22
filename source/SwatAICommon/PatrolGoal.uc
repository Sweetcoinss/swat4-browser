class PatrolGoal extends SwatCharacterGoal
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) PatrolList Patrol;

overloaded function Construct(AI_Resource R, PatrolList inPatrol)
{
	construct_AI_ResourceInt(R, Priority);
	assert(NotEqual_ObjectObject(inPatrol, none));
	Patrol = inPatrol;
	return;
}

defaultproperties
{
	Priority=35
	goalName="Patrol"
	bTerminateIfStolen=true
}