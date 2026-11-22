class ActionVariableAssign extends Action
	editinlinenew
	collapsecategories
	hidecategories(Object);

var /*0x00000000-0x00100000*/ name lhs;
var string rhs;

latent function Variable execute()
{
	local Variable vLhs;
	local Class<Variable> NewClass;

	super.execute();
	vLhs = tryFindVariable(string(lhs));
	if(EqualEqual_ObjectObject(vLhs, none))
	{
		if(NotEqual_IntInt(InStr(string(lhs), "."), -1))
		{
			logError(Concat_StrStr(Concat_StrStr("You can only create variables that reside within the current script (variable ", string(lhs)), " not found)"));
			return none;
		}
		Class'Scripting.Variable'.static.bestVariableClass(rhs, NewClass);
		vLhs = newVariable(lhs, NewClass);
	}
	vLhs.SetPropertyText("value", rhs);
	return none;
	return;
}

function editorDisplayString(out string S)
{
	S = Concat_StrStr(Concat_StrStr(propertyDisplayString('lhs'), " = "), propertyDisplayString('rhs'));
	return;
}

defaultproperties
{
	actionDisplayName="Assignment"
	actionHelp="Assigns one variable to another"
	category="Variable"
	acceptAllTypes=true
}