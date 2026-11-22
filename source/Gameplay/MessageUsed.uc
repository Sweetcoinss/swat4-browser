class MessageUsed extends Message
	editinlinenew;

var name User;
var name Usee;

overloaded function Construct(name inUser, name inUsee)
{
	User = inUser;
	Usee = inUsee;
	return;
}

static function string editorDisplay(name TriggeredBy, Message filter)
{
	if(NotEqual_NameName(TriggeredBy, 'None'))
	{
		return Concat_StrStr(string(TriggeredBy), " is Used");
	}
	else
	{
		return "Something is Used";
	}
	return;
}
