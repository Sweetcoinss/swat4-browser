class AI_CharacterAction extends AI_Action
	abstract
	native
	collapsecategories
	hidecategories(Object,InternalParameters);

var Pawn Pawn;
var AI_MovementResource movementResourceStorage;
var AI_WeaponResource weaponResourceStorage;
var AI_Goal DummyMovementGoal;
var AI_Goal DummyWeaponGoal;

function cleanup()
{
	super(ActionBase).cleanup();
	if(NotEqual_ObjectObject(DummyMovementGoal, none))
	{
		DummyMovementGoal.Release();
		DummyMovementGoal = none;
	}
	if(NotEqual_ObjectObject(DummyWeaponGoal, none))
	{
		DummyWeaponGoal.Release();
		DummyWeaponGoal = none;
	}
	return;
}

function clearDummyMovementGoal()
{
	if(NotEqual_ObjectObject(DummyMovementGoal, none))
	{
		DummyMovementGoal.unPostGoal(self);
		DummyMovementGoal.Release();
		DummyMovementGoal = none;
	}
	return;
}

function clearDummyWeaponGoal()
{
	if(NotEqual_ObjectObject(DummyWeaponGoal, none))
	{
		DummyWeaponGoal.unPostGoal(self);
		DummyWeaponGoal.Release();
		DummyWeaponGoal = none;
	}
	return;
}

function clearDummyGoals()
{
	clearDummyMovementGoal();
	clearDummyWeaponGoal();
	return;
}

function useResources(int resourceBits, optional int dummyGoalPriority)
{
	local int Priority;
	local ActionBase.ACT_ErrorCodes errorCode;
	local AI_Goal movementGoal, weaponGoal;

	if(NotEqual_IntInt(dummyGoalPriority, 0))
	{
		Priority = dummyGoalPriority;
	}
	else
	{
		Priority = achievingGoal.priorityFn();
	}
	if(NotEqual_IntInt(And_IntInt(And_IntInt(resourceBits, resourceUsage), Class'Tyrion.AI_Resource'.2), 0))
	{
		weaponGoal = Class'Tyrion.AI_DummyWeaponGoal'.static.Allocate(self)..foreach .AI_Sensor
		{
			postGoal(self);
			goto J0x400;
			myAddRef();
			weaponGoal.bTerminateIfStolen = true;
			if(Pawn.logTyrion)
			{
				Log(At_StrStr(At_StrStr(At_StrStr("useResources:", string(weaponGoal.Name)), "posted for"), string(Name)));
				DummyWeaponGoal = weaponGoal;
			}
			DummyWeaponGoal.AddRef();
			if(NotEqual_IntInt(And_IntInt(And_IntInt(resourceBits, resourceUsage), Class'Tyrion.AI_Resource'.4), 0))
			{
			}
			movementGoal = Class'Tyrion.AI_DummyMovementGoal'.static.Allocate(self)..'deactivateSentinel'.;
			/* Statement decompilation error: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index

			*/

			/*@Error*/
			goto J0x400;
			myAddRef();
			movementGoal.bTerminateIfStolen = true;
			if(Pawn.logTyrion)
			{
				Log(At_StrStr(At_StrStr(At_StrStr("useResources:", string(movementGoal.Name)), "posted for"), string(Name)));
				DummyMovementGoal = movementGoal;
			}
			DummyMovementGoal.AddRef();
			if(NotEqual_ObjectObject(weaponGoal, none))
			{
			}
			waitForAllGoalsConsidered(weaponGoal, movementGoal);
			goto J0x1FD;
			waitForAllGoalsConsidered(movementGoal);
		}/* !MISMATCHING REMOVE, tried If got Type:ForEach Position:0x06D! */
		if(OrOr_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(weaponGoal, none), Not_PreBool(weaponGoal.beingAchieved())), AndAnd_BoolBool(NotEqual_ObjectObject(movementGoal, none), Not_PreBool(movementGoal.beingAchieved()))))
		{
			if(Pawn.logTyrion)
			{
				Log(At_StrStr(At_StrStr("useResources:", string(Name)), "failing because resources unavailable"));
				errorCode = 11;
				if(NotEqual_ObjectObject(weaponGoal, none))
				{
				}
			}
			weaponGoal.Release();
			if(NotEqual_ObjectObject(movementGoal, none))
			{
			}
			movementGoal.Release();
			/* Statement decompilation error: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index

			*/

			/*@Error*/
		}
		fail(errorCode);
		return;
		@NULL
		AI_SensorData
	}/* !MISMATCHING REMOVE, tried ForEach got Type:If Position:0x02E! */
}

function initAction(AI_Resource R, AI_Goal Goal)
{
	super.initAction(R, Goal);
	Pawn = AI_CharacterResource(R).m_pawn;
	movementResourceStorage = AI_MovementResource(Pawn.MovementAI);
	weaponResourceStorage = AI_WeaponResource(Pawn.WeaponAI);
	return;
}

function AI_CharacterResource characterResource()
{
	return AI_CharacterResource(resource);
	return;
}

function AI_MovementResource movementResource()
{
	return movementResourceStorage;
	return;
}

function AI_WeaponResource weaponResource()
{
	return weaponResourceStorage;
	return;
}

static function Class<Tyrion_ResourceBase> getResourceClass()
{
	return Class'Tyrion.AI_CharacterResource';
	return;
}

static function Tyrion_ResourceBase findResource(Pawn P)
{
	return P.CharacterAI;
	return;
}

function ClassConstruct()
{
	resourceUsage = Or_IntInt(Or_IntInt(Class'Tyrion.AI_Resource'.2, Class'Tyrion.AI_Resource'.4), Class'Tyrion.AI_Resource'.1);
	return;
}

defaultproperties
{
	resourceUsage=7
}