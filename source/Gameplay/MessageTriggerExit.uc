class MessageTriggerExit extends MessageTrigger
	editinlinenew;

static function string editorDisplay(name TriggeredBy, Message filter)
{
	return Concat_StrStr(Concat_StrStr("Trigger ", string(TriggeredBy)), " is exited");
	return;
}
