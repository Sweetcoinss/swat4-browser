class RotateTowardActorGoal extends AI_MovementGoal
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) Actor ActorToRotateToward;

overloaded function Construct(AI_Resource R, int PRI, Actor inActor)
{
	construct_AI_Resource(R);
	Priority = PRI;
	assert(NotEqual_ObjectObject(inActor, none));
	ActorToRotateToward = inActor;
	return;
}

defaultproperties
{
	goalName="RotateTowardActor"
}