class PaperTargetSkeletalSystem extends HavokActor
	config
	hidecategories(Karma);

defaultproperties
{
	Physics=16
	DrawType=2
	Mesh=SkeletalMesh'TrainingAnimatedMeshes.PaperTarget'
	HavokDataClass=Class'SwatDesignerClasses.PaperTargetHavokSystem'
}