class AI_TestMovementB extends AI_MovementAction
	editinlinenew
	collapsecategories
	hidecategories(Object,InternalParameters);

state Running
{Begin:

	Log(At_StrStr(string(self.Name), "started. Sleeping for 5 seconds."));
	Sleep(5.0000000);
	Log(At_StrStr(string(self.Name), "will terminate now."));
	succeed();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'Tyrion.AI_TestInactiveAchievableGoal'
}