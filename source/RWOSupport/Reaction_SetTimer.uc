class Reaction_SetTimer extends Reaction
	editinlinenew
	collapsecategories
	hidecategories(Object);

var(Reaction) float Time;
var(Reaction) bool Loop;

protected simulated function execute(Actor Owner, Actor Other)
{
	Owner.SetTimer(Time, Loop);
	return;
}
