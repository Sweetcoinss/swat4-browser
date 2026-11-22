class HostageReactionToOfficersGoal extends SwatCharacterGoal
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) Pawn Officer;
var(Parameters) bool bWasInDanger;

overloaded function Construct(AI_Resource R, Pawn inOfficer, bool inWasInDanger)
{
	construct_AI_ResourceInt(R, Priority);
	assert(NotEqual_ObjectObject(inOfficer, none));
	Officer = inOfficer;
	bWasInDanger = inWasInDanger;
	return;
}

defaultproperties
{
	Priority=75
	goalName="HostageReactionToOfficers"
}