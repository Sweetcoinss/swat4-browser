class InitialReactionGoal extends SwatCharacterGoal
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) Pawn StimuliPawn;

overloaded function Construct(AI_Resource R, Pawn inStimuliPawn)
{
	construct_AI_Resource(R);
	assert(NotEqual_ObjectObject(inStimuliPawn, none));
	StimuliPawn = inStimuliPawn;
	return;
}

defaultproperties
{
	Priority=60
	goalName="InitialReaction"
}