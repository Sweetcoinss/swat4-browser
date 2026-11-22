class Fragment extends Effects
	config
	notplaceable
	hidecategories(Karma);

var Mesh Fragments[11];
var int numFragmentTypes;
var bool bFirstHit;
var Sound ImpactSound;
var Sound AltImpactSound;
var float SplashTime;

function bool CanSplash()
{
	if(AndAnd_BoolBool(AndAnd_BoolBool(Greater_FloatFloat(Subtract_FloatFloat(Level.TimeSeconds, SplashTime), 0.2500000), EqualEqual_IntInt(int(Physics), int(2))), Greater_FloatFloat(Abs(Velocity.Z), float(100))))
	{
		SplashTime = Level.TimeSeconds;
		return true;
	}
	return false;
	return;
}

simulated function CalcVelocity(Vector Momentum)
{
	local float ExplosionSize;

	ExplosionSize = Multiply_FloatFloat(0.0110000, VSize(Momentum));
	Velocity = Add_VectorVector(Multiply_FloatVector(0.0033000, Momentum), Multiply_VectorFloat(Multiply_FloatVector(0.7000000, VRand()), Add_FloatFloat(Add_FloatFloat(ExplosionSize, Multiply_FloatFloat(FRand(), 100.0000000)), 100.0000000)));
	AddEqual_FloatFloat(Velocity.Z, Multiply_FloatFloat(0.5000000, ExplosionSize));
	return;
}

simulated function HitWall(Vector HitNormal, Actor HitWall)
{
	local float speed;

	Velocity = Multiply_FloatVector(0.5000000, Add_VectorVector(Multiply_VectorFloat(Multiply_FloatVector(Dot_VectorVector(Velocity, HitNormal), HitNormal), -2.0000000), Velocity));
	speed = VSize(Velocity);
	if(AndAnd_BoolBool(bFirstHit, Less_FloatFloat(speed, float(400))))
	{
		bFirstHit = false;
		bRotateToDesired = true;
		bFixedRotationDir = false;
		DesiredRotation.Pitch = 0;
		DesiredRotation.Yaw = int(Multiply_FloatFloat(FRand(), float(65536)));
		DesiredRotation.Roll = 0;
	}
	RotationRate.Yaw = int(Multiply_FloatFloat(float(RotationRate.Yaw), 0.7500000));
	RotationRate.Roll = int(Multiply_FloatFloat(float(RotationRate.Roll), 0.7500000));
	RotationRate.Pitch = int(Multiply_FloatFloat(float(RotationRate.Pitch), 0.7500000));
	if(AndAnd_BoolBool(Less_FloatFloat(speed, float(60)), Greater_FloatFloat(HitNormal.Z, 0.7000000)))
	{
		SetPhysics(0);
		bBounce = false;
		GotoState('Dying');
	}
	else
	{
		if(Greater_FloatFloat(speed, float(80)))
		{
			if(Less_FloatFloat(FRand(), 0.5000000))
			{
				PlaySound(ImpactSound,,, 300.0000000, 300.0000000, Add_FloatFloat(0.8500000, Multiply_FloatFloat(FRand(), 0.3000000)), 0,, true);
			}
			else
			{
				PlaySound(AltImpactSound,,, 300.0000000, 300.0000000, Add_FloatFloat(0.8500000, Multiply_FloatFloat(FRand(), 0.3000000)), 0,, true);
			}
		}
	}
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

auto state Flying
{
	simulated function Timer()
	{
		GotoState('Dying');
		return;
	}

	singular simulated function PhysicsVolumeChange(PhysicsVolume NewVolume)
	{
		if(NewVolume.bWaterVolume)
		{
			Velocity = Multiply_FloatVector(0.2000000, Velocity);
			if(bFirstHit)
			{
				bFirstHit = false;
				bRotateToDesired = true;
				bFixedRotationDir = false;
				DesiredRotation.Pitch = 0;
				DesiredRotation.Yaw = int(Multiply_FloatFloat(FRand(), float(65536)));
				DesiredRotation.Roll = 0;
			}
			RotationRate = Multiply_FloatRotator(0.2000000, RotationRate);
			GotoState('Dying');
		}
		return;
	}

	simulated function BeginState()
	{
		RandSpin(125000.0000000);
		if(Less_FloatFloat(Abs(float(RotationRate.Pitch)), float(10000)))
		{
			RotationRate.Pitch = 10000;
		}
		if(Less_FloatFloat(Abs(float(RotationRate.Roll)), float(10000)))
		{
			RotationRate.Roll = 10000;
		}
		LinkMesh(Fragments[int(Multiply_FloatFloat(FRand(), float(numFragmentTypes)))]);
		if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
		{
			LifeSpan = Add_FloatFloat(20.0000000, Multiply_FloatFloat(float(40), FRand()));
		}
		SetTimer(5.0000000, true);
		return;
	}
	stop;
}

state Dying
{
	function PostTakeDamage(int Dam, Pawn InstigatedBy, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType)
	{
		Destroy();
		return;
	}

	simulated function Timer()
	{
		if(Not_PreBool(PlayerCanSeeMe()))
		{
			Destroy();
		}
		return;
	}

	simulated function BeginState()
	{
		SetTimer(Add_FloatFloat(1.0000000, FRand()), true);
		SetCollision(true, false, false);
		return;
	}
	stop;
}

defaultproperties
{
	bFirstHit=true
	Physics=2
	DrawType=2
	LifeSpan=20.0000000
	bDestroyInPainVolume=true
	CollisionRadius=18.0000000
	CollisionHeight=4.0000000
	bCollideWorld=true
	bBounce=true
	bFixedRotationDir=true
}