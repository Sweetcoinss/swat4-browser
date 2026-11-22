class PythonRevolver_ThirdPerson extends FiredWeaponModel
	config
	hidecategories(Karma,Advanced,Events,Force,LightColor,Lighting,Movement,Object,Sound);

defaultproperties
{
	HolderReloadAnimation="reloadRV"
	HolderEmptyReloadAnimation="reloadRV"
	HolderEquipAnimation="GangEquipHG"
	HolderUnequipAnimation="GangUnequipHG"
	HolderUseAnimation="sFire_PythonHG"
	EquippedSocket="GripRhand"
	DrawType=8
	StaticMesh=StaticMesh'SwatGear_sm.HG_Python'
}