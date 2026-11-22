class Taser_ThirdPerson extends FiredWeaponModel
	config
	hidecategories(Karma,Advanced,Events,Force,LightColor,Lighting,Movement,Object,Sound);

defaultproperties
{
	HolderReloadAnimation="reloadHG"
	HolderEmptyReloadAnimation="reloadHG"
	HolderEquipAnimation="EquipHG"
	HolderUnequipAnimation="UnequipHG"
	HolderUseAnimation="sFire_HG"
	EquippedSocket="GripRhand"
	UnequippedSocket="GripHolster"
	DrawType=8
	StaticMesh=StaticMesh'SwatGear_sm.Taser'
}