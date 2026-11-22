class VolumeTimer extends Info
	config
	notplaceable
	hidecategories(Karma,Movement,Collision,Lighting,LightColor,Karma,Force);

var PhysicsVolume V;

function PostBeginPlay()
{
	super(Actor).PostBeginPlay();
	SetTimer(1.0000000, true);
	V = PhysicsVolume(Owner);
	return;
}

function Timer()
{
	V.TimerPop(self);
	return;
}
