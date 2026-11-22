class AI_TestCharacterC extends AI_CharacterAction
	editinlinenew
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) int parameter1;
var(Parameters) float parameter2;
var int goalsAchievedN;

function goalAchievedCB(AI_Goal Goal, AI_Action Action)
{
	super(AI_Action).goalAchievedCB(Goal, Action);
	AddAdd_Int(goalsAchievedN);
	Log(At_StrStr(At_StrStr(At_StrStr(At_StrStr(string(self.Name), "goalAchievedCB called for"), string(Goal.Name)), "by"), string(Action.Name)));
	return;
}

state Running
{Begin:

	Log(At_StrStr(string(self.Name), "started. Creating a low-pri goal for movementResource."));
	Class'Tyrion.AI_TestMovementGoalA'.static.Allocate(self)..'deactivateSentinel';
	20
	/* Statement decompilation error: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index

	*/

	/*@Error*/
	Sleep(2.0000000);
	Log(At_StrStr(string(self.Name), "is creating a high-pri goal for the same resource..."));
	waitForGoal(Class'Tyrion.AI_TestMovementGoalA'.static.Allocate(self)..'deactivateSentinel', 90);
	/* Statement decompilation error: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index

	*/

	/*@Error*/
	Sleep(2.0000000);
	Log(At_StrStr(string(self.Name), "will terminate now."));
	if(EqualEqual_IntInt(goalsAchievedN, 1))
	{
		succeed();
		goto J0x141;
		fail(1);
	}
	stop;
	@NULL
	@NULL
}

defaultproperties
{
	satisfiesGoal=Class'Tyrion.AI_TestCharacterGoalC'
}