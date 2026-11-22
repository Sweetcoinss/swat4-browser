class StaticMeshActor extends Actor
	native
	config
	placeable
	hidecategories(Karma,Force,LightColor,Lighting,Object,Sound);

var bool bExactProjectileCollision;
var(Ballistics) float OverrideMomentumToPenetrate "If this is > -1, then OverrideMomentumToPenetrate is used instead of its Material's MomentumToPenetrate when calculating impact ballistics.";

simulated function float GetMomentumToPenetrate(Vector HitLocation, Vector HitNormal, Material MaterialHit)
{
	if(Greater_FloatFloat(OverrideMomentumToPenetrate, float(-1)))
	{
		return OverrideMomentumToPenetrate;
	}
	else
	{
		return MaterialHit.MomentumToPenetrate;
	}
	return;
}

defaultproperties
{
	bExactProjectileCollision=true
	OverrideMomentumToPenetrate=-1.0000000
	DrawType=8
	bStatic=true
	bWorldGeometry=true
	bShadowCast=true
	bStaticLighting=true
	bMovable=false
	CollisionRadius=1.0000000
	CollisionHeight=1.0000000
	bCollideActors=true
	bBlockActors=true
	bBlockPlayers=true
	bBlockKarma=true
	bBlockHavok=true
	bEdShouldSnap=true
}