class MoveToGoal extends OfficerCommandGoal
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) Actor Destination;

overloaded function Construct(AI_Resource R, Actor inDestination)
{
	construct_AI_ResourceInt(R, Priority);
	Destination = inDestination;
	return;
}

defaultproperties
{
	Priority=75
	goalName="MoveTo"
}