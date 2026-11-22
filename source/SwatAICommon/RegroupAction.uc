class RegroupAction extends SwatCharacterAction
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

var private config float MinRequiredRegroupDistanceFromOfficer;
var private AttackTargetGoal CurrentAttackTargetGoal;
var private MoveToActorGoal CurrentMoveToActorGoal;
var private config float LowSkillAttackWhileRegroupingChance;
var private config float MediumSkillAttackWhileRegroupingChance;
var private config float HighSkillAttackWhileRegroupingChance;
var private config float MinPassiveRegroupPercentageChance;
var private config float MaxPassiveRegroupPercentageChance;
var private config float MinAggressiveRegroupPercentageChance;
var private config float MaxAggressiveRegroupPercentageChance;
var private DistanceToOfficersSensor DistanceToOfficersSensor;
var private bool bUseDistanceToOfficersSensor;

function initAction(AI_Resource R, AI_Goal Goal)
{
	super.initAction(R, Goal);
	assert(NotEqual_ObjectObject(m_pawn, none));
	ISwatAI(m_pawn).EnableFavorLowThreatPath();
	ISwatAICharacter(m_pawn).ForceUpdateAwareness();
	if(Not_PreBool(ISwatAI(m_pawn).HasUsableWeapon()))
	{
		ISwatEnemy(m_pawn).GetEnemyCommanderAction().SetHasFledWithoutUsableWeapon();
	}
	return;
}

private function bool IsAnotherSwatEnemyAlive()
{
	local Pawn PawnIter;

	if(EqualEqual_ObjectObject(Level, none))
	{
		Level = m_pawn.Level;
	}
	PawnIter = Level.PawnList;
	J0x33:

	if(NotEqual_ObjectObject(PawnIter, none))
	{
		if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(PawnIter, m_pawn), Class'Engine.Pawn'.static.checkConscious(PawnIter)), PawnIter.IsA('SwatEnemy')), Not_PreBool(ISwatAI(PawnIter).IsCompliant())), Not_PreBool(ISwatAI(PawnIter).IsArrested())))
		{
			return true;
		}
		PawnIter = PawnIter.nextPawn;
		// [Loop Continue]
		goto J0x33;
	}
	return false;
	return;
}

private function bool IsWithinDistanceOfOfficers()
{
	local Hive HiveMind;

	HiveMind = SwatAIRepository(m_pawn.Level.AIRepo).GetHive();
	assert(NotEqual_ObjectObject(HiveMind, none));
	assert(NotEqual_ObjectObject(m_pawn, none));
	return HiveMind.IsPawnWithinDistanceOfOfficers(m_pawn, MinRequiredRegroupDistanceFromOfficer, true);
	return;
}

private function bool CanGetOutOfRoomSafely()
{
	local SwatAIRepository SwatAIRepo;
	local NavigationPointList DoorsInRoom;
	local Door DoorInRoom;
	local int i;
	local Hive HiveMind;

	HiveMind = SwatAIRepository(m_pawn.Level.AIRepo).GetHive();
	SwatAIRepo = SwatAIRepository(m_pawn.Level.AIRepo);
	DoorsInRoom = SwatAIRepo.GetRoomNavigationPointsOfType(m_pawn.GetRoomName(), 'SwatDoor');
	i = 0;
	J0x7E:

	if(Less_IntInt(i, DoorsInRoom.GetSize()))
	{
		DoorInRoom = Door(DoorsInRoom.GetEntryAt(i));
		if(Not_PreBool(HiveMind.IsActorWithinDistanceOfOfficers(DoorInRoom, MinRequiredRegroupDistanceFromOfficer)))
		{
			return true;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x7E;
	}
	return false;
	return;
}

function float selectionHeuristic(AI_Goal Goal)
{
	if(EqualEqual_ObjectObject(m_pawn, none))
	{
		m_pawn = AI_CharacterResource(Goal.resource).m_pawn;
		assert(NotEqual_ObjectObject(m_pawn, none));
	}
	if(IsAnotherSwatEnemyAlive())
	{
		if(Not_PreBool(IsWithinDistanceOfOfficers()))
		{
			if(CanGetOutOfRoomSafely())
			{
				bUseDistanceToOfficersSensor = true;
				if(ISwatAI(m_pawn).IsAggressive())
				{
					return FClamp(FRand(), MinAggressiveRegroupPercentageChance, MaxAggressiveRegroupPercentageChance);
				}
				else
				{
					return FClamp(FRand(), MinPassiveRegroupPercentageChance, MaxPassiveRegroupPercentageChance);
				}
			}
		}
		else
		{
			bUseDistanceToOfficersSensor = false;
			return Multiply_FloatFloat(FRand(), 0.1000000);
		}
	}
	return 0.0000000;
	return;
}

function cleanup()
{
	super(AI_CharacterAction).cleanup();
	if(NotEqual_ObjectObject(CurrentAttackTargetGoal, none))
	{
		CurrentAttackTargetGoal.Release();
		CurrentAttackTargetGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentMoveToActorGoal, none))
	{
		CurrentMoveToActorGoal.Release();
		CurrentMoveToActorGoal = none;
	}
	if(NotEqual_ObjectObject(DistanceToOfficersSensor, none))
	{
		DistanceToOfficersSensor.deactivateSensor(self);
		DistanceToOfficersSensor = none;
	}
	return;
}

function OnSensorMessage(AI_Sensor sensor, AI_SensorData Value, Object userData)
{
	if(m_pawn.logTyrion)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("RegroupAction received sensor message from ", string(sensor.Name)), " value is "), string(Value.integerData)));
	}
	assert(EqualEqual_ObjectObject(sensor, DistanceToOfficersSensor));
	if(EqualEqual_IntInt(Value.integerData, 1))
	{
		if(m_pawn.logTyrion)
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(m_pawn.Name), " is too close while "), string(Name)), " running.  failing!"));
		}
		instantFail(17);
	}
	return;
}

function float GetSkillSpecificAttackChance()
{
	local ISwatEnemy.EnemySkill CurrentEnemySkill;

	CurrentEnemySkill = ISwatEnemy(m_pawn).GetEnemySkill();
	switch(CurrentEnemySkill)
	{
		case 0:
			return LowSkillAttackWhileRegroupingChance;
		case 1:
			return MediumSkillAttackWhileRegroupingChance;
		case 2:
			return HighSkillAttackWhileRegroupingChance;
		default:
			assert(false);
			return 0.0000000;
			break;
	}
	return;
}

function bool ShouldAttackWhileRegrouping()
{
	assert(NotEqual_ObjectObject(m_pawn, none));
	assert(m_pawn.IsA('SwatEnemy'));
	return AndAnd_BoolBool(ISwatAI(m_pawn).HasUsableWeapon(), Less_FloatFloat(FRand(), GetSkillSpecificAttackChance()));
	return;
}

function AttackWhileRegrouping()
{
	CurrentAttackTargetGoal = Class'SwatAICommon.AttackTargetGoal'.static.Allocate(self).;
	construct_AI_ResourceActor(weaponResource(), ISwatEnemy(m_pawn).GetEnemyCommanderAction().GetCurrentEnemy());
	assert(NotEqual_ObjectObject(CurrentAttackTargetGoal, none));
	CurrentAttackTargetGoal.AddRef();
	CurrentAttackTargetGoal.postGoal(self);
	return;
}

function SwapInFullBodyFleeAnimations()
{
	if(m_pawn.IsA('SwatEnemy'))
	{
		ISwatAI(m_pawn).SetUpperBodyAnimBehavior(0, 17);
		ISwatEnemy(m_pawn).StartSprinting();
	}
	return;
}

function ResetFullBodyAnimations()
{
	if(m_pawn.IsA('SwatEnemy'))
	{
		ISwatAI(m_pawn).UnsetUpperBodyAnimBehavior(17);
		ISwatEnemy(m_pawn).StopSprinting();
	}
	return;
}

private function NavigationPoint FindRegroupDestination()
{
	local Pawn PawnIter;
	local SwatAIRepository SwatAIRepo;
	local name PawnRoomName, PawnIterRoomName;
	local NavigationPoint Destination;
	local array<NavigationPoint> PossibleDestinations;

	SwatAIRepo = SwatAIRepository(m_pawn.Level.AIRepo);
	PawnRoomName = m_pawn.GetRoomName();
	PawnIter = Level.PawnList;
	J0x4B:

	if(NotEqual_ObjectObject(PawnIter, none))
	{
		if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(PawnIter, m_pawn), PawnIter.IsA('SwatEnemy')), Class'Engine.Pawn'.static.checkConscious(PawnIter)), Not_PreBool(PawnIter.IsArrested())), Not_PreBool(PawnIter.IsArrested())))
		{
			PawnIterRoomName = PawnIter.GetRoomName();
			if(NotEqual_NameName(PawnRoomName, PawnIterRoomName))
			{
				PossibleDestinations[PossibleDestinations.Length] = SwatAIRepo.FindRandomPointInRoom(PawnIterRoomName);
			}
		}
		PawnIter = PawnIter.nextPawn;
		// [Loop Continue]
		goto J0x4B;
	}
	Destination = PossibleDestinations[Rand(PossibleDestinations.Length)];
	return Destination;
	return;
}

latent function Regroup()
{
	local NavigationPoint Destination;
	local Pawn CurrentEnemy;

	Destination = FindRegroupDestination();
	if(NotEqual_ObjectObject(Destination, none))
	{
		CurrentEnemy = ISwatEnemy(m_pawn).GetEnemyCommanderAction().GetCurrentEnemy();
		ISwatEnemy(m_pawn).GetEnemySpeechManagerAction().TriggerFleeSpeech();
		if(NotEqual_ObjectObject(CurrentEnemy, none))
		{
			SwatAIRepository(Level.AIRepo).GetHive().NotifyEnemyFleeing(m_pawn);
		}
		if(bUseDistanceToOfficersSensor)
		{
			DistanceToOfficersSensor = DistanceToOfficersSensor(Class'Tyrion.AI_Sensor'.static.activateSensor(self, Class'SwatAICommon.DistanceToOfficersSensor', characterResource(), 0.0000000, 1000000.0000000));
			assert(NotEqual_ObjectObject(DistanceToOfficersSensor, none));
			DistanceToOfficersSensor.setParameters_FloatBool(MinRequiredRegroupDistanceFromOfficer, true);
		}
		CurrentMoveToActorGoal = Class'SwatAICommon.MoveToActorGoal'.static.Allocate(self).;
		construct_AI_ResourceIntActor(movementResource(), achievingGoal.Priority, Destination);
		assert(NotEqual_ObjectObject(CurrentMoveToActorGoal, none));
		CurrentMoveToActorGoal.AddRef();
		CurrentMoveToActorGoal.SetRotateTowardsPointsDuringMovement(true);
		CurrentMoveToActorGoal.SetOpenDoorsFrantically(true);
		CurrentMoveToActorGoal.SetShouldCloseOpenedDoors(true);
		CurrentMoveToActorGoal.SetUseCoveredPaths();
		CurrentMoveToActorGoal.SetWalkThreshold(0.0000000);
		CurrentMoveToActorGoal.postGoal(self);
		waitForGoal(CurrentMoveToActorGoal);
		CurrentMoveToActorGoal.unPostGoal(self);
		CurrentMoveToActorGoal.Release();
		CurrentMoveToActorGoal = none;
	}
	return;
}

function CallForHelp()
{
	local Pawn PawnIter, CurrentEnemy;

	ISwatEnemy(m_pawn).GetEnemySpeechManagerAction().TriggerCallForHelpSpeech();
	CurrentEnemy = ISwatEnemy(m_pawn).GetEnemyCommanderAction().GetCurrentEnemy();
	if(NotEqual_ObjectObject(CurrentEnemy, none))
	{
		PawnIter = Level.PawnList;
		J0x61:

		if(NotEqual_ObjectObject(PawnIter, none))
		{
			if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(Class'Engine.Pawn'.static.checkConscious(PawnIter), PawnIter.IsA('SwatEnemy')), Less_IntInt(int(ISwatEnemy(PawnIter).GetCurrentState()), int(2))), PawnIter.IsInRoom(m_pawn.GetRoomName())))
			{
				ISwatEnemy(PawnIter).GetEnemyCommanderAction().CreateBarricadeGoal(CurrentEnemy.Location, false, false);
			}
			PawnIter = PawnIter.nextPawn;
			// [Loop Continue]
			goto J0x61;
		}
	}
	return;
}

state Running
{Begin:

	waitForResourcesAvailable(achievingGoal.Priority, achievingGoal.Priority);
	if(ShouldAttackWhileRegrouping())
	{
		AttackWhileRegrouping();
	}
	else
	{
		SwapInFullBodyFleeAnimations();
	}
	Regroup();
	CallForHelp();
	ISwatEnemy(m_pawn).GetEnemyCommanderAction().FinishedMovingEngageBehavior();
	succeed();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.EngageOfficerGoal'
}