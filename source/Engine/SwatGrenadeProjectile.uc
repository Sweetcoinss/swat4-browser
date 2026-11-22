class SwatGrenadeProjectile extends SwatProjectile
	abstract
	config(SwatEquipment)
	notplaceable
	hidecategories(Karma);

var private config float FuseTime;
var private config float NotifyAIsTime;
var private Timer NotifyAIsTimer;
var private config float BounceDampening;
var private config int BounceCount;
var array<IInterestedGrenadeThrowing> InterestedGrenadeRegistrants;
var private float TimeThrown;
var private Vector DebugLastLocation;
var bool bRenderDebugInfo;
var private bool bShouldSpin;

event PostBeginPlay()
{
	super(Actor).PostBeginPlay();
	NotifyAIsTimer = Spawn(Class'Engine.Timer', self);
	NotifyAIsTimer.__TimerDelegate__Delegate = NotifyAIsGrenadeThrown;
	NotifyAIsTimer.StartTimer(NotifyAIsTime, false);
	Label = 'Grenade';
	TimeThrown = Level.TimeSeconds;
	NotifyAIsGrenadeThrown();
	return;
}

event Tick(float dTime)
{
	local float Elapsed;
	local Rotator NewRotation;

	Elapsed = Subtract_FloatFloat(Level.TimeSeconds, TimeThrown);
	if(bShouldSpin)
	{
		NewRotation = Rotation;
		NewRotation.Pitch = int(Multiply_FloatFloat(Multiply_FloatFloat(Elapsed, float(-65535)), float(2)));
		NewRotation.Yaw = int(Add_FloatFloat(float(-8192), Multiply_FloatFloat(Elapsed, float(-60000))));
		if(EqualEqual_IntInt(BounceCount, default.BounceCount))
		{
			NewRotation.Roll = 4096;
		}
		else
		{
			if(EqualEqual_IntInt(BounceCount, 0))
			{
				NewRotation.Roll = 0;
				bShouldSpin = false;
			}
			else
			{
				NewRotation.Roll = Divide_IntInt(Subtract_PreInt(Rotation.Roll), 2);
			}
		}
		SetRotation(NewRotation);
	}
	return;
}

event Destroyed()
{
	super(Actor).Destroyed();
	DestroyNotifyAIsTimer();
	InterestedGrenadeRegistrants.Remove(0, InterestedGrenadeRegistrants.Length);
	return;
}

private function NotifyAIsGrenadeThrown()
{
	local Pawn Iter;

	Iter = Level.PawnList;
	J0x14:

	if(NotEqual_ObjectObject(Iter, none))
	{
		if(AndAnd_BoolBool(Class'Engine.Pawn'.static.checkConscious(Iter), Iter.IsA('IReactToThrownGrenades')))
		{
			IReactToThrownGrenades(Iter).NotifyGrenadeThrown(self);
		}
		Iter = Iter.nextPawn;
		// [Loop Continue]
		goto J0x14;
	}
	return;
}

private function bool IsAnInterestedGrenadeRegistrant(IInterestedGrenadeThrowing Registrant)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, InterestedGrenadeRegistrants.Length))
	{
		if(EqualEqual_ObjectObject(InterestedGrenadeRegistrants[i], Registrant))
		{
			return true;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return false;
	return;
}

function RegisterInterestedGrenadeRegistrant(IInterestedGrenadeThrowing Registrant)
{
	assert(Not_PreBool(IsAnInterestedGrenadeRegistrant(Registrant)));
	InterestedGrenadeRegistrants[InterestedGrenadeRegistrants.Length] = Registrant;
	Registrant.NotifyRegisteredOnProjectile(self);
	return;
}

function UnRegisterInterestedGrenadeRegistrant(IInterestedGrenadeThrowing Registrant)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, InterestedGrenadeRegistrants.Length))
	{
		if(EqualEqual_ObjectObject(InterestedGrenadeRegistrants[i], Registrant))
		{
			InterestedGrenadeRegistrants.Remove(i, 1);
			// [Explicit Break]
			goto J0x45;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	J0x45:

	return;
}

private function NotifyRegistrantsGrenadeDetonated()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, InterestedGrenadeRegistrants.Length))
	{
		InterestedGrenadeRegistrants[i].NotifyGrenadeDetonated(self);
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

simulated event HitWall(Vector Normal, Actor Wall)
{
	local Vector Mirror;

	TriggerEffectEvent('Bounced');
	if(Greater_IntInt(BounceCount, 0))
	{
		Mirror = MirrorVectorByNormal(Velocity, Normal);
		Velocity = Multiply_VectorFloat(Mirror, BounceDampening);
		SubtractSubtract_Int(BounceCount);
	}
	else
	{
		Disable('HitWall');
		Disable('Touch');
		TriggerEffectEvent('StoppedBouncing');
	}
	return;
}

singular simulated function Touch(Actor Other)
{
	if(OrOr_BoolBool(OrOr_BoolBool(OrOr_BoolBool(Other.bHidden, EqualEqual_IntInt(int(Other.DrawType), int(0))), EqualEqual_ObjectObject(Other, Owner)), Other.IsA('SwatDoor')))
	{
		return;
	}
	HitWall(Subtract_VectorVector(Location, Other.Location), Other);
	return;
}

private simulated function DestroyNotifyAIsTimer()
{
	if(NotEqual_ObjectObject(NotifyAIsTimer, none))
	{
		NotifyAIsTimer.__TimerDelegate__Delegate = None;
		NotifyAIsTimer.Destroy();
		NotifyAIsTimer = none;
	}
	return;
}

simulated function Detonated()
{
	assert(false);
	return;
}

latent simulated function DoPostDetonation()
{
	return;
}

auto simulated state Live
{Begin:

	Sleep(FuseTime);
	TriggerEffectEvent('Detonated',,, self.Location, Rotator(vect(0.0000000, 0.0000000, 1.0000000)));
	NotifyRegistrantsGrenadeDetonated();
	Detonated();
	DestroyNotifyAIsTimer();
	DoPostDetonation();
	stop;
}

defaultproperties
{
	bShouldSpin=true
	DrawType=8
	CollisionRadius=5.0000000
	CollisionHeight=5.0000000
}