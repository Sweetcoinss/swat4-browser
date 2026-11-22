class ActionExitScript extends Action
	editinlinenew
	collapsecategories
	hidecategories(Object);

var name targetScript;

latent function Variable execute()
{
	local Script S;

	super.execute();
	foreach parentScript.actorLabel(Class'Scripting.Script', S, targetScript)
	{
		S.Exit();
	}
	return none;
	return;
}

function editorDisplayString(out string S)
{
	S = Concat_StrStr("Exit script ", propertyDisplayString('targetScript'));
	return;
}

defaultproperties
{
	actionDisplayName="Exit Script"
	actionHelp="Ends execution of a script"
	category="Script"
}