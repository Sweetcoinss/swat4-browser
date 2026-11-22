class ActionBool extends Action
	abstract
	native
	editinlinenew
	collapsecategories
	hidecategories(Object);

function Variable makeVariable(string val)
{
	local Class<Variable> varClass;
	local Variable V;

	Class'Scripting.Variable'.static.bestVariableClass(val, varClass);
	V = newTemporaryVariable(varClass);
	V.SetPropertyText("value", val);
	return V;
	return;
}

function editorDisplayString(out string S)
{
	return;
}

defaultproperties
{
	returnType=Class'Scripting.VariableBool'
}