class ReactiveKarmaActor extends ReactiveWorldObject
	config(SwatGame)
	hidecategories(Karma,Force,LightColor,Lighting,Object,Sound);

var float ImpactInterval;
var transient float LastImpactTime;
var config float MomentumToKarmaImpulseConversionFactor;

simulated function PostTakeDamage(int Damage, Pawn InstigatedBy, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType)
{
	if(EqualEqual_IntInt(int(Physics), int(13)))
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
	else
	{
		super(Actor).PostTakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType);
	}
	return;
}

simulated function Trigger(Actor Other, Pawn EventInstigator)
{
	if(EqualEqual_IntInt(int(Physics), int(13)))
	{
	}
	else
	{
		super.Trigger(Other, EventInstigator);
	}
	return;
}

simulated event KImpact(Actor Other, Vector pos, Vector impactVel, Vector impactNorm)
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
	MomentumToKarmaImpulseConversionFactor=150.0000000
	Physics=13
	bShadowCast=false
	bBlockKarma=true
}