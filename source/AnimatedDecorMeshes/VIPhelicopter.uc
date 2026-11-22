class VIPhelicopter extends ReactiveAnimatedMesh
	config
	hidecategories(Karma,Force,LightColor,Lighting,Object,Sound);

defaultproperties
{
	ExtraAnimationSets=/* Array type was not detected. */
	// Reference: ScriptedAnimationSet'AnimatedDecorMeshes.VIPhelicopter.ScriptedAnimationSet5'
	begin object name="ScriptedAnimationSet5" class=RWOSupport.ScriptedAnimationSet
		ScriptedAnimations=/* Array type was not detected. */
	end object
	Idle=ScriptedAnimationSet5
	ScriptedSequence=/* Array type was not detected. */
	WhenDoneDo=1
	Mesh=SkeletalMesh'VIPanimatedMeshes.VIPhelicopter'
	TriggeredBy="VIPnearChopper"
}