class VIPgun_FirstPerson extends FiredWeaponModel
	config
	hidecategories(Karma,Advanced,Events,Force,LightColor,Lighting,Movement,Object,Sound);

defaultproperties
{
	UseLastRoundAnimation="fireLast"
	HolderUseLastRoundAnimation="VIP_1911fire"
	UseEmptyAnimation="Empty"
	HolderUseEmptyAnimation="VIP_1911fireEmpty"
	ReloadAnimation="reloadFull"
	EmptyReloadAnimation="reloadEmpty"
	HolderReloadAnimation="VIP_1911reload"
	HolderEmptyReloadAnimation="VIP_1911reloadEmpty"
	UseAnimation="Fire"
	HolderIdleAnimations=/* Array type was not detected. */
	HolderLowReadyIdleAnimation="VIP_1911lowready"
	HolderDisorientedLowReadyIdleAnimation="1911cantShoot"
	HolderEquipAnimation="VIP_1911equip"
	HolderUnequipAnimation="VIP_1911unequip"
	HolderUseAnimation="VIP_1911fire"
	EquippedSocket="1911Socket"
	Mesh=SkeletalMesh'FP_coltHG.1st_1911'
	Skins=/* Array type was not detected. */
}