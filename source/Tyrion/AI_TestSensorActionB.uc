class AI_TestSensorActionB extends AI_SensorMovementAction
	collapsecategories
	hidecategories(Object,InternalParameters);

var AI_TestSentinelA sentinel1;
var AI_TestSentinelB sentinel2;

function setupSensors(AI_Resource resource)
{
	sentinel1 = AI_TestSentinelA(addSensorClass(Class'Tyrion.AI_TestSentinelA'));
	sentinel2 = AI_TestSentinelB(addSensorClass(Class'Tyrion.AI_TestSentinelB'));
	return;
}

state Running
{Begin:

	sentinel1.setIntegerValue(-5);
	sentinel2.setIntegerValue(-10);
	J0x28:

	if(true)
	{
		sentinel1.setIntegerValue(Add_IntInt(sentinel1.Value.integerData, 1));
		Log(At_StrStr("AI_TestSentinelA says value is", string(sentinel1.Value.integerData)));
		sentinel2.setIntegerValue(Add_IntInt(sentinel2.Value.integerData, 1));
		Log(Concat_StrStr("AI_TestSentinelB says value is ", string(sentinel2.Value.integerData)));
		Sleep(3.0000000);
		// [Loop Continue]
		goto J0x28;
	}
	stop;
}
