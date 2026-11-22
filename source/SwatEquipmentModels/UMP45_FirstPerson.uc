class UMP45_FirstPerson extends FiredWeaponModel
	config
	hidecategories(Karma,Advanced,Events,Force,LightColor,Lighting,Movement,Object,Sound);

defaultproperties
{
	HolderBurstAnimation="UMPfireAuto"
	HolderUseEmptyAnimation="UMPfireEmpty"
	ReloadAnimation="reloadFull"
	EmptyReloadAnimation="reloadEmpty"
	HolderReloadAnimation="UMPreloadFull"
	HolderEmptyReloadAnimation="UMPreloadEmpty"
	HolderIdleAnimations=/* Array type was not detected. */
	HolderLowReadyIdleAnimation="UMPlowReady"
	HolderDisorientedLowReadyIdleAnimation="1911cantShoot"
	HolderEquipAnimation="UMPequip"
	HolderUnequipAnimation="UMPunequip"
	HolderUseAnimation="UMPfire"
	EquippedSocket="MP5Socket"
	Mesh=SkeletalMesh'FP_UMPsmg.FP_UMPsmg'
}