class SawedOff_ThirdPerson extends FiredWeaponModel
	config
	hidecategories(Karma,Advanced,Events,Force,LightColor,Lighting,Movement,Object,Sound);

defaultproperties
{
	HolderReloadAnimation="reloadSGloop"
	HolderEmptyReloadAnimation="reloadSGm4empty"
	HolderEquipAnimation="equipSG"
	HolderUnequipAnimation="unequipSG"
	HolderUseAnimation="sFireSGnova"
	EquippedSocket="GripRhandSG"
	UnequippedSocket="GripBack"
	DrawType=8
	StaticMesh=StaticMesh'SwatGear_sm.SG_SawedOff'
}