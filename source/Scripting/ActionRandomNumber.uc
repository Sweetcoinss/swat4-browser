class ActionRandomNumber extends Action
	editinlinenew
	collapsecategories
	hidecategories(Object);

var float minimum;
var float maximum;

latent function Variable execute()
{
	local int forceWholeNumber;

	super.execute();
	forceWholeNumber = int(Add_FloatFloat(float(int(Add_FloatFloat(Multiply_FloatFloat(FRand(), Subtract_FloatFloat(maximum, minimum)), minimum))), 0.5000000));
	return newTemporaryVariable(Class'Scripting.VariableFloat', string(forceWholeNumber));
	return;
}

function editorDisplayString(out string S)
{
	S = Concat_StrStr(Concat_StrStr(Concat_StrStr("A random number between ", propertyDisplayString('minimum')), " and "), propertyDisplayString('maximum'));
	return;
}

defaultproperties
{
	maximum=1.0000000
	actionDisplayName="Random Number"
	actionHelp="Generates a random number within a given range"
	returnType=Class'Scripting.Variable'
	category="Variable"
}