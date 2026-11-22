class AI_TestCharacterD extends AI_CharacterAction
	editinlinenew
	collapsecategories
	hidecategories(Object,InternalParameters);

var AI_Goal goal1;
var AI_Goal goal2;

function goalAchievedCB(AI_Goal Goal, AI_Action Child)
{
	super(AI_Action).goalAchievedCB(Goal, Child);
	Log(At_StrStr(At_StrStr(At_StrStr(At_StrStr(string(self.Name), "goalAchievedCB called for"), string(Goal.Name)), "by"), string(Child.Name)));
	return;
}

function goalNotAchievedCB(AI_Goal Goal, AI_Action Child, ActionBase.ACT_ErrorCodes errorCode)
{
	super(AI_Action).goalNotAchievedCB(Goal, Child, errorCode);
	Log(At_StrStr(At_StrStr(At_StrStr(At_StrStr(string(self.Name), "goalNotAchievedCB called for"), string(Goal.Name)), "by"), string(Child.Name)));
	return;
}

function cleanup()
{
	super.cleanup();
	if(NotEqual_ObjectObject(goal1, none))
	{
		goal1.Release();
		goal1 = none;
	}
	if(NotEqual_ObjectObject(goal2, none))
	{
		goal2.Release();
		goal2 = none;
	}
	return;
}

state Running
{Begin:

	Log(At_StrStr(string(self.Name), "started. Using movementResource (pri 20) and weaponResource (pri 30)."));
	/* Statement decompilation error: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index

	*/

	/*@Error*/
	goto J0x400;
	myAddRef();
	goal2 = Class'Tyrion.AI_TestWeaponGoalA'.static.Allocate(self)..foreach .return postGoal(self);
	{
		goto J0x400;
		myAddRef();
		waitForAllGoals(goal1, goal2);
		if(OrOr_BoolBool(Not_PreBool(goal1.wasAchieved()), Not_PreBool(goal2.wasAchieved())))
		{
			Log(At_StrStr(string(self.Name), "has failed."));
			fail(1);
			Sleep(2.0000000);
			Log(At_StrStr(string(self.Name), "has succeeded."));
		}
		succeed();
		stop;
		@NULL
		@NULL
	}
}

defaultproperties
{
	satisfiesGoal=Class'Tyrion.AI_TestCharacterGoalB'
}