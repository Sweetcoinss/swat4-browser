class AI_TestWeaponA extends AI_WeaponAction
	editinlinenew
	collapsecategories
	hidecategories(Object,InternalParameters);

state Running
{Begin:

	Log(At_StrStr(string(self.Name), "started. Sleeping for 15 seconds."));
	Sleep(15.0000000);
	Log(At_StrStr(string(self.Name), "will terminate now."));
	succeed();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'Tyrion.AI_TestWeaponGoalA'
}