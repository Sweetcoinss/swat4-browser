class ActionWait extends Action
	editinlinenew
	collapsecategories
	hidecategories(Object);

var float Seconds;

latent function Variable execute()
{
	super.execute();
	Sleep(Seconds);
	return none;
	return;
}

function editorDisplayString(out string S)
{
	S = Concat_StrStr(Concat_StrStr("Wait ", propertyDisplayString('Seconds')), " second");
	if(NotEqual_FloatFloat(Seconds, 1.0000000))
	{
		S = Concat_StrStr(S, "s");
	}
	return;
}

defaultproperties
{
	Seconds=1.0000000
	actionDisplayName="Wait n seconds"
	actionHelp="Suspends this script for n seconds"
	category="Script"
}