class MPIAmCuffed_ThirdPerson extends HandheldEquipmentModel
	config
	hidecategories(Karma,Advanced,Events,Force,LightColor,Lighting,Movement,Object,Sound);

defaultproperties
{
	HolderEquipAnimation="sGetCuffedMP"
	HolderUnequipAnimation="sUncuffed"
	EquippedSocket="MiscGrip"
	DrawType=8
	StaticMesh=StaticMesh'SwatGear_sm.HandcuffsDeployed'
}