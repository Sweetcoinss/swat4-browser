class M4A1_FirstPerson extends FiredWeaponModel
	config
	hidecategories(Karma,Advanced,Events,Force,LightColor,Lighting,Movement,Object,Sound);

defaultproperties
{
	HolderBurstAnimation="M4A1fireAuto"
	HolderUseEmptyAnimation="M4A1fireEmpty"
	ReloadAnimation="reloadFull"
	EmptyReloadAnimation="reloadEmpty"
	HolderReloadAnimation="M4A1reloadFull"
	HolderEmptyReloadAnimation="M4A1reloadEmpty"
	HolderIdleAnimations=/* Array type was not detected. */
	HolderLowReadyIdleAnimation="M4A1LowReady"
	HolderDisorientedLowReadyIdleAnimation="1911cantShoot"
	HolderEquipAnimation="M4A1equip"
	HolderUnequipAnimation="M4A1unequip"
	HolderUseAnimation="M4A1fire"
	EquippedSocket="M4A1Socket"
	Mesh=SkeletalMesh'FP_M4A1mg.FP_M4A1mg'
}