class Reaction_TriggerUnrealEvent extends Reaction
	editinlinenew
	collapsecategories
	hidecategories(Object);

var(Reaction) name Event;
var(Reaction) bool bUnTrigger;

protected simulated function execute(Actor Owner, Actor Other)
{
	if(bUnTrigger)
	{
		Owner.UntriggerEvent(Event, Owner, Pawn(Owner));
	}
	else
	{
		Owner.TriggerEvent(Event, Owner, Pawn(Owner));
	}
	return;
}
