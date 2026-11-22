class AI_Resource extends Tyrion_ResourceBase
	abstract
	native
	editinlinenew;

const OPTIONAL_RESOURCE_PRIORITY = 20;
const RU_HEAD = 1;
const RU_ARMS = 2;
const RU_LEGS = 4;
const RU_MOUNT = 8;

var array<AI_RunnableAction> idleActions;
var array<AI_RunnableAction> runningActions;
var array<AI_RunnableAction> removedActions;
var AI_Action usedByAction;
var array<AI_Sensor> sensors;
var array<AI_SensorAction> sensorActions;

event Init()
{
	local int i;
	local AI_Goal Goal;
	local array<AI_Goal> removeGoals;

	i = 0;
	J0x07:

	if(Less_IntInt(i, goals.Length))
	{
		Goal = AI_Goal(goals[i]);
		if(LessEqual_IntInt(Goal.priorityFn(), 0))
		{
			removeGoals[removeGoals.Length] = Goal;
			// [Explicit Continue]
			goto J0x7B;
		}
		if(EqualEqual_ObjectObject(Goal.resource, none))
		{
			Goal.Init(self);
		}
		J0x7B:

		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	i = 0;
	J0x8C:

	if(Less_IntInt(i, removeGoals.Length))
	{
		if(Pawn().logTyrion)
		{
			Log(At_StrStr(At_StrStr(At_StrStr(At_StrStr("Removing", string(removeGoals[i].Name)), "from"), string(Pawn().Name)), "(priority <= 0)"));
		}
		removeGoal(removeGoals[i]);
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x8C;
	}
	bUnInitialized = false;
	return;
}

function cleanup()
{
	local int i;
	local AI_Goal Goal;
	local ActionBase Action;

	i = 0;
	J0x07:

	if(Less_IntInt(i, goals.Length))
	{
		Goal = AI_Goal(goals[i]);
		if(AndAnd_BoolBool(NotEqual_ObjectObject(Goal.activationSentinel, none), NotEqual_ObjectObject(Goal.activationSentinel.sensor, none)))
		{
			Goal.activationSentinel.deactivateSentinel(Goal);
			Goal.activationSentinel.sensor = none;
		}
		if(AndAnd_BoolBool(NotEqual_ObjectObject(Goal.deactivationSentinel, none), NotEqual_ObjectObject(Goal.deactivationSentinel.sensor, none)))
		{
			Goal.deactivationSentinel.deactivateSentinel(Goal);
			Goal.deactivationSentinel.sensor = none;
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	J0x109:

	if(Greater_IntInt(idleActions.Length, 0))
	{
		Action = idleActions[0];
		idleActions.Remove(0, 1);
		Action.instantFail(2);
		// [Loop Continue]
		goto J0x109;
	}
	J0x13E:

	if(Greater_IntInt(runningActions.Length, 0))
	{
		Action = runningActions[0];
		runningActions.Remove(0, 1);
		Action.instantFail(2);
		// [Loop Continue]
		goto J0x13E;
	}
	i = 0;
	J0x17A:

	if(Less_IntInt(i, sensors.Length))
	{
		sensors[i].cleanup();
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x17A;
	}
	i = 0;
	J0x1B0:

	if(Less_IntInt(i, sensorActions.Length))
	{
		sensorActions[i].removeAction();
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x1B0;
	}
	sensorActions.Length = 0;
	J0x1E7:

	if(Greater_IntInt(goals.Length, 0))
	{
		removeGoal(AI_Goal(goals[0]));
		// [Loop Continue]
		goto J0x1E7;
	}
	return;
}

function deleteSensors()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, sensors.Length))
	{
		sensors[i].Value.Delete();
		sensors[i].Delete();
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	sensors.Length = 0;
	return;
}

// Export UAI_Resource::execdeleteRemovedActions(FFrame&, void* const)
native function deleteRemovedActions();

function AI_Resource myAddRef()
{
	AddRef();
	return self;
	return;
}

function PushRunnableAction(AI_RunnableAction Pushed)
{
	assert(NotEqual_ObjectObject(Pushed, none));
	runningActions[runningActions.Length] = Pushed;
	return;
}

function PawnDied(Pawn Pawn)
{
	local int i;
	local array<ActionBase> Actions;

	i = 0;
	J0x07:

	if(Less_IntInt(i, runningActions.Length))
	{
		Actions[Actions.Length] = runningActions[i];
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	i = 0;
	J0x40:

	if(Less_IntInt(i, idleActions.Length))
	{
		Actions[Actions.Length] = idleActions[i];
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x40;
	}
	i = 0;
	J0x79:

	if(Less_IntInt(i, Actions.Length))
	{
		if(Not_PreBool(Actions[i].bDeleted))
		{
			Actions[i].PawnDied(Pawn);
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x79;
	}
	return;
}

// Export UAI_Resource::execchooseAction(FFrame&, void* const)
native function AI_Action chooseAction(AI_Goal Goal);

event AI_Action ShallowCopyAction(AI_Action otherAction)
{
	return AI_Action(Class'Engine.Tyrion_Setup'.static.shallowCopy(otherAction));
	return;
}

event resourceCheck(AI_Goal Goal, optional AI_Action bestAction)
{
	if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(usedByAction, none), EqualEqual_BoolBool(Goal.bInactive, false)), Greater_IntInt(Goal.priorityFn(), usedByAction.achievingGoal.priorityFn())), Not_PreBool(doesParentHaveResource(Goal.parentAction))))
	{
		if(EqualEqual_ObjectObject(bestAction, none))
		{
			bestAction = chooseAction(Goal);
		}
		else
		{
			bestAction.AddRef();
		}
		if(Not_PreBool(multipleActionsCheck(bestAction)))
		{
			if(Pawn().logTyrion)
			{
				Log(Concat_StrStr(At_StrStr(At_StrStr(At_StrStr(Concat_StrStr(At_StrStr(At_StrStr(At_StrStr("resourceCheck: Interrupting", string(usedByAction.Name)), "(pri"), string(usedByAction.achievingGoal.priorityFn())), ") to achieve"), string(Goal.Name)), "(pri"), string(Goal.priorityFn())), ")"));
			}
			if(EqualEqual_ObjectObject(usedByAction, Goal.parentAction))
			{
				Log(At_StrStr(At_StrStr(At_StrStr("AI WARNING: Child action", string(bestAction.Name)), "is interrupting its parent"), string(Goal.parentAction.Name)));
			}
			if(NotEqual_ObjectObject(usedByAction.achievingGoal.parentAction, none))
			{
				usedByAction.achievingGoal.parentAction.resourceStolenCB(usedByAction.achievingGoal, self);
			}
			if(NotEqual_ObjectObject(usedByAction, none))
			{
				usedByAction.interruptAction();
			}
		}
		if(NotEqual_ObjectObject(bestAction, none))
		{
			bestAction.Release();
		}
	}
	return;
}

function AI_SensorAction addSensorActionClass(Class<AI_SensorAction> sensorActionClass)
{
	local AI_SensorAction sensorAction;

	assert(NotEqual_ObjectObject(sensorActionClass, none));
	sensorAction = sensorActionClass.static.Allocate(self)..self;
	goto J0x400;
	myAddRef();
	sensorAction.setupSensors(self);
	sensorAction.pauseAction();
	sensorActions[sensorActions.Length] = sensorAction;
	return sensorAction;
	return;
	@NULL
}

event bool multipleActionsCheck(AI_Action Action)
{
	return true;
	return;
}

event bool doesParentHaveResource(AI_Action parentAction)
{
	return false;
	return;
}

function Class<AI_RunnableAction> getActionClass()
{
	return;
}

function bool setActionParameters(AI_Goal Goal, AI_Action Action)
{
	return setActionParametersInternal(Goal, Action);
	return;
}

event Pawn Pawn()
{
	return none;
	return;
}

// Export UAI_Resource::execfindGoalByName(FFrame&, void* const)
native function AI_Goal findGoalByName(string gName);

// Export UAI_Resource::execsetActionParametersInternal(FFrame&, void* const)
private native function bool setActionParametersInternal(Object Goal, Object Action);

function addGoal(AI_Action Parent, AI_Goal Goal)
{
	Goal.AddRef();
	if(AndAnd_BoolBool(NotEqual_ObjectObject(Pawn(), none), Pawn().logTyrion))
	{
		Log(Concat_StrStr(At_StrStr(At_StrStr(At_StrStr(Concat_StrStr(string(self), ": Adding goal"), string(Goal)), "(pri"), string(Goal.Priority)), ")"));
	}
	goals[goals.Length] = Goal;
	Goal.parentAction = Parent;
	if(NotEqual_ObjectObject(Parent, none))
	{
		Parent.childGoals[Parent.childGoals.Length] = Goal;
	}
	if(EqualEqual_BoolBool(Goal.bInactive, false))
	{
		bMatchGoals = true;
	}
	return;
}

function removeGoal(AI_Goal Goal)
{
	local int i;

	if(NotEqual_ObjectObject(Goal.parentAction, none))
	{
		i = 0;
		J0x1B:

		if(Less_IntInt(i, Goal.parentAction.childGoals.Length))
		{
			if(EqualEqual_ObjectObject(Goal.parentAction.childGoals[i], Goal))
			{
				Goal.parentAction.childGoals.Remove(i, 1);
				// [Explicit Break]
				goto J0x8F;
			}
			AddAdd_Int(i);
			// [Loop Continue]
			goto J0x1B;
		}
	}
	J0x8F:

	if(AndAnd_BoolBool(NotEqual_ObjectObject(Goal.activationSentinel, none), NotEqual_ObjectObject(Goal.activationSentinel.sensor, none)))
	{
		Goal.activationSentinel.deactivateSentinel(Goal);
		Goal.activationSentinel.sensor = none;
	}
	if(AndAnd_BoolBool(NotEqual_ObjectObject(Goal.deactivationSentinel, none), NotEqual_ObjectObject(Goal.deactivationSentinel.sensor, none)))
	{
		Goal.deactivationSentinel.deactivateSentinel(Goal);
		Goal.deactivationSentinel.sensor = none;
	}
	if(AndAnd_BoolBool(NotEqual_ObjectObject(usedByAction, none), EqualEqual_ObjectObject(Goal.achievingAction, usedByAction)))
	{
		bMatchGoals = true;
	}
	if(NotEqual_ObjectObject(Goal.achievingAction, none))
	{
		Goal.achievingAction.removeAction();
	}
	i = 0;
	J0x1C1:

	if(Less_IntInt(i, goals.Length))
	{
		if(EqualEqual_ObjectObject(goals[i], Goal))
		{
			goals.Remove(i, 1);
			Goal.bDeleted = true;
			if(Greater_IntInt(Goal.Release(), 0))
			{
				Goal.NullReferences();
			}
			// [Explicit Break]
			goto J0x230;
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x1C1;
	}
	J0x230:

	return;
}

event resetGoals()
{
	local int i, n;
	local AI_Goal Goal;

	n = goals.Length;
	i = 0;
	J0x13:

	if(Less_IntInt(i, n))
	{
		Goal = AI_Goal(goals[i]);
		if(NotEqual_ObjectObject(Goal.achievingAction, none))
		{
			Goal.achievingAction.instantSucceed();
			if(NotEqual_IntInt(goals.Length, n))
			{
				n = goals.Length;
				SubtractSubtract_PreInt(i);
			}
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x13;
	}
	bGoalsReset = true;
	return;
}

function displayTyrionDebug()
{
	local int i;
	local Pawn debugPawn;

	debugPawn = Pawn();
	debugPawn.AddDebugMessage(" ");
	if(Greater_IntInt(goals.Length, 0))
	{
		debugPawn.AddDebugMessage(Concat_StrStr(string(Name), " Goals"), Class'Engine.Canvas'.static.MakeColor(byte(255), byte(255), byte(255)));
		i = 0;
		J0x6C:

		if(Less_IntInt(i, goals.Length))
		{
			if(Not_PreBool(AI_Goal(goals[i]).bInactive))
			{
				debugPawn.AddDebugMessage(Concat_StrStr("  ", goals[i].goalDebuggingString()));
			}
			AddAdd_Int(i);
			// [Loop Continue]
			goto J0x6C;
		}
	}
	if(Greater_IntInt(runningActions.Length, 0))
	{
		debugPawn.AddDebugMessage(Concat_StrStr(Concat_StrStr("Running ", string(Name)), " Actions"), Class'Engine.Canvas'.static.MakeColor(byte(255), byte(255), byte(255)));
		i = 0;
		J0x12B:

		if(Less_IntInt(i, runningActions.Length))
		{
			debugPawn.AddDebugMessage(Concat_StrStr("  ", runningActions[i].actionDebuggingString()));
			AddAdd_Int(i);
			// [Loop Continue]
			goto J0x12B;
		}
	}
	if(Greater_IntInt(idleActions.Length, 0))
	{
		debugPawn.AddDebugMessage(Concat_StrStr(Concat_StrStr("Idle ", string(Name)), " Actions"), Class'Engine.Canvas'.static.MakeColor(byte(255), byte(255), byte(255)));
		i = 0;
		J0x1C8:

		if(Less_IntInt(i, idleActions.Length))
		{
			debugPawn.AddDebugMessage(Concat_StrStr("  ", idleActions[i].actionDebuggingString()));
			AddAdd_Int(i);
			// [Loop Continue]
			goto J0x1C8;
		}
	}
	return;
}

defaultproperties
{
	bMatchGoals=true
}