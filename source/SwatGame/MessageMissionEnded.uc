class MessageMissionEnded extends Message
	editinlinenew;

static function string editorDisplay(name TriggeredBy, Message filter)
{
	return "The Mission has Ended.";
	return;
}

defaultproperties
{
	specificTo=Class'Engine.PlayerController'
}