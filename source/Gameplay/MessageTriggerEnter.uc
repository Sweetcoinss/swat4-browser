class MessageTriggerEnter extends MessageTrigger
	editinlinenew;

static function string editorDisplay(name TriggeredBy, Message filter)
{
	return Concat_StrStr(Concat_StrStr("Trigger ", string(TriggeredBy)), " is entered");
	return;
}
