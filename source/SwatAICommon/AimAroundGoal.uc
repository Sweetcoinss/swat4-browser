class AimAroundGoal extends SwatWeaponGoal
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) private float MinAimAtPointTime;
var(Parameters) private float MaxAimAtPointTime;
var(Parameters) private float MinWaitForNewPointTime;
var(Parameters) private float MaxWaitForNewPointTime;
var(Parameters) private bool bDoOnce;
var(Parameters) private bool bOnlyAimIfMoving;
var(Parameters) private float ExtraDoorWeight;
var(Parameters) private bool bAimWeapon;
var(Parameters) private bool bUseUpperBodyProcedurally;
var(Parameters) private bool bAimOnlyIfCharacterResourcesAvailable;
var(Parameters) private UpperBodyAnimBehaviorClients.EUpperBodyAnimBehaviorClientId UpperBodyAnimBehaviorClientId;
var(Parameters) private float AimInnerFovDot;
var(Parameters) private float AimOuterFovDot;
var(Parameters) private float PointTooCloseRadius;
var(Parameters) private bool bInitialDelay;
var(Parameters) private float MinInitialDelayTime;
var(Parameters) private bool MaxInitialDelayTime;
var config float DefaultInnerFovDegrees;
var config float DefaultOuterFovDegrees;
var config float DefaultMinAimAtPointTime;
var config float DefaultMaxAimAtPointTime;
var config float DefaultMinWaitForNewPointTime;
var config float DefaultMaxWaitForNewPointTime;

overloaded function Construct(AI_Resource R, optional int PRI)
{
	if(Greater_IntInt(PRI, 0))
	{
		Priority = PRI;
	}
	super.construct_AI_ResourceInt(R, Priority);
	assert(Greater_FloatFloat(DefaultMinAimAtPointTime, 0.0000000));
	assert(GreaterEqual_FloatFloat(DefaultMaxAimAtPointTime, DefaultMinAimAtPointTime));
	MinAimAtPointTime = DefaultMinAimAtPointTime;
	MaxAimAtPointTime = DefaultMaxAimAtPointTime;
	MinWaitForNewPointTime = DefaultMinWaitForNewPointTime;
	MaxWaitForNewPointTime = DefaultMaxWaitForNewPointTime;
	SetAimInnerFovDegrees(DefaultInnerFovDegrees);
	SetAimOuterFovDegrees(DefaultOuterFovDegrees);
	return;
}

overloaded function Construct(AI_Resource R, float inMinAimAtPointTime, float inMaxAimAtPointTime)
{
	construct_AI_ResourceInt(R, Priority);
	SetAimAtPointTime(inMinAimAtPointTime, inMaxAimAtPointTime);
	SetAimInnerFovDegrees(DefaultInnerFovDegrees);
	SetAimOuterFovDegrees(DefaultOuterFovDegrees);
	return;
}

function SetAimWeapon(bool inAimWeapon)
{
	bAimWeapon = inAimWeapon;
	return;
}

function SetDoOnce(bool inDoOnce)
{
	bDoOnce = inDoOnce;
	return;
}

function SetOnlyAimIfMoving(bool inOnlyAimIfMoving)
{
	bOnlyAimIfMoving = inOnlyAimIfMoving;
	return;
}

function SetExtraDoorWeight(float inExtraDoorWeight)
{
	ExtraDoorWeight = inExtraDoorWeight;
	return;
}

function SetAimInnerFovDegrees(float FovDegrees)
{
	AimInnerFovDot = SetAimFovDegrees(FovDegrees);
	return;
}

function SetAimOuterFovDegrees(float FovDegrees)
{
	AimOuterFovDot = SetAimFovDegrees(FovDegrees);
	return;
}

function SetAimAtPointTime(float inMinAimAtPointTime, float inMaxAimAtPointTime)
{
	assert(Greater_FloatFloat(inMinAimAtPointTime, 0.0000000));
	assert(GreaterEqual_FloatFloat(inMaxAimAtPointTime, inMinAimAtPointTime));
	MinAimAtPointTime = inMinAimAtPointTime;
	MaxAimAtPointTime = inMaxAimAtPointTime;
	return;
}

private function float SetAimFovDegrees(float FovDegrees)
{
	DivideEqual_FloatFloat(FovDegrees, 2.0000000);
	return Cos(Multiply_FloatFloat(Divide_FloatFloat(FovDegrees, 180.0000000), 3.1415930));
	return;
}

function SetPointTooCloseRadius(float Radius)
{
	PointTooCloseRadius = Radius;
	return;
}

defaultproperties
{
	MinAimAtPointTime=2.0000000
	MaxAimAtPointTime=5.0000000
	bUseUpperBodyProcedurally=true
	UpperBodyAnimBehaviorClientId=6
	PointTooCloseRadius=64.0000000
	Priority=35
	goalName="AimAround"
}