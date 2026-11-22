class BreachingShotgun extends Shotgun implements IFrangibleBreachingDamageType
	config(SwatEquipment)
	hidecategories(Karma);

simulated function bool HandleBallisticImpact(Actor Victim, Vector HitLocation, Vector HitNormal, Vector NormalizedBulletDirection, Material HitMaterial, Actor.ESkeletalRegion HitRegion, out float Momentum, Vector ExitLocation, Vector ExitNormal, Material ExitMaterial)
{
	if(Victim.IsA('SwatDoor'))
	{
		IHaveSkeletalRegions(Victim).OnSkeletalRegionHit(HitRegion, HitLocation, HitNormal, 0, GetDamageType(), Owner);
	}
	return super(FiredWeapon).HandleBallisticImpact(Victim, HitLocation, HitNormal, NormalizedBulletDirection, HitMaterial, HitRegion, Momentum, ExitLocation, ExitNormal, ExitMaterial);
	return;
}
