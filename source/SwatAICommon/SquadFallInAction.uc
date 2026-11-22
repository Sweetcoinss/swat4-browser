class SquadFallInAction extends OfficerSquadAction
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

var private Formation FallInFormation;
var private Timer CompletedTimer;
var config float CompletedTimerUpdateRate;
var config float CopyCompletedTimerUpdateRate;
var config float MinDistanceToTriggerReplySpeech;
var config float MinDistanceToTriggerCompletedSpeech;

function cleanup()
{
	super(ActionBase).cleanup();
	if(NotEqual_ObjectObject(FallInFormation, none))
	{
		FallInFormation.cleanup();
		FallInFormation.Release();
		FallInFormation = none;
	}
	CleanupCompletedTimer();
	return;
}

function goalNotAchievedCB(AI_Goal Goal, AI_Action Child, ActionBase.ACT_ErrorCodes errorCode)
{
	super(AI_Action).goalNotAchievedCB(Goal, Child, errorCode);
	if(Goal.IsA('FallInGoal'))
	{
		instantSucceed();
	}
	return;
}

protected function NotifyPawnDied(Pawn Pawn)
{
	super.NotifyPawnDied(Pawn);
	instantFail(1);
	return;
}

private function SpawnCompletedTimer()
{
	assert(EqualEqual_ObjectObject(CompletedTimer, none));
	assert(NotEqual_ObjectObject(CommandGiver, none));
	CompletedTimer = CommandGiver.Spawn(Class'Engine.Timer');
	CompletedTimer.__TimerDelegate__Delegate = CheckFallInCompleted;
	if(bHasBeenCopied)
	{
		CompletedTimer.StartTimer(CopyCompletedTimerUpdateRate, true);
	}
	else
	{
		CompletedTimer.StartTimer(CompletedTimerUpdateRate, true);
	}
	return;
}

private function bool ShouldReplyCompleted()
{
	local int i;
	local Pawn Iter;
	local bool bOneOfficerHasLineOfSightToCommandGiver;

	i = 0;
	J0x07:

	if(Less_IntInt(i, squad().pawns.Length))
	{
		Iter = squad().pawns[i];
		if(Greater_FloatFloat(VSize(Subtract_VectorVector(Iter.Location, CommandGiver.Location)), MinDistanceToTriggerCompletedSpeech))
		{
			return false;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	i = 0;
	J0x79:

	if(Less_IntInt(i, squad().pawns.Length))
	{
		Iter = squad().pawns[i];
		if(squad().pawns[i].LineOfSightTo(CommandGiver))
		{
			bOneOfficerHasLineOfSightToCommandGiver = true;
			// [Explicit Break]
			goto J0xEA;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x79;
	}
	J0xEA:

	return bOneOfficerHasLineOfSightToCommandGiver;
	return;
}

function CheckFallInCompleted()
{
	local Pawn OfficerInFront;

	if(ShouldReplyCompleted())
	{
		OfficerInFront = FallInFormation.GetOrderedMember(0);
		if(bHasBeenCopied)
		{
			OfficerTeamInfo(squad()).TriggerTeamReportedSpeech(OfficerInFront);
		}
		ISwatOfficer(OfficerInFront).GetOfficerSpeechManagerAction().TriggerCompletedFallInSpeech();
		CleanupCompletedTimer();
	}
	return;
}

private function CleanupCompletedTimer()
{
	if(NotEqual_ObjectObject(CompletedTimer, none))
	{
		CompletedTimer.StopTimer();
		CompletedTimer.__TimerDelegate__Delegate = None;
		CompletedTimer.Destroy();
		CompletedTimer = none;
	}
	return;
}

function FallInSquad()
{
	local Pawn Officer;
	local array<Pawn> FormationMembers;
	local int i;

	FallInFormation = Class'SwatAICommon.Formation'.static.Allocate(self).;
	construct_Pawn(CommandGiver);
	assert(NotEqual_ObjectObject(FallInFormation, none));
	FallInFormation.AddRef();
	i = 0;
	J0x43:

	if(Less_IntInt(i, squad().pawns.Length))
	{
		FormationMembers[FormationMembers.Length] = squad().pawns[i];
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x43;
	}
	FallInFormation.AddMembers(FormationMembers);
	i = 0;
	J0xA4:

	if(Less_IntInt(i, squad().pawns.Length))
	{
		Officer = squad().pawns[i];
		ISwatOfficer(Officer).SetCurrentFormation(FallInFormation);
		Class'SwatAICommon.FallInGoal'.static.Allocate(self)..AI_CharacterResource(Officer.CharacterAI);
		/* Statement decompilation error: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index

		*/

		/*@Error*/
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0xA4;
		return;
	}
	@NULL
}

private function Pawn FindOfficerToTriggerFallInSpeech()
{
	local int i;
	local Pawn Iter;

	i = 0;
	J0x07:

	if(Less_IntInt(i, squad().pawns.Length))
	{
		Iter = squad().pawns[i];
		if(GreaterEqual_FloatFloat(VSize(Subtract_VectorVector(Iter.Location, CommandGiver.Location)), MinDistanceToTriggerReplySpeech))
		{
			return Iter;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return none;
	return;
}

private function TriggerFallInSpeech()
{
	local Pawn Officer;

	Officer = FindOfficerToTriggerFallInSpeech();
	if(NotEqual_ObjectObject(Officer, none))
	{
		ISwatOfficer(Officer).GetOfficerSpeechManagerAction().TriggerRepliedFallInSpeech();
	}
	return;
}

state Running
{Begin:

	if(Not_PreBool(bHasBeenCopied))
	{
		TriggerFallInSpeech();
	}
	SpawnCompletedTimer();
	FallInSquad();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.SquadFallInGoal'
}