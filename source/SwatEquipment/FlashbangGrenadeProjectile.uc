class FlashbangGrenadeProjectile extends SwatGrenadeProjectile
	config(SwatEquipment)
	hidecategories(Karma);

var config float Damage;
var config float DamageRadius;
var config Range KarmaImpulse;
var config float KarmaImpulseRadius;
var config float StunRadius;
var config float PlayerStunDuration;
var config float AIStunDuration;
var config float MoraleModifier;

simulated function Detonated()
{
	local IReactToFlashbangGrenade Current;
	local float OuterRadius;

	OuterRadius = FMax(FMax(DamageRadius, KarmaImpulseRadius), StunRadius);
	foreach VisibleCollidingActors(Class'Engine.IReactToFlashbangGrenade', Current, OuterRadius)
	{
		if(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_IntInt(int(Actor(Current).Region.ZoneNumber), int(Region.ZoneNumber)), Not_PreBool(FastTrace(Actor(Current).Location))), NotEqual_NameName(GetLastTracedActor().Class.Name, 'DoorWay')))
		{
			continue;
		}
		Current.ReactToFlashbangGrenade(self, Pawn(Owner), Damage, DamageRadius, KarmaImpulse, KarmaImpulseRadius, StunRadius, PlayerStunDuration, AIStunDuration, MoraleModifier);
	}
	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)))
	{
		SwatGameInfo(Level.Game).GameEvents.GrenadeDetonated.Triggered(Pawn(Owner), self);
	}
	dispatchMessage(Class'SwatGame.MessageFlashbangGrenadeDetonated'.static.Allocate(self)., Construct_Void());
	bStasis = true;
	if(EqualEqual_IntInt(int(Level.DetailMode), int(0)))
	{
		LifeSpan = 30.0000000;
	}
	else
	{
		LifeSpan = 180.0000000;
	}
	return;
}

latent simulated function DoPostDetonation()
{
	Disable('Tick');
	return;
}

defaultproperties
{
	Damage=15.0000000
	DamageRadius=48.0000000
	KarmaImpulse=(Min=200.0000000,Max=300.0000000)
	KarmaImpulseRadius=800.0000000
	StunRadius=800.0000000
	PlayerStunDuration=12.0000000
	AIStunDuration=4.0000000
	MoraleModifier=0.4000000
	FuseTime=1.5000000
	NotifyAIsTime=0.7500000
	BounceDampening=0.4000000
	BounceCount=3
	StaticMesh=StaticMesh'SwatGear_sm.FlashbangThrown'
}