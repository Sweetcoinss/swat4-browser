class ArrestedSensorAction extends AI_SensorCharacterAction
	collapsecategories
	hidecategories(Object,InternalParameters);

var ArrestedSensor ArrestedSensor;

function setupSensors(AI_Resource resource)
{
	ArrestedSensor = ArrestedSensor(addSensorClass(Class'SwatAICommon.ArrestedSensor'));
	return;
}

function cleanup()
{
	super(ActionBase).cleanup();
	if(NotEqual_ObjectObject(ArrestedSensor, none))
	{
		ArrestedSensor = none;
	}
	return;
}

state Running
{Begin:

	assert(NotEqual_ObjectObject(m_pawn, none));
	J0x0B:

	if(AndAnd_BoolBool(AndAnd_BoolBool(Class'Engine.Pawn'.static.checkConscious(ArrestedSensor.Target), Greater_IntInt(ArrestedSensor.queryUsage(), 0)), Not_PreBool(ISwatAI(ArrestedSensor.Target).IsArrested())))
	{
		yield();
		// [Loop Continue]
		goto J0x0B;
	}
	if(Greater_IntInt(ArrestedSensor.queryUsage(), 0))
	{
		if(AndAnd_BoolBool(Class'Engine.Pawn'.static.checkConscious(ArrestedSensor.Target), ISwatAI(ArrestedSensor.Target).IsArrested()))
		{
			ArrestedSensor.NotifyTargetArrested();
		}
	}
	Pause();
	goto 'Begin';
	stop;
}
