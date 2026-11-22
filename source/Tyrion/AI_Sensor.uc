class AI_Sensor extends DeleteableObject implements ISensorNotification
	abstract
	native;

const ONLY_NONE_VALUE = 1;
const ONLY_NON_NONE_VALUE = 2;

var AI_SensorAction sensorAction;
var array<AI_SensorRecipient> recipients;
var AI_SensorData Value;
var bool bNotifyOnValueChange;
var bool bNotifyIfResourceInactive;

function OnSensorMessage(AI_Sensor sensor, AI_SensorData Value, Object userData)
{
	return;
}

function AI_Resource getResource()
{
	return sensorAction.resource;
	return;
}

overloaded function Construct(AI_SensorAction Action)
{
	sensorAction = Action;
	Value = Class'Tyrion.AI_SensorData'.static.Allocate(self).;
	Construct_Void();
	return;
}

static function AI_Sensor activateSensor(ISensorNotification Recipient, Class<AI_Sensor> sensorClass, AI_Resource resource, optional float lowerBound, optional float upperBound, optional Object userData)
{
	return sensorClass.static.activateSensorInternal(sensorClass, resource, lowerBound, upperBound, userData, Recipient);
	return;
}

static function AI_Sensor activateSentinel(AI_Goal Goal, Class<AI_Sensor> sentinelClass, AI_Resource resource, optional float lowerBound, optional float upperBound, optional Object userData)
{
	return sentinelClass.static.activateSensorInternal(sentinelClass, resource, lowerBound, upperBound, userData, Goal);
	return;
}

function deactivateSensor(ISensorNotification Recipient, optional float lowerBound, optional float upperBound)
{
	deactivateSensorInternal(Recipient, lowerBound, upperBound);
	return;
}

function deactivateSentinel(AI_Goal Goal, optional float lowerBound, optional float upperBound)
{
	deactivateSensorInternal(Goal, lowerBound, upperBound);
	return;
}

function Begin()
{
	return;
}

function cleanup()
{
	return;
}

protected function sendSensorMessage(AI_SensorRecipient Recipient, AI_SensorData Value)
{
	if(OrOr_BoolBool(bNotifyIfResourceInactive, Recipient.Recipient.getResource().isActive()))
	{
		Recipient.Recipient.OnSensorMessage(self, Value, Recipient.userData);
	}
	return;
}

function sendMessageOnNextValueUpdate(ISensorNotification Recipient)
{
	local int i;
	local AI_SensorRecipient sensorRecipient;

	i = 0;
	J0x07:

	if(Less_IntInt(i, recipients.Length))
	{
		sensorRecipient = recipients[i];
		if(EqualEqual_ObjectObject(sensorRecipient.Recipient, Recipient))
		{
			sensorRecipient.bNotify = true;
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

function setIntegerValue(int NewValue)
{
	local int i;
	local AI_SensorRecipient sensorRecipient;
	local int OldValue;
	local array<AI_SensorRecipient> sendList;

	OldValue = Value.integerData;
	Value.dataType = 1;
	Value.integerData = NewValue;
	i = 0;
	J0x40:

	if(Less_IntInt(i, recipients.Length))
	{
		sensorRecipient = recipients[i];
		if(AndAnd_BoolBool(AndAnd_BoolBool(GreaterEqual_FloatFloat(float(NewValue), sensorRecipient.lowerBound), LessEqual_FloatFloat(float(NewValue), sensorRecipient.upperBound)), OrOr_BoolBool(OrOr_BoolBool(OrOr_BoolBool(sensorRecipient.bNotify, Not_PreBool(bNotifyOnValueChange)), Less_FloatFloat(float(OldValue), sensorRecipient.lowerBound)), Greater_FloatFloat(float(OldValue), sensorRecipient.upperBound))))
		{
			sensorRecipient.bNotify = false;
			sendList[sendList.Length] = sensorRecipient;
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x40;
	}
	i = 0;
	J0x124:

	if(Less_IntInt(i, sendList.Length))
	{
		sendSensorMessage(sendList[i], Value);
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x124;
	}
	return;
}

function setFloatValue(float NewValue)
{
	local int i;
	local AI_SensorRecipient sensorRecipient;
	local float OldValue;
	local array<AI_SensorRecipient> sendList;

	OldValue = Value.floatData;
	Value.dataType = 0;
	Value.floatData = NewValue;
	i = 0;
	J0x40:

	if(Less_IntInt(i, recipients.Length))
	{
		sensorRecipient = recipients[i];
		if(AndAnd_BoolBool(AndAnd_BoolBool(GreaterEqual_FloatFloat(NewValue, sensorRecipient.lowerBound), LessEqual_FloatFloat(NewValue, sensorRecipient.upperBound)), OrOr_BoolBool(OrOr_BoolBool(OrOr_BoolBool(sensorRecipient.bNotify, Not_PreBool(bNotifyOnValueChange)), Less_FloatFloat(OldValue, sensorRecipient.lowerBound)), Greater_FloatFloat(OldValue, sensorRecipient.upperBound))))
		{
			sensorRecipient.bNotify = false;
			sendList[sendList.Length] = sensorRecipient;
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x40;
	}
	i = 0;
	J0x11C:

	if(Less_IntInt(i, sendList.Length))
	{
		sendSensorMessage(sendList[i], Value);
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x11C;
	}
	return;
}

function setCategoricalValue(int NewValue)
{
	Log("setCategoricalValue: Not yet implemented");
	return;
}

function setObjectValue(Object NewValue)
{
	local int i;
	local AI_SensorRecipient sensorRecipient;
	local Object OldValue;
	local array<AI_SensorRecipient> sendList;

	OldValue = Value.objectData;
	Value.dataType = 3;
	Value.objectData = NewValue;
	i = 0;
	J0x40:

	if(Less_IntInt(i, recipients.Length))
	{
		sensorRecipient = recipients[i];
		if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(OrOr_BoolBool(NotEqual_FloatFloat(sensorRecipient.upperBound, float(2)), NotEqual_ObjectObject(NewValue, none)), OrOr_BoolBool(NotEqual_FloatFloat(sensorRecipient.upperBound, float(1)), EqualEqual_ObjectObject(NewValue, none))), OrOr_BoolBool(OrOr_BoolBool(Not_PreBool(bNotifyOnValueChange), NotEqual_ObjectObject(NewValue, OldValue)), sensorRecipient.bNotify)), bSendMessage(NewValue)))
		{
			sensorRecipient.bNotify = false;
			sendList[sendList.Length] = sensorRecipient;
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x40;
	}
	i = 0;
	J0x120:

	if(Less_IntInt(i, sendList.Length))
	{
		sendSensorMessage(sendList[i], Value);
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x120;
	}
	return;
}

function bool bSendMessage(Object Object)
{
	return true;
	return;
}

function AI_SensorData QueryValue()
{
	return Value;
	return;
}

function int queryIntegerValue()
{
	return Value.integerData;
	return;
}

function float queryFloatValue()
{
	return Value.floatData;
	return;
}

function Object queryObjectValue()
{
	return Value.objectData;
	return;
}

function ClearValue()
{
	Value.Clear();
	return;
}

function int queryUsage()
{
	return recipients.Length;
	return;
}

protected static function AI_Sensor activateSensorInternal(Class<AI_Sensor> sensorClass, AI_Resource R, optional float lowerBound, optional float upperBound, optional Object userData, optional ISensorNotification Recipient)
{
	local int i;
	local AI_Sensor sensor;
	local AI_SensorRecipient sensorRecipient;

	if(EqualEqual_ObjectObject(R, none))
	{
		R = AI_SensorResource(Class'Tyrion.Setup'.default.sensorResource);
	}
	if(EqualEqual_ObjectObject(R, none))
	{
		Log("AI Error: Couldn't retrieve sensorResource in 'createSensorInternal'");
	}
	i = 0;
	J0x7E:

	if(Less_IntInt(i, R.sensors.Length))
	{
		if(EqualEqual_ObjectObject(sensorClass, R.sensors[i].Class))
		{
			sensor = R.sensors[i];
			// [Explicit Break]
			goto J0xE5;
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x7E;
	}
	J0xE5:

	if(EqualEqual_ObjectObject(sensor, none))
	{
		Log(At_StrStr(At_StrStr(At_StrStr(At_StrStr("AI WARNING: Sensor", string(sensorClass.Name)), "requested by"), string(Recipient.Name)), "but not found!"));
		Log(At_StrStr("AI WARNING: Check that the corresponding sensorAction has been set up for", string(R.Name)));
	}
	else
	{
		sensorRecipient = Class'Tyrion.AI_SensorRecipient'.static.Allocate(self, R).;
		Construct_Void();
		sensorRecipient.userData = userData;
		sensorRecipient.Recipient = Recipient;
		sensorRecipient.lowerBound = lowerBound;
		if(EqualEqual_FloatFloat(upperBound, 0.0000000))
		{
			sensorRecipient.upperBound = lowerBound;
		}
		else
		{
			sensorRecipient.upperBound = upperBound;
		}
		sensor.recipients[sensor.recipients.Length] = sensorRecipient;
		if(sensor.sensorAction.bCallBegin)
		{
			sensor.sensorAction.bCallBegin = false;
			sensor.sensorAction.Begin();
		}
		if(EqualEqual_IntInt(sensor.recipients.Length, 1))
		{
			sensor.Begin();
		}
	}
	return sensor;
	return;
}

protected function deactivateSensorInternal(ISensorNotification Recipient, optional float lowerBound, optional float upperBound)
{
	local int i;
	local AI_SensorRecipient sensorRecipient;

	i = 0;
	J0x07:

	if(Less_IntInt(i, recipients.Length))
	{
		sensorRecipient = recipients[i];
		if(AndAnd_BoolBool(AndAnd_BoolBool(EqualEqual_ObjectObject(sensorRecipient.Recipient, Recipient), OrOr_BoolBool(EqualEqual_FloatFloat(upperBound, float(0)), EqualEqual_FloatFloat(sensorRecipient.upperBound, upperBound))), OrOr_BoolBool(EqualEqual_FloatFloat(lowerBound, float(0)), EqualEqual_FloatFloat(sensorRecipient.lowerBound, lowerBound))))
		{
			recipients[i].Delete();
			recipients.Remove(i, 1);
			// [Explicit Break]
			goto J0xBC;
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	J0xBC:

	if(EqualEqual_IntInt(recipients.Length, 0))
	{
		cleanup();
	}
	return;
}
