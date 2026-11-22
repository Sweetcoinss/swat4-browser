class MPDetonator_ThirdPerson extends HandheldEquipmentModel
	config
	hidecategories(Karma,Advanced,Events,Force,LightColor,Lighting,Movement,Object,Sound);

defaultproperties
{
	HolderEquipAnimation="equipC2"
	HolderUnequipAnimation="unequipC2"
	HolderUseAnimation="sDetonateC2mp"
	EquippedSocket="MiscGrip"
	DrawType=8
	StaticMesh=StaticMesh'SwatGear_sm.C2detonator'
}