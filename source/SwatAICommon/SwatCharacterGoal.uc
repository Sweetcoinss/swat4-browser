class SwatCharacterGoal extends AI_CharacterGoal
	native
	collapsecategories
	hidecategories(Object,InternalParameters);

overloaded function Construct(AI_Resource R, int PRI)
{
	construct_AI_Resource(R);
	Priority = PRI;
	return;
}
