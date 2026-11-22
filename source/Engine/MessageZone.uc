class MessageZone extends Message
	editinlinenew;

var name Zone;
var name Instigator;

overloaded function Construct(name _zone, name _instigator)
{
	Zone = _zone;
	Instigator = _instigator;
	return;
}

static function string editorDisplay(name TriggeredBy, Message filter)
{
	return Concat_StrStr("Any zone message from ", string(TriggeredBy));
	return;
}

defaultproperties
{
	specificTo=Class'Engine.ZoneInfo'
}