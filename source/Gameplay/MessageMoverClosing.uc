class MessageMoverClosing extends MessageMover;

static function string editorDisplay(name TriggeredBy, Message filter)
{
	return Concat_StrStr(Concat_StrStr("Mover ", string(TriggeredBy)), " begins to close");
	return;
}
