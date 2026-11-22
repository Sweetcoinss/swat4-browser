class ActionGetMessageValue extends Action
	editinlinenew
	collapsecategories
	hidecategories(Object);

var name Property;

function messageProperties(LevelInfo Level, out array<name> S)
{
	local name PropName;

	if(EqualEqual_ObjectObject(parentScript.MessageClass, none))
	{
		logError("This script does not have a message class set for it");
		return;
	}
	foreach AllProperties(parentScript.MessageClass, Class'Engine.Message', PropName)
	{
		S[S.Length] = PropName;
	}
	return;
}

latent function Variable execute()
{
	local Message currMessage;
	local Class<Variable> varClass;
	local Variable V;
	local string val;

	currMessage = parentScript.triggeringMessage();
	if(EqualEqual_ObjectObject(currMessage, none))
	{
		return none;
	}
	val = currMessage.GetPropertyText(string(Property));
	Class'Scripting.Variable'.static.bestVariableClass(val, varClass);
	V = newTemporaryVariable(varClass);
	V.SetPropertyText("value", val);
	return V;
	return;
}

function editorDisplayString(out string S)
{
	S = Concat_StrStr(Concat_StrStr(string(parentScript.MessageClass.Name), "."), propertyDisplayString('Property'));
	return;
}

defaultproperties
{
	actionDisplayName="Get Message Value"
	actionHelp="Gets a value from the message that triggered the script"
	returnType=Class'Scripting.Variable'
	category="Script"
}