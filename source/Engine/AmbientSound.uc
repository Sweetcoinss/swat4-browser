class AmbientSound extends Keypoint
	config
	placeable
	hidecategories(Karma);

simulated function PostBeginPlay()
{
	super(Actor).PostBeginPlay();
	RegisterNotifyGameStarted();
	return;
}

simulated function OnGameStarted()
{
	TriggerEffectEvent('Started');
	return;
}

defaultproperties
{
	bStatic=false
	bNoDelete=true
	RemoteRole=0
}