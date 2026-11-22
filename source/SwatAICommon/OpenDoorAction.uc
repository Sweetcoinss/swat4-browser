class OpenDoorAction extends MoveToDoorAction
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) bool bOpenFrantically;
var config float BlockedSleepTime;
var private bool bIsDoorBlockedBeforeOpen;
var ISwatDoor SwatDoorTarget;

function initAction(AI_Resource R, AI_Goal Goal)
{
	super(MoveToActionBase).initAction(R, Goal);
	SwatDoorTarget = ISwatDoor(TargetDoor);
	assert(NotEqual_ObjectObject(SwatDoorTarget, none));
	return;
}

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

function bool ShouldContinueToOpenDoor()
{
	local Pawn PendingDoorInteractor;

	PendingDoorInteractor = SwatDoorTarget.GetPendingInteractor();
	return AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(TargetDoor.IsClosed(), Not_PreBool(SwatDoorTarget.IsBroken())), Not_PreBool(TargetDoor.IsOpening())), Not_PreBool(TargetDoor.IsClosing())), OrOr_BoolBool(EqualEqual_ObjectObject(PendingDoorInteractor, none), EqualEqual_ObjectObject(PendingDoorInteractor, m_pawn)));
	return;
}

private function UpdateDoorKnowledge()
{
	if(m_pawn.IsA('SwatOfficer'))
	{
		SwatAIRepository(Level.AIRepo).UpdateDoorKnowledgeForOfficers(TargetDoor);
		if(SwatDoorTarget.IsLocked())
		{
			ISwatOfficer(m_pawn).GetOfficerSpeechManagerAction().TriggerReportDoorLockedSpeech();
		}
		else
		{
			if(SwatDoorTarget.IsWedged())
			{
				ISwatOfficer(m_pawn).GetOfficerSpeechManagerAction().TriggerReportDoorWedgedSpeech();
			}
		}
	}
	else
	{
		if(SwatDoorTarget.IsWedged())
		{
			ISwatAI(m_pawn).GetCommanderAction().NotifyDoorWedged(TargetDoor);
		}
		else
		{
			if(SwatDoorTarget.IsLocked())
			{
				ISwatAI(m_pawn).GetCommanderAction().NotifyDoorLocked(TargetDoor);
			}
		}
	}
	if(OrOr_BoolBool(SwatDoorTarget.IsWedged(), AndAnd_BoolBool(SwatDoorTarget.IsLocked(), Not_PreBool(ISwatAI(m_pawn).ShouldForceOpenLockedDoors()))))
	{
		instantSucceed();
	}
	else
	{
		if(bIsDoorBlockedBeforeOpen)
		{
			ISwatAI(m_pawn).GetCommanderAction().NotifyDoorBlocked(TargetDoor);
		}
	}
	return;
}

latent function OpenDoor()
{
	local name OpenAnimName;
	local int OpenDoorAnimChannel;

	if(m_pawn.logAI)
	{
		Log(Concat_StrStr(Concat_StrStr(string(m_pawn.Name), " is preparing to open door "), string(TargetDoor.Name)));
	}
	if(ShouldContinueToOpenDoor())
	{
		ISwatAI(m_pawn).SetPendingDoor(TargetDoor);
		SwatDoorTarget.SetPendingInteractor(m_pawn);
		if(m_pawn.logAI)
		{
			Log(Concat_StrStr(Concat_StrStr(string(m_pawn.Name), " is now the pending interactor for "), string(TargetDoor.Name)));
		}
		MoveToOpenDoor(TargetDoor);
		RotateAndLockToDoorUsageRotation();
		if(ShouldContinueToOpenDoor())
		{
			bIsDoorBlockedBeforeOpen = SwatDoorTarget.IsBlockedFor(m_pawn);
			OpenAnimName = SwatDoorTarget.GetOpenAnimation(m_pawn, GetDoorUsageSide(), bOpenFrantically);
			if(m_pawn.logAI)
			{
				Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(m_pawn.Name), " is playing the open door animation ("), string(OpenAnimName)), ") on "), string(TargetDoor.Name)), " at time "), string(m_pawn.Level.TimeSeconds)), " DoorUsageSide: "), string(GetDoorUsageSide())), " bOpenFrantically: "), string(bOpenFrantically)));
			}
			OpenDoorAnimChannel = m_pawn.AnimPlaySpecial(OpenAnimName);
			m_pawn.FinishAnim(OpenDoorAnimChannel);
			if(m_pawn.logAI)
			{
				Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(m_pawn.Name), " finished playing the open door animation on "), string(TargetDoor.Name)), " at time "), string(m_pawn.Level.TimeSeconds)));
			}
		}
		ISwatAI(m_pawn).UnlockAim();
		ISwatAI(m_pawn).ClearPendingDoor();
		SwatDoorTarget.SetPendingInteractor(none);
		m_pawn.EnableCollisionAvoidance();
	}
	if(m_pawn.logAI)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("Before UpdateDoorKnowledge - IsLocked(): ", string(SwatDoorTarget.IsLocked())), " IsClosed: "), string(TargetDoor.IsClosed())), " Should Force Open Locked Doors: "), string(ISwatAI(m_pawn).ShouldForceOpenLockedDoors())));
	}
	UpdateDoorKnowledge();
	if(m_pawn.logTyrion)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(m_pawn.Name), " is finished to opening door "), string(TargetDoor.Name)), " IsClosed: "), string(TargetDoor.IsClosed())), " IsBroken: "), string(SwatDoorTarget.IsBroken())), " PendingInteractor "), string(SwatDoorTarget.GetPendingInteractor())));
	}
	return;
}

state Running
{Begin:

	OpenDoor();
	if(Not_PreBool(bIsDoorBlockedBeforeOpen))
	{
		J0x11:

		if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(TargetDoor.IsClosed(), Not_PreBool(TargetDoor.IsOpening())), Not_PreBool(SwatDoorTarget.IsBroken())), Not_PreBool(SwatDoorTarget.IsWedged())))
		{
			yield();
			// [Loop Continue]
			goto J0x11;
		}
	}
	else
	{
		Sleep(BlockedSleepTime);
		goto 'Begin';
	}
	succeed();
	stop;
}

defaultproperties
{
	BlockedSleepTime=0.5000000
	satisfiesGoal=Class'SwatAICommon.OpenDoorGoal'
}