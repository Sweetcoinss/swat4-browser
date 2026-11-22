class SwatProjectile extends Actor
	native
	config
	notplaceable
	hidecategories(Karma);

defaultproperties
{
	Physics=2
	bAlwaysRelevant=true
	RemoteRole=2
	bCollideActors=true
	bCollideWorld=true
	bBounce=true
}