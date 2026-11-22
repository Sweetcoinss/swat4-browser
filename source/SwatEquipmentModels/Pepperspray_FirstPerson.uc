class Pepperspray_FirstPerson extends FiredWeaponModel
	config
	hidecategories(Karma,Advanced,Events,Force,LightColor,Lighting,Movement,Object,Sound);

defaultproperties
{
	EquipAnimation="Equip"
	UnequipAnimation="UnEquip"
	HolderIdleAnimations=/* Array type was not detected. */
	HolderLowReadyIdleAnimation="PeppersprayLowReady"
	HolderDisorientedLowReadyIdleAnimation="1911cantShoot"
	HolderEquipAnimation="PeppersprayEquip"
	HolderUnequipAnimation="PeppersprayUnequip"
	HolderUseAnimation="PeppersprayFire"
	EquippedSocket="PepperspraySocket"
	Mesh=SkeletalMesh'FP_Pepperspray.FP_Pepperspray'
}