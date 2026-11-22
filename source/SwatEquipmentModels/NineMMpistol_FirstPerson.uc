class NineMMpistol_FirstPerson extends FiredWeaponModel
	config
	hidecategories(Karma,Advanced,Events,Force,LightColor,Lighting,Movement,Object,Sound);

defaultproperties
{
	UseLastRoundAnimation="fireLast"
	HolderUseLastRoundAnimation="1911fire"
	UseEmptyAnimation="Empty"
	HolderUseEmptyAnimation="1911fireEmpty"
	ReloadAnimation="reloadFull"
	EmptyReloadAnimation="reloadEmpty"
	HolderReloadAnimation="1911reload"
	HolderEmptyReloadAnimation="1911reloadEmpty"
	UseAnimation="Fire"
	HolderIdleAnimations=/* Array type was not detected. */
	HolderLowReadyIdleAnimation="1911lowready"
	HolderDisorientedLowReadyIdleAnimation="1911cantShoot"
	HolderEquipAnimation="1911equip"
	HolderUnequipAnimation="1911unequip"
	HolderUseAnimation="1911fire"
	EquippedSocket="1911Socket"
	Mesh=SkeletalMesh'FP_9mmPistol.FP_9mmPistol'
}