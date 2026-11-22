class AK47_FirstPerson extends FiredWeaponModel
	config
	hidecategories(Karma,Advanced,Events,Force,LightColor,Lighting,Movement,Object,Sound);

defaultproperties
{
	HolderBurstAnimation="AK47fireAuto"
	HolderUseEmptyAnimation="AK47fireEmpty"
	ReloadAnimation="reloadFull"
	EmptyReloadAnimation="reloadEmpty"
	HolderReloadAnimation="AK47reloadFull"
	HolderEmptyReloadAnimation="AK47reloadEmpty"
	HolderIdleAnimations=/* Array type was not detected. */
	HolderLowReadyIdleAnimation="AK47LowReady"
	HolderDisorientedLowReadyIdleAnimation="1911cantShoot"
	HolderEquipAnimation="AK47equip"
	HolderUnequipAnimation="AK47unequip"
	HolderUseAnimation="AK47fire"
	EquippedSocket="M4A1Socket"
	Mesh=SkeletalMesh'FP_AK47.FP_AK47'
}