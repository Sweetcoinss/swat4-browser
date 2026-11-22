class M4Super90_FirstPerson extends FiredWeaponModel
	config
	hidecategories(Karma,Advanced,Events,Force,LightColor,Lighting,Movement,Object,Sound);

defaultproperties
{
	HolderUseEmptyAnimation="m4super90FireEmpty"
	HolderReloadAnimation="m4super90reloadLoop"
	HolderEmptyReloadAnimation="M4super90ReloadEmpty"
	HolderIdleAnimations=/* Array type was not detected. */
	HolderLowReadyIdleAnimation="M4super90LowReady"
	HolderDisorientedLowReadyIdleAnimation="1911cantShoot"
	HolderEquipAnimation="M4super90equip"
	HolderUnequipAnimation="M4super90unequip"
	HolderUseAnimation="M4super90fire"
	EquippedSocket="M4super90Socket"
	Mesh=SkeletalMesh'FP_m4super90sg.FP_m4super90sg'
}