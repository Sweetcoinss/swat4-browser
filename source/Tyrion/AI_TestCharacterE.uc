class AI_TestCharacterE extends AI_CharacterAction
	editinlinenew
	collapsecategories
	hidecategories(Object,InternalParameters);

var int goalsAchievedN;

function goalAchievedCB(AI_Goal Goal, AI_Action Action)
{
	super(AI_Action).goalAchievedCB(Goal, Action);
	AddAdd_Int(goalsAchievedN);
	Log(At_StrStr(At_StrStr(At_StrStr(At_StrStr(string(self.Name), "goalAchievedCB called for"), string(Goal.Name)), "by"), string(Action.Name)));
	return;
}

function ClassConstruct()
{
	resourceUsage = Class'Tyrion.AI_Resource'.2;
	return;
}

state Running
{Begin:

	Log(At_StrStr(string(self.Name), "started. Using weaponResource (pri 25)."));
	waitForGoal(Class'Tyrion.AI_TestWeaponGoalA'.static.Allocate(self)..foreach )
	{
		/* Statement decompilation error: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index

		*/

		/*@Error*/
		Sleep(2.0000000);
		Log(At_StrStr(string(self.Name), "will terminate now."));
		if(EqualEqual_IntInt(goalsAchievedN, 1))
		{
			succeed();
			goto J0xB6;
			fail(1);
		}
		stop;
		@NULL
		@NULL
	}
}

defaultproperties
{
	satisfiesGoal=Class'Tyrion.AI_TestCharacterGoalC'
	resourceUsage=2
}