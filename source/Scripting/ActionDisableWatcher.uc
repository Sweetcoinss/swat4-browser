class ActionDisableWatcher extends ActionSetWatcherEnabled
	editinlinenew
	collapsecategories
	hidecategories(Object);

function editorDisplayString(out string S)
{
	S = Concat_StrStr(Concat_StrStr(Concat_StrStr("Disable watcher ", propertyDisplayString('scriptName')), "."), propertyDisplayString('watcherName'));
	return;
}

defaultproperties
{
	actionDisplayName="Disable Watcher"
	actionHelp="Disables a watcher in a given script"
	category="Watch"
}