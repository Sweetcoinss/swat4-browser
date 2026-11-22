class Tyrion_ResourceBase extends RefCount
	abstract
	native;

enum ResourceTypes
{
	RT_DEFAULT,                     // 0
	RT_VEHICLE,                     // 1
	RT_GUNNER,                      // 2
	RT_DRIVER,                      // 3
	RT_TURRET,                      // 4
	RT_CHARACTER,                   // 5
	RT_SQUAD,                       // 6
	RT_ARMS,                        // 7
	RT_LEGS,                        // 8
	RT_HEAD                         // 9
};

enum AI_LOD_Levels
{
	AILOD_NONE,                     // 0
	AILOD_MINIMAL,                  // 1
	AILOD_IDLE,                     // 2
	AILOD_NORMAL,                   // 3
	AILOD_ALWAYS_ON                 // 4
};

var(AI) export editinline array<export editinline Tyrion_GoalBase> goals;
var(AI) editinline array<editinline Tyrion_ActionBase> abilities;
var bool bMatchGoals;
var bool bUnInitialized;
var bool bGoalsReset;

event Init()
{
	return;
}

function setResourceOwner(Actor P)
{
	return;
}

function setIndex(int Index)
{
	return;
}

function cleanup()
{
	return;
}

function deleteSensors()
{
	return;
}

event deleteRemovedActions()
{
	return;
}

event resetGoals()
{
	return;
}

event bool isActive()
{
	return true;
	return;
}

function bool requiredResourcesAvailable(int legsPriority, int armsPriority, optional int headPriority)
{
	return;
}

function PawnDied(Pawn Pawn)
{
	return;
}

function assignGoal(Class<Tyrion_GoalBase> goalClass)
{
	if(NotEqual_ObjectObject(goalClass, none))
	{
		if(ClassIsChildOf(Class, goalClass.static.getResourceClass()))
		{
			goals[goals.Length] = goalClass.static.Allocate(self).;
			Construct_Void();
			goals[Subtract_IntInt(goals.Length, 1)].AddRef();
			goals[Subtract_IntInt(goals.Length, 1)].AddRef();
		}
	}
	return;
}

function assignAbility(Class<Tyrion_ActionBase> abilityClass)
{
	if(NotEqual_ObjectObject(abilityClass, none))
	{
		if(ClassIsChildOf(Class, abilityClass.static.getResourceClass()))
		{
			abilities[abilities.Length] = abilityClass.static.Allocate(self).;
			Construct_Void();
		}
	}
	return;
}

// Export UTyrion_ResourceBase::execTick(FFrame&, void* const)
native function Tick(float DeltaTime);

function addAbility(Tyrion_ActionBase newAbility)
{
	assert(NotEqual_ObjectObject(newAbility, none));
	abilities[abilities.Length] = newAbility;
	return;
}

function displayTyrionDebug()
{
	return;
}

defaultproperties
{
	bUnInitialized=true
	bGoalsReset=true
}