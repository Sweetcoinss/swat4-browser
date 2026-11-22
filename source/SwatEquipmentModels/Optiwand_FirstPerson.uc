class Optiwand_FirstPerson extends HandheldEquipmentModel
	config
	hidecategories(Karma,Advanced,Events,Force,LightColor,Lighting,Movement,Object,Sound);

defaultproperties
{
	EquipAnimation="Equip"
	UnequipAnimation="UnEquip"
	HolderIdleAnimations=/* Array type was not detected. */
	HolderLowReadyIdleAnimation="OptiwandLowReady"
	HolderEquipAnimation="OptiwandEquip"
	HolderUnequipAnimation="optiwandUnequip"
	HolderUseAnimation="optiwandUse"
	EquippedSocket="M4A1Socket"
	Mesh=SkeletalMesh'FP_Optiwand.FP_Optiwand'
}