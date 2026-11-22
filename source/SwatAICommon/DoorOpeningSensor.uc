class DoorOpeningSensor extends AI_Sensor implements IInterestedInDoorOpening;

var array<Door> TargetDoors;

function cleanup()
{
	super.cleanup();
	J0x06:

	if(Greater_IntInt(TargetDoors.Length, 0))
	{
		ISwatDoor(TargetDoors[0]).UnRegisterInterestedInDoorOpening(self);
		TargetDoors.Remove(0, 1);
		// [Loop Continue]
		goto J0x06;
	}
	return;
}

function NotifyDoorOpening(Door TargetDoor)
{
	setObjectValue(TargetDoor);
	return;
}

function setParameters(Door inTargetDoor)
{
	AddDoor(inTargetDoor);
	return;
}

function AddDoor(Door inTargetDoor)
{
	AssertWithDescription(NotEqual_ObjectObject(inTargetDoor, none), "DoorSensor::AddDoor - inTargetDoor passed in is None!");
	TargetDoors[TargetDoors.Length] = inTargetDoor;
	ISwatDoor(inTargetDoor).RegisterInterestedInDoorOpening(self);
	return;
}
