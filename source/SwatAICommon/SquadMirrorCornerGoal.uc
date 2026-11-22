class SquadMirrorCornerGoal extends SquadCommandGoal
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) Actor TargetMirrorPoint;

overloaded function Construct(AI_Resource R, Pawn inCommandGiver, Vector inCommandOrigin, Actor inTargetMirrorPoint)
{
	construct_AI_ResourcePawnVector(R, inCommandGiver, inCommandOrigin);
	assert(NotEqual_ObjectObject(inTargetMirrorPoint, none));
	TargetMirrorPoint = inTargetMirrorPoint;
	return;
}

function bool IsInteractingWith(Actor TestActor)
{
	return EqualEqual_ObjectObject(TargetMirrorPoint, TestActor);
	return;
}

defaultproperties
{
	goalName="SquadMirrorCorner"
}