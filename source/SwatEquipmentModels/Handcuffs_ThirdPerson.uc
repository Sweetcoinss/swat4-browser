class Handcuffs_ThirdPerson extends QualifiedUseEquipmentModel
	config
	hidecategories(Karma,Advanced,Events,Force,LightColor,Lighting,Movement,Object,Sound);

defaultproperties
{
	HolderQualifyLoopAnimation="sCuffSP"
	HolderEndQualifyAnimation="sCuffEndSP"
	HolderBeginAlternateQualifyAnimation="sCuffStartMP"
	HolderAlternateQualifyLoopAnimation="sCuffMP"
	HolderEndAlternateQualifyAnimation="sCuffEndMP"
	HolderEquipAnimation="equipCuffs"
	HolderUnequipAnimation="UnequipCuffs"
	EquippedSocket="MiscGrip"
	DrawType=8
	StaticMesh=StaticMesh'SwatGear_sm.HandcuffsHeld'
}