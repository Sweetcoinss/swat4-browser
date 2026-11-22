class Wedge_FirstPerson extends QualifiedUseEquipmentModel
	config
	hidecategories(Karma,Advanced,Events,Force,LightColor,Lighting,Movement,Object,Sound);

defaultproperties
{
	BeginQualifyAnimation="Idle"
	QualifyAnimation="Use"
	HolderBeginQualifyAnimation="DoorWedgeUse"
	HolderQualifyLoopAnimation="DoorWedgeLoop"
	HolderEndQualifyAnimation="DoorWedgeEnd"
	HolderBeginAlternateQualifyAnimation="DoorWedgeUse"
	HolderIdleAnimations=/* Array type was not detected. */
	HolderDisorientedLowReadyIdleAnimation="1911cantShoot"
	HolderEquipAnimation="DoorWedgeEquip"
	HolderUnequipAnimation="DoorWedgeUnequip"
	EquippedSocket="1911Socket"
	ExtraAnimationSets=/* Array type was not detected. */
	Mesh=SkeletalMesh'FP_DoorWedge.FP_DoorWedge'
}