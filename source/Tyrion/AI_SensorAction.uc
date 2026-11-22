class AI_SensorAction extends AI_RunnableAction
	abstract
	collapsecategories
	hidecategories(Object,InternalParameters);

var int usageCount;
var bool bCallBegin;
var Pawn m_pawn;

overloaded function Construct(AI_Resource R)
{
	resource = R;
	m_pawn = R.Pawn();
	assert(NotEqual_ObjectObject(m_pawn, none));
	GotoState('Running');
	return;
}

function Pawn Pawn()
{
	return m_pawn;
	return;
}

function AI_SensorAction myAddRef()
{
	AddRef();
	return self;
	return;
}

function setupSensors(AI_Resource R)
{
	return;
}

function Begin()
{
	return;
}

function runAction()
{
	super.runAction();
	return;
}

event instantFail(ActionBase.ACT_ErrorCodes errorCode, optional bool bRemoveGoal)
{
	return;
}

function AI_Sensor addSensorClass(Class<AI_Sensor> sensorClass)
{
	local AI_Sensor sensor;

	sensor = sensorClass.static.Allocate(self, resource).;
	construct_AI_SensorAction(self);
	resource.sensors[resource.sensors.Length] = sensor;
	return sensor;
	return;
}

defaultproperties
{
	bCallBegin=true
	bSensorAction=true
}