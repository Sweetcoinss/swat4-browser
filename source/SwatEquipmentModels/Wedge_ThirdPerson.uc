class Wedge_ThirdPerson extends QualifiedUseEquipmentModel
	config
	hidecategories(Karma,Advanced,Events,Force,LightColor,Lighting,Movement,Object,Sound);

defaultproperties
{
	HolderBeginQualifyAnimation="cPlaceWedgeStart"
	HolderQualifyLoopAnimation="cPlaceWedgeLoop"
	HolderEndQualifyAnimation="cPlaceWedgeEnd"
	HolderEquipAnimation="equipDoorWedge"
	HolderUnequipAnimation="unequipDoorWedge"
	EquippedSocket="MiscGrip"
	DrawType=8
	StaticMesh=StaticMesh'SwatGear_sm.DoorWedge'
}