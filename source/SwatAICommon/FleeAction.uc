class FleeAction extends SwatCharacterAction
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

var private config float MinRequiredFleeDistanceFromOfficer;
var private AttackTargetGoal CurrentAttackTargetGoal;
var private MoveToActorGoal CurrentMoveToActorGoal;
var private FleePoint FleeDestination;
var private config float LowSkillAttackWhileFleeingChance;
var private config float MediumSkillAttackWhileFleeingChance;
var private config float HighSkillAttackWhileFleeingChance;
var private config float MinPassiveFleePercentageChance;
var private config float MaxPassiveFleePercentageChance;
var private config float MinAggressiveFleePercentageChance;
var private config float MaxAggressiveFleePercentageChance;
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

function cleanup()
{
	super(AI_CharacterAction).cleanup();
	ISwatAI(m_pawn).DisableFavorLowThreatPath();
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
	ResetFullBodyAnimations();
	return;
}

private function bool IsWithinDistanceOfOfficers()
{
	local Hive HiveMind;

	HiveMind = SwatAIRepository(m_pawn.Level.AIRepo).GetHive();
	assert(NotEqual_ObjectObject(HiveMind, none));
	assert(NotEqual_ObjectObject(m_pawn, none));
	return HiveMind.IsPawnWithinDistanceOfOfficers(m_pawn, MinRequiredFleeDistanceFromOfficer, true);
	return;
}

private function bool FindFleeDestination()
{
	FleeDestination = FindFleePointDestination();
	return NotEqual_ObjectObject(FleeDestination, none);
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
		if(Not_PreBool(HiveMind.IsActorWithinDistanceOfOfficers(DoorInRoom, MinRequiredFleeDistanceFromOfficer)))
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
	if(FindFleeDestination())
	{
		if(Not_PreBool(IsWithinDistanceOfOfficers()))
		{
			if(CanGetOutOfRoomSafely())
			{
				bUseDistanceToOfficersSensor = true;
				if(ISwatAI(m_pawn).IsAggressive())
				{
					return FClamp(FRand(), MinAggressiveFleePercentageChance, MaxAggressiveFleePercentageChance);
				}
				else
				{
					return FClamp(FRand(), MinPassiveFleePercentageChance, MaxPassiveFleePercentageChance);
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

function OnSensorMessage(AI_Sensor sensor, AI_SensorData Value, Object userData)
{
	if(m_pawn.logTyrion)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("FleeAction received sensor message from ", string(sensor.Name)), " value is "), string(Value.integerData)));
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
			return LowSkillAttackWhileFleeingChance;
		case 1:
			return MediumSkillAttackWhileFleeingChance;
		case 2:
			return HighSkillAttackWhileFleeingChance;
		default:
			assert(false);
			return 0.0000000;
			break;
	}
	return;
}

function bool ShouldAttackWhileFleeing()
{
	assert(NotEqual_ObjectObject(m_pawn, none));
	return AndAnd_BoolBool(AndAnd_BoolBool(m_pawn.IsA('SwatEnemy'), ISwatAI(m_pawn).HasUsableWeapon()), Less_FloatFloat(FRand(), GetSkillSpecificAttackChance()));
	return;
}

function AttackWhileFleeing()
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
		ISwatAI(m_pawn).SetUpperBodyAnimBehavior(0, 16);
		ISwatEnemy(m_pawn).StartSprinting();
	}
	return;
}

function ResetFullBodyAnimations()
{
	if(m_pawn.IsA('SwatEnemy'))
	{
		ISwatAI(m_pawn).UnsetUpperBodyAnimBehavior(16);
		ISwatEnemy(m_pawn).StopSprinting();
	}
	return;
}

private function FleePoint FindFleePointDestination()
{
	local SwatAIRepository SwatAIRepo;
	local FleePoint Destination, Iter;
	local NavigationPointList AllFleePoints, ExcludesFleePoints;
	local int i;
	local Pawn CurrentEnemy, IterFleePointUser;
	local array<FleePoint> PossibleDestinations;

	SwatAIRepo = SwatAIRepository(m_pawn.Level.AIRepo);
	ExcludesFleePoints = SwatAIRepo.GetRoomNavigationPointsOfType(m_pawn.GetRoomName(), 'FleePoint');
	AllFleePoints = SwatAIRepo.FindAllOfNavigationPointClass(Class'SwatAICommon.FleePoint', ExcludesFleePoints);
	CurrentEnemy = ISwatEnemy(m_pawn).GetEnemyCommanderAction().GetCurrentEnemy();
	i = 0;
	J0x95:

	if(Less_IntInt(i, AllFleePoints.GetSize()))
	{
		Iter = FleePoint(AllFleePoints.GetEntryAt(i));
		if(OrOr_BoolBool(EqualEqual_ObjectObject(CurrentEnemy, none), Not_PreBool(CurrentEnemy.IsInRoom(Iter.GetRoomName(CurrentEnemy)))))
		{
			IterFleePointUser = Iter.GetFleePointUser();
			if(OrOr_BoolBool(EqualEqual_ObjectObject(IterFleePointUser, none), EqualEqual_ObjectObject(IterFleePointUser, m_pawn)))
			{
				PossibleDestinations[PossibleDestinations.Length] = Iter;
			}
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x95;
	}
	SwatAIRepo.ReleaseNavigationPointList(ExcludesFleePoints);
	SwatAIRepo.ReleaseNavigationPointList(AllFleePoints);
	if(Greater_IntInt(PossibleDestinations.Length, 0))
	{
		Destination = PossibleDestinations[Rand(PossibleDestinations.Length)];
	}
	return Destination;
	return;
}

latent function Flee()
{
	local Pawn CurrentEnemy;

	CurrentEnemy = ISwatEnemy(m_pawn).GetEnemyCommanderAction().GetCurrentEnemy();
	ISwatEnemy(m_pawn).GetEnemySpeechManagerAction().TriggerFleeSpeech();
	if(NotEqual_ObjectObject(CurrentEnemy, none))
	{
		SwatAIRepository(Level.AIRepo).GetHive().NotifyEnemyFleeing(m_pawn);
		if(bUseDistanceToOfficersSensor)
		{
			DistanceToOfficersSensor = DistanceToOfficersSensor(Class'Tyrion.AI_Sensor'.static.activateSensor(self, Class'SwatAICommon.DistanceToOfficersSensor', characterResource(), 0.0000000, 1000000.0000000));
			assert(NotEqual_ObjectObject(DistanceToOfficersSensor, none));
			DistanceToOfficersSensor.setParameters_FloatBool(MinRequiredFleeDistanceFromOfficer, true);
		}
	}
	assert(NotEqual_ObjectObject(FleeDestination, none));
	CurrentMoveToActorGoal = Class'SwatAICommon.MoveToActorGoal'.static.Allocate(self).;
	construct_AI_ResourceIntActor(movementResource(), achievingGoal.Priority, FleeDestination);
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
	return;
}

state Running
{Begin:

	waitForResourcesAvailable(achievingGoal.Priority, achievingGoal.Priority);
	if(ShouldAttackWhileFleeing())
	{
		AttackWhileFleeing();
	}
	else
	{
		SwapInFullBodyFleeAnimations();
	}
	Flee();
	ISwatEnemy(m_pawn).GetEnemyCommanderAction().FinishedMovingEngageBehavior();
	succeed();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.EngageOfficerGoal'
}