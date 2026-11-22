class SquadBreachBangAndClearAction extends SquadBreachThrowGrenadeAndClearAction
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

protected function TriggerThrowGrenadeMoveUpSpeech()
{
	ISwatOfficer(Thrower).GetOfficerSpeechManagerAction().TriggerMoveUpBangsSpeech();
	return;
}

protected function SetThrower()
{
	Thrower = GetThrowingOfficer(3);
	if(EqualEqual_ObjectObject(Thrower, none))
	{
		instantFail(11);
	}
	return;
}

protected latent function PreTargetDoorBreached()
{
	if(Not_PreBool(IsFirstOfficerThrower()))
	{
		PrepareToThrowGrenade(3, true);
	}
	return;
}

protected latent function PostTargetDoorBreached()
{
	if(IsFirstOfficerThrower())
	{
		PrepareToThrowGrenade(3, false);
	}
	ThrowGrenade();
	return;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.SquadBreachBangAndClearGoal'
}