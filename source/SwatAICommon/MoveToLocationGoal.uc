class MoveToLocationGoal extends MoveToGoalBase
	collapsecategories
	hidecategories(Object,InternalParameters);

var private Vector m_destination;

overloaded function Construct(AI_Resource R, int PRI, Vector Destination)
{
	construct_AI_ResourceInt(R, PRI);
	m_destination = Destination;
	return;
}

function Vector GetDestination()
{
	return m_destination;
	return;
}

defaultproperties
{
	goalName="MoveToLocation"
}