class AI_DummyHead extends AI_HeadAction
	editinlinenew
	collapsecategories
	hidecategories(Object,InternalParameters);

state Running
{Begin:

	if(resource.Pawn().logTyrion)
	{
		Log(Concat_StrStr(string(self), " started."));
	}
	sleepForever();
	succeed();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'Tyrion.AI_DummyHeadGoal'
}