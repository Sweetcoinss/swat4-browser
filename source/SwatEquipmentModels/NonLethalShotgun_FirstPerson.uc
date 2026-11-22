class NonLethalShotgun_FirstPerson extends FiredWeaponModel
	config
	hidecategories(Karma,Advanced,Events,Force,LightColor,Lighting,Movement,Object,Sound);

defaultproperties
{
	UseEmptyAnimation="fireEmpty"
	HolderUseEmptyAnimation="NovaPumpFireEmpty"
	EmptyReloadAnimation="reloadEmpty"
	HolderReloadAnimation="NovaPumpReloadLoop"
	HolderEmptyReloadAnimation="NovaPumpReloadEmpty"
	UseAnimation="Fire"
	HolderIdleAnimations=/* Array type was not detected. */
	HolderLowReadyIdleAnimation="NovaPumpLowReady"
	HolderDisorientedLowReadyIdleAnimation="1911cantShoot"
	HolderEquipAnimation="NovaPumpEquip"
	HolderUnequipAnimation="NovaPumpUnequip"
	HolderUseAnimation="NovaPumpFire"
	EquippedSocket="M4super90Socket"
	Mesh=SkeletalMesh'FP_NovaPumpShotgun.FP_NovaPumpShotgun'
	Skins=/* Array type was not detected. */
}