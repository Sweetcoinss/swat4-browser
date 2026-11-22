class FlashbangGrenade_ThirdPerson extends ThrownWeaponModel
	config
	collapsecategories
	hidecategories(Karma,Advanced,Events,Force,LightColor,Lighting,Movement,Object,Sound);

defaultproperties
{
	HolderEquipAnimation="equipFlashbang"
	HolderUnequipAnimation="unequipFlashbang"
	HolderUseAnimation="sThrowLong"
	EquippedSocket="GripRhand"
	UnequippedSocket="GripBelt2"
	DrawType=8
	StaticMesh=StaticMesh'SwatGear_sm.Flashbang'
}