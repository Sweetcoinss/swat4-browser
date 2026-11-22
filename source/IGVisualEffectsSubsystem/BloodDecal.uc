class BloodDecal extends ProjectedDecal
	config
	hidecategories(Karma,Collision,Force,Karma,LightColor,Lighting,Object,Sound);

var Range DrawScaleRange;

function PostBeginPlay()
{
	super.PostBeginPlay();
	SetDrawScale(RandRange(DrawScaleRange.Min, DrawScaleRange.Max));
	return;
}

defaultproperties
{
	DrawScaleRange=(Min=0.0100000,Max=0.1900000)
	ProjTexture=Texture'SwatFXtex.BloodSplat1'
	MaxTraceDistance=50
	DrawScale=0.3000000
}