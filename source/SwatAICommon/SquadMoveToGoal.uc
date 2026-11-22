class SquadMoveToGoal extends SquadCommandGoal
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) Vector Destination;

overloaded function Construct(AI_Resource R, Pawn inCommandGiver, Vector inCommandOrigin, Vector inDestination)
{
	construct_AI_ResourcePawnVector(R, inCommandGiver, inCommandOrigin);
	Destination = inDestination;
	return;
}

defaultproperties
{
	bRepostElementGoalOnSubElementSquad=true
	goalName="SquadMoveTo"
}