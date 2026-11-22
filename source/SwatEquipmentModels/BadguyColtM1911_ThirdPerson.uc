class BadguyColtM1911_ThirdPerson extends FiredWeaponModel
	config
	hidecategories(Karma,Advanced,Events,Force,LightColor,Lighting,Movement,Object,Sound);

defaultproperties
{
	EmptyReloadAnimation="reloadEmpty"
	HolderReloadAnimation="reloadHG"
	HolderEmptyReloadAnimation="reloadHGempty"
	HolderEquipAnimation="GangEquipHG"
	HolderUnequipAnimation="GangUnequipHG"
	EquippedSocket="GripRhand"
	DrawType=8
	StaticMesh=StaticMesh'SwatGear_sm.HG_1911'
}