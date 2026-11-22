class MessageMoverPlayerBump extends MessageMover
	editinlinenew;

var name playerLabel;

overloaded function Construct(name _moverLabel, name _playerLabel)
{
	moverLabel = _moverLabel;
	playerLabel = _playerLabel;
	return;
}

static function string editorDisplay(name TriggeredBy, Message filter)
{
	return Concat_StrStr("The player bumps mover ", string(TriggeredBy));
	return;
}
