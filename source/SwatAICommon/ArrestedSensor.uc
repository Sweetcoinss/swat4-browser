class ArrestedSensor extends AI_Sensor;

var Pawn Target;

function NotifyTargetArrested()
{
	setObjectValue(Target);
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
