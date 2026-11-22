class AI_TestWeaponGoalA extends AI_WeaponGoal
	editinlinenew
	collapsecategories
	hidecategories(Object,InternalParameters);

overloaded function Construct(AI_Resource R, int PRI)
{
	construct_AI_Resource(R);
	Priority = PRI;
	return;
}
