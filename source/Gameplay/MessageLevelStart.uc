class MessageLevelStart extends Message;

var bool UsingCustomScenario;

overloaded function Construct(bool inUsingCustomScenario)
{
	UsingCustomScenario = inUsingCustomScenario;
	return;
}

static function string editorDisplay(name TriggeredBy, Message filter)
{
	return "The level starts";
	return;
}

defaultproperties
{
	specificTo=Class'Engine.GameInfo'
}