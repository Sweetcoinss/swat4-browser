class ActionEnableWatcher extends ActionSetWatcherEnabled
	editinlinenew
	collapsecategories
	hidecategories(Object);

function editorDisplayString(out string S)
{
	S = Concat_StrStr(Concat_StrStr(Concat_StrStr("Enable watcher ", propertyDisplayString('scriptName')), "."), propertyDisplayString('watcherName'));
	return;
}

defaultproperties
{
	Enabled=true
	actionDisplayName="Enable Watcher"
	actionHelp="Enables a watcher in a given script"
	category="Watch"
}