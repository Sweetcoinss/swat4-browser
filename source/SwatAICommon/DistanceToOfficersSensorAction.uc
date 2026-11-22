class DistanceToOfficersSensorAction extends DistanceSensorAction
	collapsecategories
	hidecategories(Object,InternalParameters);

function setupSensors(AI_Resource resource)
{
	DistanceSensor = DistanceSensor(addSensorClass(Class'SwatAICommon.DistanceToOfficersSensor'));
	return;
}
