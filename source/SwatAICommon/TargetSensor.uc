class TargetSensor extends AI_Sensor;

var Actor Target;
var Pawn TargetPawn;
var bool bCanHitTarget;

function NotifyCanHitTarget()
{
	bCanHitTarget = true;
	setObjectValue(Target);
	return;
}

function NotifyCannotHitTarget()
{
	bCanHitTarget = false;
	setObjectValue(none);
	return;
}

function setParameters(Actor inTarget)
{
	AssertWithDescription(NotEqual_ObjectObject(inTarget, none), "TargetSensor::setParameters - inTarget passed in is None!");
	if(NotEqual_ObjectObject(Target, inTarget))
	{
		Target = inTarget;
		TargetPawn = Pawn(Target);
		if(TargetSensorAction(sensorAction).Pawn().CanHit(Target))
		{
			NotifyCanHitTarget();
		}
		else
		{
			NotifyCannotHitTarget();
		}
	}
	assert(NotEqual_ObjectObject(sensorAction, none));
	assert(sensorAction.IsA('TargetSensorAction'));
	if(sensorAction.IsIdle())
	{
		if(sensorAction.m_pawn.logTyrion)
		{
			Log(Concat_StrStr(Concat_StrStr(string(sensorAction.Name), " told to run by "), string(Name)));
		}
		sensorAction.runAction();
	}
	return;
}
