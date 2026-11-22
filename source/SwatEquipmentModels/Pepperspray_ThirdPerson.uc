class Pepperspray_ThirdPerson extends FiredWeaponModel
	config
	hidecategories(Karma,Advanced,Events,Force,LightColor,Lighting,Movement,Object,Sound);

defaultproperties
{
	HolderEquipAnimation="EquipPepperSpray"
	HolderUnequipAnimation="UnequipPepperSpray"
	HolderUseAnimation="sFire_HG"
	EquippedSocket="GripRhand"
	DrawType=8
	StaticMesh=StaticMesh'SwatGear_sm.PepperSpray'
}