class SquadDeployThrownItemThroughDoorAction extends SquadThrowGrenadeAndClearAction
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) HandheldEquipment.EquipmentSlot ThrownItemSlot;

protected function TriggerThrowGrenadeMoveUpSpeech()
{
	switch(ThrownItemSlot)
	{
		case 3:
			ISwatOfficer(Thrower).GetOfficerSpeechManagerAction().TriggerMoveUpBangsSpeech();
			break;
		case 4:
			ISwatOfficer(Thrower).GetOfficerSpeechManagerAction().TriggerMoveUpGasSpeech();
			break;
		case 5:
			ISwatOfficer(Thrower).GetOfficerSpeechManagerAction().TriggerMoveUpStingSpeech();
			break;
		default:
			break;
	}
	return;
}

protected function SetThrower()
{
	Thrower = GetThrowingOfficer(ThrownItemSlot);
	if(EqualEqual_ObjectObject(Thrower, none))
	{
		instantFail(11);
	}
	return;
}

protected latent function PrepareToMoveThroughOpenDoorway()
{
	PrepareToThrowGrenade(ThrownItemSlot, false);
	ThrowGrenade();
	return;
}

protected latent function PreTargetDoorOpened()
{
	if(Not_PreBool(IsFirstOfficerThrower()))
	{
		PrepareToThrowGrenade(ThrownItemSlot, true);
	}
	return;
}

protected latent function PostTargetDoorOpened()
{
	if(IsFirstOfficerThrower())
	{
		PrepareToThrowGrenade(ThrownItemSlot, false);
	}
	ThrowGrenade();
	return;
}

state Running
{Begin:

	StackUpSquad(true);
	SetupOfficerRoles();
	PrepareToMoveSquad();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.SquadDeployThrownItemThroughDoorGoal'
}