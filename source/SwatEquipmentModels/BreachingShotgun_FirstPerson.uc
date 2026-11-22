class BreachingShotgun_FirstPerson extends FiredWeaponModel
	config
	hidecategories(Karma,Advanced,Events,Force,LightColor,Lighting,Movement,Object,Sound);

defaultproperties
{
	UseEmptyAnimation="fireEmpty"
	HolderUseEmptyAnimation="BreachingSGfireEmpty"
	EmptyReloadAnimation="reloadEmpty"
	HolderReloadAnimation="BreachingSGreloadLoop"
	HolderEmptyReloadAnimation="BreachingSGreloadEmpty"
	UseAnimation="Fire"
	HolderIdleAnimations=/* Array type was not detected. */
	HolderLowReadyIdleAnimation="BreachingSGlowReady"
	HolderDisorientedLowReadyIdleAnimation="1911cantShoot"
	HolderEquipAnimation="BreachingSGequip"
	HolderUnequipAnimation="BreachingSGunequip"
	HolderUseAnimation="BreachingSGfire"
	EquippedSocket="BreachingSGsocket"
	Mesh=SkeletalMesh'FP_BreachingSG.FP_BreachingSG'
}