class CSGasGrenadeProjectile extends SwatGrenadeProjectile
	config(SwatEquipment)
	hidecategories(Karma);

var config float UpdatePeriod;
var config float GasEmissionDuration;
var config float ReactionDuration;
var config float ExpansionTime;
var config Range Radius;
var config float SPPlayerProtectiveEquipmentDurationScaleFactor;
var config float MPPlayerProtectiveEquipmentDurationScaleFactor;
var float DetonatedTime;

simulated function Detonated()
{
	DetonatedTime = Level.TimeSeconds;
	GotoState('Active');
	dispatchMessage(Class'SwatGame.MessageCSGasGrenadeDetonated'.static.Allocate(self)., Construct_Void());
	return;
}

protected function float GetRadiusOfEffect()
{
	local float FractionOfMaxRadius, ElapsedTime;

	ElapsedTime = Subtract_FloatFloat(Level.TimeSeconds, DetonatedTime);
	FractionOfMaxRadius = FClamp(Divide_FloatFloat(ElapsedTime, ExpansionTime), 0.0000000, 1.0000000);
	return Lerp(FractionOfMaxRadius, Radius.Min, Radius.Max);
	return;
}

simulated state Active
{
	simulated event Timer()
	{
		local float Now;
		local IReactToCSGas Current;
		local float EffectRadius;

		Now = Level.TimeSeconds;
		if(Greater_FloatFloat(Now, Add_FloatFloat(DetonatedTime, GasEmissionDuration)))
		{
			SetTimer(0.0000000, false);
			GotoState('Dead');
		}
		else
		{
			EffectRadius = GetRadiusOfEffect();
			foreach RadiusActors(Class'Engine.IReactToCSGas', Current, EffectRadius)
			{
				if(OrOr_BoolBool(EqualEqual_ObjectObject(Actor(Current).Region.Zone, Region.Zone), FastTrace(Location, Actor(Current).Location)))
				{
					Current.ReactToCSGas(self, ReactionDuration, SPPlayerProtectiveEquipmentDurationScaleFactor, MPPlayerProtectiveEquipmentDurationScaleFactor);
				}
			}
		}
		return;
	}

	event Tick(float dTime)
	{
		super(SwatGrenadeProjectile).Tick(dTime);
		return;
	}

	simulated function Detonated()
	{
		AssertWithDescription(false, Concat_StrStr(Concat_StrStr("[tcohen] ", string(Name)), " Detonated(), but it is already Active."));
		return;
	}
Begin:

	SetTimer(UpdatePeriod, true);
	stop;
}

simulated state Dead
{
	simulated event Timer()
	{
		AssertWithDescription(false, Concat_StrStr(Concat_StrStr("[tcohen] ", string(Name)), " is Dead, but it is still getting Timer() events."));
		return;
	}

	simulated function Detonated()
	{
		AssertWithDescription(false, Concat_StrStr(Concat_StrStr("[tcohen] ", string(Name)), " Detonated, but it is Dead."));
		return;
	}
Begin:

	bBlockNonZeroExtentTraces = false;
	bStasis = true;
	Disable('Tick');
	if(EqualEqual_IntInt(int(Level.DetailMode), int(0)))
	{
		LifeSpan = 30.0000000;
	}
	else
	{
		LifeSpan = 180.0000000;
	}
	stop;
}

defaultproperties
{
	UpdatePeriod=0.5000000
	GasEmissionDuration=7.0000000
	ReactionDuration=11.5000000
	ExpansionTime=2.0000000
	Radius=(Min=20.0000000,Max=400.0000000)
	FuseTime=1.5000000
	NotifyAIsTime=0.7500000
	BounceDampening=0.4000000
	BounceCount=3
	StaticMesh=StaticMesh'SwatGear_sm.CSgasGrenadeThrown'
}