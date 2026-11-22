class MP5_FirstPerson extends FiredWeaponModel
	config
	hidecategories(Karma,Advanced,Events,Force,LightColor,Lighting,Movement,Object,Sound);

defaultproperties
{
	HolderBurstAnimation="mp5FireAuto"
	HolderUseEmptyAnimation="MP5fireEmpty"
	ReloadAnimation="reloadFull"
	EmptyReloadAnimation="reloadEmpty"
	HolderReloadAnimation="MP5reloadFull"
	HolderEmptyReloadAnimation="MP5reloadEmpty"
	HolderIdleAnimations=/* Array type was not detected. */
	HolderLowReadyIdleAnimation="MP5LowReady"
	HolderDisorientedLowReadyIdleAnimation="1911cantShoot"
	HolderEquipAnimation="MP5equip"
	HolderUnequipAnimation="MP5unequip"
	HolderUseAnimation="MP5fire"
	EquippedSocket="MP5Socket"
	Mesh=SkeletalMesh'FP_mp5SMG.1st_mp5'
}