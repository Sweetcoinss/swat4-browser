class DynamicProjector extends Projector
	config
	placeable
	hidecategories(Karma,Collision,Force,Karma,LightColor,Lighting,Object,Sound);

function Tick(float DeltaTime)
{
	DetachProjector();
	AttachProjector();
	return;
}

defaultproperties
{
	bDynamicAttach=true
	bStatic=false
}