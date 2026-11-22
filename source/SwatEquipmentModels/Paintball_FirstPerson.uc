class Paintball_FirstPerson extends FiredWeaponModel
	config
	hidecategories(Karma,Advanced,Events,Force,LightColor,Lighting,Movement,Object,Sound);

defaultproperties
{
	HolderReloadAnimation="PaintballReload"
	HolderIdleAnimations=/* Array type was not detected. */
	HolderLowReadyIdleAnimation="PaintballLowReady"
	HolderDisorientedLowReadyIdleAnimation="1911cantShoot"
	HolderEquipAnimation="PaintballEquip"
	HolderUnequipAnimation="PaintballUnequip"
	HolderUseAnimation="PaintballFire"
	EquippedSocket="PaintballSocket"
	Mesh=SkeletalMesh'FP_paintball.FP_paintball'
}