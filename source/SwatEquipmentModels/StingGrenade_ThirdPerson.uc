class StingGrenade_ThirdPerson extends ThrownWeaponModel
	config
	collapsecategories
	hidecategories(Karma,Advanced,Events,Force,LightColor,Lighting,Movement,Object,Sound);

defaultproperties
{
	HolderEquipAnimation="equipStingGrenade"
	HolderUnequipAnimation="unequipStingGrenade"
	HolderUseAnimation="sThrowLong"
	EquippedSocket="GripRhand"
	UnequippedSocket="GripBelt1"
	DrawType=8
	StaticMesh=StaticMesh'SwatGear_sm.stingGrenade'
}