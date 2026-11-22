class MoveToOpponentGoal extends MoveToActorGoal
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) bool bStopWhenSuccessful;

function SetStopWhenSuccessful(bool bInStopWhenSuccessful)
{
	bStopWhenSuccessful = bInStopWhenSuccessful;
	return;
}

defaultproperties
{
	goalName="MoveToOpponent"
}