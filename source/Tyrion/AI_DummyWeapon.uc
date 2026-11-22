class AI_DummyWeapon extends AI_WeaponAction
	editinlinenew
	collapsecategories
	hidecategories(Object,InternalParameters);

state Running
{Begin:

	if(resource.Pawn().logTyrion)
	{
		Log(At_StrStr(string(self.Name), "started."));
	}
	Pause();
	succeed();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'Tyrion.AI_DummyWeaponGoal'
}