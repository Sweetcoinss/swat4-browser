class ActionStartTimer extends Action
	editinlinenew
	collapsecategories
	hidecategories(Object);

var float Seconds;

latent function Variable execute()
{
	super.execute();
	parentScript.SetTimer(Seconds, false);
	return none;
	return;
}

function editorDisplayString(out string S)
{
	S = Concat_StrStr(Concat_StrStr("Start timer for ", propertyDisplayString('Seconds')), " second");
	if(NotEqual_FloatFloat(Seconds, 1.0000000))
	{
		S = Concat_StrStr(S, "s");
	}
	return;
}

defaultproperties
{
	actionDisplayName="Start Timer"
	actionHelp="Starts a timer that will send a timer expired message after n seconds."
	category="Script"
}