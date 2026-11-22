class SilencedMP5_ThirdPerson extends FiredWeaponModel
	config
	hidecategories(Karma,Advanced,Events,Force,LightColor,Lighting,Movement,Object,Sound);

defaultproperties
{
	HolderBurstAnimation="sFire_SMGauto"
	HolderReloadAnimation="reloadSMG"
	HolderEquipAnimation="equipSMG"
	HolderUnequipAnimation="UnequipSMG"
	HolderUseAnimation="sFire_SMG"
	EquippedSocket="GripRhand"
	UnequippedSocket="GripBack"
	DrawType=8
	StaticMesh=StaticMesh'SwatGear_sm.SMG_mp5FlashlightSilenced'
}