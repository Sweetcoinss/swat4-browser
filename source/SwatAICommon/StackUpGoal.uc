class StackUpGoal extends OfficerCommandGoal
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) StackupPoint StackupPoint;
var(Parameters) bool bRunToStackupPoint;

overloaded function Construct(AI_Resource R)
{
	assert(false);
	return;
}

overloaded function Construct(AI_Resource R, StackupPoint inStackupPoint)
{
	construct_AI_Resource(R);
	assert(NotEqual_ObjectObject(inStackupPoint, none));
	StackupPoint = inStackupPoint;
	return;
}

function SetStackUpPoint(StackupPoint NewStackUpPoint)
{
	assert(NotEqual_ObjectObject(NewStackUpPoint, none));
	assert(NotEqual_ObjectObject(achievingAction, none));
	StackUpAction(achievingAction).SetStackUpPoint(NewStackUpPoint);
	return;
}

function SetRunToStackupPoint(bool inRunToStackupPoint)
{
	bRunToStackupPoint = inRunToStackupPoint;
	return;
}

defaultproperties
{
	Priority=75
	goalName="StackUp"
}