class FragGrenade_ThirdPerson extends ThrownWeaponModel
	config
	collapsecategories
	hidecategories(Karma,Advanced,Events,Force,LightColor,Lighting,Movement,Object,Sound);

defaultproperties
{
	HolderEquipAnimation="equipFlashbang"
	HolderUnequipAnimation="unequipFlashbang"
	HolderUseAnimation="sThrowLong"
	EquippedSocket="GripRhand"
	DrawType=8
	StaticMesh=StaticMesh'SwatGear_sm.FragHeld'
}