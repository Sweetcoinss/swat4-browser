class Handler_TimerExpired extends Handler
	editinlinenew
	collapsecategories
	hidecategories(Object);

static final simulated function dispatch(array<Handler> Handlers, Actor Owner, Actor Other)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, Handlers.Length))
	{
		Handler_TimerExpired(Handlers[i]).Handle(Owner, Other);
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

simulated function Handle(Actor Owner, Actor Other)
{
	DoReactions(Owner, Other);
	return;
}
