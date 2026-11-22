class MoveAndClearGoal extends OfficerCommandGoal
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) ClearPoint TargetClearPoint;
var(Parameters) Vector CommandOrigin;
var(Parameters) bool bShouldAnnounceClear;

overloaded function Construct(AI_Resource R)
{
	assert(false);
	return;
}

overloaded function Construct(AI_Resource R, ClearPoint inClearPoint, Vector inCommandOrigin, bool bInShouldAnnounceClear)
{
	construct_AI_Resource(R);
	assert(NotEqual_ObjectObject(inClearPoint, none));
	TargetClearPoint = inClearPoint;
	bShouldAnnounceClear = bInShouldAnnounceClear;
	return;
}

defaultproperties
{
	Priority=90
	goalName="MoveAndClear"
}