class SquadBreachStingAndClearAction extends SquadBreachThrowGrenadeAndClearAction
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

protected latent function PreTargetDoorBreached()
{
	if(Not_PreBool(IsFirstOfficerThrower()))
	{
		PrepareToThrowGrenade(5, true);
	}
	return;
}

protected latent function PostTargetDoorBreached()
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
	satisfiesGoal=Class'SwatAICommon.SquadBreachStingAndClearGoal'
}