class SquadExamineAndReportGoal extends SquadCommandGoal
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) Actor ExamineTarget;

overloaded function Construct(AI_Resource R, Pawn inCommandGiver, Vector inCommandOrigin, Actor inExamineTarget)
{
	construct_AI_ResourcePawnVector(R, inCommandGiver, inCommandOrigin);
	assert(NotEqual_ObjectObject(inExamineTarget, none));
	ExamineTarget = inExamineTarget;
	return;
}

defaultproperties
{
	goalName="SquadExamineAndReport"
}