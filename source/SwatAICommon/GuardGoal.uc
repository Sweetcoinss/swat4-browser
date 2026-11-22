class GuardGoal extends SwatCharacterGoal
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) Actor Target;

overloaded function Construct(AI_Resource R)
{
	assert(false);
	return;
}

overloaded function Construct(AI_Resource R, Actor inTarget)
{
	construct_AI_Resource(R);
	assert(NotEqual_ObjectObject(inTarget, none));
	Target = inTarget;
	return;
}

defaultproperties
{
	Priority=60
	goalName="Guard"
}