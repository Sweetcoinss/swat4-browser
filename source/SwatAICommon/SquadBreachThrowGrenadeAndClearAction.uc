class SquadBreachThrowGrenadeAndClearAction extends SquadBreachAndClearAction implements IInterestedInDetonatorEquipping
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

latent function PrepareToMoveSquad()
{
	MoveUpThrower();
	super.PrepareToMoveSquad();
	return;
}
