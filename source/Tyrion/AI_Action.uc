class AI_Action extends AI_RunnableAction implements ISensorNotification
	abstract
	native
	collapsecategories
	hidecategories(Object,InternalParameters);

var const editconst Class<AI_Goal> satisfiesGoal;
var AI_Goal achievingGoal;
var array<AI_Goal> childGoals;
var float heuristicValue;
var int resourceUsage;
var int waitingForGoalsN;

latent function succeed()
{
	achievingGoal.markGoalAsAchieved();
	if(NotEqual_ObjectObject(achievingGoal.parentAction, none))
	{
		achievingGoal.parentAction.goalAchievedCB(achievingGoal, self);
	}
	achievingGoal.handleGoalSuccess();
	if(NotEqual_ObjectObject(achievingGoal.achievingAction, none))
	{
		removeAction();
	}
	achievingGoal.Release();
	achievingGoal = none;
	yield();
	return;
}

event instantSucceed()
{
	achievingGoal.markGoalAsAchieved();
	if(NotEqual_ObjectObject(achievingGoal.parentAction, none))
	{
		achievingGoal.parentAction.goalAchievedCB(achievingGoal, self);
	}
	achievingGoal.handleGoalSuccess();
	if(NotEqual_ObjectObject(achievingGoal.achievingAction, none))
	{
		removeAction();
	}
	achievingGoal.Release();
	achievingGoal = none;
	return;
}

event instantFail(ActionBase.ACT_ErrorCodes errorCode, optional bool bRemoveGoal)
{
	if(EqualEqual_ObjectObject(achievingGoal, none))
	{
		return;
	}
	if(bRemoveGoal)
	{
		achievingGoal.bTryOnlyOnce = true;
	}
	achievingGoal.markGoalAsFailed();
	if(NotEqual_ObjectObject(achievingGoal.parentAction, none))
	{
		achievingGoal.parentAction.goalNotAchievedCB(achievingGoal, self, errorCode);
	}
	achievingGoal.handleGoalFailure();
	removeAction();
	achievingGoal.Release();
	achievingGoal = none;
	return;
}

latent function fail(ActionBase.ACT_ErrorCodes errorCode, optional bool bRemoveGoal)
{
	instantFail(errorCode, bRemoveGoal);
	yield();
	return;
}

latent function waitForGoal(AI_Goal Goal, optional bool bTryOnlyOnce)
{
	waitingForGoalsN = 1;
	Goal.bWakeUpPoster = true;
	Goal.bTryOnlyOnce = bTryOnlyOnce;
	Pause();
	return;
}

latent function interruptGoalIf(AI_Goal Goal, Class<IBooleanGoalCondition> condition)
{
	J0x00:
	if(Not_PreBool(Goal.hasCompleted()))
	{
		if(condition.static.goalTest(Goal))
		{
			Goal.unPostGoal(self);
			// [Explicit Break]
			goto J0x4A;
		}
		else
		{
			yield();
		}
		// [Loop Continue]
		goto J0x00;
	}
	J0x4A:

	return;
}

latent function waitForAllGoals(optional AI_Goal goal1, optional AI_Goal goal2, optional AI_Goal goal3, optional AI_Goal goal4, optional AI_Goal goal5, optional AI_Goal goal6, optional AI_Goal goal7, optional AI_Goal goal8, optional AI_Goal goal9)
{
	waitingForGoalsN = 0;
	if(NotEqual_ObjectObject(goal1, none))
	{
		AddAdd_Int(waitingForGoalsN);
		goal1.bWakeUpPoster = true;
	}
	if(NotEqual_ObjectObject(goal2, none))
	{
		AddAdd_Int(waitingForGoalsN);
		goal2.bWakeUpPoster = true;
	}
	if(NotEqual_ObjectObject(goal3, none))
	{
		AddAdd_Int(waitingForGoalsN);
		goal3.bWakeUpPoster = true;
	}
	if(NotEqual_ObjectObject(goal4, none))
	{
		AddAdd_Int(waitingForGoalsN);
		goal4.bWakeUpPoster = true;
	}
	if(NotEqual_ObjectObject(goal5, none))
	{
		AddAdd_Int(waitingForGoalsN);
		goal5.bWakeUpPoster = true;
	}
	if(NotEqual_ObjectObject(goal6, none))
	{
		AddAdd_Int(waitingForGoalsN);
		goal6.bWakeUpPoster = true;
	}
	if(NotEqual_ObjectObject(goal7, none))
	{
		AddAdd_Int(waitingForGoalsN);
		goal7.bWakeUpPoster = true;
	}
	if(NotEqual_ObjectObject(goal8, none))
	{
		AddAdd_Int(waitingForGoalsN);
		goal8.bWakeUpPoster = true;
	}
	if(NotEqual_ObjectObject(goal9, none))
	{
		AddAdd_Int(waitingForGoalsN);
		goal9.bWakeUpPoster = true;
	}
	Pause();
	return;
}

latent function waitForAllGoalsInList(array<AI_Goal> goals)
{
	local int i;

	waitingForGoalsN = 0;
	i = 0;
	J0x0E:

	if(Less_IntInt(i, goals.Length))
	{
		if(NotEqual_ObjectObject(goals[i], none))
		{
			AddAdd_Int(waitingForGoalsN);
			goals[i].bWakeUpPoster = true;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x0E;
	}
	Pause();
	return;
}

latent function waitForAnyGoal(AI_Goal goal1, optional AI_Goal goal2, optional AI_Goal goal3, optional AI_Goal goal4, optional AI_Goal goal5, optional AI_Goal goal6, optional AI_Goal goal7)
{
	waitingForGoalsN = 1;
	goal1.bWakeUpPoster = true;
	if(NotEqual_ObjectObject(goal2, none))
	{
		goal2.bWakeUpPoster = true;
	}
	if(NotEqual_ObjectObject(goal3, none))
	{
		goal3.bWakeUpPoster = true;
	}
	if(NotEqual_ObjectObject(goal4, none))
	{
		goal4.bWakeUpPoster = true;
	}
	if(NotEqual_ObjectObject(goal5, none))
	{
		goal5.bWakeUpPoster = true;
	}
	if(NotEqual_ObjectObject(goal6, none))
	{
		goal6.bWakeUpPoster = true;
	}
	if(NotEqual_ObjectObject(goal7, none))
	{
		goal7.bWakeUpPoster = true;
	}
	Pause();
	return;
}

latent function waitForAllGoalsConsidered(AI_Goal goal1, optional AI_Goal goal2, optional AI_Goal goal3, optional AI_Goal goal4, optional AI_Goal goal5, optional AI_Goal goal6, optional AI_Goal goal7)
{
	J0x00:
	if(Not_PreBool(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(OrOr_BoolBool(EqualEqual_ObjectObject(goal1, none), goal1.wasConsidered()), OrOr_BoolBool(EqualEqual_ObjectObject(goal2, none), goal2.wasConsidered())), OrOr_BoolBool(EqualEqual_ObjectObject(goal3, none), goal3.wasConsidered())), OrOr_BoolBool(EqualEqual_ObjectObject(goal4, none), goal4.wasConsidered())), OrOr_BoolBool(EqualEqual_ObjectObject(goal5, none), goal5.wasConsidered())), OrOr_BoolBool(EqualEqual_ObjectObject(goal6, none), goal6.wasConsidered())), OrOr_BoolBool(EqualEqual_ObjectObject(goal7, none), goal7.wasConsidered()))))
	{
		yield();
		// [Loop Continue]
		goto J0x00;
	}
	return;
}

latent function waitForResourcesAvailable(int legsPriority, int armsPriority, optional int headPriority)
{
	J0x00:
	if(Not_PreBool(resource.requiredResourcesAvailable(legsPriority, armsPriority, headPriority)))
	{
		yield();
		// [Loop Continue]
		goto J0x00;
	}
	return;
}

function OnSensorMessage(AI_Sensor sensor, AI_SensorData Value, Object userData)
{
	return;
}

function AI_Resource getResource()
{
	return resource;
	return;
}

event initAction(AI_Resource R, AI_Goal Goal)
{
	resource = R;
	achievingGoal = Goal;
	Goal.achievingAction = self;
	achievingGoal.AddRef();
	GotoState('Running');
	return;
}

function AI_Action myAddRef()
{
	AddRef();
	return self;
	return;
}

function interruptAction()
{
	if(NotEqual_ObjectObject(achievingGoal.parentAction, none))
	{
		achievingGoal.parentAction.goalNotAchievedCB(achievingGoal, self, 3);
	}
	achievingGoal.markGoalAsFailed();
	super.interruptAction();
	return;
}

function removeAction()
{
	GotoState('None');
	J0x07:

	if(Greater_IntInt(childGoals.Length, 0))
	{
		childGoals[0].resource.removeGoal(childGoals[0]);
		// [Loop Continue]
		goto J0x07;
	}
	achievingGoal.achievingAction = none;
	if(EqualEqual_ObjectObject(self, resource.usedByAction))
	{
		resource.usedByAction = none;
	}
	super.removeAction();
	return;
}

function runAction()
{
	if(Not_PreBool(resource.isActive()))
	{
		if(AndAnd_BoolBool(NotEqual_ObjectObject(resource.Pawn(), none), resource.Pawn().logTyrion))
		{
			Log(At_StrStr(string(Name), "stopped. Resource is dead"));
		}
		instantFail(2);
		return;
	}
	super.runAction();
	return;
}

event float selectionHeuristic(AI_Goal Goal)
{
	return 1.0000000;
	return;
}

function bool isChildGoal(AI_Goal Goal)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, childGoals.Length))
	{
		if(EqualEqual_ObjectObject(childGoals[i], Goal))
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

function goalAchievedCB(AI_Goal Goal, AI_Action Child)
{
	if(AndAnd_BoolBool(AndAnd_BoolBool(Goal.bWakeUpPoster, EqualEqual_IntInt(SubtractSubtract_PreInt(waitingForGoalsN), 0)), bIdle))
	{
		runAction();
	}
	return;
}

function goalNotAchievedCB(AI_Goal Goal, AI_Action Child, ActionBase.ACT_ErrorCodes errorCode)
{
	if(AndAnd_BoolBool(Goal.bWakeUpPoster, bIdle))
	{
		runAction();
	}
	return;
}

function resourceStolenCB(AI_Goal Goal, AI_Resource stolenResource)
{
	if(resource.Pawn().logTyrion)
	{
		Log(At_StrStr(At_StrStr(At_StrStr("---> resource", string(stolenResource.Name)), "stolen from"), string(Goal.Name)));
	}
	if(Goal.bTerminateIfStolen)
	{
		if(resource.Pawn().logTyrion)
		{
			Log(At_StrStr(At_StrStr("--->", string(Name)), "terminating"));
		}
		instantFail(10);
	}
	return;
}
