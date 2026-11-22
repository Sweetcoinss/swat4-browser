class MoveToDoorGoal extends MoveToGoalBase
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) Door TargetDoor;
var(Parameters) bool bPreferSides;
var ISwatAI.AIDoorUsageSide DoorUsageSide;
var Rotator DoorUsageRotation;

overloaded function Construct(AI_Resource R, int PRI)
{
	assert(false);
	return;
}

overloaded function Construct(AI_Resource R, Door inTargetDoor)
{
	construct_AI_ResourceInt(R, Priority);
	assert(NotEqual_ObjectObject(inTargetDoor, none));
	TargetDoor = inTargetDoor;
	return;
}

overloaded function Construct(AI_Resource R, int PRI, Door inTargetDoor)
{
	construct_AI_ResourceInt(R, PRI);
	assert(NotEqual_ObjectObject(inTargetDoor, none));
	TargetDoor = inTargetDoor;
	return;
}

function Vector GetDestination()
{
	local Vector Destination;
	local Rotator DummyRotation;
	local ISwatDoor SwatDoorTarget;

	SwatDoorTarget = ISwatDoor(TargetDoor);
	assert(NotEqual_ObjectObject(SwatDoorTarget, none));
	SwatDoorTarget.GetOpenPositions(AI_MovementResource(resource).m_pawn, false, Destination, DummyRotation);
	return Destination;
	return;
}

function SetPreferSides()
{
	bPreferSides = true;
	return;
}

defaultproperties
{
	Priority=75
	goalName="MoveToDoor"
}