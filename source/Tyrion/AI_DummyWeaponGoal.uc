class AI_DummyWeaponGoal extends AI_WeaponGoal
	editinlinenew
	collapsecategories
	hidecategories(Object,InternalParameters);

overloaded function Construct(AI_Resource R, int PRI)
{
	construct_AI_Resource(R);
	Priority = PRI;
	return;
}

defaultproperties
{
	goalName="AI_DummyWeapon"
}