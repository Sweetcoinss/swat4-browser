class NotStatement extends ActionBool
	editinlinenew
	collapsecategories
	hidecategories(Object);

var bool rhs;

latent function Variable execute()
{
	local Variable rhsVAR;
	local VariableBool returnVar;

	super(Action).execute();
	rhsVAR = makeVariable(string(rhs));
	returnVar = VariableBool(newTemporaryVariable(Class'Scripting.VariableBool'));
	returnVar.Value = rhsVAR.not();
	return returnVar;
	return;
}

function editorDisplayString(out string S)
{
	S = Concat_StrStr(Concat_StrStr("NOT(", propertyDisplayString('lhs')), ")");
	return;
}

defaultproperties
{
	actionDisplayName="Not Statement"
	actionHelp="Returns the result of a logical not operation"
	category="Logic"
}