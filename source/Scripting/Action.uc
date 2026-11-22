class Action extends Object
	abstract
	native
	editinlinenew
	collapsecategories
	hidecategories(Object);

cpptext
{
	virtual void CleanupDestroyed();

}

struct native ParameterResolveInfo
{
	var export Action Action;
	var name Variable;
	var name PropertyName;
};

var string actionDisplayName;
var string actionHelp;
var Class<Variable> returnType;
var string category;
var Script parentScript;
var bool acceptAllTypes;
var array<ParameterResolveInfo> resolveInfoList;

overloaded function Construct()
{
	parentScript = Script(Outer);
	assert(NotEqual_ObjectObject(parentScript, none));
	return;
}

function setParentScript(Script S)
{
	parentScript = S;
	return;
}

// Export UAction::execSetActionPropertyText(FFrame&, void* const)
native final function SetActionPropertyText(string PropName, string PropValue);

private latent function resolveParameters()
{
	local int i;
	local name PropName;
	local Variable V;
	local array<int> resolveActions;

	foreach AllProperties(self.Class, Class'Scripting.Action', PropName)
	{
		i = 0;
		J0x24:

		if(Less_IntInt(i, resolveInfoList.Length))
		{
			if(EqualEqual_NameName(resolveInfoList[i].PropertyName, PropName))
			{
				if(NotEqual_ObjectObject(resolveInfoList[i].Action, none))
				{
					resolveActions.Length = Add_IntInt(resolveActions.Length, 1);
					resolveActions[Subtract_IntInt(resolveActions.Length, 1)] = i;
					// [Explicit Continue]
					goto J0x166;
				}
				if(NotEqual_NameName(resolveInfoList[i].Variable, 'None'))
				{
					V = tryFindVariable(string(resolveInfoList[i].Variable));
					if(NotEqual_ObjectObject(V, none))
					{
						SetActionPropertyText(string(PropName), V.GetPropertyText("value"));
					}
					// [Explicit Continue]
					goto J0x166;
				}
				logError(Concat_StrStr(Concat_StrStr("Parameter ", string(PropName)), " has an entry in the resolveinfo map, but has no action or variable resolve target"));
			}
			J0x166:

			AddAdd_Int(i);
			// [Loop Continue]
			goto J0x24;
		}
	}
	i = 0;
	J0x179:

	if(Less_IntInt(i, resolveActions.Length))
	{
		resolveInfoList[resolveActions[i]].Action.execute();
		V = ;
		return if(NotEqual_ObjectObject(V, none))
		{
			SetActionPropertyText(string(resolveInfoList[resolveActions[i]].PropertyName), V.GetPropertyText("value"));
			// [Explicit Continue]
			goto J0x213;
		}
		SetPropertyText(string(resolveInfoList[resolveActions[i]].PropertyName), "");
		J0x213:

		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x179;
	}
	return;
}

function logError(string Reason)
{
	local string S;

	editorDisplayString(S);
	S = Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("ERROR: ", string(parentScript.Name)), ", Action "), S), ": "), Reason);
	SLog(S);
	return;
}

function Actor findByLabel(Class<Actor> actorClass, name Label)
{
	return parentScript.findByLabel(actorClass, Label);
	return;
}

function Actor findStaticByLabel(Class<Actor> actorClass, name Label)
{
	return parentScript.findStaticByLabel(actorClass, Label);
	return;
}

function Variable newVariable(name VariableName, Class<Variable> variableType)
{
	return parentScript.newVariable(VariableName, variableType);
	return;
}

function Variable newTemporaryVariable(Class<Variable> variableType, optional string initValue)
{
	return parentScript.newTemporaryVariable(variableType, initValue);
	return;
}

function Variable findVariable(coerce string VariableName)
{
	local Variable V;

	V = Class'Scripting.Variable'.static.findVariable(VariableName, parentScript);
	if(EqualEqual_ObjectObject(V, none))
	{
		logError(Concat_StrStr(Concat_StrStr("Variable ", VariableName), " not found"));
	}
	return V;
	return;
}

function Variable tryFindVariable(coerce string VariableName)
{
	local Variable V;

	V = Class'Scripting.Variable'.static.findVariable(VariableName, parentScript);
	return V;
	return;
}

latent function Variable execute()
{
	resolveParameters();
	return none;
	return;
}

function string propertyDisplayString(name PropName)
{
	local string S;
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, resolveInfoList.Length))
	{
		if(EqualEqual_NameName(resolveInfoList[i].PropertyName, PropName))
		{
			if(NotEqual_ObjectObject(resolveInfoList[i].Action, none))
			{
				resolveInfoList[i].Action.editorDisplayString(S);
				return S;
				// [Explicit Continue]
				goto J0x9C;
			}
			if(NotEqual_NameName(resolveInfoList[i].Variable, 'None'))
			{
				return string(resolveInfoList[i].Variable);
			}
		}
		J0x9C:

		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	return GetPropertyText(string(PropName));
	return;
}

event editorDisplayString(out string S)
{
	S = actionDisplayName;
	return;
}

event enumScriptLabels(LevelInfo Level, out array<name> S)
{
	local Actor A;

	foreach Level.AllActors(Class'Engine.Actor', A)
	{
		if(AndAnd_BoolBool(NotEqual_NameName(A.Label, A.Name), NotEqual_NameName(A.Label, 'None')))
		{
			S[S.Length] = A.Label;
		}
	}
	return;
}

event enumScripts(LevelInfo Level, out array<name> S)
{
	local Script aScript;

	foreach Level.AllActors(Class'Scripting.Script', aScript)
	{
		if(NotEqual_NameName(aScript.Label, 'None'))
		{
			S[S.Length] = aScript.Label;
		}
	}
	return;
}

defaultproperties
{
	actionDisplayName="<actionDisplayName>"
	actionHelp="<actionHelp>"
	category="Default Category"
}