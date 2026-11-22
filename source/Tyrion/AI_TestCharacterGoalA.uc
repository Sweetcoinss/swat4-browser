class AI_TestCharacterGoalA extends AI_CharacterGoal
	editinlinenew
	collapsecategories
	hidecategories(Object,InternalParameters);

var int constraint1;

overloaded function Construct(AI_Resource R, int PRI, int const1)
{
	Priority = PRI;
	constraint1 = const1;
	construct_AI_Resource(R);
	return;
}
