class MessageTimerExpired extends Message;

static function string editorDisplay(name TriggeredBy, Message filter)
{
	return Concat_StrStr(Concat_StrStr("The timer for ", string(TriggeredBy)), " expires");
	return;
}

defaultproperties
{
	specificTo=Class'Scripting.Script'
}