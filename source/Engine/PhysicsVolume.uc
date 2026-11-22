class PhysicsVolume extends Volume
	native
	nativereplication
	config
	notplaceable
	hidecategories(Karma,Events,Force,Karma,LightColor,Lighting,Sound,Object);

var bool bPainCausing;
var Vector ZoneVelocity;
var Vector Gravity;
var float GroundFriction;
var float TerminalVelocity;
var float DamagePerSec;
var Class<DamageType> DamageType;
var int Priority;
var Sound EntrySound;
var Sound ExitSound;
var Class<Actor> EntryActor;
var Class<Actor> ExitActor;
var float FluidFriction;
var Vector ViewFlash;
var Vector ViewFog;
var bool bDestructive;
var bool bNoInventory;
var bool bMoveProjectiles;
var bool bBounceVelocity;
var bool bNeutralZone;
var bool bWaterVolume;
var Info PainTimer;
var(VolumeFog) bool bDistanceFog;
var(VolumeFog) Color DistanceFogColor;
var(VolumeFog) float DistanceFogStart;
var(VolumeFog) float DistanceFogEnd;
var(Karma) float KExtraLinearDamping;
var(Karma) float KExtraAngularDamping;
var(Karma) float KBuoyancy;
var PhysicsVolume NextPhysicsVolume;

replication
{
	// Pos:0x000
	reliable if(AndAnd_BoolBool(bNetDirty, EqualEqual_IntInt(int(Role), int(ROLE_Authority))))
		Gravity;
}

event PhysicsChangedFor(Actor Other)
{
	return;
}

event ActorEnteredVolume(Actor Other)
{
	return;
}

event ActorLeavingVolume(Actor Other)
{
	return;
}

event PawnEnteredVolume(Pawn Other)
{
	if(Other.IsPlayerPawn())
	{
		TriggerEvent(Event, self, Other);
	}
	return;
}

event PawnLeavingVolume(Pawn Other)
{
	if(Other.IsPlayerPawn())
	{
		UntriggerEvent(Event, self, Other);
	}
	return;
}

function TimerPop(VolumeTimer t)
{
	local Actor A;
	local bool bFound;

	if(EqualEqual_ObjectObject(t, PainTimer))
	{
		if(Not_PreBool(bPainCausing))
		{
			PainTimer.Destroy();
			return;
		}
		foreach TouchingActors(Class'Engine.Actor', A)
		{
			if(AndAnd_BoolBool(A.bCanBeDamaged, Not_PreBool(A.bStatic)))
			{
				CausePainTo(A);
				bFound = true;
			}
		}
		if(Not_PreBool(bFound))
		{
			PainTimer.Destroy();
		}
	}
	return;
}

function Trigger(Actor Other, Pawn EventInstigator)
{
	if(NotEqual_FloatFloat(DamagePerSec, float(0)))
	{
		bPainCausing = Not_PreBool(bPainCausing);
		if(AndAnd_BoolBool(bPainCausing, EqualEqual_ObjectObject(PainTimer, none)))
		{
			PainTimer = Spawn(Class'Engine.VolumeTimer', self);
		}
	}
	return;
}

event Touch(Actor Other)
{
	local Pawn P;
	local bool bFoundPawn;

	super(Actor).Touch(Other);
	if(EqualEqual_ObjectObject(Other, none))
	{
		return;
	}
	if(AndAnd_BoolBool(AndAnd_BoolBool(bNoInventory, Other.IsA('Inventory')), EqualEqual_ObjectObject(Other.Owner, none)))
	{
		Other.LifeSpan = 1.5000000;
		return;
	}
	if(AndAnd_BoolBool(bMoveProjectiles, NotEqual_VectorVector(ZoneVelocity, vect(0.0000000, 0.0000000, 0.0000000))))
	{
		if(EqualEqual_IntInt(int(Other.Physics), int(6)))
		{
			AddEqual_VectorVector(Other.Velocity, ZoneVelocity);
		}
		else
		{
			if(AndAnd_BoolBool(Other.IsA('Effects'), EqualEqual_IntInt(int(Other.Physics), int(0))))
			{
				Other.SetPhysics(6);
				AddEqual_VectorVector(Other.Velocity, ZoneVelocity);
			}
		}
	}
	if(bPainCausing)
	{
		if(Other.bDestroyInPainVolume)
		{
			Other.Destroy();
			return;
		}
		if(AndAnd_BoolBool(Other.bCanBeDamaged, Not_PreBool(Other.bStatic)))
		{
			CausePainTo(Other);
			if(EqualEqual_ObjectObject(PainTimer, none))
			{
				PainTimer = Spawn(Class'Engine.VolumeTimer', self);
			}
			else
			{
				if(NotEqual_ObjectObject(Pawn(Other), none))
				{
					foreach TouchingActors(Class'Engine.Pawn', P)
					{
						if(AndAnd_BoolBool(NotEqual_ObjectObject(P, Other), P.bCanBeDamaged))
						{
							bFoundPawn = true;
							break;
						}
					}
					if(Not_PreBool(bFoundPawn))
					{
						PainTimer.SetTimer(1.0000000, true);
					}
				}
			}
		}
	}
	if(AndAnd_BoolBool(bWaterVolume, Other.CanSplash()))
	{
		PlayEntrySplash(Other);
	}
	return;
}

function PlayEntrySplash(Actor Other)
{
	local float SplashSize;
	local Actor splash;

	SplashSize = FClamp(Multiply_FloatFloat(Multiply_FloatFloat(0.0000300, Other.Mass), Subtract_FloatFloat(float(250), Multiply_FloatFloat(0.5000000, FMax(-600.0000000, Other.Velocity.Z)))), 0.1000000, 1.0000000);
	if(NotEqual_ObjectObject(EntrySound, none))
	{
		PlaySound(EntrySound, SplashSize);
		if(NotEqual_ObjectObject(Other.Instigator, none))
		{
			MakeNoise(SplashSize);
		}
	}
	if(NotEqual_ObjectObject(EntryActor, none))
	{
		splash = Spawn(EntryActor);
		if(NotEqual_ObjectObject(splash, none))
		{
			splash.SetDrawScale(SplashSize);
		}
	}
	return;
}

event UnTouch(Actor Other)
{
	if(AndAnd_BoolBool(bWaterVolume, Other.CanSplash()))
	{
		PlayExitSplash(Other);
	}
	return;
}

function PlayExitSplash(Actor Other)
{
	local float SplashSize;
	local Actor splash;

	SplashSize = FClamp(Multiply_FloatFloat(0.0030000, Other.Mass), 0.1000000, 1.0000000);
	if(NotEqual_ObjectObject(ExitSound, none))
	{
		PlaySound(ExitSound, SplashSize);
	}
	if(NotEqual_ObjectObject(ExitActor, none))
	{
		splash = Spawn(ExitActor);
		if(NotEqual_ObjectObject(splash, none))
		{
			splash.SetDrawScale(SplashSize);
		}
	}
	return;
}

function CausePainTo(Actor Other)
{
	local float depth;
	local Pawn P;

	depth = 1.0000000;
	P = Pawn(Other);
	if(Greater_FloatFloat(DamagePerSec, float(0)))
	{
		if(AndAnd_BoolBool(Region.Zone.bSoftKillZ, NotEqual_IntInt(int(Other.Physics), int(1))))
		{
			return;
		}
		Other.TakeDamage(int(Multiply_FloatFloat(DamagePerSec, depth)), none, Location, vect(0.0000000, 0.0000000, 0.0000000), DamageType);
		if(AndAnd_BoolBool(NotEqual_ObjectObject(P, none), NotEqual_ObjectObject(P.Controller, none)))
		{
			P.Controller.PawnIsInPain(self);
		}
	}
	else
	{
		if(AndAnd_BoolBool(NotEqual_ObjectObject(P, none), Less_IntInt(P.Health, P.default.Health)))
		{
			P.Health = Min(P.default.Health, int(Subtract_FloatFloat(float(P.Health), Multiply_FloatFloat(depth, DamagePerSec))));
		}
	}
	return;
}

defaultproperties
{
	Gravity=(X=0.0000000,Y=0.0000000,Z=-1500.0000000)
	GroundFriction=8.0000000
	TerminalVelocity=2500.0000000
	FluidFriction=0.3000000
	KBuoyancy=1.0000000
	bAlwaysRelevant=true
	bOnlyDirtyReplication=true
	NetUpdateFrequency=5.0000000
}