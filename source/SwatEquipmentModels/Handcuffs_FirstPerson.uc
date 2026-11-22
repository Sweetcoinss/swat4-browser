class Handcuffs_FirstPerson extends QualifiedUseEquipmentModel
	config
	hidecategories(Karma,Advanced,Events,Force,LightColor,Lighting,Movement,Object,Sound);

defaultproperties
{
	HolderQualifyLoopAnimation="HandcuffsUseSP"
	HolderEndQualifyAnimation="HandcuffsUseEnd"
	HolderBeginAlternateQualifyAnimation="HandcuffsUseStartMP"
	HolderAlternateQualifyLoopAnimation="HandcuffsUseMP"
	HolderEndAlternateQualifyAnimation="HandcuffsUseEnd"
	HolderIdleAnimations=/* Array type was not detected. */
	HolderDisorientedLowReadyIdleAnimation="1911cantShoot"
	HolderEquipAnimation="HandcuffsEquip"
	HolderUnequipAnimation="HandcuffsUnequip"
	EquippedSocket="1911Socket"
	Mesh=SkeletalMesh'FP_Handcuffs.FP_Handcuffs'
}