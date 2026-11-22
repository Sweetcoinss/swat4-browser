class ActionCreateWatcher extends Action
	editinlinenew
	collapsecategories
	hidecategories(Object);

var /*0x00000000-0x00100000*/ export editinline WatcherBase newWatcher;

latent function Variable execute()
{
	super.execute();
	if(NotEqual_ObjectObject(newWatcher, none))
	{
		if(newWatcher.Enabled)
		{
			newWatcher.GotoState('LookAtExpression');
		}
		parentScript.addWatcher(newWatcher);
	}
	else
	{
		logError("Tried to create an empty watcher");
	}
	return none;
	return;
}

function editorDisplayString(out string S)
{
	local string watcherDisplay, watcherName;

	watcherDisplay = "Do Nothing";
	watcherName = "Nothing";
	if(NotEqual_ObjectObject(newWatcher, none))
	{
		newWatcher.editorDisplayString(watcherDisplay);
		watcherName = string(newWatcher.watcherName);
	}
	S = Concat_StrStr(Concat_StrStr(Concat_StrStr("Create watcher '", watcherName), "' to: "), watcherDisplay);
	return;
}

defaultproperties
{
	actionDisplayName="Create a new watcher"
	actionHelp="Creates a new watcher and puts it in the scripts watcher list"
	category="Watch"
}