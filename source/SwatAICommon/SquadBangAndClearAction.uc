class SquadBangAndClearAction extends SquadThrowGrenadeAndClearAction
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

protected latent function PrepareToMoveThroughOpenDoorway()
{
	PrepareToThrowGrenade(3, false);
	ThrowGrenade();
	return;
}

protected latent function PreTargetDoorOpened()
{
	if(Not_PreBool(IsFirstOfficerThrower()))
	{
		PrepareToThrowGrenade(3, true);
	}
	return;
}

protected latent function PostTargetDoorOpened()
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
	satisfiesGoal=Class'SwatAICommon.SquadBangAndClearGoal'
}