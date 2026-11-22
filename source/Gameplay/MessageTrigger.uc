class MessageTrigger extends Message
	editinlinenew;

var name Trigger;
var name Instigator;

overloaded function Construct(name _trigger, name _instigator)
{
	Trigger = _trigger;
	Instigator = _instigator;
	return;
}

static function string editorDisplay(name TriggeredBy, Message filter)
{
	return Concat_StrStr("Any trigger message from ", string(TriggeredBy));
	return;
}

defaultproperties
{
	specificTo=Class'Gameplay.Trigger'
}