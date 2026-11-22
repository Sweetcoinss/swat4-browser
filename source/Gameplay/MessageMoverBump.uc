class MessageMoverBump extends MessageMover
	editinlinenew;

var name bumperLabel;

overloaded function Construct(name _moverLabel, name _bumperLabel)
{
	moverLabel = _moverLabel;
	bumperLabel = _bumperLabel;
	return;
}

static function string editorDisplay(name TriggeredBy, Message filter)
{
	return Concat_StrStr(Concat_StrStr("Mover ", string(TriggeredBy)), " is bumped");
	return;
}
