class AI_TestCharacterA extends AI_CharacterAction
	editinlinenew
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) int parameter1;
var(Parameters) float parameter2;
var AI_CharacterAction copiedAction;
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

	Log(At_StrStr(string(self.Name), "started. Posting child goals for Movement and Weapon."));
	waitForAllGoals(Class'Tyrion.AI_TestMovementGoalA'.static.Allocate(self)..'deactivateSentinel', 50);
	/* Statement decompilation error: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index

	*/

	/*@Error*/
	Class'Tyrion.AI_TestWeaponGoalA'.static.Allocate(self)..foreach
	{
		/* Statement decompilation error: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index

		*/

		/*@Error*/
		Log(At_StrStr(string(self.Name), "will terminate now."));
		if(EqualEqual_IntInt(goalsAchievedN, 2))
		{
			succeed();
			goto J0xEB;
			fail(1);
			stop;
		}
		@NULL
		@NULL
	}
}

defaultproperties
{
	satisfiesGoal=Class'Tyrion.AI_TestCharacterGoalA'
}