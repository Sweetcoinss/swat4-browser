class Reaction_UseSelf extends Reaction
	editinlinenew
	collapsecategories
	hidecategories(Object);

protected simulated function execute(Actor Owner, Actor Other)
{
	Owner.ReactToUsed(Other);
	return;
}
