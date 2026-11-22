class Toolkit_FirstPerson extends QualifiedUseEquipmentModel
	config
	hidecategories(Karma,Advanced,Events,Force,LightColor,Lighting,Movement,Object,Sound);

defaultproperties
{
	BeginQualifyAnimation="useStart"
	QualifyAnimation="useLoop"
	EndQualifyAnimation="useEnd"
	HolderBeginQualifyAnimation="ToolkitUseStart"
	HolderQualifyLoopAnimation="ToolkitUseLoop"
	HolderEndQualifyAnimation="ToolkitUseEnd"
	BeginAlternateQualifyAnimation="picklockStart"
	EndAlternateQualifyAnimation="picklockEnd"
	HolderBeginAlternateQualifyAnimation="ToolkitPicklockStart"
	HolderAlternateQualifyLoopAnimation="ToolkitPicklockLoop"
	HolderEndAlternateQualifyAnimation="ToolkitPicklockEnd"
	EquipAnimation="Equip"
	UnequipAnimation="UnEquip"
	UseAnimation="useStart"
	HolderIdleAnimations=/* Array type was not detected. */
	HolderDisorientedLowReadyIdleAnimation="1911cantShoot"
	HolderEquipAnimation="ToolkitEquip"
	HolderUnequipAnimation="ToolkitUnequip"
	HolderUseAnimation="ToolkitUseStart"
	EquippedSocket="1911Socket"
	ExtraAnimationSets=/* Array type was not detected. */
	Mesh=SkeletalMesh'FP_toolkit.FP_toolkit'
}