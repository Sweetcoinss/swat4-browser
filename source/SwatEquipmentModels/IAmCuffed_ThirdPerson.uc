class IAmCuffed_ThirdPerson extends HandheldEquipmentModel
	config
	hidecategories(Karma,Advanced,Events,Force,LightColor,Lighting,Movement,Object,Sound);

defaultproperties
{
	HolderEquipAnimation="ComplyCuffed"
	HolderUnequipAnimation="sUncuffed"
	HolderEquipTweenTime=0.2000000
	EquippedSocket="MiscGrip"
	DrawType=8
	StaticMesh=StaticMesh'SwatGear_sm.HandcuffsDeployed'
}