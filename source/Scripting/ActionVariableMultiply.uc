class ActionVariableMultiply extends Action
	editinlinenew
	collapsecategories
	hidecategories(Object);

var /*0x00000000-0x00100000*/ name lhs;
var string rhs;

latent function Variable execute()
{
	local Variable vLhs, Result;

	super.execute();
	vLhs = findVariable(string(lhs));
	if(EqualEqual_ObjectObject(vLhs, none))
	{
		logError("lhs of an arithmetic operation must be a variable");
		return none;
	}
	Result = newTemporaryVariable(vLhs.Class, vLhs.GetPropertyText("value"));
	Result.multiply(rhs);
	return Result;
	return;
}

function editorDisplayString(out string S)
{
	S = Concat_StrStr(Concat_StrStr(propertyDisplayString('lhs'), " * "), propertyDisplayString('rhs'));
	return;
}

defaultproperties
{
	actionDisplayName="Multiplication"
	actionHelp="Returns the result of the multiplication of one variable with another"
	returnType=Class'Scripting.Variable'
	category="Variable"
}