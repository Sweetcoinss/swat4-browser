class Paintball_ThirdPerson extends FiredWeaponModel
	config
	hidecategories(Karma,Advanced,Events,Force,LightColor,Lighting,Movement,Object,Sound);

defaultproperties
{
	HolderReloadAnimation="reloadMG"
	HolderEquipAnimation="EquipMG"
	HolderUnequipAnimation="UnequipMG"
	EquippedSocket="GripRhand"
	UnequippedSocket="GripBack"
	DrawType=8
	StaticMesh=StaticMesh'SwatGear_sm.paintballGun'
}