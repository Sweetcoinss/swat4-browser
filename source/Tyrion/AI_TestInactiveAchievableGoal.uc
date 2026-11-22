class AI_TestInactiveAchievableGoal extends AI_MovementGoal
	editinlinenew
	collapsecategories
	hidecategories(Object,InternalParameters);

overloaded function Construct(AI_Resource R, int PRI)
{
	construct_AI_Resource(R);
	Priority = PRI;
	return;
}

function Init(AI_Resource R)
{
	super(AI_Goal).Init(R);
	activationSentinel.activateSentinel(self, Class'Tyrion.AI_TestSentinelA', R,,, self);
	return;
}

function setUpDeactivationSentinel()
{
	deactivationSentinel.activateSentinel(self, Class'Tyrion.AI_TestSentinelB', resource,,, none);
	return;
}

defaultproperties
{
	bInactive=true
}