class SquadGasAndClearAction extends SquadThrowGrenadeAndClearAction
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

protected latent function PrepareToMoveThroughOpenDoorway()
{
	PrepareToThrowGrenade(4, false);
	ThrowGrenade();
	return;
}

protected latent function PreTargetDoorOpened()
{
	if(Not_PreBool(IsFirstOfficerThrower()))
	{
		PrepareToThrowGrenade(4, true);
	}
	return;
}

protected latent function PostTargetDoorOpened()
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
	satisfiesGoal=Class'SwatAICommon.SquadGasAndClearGoal'
}