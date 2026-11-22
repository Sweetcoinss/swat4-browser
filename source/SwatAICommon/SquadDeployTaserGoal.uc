class SquadDeployTaserGoal extends SquadCommandGoal
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) Pawn TargetPawn;

overloaded function Construct(AI_Resource R, Pawn inCommandGiver, Vector inCommandOrigin, Pawn inTargetPawn)
{
	construct_AI_ResourcePawnVector(R, inCommandGiver, inCommandOrigin);
	assert(NotEqual_ObjectObject(inTargetPawn, none));
	TargetPawn = inTargetPawn;
	return;
}

function bool IsInteractingWith(Actor TestActor)
{
	return EqualEqual_ObjectObject(TargetPawn, TestActor);
	return;
}

defaultproperties
{
	bIsCharacterInteractionCommandGoal=true
	goalName="SquadDeployTaser"
}