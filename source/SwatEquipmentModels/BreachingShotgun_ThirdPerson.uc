class BreachingShotgun_ThirdPerson extends FiredWeaponModel
	config
	hidecategories(Karma,Advanced,Events,Force,LightColor,Lighting,Movement,Object,Sound);

defaultproperties
{
	EmptyReloadAnimation="reloadEmpty"
	HolderReloadAnimation="reloadSGloop"
	HolderEmptyReloadAnimation="reloadSGnovaEmpty"
	UseAnimation="Fire"
	HolderEquipAnimation="equipBreachingSG"
	HolderUnequipAnimation="unequipBreachingSG"
	HolderUseAnimation="sFireSGnova"
	EquippedSocket="GripRhandSG"
	UnequippedSocket="BreachSGunequipped"
	Mesh=SkeletalMesh'BreachingSG_ThirdPerson.BreachingSG_ThirdPerson'
}