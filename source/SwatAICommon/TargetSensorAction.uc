class TargetSensorAction extends AI_SensorCharacterAction
	collapsecategories
	hidecategories(Object,InternalParameters);

var TargetSensor TargetSensor;
var private bool bCurrentlyCanHitTarget;

function setupSensors(AI_Resource resource)
{
	TargetSensor = TargetSensor(addSensorClass(Class'SwatAICommon.TargetSensor'));
	return;
}

function cleanup()
{
	super(ActionBase).cleanup();
	if(NotEqual_ObjectObject(TargetSensor, none))
	{
		TargetSensor = none;
	}
	return;
}

function TestCanHitTarget()
{
	local bool bCanHitTarget;

	bCanHitTarget = m_pawn.CanHit(TargetSensor.Target);
	if(AndAnd_BoolBool(TargetSensor.bCanHitTarget, Not_PreBool(bCanHitTarget)))
	{
		TargetSensor.NotifyCannotHitTarget();
	}
	else
	{
		if(AndAnd_BoolBool(Not_PreBool(TargetSensor.bCanHitTarget), bCanHitTarget))
		{
			TargetSensor.NotifyCanHitTarget();
		}
	}
	return;
}

state Running
{Begin:

	assert(NotEqual_ObjectObject(m_pawn, none));
	if(m_pawn.logTyrion)
	{
		Log(Concat_StrStr(string(Name), " running!"));
	}
	J0x33:

	if(AndAnd_BoolBool(OrOr_BoolBool(EqualEqual_ObjectObject(TargetSensor.TargetPawn, none), Class'Engine.Pawn'.static.checkConscious(TargetSensor.TargetPawn)), Greater_IntInt(TargetSensor.queryUsage(), 0)))
	{
		TestCanHitTarget();
		yield();
		// [Loop Continue]
		goto J0x33;
	}
	if(Greater_IntInt(TargetSensor.queryUsage(), 0))
	{
		if(m_pawn.logTyrion)
		{
			Log(Concat_StrStr(string(Name), " says target dead! Notifying sensor!"));
		}
		TargetSensor.NotifyCannotHitTarget();
	}
	Pause();
	goto 'Begin';
	stop;
}
