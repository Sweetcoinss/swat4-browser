class AimAtTargetGoal extends SwatWeaponGoal
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) private Actor Target;
var(Parameters) private bool bOnlyWhenCanHitTarget;
var(Parameters) private bool bShouldFinishOnSuccess;
var(Parameters) private bool bAimWeapon;
var(Parameters) private bool bHoldAimForPeriodOfTime;
var(Parameters) private float HoldAimTime;
var(Parameters) private float MinDistanceToTargetToAim;

overloaded function Construct(AI_Resource R)
{
	assert(false);
	return;
}

overloaded function Construct(AI_Resource R, Actor inTarget)
{
	construct_AI_ResourceInt(R, Priority);
	assert(NotEqual_ObjectObject(inTarget, none));
	Target = inTarget;
	return;
}

overloaded function Construct(AI_Resource R, int PRI, Actor inTarget)
{
	construct_AI_ResourceInt(R, PRI);
	assert(NotEqual_ObjectObject(inTarget, none));
	Target = inTarget;
	return;
}

function SetAimOnlyWhenCanHitTarget(bool inOnlyAimWhenCanHitTarget)
{
	bOnlyWhenCanHitTarget = inOnlyAimWhenCanHitTarget;
	return;
}

function SetShouldFinishOnSuccess(bool inShouldFinishOnSuccess)
{
	bShouldFinishOnSuccess = inShouldFinishOnSuccess;
	return;
}

function SetAimWeapon(bool inAimWeapon)
{
	bAimWeapon = inAimWeapon;
	return;
}

overloaded function SetHoldAimTime()
{
	return;
}

overloaded function SetHoldAimTime(float inHoldAimTime)
{
	assert(GreaterEqual_FloatFloat(inHoldAimTime, 0.0000000));
	bHoldAimForPeriodOfTime = true;
	HoldAimTime = inHoldAimTime;
	return;
}

overloaded function SetHoldAimTime(float inMinHoldAimTime, float inMaxHoldAimTime)
{
	SetHoldAimTime_Float(RandRange(inMinHoldAimTime, inMaxHoldAimTime));
	return;
}

function SetMinDistanceToTargetToAim(float inMinDistanceToTargetToAim)
{
	MinDistanceToTargetToAim = inMinDistanceToTargetToAim;
	return;
}

defaultproperties
{
	bAimWeapon=true
	Priority=75
	goalName="AimAtTarget"
}