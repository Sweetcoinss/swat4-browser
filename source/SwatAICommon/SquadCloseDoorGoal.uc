class SquadCloseDoorGoal extends SquadCommandGoal
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) Door TargetDoor;

overloaded function Construct(AI_Resource R, Pawn inCommandGiver, Vector inCommandOrigin, Door inTargetDoor)
{
	construct_AI_ResourcePawnVector(R, inCommandGiver, inCommandOrigin);
	assert(NotEqual_ObjectObject(inTargetDoor, none));
	TargetDoor = inTargetDoor;
	return;
}

function Door GetDoorBeingUsed()
{
	return TargetDoor;
	return;
}

defaultproperties
{
	goalName="SquadCloseDoor"
}