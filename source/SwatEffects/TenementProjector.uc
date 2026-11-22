class TenementProjector extends DynamicProjector
	config
	hidecategories(Karma,Collision,Force,Karma,LightColor,Lighting,Object,Sound);

defaultproperties
{
	FrameBufferBlendingOp=3
	ProjTexture=TexOscillator'Tenement_Tex.ten_slide01_osc'
	FOV=50
	MaxTraceDistance=400
	bLevelStatic=false
	bClipBSP=true
	bClipStaticMesh=true
	bNoProjectOnOwner=true
	bLightChanged=true
	Tag="GraphProjector"
	Rotation=(Pitch=-5119,Yaw=0,Roll=0)
	DrawScale=0.0100000
	bSelected=true
	bNeedLifetimeEffectEvents=false
	Label="GraphProjector1"
}