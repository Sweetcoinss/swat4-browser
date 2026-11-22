class Handler_KarmaImpacted extends Handler
	editinlinenew
	collapsecategories
	hidecategories(Object);

var(Handler) float MinimumVelocity;
var(Handler) bool AccumulateVelocity;
var float AccumulatedVelocity;

static final simulated function dispatch(array<Handler> Handlers, Actor Owner, Actor Other, Vector pos, Vector impactVel, Vector impactNorm)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, Handlers.Length))
	{
		Handler_KarmaImpacted(Handlers[i]).Handle(Owner, Other, pos, impactVel, impactNorm);
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

final simulated function Handle(Actor Owner, Actor Other, Vector pos, Vector impactVel, Vector impactNorm)
{
	local float velocityMagnitude;

	velocityMagnitude = VSize(impactVel);
	AddEqual_FloatFloat(AccumulatedVelocity, velocityMagnitude);
	if(AccumulateVelocity)
	{
		if(Less_FloatFloat(AccumulatedVelocity, MinimumVelocity))
		{
			return;
		}
	}
	else
	{
		if(Less_FloatFloat(velocityMagnitude, MinimumVelocity))
		{
			return;
		}
	}
	DoReactions(Owner, Other);
	return;
}
