class Reaction_ChangeTag extends Reaction
	editinlinenew
	collapsecategories
	hidecategories(Object);

var(Reaction) name OldTag;
var(Reaction) name NewTag;

protected simulated function execute(Actor Owner, Actor Other)
{
	local Actor Current;

	foreach Owner.DynamicActors(Class'Engine.Actor', Current, OldTag)
	{
		Current.Tag = NewTag;
	}
	return;
}
