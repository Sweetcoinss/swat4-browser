class Reaction_DamageRadius extends Reaction
	editinlinenew
	collapsecategories
	hidecategories(Object);

enum EDropOffMode
{
	DropOff_None,                   // 0
	DropOff_Linear,                 // 1
	DropOff_Exponential             // 2
};

var(Reaction) float Radius "The radius at which damage should be applied";
var(Reaction) float DamagePerInterval "The amount of damage applied to victims every interval (specified in IntervalTime)";
var(Reaction) float IntervalTime "The interval of time between each application of damage to victims";
var(Reaction) int Intervals "The number of times to apply damage";
var(Reaction) Reaction_DamageRadius.EDropOffMode DropOffMode "How damage should be reduced from the center of the RWO to the Radius distance.  'None' means that the full DamagePerInterval is applied throughout the Raidus.  'Linear' means that damage drops-off linearly from the center to the Radius distance, and 'Exponential' means that damage drops-off exponentially from the center to the Radius distance.";
var(Reaction) name DamageAlternateOrigin "The Tag of an Actor to use as the center of the damage radius instead of the RWO that owns this Reaction.  Leave 'None' to use the RWO that owns this Reaction.";
var Actor DamageInstigator;
var Actor DamageSource;
var Timer DamageTimer;
var int DeltCount;
var float LastExecuteTime;

protected simulated function execute(Actor Owner, Actor Other)
{
	local float Now;

	Now = Owner.Level.TimeSeconds;
	if(EqualEqual_FloatFloat(LastExecuteTime, Now))
	{
		return;
	}
	LastExecuteTime = Now;
	if(EqualEqual_NameName(DamageAlternateOrigin, 'None'))
	{
		DamageSource = Owner;
	}
	else
	{
		foreach Owner.DynamicActors(Class'Engine.Actor', DamageSource, DamageAlternateOrigin)
		{
			break;
		}
	}
	DamageInstigator = Other;
	if(EqualEqual_ObjectObject(DamageInstigator, none))
	{
		DamageInstigator = DamageSource;
	}
	if(NotEqual_ObjectObject(DamageSource, none))
	{
		DealDamage();
	}
	return;
}

simulated function DealDamage()
{
	local Actor Current;

	foreach DamageSource.VisibleCollidingActors(Class'Engine.Actor', Current, Radius, DamageSource.Location)
	{
		if(OrOr_BoolBool(Not_PreBool(Current.IsA('Pawn')), DamageSource.FastTrace(DamageSource.Location, Current.Location)))
		{
			DealDamageTo(Current, DamageSource);
		}
	}
	AddAdd_PreInt(DeltCount);
	if(GreaterEqual_IntInt(Intervals, DeltCount))
	{
		if(LessEqual_FloatFloat(IntervalTime, float(0)))
		{
			AssertWithDescription(false, Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] ", string(DamageSource)), "'s "), string(Name)), "'s IntervalTime must be greater than zero."));
		}
		if(EqualEqual_ObjectObject(DamageTimer, none))
		{
			DamageTimer = DamageSource.Spawn(Class'Engine.Timer');
			DamageTimer.__TimerDelegate__Delegate = DealDamage;
		}
		DamageTimer.StartTimer(IntervalTime, false, true);
	}
	else
	{
		if(NotEqual_ObjectObject(DamageTimer, none))
		{
			DamageTimer.Destroy();
			DamageTimer = none;
		}
	}
	return;
}

private simulated function DealDamageTo(Actor Target, Actor Source)
{
	local Vector direction;
	local float Distance, Damage;
	local Vector Momentum;

	direction = Subtract_VectorVector(Target.Location, Source.Location);
	Distance = VSize(direction);
	switch(DropOffMode)
	{
		case 0:
			Damage = DamagePerInterval;
			break;
		case 1:
			Damage = Multiply_FloatFloat(DamagePerInterval, Subtract_FloatFloat(float(1), Divide_FloatFloat(Distance, Radius)));
			break;
		case 2:
			Damage = Multiply_FloatFloat(DamagePerInterval, Subtract_FloatFloat(float(1), Square(Divide_FloatFloat(Distance, Radius))));
			break;
		default:
			AssertWithDescription(false, Concat_StrStr(Concat_StrStr("[tcohen] ", string(Name)), "::DealDamageTo(): unexpected DropOffMode value"));
			break;
	}
	Momentum = Divide_VectorFloat(Multiply_VectorFloat(Normal(direction), Damage), Target.Level.GetRepo().MomentumToDamageConversionFactor);
	Target.TakeDamage(int(Damage), Pawn(DamageInstigator), Target.Location, Momentum, Class'RWOSupport.DamageRadiusDamageType');
	return;
}

defaultproperties
{
	Radius=500.0000000
	DamagePerInterval=100.0000000
	IntervalTime=1.0000000
}