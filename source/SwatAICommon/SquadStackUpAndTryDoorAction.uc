class SquadStackUpAndTryDoorAction extends SquadStackUpAction
	collapsecategories
	hidecategories(Object,InternalParameters);

var private TryDoorGoal CurrentTryDoorGoal;

function cleanup()
{
	super.cleanup();
	if(NotEqual_ObjectObject(CurrentTryDoorGoal, none))
	{
		CurrentTryDoorGoal.Release();
		CurrentTryDoorGoal = none;
	}
	return;
}

function goalAchievedCB(AI_Goal Goal, AI_Action Child)
{
	super(AI_Action).goalAchievedCB(Goal, Child);
	if(resource.Pawn().logTyrion)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("SquadStackUpAndTryDoorAction::goalAchievedCB - pawn is: ", string(Goal.resource.Pawn())), " goal is: "), string(Goal)), " child is: "), string(Child)));
	}
	if(AndAnd_BoolBool(AndAnd_BoolBool(EqualEqual_ObjectObject(CurrentTryDoorGoal, none), Goal.IsA('StackUpGoal')), EqualEqual_ObjectObject(OfficersInStackUpOrder[0], Goal.resource.Pawn())))
	{
		if(CanInteractWithTargetDoor())
		{
			TryDoor(Goal.resource.Pawn());
		}
		runAction();
	}
	else
	{
		if(EqualEqual_ObjectObject(Goal, CurrentTryDoorGoal))
		{
			PostStackedUpGoal(GetFirstOfficer(), StackUpPoints[0]);
			runAction();
		}
	}
	return;
}

protected function NotifyPawnDied(Pawn Pawn)
{
	super.NotifyPawnDied(Pawn);
	assert(NotEqual_ObjectObject(Pawn, none));
	instantFail(1);
	return;
}

protected function bool ShouldFirstOfficerBeStackedUp()
{
	return OrOr_BoolBool(EqualEqual_ObjectObject(OfficersInStackUpOrder[0], none), Not_PreBool(IsOfficerAtSideOpenPoint(OfficersInStackUpOrder[0])));
	return;
}

function TryDoor(Pawn Officer)
{
	assert(NotEqual_ObjectObject(Officer, none));
	assert(EqualEqual_ObjectObject(CurrentTryDoorGoal, none));
	RemoveStackedUpGoalOnOfficer(Officer);
	CurrentTryDoorGoal = Class'SwatAICommon.TryDoorGoal'.static.Allocate(self).;
	construct_AI_ResourceDoorBool(AI_Resource(Officer.CharacterAI), TargetDoor, Not_PreBool(bTriggerCouldntBreachLockedSpeech));
	assert(NotEqual_ObjectObject(CurrentTryDoorGoal, none));
	CurrentTryDoorGoal.AddRef();
	CurrentTryDoorGoal.postGoal(self);
	return;
}

private function RemoveTryDoorGoal()
{
	if(NotEqual_ObjectObject(CurrentTryDoorGoal, none))
	{
		CurrentTryDoorGoal.unPostGoal(self);
		CurrentTryDoorGoal.Release();
		CurrentTryDoorGoal = none;
	}
	return;
}

state Running
{Begin:

	if(NeedsToStackUp())
	{
		TriggerOrderedToStackUpReplySpeech();
		InternalStackUpSquad();
		Pause();
		if(AndAnd_BoolBool(NotEqual_ObjectObject(CurrentTryDoorGoal, none), Not_PreBool(CurrentTryDoorGoal.hasCompleted())))
		{
			waitForGoal(CurrentTryDoorGoal);
		}
	}
	else
	{
		TryDoor(GetFirstOfficer());
		Pause();
	}
	RemoveTryDoorGoal();
	TriggerCompletedSpeech();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.SquadStackUpAndTryDoorGoal'
}