interface ICanUseProtectiveEquipment implements IHaveSkeletalRegions
	parseconfig;

simulated function SetProtection(Actor.ESkeletalRegion Region, ProtectiveEquipment Protection)
{
	return;
}

simulated function bool HasProtection(name ProtectionClass)
{
	return;
}

simulated function SkeletalRegionInformation GetSkeletalRegionInformation(Actor.ESkeletalRegion Region)
{
	return;
}

simulated function ProtectiveEquipment GetSkeletalRegionProtection(Actor.ESkeletalRegion Region)
{
	return;
}
