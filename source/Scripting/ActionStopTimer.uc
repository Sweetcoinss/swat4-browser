class ActionStopTimer extends Action
	editinlinenew
	collapsecategories
	hidecategories(Object);

var name scriptLabel;

latent function Variable execute()
{
	local Script S;

	super.execute();
	foreach parentScript.actorLabel(Class'Scripting.Script', S, scriptLabel)
	{
		S.SetTimer(0.0000000, false);
	}
	return none;
	return;
}

function editorDisplayString(out string S)
{
	S = Concat_StrStr("Stop timer for ", propertyDisplayString('scriptLabel'));
	return;
}

defaultproperties
{
	actionDisplayName="Stop Timer"
	actionHelp="Stops the timer for all scripts with the given label"
	category="Script"
}