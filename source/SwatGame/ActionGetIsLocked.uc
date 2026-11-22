class ActionGetIsLocked extends Action
	editinlinenew
	collapsecategories
	hidecategories(Object);

var name Door;

latent function Variable execute()
{
	local SwatDoor D;
	local string val;
	local Class<Variable> bestClass;

	super.execute();
	D = SwatDoor(findByLabel(Class'SwatGame.SwatDoor', Door));
	if(EqualEqual_ObjectObject(D, none))
	{
		logError(Concat_StrStr(Concat_StrStr("door ", string(Door)), " not found"));
	}
	else
	{
		val = string(D.IsLocked());
		Class'Scripting.Variable'.static.bestVariableClass(val, bestClass);
		return newTemporaryVariable(bestClass, val);
	}
	return none;
	return;
}

function editorDisplayString(out string S)
{
	S = "Get Door IsLocked";
	return;
}

event enumScriptLabels(LevelInfo Level, out array<name> S)
{
	local SwatDoor D;

	foreach Level.AllActors(Class'SwatGame.SwatDoor', D)
	{
		if(AndAnd_BoolBool(NotEqual_NameName(D.Label, D.Name), NotEqual_NameName(D.Label, 'None')))
		{
			S[S.Length] = D.Label;
		}
	}
	return;
}

defaultproperties
{
	actionDisplayName="Get Door IsLocked"
	actionHelp="Returns true if the specified Door is locked, and false otherwise"
	returnType=Class'Scripting.Variable'
	category="Door"
}