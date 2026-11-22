class M4A1_ThirdPerson extends FiredWeaponModel
	config
	hidecategories(Karma,Advanced,Events,Force,LightColor,Lighting,Movement,Object,Sound);

defaultproperties
{
	HolderBurstAnimation="sFire_M4A1auto"
	HolderReloadAnimation="reloadM4A1full"
	HolderEmptyReloadAnimation="reloadM4A1empty"
	HolderEquipAnimation="equipM4A1"
	HolderUnequipAnimation="unequipM4A1"
	HolderUseAnimation="sFire_M4A1"
	EquippedSocket="GripRhand"
	UnequippedSocket="GripBack"
	DrawType=8
	StaticMesh=StaticMesh'SwatGear_sm.MG_m4Flashlight'
}