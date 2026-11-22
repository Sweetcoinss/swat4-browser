class MessageZoneEntered extends MessageZone
	editinlinenew;

static function string editorDisplay(name TriggeredBy, Message filter)
{
	return Concat_StrStr(Concat_StrStr("Zone ", string(TriggeredBy)), " is entered");
	return;
}
