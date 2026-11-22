class ColtM1911_ThirdPerson extends FiredWeaponModel
	config
	hidecategories(Karma,Advanced,Events,Force,LightColor,Lighting,Movement,Object,Sound);

defaultproperties
{
	UseLastRoundAnimation="fireLast"
	EmptyReloadAnimation="reloadEmpty"
	HolderReloadAnimation="reloadHG"
	HolderEmptyReloadAnimation="reloadHGempty"
	UseAnimation="Fire"
	HolderEquipAnimation="EquipHG"
	HolderUnequipAnimation="UnequipHG"
	EquippedSocket="GripRhand"
	UnequippedSocket="GripHolster"
	DroppedStaticMesh=StaticMesh'SwatGear_sm.HG_1911Flashlight'
	Mesh=SkeletalMesh'Colt1911FL_ThirdPerson.Colt1911FL_ThirdPerson'
}