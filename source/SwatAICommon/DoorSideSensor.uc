class DoorSideSensor extends AI_Sensor;

var Actor Target;
var Door Door;
var bool bNotifyOnLeftSide;

function NotifyTargetOnSide()
{
	setObjectValue(Target);
	return;
}

function cleanup()
{
	Target = none;
	return;
}

function setParameters(Actor inTarget, Door inDoor, bool inNotifyOnLeftSide)
{
	assert(NotEqual_ObjectObject(inTarget, none));
	Target = inTarget;
	assert(NotEqual_ObjectObject(inDoor, none));
	Door = inDoor;
	bNotifyOnLeftSide = inNotifyOnLeftSide;
	sensorAction.runAction();
	return;
}
