class ThrownWeapon extends Weapon
	abstract
	config(SwatEquipment)
	notplaceable
	hidecategories(Karma);

var private float ThrowSpeed;
var config Class<SwatGrenadeProjectile> ProjectileClass;
var config name FirstPersonPreThrowAnimation;
var array<IInterestedGrenadeThrowing> InterestedGrenadeRegistrants;

function PostBeginPlay()
{
	super(HandheldEquipment).PostBeginPlay();
	assert(NotEqual_ObjectObject(ProjectileClass, none));
	return;
}

simulated function OnPlayerUse()
{
	Level.GetLocalPlayerController().Throw();
	return;
}

function SetThrowSpeed(float inThrowSpeed)
{
	ThrowSpeed = inThrowSpeed;
	return;
}

protected latent simulated function DoUsingHook()
{
	local Hands Hands;
	local Pawn PawnOwner;
	local int PawnThrowAnimationChannel;

	PawnOwner = Pawn(Owner);
	Hands = PawnOwner.GetHands();
	PawnThrowAnimationChannel = PawnOwner.AnimPlayEquipment(0, ICanThrowWeapons(PawnOwner).GetThrowAnimation(ThrowSpeed), ICanThrowWeapons(PawnOwner).GetPawnThrowTweenTime(), ICanThrowWeapons(PawnOwner).GetPawnThrowRootBone());
	if(NotEqual_ObjectObject(Hands, none))
	{
		Hands.PlayAnim(Hands.GetThrowAnimation(ThrowSpeed));
	}
	Pawn(Owner).FinishAnim(PawnThrowAnimationChannel);
	if(NotEqual_ObjectObject(Hands, none))
	{
		Hands.FinishAnim();
	}
	return;
}

simulated function UsedHook()
{
	local ICanThrowWeapons Holder;
	local Vector InitialLocation;
	local Rotator ThrownDirection;

	if(AndAnd_BoolBool(IsAvailable(), NotEqual_IntInt(int(Level.NetMode), int(NM_Client))))
	{
		Holder = ICanThrowWeapons(Owner);
		AssertWithDescription(NotEqual_ObjectObject(Holder, none), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] ", string(Class.Name)), " was notified OnThrown(), but its Owner ("), string(Owner)), ") cannot throw weapons."));
		Holder.GetThrownProjectileParams(InitialLocation, ThrownDirection);
		SpawnProjectile(InitialLocation, Multiply_VectorFloat(Vector(ThrownDirection), ThrowSpeed));
	}
	return;
}

function SwatGrenadeProjectile SpawnProjectile(Vector inLocation, Vector inVelocity)
{
	local SwatGrenadeProjectile Projectile;

	Projectile = Owner.Spawn(ProjectileClass, Owner,, inLocation,, true);
	AssertWithDescription(NotEqual_ObjectObject(Projectile, none), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] The thrown ", string(Class.Name)), " failed to spawn its projectile of class "), string(ProjectileClass)), ".  Make sure that the specified ProjectileClass is a subclass of SwatGrenadeProjectile, and Check the log for spawning errors."));
	Projectile.Velocity = inVelocity;
	Projectile.TriggerEffectEvent('Thrown');
	RegisterInterestedGrenadeRegistrantWithProjectile(Projectile);
	return Projectile;
	return;
}

event Destroyed()
{
	super(HandheldEquipment).Destroyed();
	if(NotEqual_ObjectObject(FirstPersonModel, none))
	{
		FirstPersonModel.Destroy();
	}
	if(NotEqual_ObjectObject(ThirdPersonModel, none))
	{
		ThirdPersonModel.Destroy();
	}
	return;
}

function RegisterInterestedGrenadeRegistrantWithProjectile(SwatGrenadeProjectile Projectile)
{
	local int i;

	assert(NotEqual_ObjectObject(Projectile, none));
	i = 0;
	J0x12:

	if(Less_IntInt(i, InterestedGrenadeRegistrants.Length))
	{
		Projectile.RegisterInterestedGrenadeRegistrant(InterestedGrenadeRegistrants[i]);
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x12;
	}
	return;
}

private function bool IsAnInterestedGrenadeRegistrant(IInterestedGrenadeThrowing Client)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, InterestedGrenadeRegistrants.Length))
	{
		if(EqualEqual_ObjectObject(InterestedGrenadeRegistrants[i], Client))
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

function RegisterInterestedGrenadeThrowing(IInterestedGrenadeThrowing Client)
{
	assert(Not_PreBool(IsAnInterestedGrenadeRegistrant(Client)));
	InterestedGrenadeRegistrants[InterestedGrenadeRegistrants.Length] = Client;
	return;
}

function UnRegisterInterestedGrenadeThrowing(IInterestedGrenadeThrowing Client)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, InterestedGrenadeRegistrants.Length))
	{
		if(EqualEqual_ObjectObject(InterestedGrenadeRegistrants[i], Client))
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

defaultproperties
{
	UnavailableAfterUsed=true
	CollisionRadius=5.0000000
	CollisionHeight=5.0000000
	bBounce=true
}