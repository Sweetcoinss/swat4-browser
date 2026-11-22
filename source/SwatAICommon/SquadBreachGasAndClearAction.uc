class SquadBreachGasAndClearAction extends SquadBreachThrowGrenadeAndClearAction
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

protected function TriggerThrowGrenadeMoveUpSpeech()
{
	ISwatOfficer(Thrower).GetOfficerSpeechManagerAction().TriggerMoveUpGasSpeech();
	return;
}

protected function SetThrower()
{
	Thrower = GetThrowingOfficer(4);
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
		PrepareToThrowGrenade(4, true);
	}
	return;
}

protected latent function PostTargetDoorBreached()
{
	if(IsFirstOfficerThrower())
	{
		PrepareToThrowGrenade(4, false);
	}
	ThrowGrenade();
	return;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.SquadBreachGasAndClearGoal'
}