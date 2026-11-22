class MessageBombDisarmed extends Message
	editinlinenew;

var name SpawnerGroup;
var name Spawner;

overloaded function Construct(name inSpawnerGroup, name inSpawner)
{
	SpawnerGroup = inSpawnerGroup;
	Spawner = inSpawner;
	return;
}

static function string editorDisplay(name TriggeredBy, Message filter)
{
	return "A bomb is disarmed.";
	return;
}

defaultproperties
{
	specificTo=Class'SwatGame.GameModeRD'
}