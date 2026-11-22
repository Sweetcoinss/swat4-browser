class MirrorCornerGoal extends OfficerCommandGoal
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) Actor TargetMirrorPoint;

overloaded function Construct(AI_Resource R)
{
	assert(false);
	return;
}

overloaded function Construct(AI_Resource R, Actor inTargetMirrorPoint)
{
	construct_AI_Resource(R);
	assert(NotEqual_ObjectObject(inTargetMirrorPoint, none));
	TargetMirrorPoint = inTargetMirrorPoint;
	return;
}

defaultproperties
{
	Priority=80
	goalName="MirrorCorner"
}