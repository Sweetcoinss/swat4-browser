class MessageMissionFailed extends Message
	editinlinenew;

static function string editorDisplay(name TriggeredBy, Message filter)
{
	return "The Mission is Failed.";
	return;
}

defaultproperties
{
	specificTo=Class'Engine.PlayerController'
}