class Decoration extends Actor
	abstract
	native
	config
	placeable
	hidecategories(Karma);

var Class<Actor> EffectWhenDestroyed;
var bool bPushable;
var bool bDamageable;
var bool bPushSoundPlaying;
var bool bSplash;
var Sound PushSound;
var Sound EndPushSound;
var const int numLandings;
var Class<Inventory> contents;
var int NumFrags;
var Texture FragSkin;
var Class<Fragment> FragType;
var Vector FragMomentum;
var int Health;
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

function Drop(Vector newVel)
{
	return;
}

function Landed(Vector HitNormal)
{
	local Rotator NewRot;

	if(Less_FloatFloat(Velocity.Z, float(-500)))
	{
		TakeDamage(100, Pawn(Owner), HitNormal, Multiply_VectorFloat(HitNormal, float(10000)), Class'Engine.Crushed');
	}
	Velocity = vect(0.0000000, 0.0000000, 0.0000000);
	NewRot = Rotation;
	NewRot.Pitch = 0;
	NewRot.Roll = 0;
	SetRotation(NewRot);
	return;
}

function HitWall(Vector HitNormal, Actor Wall)
{
	Landed(HitNormal);
	return;
}

function PostTakeDamage(int NDamage, Pawn InstigatedBy, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType)
{
	Instigator = InstigatedBy;
	if(OrOr_BoolBool(Not_PreBool(bDamageable), Less_IntInt(Health, 0)))
	{
		return;
	}
	if(NotEqual_ObjectObject(Instigator, none))
	{
		MakeNoise(1.0000000);
	}
	SubtractEqual_IntInt(Health, NDamage);
	FragMomentum = Momentum;
	if(Less_IntInt(Health, 0))
	{
		Destroy();
	}
	else
	{
		SetPhysics(2);
		Momentum.Z = 1000.0000000;
		Velocity = Divide_VectorFloat(Momentum, Mass);
	}
	return;
}

singular function PhysicsVolumeChange(PhysicsVolume NewVolume)
{
	if(NewVolume.bWaterVolume)
	{
		if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(bSplash, Not_PreBool(PhysicsVolume.bWaterVolume)), LessEqual_FloatFloat(Mass, Buoyancy)), OrOr_BoolBool(Less_FloatFloat(Abs(Velocity.Z), float(100)), EqualEqual_FloatFloat(Mass, float(0)))), Less_FloatFloat(FRand(), 0.0500000)), Not_PreBool(PlayerCanSeeMe())))
		{
			bSplash = false;
			SetPhysics(0);
		}
	}
	if(AndAnd_BoolBool(PhysicsVolume.bWaterVolume, Greater_FloatFloat(Buoyancy, Mass)))
	{
		if(Greater_FloatFloat(Buoyancy, Multiply_FloatFloat(1.1000000, Mass)))
		{
			Buoyancy = Multiply_FloatFloat(0.9500000, Buoyancy);
		}
		else
		{
			if(Greater_FloatFloat(Buoyancy, Multiply_FloatFloat(1.0300000, Mass)))
			{
				Buoyancy = Multiply_FloatFloat(0.9900000, Buoyancy);
			}
		}
	}
	return;
}

function Trigger(Actor Other, Pawn EventInstigator)
{
	Instigator = EventInstigator;
	TakeDamage(1000, Instigator, Location, Multiply_VectorFloat(vect(0.0000000, 0.0000000, 1.0000000), float(900)), Class'Engine.Crushed');
	return;
}

singular function BaseChange()
{
	if(Less_FloatFloat(Velocity.Z, float(-500)))
	{
		TakeDamage(int(Subtract_FloatFloat(float(1), Divide_FloatFloat(Velocity.Z, float(30)))), Instigator, Location, vect(0.0000000, 0.0000000, 0.0000000), Class'Engine.Crushed');
	}
	if(EqualEqual_ObjectObject(Base, none))
	{
		if(AndAnd_BoolBool(AndAnd_BoolBool(Not_PreBool(bInterpolating), bPushable), EqualEqual_IntInt(int(Physics), int(0))))
		{
			SetPhysics(2);
		}
	}
	else
	{
		if(NotEqual_ObjectObject(Pawn(Base), none))
		{
			Base.TakeDamage(int(Divide_FloatFloat(Multiply_FloatFloat(float(int(Subtract_FloatFloat(float(1), Divide_FloatFloat(Velocity.Z, float(400))))), Mass), Base.Mass)), Instigator, Location, Multiply_FloatVector(0.5000000, Velocity), Class'Engine.Crushed');
			Velocity.Z = 100.0000000;
			if(Less_FloatFloat(FRand(), 0.5000000))
			{
				AddEqual_FloatFloat(Velocity.X, float(70));
			}
			else
			{
				AddEqual_FloatFloat(Velocity.Y, float(70));
			}
			SetPhysics(2);
		}
		else
		{
			if(AndAnd_BoolBool(NotEqual_ObjectObject(Decoration(Base), none), Less_FloatFloat(Velocity.Z, float(-500))))
			{
				Base.TakeDamage(int(Subtract_FloatFloat(float(1), Divide_FloatFloat(Multiply_FloatFloat(Divide_FloatFloat(Mass, Base.Mass), Velocity.Z), float(30)))), Instigator, Location, Multiply_FloatVector(0.2000000, Velocity), Class'Engine.Crushed');
				Velocity.Z = 100.0000000;
				if(Less_FloatFloat(FRand(), 0.5000000))
				{
					AddEqual_FloatFloat(Velocity.X, float(70));
				}
				else
				{
					AddEqual_FloatFloat(Velocity.Y, float(70));
				}
				SetPhysics(2);
			}
			else
			{
				Instigator = none;
			}
		}
	}
	return;
}

simulated function Destroyed()
{
	local Inventory dropped;
	local int i;
	local Fragment S;
	local float BaseSize;

	if(EqualEqual_IntInt(int(Role), int(ROLE_Authority)))
	{
		if(AndAnd_BoolBool(NotEqual_ObjectObject(contents, none), Not_PreBool(Level.bStartup)))
		{
			dropped = Spawn(contents);
		}
		TriggerEvent(Event, self, none);
		if(bPushSoundPlaying)
		{
			PlaySound(EndPushSound);
		}
	}
	if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_IntInt(int(Level.NetMode), int(NM_DedicatedServer)), Not_PreBool(PhysicsVolume.bDestructive)), Greater_IntInt(NumFrags, 0)), NotEqual_ObjectObject(FragType, none)))
	{
		BaseSize = Divide_FloatFloat(Multiply_FloatFloat(0.8000000, Sqrt(Multiply_FloatFloat(CollisionRadius, CollisionHeight))), float(NumFrags));
		i = 0;
		J0xD1:

		if(Less_IntInt(i, NumFrags))
		{
			S = Spawn(FragType, Owner,, Add_VectorVector(Location, Multiply_FloatVector(CollisionRadius, VRand())));
			S.CalcVelocity(FragMomentum);
			if(NotEqual_ObjectObject(FragSkin, none))
			{
				S.Skins[0] = FragSkin;
			}
			S.SetDrawScale(Multiply_FloatFloat(BaseSize, Add_FloatFloat(0.5000000, Multiply_FloatFloat(0.7000000, FRand()))));
			AddAdd_Int(i);
			// [Loop Continue]
			goto J0xD1;
		}
	}
	super.Destroyed();
	return;
}

function Timer()
{
	PlaySound(EndPushSound);
	bPushSoundPlaying = false;
	return;
}

function PostBump(Actor Other)
{
	local float speed, OldZ;

	if(AndAnd_BoolBool(AndAnd_BoolBool(bPushable, NotEqual_ObjectObject(Pawn(Other), none)), Greater_FloatFloat(Other.Mass, float(40))))
	{
		OldZ = Velocity.Z;
		speed = VSize(Other.Velocity);
		Velocity = Divide_VectorFloat(Multiply_VectorFloat(Other.Velocity, FMin(120.0000000, Add_FloatFloat(20.0000000, speed))), speed);
		if(EqualEqual_IntInt(int(Physics), int(0)))
		{
			Velocity.Z = 25.0000000;
			if(Not_PreBool(bPushSoundPlaying))
			{
				PlaySound(PushSound);
				bPushSoundPlaying = true;
			}
		}
		else
		{
			Velocity.Z = OldZ;
		}
		SetPhysics(2);
		SetTimer(0.3000000, false);
		Instigator = Pawn(Other);
	}
	return;
}

defaultproperties
{
	DrawType=2
	bStatic=true
	bStasis=true
	bOrientOnSlope=true
	NetUpdateFrequency=10.0000000
	bShouldBaseAtStartup=true
}