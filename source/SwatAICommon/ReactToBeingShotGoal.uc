class ReactToBeingShotGoal extends SwatCharacterGoal
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) Vector HitLocation;
var(Parameters) Vector HitNormal;
var(Parameters) Actor.ESkeletalRegion RegionHit;

overloaded function Construct(AI_Resource R, Actor.ESkeletalRegion inRegionHit, Vector inHitLocation, Vector inHitNormal)
{
	construct_AI_Resource(R);
	RegionHit = inRegionHit;
	HitLocation = inHitLocation;
	HitNormal = inHitNormal;
	return;
}

defaultproperties
{
	Priority=99
	goalName="ReactToBeingShot"
}