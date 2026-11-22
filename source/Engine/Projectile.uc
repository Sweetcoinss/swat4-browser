class Projectile extends Actor
	abstract
	native
	config
	notplaceable
	hidecategories(Karma);

var float speed;
var float MaxSpeed;
var float TossZ;
var Actor ZeroCollider;
var bool bSwitchToZeroCollision;
var float Damage;
var float DamageRadius;
var float MomentumTransfer;
var Class<DamageType> MyDamageType;
var Sound SpawnSound;
var Sound ImpactSound;
var Class<Projector> ExplosionDecal;
var float ExploWallOut;

function bool EncroachingOn(Actor Other)
{
	if(OrOr_BoolBool(NotEqual_ObjectObject(Other.Brush, none), NotEqual_ObjectObject(Brush(Other), none)))
	{
		return true;
	}
	return false;
	return;
}

singular simulated function Touch(Actor Other)
{
	local Actor HitActor;
	local Vector HitLocation, HitNormal, VelDir, AdjustedLocation;
	local bool bBeyondOther;
	local float BackDist, DirZ;

	if(EqualEqual_ObjectObject(Other, none))
	{
		return;
	}
	if(OrOr_BoolBool(Other.bProjTarget, AndAnd_BoolBool(Other.bBlockActors, Other.bBlockPlayers)))
	{
		if(OrOr_BoolBool(EqualEqual_VectorVector(Velocity, vect(0.0000000, 0.0000000, 0.0000000)), Other.IsA('Mover')))
		{
			ProcessTouch(Other, Location);
			return;
		}
		bBeyondOther = Greater_FloatFloat(Dot_VectorVector(Velocity, Subtract_VectorVector(Location, Other.Location)), float(0));
		VelDir = Normal(Velocity);
		DirZ = Sqrt(Abs(VelDir.Z));
		BackDist = Add_FloatFloat(Multiply_FloatFloat(Other.CollisionRadius, Subtract_FloatFloat(float(1), DirZ)), Multiply_FloatFloat(Other.CollisionHeight, DirZ));
		if(bBeyondOther)
		{
			AddEqual_FloatFloat(BackDist, VSize(Subtract_VectorVector(Location, Other.Location)));
		}
		else
		{
			SubtractEqual_FloatFloat(BackDist, VSize(Subtract_VectorVector(Location, Other.Location)));
		}
		HitActor = Trace(HitLocation, HitNormal, Location, Subtract_VectorVector(Location, Multiply_FloatVector(Multiply_FloatFloat(1.1000000, BackDist), VelDir)), true);
		if(EqualEqual_ObjectObject(HitActor, Other))
		{
			AdjustedLocation = HitLocation;
		}
		else
		{
			if(bBeyondOther)
			{
				AdjustedLocation = Subtract_VectorVector(Other.Location, Multiply_FloatVector(Other.CollisionRadius, VelDir));
			}
			else
			{
				AdjustedLocation = Location;
			}
		}
		ProcessTouch(Other, AdjustedLocation);
		if(AndAnd_BoolBool(Less_IntInt(int(Role), int(ROLE_Authority)), EqualEqual_IntInt(int(Other.Role), int(ROLE_Authority))))
		{
			ClientSideTouch(Other, AdjustedLocation);
		}
	}
	return;
}

simulated function ClientSideTouch(Actor Other, Vector HitLocation)
{
	Other.TakeDamage(int(Damage), Instigator, Location, Multiply_FloatVector(MomentumTransfer, Normal(Velocity)), MyDamageType);
	return;
}

simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
	if(NotEqual_ObjectObject(Other, Instigator))
	{
		Explode(HitLocation, Normal(Subtract_VectorVector(HitLocation, Other.Location)));
	}
	return;
}

simulated function HitWall(Vector HitNormal, Actor Wall)
{
	if(EqualEqual_IntInt(int(Role), int(ROLE_Authority)))
	{
		if(NotEqual_ObjectObject(Mover(Wall), none))
		{
			Wall.TakeDamage(int(Damage), Instigator, Location, Multiply_FloatVector(MomentumTransfer, Normal(Velocity)), MyDamageType);
		}
		MakeNoise(1.0000000);
	}
	Explode(Add_VectorVector(Location, Multiply_FloatVector(ExploWallOut, HitNormal)), HitNormal);
	if(AndAnd_BoolBool(NotEqual_ObjectObject(ExplosionDecal, none), NotEqual_IntInt(int(Level.NetMode), int(NM_DedicatedServer))))
	{
		Spawn(ExplosionDecal, self,, Location, Rotator(Subtract_PreVector(HitNormal)));
	}
	return;
}

simulated function BlowUp(Vector HitLocation)
{
	HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation);
	if(EqualEqual_IntInt(int(Role), int(ROLE_Authority)))
	{
		MakeNoise(1.0000000);
	}
	return;
}

simulated function Explode(Vector HitLocation, Vector HitNormal)
{
	Destroy();
	return;
}

final simulated function RandSpin(float spinRate)
{
	DesiredRotation = RotRand();
	RotationRate.Yaw = int(Subtract_FloatFloat(Multiply_FloatFloat(Multiply_FloatFloat(spinRate, float(2)), FRand()), spinRate));
	RotationRate.Pitch = int(Subtract_FloatFloat(Multiply_FloatFloat(Multiply_FloatFloat(spinRate, float(2)), FRand()), spinRate));
	RotationRate.Roll = int(Subtract_FloatFloat(Multiply_FloatFloat(Multiply_FloatFloat(spinRate, float(2)), FRand()), spinRate));
	return;
}

static function Vector GetTossVelocity(Pawn P, Rotator R)
{
	local Vector V;

	V = Vector(R);
	MultiplyEqual_VectorFloat(V, Add_FloatFloat(Multiply_FloatFloat(Dot_VectorVector(P.Velocity, V), 0.4000000), default.speed));
	AddEqual_FloatFloat(V.Z, default.TossZ);
	return V;
	return;
}

defaultproperties
{
	MaxSpeed=2000.0000000
	TossZ=100.0000000
	DamageRadius=220.0000000
	MyDamageType=Class'Engine.DamageType'
	Physics=6
	DrawType=2
	bAcceptsProjectors=false
	bNetTemporary=true
	bReplicateInstigator=true
	bNetInitialRotation=true
	RemoteRole=2
	NetPriority=2.5000000
	LifeSpan=14.0000000
	Texture=Texture'Engine_res.S_Camera'
	bUnlit=true
	bGameRelevant=true
	bCanBeDamaged=true
	bDisturbFluidSurface=true
	CollisionRadius=0.0000000
	CollisionHeight=0.0000000
	bCollideActors=true
	bCollideWorld=true
	bUseCylinderCollision=true
}