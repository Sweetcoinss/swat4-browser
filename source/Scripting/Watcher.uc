class Watcher extends WatcherBase
	editinlinenew
	collapsecategories
	hidecategories(Object);

var bool watchedExpression;

latent function Variable execute()
{
	if(Not_PreBool(Enabled))
	{
		return none;
	}
	super(Action).execute();
	if(watchedExpression)
	{
		Enabled = false;
		parentScript.dispatchMessage(Class'Scripting.MessageWatcher'.static.Allocate(self)., construct_NameName(parentScript.Label, watcherName));
	}
	return none;
	return;
}

function editorDisplayString(out string S)
{
	S = Concat_StrStr(Concat_StrStr("Send a watch message when ", propertyDisplayString('watchedExpression')), " is true");
	return;
}

state LookAtExpression
{	J0x00:
	if(Enabled)
	{
		Sleep(1.0000000);
		execute();
		// [Loop Continue]
		goto J0x00;
	}
	stop;
}

defaultproperties
{
	actionDisplayName="Watcher"
	actionHelp="Sends a watcher message if the watched expression is true"
	category="Watch"
}