class AI_Goal extends Tyrion_GoalBase implements ISensorNotification
	abstract
	native
	collapsecategories
	hidecategories(Object,InternalParameters);

var bool bRemoveGoalOfSameType "remove an existing goal of the same type before adding this one";
var bool bTryOnlyOnce "when true, don't try to achieve goal more than once (i.e. remove if it fails)";
var int Priority "in the range [0, 100]; higher number means higher priority";
var string goalName "reference to this goal for script actions";
var AI_SensorWithBounds activationSentinel;
var AI_SensorWithBounds deactivationSentinel;
var AI_Action achievingAction;
var AI_Action parentAction;
var bool bInactive;
var bool bPermanent;
var bool bDeleted;
var bool bGoalConsidered;
var bool bWakeUpPoster;
var bool bTerminateIfStolen;
var bool bGoalFailed;
var bool bGoalAchieved;
var int ignoreCounter;
var int matchedN;
var AI_Resource resource;

function OnSensorMessage(AI_Sensor sensor, AI_SensorData Value, Object userData)
{
	if(EqualEqual_ObjectObject(userData, none))
	{
		DeActivate();
	}
	else
	{
		Activate();
	}
	return;
}

function AI_Resource getResource()
{
	return resource;
	return;
}

overloaded function Construct()
{
	assert(false);
	return;
}

overloaded function Construct(AI_Resource R)
{
	Init(R);
	return;
}

function Init(AI_Resource R)
{
	if(EqualEqual_ObjectObject(R, none))
	{
		Log(Concat_StrStr(At_StrStr(At_StrStr(At_StrStr("AI WARNING:", string(Name)), "(in"), string(R.Pawn().Name)), ") given 'None' resource!"));
	}
	if(AndAnd_BoolBool(NotEqual_ObjectObject(R, none), EqualEqual_ObjectObject(resource, R)))
	{
		Log(Concat_StrStr(At_StrStr(At_StrStr(At_StrStr("AI WARNING:", string(Name)), "(in"), string(R.Pawn().Name)), ") already initialized!"));
	}
	resource = R;
	if(EqualEqual_ObjectObject(activationSentinel, none))
	{
		activationSentinel = Class'Tyrion.AI_SensorWithBounds'.static.Allocate(self, R).;
		Construct_Void();
	}
	if(EqualEqual_ObjectObject(deactivationSentinel, none))
	{
		deactivationSentinel = Class'Tyrion.AI_SensorWithBounds'.static.Allocate(self, R).;
		Construct_Void();
	}
	return;
}

function AI_Goal myAddRef()
{
	AddRef();
	return self;
	return;
}

event int priorityFn()
{
	return Priority;
	return;
}

function AI_Goal postGoal(AI_Action Parent)
{
	local int i;

	if(bRemoveGoalOfSameType)
	{
		i = 0;
		J0x10:

		if(Less_IntInt(i, resource.goals.Length))
		{
			if(EqualEqual_NameName(resource.goals[i].Class.Name, Class.Name))
			{
				if(resource.Pawn().logTyrion)
				{
					Log(At_StrStr(At_StrStr(At_StrStr(Concat_StrStr(string(resource.Pawn().Name), ": bRemoveGoalOfSameType = true; Replacing"), string(resource.goals[i].Name)), "with"), string(Name)));
				}
				AI_Goal(resource.goals[i]).unPostGoal(parentAction);
				// [Explicit Break]
				goto J0x12E;
			}
			AddAdd_PreInt(i);
			// [Loop Continue]
			goto J0x10;
		}
	}
	J0x12E:

	resource.addGoal(Parent, self);
	return self;
	return;
}

function unPostGoal(AI_Action Parent)
{
	if(EqualEqual_ObjectObject(Parent, parentAction))
	{
		resource.removeGoal(self);
	}
	else
	{
		Log(At_StrStr(At_StrStr(At_StrStr("AI WARNING: invalid unPostGoal call.", string(Parent.Name)), "does not own"), string(Name)));
	}
	return;
}

// Export UAI_Goal::execcopyParametersFrom(FFrame&, void* const)
native function bool copyParametersFrom(AI_Goal otherGoal);

function changePriority(int newPriority)
{
	if(resource.Pawn().logTyrion)
	{
		Log(At_StrStr(At_StrStr(At_StrStr(At_StrStr(string(Name), "priority changed from"), string(Priority)), "to"), string(newPriority)));
	}
	Priority = newPriority;
	if(LessEqual_IntInt(newPriority, 0))
	{
		unPostGoal(parentAction);
	}
	resource.bMatchGoals = true;
	return;
}

function bool hasCompleted()
{
	return OrOr_BoolBool(bGoalFailed, bGoalAchieved);
	return;
}

function bool wasAchieved()
{
	return bGoalAchieved;
	return;
}

function bool wasNotAchieved()
{
	return bGoalFailed;
	return;
}

function bool wasConsidered()
{
	return bGoalConsidered;
	return;
}

function bool beingAchieved()
{
	return NotEqual_ObjectObject(achievingAction, none);
	return;
}

function markGoalAsAchieved()
{
	bGoalAchieved = true;
	bGoalFailed = false;
	return;
}

function handleGoalSuccess()
{
	if(AndAnd_BoolBool(NotEqual_ObjectObject(activationSentinel.sensor, none), Not_PreBool(bInactive)))
	{
		if(resource.Pawn().logTyrion)
		{
			Log(At_StrStr(string(Name), "was just deactivated because the action achieving it succeeded!"));
		}
		if(NotEqual_ObjectObject(deactivationSentinel.sensor, none))
		{
			deactivationSentinel.deactivateSentinel(self);
			deactivationSentinel.sensor = none;
		}
		bInactive = true;
	}
	if(bPermanent)
	{
		resource.bMatchGoals = true;
	}
	else
	{
		resource.removeGoal(self);
	}
	return;
}

function markGoalAsFailed()
{
	bGoalAchieved = false;
	bGoalFailed = true;
	return;
}

function handleGoalFailure()
{
	if(bTryOnlyOnce)
	{
		if(AndAnd_BoolBool(NotEqual_ObjectObject(activationSentinel.sensor, none), Not_PreBool(bInactive)))
		{
			if(resource.Pawn().logTyrion)
			{
				Log(At_StrStr(string(Name), "was just deactivated because the action achieving it failed and goal was 'bTryOnce'!"));
			}
			if(NotEqual_ObjectObject(deactivationSentinel.sensor, none))
			{
				deactivationSentinel.deactivateSentinel(self);
				deactivationSentinel.sensor = none;
			}
			bInactive = true;
		}
		else
		{
			assert(Not_PreBool(bPermanent));
			if(resource.Pawn().logTyrion)
			{
				Log(At_StrStr(At_StrStr(At_StrStr(At_StrStr(string(Name), "("), string(resource.Pawn().Name)), ") bTryOnce = true: Removing"), string(Name)));
			}
			resource.removeGoal(self);
		}
	}
	else
	{
		resource.bMatchGoals = true;
		ignoreCounter = 1;
	}
	return;
}

function DeActivate()
{
	if(EqualEqual_BoolBool(bInactive, false))
	{
		if(resource.Pawn().logTyrion)
		{
			Log(At_StrStr(string(Name), "was just deactivated by its deactivationSentinel!"));
		}
		bInactive = true;
		if(NotEqual_ObjectObject(achievingAction, none))
		{
			achievingAction.interruptAction();
		}
		if(bPermanent)
		{
			if(NotEqual_ObjectObject(deactivationSentinel.sensor, none))
			{
				deactivationSentinel.deactivateSentinel(self);
				deactivationSentinel.sensor = none;
			}
		}
		else
		{
			resource.removeGoal(self);
		}
	}
	return;
}

function Activate()
{
	if(EqualEqual_BoolBool(bInactive, true))
	{
		if(resource.Pawn().logTyrion)
		{
			Log(At_StrStr(string(Name), "was just activated!"));
		}
		bInactive = false;
		resource.bMatchGoals = true;
		if(NotEqual_ObjectObject(deactivationSentinel.sensor, none))
		{
			Log(At_StrStr(At_StrStr("AI WARNING:", string(self)), "attempted to reset non-None deactivation sentinel"));
			deactivationSentinel.deactivateSentinel(self);
			deactivationSentinel.sensor = none;
		}
		setUpDeactivationSentinel();
	}
	return;
}

function setUpDeactivationSentinel()
{
	return;
}

static function int GetDefaultPriority()
{
	return default.Priority;
	return;
}

defaultproperties
{
	Priority=50
	goalName="<unnamed goal>"
}