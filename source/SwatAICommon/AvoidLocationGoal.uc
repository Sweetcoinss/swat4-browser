class AvoidLocationGoal extends SwatCharacterGoal
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) Vector AvoidLocation;

overloaded function Construct(AI_Resource R)
{
	assert(false);
	return;
}

overloaded function Construct(AI_Resource R, Vector inAvoidLocation)
{
	construct_AI_Resource(R);
	AvoidLocation = inAvoidLocation;
	return;
}

overloaded function Construct(AI_Resource R, int PRI, Vector inAvoidLocation)
{
	construct_AI_ResourceInt(R, PRI);
	AvoidLocation = inAvoidLocation;
	return;
}

defaultproperties
{
	Priority=89
	goalName="AvoidLocation"
}