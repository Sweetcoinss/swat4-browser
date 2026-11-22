class CSgasGrenade_FirstPerson extends ThrownWeaponModel
	config
	collapsecategories
	hidecategories(Karma,Advanced,Events,Force,LightColor,Lighting,Movement,Object,Sound);

defaultproperties
{
	EquipAnimation="Equip"
	UseAnimation="Throw"
	HolderIdleAnimations=/* Array type was not detected. */
	HolderDisorientedLowReadyIdleAnimation="1911cantShoot"
	HolderEquipAnimation="GrenadeEquip"
	HolderUnequipAnimation="GrenadeUnequip"
	HolderUseAnimation="GrenadeThrow"
	EquippedSocket="GrenadeSocket"
	Mesh=SkeletalMesh'FP_csGasGrenade.FP_csGasGrenade'
}