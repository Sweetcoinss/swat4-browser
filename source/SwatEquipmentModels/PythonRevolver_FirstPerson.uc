class PythonRevolver_FirstPerson extends FiredWeaponModel
	config
	hidecategories(Karma,Advanced,Events,Force,LightColor,Lighting,Movement,Object,Sound);

defaultproperties
{
	HolderUseLastRoundAnimation="RevolverFire"
	UseEmptyAnimation="Fire"
	HolderUseEmptyAnimation="RevolverFireEmpty"
	ReloadAnimation="Reload"
	HolderReloadAnimation="RevolverReload"
	UseAnimation="Fire"
	HolderIdleAnimations=/* Array type was not detected. */
	HolderLowReadyIdleAnimation="RevolverLowReady"
	HolderDisorientedLowReadyIdleAnimation="1911cantShoot"
	HolderEquipAnimation="RevolverEquip"
	HolderUnequipAnimation="RevolverUnequip"
	HolderUseAnimation="RevolverFire"
	EquippedSocket="BreachingSGsocket"
	Mesh=SkeletalMesh'FP_Revolver.FP_Revolver'
	HavokDataClass=Class'Engine.HavokSkeletalSystem'
}