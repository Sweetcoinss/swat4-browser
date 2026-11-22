class CommonSensorAction extends AI_SensorCharacterAction
	collapsecategories
	hidecategories(Object,InternalParameters);

var private VisionSensor VisionSensor;
var private HearingSensor HearingSensor;
var private ComplySensor ComplySensor;
var private DoorOpeningSensor DoorOpeningSensor;

function setupSensors(AI_Resource resource)
{
	super(AI_SensorAction).setupSensors(resource);
	VisionSensor = VisionSensor(addSensorClass(Class'SwatAICommon.VisionSensor'));
	HearingSensor = HearingSensor(addSensorClass(Class'SwatAICommon.HearingSensor'));
	ComplySensor = ComplySensor(addSensorClass(Class'SwatAICommon.ComplySensor'));
	DoorOpeningSensor = DoorOpeningSensor(addSensorClass(Class'SwatAICommon.DoorOpeningSensor'));
	return;
}

function cleanup()
{
	super(ActionBase).cleanup();
	VisionSensor = none;
	HearingSensor = none;
	ComplySensor = none;
	DoorOpeningSensor = none;
	return;
}

function VisionSensor GetVisionSensor()
{
	return VisionSensor;
	return;
}

function HearingSensor GetHearingSensor()
{
	return HearingSensor;
	return;
}

function ComplySensor GetComplySensor()
{
	return ComplySensor;
	return;
}

state Running
{Begin:

	Log(At_StrStr(string(self.Name), "!!! SHOULD NEVER BE CALLED !!!"));
	assert(false);
	stop;
}
