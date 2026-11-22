class Scorpion_ThirdPerson extends FiredWeaponModel
	config
	hidecategories(Karma,Advanced,Events,Force,LightColor,Lighting,Movement,Object,Sound);

defaultproperties
{
	HolderReloadAnimation="reloadHG"
	HolderEmptyReloadAnimation="reloadHGempty"
	HolderEquipAnimation="GangEquipHG"
	HolderUnequipAnimation="GangUnequipHG"
	HolderUseAnimation="sFire_HG"
	EquippedSocket="GripRhand"
	DrawType=8
	StaticMesh=StaticMesh'SwatGear_sm.HG_Scorpion'
}