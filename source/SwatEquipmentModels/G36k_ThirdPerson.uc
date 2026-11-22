class G36k_ThirdPerson extends FiredWeaponModel
	config
	hidecategories(Karma,Advanced,Events,Force,LightColor,Lighting,Movement,Object,Sound);

defaultproperties
{
	HolderBurstAnimation="sFire_MGauto"
	HolderReloadAnimation="reloadMG"
	HolderEmptyReloadAnimation="reloadMGempty"
	HolderEquipAnimation="EquipMG"
	HolderUnequipAnimation="UnequipMG"
	HolderUseAnimation="sFire_MG"
	EquippedSocket="GripRhand"
	UnequippedSocket="GripBack"
	DrawType=8
	StaticMesh=StaticMesh'SwatGear_sm.MG_g36k'
}