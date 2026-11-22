class CSgasGrenade_ThirdPerson extends ThrownWeaponModel
	config
	collapsecategories
	hidecategories(Karma,Advanced,Events,Force,LightColor,Lighting,Movement,Object,Sound);

defaultproperties
{
	HolderEquipAnimation="equipCSgas"
	HolderUnequipAnimation="unequipCSgas"
	HolderUseAnimation="sThrowLong"
	EquippedSocket="GripRhand"
	UnequippedSocket="GripBelt3"
	DrawType=8
	StaticMesh=StaticMesh'SwatGear_sm.CSgas'
}