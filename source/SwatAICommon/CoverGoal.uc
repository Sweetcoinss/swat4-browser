class CoverGoal extends SwatCharacterGoal
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) Vector coverLocation;
var(Parameters) Vector CoverFromLocation;
var(Parameters) Vector CommandOrigin;
var(Parameters) bool bShouldAimAround;

overloaded function Construct(AI_Resource R)
{
	assert(false);
	return;
}

overloaded function Construct(AI_Resource R, Vector inCoverLocation, Vector inCoverCommandOrigin, Vector inCoverFromLocation, bool bInShouldAimAround)
{
	construct_AI_Resource(R);
	coverLocation = inCoverLocation;
	CommandOrigin = inCoverCommandOrigin;
	CoverFromLocation = inCoverFromLocation;
	bShouldAimAround = bInShouldAimAround;
	return;
}

defaultproperties
{
	Priority=60
	goalName="Cover"
}