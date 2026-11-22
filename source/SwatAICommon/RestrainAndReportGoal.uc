class RestrainAndReportGoal extends SwatCharacterGoal
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) Pawn CompliantTarget;

overloaded function Construct(AI_Resource R, Pawn inCompliantTarget)
{
	construct_AI_Resource(R);
	assert(NotEqual_ObjectObject(inCompliantTarget, none));
	CompliantTarget = inCompliantTarget;
	return;
}

defaultproperties
{
	Priority=80
	goalName="RestrainAndReport"
}