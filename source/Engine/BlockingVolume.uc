class BlockingVolume extends Volume
	native
	config
	notplaceable
	hidecategories(Karma,Events,Force,Karma,LightColor,Lighting,Sound,Object);

var bool bClampFluid;
var bool bIsStairs "Set this to true if this stairway is being as a ramp for stairs";

defaultproperties
{
	bClampFluid=true
	bOccludedByGeometryInEditor=true
	bWorldGeometry=true
	bBlockActors=true
	bBlockPlayers=true
	bBlockZeroExtentTraces=false
	bBlockKarma=true
}