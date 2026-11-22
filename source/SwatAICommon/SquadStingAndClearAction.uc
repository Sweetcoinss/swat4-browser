class SquadStingAndClearAction extends SquadThrowGrenadeAndClearAction
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

protected function TriggerThrowGrenadeMoveUpSpeech()
{
	ISwatOfficer(Thrower).GetOfficerSpeechManagerAction().TriggerMoveUpStingSpeech();
	return;
}

protected function SetThrower()
{
	Thrower = GetThrowingOfficer(5);
	if(EqualEqual_ObjectObject(Thrower, none))
	{
		instantFail(11);
	}
	return;
}

protected latent function PrepareToMoveThroughOpenDoorway()
{
	PrepareToThrowGrenade(5, false);
	ThrowGrenade();
	return;
}

protected latent function PreTargetDoorOpened()
{
	if(Not_PreBool(IsFirstOfficerThrower()))
	{
		PrepareToThrowGrenade(5, true);
	}
	return;
}

protected latent function PostTargetDoorOpened()
{
	if(IsFirstOfficerThrower())
	{
		PrepareToThrowGrenade(5, false);
	}
	ThrowGrenade();
	return;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.SquadStingAndClearGoal'
}