class Reaction_SetCollision extends Reaction
	editinlinenew
	collapsecategories
	hidecategories(Object);

var(Reaction) bool CollideActors;
var(Reaction) bool BlockActors;
var(Reaction) bool BlockPlayers;

protected simulated function execute(Actor Owner, Actor Other)
{
	Owner.SetCollision(CollideActors, BlockActors, BlockPlayers);
	return;
}
