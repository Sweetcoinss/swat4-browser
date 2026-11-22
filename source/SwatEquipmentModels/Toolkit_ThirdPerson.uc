class Toolkit_ThirdPerson extends QualifiedUseEquipmentModel
	config
	hidecategories(Karma,Advanced,Events,Force,LightColor,Lighting,Movement,Object,Sound);

defaultproperties
{
	HolderBeginQualifyAnimation="ToolkitUseStart"
	HolderQualifyLoopAnimation="ToolkitUseLoop"
	HolderEndQualifyAnimation="ToolkitUseEnd"
	HolderBeginAlternateQualifyAnimation="sPickLockStart"
	HolderAlternateQualifyLoopAnimation="sPickLock"
	HolderEndAlternateQualifyAnimation="sPickLockEnd"
	HolderAnimationBlending=1
	HolderShouldHideBeginAndEndAnims=true
	HolderEquipAnimation="equipTacticalAid"
	HolderUnequipAnimation="unequipTacticalAid"
	HolderUseAnimation="sPickLock"
	EquippedSocket="MiscGrip"
	DrawType=8
	StaticMesh=StaticMesh'SwatGear_sm.Toolkit'
}