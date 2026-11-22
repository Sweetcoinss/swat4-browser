class ThreatenedSensorAction extends AI_SensorCharacterAction
	collapsecategories
	hidecategories(Object,InternalParameters);

const kUpdateTime = 1.0;

var ThreatenedSensor ThreatenedSensor;

function setupSensors(AI_Resource resource)
{
	ThreatenedSensor = ThreatenedSensor(addSensorClass(Class'SwatAICommon.ThreatenedSensor'));
	return;
}

function cleanup()
{
	super(ActionBase).cleanup();
	if(NotEqual_ObjectObject(ThreatenedSensor, none))
	{
		ThreatenedSensor = none;
	}
	return;
}

function UpdateThreatFrom(Pawn ThreateningPawn)
{
	if(AndAnd_BoolBool(ISwatAI(m_pawn).IsOtherActorAThreat(ThreateningPawn), Class'SwatAICommon.SwatWeaponAction'.static.IsAThreatBasedOnAim(ThreateningPawn, m_pawn)))
	{
		if(AndAnd_BoolBool(ThreateningPawn.IsA('SwatEnemy'), Not_PreBool(ISwatEnemy(ThreateningPawn).IsAThreat())))
		{
			ISwatEnemy(ThreateningPawn).BecomeAThreat();
		}
		if(NotEqual_ObjectObject(ThreatenedSensor.ThreatenedBy, ThreateningPawn))
		{
			ThreatenedSensor.NotifyThreatened(ThreateningPawn);
			if(IsIdle())
			{
				runAction();
			}
		}
	}
	return;
}

function bool IsThreatened()
{
	return Class'Engine.Pawn'.static.checkConscious(ThreatenedSensor.ThreatenedBy);
	return;
}

state Running
{Begin:

	assert(NotEqual_ObjectObject(m_pawn, none));
	J0x0B:

	if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(Class'Engine.Pawn'.static.checkConscious(ThreatenedSensor.ThreatenedBy), Greater_IntInt(ThreatenedSensor.queryUsage(), 0)), ISwatAI(m_pawn).IsOtherActorAThreat(ThreatenedSensor.ThreatenedBy)), Class'SwatAICommon.SwatWeaponAction'.static.IsAThreatBasedOnAim(ThreatenedSensor.ThreatenedBy, m_pawn)))
	{
		yield();
		// [Loop Continue]
		goto J0x0B;
	}
	ThreatenedSensor.NotifyNoLongerThreatened();
	Pause();
	goto 'Begin';
	stop;
}
