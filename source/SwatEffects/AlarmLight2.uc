class AlarmLight2 extends DynamicProjector
	config
	hidecategories(Karma,Collision,Force,Karma,LightColor,Lighting,Object,Sound);

defaultproperties
{
	FrameBufferBlendingOp=3
	ProjTexture=Texture'SwatFXtex.AlarmLightBeam'
	FOV=120
	MaxTraceDistance=100
	bLevelStatic=false
	bClipBSP=true
	bClipStaticMesh=true
	bGradient=true
	GradientTexture=Texture'SwatGearTex.FLASHLIGHT_Fade'
	DrawType=0
	bLightChanged=true
	bHidden=false
	Tag="FlashlightProjectorBase"
	Location=(X=483.0000000,Y=-218.0000000,Z=-426.0000000)
	DrawScale=0.0100000
	bSelected=true
	bNeedLifetimeEffectEvents=false
	Label="AlarmLight2"
}