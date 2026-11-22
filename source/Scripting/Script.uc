class Script extends Actor
	native
	config
	placeable
	hidecategories(Karma,Advanced,Collision,Events,Force,Karma,Lighting,LightColor,Movement,Sound,Display,Object,Placement,Navigation);

var Class<Message> MessageClass;
var export editinline Message messageFilter;
var export editinline array<export editinline Action> Actions;
var bool Enabled;
var bool CampaignObjectiveSpecific "If true, this Script will not execute unless Campaign Objectives are currently enabled.";
var bool DisabledInMP;
var bool bIsExecuting;
var array<WatcherBase> watchers;
var private bool bExitScript;
var private bool bExitLoop;
var private Message currentMessage;
var array<Message> messageQueue;
var array<Variable> variables;
var array<Variable> tempVariables;

function PostBeginPlay()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, Actions.Length))
	{
		Actions[i].setParentScript(self);
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	if(NotEqual_StrStr(TriggeredBy, ""))
	{
		registerMessage(MessageClass, TriggeredBy);
	}
	return;
}

simulated event SetInitialState()
{
	return;
}

event Timer()
{
	dispatchMessage(Class'Scripting.MessageTimerExpired'.static.Allocate(self)., Construct_Void());
	return;
}

function Variable findVariable(name VariableName)
{
	local name fullVariableName;
	local int i;

	fullVariableName = string(Concat_StrStr("Variable_", string(VariableName)));
	i = 0;
	J0x23:

	if(Less_IntInt(i, variables.Length))
	{
		if(EqualEqual_NameName(variables[i].Name, fullVariableName))
		{
			return variables[i];
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x23;
	}
	return none;
	return;
}

function Variable newVariable(name VariableName, Class<Variable> variableType)
{
	local Variable V;

	V = findVariable(VariableName);
	if(NotEqual_ObjectObject(V, none))
	{
		return V;
	}
	variables[variables.Length] = variableType.static.Allocate(self, self, Concat_StrStr("Variable_", string(VariableName))).;
	construct_Script(self);
	return variables[Subtract_IntInt(variables.Length, 1)];
	return;
}

function Variable newTemporaryVariable(Class<Variable> variableType, optional string initValue)
{
	local Variable V;

	V = variableType.static.Allocate(self, self).;
	construct_Script(self);
	tempVariables[tempVariables.Length] = V;
	if(NotEqual_StrStr(initValue, ""))
	{
		V.SetPropertyText("value", initValue);
	}
	return V;
	return;
}

function addWatcher(WatcherBase newWatcher)
{
	watchers[watchers.Length] = newWatcher;
	return;
}

function setWatcherEnabled(name watcherName, bool Enabled)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, watchers.Length))
	{
		if(EqualEqual_NameName(watchers[i].watcherName, watcherName))
		{
			watchers[i].Enabled = Enabled;
			watchers[i].GotoState('LookAtExpression');
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

function Exit()
{
	bExitScript = true;
	return;
}

function bool continueExecution()
{
	return Not_PreBool(bExitScript);
	return;
}

function enterLoop()
{
	bExitLoop = false;
	return;
}

function bool keepLooping()
{
	return AndAnd_BoolBool(Not_PreBool(bExitLoop), Not_PreBool(bExitScript));
	return;
}

function exitLoop()
{
	bExitLoop = true;
	return;
}

function onMessage(Message msg)
{
	if(Not_PreBool(Enabled))
	{
		return;
	}
	if(AndAnd_BoolBool(DisabledInMP, NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone))))
	{
		return;
	}
	if(NotEqual_ObjectObject(msg.Class, MessageClass))
	{
		return;
	}
	if(AndAnd_BoolBool(NotEqual_ObjectObject(messageFilter, none), Not_PreBool(msg.passesFilter(messageFilter))))
	{
		return;
	}
	execute(msg);
	return;
}

function Message triggeringMessage()
{
	return currentMessage;
	return;
}

function execute(Message msg)
{
	local Message msgCopy;
	local name PropName;

	assert(NotEqual_ObjectObject(msg, none));
	bExitScript = false;
	msgCopy = MessageClass.static.Allocate(self).;
	Construct_Void();
	foreach AllProperties(MessageClass, Class'Engine.Message', PropName)
	{
		msgCopy.SetPropertyText(string(PropName), msg.GetPropertyText(string(PropName)));
	}
	if(EqualEqual_ObjectObject(currentMessage, none))
	{
		currentMessage = msgCopy;
		GotoState('ExecuteScript');
	}
	else
	{
		messageQueue[messageQueue.Length] = msgCopy;
	}
	return;
}

latent function executeScriptFromScriptAction(bool blockCallingScript)
{
	if(Not_PreBool(Enabled))
	{
		return;
	}
	if(bIsExecuting)
	{
		Log(Concat_StrStr(Concat_StrStr("Script ", string(Label)), " was denied execution because of attempted re-entry"));
		return;
	}
	bExitScript = false;
	if(blockCallingScript)
	{
		executeActions();
	}
	else
	{
		GotoState('ExecuteScript');
	}
	return;
}

private latent function executeActions()
{
	local int i;

	if(AndAnd_BoolBool(CampaignObjectiveSpecific, Not_PreBool(Level.Game.CampaignObjectivesAreInEffect())))
	{
		return;
	}
	SLog(Concat_StrStr("Starting execution of script ", string(Label)));
	bIsExecuting = true;
	i = 0;
	J0x67:

	if(AndAnd_BoolBool(Less_IntInt(i, Actions.Length), Not_PreBool(bExitScript)))
	{
		if(NotEqual_ObjectObject(Actions[i], none))
		{
			Actions[i].execute();
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x67;
	}
	if(NotEqual_ObjectObject(currentMessage, none))
	{
		Level.MessageDispatcher.deleteMessage(currentMessage);
		currentMessage = none;
	}
	destroyTempVariables();
	bIsExecuting = false;
	SLog(Concat_StrStr("Finished executing script ", string(Label)));
	return;
}

// Export UScript::execdestroyTempVariables(FFrame&, void* const)
native function destroyTempVariables();

function enumValidMessages(LevelInfo L, out array< Class<Message> > S)
{
	local Class C, Base;
	local Class<Message> M;
	local Actor triggeredByActor;
	local name triggeredByActorLabel;

	if(EqualEqual_StrStr(TriggeredBy, ""))
	{
		return;
	}
	if(AndAnd_BoolBool(NotEqual_StrStr(TriggeredBy, "all"), EqualEqual_IntInt(InStr(TriggeredBy, ","), -1)))
	{
		triggeredByActor = findStaticByLabel(Class'Engine.Actor', string(TriggeredBy));
	}
	if(NotEqual_ObjectObject(triggeredByActor, none))
	{
		triggeredByActorLabel = triggeredByActor.Label;
	}
	Base = Class'Engine.Message';
	foreach AllClasses(Base, C)
	{
		M = Class<Message>(C);
		if(AndAnd_BoolBool(NotEqual_ObjectObject(M.default.specificTo, none), NotEqual_StrStr(M.static.editorDisplay(triggeredByActorLabel, none), "")))
		{
			if(OrOr_BoolBool(EqualEqual_ObjectObject(triggeredByActor, none), triggeredByActor.IsA(M.default.specificTo.Name)))
			{
				S[S.Length] = M;
			}
		}
	}
	return;
}

function string editorDisplayMessage(Class<Message> Input)
{
	if(EqualEqual_StrStr(TriggeredBy, ""))
	{
		return "'TriggeredBy' is empty";
	}
	else
	{
		if(EqualEqual_ObjectObject(Input, none))
		{
			return "No message specified";
		}
		else
		{
			return Input.static.editorDisplay(string(TriggeredBy), messageFilter);
		}
	}
	return;
}

function string editorDisplayFilter(Message Input)
{
	local string DisplayString;
	local name PropName;
	local string filterProp;

	if(EqualEqual_ObjectObject(Input, none))
	{
		return "";
	}
	DisplayString = editorDisplayMessage(MessageClass);
	foreach AllEditableProperties(MessageClass, Class'Engine.Message', PropName)
	{
		filterProp = messageFilter.GetPropertyText(string(PropName));
		if(Not_PreBool(OrOr_BoolBool(OrOr_BoolBool(OrOr_BoolBool(EqualEqual_StrStr(filterProp, ""), EqualEqual_StrStr(filterProp, "None")), EqualEqual_StrStr(filterProp, "0")), EqualEqual_StrStr(filterProp, "0.00"))))
		{
			DisplayString = Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(DisplayString, ", "), string(PropName)), "="), filterProp);
		}
	}
	return DisplayString;
	return;
}

state ExecuteScript
{Begin:

	executeActions();
	if(Greater_IntInt(messageQueue.Length, 0))
	{
		currentMessage = messageQueue[0];
		messageQueue.Remove(0, 1);
		goto 'Begin';
	}
	else
	{
		GotoState('None');
	}
	stop;
}

defaultproperties
{
	Enabled=true
	bHidden=true
	bNoDelete=true
	Texture=Texture'EditorSprites.Sprite_Script'
}