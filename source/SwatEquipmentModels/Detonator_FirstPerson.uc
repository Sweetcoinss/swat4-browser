class Detonator_FirstPerson extends HandheldEquipmentModel
	config
	hidecategories(Karma,Advanced,Events,Force,LightColor,Lighting,Movement,Object,Sound);

defaultproperties
{
	UseAnimation="Use"
	HolderIdleAnimations=/* Array type was not detected. */
	HolderDisorientedLowReadyIdleAnimation="1911cantShoot"
	HolderEquipAnimation="C2equip"
	HolderUnequipAnimation="C2unequip"
	HolderUseAnimation="C2detonatorUse"
	EquippedSocket="C2Socket"
	Mesh=SkeletalMesh'FP_C2detonator.FP_C2detonator'
}