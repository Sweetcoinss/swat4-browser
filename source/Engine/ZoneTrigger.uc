class ZoneTrigger extends Trigger
	config
	placeable
	hidecategories(Karma);

function Touch(Actor Other)
{
	local ZoneInfo Z;

	if(IsRelevant(Other))
	{
		if(NotEqual_NameName(Event, 'None'))
		{
			foreach AllActors(Class'Engine.ZoneInfo', Z)
			{
				if(EqualEqual_NameName(Z.ZoneTag, Event))
				{
					Z.Trigger(Other, Other.Instigator);
				}
			}
		}
		if(NotEqual_StrStr(Message, ""))
		{
			Other.Instigator.ClientMessage(Message);
		}
		if(bTriggerOnceOnly)
		{
			SetCollision(false);
		}
	}
	return;
}

function UnTouch(Actor Other)
{
	local ZoneInfo Z;

	if(IsRelevant(Other))
	{
		if(NotEqual_NameName(Event, 'None'))
		{
			foreach AllActors(Class'Engine.ZoneInfo', Z)
			{
				if(EqualEqual_NameName(Z.ZoneTag, Event))
				{
					Z.UnTrigger(Other, Other.Instigator);
				}
			}
		}
	}
	return;
}
