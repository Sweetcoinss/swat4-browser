class NineMMpistol_ThirdPerson extends FiredWeaponModel
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
	DroppedStaticMesh=StaticMesh'SwatGear_sm.HG_9mm'
	Mesh=SkeletalMesh'NineMMpistol_ThirdPerson.NineMMpistol_ThirdPerson'
}