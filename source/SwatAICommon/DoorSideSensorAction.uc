class DoorSideSensorAction extends AI_SensorCharacterAction
	collapsecategories
	hidecategories(Object,InternalParameters);

var DoorSideSensor DoorSideSensor;

function setupSensors(AI_Resource resource)
{
	DoorSideSensor = DoorSideSensor(addSensorClass(Class'SwatAICommon.DoorSideSensor'));
	return;
}

function cleanup()
{
	super(ActionBase).cleanup();
	if(NotEqual_ObjectObject(DoorSideSensor, none))
	{
		DoorSideSensor = none;
	}
	return;
}

state Running
{Begin:

	assert(NotEqual_ObjectObject(m_pawn, none));
	J0x0B:

	if(Greater_IntInt(DoorSideSensor.queryUsage(), 0))
	{
		if(EqualEqual_BoolBool(DoorSideSensor.bNotifyOnLeftSide, ISwatDoor(DoorSideSensor.Door).ActorIsToMyLeft(DoorSideSensor.Target)))
		{
			DoorSideSensor.NotifyTargetOnSide();
		}
		yield();
		// [Loop Continue]
		goto J0x0B;
	}
	Pause();
	goto 'Begin';
	stop;
}
