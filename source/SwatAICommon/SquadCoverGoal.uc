class SquadCoverGoal extends SquadCommandGoal
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) Vector coverLocation;

overloaded function Construct(AI_Resource R, Pawn inCommandGiver, Vector inCommandOrigin, Vector inCoverLocation)
{
	construct_AI_ResourcePawnVector(R, inCommandGiver, inCommandOrigin);
	coverLocation = inCoverLocation;
	return;
}

defaultproperties
{
	bRepostElementGoalOnSubElementSquad=true
	goalName="SquadCover"
}