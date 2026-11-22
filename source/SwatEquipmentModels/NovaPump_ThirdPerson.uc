class NovaPump_ThirdPerson extends FiredWeaponModel
	config
	hidecategories(Karma,Advanced,Events,Force,LightColor,Lighting,Movement,Object,Sound);

defaultproperties
{
	EmptyReloadAnimation="reloadEmpty"
	HolderReloadAnimation="reloadSGloop"
	HolderEmptyReloadAnimation="reloadSGnovaEmpty"
	UseAnimation="Fire"
	HolderEquipAnimation="equipSG"
	HolderUnequipAnimation="unequipSG"
	HolderUseAnimation="sFireSGnova"
	EquippedSocket="GripRhandSG"
	UnequippedSocket="GripBack"
	DroppedStaticMesh=StaticMesh'SwatGear_sm.SG_NovaPumpTraining'
	Mesh=SkeletalMesh'NovaPump_ThirdPerson.NovaPump_ThirdPerson'
	Skins=/* Array type was not detected. */
}