class EffectEventTrigger extends Trigger
	config
	hidecategories(Karma);

var(Events) name EffectEvent;

simulated function DoTrigger(Pawn Instigator)
{
	local Actor A;

	if(EqualEqual_NameName(Event, 'None'))
	{
		return;
	}
	foreach DynamicActors(Class'Engine.Actor', A, Event)
	{
		A.TriggerEffectEvent(EffectEvent);
	}
	return;
}
