class MessageTriggerVolume extends Message
	editinlinenew;

var name TriggerVolume;
var name Instigator;

overloaded function Construct(name _triggerVolume, name _instigator)
{
	TriggerVolume = _triggerVolume;
	Instigator = _instigator;
	return;
}

static function string editorDisplay(name TriggeredBy, Message filter)
{
	return Concat_StrStr("Any TriggerVolume message from ", string(TriggeredBy));
	return;
}

defaultproperties
{
	specificTo=Class'Gameplay.TriggerVolume'
}