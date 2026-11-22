class VIPgrenade_FirstPerson extends ThrownWeaponModel
	config
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