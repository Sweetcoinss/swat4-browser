class AimAtPointGoal extends SwatWeaponGoal
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) Vector Point;

overloaded function Construct(AI_Resource R)
{
	assert(false);
	return;
}

overloaded function Construct(AI_Resource R, Vector inPoint)
{
	construct_AI_ResourceInt(R, Priority);
	Point = inPoint;
	return;
}

overloaded function Construct(AI_Resource R, int PRI, Vector inPoint)
{
	construct_AI_ResourceInt(R, PRI);
	Point = inPoint;
	return;
}

defaultproperties
{
	Priority=75
	goalName="AimAtPoint"
}