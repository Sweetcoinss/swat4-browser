class OrStatement extends ActionBool
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
	returnVar.Value = lhsVAR.or(string(rhs));
	return returnVar;
	return;
}

function editorDisplayString(out string S)
{
	S = Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("(", propertyDisplayString('lhs')), ") OR ("), propertyDisplayString('rhs')), ")");
	return;
}

defaultproperties
{
	actionDisplayName="Or Statement"
	actionHelp="Returns the result of a logical or operation"
	category="Logic"
}