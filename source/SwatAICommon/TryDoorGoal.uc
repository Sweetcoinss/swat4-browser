class TryDoorGoal extends OfficerCommandGoal
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) Door TargetDoor;
var(Parameters) bool bTriggerReportResultsSpeech;

overloaded function Construct(AI_Resource R)
{
	assert(false);
	return;
}

overloaded function Construct(AI_Resource R, Door inTargetDoor, bool bInTriggerReportResultsSpeech)
{
	construct_AI_Resource(R);
	assert(NotEqual_ObjectObject(inTargetDoor, none));
	TargetDoor = inTargetDoor;
	bTriggerReportResultsSpeech = bInTriggerReportResultsSpeech;
	return;
}

defaultproperties
{
	Priority=80
	goalName="TryDoor"
}