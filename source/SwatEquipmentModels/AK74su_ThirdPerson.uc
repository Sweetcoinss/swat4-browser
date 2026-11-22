class AK74su_ThirdPerson extends FiredWeaponModel
	config
	hidecategories(Karma,Advanced,Events,Force,LightColor,Lighting,Movement,Object,Sound);

defaultproperties
{
	HolderBurstAnimation="sFire_MGauto"
	HolderReloadAnimation="reloadMG"
	HolderEmptyReloadAnimation="reloadM4A1empty"
	HolderEquipAnimation="EquipMG"
	HolderUnequipAnimation="UnequipMG"
	HolderUseAnimation="sFire_MG"
	EquippedSocket="GripRhand"
	UnequippedSocket="GripBack"
	DrawType=8
	StaticMesh=StaticMesh'SwatGear_sm.MG_ak74su'
}