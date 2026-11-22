class CompliantSensorAction extends AI_SensorCharacterAction
	collapsecategories
	hidecategories(Object,InternalParameters);

var CompliantSensor CompliantSensor;

function setupSensors(AI_Resource resource)
{
	CompliantSensor = CompliantSensor(addSensorClass(Class'SwatAICommon.CompliantSensor'));
	return;
}

function cleanup()
{
	super(ActionBase).cleanup();
	if(NotEqual_ObjectObject(CompliantSensor, none))
	{
		CompliantSensor = none;
	}
	return;
}

state Running
{Begin:

	assert(NotEqual_ObjectObject(m_pawn, none));
	J0x0B:

	if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(Class'Engine.Pawn'.static.checkConscious(CompliantSensor.Target), Greater_IntInt(CompliantSensor.queryUsage(), 0)), Not_PreBool(ISwatAI(CompliantSensor.Target).IsCompliant())), OrOr_BoolBool(Not_PreBool(CompliantSensor.Target.IsA('SwatEnemy')), Not_PreBool(ISwatEnemy(CompliantSensor.Target).IsAThreat()))))
	{
		yield();
		// [Loop Continue]
		goto J0x0B;
	}
	if(Greater_IntInt(CompliantSensor.queryUsage(), 0))
	{
		if(AndAnd_BoolBool(Class'Engine.Pawn'.static.checkConscious(CompliantSensor.Target), ISwatAI(CompliantSensor.Target).IsCompliant()))
		{
			CompliantSensor.NotifyTargetCompliant();
		}
		else
		{
			CompliantSensor.NotifyFailed();
		}
	}
	Pause();
	goto 'Begin';
	stop;
}
