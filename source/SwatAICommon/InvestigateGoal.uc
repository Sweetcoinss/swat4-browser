class InvestigateGoal extends SwatCharacterGoal
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) Vector InvestigateLocation;
var(Parameters) bool bShouldWalkToInvestigate;

overloaded function Construct(AI_Resource R, Vector inInvestigateLocation, bool bInShouldWalkToInvestigate)
{
	construct_AI_ResourceInt(R, Priority);
	InvestigateLocation = inInvestigateLocation;
	bShouldWalkToInvestigate = bInShouldWalkToInvestigate;
	return;
}

defaultproperties
{
	Priority=60
	goalName="Investigate"
}