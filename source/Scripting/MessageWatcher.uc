class MessageWatcher extends Message
	editinlinenew;

var name scriptName;
var name watcherName;

overloaded function Construct(name _scriptName, name _watcherName)
{
	scriptName = _scriptName;
	watcherName = _watcherName;
	return;
}

static function string editorDisplay(name TriggeredBy, Message filter)
{
	return Concat_StrStr("A watcher message from ", string(TriggeredBy));
	return;
}

defaultproperties
{
	specificTo=Class'Scripting.Script'
}