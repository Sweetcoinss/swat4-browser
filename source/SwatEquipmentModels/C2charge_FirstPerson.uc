class C2charge_FirstPerson extends QualifiedUseEquipmentModel
	config
	hidecategories(Karma,Advanced,Events,Force,LightColor,Lighting,Movement,Object,Sound);

defaultproperties
{
	QualifyAnimation="placeLoop"
	HolderBeginQualifyAnimation="C2PlaceStart"
	HolderQualifyLoopAnimation="C2PlaceLoop"
	HolderEndQualifyAnimation="C2PlaceEnd"
	FinishQualifyTweenTime=0.3000000
	HolderIdleAnimations=/* Array type was not detected. */
	HolderDisorientedLowReadyIdleAnimation="1911cantShoot"
	HolderEquipAnimation="C2equip"
	HolderUnequipAnimation="C2unequip"
	EquippedSocket="C2Socket"
	Mesh=SkeletalMesh'FP_C2charge.FP_C2charge'
}