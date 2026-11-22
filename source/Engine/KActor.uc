class KActor extends Actor
	native
	config(SwatGame)
	placeable
	hidecategories(Karma);

cpptext
{
	virtual void Spawned();

}

var(Karma) bool bKTakeShot;
var array<Sound> ImpactSounds;
var float ImpactVolume;
var Class<Actor> ImpactEffect;
var bool bOrientImpactEffect;
var float ImpactInterval;
var transient float LastImpactTime;
var config float MomentumToKarmaImpulseConversionFactor;
var(Ballistics) float OverrideMomentumToPenetrate "If this is > -1, then OverrideMomentumToPenetrate is used instead of its Material's MomentumToPenetrate when calculating impact ballistics.";

simulated function float GetMomentumToPenetrate(Vector HitLocation, Vector HitNormal, Material MaterialHit)
{
	if(Greater_FloatFloat(OverrideMomentumToPenetrate, float(-1)))
	{
		return OverrideMomentumToPenetrate;
	}
	else
	{
		return MaterialHit.MomentumToPenetrate;
	}
	return;
}

function PostTakeDamage(int Damage, Pawn InstigatedBy, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType)
{
	if(bKTakeShot)
	{
		if(Less_FloatFloat(VSize(Momentum), 0.0010000))
		{
			return;
		}
		if(Level.AnalyzeBallistics)
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[BALLISTICS] The KActor named ", string(Name)), " took damage with Momentum="), string(VSize(Momentum))), ".  MomentumToKarmaImpulseConversionFactor="), string(MomentumToKarmaImpulseConversionFactor)), ".  Adding Karma impulse "), string(VSize(Multiply_VectorFloat(Momentum, MomentumToKarmaImpulseConversionFactor)))));
		}
	}
	return;
}

function Trigger(Actor Other, Pawn EventInstigator)
{
	return;
}

event KImpact(Actor Other, Vector pos, Vector impactVel, Vector impactNorm)
{
	if(Greater_FloatFloat(Level.TimeSeconds, Add_FloatFloat(LastImpactTime, ImpactInterval)))
	{
		TriggerEffectEvent('KarmaImpacted');
		LastImpactTime = Level.TimeSeconds;
	}
	return;
}

defaultproperties
{
	bKTakeShot=true
	MomentumToKarmaImpulseConversionFactor=150.0000000
	OverrideMomentumToPenetrate=-1.0000000
	Physics=13
	DrawType=8
	bNoDelete=true
	RemoteRole=0
	CollisionRadius=1.0000000
	CollisionHeight=1.0000000
	bCollideActors=true
	bBlockActors=true
	bBlockPlayers=true
	bProjTarget=true
	bBlockKarma=true
	bEdShouldSnap=true
}