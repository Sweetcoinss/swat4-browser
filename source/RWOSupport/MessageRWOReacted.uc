class MessageRWOReacted extends Message
	editinlinenew;

var name RWO;

overloaded function Construct(name _RWO, name _instigator)
{
	RWO = _RWO;
	return;
}

static function string editorDisplay(name TriggeredBy, Message filter)
{
	return Concat_StrStr(string(TriggeredBy), " executes a Reaction_RunScript");
	return;
}

defaultproperties
{
	specificTo=Class'RWOSupport.ReactiveWorldObject'
}