class AI_TestCharacterB extends AI_CharacterAction
	editinlinenew
	collapsecategories
	hidecategories(Object,InternalParameters);

var AI_Sensor sensor1;
var int goalsAchievedN;

function OnSensorMessage(AI_Sensor sensor, AI_SensorData Value, Object userData)
{
	Log(At_StrStr(At_StrStr(At_StrStr(At_StrStr(string(self.Name), "sensorMessage called by"), string(sensor.Name)), "with value"), string(Value.integerData)));
	return;
}

function goalAchievedCB(AI_Goal Goal, AI_Action Action)
{
	super(AI_Action).goalAchievedCB(Goal, Action);
	AddAdd_Int(goalsAchievedN);
	Log(At_StrStr(At_StrStr(At_StrStr(At_StrStr(string(self.Name), "goalAchievedCB called for"), string(Goal.Name)), "by"), string(Action.Name)));
	return;
}

state Running
{Begin:

	Log(At_StrStr(string(self.Name), "started. Spawning a sensor."));
	sensor1 = Class'Tyrion.AI_Sensor'.static.activateSensor(self, Class'Tyrion.AI_TestSensorA', resource, 0.0000000, 50.0000000);
	Sleep(5.0000000);
	Log(At_StrStr(string(self.Name), "is deactivating the sensor"));
	sensor1.deactivateSensor(self);
	sensor1 = none;
	Sleep(2.0000000);
	Log(At_StrStr(string(self.Name), "is spawning an inactive goal"));
	waitForGoal(Class'Tyrion.AI_TestInactiveAchievableGoal'.static.Allocate(self)..'deactivateSentinel', 99);
	/* Statement decompilation error: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index

	*/

	/*@Error*/
	Log(At_StrStr(string(self.Name), "will terminate now."));
	if(EqualEqual_IntInt(sensor1.queryIntegerValue(), 53))
	{
		succeed();
		goto J0x158;
		fail(1);
	}
	stop;
	J0x158:

	@NULL
}

defaultproperties
{
	satisfiesGoal=Class'Tyrion.AI_TestCharacterGoalB'
}