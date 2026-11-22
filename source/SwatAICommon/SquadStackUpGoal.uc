class SquadStackUpGoal extends SquadCommandGoal
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) Door TargetDoor;
var(Parameters) bool bTriggerCouldntBreachLockedSpeech;

overloaded function Construct(AI_Resource R, Pawn inCommandGiver, Vector inCommandOrigin, Door inTargetDoor, optional bool bInTriggerCouldntBreachLockedSpeech)
{
	construct_AI_ResourcePawnVector(R, inCommandGiver, inCommandOrigin);
	assert(NotEqual_ObjectObject(inTargetDoor, none));
	TargetDoor = inTargetDoor;
	bTriggerCouldntBreachLockedSpeech = bInTriggerCouldntBreachLockedSpeech;
	return;
}

function Door GetDoorBeingUsed()
{
	return TargetDoor;
	return;
}

defaultproperties
{
	goalName="SquadStackUp"
}