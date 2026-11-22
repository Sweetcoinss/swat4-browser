class Optiwand_ThirdPerson extends HandheldEquipmentModel
	config
	hidecategories(Karma,Advanced,Events,Force,LightColor,Lighting,Movement,Object,Sound);

defaultproperties
{
	EquipAnimation="Equip"
	UnequipAnimation="UnEquip"
	HolderEquipAnimation="EquipOptiwand"
	HolderUnequipAnimation="unequipOptiwand"
	EquippedSocket="GripRhand"
	UnequippedSocket="OptiwandUnequipped"
	Mesh=SkeletalMesh'Optiwand_ThirdPerson.Optiwand_ThirdPerson'
}