class AndStatement extends ActionBool
	editinlinenew
	collapsecategories
	hidecategories(Object);

var bool lhs;
var bool rhs;

latent function Variable execute()
{
	local Variable lhsVAR;
	local VariableBool returnVar;

	super(Action).execute();
	lhsVAR = makeVariable(string(lhs));
	returnVar = VariableBool(newTemporaryVariable(Class'Scripting.VariableBool'));
	returnVar.Value = lhsVAR.and(string(rhs));
	return returnVar;
	return;
}

function editorDisplayString(out string S)
{
	S = Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("(", propertyDisplayString('lhs')), ") AND ("), propertyDisplayString('rhs')), ")");
	return;
}

defaultproperties
{
	actionDisplayName="And Statement"
	actionHelp="Returns the result of a logical and operation"
	category="Logic"
}