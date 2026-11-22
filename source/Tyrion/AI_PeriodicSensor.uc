class AI_PeriodicSensor extends AI_Sensor
	abstract;

protected static function AI_Sensor activateSensorInternal(Class<AI_Sensor> sensorClass, AI_Resource R, optional float lowerBound, optional float upperBound, optional Object userData, optional ISensorNotification Recipient)
{
	local AI_PeriodicSensor sensor;

	sensor = AI_PeriodicSensor(super.activateSensorInternal(sensorClass, R, lowerBound, upperBound, userData, Recipient));
	if(NotEqual_ObjectObject(sensor, none))
	{
		AddAdd_Int(sensor.sensorAction.usageCount);
		if(EqualEqual_IntInt(sensor.sensorAction.usageCount, 1))
		{
			sensor.sensorAction.runAction();
		}
	}
	return sensor;
	return;
}

protected function deactivateSensorInternal(ISensorNotification Recipient, optional float lowerBound, optional float upperBound)
{
	super.deactivateSensorInternal(Recipient, lowerBound, upperBound);
	SubtractSubtract_Int(sensorAction.usageCount);
	if(AndAnd_BoolBool(EqualEqual_IntInt(recipients.Length, 0), EqualEqual_IntInt(sensorAction.usageCount, 0)))
	{
		sensorAction.pauseAction();
	}
	return;
}

defaultproperties
{
	bNotifyOnValueChange=true
}