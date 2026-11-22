class Uzi_FirstPerson extends FiredWeaponModel
	config
	hidecategories(Karma,Advanced,Events,Force,LightColor,Lighting,Movement,Object,Sound);

defaultproperties
{
	HolderBurstAnimation="uziFireAuto"
	HolderUseEmptyAnimation="uziFireEmpty"
	EmptyReloadAnimation="reloadEmpty"
	HolderReloadAnimation="uziReloadFull"
	HolderEmptyReloadAnimation="uziReloadEmpty"
	HolderIdleAnimations=/* Array type was not detected. */
	HolderLowReadyIdleAnimation="uziLowReady"
	HolderDisorientedLowReadyIdleAnimation="1911cantShoot"
	HolderEquipAnimation="uziEquip"
	HolderUnequipAnimation="uziUnequip"
	HolderUseAnimation="uziFire"
	EquippedSocket="PaintballSocket"
	Mesh=SkeletalMesh'FP_uzi.FP_uzi'
}