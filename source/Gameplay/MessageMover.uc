class MessageMover extends Message
	abstract;

var name moverLabel;

overloaded function Construct(name _moverLabel)
{
	moverLabel = _moverLabel;
	return;
}

static function string editorDisplay(name TriggeredBy, Message filter)
{
	return Concat_StrStr("Any mover message from ", string(TriggeredBy));
	return;
}

defaultproperties
{
	specificTo=Class'Engine.Mover'
}