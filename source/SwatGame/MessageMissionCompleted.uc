class MessageMissionCompleted extends Message
	editinlinenew;

static function string editorDisplay(name TriggeredBy, Message filter)
{
	return "The Mission is Completed.";
	return;
}

defaultproperties
{
	specificTo=Class'Engine.PlayerController'
}