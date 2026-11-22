class ActionScriptNote extends Action
	editinlinenew
	collapsecategories
	hidecategories(Object);

var /*0x00000000-0x00100000*/ string Note;

latent function Variable execute()
{
	return none;
	return;
}

function editorDisplayString(out string S)
{
	S = Note;
	return;
}

defaultproperties
{
	actionDisplayName="Script Note"
	actionHelp="Does nothing at runtime, but allows for notes to be added to a script"
	category="Other"
}