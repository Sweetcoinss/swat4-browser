class SquadDisableTargetGoal extends SquadCommandGoal
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) Actor Target;

overloaded function Construct(AI_Resource R, Pawn inCommandGiver, Vector inCommandOrigin, Actor inTarget)
{
	construct_AI_ResourcePawnVector(R, inCommandGiver, inCommandOrigin);
	assert(NotEqual_ObjectObject(inTarget, none));
	Target = inTarget;
	return;
}

function bool IsInteractingWith(Actor TestActor)
{
	return EqualEqual_ObjectObject(Target, TestActor);
	return;
}

defaultproperties
{
	goalName="SquadDisableTarget"
}