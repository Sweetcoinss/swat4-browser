class FragGrenade_FirstPerson extends ThrownWeaponModel
	config
	collapsecategories
	hidecategories(Karma,Advanced,Events,Force,LightColor,Lighting,Movement,Object,Sound);

defaultproperties
{
	UseAnimation="Throw"
	HolderIdleAnimations=/* Array type was not detected. */
	HolderDisorientedLowReadyIdleAnimation="1911cantShoot"
	HolderEquipAnimation="GrenadeEquip"
	HolderUnequipAnimation="GrenadeUnequip"
	HolderUseAnimation="GrenadeThrow"
	EquippedSocket="GrenadeSocket"
	Mesh=SkeletalMesh'FP_FragGrenade.FP_FragGrenade'
}