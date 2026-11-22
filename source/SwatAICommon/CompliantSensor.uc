class CompliantSensor extends AI_Sensor;

var Pawn Target;

function NotifyTargetCompliant()
{
	setObjectValue(none);
	return;
}

function NotifyFailed()
{
	setObjectValue(none);
	return;
}

function cleanup()
{
	Target = none;
	return;
}

function setParameters(Pawn inTarget)
{
	assert(NotEqual_ObjectObject(inTarget, none));
	Target = inTarget;
	sensorAction.runAction();
	return;
}
