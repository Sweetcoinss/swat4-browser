class G36K_FirstPerson extends FiredWeaponModel
	config
	hidecategories(Karma,Advanced,Events,Force,LightColor,Lighting,Movement,Object,Sound);

defaultproperties
{
	BurstAnimation="fireAuto"
	HolderBurstAnimation="G36KfireAuto"
	HolderUseEmptyAnimation="G36KfireEmpty"
	ReloadAnimation="reloadFull"
	EmptyReloadAnimation="reloadEmpty"
	HolderReloadAnimation="G36KreloadFull"
	HolderEmptyReloadAnimation="G36KreloadEmpty"
	UseAnimation="Fire"
	HolderIdleAnimations=/* Array type was not detected. */
	HolderLowReadyIdleAnimation="G36KlowReady"
	HolderDisorientedLowReadyIdleAnimation="1911cantShoot"
	HolderEquipAnimation="G36Kequip"
	HolderUnequipAnimation="G36Kunequip"
	HolderUseAnimation="G36Kfire"
	EquippedSocket="M4A1Socket"
	Mesh=SkeletalMesh'FP_G36k.FP_G36k'
}