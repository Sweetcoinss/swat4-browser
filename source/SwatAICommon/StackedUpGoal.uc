class StackedUpGoal extends SwatCharacterGoal
	collapsecategories
	hidecategories(Object,InternalParameters);

var private StackupPoint StackupPoint;

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

function StackupPoint GetStackUpPoint()
{
	return StackupPoint;
	return;
}

defaultproperties
{
	Priority=39
	goalName="StackedUp"
}