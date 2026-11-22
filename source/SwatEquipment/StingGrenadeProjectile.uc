class StingGrenadeProjectile extends SwatGrenadeProjectile
	config(SwatEquipment)
	hidecategories(Karma);

var config float Damage;
var config float DamageRadius;
var config Range KarmaImpulse;
var config float KarmaImpulseRadius;
var config float StingRadius;
var config float PlayerStingDuration;
var config float HeavilyArmoredPlayerStingDuration;
var config float AIStingDuration;
var config float MoraleModifier;

simulated function Detonated()
{
	local IReactToStingGrenade Current;
	local float OuterRadius;

	OuterRadius = FMax(FMax(DamageRadius, KarmaImpulseRadius), StingRadius);
	foreach VisibleCollidingActors(Class'Engine.IReactToStingGrenade', Current, OuterRadius)
	{
		if(NotEqual_IntInt(int(Actor(Current).Region.ZoneNumber), int(Region.ZoneNumber)))
		{
			if(Not_PreBool(FastTrace(Actor(Current).Location)))
			{
				continue;
			}
		}
		Current.ReactToStingGrenade(self, Pawn(Owner), Damage, DamageRadius, KarmaImpulse, KarmaImpulseRadius, StingRadius, PlayerStingDuration, HeavilyArmoredPlayerStingDuration, AIStingDuration, MoraleModifier);
	}
	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)))
	{
		SwatGameInfo(Level.Game).GameEvents.GrenadeDetonated.Triggered(Pawn(Owner), self);
	}
	dispatchMessage(Class'SwatGame.MessageStingGrenadeDetonated'.static.Allocate(self)., Construct_Void());
	return;
}

latent simulated function DoPostDetonation()
{
	bHidden = true;
	Disable('Tick');
	Sleep(3.0000000);
	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)))
	{
		Destroy();
	}
	return;
}

defaultproperties
{
	Damage=20.0000000
	DamageRadius=100.0000000
	KarmaImpulse=(Min=50.0000000,Max=300.0000000)
	KarmaImpulseRadius=640.0000000
	StingRadius=500.0000000
	PlayerStingDuration=8.0000000
	HeavilyArmoredPlayerStingDuration=4.0000000
	AIStingDuration=8.0000000
	MoraleModifier=0.4000000
	FuseTime=1.5000000
	NotifyAIsTime=0.7500000
	BounceDampening=0.4000000
	BounceCount=3
	StaticMesh=StaticMesh'SwatGear_sm.StingGrenadeThrown'
}