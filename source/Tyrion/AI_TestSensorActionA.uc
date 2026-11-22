class AI_TestSensorActionA extends AI_SensorCharacterAction
	collapsecategories
	hidecategories(Object,InternalParameters);

var AI_Sensor sensor1;

function setupSensors(AI_Resource resource)
{
	sensor1 = addSensorClass(Class'Tyrion.AI_TestSensorA');
	return;
}

state Running
{Begin:

	sensor1.setIntegerValue(55);
	J0x11:

	if(true)
	{
		if(Greater_IntInt(sensor1.queryUsage(), 0))
		{
			sensor1.setIntegerValue(Subtract_IntInt(sensor1.Value.integerData, 1));
		}
		Log(At_StrStr("AI_TestSensorA says value is", string(sensor1.Value.integerData)));
		Sleep(3.0000000);
		// [Loop Continue]
		goto J0x11;
	}
	stop;
}
