class DeployLessLethalShotgunGoal extends SwatCharacterGoal
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) Pawn TargetPawn;

overloaded function Construct(AI_Resource R, Pawn inTargetPawn)
{
	construct_AI_Resource(R);
	assert(NotEqual_ObjectObject(inTargetPawn, none));
	TargetPawn = inTargetPawn;
	return;
}

defaultproperties
{
	Priority=80
	goalName="DeployLessLethalShotgun"
}