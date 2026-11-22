class SwatMovementResource extends AI_MovementResource
	editinlinenew;

var DistanceSensorAction MovementDistanceSensorAction;

event Init()
{
	super.Init();
	MovementDistanceSensorAction = DistanceSensorAction(addSensorActionClass(Class'SwatAICommon.DistanceSensorAction'));
	return;
}

function cleanup()
{
	MovementDistanceSensorAction = none;
	super.cleanup();
	return;
}
