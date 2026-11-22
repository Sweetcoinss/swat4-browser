class TryDoorAction extends SwatCharacterAction
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) Door TargetDoor;
var(Parameters) bool bTriggerReportResultsSpeech;
var private MoveToDoorGoal CurrentMoveToDoorGoal;
var private ISwatAI.AIDoorUsageSide TryDoorUsageSide;
var private Rotator TryDoorUsageRotation;

function cleanup()
{
	super(AI_CharacterAction).cleanup();
	if(NotEqual_ObjectObject(CurrentMoveToDoorGoal, none))
	{
		CurrentMoveToDoorGoal.Release();
		CurrentMoveToDoorGoal = none;
	}
	ISwatAI(m_pawn).AnimStopSpecial();
	ISwatAI(m_pawn).UnlockAim();
	m_pawn.EnableCollisionAvoidance();
	return;
}

function goalNotAchievedCB(AI_Goal Goal, AI_Action Child, ActionBase.ACT_ErrorCodes errorCode)
{
	super(AI_Action).goalNotAchievedCB(Goal, Child, errorCode);
	if(m_pawn.logTyrion)
	{
		Log(Concat_StrStr(string(Goal.Name), " was not achieved.  failing."));
	}
	instantFail(errorCode);
	return;
}

private function ReportResultsToTeam()
{
	local SwatAIRepository SwatAIRepo;

	SwatAIRepo = SwatAIRepository(m_pawn.Level.AIRepo);
	assert(NotEqual_ObjectObject(SwatAIRepo, none));
	SwatAIRepo.UpdateDoorKnowledgeForOfficers(TargetDoor);
	if(bTriggerReportResultsSpeech)
	{
		TriggerReportResultsSpeech();
	}
	return;
}

private function TriggerReportResultsSpeech()
{
	local ISwatDoor SwatTargetDoor;

	SwatTargetDoor = ISwatDoor(TargetDoor);
	assert(NotEqual_ObjectObject(SwatTargetDoor, none));
	if(SwatTargetDoor.IsLocked())
	{
		ISwatOfficer(m_pawn).GetOfficerSpeechManagerAction().TriggerReportDoorLockedSpeech();
	}
	else
	{
		if(SwatTargetDoor.IsWedged())
		{
			ISwatOfficer(m_pawn).GetOfficerSpeechManagerAction().TriggerReportDoorWedgedSpeech();
		}
		else
		{
			ISwatOfficer(m_pawn).GetOfficerSpeechManagerAction().TriggerReportDoorOpenSpeech();
		}
	}
	return;
}

latent function MoveToTryDoor()
{
	CurrentMoveToDoorGoal = Class'SwatAICommon.MoveToDoorGoal'.static.Allocate(self).;
	construct_AI_ResourceIntDoor(movementResource(), achievingGoal.Priority, TargetDoor);
	assert(NotEqual_ObjectObject(CurrentMoveToDoorGoal, none));
	CurrentMoveToDoorGoal.AddRef();
	CurrentMoveToDoorGoal.SetRotateTowardsPointsDuringMovement(true);
	CurrentMoveToDoorGoal.SetShouldWalkEntireMove(false);
	CurrentMoveToDoorGoal.SetPreferSides();
	CurrentMoveToDoorGoal.postGoal(self);
	waitForGoal(CurrentMoveToDoorGoal);
	TryDoorUsageSide = CurrentMoveToDoorGoal.DoorUsageSide;
	TryDoorUsageRotation = CurrentMoveToDoorGoal.DoorUsageRotation;
	CurrentMoveToDoorGoal.unPostGoal(self);
	CurrentMoveToDoorGoal.Release();
	CurrentMoveToDoorGoal = none;
	return;
}

latent function TryDoor()
{
	local int AnimSpecialChannel;
	local name AnimName;
	local ISwatDoor SwatDoorTarget;

	SwatDoorTarget = ISwatDoor(TargetDoor);
	assert(NotEqual_ObjectObject(SwatDoorTarget, none));
	AnimName = SwatDoorTarget.GetTryDoorAnimation(m_pawn, TryDoorUsageSide);
	AnimSpecialChannel = m_pawn.AnimPlaySpecial(AnimName);
	m_pawn.FinishAnim(AnimSpecialChannel);
	return;
}

private function bool CanInteractWithTargetDoor()
{
	return AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(Not_PreBool(TargetDoor.IsEmptyDoorway()), TargetDoor.IsClosed()), Not_PreBool(TargetDoor.IsOpening())), Not_PreBool(ISwatDoor(TargetDoor).IsBroken()));
	return;
}

state Running
{Begin:

	useResources(Class'Tyrion.AI_Resource'.2);
	if(CanInteractWithTargetDoor())
	{
		MoveToTryDoor();
		useResources(Class'Tyrion.AI_Resource'.4);
		if(CanInteractWithTargetDoor())
		{
			ISwatAI(m_pawn).AimToRotation(TryDoorUsageRotation);
			ISwatAI(m_pawn).LockAim();
			ISwatAI(m_pawn).AnimSnapBaseToAim();
			TryDoor();
			ISwatAI(m_pawn).UnlockAim();
			m_pawn.EnableCollisionAvoidance();
			ReportResultsToTeam();
		}
	}
	succeed();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.TryDoorGoal'
}