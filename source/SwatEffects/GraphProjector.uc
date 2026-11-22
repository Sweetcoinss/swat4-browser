class GraphProjector extends DynamicProjector
	config
	hidecategories(Karma,Collision,Force,Karma,LightColor,Lighting,Object,Sound);

defaultproperties
{
	ProjTexture=Texture'RedLibrary_Tex.ProjectorChart'
	FOV=2
	MaxTraceDistance=500
	bLevelStatic=false
	bClipBSP=true
	bClipStaticMesh=true
	bNoProjectOnOwner=true
	bLightChanged=true
	Tag="GraphProjector"
	Rotation=(Pitch=-5119,Yaw=0,Roll=0)
	DrawScale=0.8000000
	bSelected=true
	bNeedLifetimeEffectEvents=false
	Label="GraphProjector1"
}