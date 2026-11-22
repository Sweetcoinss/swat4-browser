class MoveToActorGoal extends MoveToGoalBase
	collapsecategories
	hidecategories(Object,InternalParameters);

var private Actor m_destination;

overloaded function Construct(AI_Resource R, int PRI, Actor Destination)
{
	construct_AI_ResourceInt(R, PRI);
	SetDestinationActor(Destination);
	return;
}

function Actor GetDestinationActor()
{
	return m_destination;
	return;
}

function Vector GetDestination()
{
	return m_destination.Location;
	return;
}

function SetDestinationActor(Actor Destination)
{
	AssertWithDescription(NotEqual_ObjectObject(Destination, none), "MoveToActorGoal::SetDestinationActor - destination passed in is None!");
	m_destination = Destination;
	return;
}

defaultproperties
{
	goalName="MoveToActor"
}