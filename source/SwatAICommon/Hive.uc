class Hive extends Object
	native
	config(AI);

const kMinAwarenessUpdateTime = 0.333;
const kMaxAwarenessUpdateTime = 0.666;
const kRequestEngagePointStaleDelta = 2.0;

struct native WeightedAssignment
{
	var float Weight;
	var Pawn Officer;
	var Pawn Assignment;
};

var private HiveBlackboard Blackboard;
var SwatAIRepository SwatAIRepo;
var array<Pawn> HiveAwarenessPawns;
var private AwarenessProxy HiveAwareness;
var private float AwarenessCounter;
var private bool bAwarenessDisabled;
var array<CachedEngageInfo> CachedEngagements;
var config float PlayerDamageThreshold;
var private float CurrentPlayerDamage;
var private bool bTriggeredFirstShotReaction;
var private bool bTriggeredSecondShotReaction;
var private bool bTriggeredThirdShotReaction;
var array<Pawn> ThreateningUncompliantAssignments;
var array<Pawn> NonThreateningUncompliantAssignments;
var config float MaxWatchTargetDistance;

overloaded function Construct()
{
	Blackboard = Class'SwatAICommon.HiveBlackboard'.static.Allocate(self, none).;
	Construct_Void();
	assert(NotEqual_ObjectObject(Blackboard, none));
	return;
}

// Export UHive::execGetNumOfficers(FFrame&, void* const)
native function int GetNumOfficers();

// Export UHive::execGetOfficer(FFrame&, void* const)
native function Pawn GetOfficer(int Index);

function Pawn GetClosestOfficerTo(Actor Target, optional bool bRequiresLineOfSight)
{
	assert(NotEqual_ObjectObject(Target, none));
	return SwatAIRepo.GetElementSquad().GetClosestOfficerTo(Target, bRequiresLineOfSight);
	return;
}

function Pawn GetClosestOfficerThatCanHit(Actor Target)
{
	assert(NotEqual_ObjectObject(Target, none));
	return SwatAIRepo.GetElementSquad().GetClosestOfficerThatCanHit(Target);
	return;
}

function AwarenessProxy GetAwareness()
{
	return HiveAwareness;
	return;
}

function DisableAwareness()
{
	bAwarenessDisabled = true;
	return;
}

function EnableAwareness()
{
	bAwarenessDisabled = false;
	return;
}

function AddOfficerToHiveAwareness(Pawn Officer)
{
	HiveAwarenessPawns[HiveAwarenessPawns.Length] = Officer;
	if(AndAnd_BoolBool(EqualEqual_ObjectObject(HiveAwareness, none), EqualEqual_IntInt(HiveAwarenessPawns.Length, SwatAIRepo.Level.Game.GetNumSpawnedOfficers())))
	{
		HiveAwareness = Class'SwatAIAwareness.AwarenessFactory'.static.CreateAwarenessForMultiplePawns(HiveAwarenessPawns);
	}
	return;
}

function RemoveOfficerFromHiveAwareness(Pawn Officer)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, HiveAwarenessPawns.Length))
	{
		if(EqualEqual_ObjectObject(HiveAwarenessPawns[i], Officer))
		{
			HiveAwarenessPawns.Remove(i, 1);
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	if(EqualEqual_IntInt(HiveAwarenessPawns.Length, 0))
	{
		HiveAwareness.Term();
		HiveAwareness = none;
	}
	return;
}

private function CheckUpdateOfficerAssignmentsForEnemy(Pawn Enemy)
{
	local int i;

	assert(NotEqual_ObjectObject(Enemy, none));
	assert(Enemy.IsA('SwatEnemy'));
	i = 0;
	J0x26:

	if(Less_IntInt(i, Blackboard.EncounteredEnemies.Length))
	{
		if(EqualEqual_ObjectObject(Blackboard.EncounteredEnemies[i], Enemy))
		{
			UpdateOfficerAssignments();
			// [Explicit Break]
			goto J0x70;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x26;
	}
	J0x70:

	return;
}

function NotifyEnemyBecameThreat(Pawn Enemy)
{
	CheckUpdateOfficerAssignmentsForEnemy(Enemy);
	return;
}

function NotifyEnemyStunned(Pawn Enemy)
{
	CheckUpdateOfficerAssignmentsForEnemy(Enemy);
	return;
}

function NotifyEnemyFleeing(Pawn Enemy)
{
	assert(NotEqual_ObjectObject(Enemy, none));
	SwatAIRepo.GetElementSquad().TriggerEnemyFleeingSpeech(Enemy);
	return;
}

function NotifyAIBecameCompliant(Pawn AI)
{
	Blackboard.RemoveAssignedTarget(AI);
	UpdateOfficerAssignments();
	return;
}

function NotifyCompliantAIFinishedComplying(Pawn AI)
{
	if(Not_PreBool(Blackboard.IsACompliantAI(AI)))
	{
		SwatAIRepo.GetElementSquad().TriggerTargetCompliantSpeech(AI);
		Blackboard.AddCompliantAI(AI);
	}
	return;
}

function NotifyAIBecameRestrained(Pawn AI)
{
	Blackboard.RemoveCompliantAI(AI);
	Blackboard.AddRestrainedAI(AI);
	return;
}

function RemoveWatchedAI(Pawn AI)
{
	Blackboard.RemoveWatchedAI(AI);
	return;
}

function AddWatchedAI(Pawn AI)
{
	Blackboard.AddWatchedAI(AI);
	return;
}

private function bool FindCompliantTargetToWatch(Pawn Officer, out Pawn CompliantTarget)
{
	local int i;
	local Pawn CompliantAIIter;
	local array<Pawn> CompliantTargets;

	i = 0;
	J0x07:

	if(Less_IntInt(i, Blackboard.CompliantAIs.Length))
	{
		CompliantAIIter = Blackboard.CompliantAIs[i];
		if(AndAnd_BoolBool(AndAnd_BoolBool(Not_PreBool(Blackboard.IsAIBeingWatched(CompliantAIIter)), Less_FloatFloat(VSize(Subtract_VectorVector(CompliantAIIter.Location, Officer.Location)), MaxWatchTargetDistance)), EqualEqual_ObjectObject(Officer, GetClosestOfficerThatCanHit(CompliantAIIter))))
		{
			CompliantTargets[CompliantTargets.Length] = CompliantAIIter;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	if(Greater_IntInt(CompliantTargets.Length, 0))
	{
		CompliantTarget = CompliantTargets[Rand(CompliantTargets.Length)];
		return true;
	}
	else
	{
		return false;
	}
	return;
}

private function bool FindRestrainedTargetToWatch(Pawn Officer, out Pawn RestrainedTarget)
{
	local int i;
	local Pawn RestrainedAIIter;
	local array<Pawn> RestrainedTargets;

	i = 0;
	J0x07:

	if(Less_IntInt(i, Blackboard.RestrainedAIs.Length))
	{
		RestrainedAIIter = Blackboard.RestrainedAIs[i];
		if(AndAnd_BoolBool(AndAnd_BoolBool(Not_PreBool(Blackboard.IsAIBeingWatched(RestrainedAIIter)), Less_FloatFloat(VSize(Subtract_VectorVector(RestrainedAIIter.Location, Officer.Location)), MaxWatchTargetDistance)), EqualEqual_ObjectObject(Officer, GetClosestOfficerThatCanHit(RestrainedAIIter))))
		{
			RestrainedTargets[RestrainedTargets.Length] = RestrainedAIIter;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	if(Greater_IntInt(RestrainedTargets.Length, 0))
	{
		RestrainedTarget = RestrainedTargets[Rand(RestrainedTargets.Length)];
		return true;
	}
	else
	{
		return false;
	}
	return;
}

function Pawn FindTargetToWatchForOfficer(Pawn Officer)
{
	local Pawn TargetToWatch;

	if(OrOr_BoolBool(FindCompliantTargetToWatch(Officer, TargetToWatch), FindRestrainedTargetToWatch(Officer, TargetToWatch)))
	{
		return TargetToWatch;
	}
	else
	{
		return none;
	}
	return;
}

function NotifyAIDied(Pawn AI)
{
	assert(NotEqual_ObjectObject(AI, none));
	Blackboard.RemoveAssignedTarget(AI);
	Blackboard.RemoveCompliantAI(AI);
	Blackboard.RemoveRestrainedAI(AI);
	Blackboard.RemoveWatchedAI(AI);
	if(Blackboard.HasAIBeenEncountered(AI))
	{
		UpdateOfficerAssignments();
	}
	if(AI.IsA('SwatEnemy'))
	{
		SwatAIRepo.GetElementSquad().TriggerSuspectDownSpeech(AI);
	}
	else
	{
		if(AI.IsA('SwatHostage'))
		{
			SwatAIRepo.GetElementSquad().TriggerHostageDownSpeech(AI);
		}
		else
		{
			assert(AI.IsA('SwatTrainer'));
		}
	}
	return;
}

function NotifyOfficerConstructed(Pawn Officer)
{
	AddOfficerToHiveAwareness(Officer);
	return;
}

function NotifyOfficerDestroyed(Pawn Officer)
{
	RemoveOfficerFromHiveAwareness(Officer);
	return;
}

function NotifyOfficerDied(Pawn Officer)
{
	assert(NotEqual_ObjectObject(Officer, none));
	ClearEngagingPointForOfficer(Officer);
	UpdateOfficerAssignments();
	SwatAIRepo.GetElementSquad().TriggerOfficerDownSpeech(Officer);
	RemoveOfficerFromHiveAwareness(Officer);
	return;
}

function NotifyPlayerDied(Pawn Player)
{
	assert(NotEqual_ObjectObject(Player, none));
	SwatAIRepo.GetElementSquad().TriggerLeadDownSpeech(Player);
	return;
}

function bool IsPawnWithinDistanceOfOfficers(Pawn TestPawn, float Distance, bool bRequiresLineOfSight)
{
	local int i;
	local Pawn IterOfficer, Player;
	local Controller Iter;

	assert(NotEqual_ObjectObject(TestPawn, none));
	if(EqualEqual_IntInt(int(TestPawn.Level.NetMode), int(NM_Standalone)))
	{
		Player = TestPawn.Level.GetLocalPlayerController().Pawn;
		if(Class'Engine.Pawn'.static.checkConscious(Player))
		{
			if(AndAnd_BoolBool(Less_FloatFloat(VSize2D(Subtract_VectorVector(Player.Location, TestPawn.Location)), Distance), OrOr_BoolBool(Not_PreBool(bRequiresLineOfSight), TestPawn.LineOfSightTo(Player))))
			{
				return true;
			}
		}
		i = 0;
		J0xC4:

		if(Less_IntInt(i, GetNumOfficers()))
		{
			IterOfficer = GetOfficer(i);
			if(AndAnd_BoolBool(Less_FloatFloat(VSize2D(Subtract_VectorVector(IterOfficer.Location, TestPawn.Location)), Distance), OrOr_BoolBool(Not_PreBool(bRequiresLineOfSight), TestPawn.LineOfSightTo(IterOfficer))))
			{
				return true;
			}
			AddAdd_PreInt(i);
			// [Loop Continue]
			goto J0xC4;
		}
	}
	else
	{
		assert(TestPawn.Level.IsCOOPServer);
		Iter = TestPawn.Level.ControllerList;
		J0x17C:

		if(NotEqual_ObjectObject(Iter, none))
		{
			if(Iter.IsA('PlayerController'))
			{
				IterOfficer = Iter.Pawn;
				if(Class'Engine.Pawn'.static.checkConscious(IterOfficer))
				{
					if(AndAnd_BoolBool(Less_FloatFloat(VSize2D(Subtract_VectorVector(IterOfficer.Location, TestPawn.Location)), Distance), OrOr_BoolBool(Not_PreBool(bRequiresLineOfSight), TestPawn.LineOfSightTo(IterOfficer))))
					{
						return true;
					}
				}
			}
			Iter = Iter.nextController;
			// [Loop Continue]
			goto J0x17C;
		}
	}
	return false;
	return;
}

function bool IsActorWithinDistanceOfOfficers(Actor TestActor, float Distance)
{
	local int i;
	local Pawn IterOfficer, Player;
	local Controller Iter;

	assert(NotEqual_ObjectObject(TestActor, none));
	if(EqualEqual_IntInt(int(TestActor.Level.NetMode), int(NM_Standalone)))
	{
		Player = TestActor.Level.GetLocalPlayerController().Pawn;
		if(Class'Engine.Pawn'.static.checkConscious(Player))
		{
			if(Less_FloatFloat(VSize2D(Subtract_VectorVector(Player.Location, TestActor.Location)), Distance))
			{
				return true;
			}
		}
		i = 0;
		J0x9E:

		if(Less_IntInt(i, GetNumOfficers()))
		{
			IterOfficer = GetOfficer(i);
			if(Less_FloatFloat(VSize2D(Subtract_VectorVector(IterOfficer.Location, TestActor.Location)), Distance))
			{
				return true;
			}
			AddAdd_PreInt(i);
			// [Loop Continue]
			goto J0x9E;
		}
	}
	else
	{
		assert(TestActor.Level.IsCOOPServer);
		Iter = TestActor.Level.ControllerList;
		J0x130:

		if(NotEqual_ObjectObject(Iter, none))
		{
			if(Iter.IsA('PlayerController'))
			{
				IterOfficer = Iter.Pawn;
				if(Class'Engine.Pawn'.static.checkConscious(IterOfficer))
				{
					if(Less_FloatFloat(VSize2D(Subtract_VectorVector(IterOfficer.Location, TestActor.Location)), Distance))
					{
						return true;
					}
				}
			}
			Iter = Iter.nextController;
			// [Loop Continue]
			goto J0x130;
		}
	}
	return false;
	return;
}

function NavigationPoint RequestNewEngagingPointForOfficer(Pawn Officer, Pawn OfficerOpponent)
{
	local NavigationPoint EngagingPoint;

	ClearEngagingPointForOfficer(Officer);
	EngagingPoint = FindEngagingPointForOfficerInRoom(Officer, OfficerOpponent, 2.0000000);
	if(NotEqual_ObjectObject(EngagingPoint, none))
	{
		SetEngagingPointForOfficer(EngagingPoint, Officer);
	}
	return EngagingPoint;
	return;
}

// Export UHive::execClearEngagingPointForOfficer(FFrame&, void* const)
native function ClearEngagingPointForOfficer(Pawn Officer);

// Export UHive::execSetEngagingPointForOfficer(FFrame&, void* const)
private native function SetEngagingPointForOfficer(NavigationPoint inPoint, Pawn Officer);

// Export UHive::execFindEngagingPointForOfficerInRoom(FFrame&, void* const)
native function NavigationPoint FindEngagingPointForOfficerInRoom(Pawn Officer, Pawn OfficerOpponent, float CacheStaleDeltaTime);

function OfficerSawPawn(Pawn OfficerViewer, Pawn Seen)
{
	assert(NotEqual_ObjectObject(OfficerViewer, none));
	assert(NotEqual_ObjectObject(Seen, none));
	if(Seen.IsA('SwatPlayer'))
	{
		if(CanAssignAnyOfficerToTarget(Seen))
		{
			UpdateOfficerAssignments();
		}
	}
	else
	{
		if(Not_PreBool(Blackboard.HasAIBeenEncountered(Seen)))
		{
			if(Seen.IsA('SwatEnemy'))
			{
				OfficerSawEnemy(OfficerViewer, Seen);
			}
			else
			{
				assert(Seen.IsA('SwatHostage'));
				OfficerSawHostage(OfficerViewer, Seen);
			}
		}
		if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(Not_PreBool(ISwatAI(Seen).IsCompliant()), Not_PreBool(ISwatAI(Seen).IsArrested())), Not_PreBool(Seen.IsIncapacitated())), OrOr_BoolBool(Seen.IsAThreat(), Not_PreBool(ISwatAI(Seen).GetCommanderAction().IsIgnoringComplianceOrders()))), CanAssignAnyOfficerToTarget(Seen)))
		{
			UpdateOfficerAssignments();
		}
	}
	return;
}

function OfficerLostPawn(Pawn OfficerViewer, Pawn Lost)
{
	return;
}

function bool HasTurnedOnPlayer()
{
	return GreaterEqual_FloatFloat(CurrentPlayerDamage, PlayerDamageThreshold);
	return;
}

function NotifyOfficerShotByPlayer(Pawn OfficerShot, float Damage, Pawn PlayerInstigator)
{
	assert(NotEqual_ObjectObject(PlayerInstigator, none));
	assert(NotEqual_ObjectObject(OfficerShot, none));
	if(NotEqual_ObjectObject(Blackboard.PlayerEnemy, PlayerInstigator))
	{
		AddEqual_FloatFloat(CurrentPlayerDamage, FMin(Damage, 100.0000000));
		if(OfficerShot.logAI)
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("CurrentPlayerDamage is: ", string(CurrentPlayerDamage)), " PlayerDamageThreshold: "), string(PlayerDamageThreshold)));
		}
		if(HasTurnedOnPlayer())
		{
			if(OfficerShot.logAI)
			{
				Log(Concat_StrStr("going to attack: ", string(PlayerInstigator.Name)));
			}
			PlayerCrossedDamageThreshold(PlayerInstigator);
		}
		else
		{
			TriggerAppropriateSpeechForRogueLead(OfficerShot);
		}
	}
	return;
}

private function TriggerAppropriateSpeechForRogueLead(Pawn OfficerShot)
{
	if(Not_PreBool(bTriggeredFirstShotReaction))
	{
		SwatAIRepo.GetElementSquad().TriggerReactedFirstShotSpeech(OfficerShot);
		bTriggeredFirstShotReaction = true;
	}
	else
	{
		if(Not_PreBool(bTriggeredSecondShotReaction))
		{
			SwatAIRepo.GetElementSquad().TriggerReactedSecondShotSpeech(OfficerShot);
			bTriggeredSecondShotReaction = true;
		}
	}
	return;
}

private function PlayerCrossedDamageThreshold(Pawn Player)
{
	local ElementSquadInfo Element;
	local int i;

	Blackboard.PlayerEnemy = Player;
	Element = SwatAIRepo.GetElementSquad();
	i = 0;
	J0x30:

	if(Less_IntInt(i, Element.pawns.Length))
	{
		Element.pawns[i].AddViewablePawn(Player);
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x30;
	}
	Element.TriggerReactedThirdShotSpeech(Player);
	UpdateOfficerAssignments();
	return;
}

function FinishedAssignment()
{
	UpdateOfficerAssignments();
	return;
}

function NotifyAIIgnoringOfficers(Pawn AI)
{
	if(AI.IsA('SwatEnemy'))
	{
		SwatAIRepo.GetElementSquad().TriggerSuspectWontComplySpeech(AI);
	}
	else
	{
		SwatAIRepo.GetElementSquad().TriggerHostageWontComplySpeech(AI);
	}
	UpdateOfficerAssignments();
	return;
}

function NotifyOfficersOfTarget(Pawn Target)
{
	AssertWithDescription(OrOr_BoolBool(Target.IsA('SwatHostage'), Target.IsA('SwatEnemy')), Concat_StrStr(Concat_StrStr("Hive::NotifyOfficersOfTarget - Target (", string(Target)), ") is not a SwatHostage or SwatEnemy"));
	if(Target.IsA('SwatHostage'))
	{
		Blackboard.UpdateHostage(Target);
	}
	else
	{
		Blackboard.UpdateEnemy(Target);
	}
	return;
}

private function OfficerSawHostage(Pawn OfficerViewer, Pawn SeenHostage)
{
	Blackboard.UpdateHostage(SeenHostage);
	if(AndAnd_BoolBool(Not_PreBool(ISwatAI(SeenHostage).IsCompliant()), Not_PreBool(ISwatAI(SeenHostage).IsArrested())))
	{
		ISwatOfficer(OfficerViewer).GetOfficerSpeechManagerAction().TriggerHostageSpottedSpeech(SeenHostage);
	}
	return;
}

private function OfficerSawEnemy(Pawn OfficerViewer, Pawn SeenEnemy)
{
	Blackboard.UpdateEnemy(SeenEnemy);
	if(AndAnd_BoolBool(Not_PreBool(ISwatAI(SeenEnemy).IsCompliant()), Not_PreBool(ISwatAI(SeenEnemy).IsArrested())))
	{
		ISwatOfficer(OfficerViewer).GetOfficerSpeechManagerAction().TriggerSuspectSpottedSpeech();
	}
	return;
}

private function ClearCommandGoalsForOfficer(Pawn Officer)
{
	if(Officer.logTyrion)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("ClearCommandGoalsForOfficer (", string(Officer.Name)), ") - Element is executing command: "), string(SwatAIRepo.GetElementSquad().IsExecutingCommandGoal())));
	}
	if(SwatAIRepo.GetElementSquad().IsExecutingCommandGoal())
	{
		SwatAIRepo.GetElementSquad().ClearNonCharacterInteractionCommandGoal();
	}
	else
	{
		if(SwatAIRepo.GetRedSquad().IsOfficerOnTeam(Officer))
		{
			if(Officer.logTyrion)
			{
				Log(Concat_StrStr("Red team executing command goal - ", string(SwatAIRepo.GetRedSquad().IsExecutingCommandGoal())));
			}
			if(SwatAIRepo.GetRedSquad().IsExecutingCommandGoal())
			{
				SwatAIRepo.GetRedSquad().ClearNonCharacterInteractionCommandGoal();
			}
		}
		else
		{
			if(SwatAIRepo.GetBlueSquad().IsOfficerOnTeam(Officer))
			{
				if(Officer.logTyrion)
				{
					Log(Concat_StrStr("Blue team executing command goal - ", string(SwatAIRepo.GetRedSquad().IsExecutingCommandGoal())));
				}
				if(SwatAIRepo.GetRedSquad().IsExecutingCommandGoal())
				{
					SwatAIRepo.GetBlueSquad().ClearNonCharacterInteractionCommandGoal();
				}
			}
		}
	}
	return;
}

private function bool IsOfficerBreaching(Pawn Officer)
{
	assert(Class'Engine.Pawn'.static.checkConscious(Officer));
	return OrOr_BoolBool(NotEqual_ObjectObject(AI_Resource(Officer.CharacterAI).findGoalByName("UseBreachingShotgun"), none), NotEqual_ObjectObject(AI_Resource(Officer.CharacterAI).findGoalByName("UseBreachingCharge"), none));
	return;
}

private function bool IsOfficerDeployingNonLethal(Pawn Officer)
{
	assert(Class'Engine.Pawn'.static.checkConscious(Officer));
	return OrOr_BoolBool(OrOr_BoolBool(OrOr_BoolBool(NotEqual_ObjectObject(AI_Resource(Officer.CharacterAI).findGoalByName("ThrowGrenade"), none), NotEqual_ObjectObject(AI_Resource(Officer.CharacterAI).findGoalByName("DeployPepperSpray"), none)), NotEqual_ObjectObject(AI_Resource(Officer.CharacterAI).findGoalByName("DeployTaser"), none)), NotEqual_ObjectObject(AI_Resource(Officer.CharacterAI).findGoalByName("DeployLessLethalShotgun"), none));
	return;
}

private function bool IsOfficerClearingIntoRoom(Pawn Officer, name RoomName)
{
	if(SwatAIRepo.GetElementSquad().IsMovingAndClearing())
	{
		if(Officer.logAI)
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("IsOfficerClearingIntoRoom - Element - RoomName: ", string(RoomName)), " RoomToClear: "), string(SwatAIRepo.GetElementSquad().GetRoomNameToClear())));
		}
		return EqualEqual_NameName(RoomName, SwatAIRepo.GetElementSquad().GetRoomNameToClear());
	}
	else
	{
		if(SwatAIRepo.GetRedSquad().IsOfficerOnTeam(Officer))
		{
			if(SwatAIRepo.GetRedSquad().IsMovingAndClearing())
			{
				if(Officer.logAI)
				{
					Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("IsOfficerClearingIntoRoom - RedTeam - RoomName: ", string(RoomName)), " RoomToClear: "), string(SwatAIRepo.GetRedSquad().GetRoomNameToClear())));
				}
				return EqualEqual_NameName(RoomName, SwatAIRepo.GetRedSquad().GetRoomNameToClear());
			}
		}
		else
		{
			if(SwatAIRepo.GetBlueSquad().IsMovingAndClearing())
			{
				if(Officer.logAI)
				{
					Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("IsOfficerClearingIntoRoom - BlueTeam - RoomName: ", string(RoomName)), " RoomToClear: "), string(SwatAIRepo.GetBlueSquad().GetRoomNameToClear())));
				}
				return EqualEqual_NameName(RoomName, SwatAIRepo.GetBlueSquad().GetRoomNameToClear());
			}
		}
	}
	return false;
	return;
}

private event bool CanAssignOfficerToTarget(Pawn Officer, Pawn Target)
{
	local bool bIsTargetAThreat;

	assert(Class'Engine.Pawn'.static.checkConscious(Officer));
	if(Target.IsA('SwatEnemy'))
	{
		bIsTargetAThreat = ISwatEnemy(Target).IsAThreat();
	}
	if(AndAnd_BoolBool(AndAnd_BoolBool(Not_PreBool(IsOfficerDeployingNonLethal(Officer)), Not_PreBool(IsOfficerBreaching(Officer))), OrOr_BoolBool(OrOr_BoolBool(OrOr_BoolBool(OrOr_BoolBool(Target.IsInRoom(Officer.GetRoomName()), IsOfficerClearingIntoRoom(Officer, Target.GetRoomName())), AndAnd_BoolBool(OrOr_BoolBool(Not_PreBool(Target.IsA('SwatEnemy')), Not_PreBool(bIsTargetAThreat)), Officer.LineOfSightTo(Target))), AndAnd_BoolBool(AndAnd_BoolBool(Target.IsA('SwatEnemy'), bIsTargetAThreat), Officer.CanHit(Target))), AndAnd_BoolBool(OrOr_BoolBool(bIsTargetAThreat, Not_PreBool(Blackboard.AreAnyAssignedTargetsThreatening())), NotEqual_ObjectObject(FindEngagingPointForOfficerInRoom(Officer, Target, 0.0000000), none)))))
	{
		return true;
	}
	else
	{
		return false;
	}
	return;
}

private function bool CanAssignAnyOfficerToTarget(Pawn Target)
{
	local int i;
	local Pawn Officer;
	local array<Pawn> OfficersOrderedByDistanceToTarget;

	i = 0;
	J0x07:

	if(Less_IntInt(i, GetNumOfficers()))
	{
		Officer = GetOfficer(i);
		if(Class'Engine.Pawn'.static.checkConscious(Officer))
		{
			OfficersOrderedByDistanceToTarget[OfficersOrderedByDistanceToTarget.Length] = Officer;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	i = 0;
	J0x62:

	if(Less_IntInt(i, OfficersOrderedByDistanceToTarget.Length))
	{
		Officer = OfficersOrderedByDistanceToTarget[i];
		if(CanAssignOfficerToTarget(Officer, Target))
		{
			return true;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x62;
	}
	return false;
	return;
}

// Export UHive::execUpdateOfficerAssignments(FFrame&, void* const)
native function UpdateOfficerAssignments();

private event AssignOfficer(Pawn Officer, Pawn Assignment)
{
	assert(NotEqual_ObjectObject(Officer, none));
	assert(NotEqual_ObjectObject(Assignment, none));
	if(Officer.logAI)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("telling ", string(Officer)), " to engage "), string(Assignment)));
	}
	ClearCommandGoalsForOfficer(Officer);
	Blackboard.AddAssignedTarget(Assignment);
	ISwatOfficer(Officer).GetOfficerCommanderAction().EngageTarget(Assignment);
	return;
}

private event ClearOfficerEngagements(Pawn Officer)
{
	if(Officer.logAI)
	{
		Log(Concat_StrStr(string(Officer.Name), " ClearOfficerEngagements"));
	}
	ISwatOfficer(Officer).GetOfficerCommanderAction().ClearAssignment();
	ISwatOfficer(Officer).GetOfficerCommanderAction().ClearEngageGoals();
	return;
}
