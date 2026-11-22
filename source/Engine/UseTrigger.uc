class UseTrigger extends Triggers
	config
	placeable
	hidecategories(Karma);

var localized string Message;

function UsedBy(Pawn User)
{
	TriggerEvent(Event, self, User);
	return;
}

function Touch(Actor Other)
{
	if(AndAnd_BoolBool(NotEqual_StrStr(Message, ""), NotEqual_ObjectObject(Other.Instigator, none)))
	{
		Other.Instigator.ClientMessage(Message);
	}
	return;
}
