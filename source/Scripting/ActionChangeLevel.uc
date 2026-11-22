class ActionChangeLevel extends Action
	editinlinenew
	collapsecategories
	hidecategories(Object);

var string MapName;
var bool bShowLoadingMessage;
var bool persist;

latent function Variable execute()
{
	super.execute();
	if(bShowLoadingMessage)
	{
		parentScript.Level.ServerTravel(MapName, persist);
	}
	else
	{
		parentScript.Level.ServerTravel(Concat_StrStr(MapName, "?quiet"), persist);
	}
	return none;
	return;
}

function editorDisplayString(out string S)
{
	S = Concat_StrStr("Change level to map ", propertyDisplayString('MapName'));
	return;
}

defaultproperties
{
	actionDisplayName="Change Level"
	actionHelp="Loads a new map"
	category="Level"
}