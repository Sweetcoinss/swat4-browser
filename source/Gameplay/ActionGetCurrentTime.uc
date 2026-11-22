class ActionGetCurrentTime extends Action
	editinlinenew
	collapsecategories
	hidecategories(Object);

latent function Variable execute()
{
	return newTemporaryVariable(Class'Scripting.VariableFloat', string(parentScript.Level.TimeSeconds));
	return;
}

function editorDisplayString(out string S)
{
	S = "The current time";
	return;
}

defaultproperties
{
	actionDisplayName="Get Current Time"
	actionHelp="Gets the current time"
	returnType=Class'Scripting.VariableFloat'
	category="Script"
}