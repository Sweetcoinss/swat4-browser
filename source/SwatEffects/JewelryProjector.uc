class JewelryProjector extends DynamicProjector
	config
	hidecategories(Karma,Collision,Force,Karma,LightColor,Lighting,Object,Sound);

defaultproperties
{
	FrameBufferBlendingOp=0
	ProjTexture=Texture'Jewel_Tex.JewelProjection'
	FOV=25
	MaxTraceDistance=220
	bLevelStatic=false
	bClipBSP=true
	bClipStaticMesh=true
	bNoProjectOnOwner=true
	bLightChanged=true
	Tag="JewelryProjector"
	Rotation=(Pitch=-5119,Yaw=0,Roll=0)
	DrawScale=0.0100000
	bSelected=true
	bNeedLifetimeEffectEvents=false
	Label="JewelryProjector1"
}