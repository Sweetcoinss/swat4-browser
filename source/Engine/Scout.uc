class Scout extends Pawn
	native
	config(SwatPawn)
	notplaceable
	hidecategories(Karma);

var const float MaxLandingVelocity;
var const Actor WalkMoveHitActor;
var const Vector WalkMoveHitLocation;
var const string WalkMoveHitMessage;

function PreBeginPlay()
{
	Destroy();
	return;
}

defaultproperties
{
	AccelRate=1.0000000
	CollisionRadius=52.0000000
	bCollideActors=false
	bCollideWorld=false
	bBlockActors=false
	bBlockPlayers=false
	bProjTarget=false
	bPathColliding=true
}