class RotateTowardRotationGoal extends AI_MovementGoal
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) Rotator DesiredRotation;

overloaded function Construct(AI_Resource R, int PRI, Rotator inDesiredRotation)
{
	construct_AI_Resource(R);
	Priority = PRI;
	DesiredRotation = inDesiredRotation;
	return;
}

defaultproperties
{
	goalName="RotateTowardRotation"
}