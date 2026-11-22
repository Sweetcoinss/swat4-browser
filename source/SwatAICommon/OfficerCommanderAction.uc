class OfficerCommanderAction extends CommanderAction
	native
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

const kRotateToFaceNoiseBehaviorPriority = 50;

var private Hive HiveMind;
var private Pawn CurrentAssignment;
var private bool bHasEngaged;
var private EngageForComplianceGoal CurrentEngageForComplianceGoal;
var private AttackEnemyGoal CurrentAttackEnemyGoal;
var private IdleAimAroundGoal CurrentIdleAimAroundGoal;
var private WatchNonHostileTargetGoal CurrentWatchNonHostileTargetGoal;
var private RotateTowardRotationGoal CurrentRotateTowardRotationGoal;
var config float MinAimAtNoiseWhileMovingTime;
var config float MaxAimAtNoiseWhileMovingTime;
var config float MinFinishedEngagingTimeToAimAround;
var config float MaxFinishedEngagingTimeToAimAround;

function initAction(AI_Resource R, AI_Goal Goal)
{
	super.initAction(R, Goal);
	SetupWatchingNonHostileTargets();
	SetupIdleAimAroundGoal();
	return;
}

function cleanup()
{
	super.cleanup();
	if(NotEqual_ObjectObject(CurrentEngageForComplianceGoal, none))
	{
		CurrentEngageForComplianceGoal.Release();
		CurrentEngageForComplianceGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentAttackEnemyGoal, none))
	{
		CurrentAttackEnemyGoal.Release();
		CurrentAttackEnemyGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentWatchNonHostileTargetGoal, none))
	{
		CurrentWatchNonHostileTargetGoal.Release();
		CurrentWatchNonHostileTargetGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentRotateTowardRotationGoal, none))
	{
		CurrentRotateTowardRotationGoal.Release();
		CurrentRotateTowardRotationGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentIdleAimAroundGoal, none))
	{
		CurrentIdleAimAroundGoal.Release();
		CurrentIdleAimAroundGoal = none;
	}
	return;
}

function RemoveNonDeathGoals()
{
	super.RemoveNonDeathGoals();
	if(NotEqual_ObjectObject(CurrentIdleAimAroundGoal, none))
	{
		CurrentIdleAimAroundGoal.unPostGoal(self);
		CurrentIdleAimAroundGoal.Release();
		CurrentIdleAimAroundGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentEngageForComplianceGoal, none))
	{
		CurrentEngageForComplianceGoal.unPostGoal(self);
		CurrentEngageForComplianceGoal.Release();
		CurrentEngageForComplianceGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentAttackEnemyGoal, none))
	{
		CurrentAttackEnemyGoal.unPostGoal(self);
		CurrentAttackEnemyGoal.Release();
		CurrentAttackEnemyGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentWatchNonHostileTargetGoal, none))
	{
		CurrentWatchNonHostileTargetGoal.unPostGoal(self);
		CurrentWatchNonHostileTargetGoal.Release();
		CurrentWatchNonHostileTargetGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentRotateTowardRotationGoal, none))
	{
		CurrentRotateTowardRotationGoal.unPostGoal(self);
		CurrentRotateTowardRotationGoal.Release();
		CurrentRotateTowardRotationGoal = none;
	}
	return;
}

function Hive GetHive()
{
	if(EqualEqual_ObjectObject(HiveMind, none))
	{
		assert(NotEqual_ObjectObject(m_pawn, none));
		HiveMind = SwatAIRepository(m_pawn.Level.AIRepo).GetHive();
		assert(NotEqual_ObjectObject(HiveMind, none));
	}
	return HiveMind;
	return;
}

// Export UOfficerCommanderAction::execGetCurrentAssignment(FFrame&, void* const)
native function Pawn GetCurrentAssignment();

private function SetupWatchingNonHostileTargets()
{
	CurrentWatchNonHostileTargetGoal = Class'SwatAICommon.WatchNonHostileTargetGoal'.static.Allocate(self).;
	construct_AI_Resource(characterResource());
	assert(NotEqual_ObjectObject(CurrentWatchNonHostileTargetGoal, none));
	CurrentWatchNonHostileTargetGoal.AddRef();
	CurrentWatchNonHostileTargetGoal.postGoal(self);
	return;
}

private function SetupIdleAimAroundGoal()
{
	CurrentIdleAimAroundGoal = Class'SwatAICommon.IdleAimAroundGoal'.static.Allocate(self).;
	construct_AI_ResourceInt(weaponResource());
	assert(NotEqual_ObjectObject(CurrentIdleAimAroundGoal, none));
	CurrentIdleAimAroundGoal.AddRef();
	CurrentIdleAimAroundGoal.postGoal(self);
	return;
}

function OnPawnEncounteredVisionNotification()
{
	local Pawn Enemy;

	if(NotEqual_ObjectObject(VisionSensor.LastPawnSeen, none))
	{
		Enemy = VisionSensor.LastPawnSeen;
	}
	else
	{
		assert(NotEqual_ObjectObject(VisionSensor.LastPawnLost, none));
		Enemy = VisionSensor.LastPawnSeen;
	}
	GetHive().OfficerSawPawn(m_pawn, Enemy);
	return;
}

function OnPawnLostVisionNotification()
{
	assert(NotEqual_ObjectObject(VisionSensor.LastPawnLost, none));
	GetHive().OfficerLostPawn(m_pawn, VisionSensor.LastPawnLost);
	return;
}

function OnHeardNoise()
{
	local Actor HeardActor;
	local Pawn HeardPawn, LastDoorInteractor;
	local name SoundCategory;
	local Vector SoundOrigin;

	if(EqualEqual_ObjectObject(CurrentAssignment, none))
	{
		HeardActor = HearingSensor.LastSoundMaker;
		HeardPawn = Pawn(HeardActor);
		SoundCategory = HearingSensor.LastSoundHeardCategory;
		SoundOrigin = HearingSensor.LastSoundHeardOrigin;
		if(IsDeadlyNoise(SoundCategory))
		{
			if(HeardActor.IsA('FiredWeaponModel'))
			{
				HeardPawn = Pawn(FiredWeaponModel(HeardActor).HandheldEquipment.Owner);
			}
			else
			{
				if(HeardActor.IsA('Ammunition'))
				{
					HeardPawn = Pawn(HeardActor.Owner.Owner);
				}
			}
			if(AndAnd_BoolBool(NotEqual_ObjectObject(HeardPawn, none), ISwatAI(m_pawn).IsOtherActorAThreat(HeardPawn)))
			{
				ISwatAI(m_pawn).GetKnowledge().UpdateKnowledgeAboutPawn(HeardPawn);
				if(m_pawn.LineOfSightTo(HeardPawn))
				{
					RotateToFaceNoise(HeardPawn);
				}
				else
				{
					if(AndAnd_BoolBool(NotEqual_ObjectObject(HeardActor, HeardPawn), m_pawn.LineOfSightTo(HeardActor)))
					{
						RotateToFaceNoise(HeardActor);
					}
				}
			}
		}
		else
		{
			if(EqualEqual_NameName(SoundCategory, 'Footsteps'))
			{
				if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(Not_PreBool(HeardPawn.IsA('SwatPlayer')), Not_PreBool(ISwatAI(HeardPawn).IsCompliant())), Not_PreBool(ISwatAI(HeardPawn).IsArrested())), OrOr_BoolBool(HeardPawn.IsA('SwatHostage'), HeardPawn.IsA('SwatEnemy'))))
				{
					ISwatAI(m_pawn).GetKnowledge().UpdateKnowledgeAboutPawn(HeardPawn);
					if(m_pawn.LineOfSightTo(HeardPawn))
					{
						RotateToFaceNoise(HeardPawn);
					}
				}
			}
			else
			{
				if(EqualEqual_NameName(SoundCategory, 'DoorInteraction'))
				{
					LastDoorInteractor = ISwatDoor(HeardActor).GetLastInteractor();
					if(OrOr_BoolBool(LastDoorInteractor.IsA('SwatHostage'), LastDoorInteractor.IsA('SwatEnemy')))
					{
						if(HasLineOfSightToDoor(Door(HeardActor)))
						{
							RotateToFaceNoise(HeardActor);
						}
					}
				}
			}
		}
	}
	return;
}

private function RotateToFaceNoise(Actor NoisyActor)
{
	assert(NotEqual_ObjectObject(NoisyActor, none));
	if(Greater_FloatFloat(VSize(m_pawn.Velocity), 0.0000000))
	{
		if(OrOr_BoolBool(EqualEqual_ObjectObject(CurrentAimAtTargetGoal, none), CurrentAimAtTargetGoal.hasCompleted()))
		{
			AimAtTarget(NoisyActor, 50, true, MinAimAtNoiseWhileMovingTime, MaxAimAtNoiseWhileMovingTime);
		}
	}
	else
	{
		if(OrOr_BoolBool(EqualEqual_ObjectObject(CurrentRotateTowardActorGoal, none), CurrentRotateTowardActorGoal.hasCompleted()))
		{
			RotateToFace(NoisyActor, 50);
		}
	}
	return;
}

function NotifyDoorBlocked(Door BlockedDoor)
{
	super.NotifyDoorBlocked(BlockedDoor);
	if(ISwatDoor(BlockedDoor).WasBlockedBy('SwatPlayer'))
	{
		ISwatOfficer(m_pawn).GetOfficerSpeechManagerAction().TriggerPlayerBlockingDoorSpeech();
	}
	else
	{
		if(ISwatDoor(BlockedDoor).WasBlockedBy('SwatAICharacter'))
		{
			ISwatOfficer(m_pawn).GetOfficerSpeechManagerAction().TriggerCharacterBlockingDoorSpeech();
		}
	}
	return;
}

private function bool ShouldEngageTarget(Pawn Target)
{
	if(m_pawn.logTyrion)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("ShouldEngageTarget - CurrentAssignment: ", string(CurrentAssignment)), " Target: "), string(Target)), " CurrentAttackEnemyGoal: "), string(CurrentAttackEnemyGoal)));
	}
	if(NotEqual_ObjectObject(CurrentAssignment, Target))
	{
		return true;
	}
	else
	{
		if(AndAnd_BoolBool(AndAnd_BoolBool(Target.IsA('SwatEnemy'), EqualEqual_ObjectObject(CurrentAttackEnemyGoal, none)), ISwatEnemy(Target).IsAThreat()))
		{
			return true;
		}
	}
	return false;
	return;
}

function EngageTarget(Pawn Target)
{
	assert(NotEqual_ObjectObject(Target, none));
	if(ShouldEngageTarget(Target))
	{
		if(m_pawn.logAI)
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(m_pawn.Name), " told to engage new target: "), string(Target.Name)), " at time "), string(Level.TimeSeconds)));
		}
		CurrentAssignment = Target;
		ClearEngageGoals();
		StopWaiting();
		runAction();
	}
	return;
}

function ClearAssignment()
{
	if(m_pawn.logAI)
	{
		Log(Concat_StrStr(string(m_pawn.Name), " assignment cleared"));
	}
	CurrentAssignment = none;
	return;
}

function ClearEngageGoals()
{
	if(NotEqual_ObjectObject(CurrentAttackEnemyGoal, none))
	{
		CurrentAttackEnemyGoal.unPostGoal(self);
		CurrentAttackEnemyGoal.Release();
		CurrentAttackEnemyGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentEngageForComplianceGoal, none))
	{
		CurrentEngageForComplianceGoal.unPostGoal(self);
		CurrentEngageForComplianceGoal.Release();
		CurrentEngageForComplianceGoal = none;
	}
	StopWaiting();
	runAction();
	return;
}

function FindBetterEnemy()
{
	if(AndAnd_BoolBool(NotEqual_ObjectObject(CurrentAttackEnemyGoal, none), NotEqual_ObjectObject(AttackEnemyAction(CurrentAttackEnemyGoal.achievingAction), none)))
	{
		if(Not_PreBool(AttackEnemyAction(CurrentAttackEnemyGoal.achievingAction).IsMovingToAttack()))
		{
			GetHive().UpdateOfficerAssignments();
		}
	}
	return;
}

private latent function EngageTargetForCompliance(Pawn Target)
{
	assert(EqualEqual_ObjectObject(CurrentEngageForComplianceGoal, none));
	if(m_pawn.logAI)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(m_pawn.Name), " is going to engage "), string(Target.Name)), " for compliance"));
	}
	CurrentEngageForComplianceGoal = Class'SwatAICommon.EngageForComplianceGoal'.static.Allocate(self).;
	construct_AI_ResourcePawn(characterResource(), Target);
	assert(NotEqual_ObjectObject(CurrentEngageForComplianceGoal, none));
	CurrentEngageForComplianceGoal.AddRef();
	CurrentEngageForComplianceGoal.postGoal(self);
	waitForGoal(CurrentEngageForComplianceGoal);
	return;
}

private latent function AttackTarget(Pawn Target)
{
	assert(EqualEqual_ObjectObject(CurrentAttackEnemyGoal, none));
	if(m_pawn.logAI)
	{
		Log(Concat_StrStr(Concat_StrStr(string(m_pawn.Name), " is going to attack "), string(Target.Name)));
	}
	CurrentAttackEnemyGoal = Class'SwatAICommon.AttackEnemyGoal'.static.Allocate(self).;
	construct_AI_Resource(characterResource());
	assert(NotEqual_ObjectObject(CurrentAttackEnemyGoal, none));
	CurrentAttackEnemyGoal.AddRef();
	CurrentAttackEnemyGoal.postGoal(self);
	waitForGoal(CurrentAttackEnemyGoal);
	return;
}

private latent function EngageAssignment()
{
	local bool bCompletedEngagementGoals;

	assert(NotEqual_ObjectObject(CurrentAssignment, none));
	if(OrOr_BoolBool(AndAnd_BoolBool(CurrentAssignment.IsA('SwatEnemy'), ISwatEnemy(CurrentAssignment).IsAThreat()), CurrentAssignment.IsA('SwatPlayer')))
	{
		AttackTarget(CurrentAssignment);
		if(NotEqual_ObjectObject(CurrentAttackEnemyGoal, none))
		{
			bCompletedEngagementGoals = CurrentAttackEnemyGoal.hasCompleted();
			CurrentAttackEnemyGoal.unPostGoal(self);
			CurrentAttackEnemyGoal.Release();
			CurrentAttackEnemyGoal = none;
		}
	}
	else
	{
		EngageTargetForCompliance(CurrentAssignment);
		if(NotEqual_ObjectObject(CurrentEngageForComplianceGoal, none))
		{
			bCompletedEngagementGoals = CurrentEngageForComplianceGoal.hasCompleted();
			CurrentEngageForComplianceGoal.unPostGoal(self);
			CurrentEngageForComplianceGoal.Release();
			CurrentEngageForComplianceGoal = none;
		}
	}
	if(OrOr_BoolBool(bCompletedEngagementGoals, Not_PreBool(Class'Engine.Pawn'.static.checkConscious(CurrentAssignment))))
	{
		if(m_pawn.logAI)
		{
			Log(Concat_StrStr(Concat_StrStr(string(m_pawn.Name), " calling finished assignment at time "), string(Level.TimeSeconds)));
		}
		CurrentAssignment = none;
		GetHive().FinishedAssignment();
	}
	return;
}

state Running
{Begin:

	if(EqualEqual_ObjectObject(CurrentAssignment, none))
	{
		if(bHasEngaged)
		{
			Sleep(RandRange(MinFinishedEngagingTimeToAimAround, MaxFinishedEngagingTimeToAimAround));
			if(AndAnd_BoolBool(AndAnd_BoolBool(EqualEqual_ObjectObject(CurrentAssignment, none), EqualEqual_ObjectObject(CurrentWatchNonHostileTargetGoal.achievingAction, none)), NotEqual_ObjectObject(CurrentIdleAimAroundGoal.achievingAction, none)))
			{
				CurrentIdleAimAroundGoal.achievingAction.instantFail(1);
			}
		}
		if(EqualEqual_ObjectObject(CurrentAssignment, none))
		{
			Pause();
		}
	}
	if(NotEqual_ObjectObject(CurrentAssignment, none))
	{
		bHasEngaged = true;
		EngageAssignment();
	}
	yield();
	goto 'Begin';
	stop;
}
