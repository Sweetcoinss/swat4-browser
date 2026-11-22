class MessageTriggerVolumeExit extends MessageTriggerVolume
	editinlinenew;

static function string editorDisplay(name TriggeredBy, Message filter)
{
	return Concat_StrStr(Concat_StrStr("TriggerVolume ", string(TriggeredBy)), " is exited");
	return;
}
