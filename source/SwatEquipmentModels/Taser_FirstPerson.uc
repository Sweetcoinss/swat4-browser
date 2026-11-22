class Taser_FirstPerson extends FiredWeaponModel
	config
	hidecategories(Karma,Advanced,Events,Force,LightColor,Lighting,Movement,Object,Sound);

defaultproperties
{
	ReloadAnimation="Reload"
	HolderReloadAnimation="taserReload"
	UseAnimation="Fire"
	HolderIdleAnimations=/* Array type was not detected. */
	HolderLowReadyIdleAnimation="1911lowready"
	HolderDisorientedLowReadyIdleAnimation="1911cantShoot"
	HolderEquipAnimation="1911equip"
	HolderUnequipAnimation="1911unequip"
	HolderUseAnimation="1911fire"
	EquippedSocket="1911Socket"
	Mesh=SkeletalMesh'FP_taser.FP_taser'
}