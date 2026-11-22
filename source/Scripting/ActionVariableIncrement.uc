class ActionVariableIncrement extends Action
	editinlinenew
	collapsecategories
	hidecategories(Object);

var /*0x00000000-0x00100000*/ name Target;

latent function Variable execute()
{
	local Variable vTarget, Result;

	super.execute();
	vTarget = findVariable(string(Target));
	if(EqualEqual_ObjectObject(vTarget, none))
	{
		logError("Target of the increment operation must be a variable");
		return none;
	}
	vTarget.Add("1");
	Result = newTemporaryVariable(vTarget.Class, vTarget.GetPropertyText("value"));
	return Result;
	return;
}

function editorDisplayString(out string S)
{
	S = Concat_StrStr("Increment ", propertyDisplayString('Target'));
	return;
}

defaultproperties
{
	actionDisplayName="Increment"
	actionHelp="Adds 1 to the variable"
	returnType=Class'Scripting.Variable'
	category="Variable"
}