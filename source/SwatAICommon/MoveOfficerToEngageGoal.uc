class MoveOfficerToEngageGoal extends MoveToOpponentGoal
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) Pawn Opponent;

overloaded function Construct(AI_Resource R, int PRI, Pawn inOpponent)
{
	construct_AI_ResourceInt(R, PRI);
	AssertWithDescription(NotEqual_ObjectObject(inOpponent, none), "MoveOfficerToEngageGoal::construct - Opponent passed in is None!");
	Opponent = inOpponent;
	return;
}

defaultproperties
{
	goalName="MoveOfficerToEngage"
}