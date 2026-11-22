class BreakableWindow extends ReactiveStaticMesh
	config(SwatGame)
	hidecategories(Karma,Force,LightColor,Lighting,Object,Sound);

simulated function PostBeginPlay()
{
	super(ReactiveWorldObject).PostBeginPlay();
	bWorldGeometry = true;
	return;
}
