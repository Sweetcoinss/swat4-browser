class Ingram_ThirdPerson extends FiredWeaponModel
	config
	hidecategories(Karma,Advanced,Events,Force,LightColor,Lighting,Movement,Object,Sound);

defaultproperties
{
	HolderBurstAnimation="sFire_HG"
	HolderReloadAnimation="reloadHG"
	HolderEmptyReloadAnimation="reloadHGempty"
	HolderEquipAnimation="GangEquipHG"
	HolderUnequipAnimation="GangUnequipHG"
	HolderUseAnimation="sFire_GangHG"
	EquippedSocket="GripRhand"
	DrawType=8
	StaticMesh=StaticMesh'SwatGear_sm.HG_Ingram'
}