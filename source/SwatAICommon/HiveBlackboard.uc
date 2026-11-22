class HiveBlackboard extends Object
	native;

var Pawn PlayerEnemy;
var array<Pawn> EncounteredHostages;
var array<Pawn> EncounteredEnemies;
var array<Pawn> AssignedTargets;
var array<Pawn> CompliantAIs;
var array<Pawn> RestrainedAIs;
var array<Pawn> AIsBeingWatched;
var native map<NavigationPoint, Pawn> EngagingPointMap;

// Export UHiveBlackboard::execUpdateHostage(FFrame&, void* const)
native function UpdateHostage(Pawn Hostage);

// Export UHiveBlackboard::execUpdateEnemy(FFrame&, void* const)
native function UpdateEnemy(Pawn Enemy);

// Export UHiveBlackboard::execHasAIBeenEncountered(FFrame&, void* const)
native function bool HasAIBeenEncountered(Pawn TestAI);

function MakePlayerEnemy(Pawn Player)
{
	assert(NotEqual_ObjectObject(Player, none));
	PlayerEnemy = Player;
	return;
}

function bool IsACompliantAI(Pawn AI)
{
	local int i;

	assert(NotEqual_ObjectObject(AI, none));
	i = 0;
	J0x12:

	if(Less_IntInt(i, CompliantAIs.Length))
	{
		if(EqualEqual_ObjectObject(CompliantAIs[i], AI))
		{
			return true;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x12;
	}
	return false;
	return;
}

function AddCompliantAI(Pawn AI)
{
	assert(NotEqual_ObjectObject(AI, none));
	if(Not_PreBool(IsACompliantAI(AI)))
	{
		CompliantAIs[CompliantAIs.Length] = AI;
	}
	return;
}

function RemoveCompliantAI(Pawn AI)
{
	local int i;

	assert(NotEqual_ObjectObject(AI, none));
	i = 0;
	J0x12:

	if(Less_IntInt(i, CompliantAIs.Length))
	{
		if(EqualEqual_ObjectObject(CompliantAIs[i], AI))
		{
			CompliantAIs.Remove(i, 1);
			// [Explicit Break]
			goto J0x50;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x12;
	}
	J0x50:

	return;
}

function ValidateRestrainedAIs()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, RestrainedAIs.Length))
	{
		if(Not_PreBool(Class'Engine.Pawn'.static.checkConscious(RestrainedAIs[i])))
		{
			RestrainedAIs.Remove(i, 1);
			SubtractSubtract_PreInt(i);
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

private function bool IsARestrainedAI(Pawn AI)
{
	local int i;

	assert(NotEqual_ObjectObject(AI, none));
	i = 0;
	J0x12:

	if(Less_IntInt(i, RestrainedAIs.Length))
	{
		if(EqualEqual_ObjectObject(RestrainedAIs[i], AI))
		{
			return true;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x12;
	}
	return false;
	return;
}

function AddRestrainedAI(Pawn AI)
{
	assert(NotEqual_ObjectObject(AI, none));
	if(Not_PreBool(IsARestrainedAI(AI)))
	{
		RestrainedAIs[RestrainedAIs.Length] = AI;
	}
	return;
}

function RemoveRestrainedAI(Pawn AI)
{
	local int i;

	assert(NotEqual_ObjectObject(AI, none));
	i = 0;
	J0x12:

	if(Less_IntInt(i, RestrainedAIs.Length))
	{
		if(EqualEqual_ObjectObject(RestrainedAIs[i], AI))
		{
			RestrainedAIs.Remove(i, 1);
			// [Explicit Break]
			goto J0x50;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x12;
	}
	J0x50:

	return;
}

function AddWatchedAI(Pawn AI)
{
	assert(NotEqual_ObjectObject(AI, none));
	assert(Not_PreBool(IsAIBeingWatched(AI)));
	AIsBeingWatched[AIsBeingWatched.Length] = AI;
	return;
}

function RemoveWatchedAI(Pawn AI)
{
	local int i;

	assert(NotEqual_ObjectObject(AI, none));
	i = 0;
	J0x12:

	if(Less_IntInt(i, AIsBeingWatched.Length))
	{
		if(EqualEqual_ObjectObject(AIsBeingWatched[i], AI))
		{
			AIsBeingWatched.Remove(i, 1);
			// [Explicit Break]
			goto J0x50;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x12;
	}
	J0x50:

	return;
}

function bool IsAIBeingWatched(Pawn AI)
{
	local int i;

	assert(NotEqual_ObjectObject(AI, none));
	i = 0;
	J0x12:

	if(Less_IntInt(i, AIsBeingWatched.Length))
	{
		if(EqualEqual_ObjectObject(AIsBeingWatched[i], AI))
		{
			return true;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x12;
	}
	return false;
	return;
}

function AddAssignedTarget(Pawn AI)
{
	assert(NotEqual_ObjectObject(AI, none));
	if(Not_PreBool(IsAnAssignedTarget(AI)))
	{
		AssignedTargets[AssignedTargets.Length] = AI;
	}
	return;
}

function bool AreAnyAssignedTargetsThreatening()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, AssignedTargets.Length))
	{
		if(AndAnd_BoolBool(AssignedTargets[i].IsA('SwatEnemy'), ISwatEnemy(AssignedTargets[i]).IsAThreat()))
		{
			return true;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return false;
	return;
}

function RemoveAssignedTarget(Pawn AI)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, AssignedTargets.Length))
	{
		if(EqualEqual_ObjectObject(AssignedTargets[i], AI))
		{
			AssignedTargets.Remove(i, 1);
			// [Explicit Break]
			goto J0x45;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	J0x45:

	return;
}

function bool IsAnAssignedTarget(Pawn AI)
{
	local int i;

	assert(NotEqual_ObjectObject(AI, none));
	i = 0;
	J0x12:

	if(Less_IntInt(i, AssignedTargets.Length))
	{
		if(EqualEqual_ObjectObject(AssignedTargets[i], AI))
		{
			return true;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x12;
	}
	return false;
	return;
}
