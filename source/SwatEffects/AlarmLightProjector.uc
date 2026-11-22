class AlarmLightProjector extends DynamicProjector
	config
	hidecategories(Karma,Collision,Force,Karma,LightColor,Lighting,Object,Sound);

defaultproperties
{
	FrameBufferBlendingOp=2
	ProjTexture=Texture'SwatGearTex.FlashLightBeamC'
	FOV=50
	MaxTraceDistance=100
	bProjectActor=false
	bLevelStatic=false
	bClipBSP=true
	bClipStaticMesh=true
	bGradient=true
	bProjectOnBackfaces=true
	bLightChanged=true
	Tag="DynamicProjector"
	Location=(X=443.8585000,Y=-408.4930000,Z=-435.0000000)
	DrawScale=0.1000000
	bSelected=true
	bNeedLifetimeEffectEvents=false
	Label="DynamicProjector4"
}