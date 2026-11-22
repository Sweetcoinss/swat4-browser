class MessageConversationEnded extends Message
	editinlinenew;

var bool Completed;

overloaded function Construct(bool inCompleted)
{
	Completed = inCompleted;
	return;
}

static function string editorDisplay(name TriggeredBy, Message filter)
{
	return "A conversation ends";
	return;
}

defaultproperties
{
	specificTo=none
}