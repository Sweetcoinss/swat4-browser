class Reaction_TriggerSelf extends Reaction
	editinlinenew
	collapsecategories
	hidecategories(Object);

protected simulated function execute(Actor Owner, Actor Other)
{
	Owner.PreTrigger(Owner, Pawn(Other));
	Owner.Trigger(Owner, Pawn(Other));
	return;
}
