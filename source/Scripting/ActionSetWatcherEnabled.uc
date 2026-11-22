class ActionSetWatcherEnabled extends Action
	abstract
	editinlinenew
	collapsecategories
	hidecategories(Object);

var name scriptName;
var name watcherName;
var private bool Enabled;

latent function Variable execute()
{
	local Script S;

	super.execute();
	if(NotEqual_NameName(scriptName, 'None'))
	{
		foreach parentScript.actorLabel(Class'Scripting.Script', S, scriptName)
		{
			S.setWatcherEnabled(watcherName, Enabled);
		}
	}
	else
	{
		parentScript.setWatcherEnabled(watcherName, Enabled);
	}
	return none;
	return;
}
