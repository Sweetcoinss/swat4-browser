class DistanceSensorAction extends AI_SensorAction
	collapsecategories
	hidecategories(Object,InternalParameters);

var DistanceSensor DistanceSensor;

function setupSensors(AI_Resource resource)
{
	DistanceSensor = DistanceSensor(addSensorClass(Class'SwatAICommon.DistanceSensor'));
	return;
}

function cleanup()
{
	super(ActionBase).cleanup();
	DistanceSensor = none;
	return;
}

function TestWithinRequiredDistance()
{
	DistanceSensor.UpdateTarget();
	if(DistanceSensor.IsWithinRequiredDistance())
	{
		DistanceSensor.NotifyWithinRequiredDistance();
	}
	else
	{
		DistanceSensor.NotifyOutsideRequiredDistance();
	}
	return;
}

state Running
{Begin:

	assert(NotEqual_ObjectObject(m_pawn, none));
	yield();
	J0x11:

	if(AndAnd_BoolBool(Class'Engine.Pawn'.static.checkConscious(Pawn()), Greater_IntInt(DistanceSensor.queryUsage(), 0)))
	{
		TestWithinRequiredDistance();
		Sleep(DistanceSensor.DistanceSensorUpdateRate);
		// [Loop Continue]
		goto J0x11;
	}
	Pause();
	goto 'Begin';
	stop;
}
