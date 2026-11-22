class TruthStatement extends ActionBool
	editinlinenew
	collapsecategories
	hidecategories(Object);

var name Value;

latent function Variable execute()
{
	local Variable valueVar;
	local VariableBool returnVar;

	super(Action).execute();
	valueVar = makeVariable(string(Value));
	returnVar = VariableBool(newTemporaryVariable(Class'Scripting.VariableBool'));
	returnVar.Value = valueVar.truth();
	return returnVar;
	return;
}

function editorDisplayString(out string S)
{
	S = propertyDisplayString('Value');
	return;
}

defaultproperties
{
	actionDisplayName="Truth Statement"
	actionHelp="Returns value evaluated as a boolean"
	category="Logic"
}