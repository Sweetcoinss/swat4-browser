class DisableTargetGoal extends SwatCharacterGoal
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) Actor Target;
var(Parameters) Vector DisableFromPoint;
var(Parameters) bool bUseMoveToThreshold;

overloaded function Construct(AI_Resource R, Actor inTarget, Vector inDisableFromPoint, bool inUseMoveToThreshold)
{
	construct_AI_Resource(R);
	assert(NotEqual_ObjectObject(inTarget, none));
	Target = inTarget;
	DisableFromPoint = inDisableFromPoint;
	bUseMoveToThreshold = inUseMoveToThreshold;
	return;
}

defaultproperties
{
	Priority=80
	goalName="DisableTarget"
}