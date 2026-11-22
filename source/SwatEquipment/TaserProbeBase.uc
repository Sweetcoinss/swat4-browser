class TaserProbeBase extends Actor
	config
	notplaceable
	hidecategories(Karma);

var config int BounceCount;
var config float BounceDampening;

simulated function ResetState()
{
	BounceCount = default.BounceCount;
	SetPhysics(0);
	SetCollision(false, false, false);
	bCollideWorld = false;
	bBounce = false;
	return;
}

simulated function StartPhysics()
{
	BounceCount = default.BounceCount;
	SetPhysics(2);
	SetCollision(true, false, false);
	bCollideWorld = true;
	bBounce = true;
	return;
}

simulated event HitWall(Vector Normal, Actor Wall)
{
	local Vector Mirror;

	if(Greater_FloatFloat(Dot_VectorVector(Velocity, Normal), float(0)))
	{
		return;
	}
	if(Greater_IntInt(BounceCount, 0))
	{
		Mirror = MirrorVectorByNormal(Velocity, Normal);
		Velocity = Multiply_VectorFloat(Mirror, BounceDampening);
		TriggerEffectEvent('Bounced');
		SubtractSubtract_Int(BounceCount);
	}
	else
	{
		TriggerEffectEvent('Bounced');
		SetPhysics(0);
	}
	return;
}

singular simulated function Touch(Actor Other)
{
	if(OrOr_BoolBool(OrOr_BoolBool(Other.bHidden, EqualEqual_IntInt(int(Other.DrawType), int(0))), NotEqual_ObjectObject(TaserProbeBase(Other), none)))
	{
		return;
	}
	HitWall(Subtract_VectorVector(Location, Other.Location), Other);
	return;
}

simulated function OnOptimizedOut()
{
	super.OnOptimizedOut();
	ResetState();
	return;
}

defaultproperties
{
	BounceCount=5
	BounceDampening=0.5000000
	DrawType=8
	bAlwaysRelevant=true
	RemoteRole=0
	CollisionRadius=5.0000000
	CollisionHeight=5.0000000
	bCollideActors=true
	bCollideWorld=true
	bBounce=true
}