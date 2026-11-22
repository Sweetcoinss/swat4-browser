interface IHaveSkeletalRegions
	parseconfig;

simulated function OnSkeletalRegionHit(Actor.ESkeletalRegion RegionHit, Vector HitLocation, Vector HitNormal, int Damage, Class<DamageType> DamageType, Actor Instigator)
{
	return;
}
