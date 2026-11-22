class CloseDoorAction extends MoveToDoorAction
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) bool CloseDoorFromBehind;
var(Parameters) bool CloseDoorFromLeft;
var private ISwatDoor SwatDoorTarget;

function cleanup()
{
	super(MoveToActionBase).cleanup();
	ISwatAI(m_pawn).AnimStopSpecial();
	ISwatAI(m_pawn).UnlockAim();
	m_pawn.EnableCollisionAvoidance();
	ISwatAI(m_pawn).ClearPendingDoor();
	SwatDoorTarget.SetPendingInteractor(none);
	return;
}

private function bool ShouldContinueToCloseDoor()
{
	local Pawn PendingDoorInteractor;

	assert(NotEqual_ObjectObject(SwatDoorTarget, none));
	PendingDoorInteractor = SwatDoorTarget.GetPendingInteractor();
	return AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(Not_PreBool(TargetDoor.IsEmptyDoorway()), Not_PreBool(TargetDoor.IsClosed())), Not_PreBool(SwatDoorTarget.IsBroken())), OrOr_BoolBool(EqualEqual_ObjectObject(PendingDoorInteractor, none), EqualEqual_ObjectObject(PendingDoorInteractor, m_pawn)));
	return;
}

latent function CloseDoor()
{
	local name CloseAnimName;
	local int CloseDoorAnimChannel;
	local Pawn PendingDoorInteractor;

	SwatDoorTarget = ISwatDoor(TargetDoor);
	assert(NotEqual_ObjectObject(SwatDoorTarget, none));
	PendingDoorInteractor = SwatDoorTarget.GetPendingInteractor();
	J0x30:

	if(TargetDoor.IsOpening())
	{
		yield();
		// [Loop Continue]
		goto J0x30;
	}
	if(ShouldContinueToCloseDoor())
	{
		m_pawn.DisableCollisionAvoidance();
		ISwatAI(m_pawn).SetPendingDoor(TargetDoor);
		SwatDoorTarget.SetPendingInteractor(m_pawn);
		if(m_pawn.FitsAtLocation(SwatDoorTarget.GetClosePoint(CloseDoorFromLeft)))
		{
			MoveToCloseDoor(TargetDoor, CloseDoorFromLeft, CloseDoorFromBehind);
			RotateAndLockToDoorUsageRotation();
			if(ShouldContinueToCloseDoor())
			{
				CloseAnimName = SwatDoorTarget.GetCloseAnimation(m_pawn, CloseDoorFromBehind);
				CloseDoorAnimChannel = m_pawn.AnimPlaySpecial(CloseAnimName);
				m_pawn.FinishAnim(CloseDoorAnimChannel);
			}
			ISwatAI(m_pawn).UnlockAim();
		}
		else
		{
			if(m_pawn.IsA('SwatOfficer'))
			{
				ISwatOfficer(m_pawn).GetOfficerSpeechManagerAction().TriggerCouldntCompleteMoveSpeech();
			}
		}
		ISwatAI(m_pawn).ClearPendingDoor();
		SwatDoorTarget.SetPendingInteractor(none);
		m_pawn.EnableCollisionAvoidance();
	}
	return;
}

state Running
{Begin:

	CloseDoor();
	succeed();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.CloseDoorGoal'
}