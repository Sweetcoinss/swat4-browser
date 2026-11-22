class ReactiveWorldObject extends HavokActor implements IReactToFlashbangGrenade, IReactToStingGrenade, ICanBeUsed
	native
	config(SwatGame)
	hidecategories(Karma,Force,LightColor,Lighting,Object,Sound);

var(Handlers) export editinline array<export editinline Handler_Damaged> DamagedHandlers;
var(Handlers) export editinline array<export editinline Handler_Bumped> BumpedHandlers;
var(Handlers) export editinline array<export editinline Handler_Used> UsedHandlers;
var(Handlers) export editinline array<export editinline Handler_Triggered> TriggeredHandlers;
var(Handlers) export editinline array<export editinline Handler_GrenadeDetonated> GrenadeDetonatedHandlers;
var(Handlers) export editinline array<export editinline Handler_TimerExpired> TimerExpiredHandlers;
var(Handlers) bool UsableNow;
var(Handlers) bool TriggerableNow;
var(Handlers) bool IgnoreZeroDamage;
var(Handlers) bool ShouldReactToTriggeredOnPostBeginPlayInMP;
var bool IsConseptuallyBroken;
var(Havok) bool bHighDetailOnly "If true, the object will have physics disabled if the level's physics setting is less than PDL_High, or if running on a dedicated server.";
var(Havok) bool bClientOnly "If true, the object's physics will be disabled when running on a server (i.e., it will only be physical on clients)";
var(Havok) float hkMass "The mass of the object.\r" "\r" "WARNING: If mass is set to 0 then the object will be fixed in place, and the hkKeyframed setting will be ignored!";
var(Havok) bool hkStabilizedInertia "Set this flag to help stabilize the physics of unstable configurations, such as long thin objects. For normal configurations is should be left at the default value of false.";
var(Havok) float hkFriction "Controls how sticky the object is. Minimum value is 0 and maximum is 1";
var(Havok) float hkRestitution "Controls how bouncy the object is. Minimum value is 0 and maximum is 1";
var(Havok) float hkLinearDamping "Controls how much damping is applied to linear velocity. Values are usually very small, and 0 means 'no damping'";
var(Havok) float hkAngularDamping "Controls how much damping is applied to angular velocity. Values are usually very small, and 0 means 'no damping'";
var(Havok) bool hkActive "If true, the object will be 'physical' as soon as the level starts (e.g., it will fall to the ground, etc). If false, it will be inactive until it is activated (i.e., it will float in space something collides with it, etc.)";
var(Havok) bool hkKeyframed "Only set this to true for objects that should block other physics objects but whose movement is controlled by Unreal instead of physical forces. For example, this should be true for Movers.\r" "\r" "WARNING: this flag is ignored if hkMass is 0!";
var(Havok) Vector hkLinearVel "The initial linear velocity of the object.\r" "\r" "WARNING: this value must be in Unreal units, not meters/second (1 meter = 50 Unreal distance units).";
var(Havok) Vector hkAngularVel "The initial angular velocity of the object.\r" "\r" "WARNING: this value must be in Unreal units, not radians/second (1 radian = 10430.2192 Unreal angular units).";
var(Havok) float hkForceUprightStrength "Governs how quickly an object bounces back when tilted away from its upright axis. Higher values mean that the object recovers more quickly. Values can range from 0 to 1";
var(Havok) float hkForceUprightDamping "Governs how quickly the oscillation along the vertical axis settles down. Low values create springy behavior, while high values will reduce any oscillations very quickly with the size of the oscillations getting much smaller each time. Values can range from 0 to 1";
var(Havok) HavokRigidBody.EOrientationConstraint hkForceUpright "Controls which, if any, of the object's rotational axes are constrained while moving.\r" "\r" "WARNING: this parameter is ignored hkKeyframed is true or hkMass is 0.";
var int hkCollisionLayer;
var int hkCollisionSystemGroup;
var int hkCollisionSubpartID;
var int hkCollisionSubpartIgnoreID;
var(Havok) bool useIntrusionDrivenUpdates "If false, the Havok representation of this skeleton's bones will be updated every frame to match the on-screen bone location. If true, they will only be updated when another Havok object enters a volume rougly twice the size of this actor's bounding volume. This is a performance optimization; in most cases you should leave it at the default setting.\r" "\r" "NOTE: This is automatically set to true at runtime for keyframed (animated) skeletal meshes.";
var(Havok) name SkeletonPhysicsFile "File from which to load the Havok ragdoll skeleton (e.g., \"myRagdoll.hke\"). File path is relative to \"ProjectRootContentHavokData\".";
var(Havok) float hkJointFriction "Friction applied to all ragdoll joints";
var private const transient bool bShouldDestroySelf;

// Export UReactiveWorldObject::execDestroyRWO(FFrame&, void* const)
native simulated function DestroyRWO();

simulated event PostBeginPlay()
{
	super(Actor).PostBeginPlay();
	if(AndAnd_BoolBool(ShouldReactToTriggeredOnPostBeginPlayInMP, NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone))))
	{
		ReactToTriggered(none);
	}
	return;
}

simulated event Destroyed()
{
	HavokActivate();
	return;
}

simulated event bool TriggerEffectEvent(name EffectEvent, optional Actor Other, optional Material TargetMaterial, optional Vector HitLocation, optional Rotator HitNormal, optional bool PlayOnOther, optional bool QueryOnly, optional IEffectObserver Observer, optional name ReferenceTag, optional name SkipSubsystemWithThisName)
{
	if(AndAnd_BoolBool(IsConseptuallyBroken, EqualEqual_NameName(EffectEvent, 'Alive')))
	{
		return false;
	}
	super(Actor).TriggerEffectEvent(EffectEvent, Other, TargetMaterial, HitLocation, HitNormal, PlayOnOther, QueryOnly, Observer);
	return;
}

simulated function ReactToDamaged(int Damage, Pawn EventInstigator, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType)
{
	if(AndAnd_BoolBool(EqualEqual_IntInt(Damage, 0), IgnoreZeroDamage))
	{
		return;
	}
	Class'RWOSupport.Handler_Damaged'.static.dispatch(DamagedHandlers, self, Damage, EventInstigator, HitLocation, Momentum, DamageType);
	return;
}

simulated function ReactToBumped(Actor Other)
{
	Class'RWOSupport.Handler_Bumped'.static.dispatch(BumpedHandlers, self, Other);
	return;
}

simulated function ReactToUsed(Actor Other)
{
	Class'RWOSupport.Handler_Used'.static.dispatch(UsedHandlers, self, Other);
	return;
}

simulated function ReactToTriggered(Actor Other)
{
	Class'RWOSupport.Handler_Triggered'.static.dispatch(TriggeredHandlers, self, Other);
	return;
}

simulated function ReactToTimerExpired()
{
	Class'RWOSupport.Handler_TimerExpired'.static.dispatch(TimerExpiredHandlers, self, none);
	return;
}

simulated function bool CanBeUsed()
{
	return Greater_IntInt(UsedHandlers.Length, 0);
	return;
}

simulated event Trigger(Actor Other, Pawn EventInstigator)
{
	BroadcastReactToTriggered(Other);
	return;
}

simulated event Timer()
{
	ReactToTimerExpired();
	return;
}

simulated function ReactToFlashbangGrenade(SwatGrenadeProjectile Grenade, Pawn Instigator, float Damage, float DamageRadius, Range KarmaImpulse, float KarmaImpulseRadius, float StunRadius, float PlayerStunDuration, float AIStunDuration, float MoraleModifier)
{
	ReactToGrenade(Grenade, Instigator, Damage, DamageRadius, KarmaImpulse, KarmaImpulseRadius);
	return;
}

simulated function ReactToStingGrenade(SwatGrenadeProjectile Grenade, Pawn Instigator, float Damage, float DamageRadius, Range PhysicsImpulse, float PhysicsImpulseRadius, float StingRadius, float PlayerStingDuration, float HeavilyArmoredPlayerStingDuration, float AIStingDuration, float MoraleModifier)
{
	ReactToGrenade(Grenade, Instigator, Damage, DamageRadius, PhysicsImpulse, PhysicsImpulseRadius);
	return;
}

simulated function ReactToGrenade(SwatGrenadeProjectile Grenade, Pawn Instigator, float Damage, float DamageRadius, Range PhysicsImpulse, float PhysicsImpulseRadius)
{
	local Vector direction, GrenadeLocation;
	local float Distance, magnitude;

	if(NotEqual_ObjectObject(Grenade, none))
	{
		GrenadeLocation = Grenade.Location;
		direction = Subtract_VectorVector(Location, Grenade.Location);
		Distance = VSize(direction);
		if(EqualEqual_ObjectObject(Instigator, none))
		{
			Instigator = Pawn(Grenade.Owner);
		}
	}
	else
	{
		GrenadeLocation = Location;
		Distance = 0.0000000;
		if(NotEqual_ObjectObject(Instigator, none))
		{
			direction = Subtract_VectorVector(Location, Instigator.Location);
		}
		else
		{
			direction = Location;
		}
	}
	if(LessEqual_FloatFloat(Distance, DamageRadius))
	{
		TakeDamage(int(Damage), Instigator, GrenadeLocation, vect(0.0000000, 0.0000000, 0.0000000), Class'Engine.GrenadeDamageType');
	}
	if(AndAnd_BoolBool(OrOr_BoolBool(EqualEqual_IntInt(int(Physics), int(15)), EqualEqual_IntInt(int(Physics), int(16))), LessEqual_FloatFloat(Distance, PhysicsImpulseRadius)))
	{
		magnitude = Lerp(Divide_FloatFloat(Distance, PhysicsImpulseRadius), PhysicsImpulse.Max, PhysicsImpulse.Min);
		HavokImpartCOMImpulse(Multiply_VectorFloat(Normal(direction), magnitude));
	}
	Class'RWOSupport.Handler_GrenadeDetonated'.static.dispatch(GrenadeDetonatedHandlers, self, Grenade);
	return;
}

simulated function bool CanBeUsedNow()
{
	return AndAnd_BoolBool(UsableNow, Greater_IntInt(UsedHandlers.Length, 0));
	return;
}

simulated function OnUsed(Pawn Other)
{
	dispatchMessage(Class'Gameplay.MessageUsed'.static.Allocate(self)., construct_NameName(Other.Label, self.Label));
	BroadcastReactToUsed(Other);
	return;
}

simulated function PostUsed()
{
	return;
}

// Export UReactiveWorldObject::execRemoveProjectors(FFrame&, void* const)
native final simulated event RemoveProjectors();

defaultproperties
{
	UsableNow=true
	TriggerableNow=true
	hkMass=1.0000000
	hkFriction=0.8000000
	hkRestitution=0.3000000
	hkAngularDamping=0.0500000
	hkForceUprightStrength=0.3000000
	hkForceUprightDamping=0.9000000
	Physics=0
	bAcceptsShadowProjectors=false
	bShadowCast=true
	bBlockActors=false
	bBlockPlayers=false
	bBlockKarma=false
	bWeaponTestsPassThrough=true
}