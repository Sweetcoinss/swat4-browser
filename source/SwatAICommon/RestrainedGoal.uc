class RestrainedGoal extends SwatCharacterGoal
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) Pawn Restrainer;

overloaded function Construct(AI_Resource R, Pawn inRestrainer)
{
	construct_AI_Resource(R);
	assert(NotEqual_ObjectObject(inRestrainer, none));
	Restrainer = inRestrainer;
	return;
}

defaultproperties
{
	Priority=98
	goalName="Restrained"
	bPermanent=true
}