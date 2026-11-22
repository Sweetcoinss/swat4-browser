class SquadSecureAction extends OfficerSquadAction
	collapsecategories
	hidecategories(Object,InternalParameters);

var array<Pawn> AvailableOfficers;
var array<RestrainAndReportGoal> CurrentRestrainAndReportGoals;
var array<SecureEvidenceGoal> CurrentSecureEvidenceGoals;
var array<Actor> TargetsBeingSecured;

protected function NotifyPawnDied(Pawn Pawn)
{
	local int i;

	super.NotifyPawnDied(Pawn);
	i = 0;
	J0x12:

	if(Less_IntInt(i, AvailableOfficers.Length))
	{
		if(EqualEqual_ObjectObject(AvailableOfficers[i], Pawn))
		{
			AvailableOfficers.Remove(i, 1);
			// [Explicit Break]
			goto J0x50;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x12;
	}
	J0x50:

	return;
}

function cleanup()
{
	super(ActionBase).cleanup();
	ClearOutRestrainAndReportGoals();
	ClearOutSecureEvidenceGoals();
	CopyTargetsBeingSecuredToGoal();
	return;
}

private function ClearOutRestrainAndReportGoals()
{
	J0x00:
	if(Greater_IntInt(CurrentRestrainAndReportGoals.Length, 0))
	{
		if(NotEqual_ObjectObject(CurrentRestrainAndReportGoals[0], none))
		{
			CurrentRestrainAndReportGoals[0].Release();
			CurrentRestrainAndReportGoals.Remove(0, 1);
		}
		// [Loop Continue]
		goto J0x00;
	}
	return;
}

private function ClearOutSecureEvidenceGoals()
{
	J0x00:
	if(Greater_IntInt(CurrentSecureEvidenceGoals.Length, 0))
	{
		if(NotEqual_ObjectObject(CurrentSecureEvidenceGoals[0], none))
		{
			CurrentSecureEvidenceGoals[0].Release();
			CurrentSecureEvidenceGoals.Remove(0, 1);
		}
		// [Loop Continue]
		goto J0x00;
	}
	return;
}

function CopyTargetsBeingSecuredToGoal()
{
	J0x00:
	if(Greater_IntInt(TargetsBeingSecured.Length, 0))
	{
		AddSecureTarget(TargetsBeingSecured[0]);
		TargetsBeingSecured.Remove(0, 1);
		// [Loop Continue]
		goto J0x00;
	}
	return;
}

function AddSecureTarget(Actor SecureTarget)
{
	SquadSecureGoal(achievingGoal).AddSecureTarget(SecureTarget);
	return;
}

function int GetNumSecureTargets()
{
	return SquadSecureGoal(achievingGoal).GetNumSecureTargets();
	return;
}

function Actor GetSecureTarget(int SecureTargetIndex)
{
	return SquadSecureGoal(achievingGoal).GetSecureTarget(SecureTargetIndex);
	return;
}

function RemoveSecureTarget(Actor SecureTarget)
{
	SquadSecureGoal(achievingGoal).RemoveSecureTarget(SecureTarget);
	return;
}

private function AddTargetBeingSecured(Actor SecureTarget)
{
	assert(Not_PreBool(IsTargetBeingSecured(SecureTarget)));
	TargetsBeingSecured[TargetsBeingSecured.Length] = SecureTarget;
	return;
}

private function RemoveTargetBeingSecured(Actor SecureTarget)
{
	local int i;

	Log(Concat_StrStr("RemoveTargetBeingSecured called on ", string(SecureTarget)));
	assert(IsTargetBeingSecured(SecureTarget));
	i = 0;
	J0x45:

	if(Less_IntInt(i, TargetsBeingSecured.Length))
	{
		if(EqualEqual_ObjectObject(TargetsBeingSecured[i], SecureTarget))
		{
			TargetsBeingSecured.Remove(i, 1);
			// [Explicit Break]
			goto J0x83;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x45;
	}
	J0x83:

	return;
}

function bool IsTargetBeingSecured(Actor SecureTarget)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, TargetsBeingSecured.Length))
	{
		if(EqualEqual_ObjectObject(TargetsBeingSecured[i], SecureTarget))
		{
			return true;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return false;
	return;
}

function NotifyNewSecureTarget()
{
	if(IsIdle())
	{
		runAction();
	}
	return;
}

function goalAchievedCB(AI_Goal Goal, AI_Action Child)
{
	local RestrainAndReportGoal AchievedRestrainAndReportGoal;
	local SecureEvidenceGoal AchievedSecureEvidenceGoal;

	super(AI_Action).goalAchievedCB(Goal, Child);
	if(resource.Pawn().logTyrion)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("Squad R&R goal achieved was: ", string(Goal.Name)), " goal.IsA('RestrainAndReportGoal'): "), string(Goal.IsA('RestrainAndReportGoal'))));
	}
	if(Goal.IsA('RestrainAndReportGoal'))
	{
		assert(NotEqual_ObjectObject(AI_CharacterResource(Goal.resource).m_pawn, none));
		AchievedRestrainAndReportGoal = RestrainAndReportGoal(Goal);
		RemoveTargetBeingSecured(AchievedRestrainAndReportGoal.CompliantTarget);
		RemoveRestrainAndReportGoal(AchievedRestrainAndReportGoal);
		MakeOfficerAvailable(AI_CharacterResource(Goal.resource).m_pawn);
		if(IsIdle())
		{
			runAction();
		}
	}
	else
	{
		if(Goal.IsA('SecureEvidenceGoal'))
		{
			assert(NotEqual_ObjectObject(AI_CharacterResource(Goal.resource).m_pawn, none));
			AchievedSecureEvidenceGoal = SecureEvidenceGoal(Goal);
			RemoveTargetBeingSecured(Actor(AchievedSecureEvidenceGoal.EvidenceTarget));
			RemoveSecureEvidenceGoal(AchievedSecureEvidenceGoal);
			MakeOfficerAvailable(AI_CharacterResource(Goal.resource).m_pawn);
			if(IsIdle())
			{
				runAction();
			}
		}
	}
	return;
}

function goalNotAchievedCB(AI_Goal Goal, AI_Action Child, ActionBase.ACT_ErrorCodes errorCode)
{
	local RestrainAndReportGoal NotAchievedRestrainAndReportGoal;
	local SecureEvidenceGoal NotAchievedSecureEvidenceGoal;
	local Pawn Officer;

	super(AI_Action).goalNotAchievedCB(Goal, Child, errorCode);
	if(Goal.IsA('RestrainAndReportGoal'))
	{
		NotAchievedRestrainAndReportGoal = RestrainAndReportGoal(Goal);
		Officer = AI_CharacterResource(Goal.resource).m_pawn;
		if(NotEqual_IntInt(int(errorCode), int(4)))
		{
			RemoveTargetBeingSecured(NotAchievedRestrainAndReportGoal.CompliantTarget);
			AddSecureTarget(NotAchievedRestrainAndReportGoal.CompliantTarget);
			if(IsIdle())
			{
				runAction();
			}
		}
		RemoveRestrainAndReportGoal(NotAchievedRestrainAndReportGoal);
		if(Class'Engine.Pawn'.static.checkConscious(Officer))
		{
			MakeOfficerAvailable(Officer);
		}
	}
	else
	{
		if(Goal.IsA('SecureEvidenceGoal'))
		{
			NotAchievedSecureEvidenceGoal = SecureEvidenceGoal(Goal);
			Officer = AI_CharacterResource(Goal.resource).m_pawn;
			if(NotEqual_IntInt(int(errorCode), int(4)))
			{
				RemoveTargetBeingSecured(Actor(NotAchievedSecureEvidenceGoal.EvidenceTarget));
				AddSecureTarget(Actor(NotAchievedSecureEvidenceGoal.EvidenceTarget));
				if(IsIdle())
				{
					runAction();
				}
			}
			RemoveSecureEvidenceGoal(NotAchievedSecureEvidenceGoal);
			if(Class'Engine.Pawn'.static.checkConscious(Officer))
			{
				MakeOfficerAvailable(Officer);
			}
		}
	}
	return;
}

function RemoveRestrainAndReportGoal(RestrainAndReportGoal Goal)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, CurrentRestrainAndReportGoals.Length))
	{
		if(EqualEqual_ObjectObject(CurrentRestrainAndReportGoals[i], Goal))
		{
			CurrentRestrainAndReportGoals[i].unPostGoal(self);
			CurrentRestrainAndReportGoals[i].Release();
			CurrentRestrainAndReportGoals.Remove(i, 1);
			// [Explicit Break]
			goto J0x6C;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	J0x6C:

	return;
}

function RemoveSecureEvidenceGoal(SecureEvidenceGoal Goal)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, CurrentSecureEvidenceGoals.Length))
	{
		if(EqualEqual_ObjectObject(CurrentSecureEvidenceGoals[i], Goal))
		{
			CurrentSecureEvidenceGoals[i].unPostGoal(self);
			CurrentSecureEvidenceGoals[i].Release();
			CurrentSecureEvidenceGoals.Remove(i, 1);
			// [Explicit Break]
			goto J0x6C;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	J0x6C:

	return;
}

private function PopulateAvailableOfficers()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, squad().pawns.Length))
	{
		AvailableOfficers[AvailableOfficers.Length] = squad().pawns[i];
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

private function MakeOfficerAvailable(Pawn Officer)
{
	assert(NotEqual_ObjectObject(Officer, none));
	AvailableOfficers[AvailableOfficers.Length] = Officer;
	return;
}

private function MakeOfficerUnavailable(Pawn Officer)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, AvailableOfficers.Length))
	{
		if(EqualEqual_ObjectObject(AvailableOfficers[i], Officer))
		{
			AvailableOfficers.Remove(i, 1);
			// [Explicit Break]
			goto J0x45;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	J0x45:

	return;
}

private function bool AreAnyOfficersAvailable()
{
	ValidateAvailableOfficers();
	return Greater_IntInt(AvailableOfficers.Length, 0);
	return;
}

private function ValidateAvailableOfficers()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, AvailableOfficers.Length))
	{
		if(Not_PreBool(Class'Engine.Pawn'.static.checkConscious(AvailableOfficers[i])))
		{
			AvailableOfficers.Remove(i, 1);
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

private function Pawn GetClosestAvailableOfficerToTarget(Actor Target)
{
	local int i;
	local float IterDistance, ClosestDistance;
	local Pawn IterOfficer, ClosestOfficer;

	ValidateAvailableOfficers();
	i = 0;
	J0x0D:

	if(Less_IntInt(i, AvailableOfficers.Length))
	{
		IterOfficer = AvailableOfficers[i];
		IterDistance = IterOfficer.GetPathfindingDistanceToActor(Target, true);
		if(OrOr_BoolBool(EqualEqual_ObjectObject(ClosestOfficer, none), Less_FloatFloat(IterDistance, ClosestDistance)))
		{
			ClosestOfficer = IterOfficer;
			ClosestDistance = IterDistance;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x0D;
	}
	return ClosestOfficer;
	return;
}

latent function RestrainAndReportOnTarget(Pawn RestrainTarget)
{
	local Pawn Officer;
	local RestrainAndReportGoal CurrentRestrainAndReportGoal;

	assert(NotEqual_ObjectObject(RestrainTarget, none));
	Officer = GetClosestAvailableOfficerToTarget(RestrainTarget);
	MakeOfficerUnavailable(Officer);
	CurrentRestrainAndReportGoal = Class'SwatAICommon.RestrainAndReportGoal'.static.Allocate(self).;
	construct_AI_ResourcePawn(AI_Resource(Officer.CharacterAI), RestrainTarget);
	assert(NotEqual_ObjectObject(CurrentRestrainAndReportGoal, none));
	CurrentRestrainAndReportGoal.AddRef();
	CurrentRestrainAndReportGoals[CurrentRestrainAndReportGoals.Length] = CurrentRestrainAndReportGoal;
	CurrentRestrainAndReportGoal.postGoal(self);
	return;
}

latent function SecureEvidence(IEvidence SecureEvidenceTarget)
{
	local Pawn Officer;
	local SecureEvidenceGoal CurrentSecureEvidenceGoal;

	assert(NotEqual_ObjectObject(SecureEvidenceTarget, none));
	Officer = GetClosestAvailableOfficerToTarget(Actor(SecureEvidenceTarget));
	MakeOfficerUnavailable(Officer);
	CurrentSecureEvidenceGoal = Class'SwatAICommon.SecureEvidenceGoal'.static.Allocate(self).;
	construct_AI_ResourceIEvidence(AI_Resource(Officer.CharacterAI), SecureEvidenceTarget);
	assert(NotEqual_ObjectObject(CurrentSecureEvidenceGoal, none));
	CurrentSecureEvidenceGoal.AddRef();
	CurrentSecureEvidenceGoals[CurrentSecureEvidenceGoals.Length] = CurrentSecureEvidenceGoal;
	CurrentSecureEvidenceGoal.postGoal(self);
	return;
}

latent function SecureCurrentTargets()
{
	local Actor IterTarget;

	if(resource.Pawn().logAI)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("SecureCurrentTargets - GetNumSecureTargets():", string(GetNumSecureTargets())), " AreAnyOfficersAvailable(): "), string(AreAnyOfficersAvailable())));
	}
	J0x81:

	if(AndAnd_BoolBool(Greater_IntInt(GetNumSecureTargets(), 0), AreAnyOfficersAvailable()))
	{
		IterTarget = GetSecureTarget(0);
		if(Not_PreBool(IsTargetBeingSecured(IterTarget)))
		{
			if(IterTarget.IsA('Pawn'))
			{
				RestrainAndReportOnTarget(Pawn(IterTarget));
			}
			else
			{
				assert(IterTarget.IsA('IEvidence'));
				SecureEvidence(IEvidence(IterTarget));
			}
			AddTargetBeingSecured(IterTarget);
		}
		RemoveSecureTarget(IterTarget);
		// [Loop Continue]
		goto J0x81;
	}
	return;
}

private function TriggerReplyToOrderSpeech()
{
	local Pawn ClosestOfficerToCommandGiver;

	ClosestOfficerToCommandGiver = GetClosestOfficerTo(CommandGiver, false, false);
	if(NotEqual_ObjectObject(ClosestOfficerToCommandGiver, none))
	{
		ISwatOfficer(ClosestOfficerToCommandGiver).GetOfficerSpeechManagerAction().TriggerGenericOrderReplySpeech();
	}
	return;
}

state Running
{Begin:

	PopulateAvailableOfficers();
	if(Not_PreBool(bHasBeenCopied))
	{
		TriggerReplyToOrderSpeech();
	}
	J0x17:

	if(OrOr_BoolBool(OrOr_BoolBool(Greater_IntInt(GetNumSecureTargets(), 0), Greater_IntInt(CurrentRestrainAndReportGoals.Length, 0)), Greater_IntInt(CurrentSecureEvidenceGoals.Length, 0)))
	{
		SecureCurrentTargets();
		if(resource.Pawn().logTyrion)
		{
			Log("pausing Squad securing");
		}
		Pause();
		yield();
		// [Loop Continue]
		goto J0x17;
	}
	succeed();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.SquadSecureGoal'
}