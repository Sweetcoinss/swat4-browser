class AI_SensorWithBounds extends DeleteableObject
	native;

var AI_Sensor sensor;
var float lowerBound;
var float upperBound;

function activateSensor(ISensorNotification Recipient, Class<AI_Sensor> sensorClass, AI_Resource resource, optional float lowerBound, optional float upperBound, optional Object userData)
{
	self.lowerBound = lowerBound;
	self.upperBound = upperBound;
	sensor = Class'Tyrion.AI_Sensor'.static.activateSensor(Recipient, sensorClass, resource, lowerBound, upperBound, userData);
	return;
}

function activateSentinel(AI_Goal Goal, Class<AI_Sensor> sentinelClass, AI_Resource resource, optional float lowerBound, optional float upperBound, optional Object userData)
{
	self.lowerBound = lowerBound;
	self.upperBound = upperBound;
	sensor = Class'Tyrion.AI_Sensor'.static.activateSensor(Goal, sentinelClass, resource, lowerBound, upperBound, userData);
	return;
}

function deactivateSensor(ISensorNotification Recipient)
{
	sensor.deactivateSensor(Recipient, lowerBound, upperBound);
	return;
}

function deactivateSentinel(AI_Goal Goal)
{
	sensor.deactivateSensor(Goal, lowerBound, upperBound);
	return;
}
