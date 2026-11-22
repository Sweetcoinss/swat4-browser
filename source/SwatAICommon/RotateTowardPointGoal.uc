class RotateTowardPointGoal extends AI_MovementGoal
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) Vector PointToRotateToward;

overloaded function Construct(AI_Resource R, int PRI, Vector inPoint)
{
	construct_AI_Resource(R);
	Priority = PRI;
	PointToRotateToward = inPoint;
	return;
}

defaultproperties
{
	goalName="RotateTowardPoint"
}