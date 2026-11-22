class EnemyCommanderAction extends CommanderAction
	native
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

const kRotateToSuspiciousNoisePriority = 55;

var private Pawn CurrentEnemy;
var private Pawn OldEnemy;
var private InitialReactionGoal CurrentInitialReactionGoal;
var private Timer LostPawnTimer;
var private bool bHasHadInitialReactionChance;
var private bool bWasSurprised;
var private bool bReceivedUsableWeaponsMoralePenalty;
var private bool bHasFledWithoutUsableWeapon;
var private bool bIgnoreCurrentEnemy;
var private Door LastBlockedDoor;
var private int BlockedDoorCount;
var config int MaxBlockedDoorCount;
var private InvestigateGoal CurrentInvestigateGoal;
var private BarricadeGoal CurrentBarricadeGoal;
var private EngageOfficerGoal CurrentEngageOfficerGoal;
var private ConverseWithHostagesGoal CurrentConverseWithHostagesGoal;
var config float LowSkillInitialReactionChance;
var config float MediumSkillInitialReactionChance;
var config float HighSkillInitialReactionChance;
var config float MinDistanceToOfficersToDoInitialReaction;
var config float LowSkillScreamChance;
var config float MediumSkillScreamChance;
var config float HighSkillScreamChance;
var config float SurprisedComplianceAngle;
var private float SurprisedComplianceDotProduct;
var config float MaxSurprisedComplianceDistance;
var config float LowSkillSurprisedComplianceMoraleModification;
var config float MediumSkillSurprisedComplianceMoraleModification;
var config float HighSkillSurprisedComplianceMoraleModification;
var config float LowSkillWeaponDroppedMoraleModification;
var config float MediumSkillWeaponDroppedMoraleModification;
var config float HighSkillWeaponDroppedMoraleModification;
var config float LowSkillFlashbangedMoraleModification;
var config float MediumSkillFlashbangedMoraleModification;
var config float HighSkillFlashbangedMoraleModification;
var config float LowSkillGassedMoraleModification;
var config float MediumSkillGassedMoraleModification;
var config float HighSkillGassedMoraleModification;
var config float LowSkillPepperSprayedMoraleModification;
var config float MediumSkillPepperSprayedMoraleModification;
var config float HighSkillPepperSprayedMoraleModification;
var config float LowSkillStungMoraleModification;
var config float MediumSkillStungMoraleModification;
var config float HighSkillStungMoraleModification;
var config float LowSkillTasedMoraleModification;
var config float MediumSkillTasedMoraleModification;
var config float HighSkillTasedMoraleModification;
var config float LowSkillStunnedByC2MoraleModification;
var config float MediumSkillStunnedByC2MoraleModification;
var config float HighSkillStunnedByC2MoraleModification;
var config float LowSkillShotMoraleModification;
var config float MediumSkillShotMoraleModification;
var config float HighSkillShotMoraleModification;
var config float LowSkillKilledOfficerMoraleModification;
var config float MediumSkillKilledOfficerMoraleModification;
var config float HighSkillKilledOfficerMoraleModification;
var config float LowSkillNearbyEnemyKilledMoraleModification;
var config float MediumSkillNearbyEnemyKilledMoraleModification;
var config float HighSkillNearbyEnemyKilledMoraleModification;
var config float LowSkillOutOfUsableWeaponsMoraleModification;
var config float MediumSkillOutOfUsableWeaponsMoraleModification;
var config float HighSkillOutOfUsableWeaponsMoraleModification;
var config float DeltaDistanceToSwitchEnemies;
var config float LowSkillReactToThrownGrenadeChance;
var config float MediumSkillReactToThrownGrenadeChance;
var config float HighSkillReactToThrownGrenadeChance;
var config float MinLostPawnDeltaTime;
var config float MaxLostPawnDeltaTime;

function initAction(AI_Resource R, AI_Goal Goal)
{
	super.initAction(R, Goal);
	SurprisedComplianceDotProduct = Cos(Multiply_FloatFloat(Divide_FloatFloat(SurprisedComplianceAngle, 2.0000000), 0.0174533));
	ActivateComplySensor();
	InitializeMorale();
	SetupHostageConversing();
	return;
}

function cleanup()
{
	super.cleanup();
	if(NotEqual_ObjectObject(CurrentInitialReactionGoal, none))
	{
		CurrentInitialReactionGoal.Release();
		CurrentInitialReactionGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentInvestigateGoal, none))
	{
		CurrentInvestigateGoal.Release();
		CurrentInvestigateGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentBarricadeGoal, none))
	{
		CurrentBarricadeGoal.Release();
		CurrentBarricadeGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentEngageOfficerGoal, none))
	{
		CurrentEngageOfficerGoal.Release();
		CurrentEngageOfficerGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentConverseWithHostagesGoal, none))
	{
		CurrentConverseWithHostagesGoal.Release();
		CurrentConverseWithHostagesGoal = none;
	}
	DeactivateLostPawnTimer();
	return;
}

function RemoveNonDeathGoals()
{
	super.RemoveNonDeathGoals();
	if(NotEqual_ObjectObject(CurrentInitialReactionGoal, none))
	{
		CurrentInitialReactionGoal.unPostGoal(self);
		CurrentInitialReactionGoal.Release();
		CurrentInitialReactionGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentInvestigateGoal, none))
	{
		CurrentInvestigateGoal.unPostGoal(self);
		CurrentInvestigateGoal.Release();
		CurrentInvestigateGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentBarricadeGoal, none))
	{
		CurrentBarricadeGoal.unPostGoal(self);
		CurrentBarricadeGoal.Release();
		CurrentBarricadeGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentEngageOfficerGoal, none))
	{
		CurrentEngageOfficerGoal.unPostGoal(self);
		CurrentEngageOfficerGoal.Release();
		CurrentEngageOfficerGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentConverseWithHostagesGoal, none))
	{
		CurrentConverseWithHostagesGoal.unPostGoal(self);
		CurrentConverseWithHostagesGoal.Release();
		CurrentConverseWithHostagesGoal = none;
	}
	return;
}

function goalNotAchievedCB(AI_Goal Goal, AI_Action Child, ActionBase.ACT_ErrorCodes errorCode)
{
	super.goalNotAchievedCB(Goal, Child, errorCode);
	if(EqualEqual_ObjectObject(Goal, CurrentEngageOfficerGoal))
	{
		CurrentEngageOfficerGoal.unPostGoal(self);
		CurrentEngageOfficerGoal.Release();
		CurrentEngageOfficerGoal = none;
	}
	else
	{
		if(EqualEqual_ObjectObject(Goal, CurrentBarricadeGoal))
		{
			CurrentBarricadeGoal.unPostGoal(self);
			CurrentBarricadeGoal.Release();
			CurrentBarricadeGoal = none;
		}
		else
		{
			if(EqualEqual_ObjectObject(Goal, CurrentInvestigateGoal))
			{
				CurrentInvestigateGoal.unPostGoal(self);
				CurrentInvestigateGoal.Release();
				CurrentInvestigateGoal = none;
			}
			else
			{
				if(EqualEqual_ObjectObject(Goal, CurrentInitialReactionGoal))
				{
					CurrentInitialReactionGoal.unPostGoal(self);
					CurrentInitialReactionGoal.Release();
					CurrentInitialReactionGoal = none;
				}
			}
		}
	}
	return;
}

protected function bool ShouldRemoveFailedPatrolGoal()
{
	return OrOr_BoolBool(EqualEqual_ObjectObject(CurrentInvestigateGoal, none), EqualEqual_IntInt(int(ISwatEnemy(m_pawn).GetCurrentState()), int(2)));
	return;
}

function Pawn GetCurrentEnemy()
{
	return CurrentEnemy;
	return;
}

private function SetupHostageConversing()
{
	CurrentConverseWithHostagesGoal = Class'SwatAICommon.ConverseWithHostagesGoal'.static.Allocate(self).;
	construct_AI_Resource(characterResource());
	assert(NotEqual_ObjectObject(CurrentConverseWithHostagesGoal, none));
	CurrentConverseWithHostagesGoal.AddRef();
	CurrentConverseWithHostagesGoal.postGoal(self);
	return;
}

function float GetFlashbangedMoraleModification()
{
	if(EqualEqual_IntInt(int(ISwatEnemy(m_pawn).GetEnemySkill()), int(2)))
	{
		return HighSkillFlashbangedMoraleModification;
	}
	else
	{
		if(EqualEqual_IntInt(int(ISwatEnemy(m_pawn).GetEnemySkill()), int(1)))
		{
			return MediumSkillFlashbangedMoraleModification;
		}
		else
		{
			return LowSkillFlashbangedMoraleModification;
		}
	}
	return;
}

function float GetGassedMoraleModification()
{
	if(EqualEqual_IntInt(int(ISwatEnemy(m_pawn).GetEnemySkill()), int(2)))
	{
		return HighSkillGassedMoraleModification;
	}
	else
	{
		if(EqualEqual_IntInt(int(ISwatEnemy(m_pawn).GetEnemySkill()), int(1)))
		{
			return MediumSkillGassedMoraleModification;
		}
		else
		{
			return LowSkillGassedMoraleModification;
		}
	}
	return;
}

function float GetPepperSprayedMoraleModification()
{
	if(EqualEqual_IntInt(int(ISwatEnemy(m_pawn).GetEnemySkill()), int(2)))
	{
		return HighSkillPepperSprayedMoraleModification;
	}
	else
	{
		if(EqualEqual_IntInt(int(ISwatEnemy(m_pawn).GetEnemySkill()), int(1)))
		{
			return MediumSkillPepperSprayedMoraleModification;
		}
		else
		{
			return LowSkillPepperSprayedMoraleModification;
		}
	}
	return;
}

function float GetStungMoraleModification()
{
	if(EqualEqual_IntInt(int(ISwatEnemy(m_pawn).GetEnemySkill()), int(2)))
	{
		return HighSkillStungMoraleModification;
	}
	else
	{
		if(EqualEqual_IntInt(int(ISwatEnemy(m_pawn).GetEnemySkill()), int(1)))
		{
			return MediumSkillStungMoraleModification;
		}
		else
		{
			return LowSkillStungMoraleModification;
		}
	}
	return;
}

function float GetTasedMoraleModification()
{
	if(EqualEqual_IntInt(int(ISwatEnemy(m_pawn).GetEnemySkill()), int(2)))
	{
		return HighSkillTasedMoraleModification;
	}
	else
	{
		if(EqualEqual_IntInt(int(ISwatEnemy(m_pawn).GetEnemySkill()), int(1)))
		{
			return MediumSkillTasedMoraleModification;
		}
		else
		{
			return LowSkillTasedMoraleModification;
		}
	}
	return;
}

function float GetStunnedByC2DetonationMoraleModification()
{
	if(EqualEqual_IntInt(int(ISwatEnemy(m_pawn).GetEnemySkill()), int(2)))
	{
		return HighSkillStunnedByC2MoraleModification;
	}
	else
	{
		if(EqualEqual_IntInt(int(ISwatEnemy(m_pawn).GetEnemySkill()), int(1)))
		{
			return MediumSkillStunnedByC2MoraleModification;
		}
		else
		{
			return LowSkillStunnedByC2MoraleModification;
		}
	}
	return;
}

function float GetShotMoraleModification()
{
	if(EqualEqual_IntInt(int(ISwatEnemy(m_pawn).GetEnemySkill()), int(2)))
	{
		return HighSkillShotMoraleModification;
	}
	else
	{
		if(EqualEqual_IntInt(int(ISwatEnemy(m_pawn).GetEnemySkill()), int(1)))
		{
			return MediumSkillShotMoraleModification;
		}
		else
		{
			return LowSkillShotMoraleModification;
		}
	}
	return;
}

private function float GetWeaponDroppedMoraleModification()
{
	if(EqualEqual_IntInt(int(ISwatEnemy(m_pawn).GetEnemySkill()), int(2)))
	{
		return HighSkillWeaponDroppedMoraleModification;
	}
	else
	{
		if(EqualEqual_IntInt(int(ISwatEnemy(m_pawn).GetEnemySkill()), int(1)))
		{
			return MediumSkillWeaponDroppedMoraleModification;
		}
		else
		{
			return LowSkillWeaponDroppedMoraleModification;
		}
	}
	return;
}

function NotifyWeaponDropped()
{
	ChangeMorale(Subtract_PreFloat(GetWeaponDroppedMoraleModification()), "Dropped weapon");
	InterruptCurrentEngagement();
	return;
}

private function float GetKilledOfficerMoraleModification()
{
	if(EqualEqual_IntInt(int(ISwatEnemy(m_pawn).GetEnemySkill()), int(2)))
	{
		return HighSkillKilledOfficerMoraleModification;
	}
	else
	{
		if(EqualEqual_IntInt(int(ISwatEnemy(m_pawn).GetEnemySkill()), int(1)))
		{
			return MediumSkillKilledOfficerMoraleModification;
		}
		else
		{
			return LowSkillKilledOfficerMoraleModification;
		}
	}
	return;
}

function NotifyKilledOfficer(Pawn Officer)
{
	assert(NotEqual_ObjectObject(Officer, none));
	ChangeMorale(GetKilledOfficerMoraleModification(), Concat_StrStr("Killed ", string(Officer.Name)));
	return;
}

private function float GetNearbyEnemyKilledMoraleModification()
{
	if(EqualEqual_IntInt(int(ISwatEnemy(m_pawn).GetEnemySkill()), int(2)))
	{
		return HighSkillNearbyEnemyKilledMoraleModification;
	}
	else
	{
		if(EqualEqual_IntInt(int(ISwatEnemy(m_pawn).GetEnemySkill()), int(1)))
		{
			return MediumSkillNearbyEnemyKilledMoraleModification;
		}
		else
		{
			return LowSkillNearbyEnemyKilledMoraleModification;
		}
	}
	return;
}

function NotifyNearbyEnemyKilled(Pawn NearbyEnemy, Pawn Officer)
{
	assert(NotEqual_ObjectObject(NearbyEnemy, none));
	if(NotEqual_ObjectObject(Officer, none))
	{
		ChangeMorale(Subtract_PreFloat(GetNearbyEnemyKilledMoraleModification()), Concat_StrStr(Concat_StrStr(Concat_StrStr("Nearby Enemy ", string(NearbyEnemy.Name)), " Killed By "), string(Officer.Name)));
	}
	else
	{
		ChangeMorale(Subtract_PreFloat(GetNearbyEnemyKilledMoraleModification()), Concat_StrStr(Concat_StrStr("Nearby Enemy ", string(NearbyEnemy.Name)), " Killed By an inanimate object"));
	}
	return;
}

private function float GetOutOfWeaponsMoraleModification()
{
	if(EqualEqual_IntInt(int(ISwatEnemy(m_pawn).GetEnemySkill()), int(2)))
	{
		return HighSkillOutOfUsableWeaponsMoraleModification;
	}
	else
	{
		if(EqualEqual_IntInt(int(ISwatEnemy(m_pawn).GetEnemySkill()), int(1)))
		{
			return MediumSkillOutOfUsableWeaponsMoraleModification;
		}
		else
		{
			return LowSkillOutOfUsableWeaponsMoraleModification;
		}
	}
	return;
}

private function CheckOutOfUsableWeapons()
{
	if(AndAnd_BoolBool(Not_PreBool(bReceivedUsableWeaponsMoralePenalty), Not_PreBool(ISwatAI(m_pawn).HasUsableWeapon())))
	{
		bReceivedUsableWeaponsMoralePenalty = true;
		ChangeMorale(Subtract_PreFloat(GetOutOfWeaponsMoraleModification()), "Has no usable weapons!");
	}
	return;
}

protected function DisableSensingSystems()
{
	ISwatAI(m_pawn).DisableAwareness();
	ISwatAI(m_pawn).DisableVision(true);
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
	DeactivateLostPawnTimer();
	if(m_pawn.logAI)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(m_pawn.Name), " OnPawnEncounteredVisionNotification - VisionSensor.LastPawnSeen: "), string(VisionSensor.LastPawnSeen)), " LostPawnTimer: "), string(LostPawnTimer)), " CurrentEnemy: "), string(CurrentEnemy)));
	}
	EncounterEnemy(Enemy);
	return;
}

function OnPawnLostVisionNotification()
{
	assert(NotEqual_ObjectObject(VisionSensor.LastPawnLost, none));
	if(m_pawn.logAI)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(m_pawn.Name), " OnPawnLostVisionNotification - VisionSensor.LastPawnLost: "), string(VisionSensor.LastPawnLost)), " CurrentEnemy: "), string(CurrentEnemy)));
	}
	if(EqualEqual_ObjectObject(CurrentEnemy, VisionSensor.LastPawnLost))
	{
		if(AndAnd_BoolBool(AndAnd_BoolBool(Not_PreBool(IsRunningAway()), Not_PreBool(IsTakingCover())), Not_PreBool(IsThreateningHostage())))
		{
			if(AndAnd_BoolBool(NotEqual_ObjectObject(GetBetterEnemy(), none), NotEqual_ObjectObject(GetBetterEnemy(), CurrentEnemy)))
			{
				InterruptCurrentEngagement();
			}
			else
			{
				ActivateLostPawnTimer();
			}
		}
	}
	return;
}

private function ActivateLostPawnTimer()
{
	if(EqualEqual_ObjectObject(LostPawnTimer, none))
	{
		LostPawnTimer = m_pawn.Spawn(Class'Engine.Timer');
		LostPawnTimer.__TimerDelegate__Delegate = LostPawnTimerTriggered;
		LostPawnTimer.StartTimer(RandRange(MinLostPawnDeltaTime, MaxLostPawnDeltaTime));
	}
	return;
}

private function DeactivateLostPawnTimer()
{
	if(NotEqual_ObjectObject(LostPawnTimer, none))
	{
		LostPawnTimer.StopTimer();
		LostPawnTimer.__TimerDelegate__Delegate = None;
		LostPawnTimer.Destroy();
		LostPawnTimer = none;
	}
	return;
}

function LostPawnTimerTriggered()
{
	if(m_pawn.logAI)
	{
		Log("LostPawnTimerTriggered - removing any engage or initial reaction behaviors and setting CurrentEnemy to None");
	}
	assert(NotEqual_ObjectObject(LostPawnTimer, none));
	DeactivateLostPawnTimer();
	SetCurrentEnemy(none);
	InterruptCurrentEngagement();
	return;
}

private function bool DoesSoundCauseUsToKnowAboutPawn(name inSoundCategory)
{
	return EqualEqual_NameName(inSoundCategory, 'OfficerYelling');
	return;
}

private function bool DoWeKnowAboutPawn(Pawn inPawn)
{
	return ISwatAI(m_pawn).GetKnowledge().HasKnownKnowledgeAboutPawn(inPawn);
	return;
}

function OnHeardNoise()
{
	local Actor HeardActor;
	local Pawn HeardPawn, LastDoorInteractor;
	local name SoundCategory;
	local Vector SoundOrigin;

	HeardActor = HearingSensor.LastSoundMaker;
	SoundCategory = HearingSensor.LastSoundHeardCategory;
	SoundOrigin = HearingSensor.LastSoundHeardOrigin;
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
		else
		{
			HeardPawn = Pawn(HeardActor);
		}
	}
	if(m_pawn.logTyrion)
	{
		HearingSensor.DebugHearingSensorToLog();
	}
	if(OrOr_BoolBool(m_pawn.IsCompliant(), m_pawn.IsArrested()))
	{
		if(AndAnd_BoolBool(AndAnd_BoolBool(HeardActor.IsA('Ammunition'), Less_FloatFloat(VSize(Subtract_VectorVector(HeardActor.Location, m_pawn.Location)), MinReactToGunshotDistance)), m_pawn.LineOfSightTo(HeardActor)))
		{
			PlayFlinch();
		}
	}
	else
	{
		if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(HeardPawn, none), ISwatAI(m_pawn).IsOtherActorAThreat(HeardPawn)), m_pawn.LineOfSightTo(HeardPawn)), OrOr_BoolBool(DoesSoundCauseUsToKnowAboutPawn(SoundCategory), DoWeKnowAboutPawn(HeardPawn))))
		{
			ISwatAI(m_pawn).GetKnowledge().UpdateKnowledgeAboutPawn(HeardPawn);
			EncounterEnemy(HeardPawn);
		}
		if(EqualEqual_NameName(SoundCategory, 'Footsteps'))
		{
			HandleFootstepNoise(HeardPawn, SoundOrigin);
		}
		else
		{
			if(EqualEqual_NameName(SoundCategory, 'DoorInteraction'))
			{
				AssertWithDescription(HeardActor.IsA('SwatDoor'), Concat_StrStr(Concat_StrStr("EnemyCommanderAction::OnHeardNoise - sound played by ", string(HeardActor)), " with the Sound category 'DoorInteraction' is not a door!"));
				LastDoorInteractor = ISwatDoor(HeardActor).GetLastInteractor();
				if(AndAnd_BoolBool(ISwatAI(m_pawn).IsOtherActorAThreat(LastDoorInteractor), HasLineOfSightToDoor(Door(HeardActor))))
				{
					if(EqualEqual_IntInt(int(ISwatEnemy(m_pawn).GetCurrentState()), int(2)))
					{
						EncounterEnemy(LastDoorInteractor);
					}
					else
					{
						BecomeSuspicious(SoundOrigin);
					}
				}
			}
			else
			{
				if(EqualEqual_ObjectObject(CurrentEnemy, none))
				{
					BecomeSuspicious(SoundOrigin, AndAnd_BoolBool(NotEqual_ObjectObject(HeardPawn, none), HeardPawn.IsA('SniperPawn')));
				}
			}
		}
	}
	return;
}

private function BecomeSuspicious(Vector SuspiciousEventOrigin, optional bool bOnlyBarricade)
{
	local bool bIsAnInvestigator;

	if(Less_IntInt(int(ISwatEnemy(m_pawn).GetCurrentState()), int(1)))
	{
		ISwatEnemy(m_pawn).SetCurrentState(1);
	}
	if(Not_PreBool(IsRunning()))
	{
		bIsAnInvestigator = ISwatEnemy(m_pawn).IsAnInvestigator();
		if(AndAnd_BoolBool(AndAnd_BoolBool(bIsAnInvestigator, Not_PreBool(bOnlyBarricade)), OrOr_BoolBool(EqualEqual_ObjectObject(CurrentInvestigateGoal, none), CurrentInvestigateGoal.hasCompleted())))
		{
			CreateInvestigateGoal(SuspiciousEventOrigin);
		}
		else
		{
			if(AndAnd_BoolBool(OrOr_BoolBool(bOnlyBarricade, Not_PreBool(bIsAnInvestigator)), OrOr_BoolBool(EqualEqual_ObjectObject(CurrentBarricadeGoal, none), CurrentBarricadeGoal.hasCompleted())))
			{
				CreateBarricadeGoal(SuspiciousEventOrigin, true, true);
			}
			else
			{
				if(m_pawn.FastTrace(SuspiciousEventOrigin, m_pawn.Location))
				{
					RotateToRotation(Rotator(Subtract_VectorVector(SuspiciousEventOrigin, m_pawn.Location)), 55);
				}
			}
		}
	}
	return;
}

private function HandleFootstepNoise(Pawn HeardPawn, Vector FootstepSoundOrigin)
{
	if(AndAnd_BoolBool(NotEqual_ObjectObject(HeardPawn, none), OrOr_BoolBool(HeardPawn.IsA('SwatOfficer'), HeardPawn.IsA('SwatPlayer'))))
	{
		if(NotEqual_ObjectObject(CurrentEnemy, none))
		{
			ISwatAI(m_pawn).GetKnowledge().UpdateKnowledgeAboutPawn(HeardPawn);
			EncounterEnemy(HeardPawn);
		}
		else
		{
			BecomeSuspicious(FootstepSoundOrigin);
		}
	}
	return;
}

private function float GetScreamChance()
{
	if(EqualEqual_IntInt(int(ISwatEnemy(m_pawn).GetEnemySkill()), int(2)))
	{
		return HighSkillScreamChance;
	}
	else
	{
		if(EqualEqual_IntInt(int(ISwatEnemy(m_pawn).GetEnemySkill()), int(1)))
		{
			return MediumSkillScreamChance;
		}
		else
		{
			return LowSkillScreamChance;
		}
	}
	return;
}

protected function bool ShouldScream()
{
	return Less_FloatFloat(FRand(), GetScreamChance());
	return;
}

function float GetSkillSpecificSurpriseComplianceModification()
{
	if(EqualEqual_IntInt(int(ISwatEnemy(m_pawn).GetEnemySkill()), int(2)))
	{
		return HighSkillSurprisedComplianceMoraleModification;
	}
	else
	{
		if(EqualEqual_IntInt(int(ISwatEnemy(m_pawn).GetEnemySkill()), int(1)))
		{
			return MediumSkillSurprisedComplianceMoraleModification;
		}
		else
		{
			return LowSkillSurprisedComplianceMoraleModification;
		}
	}
	return;
}

function bool WasSurprised()
{
	if(bWasSurprised)
	{
		bWasSurprised = false;
		return true;
	}
	return;
}

function bool CheckIfSurprisedByEnemy(Pawn Enemy)
{
	local Vector EnemyDirectionNoZ, ViewDirectionNoZ;
	local float fDot, fDistanceToEnemy;

	fDistanceToEnemy = VSize(Subtract_VectorVector(m_pawn.Location, Enemy.Location));
	if(Less_FloatFloat(fDistanceToEnemy, MaxSurprisedComplianceDistance))
	{
		EnemyDirectionNoZ = Normal(Subtract_VectorVector(Enemy.Location, m_pawn.Location));
		EnemyDirectionNoZ.Z = 0.0000000;
		ViewDirectionNoZ = Vector(ISwatAI(m_pawn).GetAimOrientation());
		ViewDirectionNoZ.Z = 0.0000000;
		fDot = Dot_VectorVector(EnemyDirectionNoZ, ViewDirectionNoZ);
		if(Less_FloatFloat(fDot, SurprisedComplianceDotProduct))
		{
			bWasSurprised = true;
			return true;
		}
	}
	return false;
	return;
}

function PreComplianceCheck(Pawn ComplianceIssuer)
{
	assert(NotEqual_ObjectObject(ComplianceIssuer, none));
	if(Less_IntInt(int(ISwatEnemy(m_pawn).GetCurrentState()), int(2)))
	{
		ISwatEnemy(m_pawn).SetCurrentState(2);
		if(CheckIfSurprisedByEnemy(ComplianceIssuer))
		{
			ChangeMorale(Subtract_PreFloat(GetSkillSpecificSurpriseComplianceModification()), At_StrStr("Enemy surprised by ", string(ComplianceIssuer.Name)));
		}
	}
	return;
}

function PostComplianceCheck(Pawn ComplianceIssuer, bool bWillComply)
{
	if(Not_PreBool(bWillComply))
	{
		ISwatEnemy(m_pawn).GetEnemySpeechManagerAction().TriggerUncompliantSpeech();
		EncounterEnemy(ComplianceIssuer);
	}
	return;
}

protected function NotifyBecameCompliant()
{
	super.NotifyBecameCompliant();
	SetCurrentEnemy(none);
	if(NotEqual_ObjectObject(CurrentInitialReactionGoal, none))
	{
		CurrentInitialReactionGoal.unPostGoal(self);
		CurrentInitialReactionGoal.Release();
		CurrentInitialReactionGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentEngageOfficerGoal, none))
	{
		CurrentEngageOfficerGoal.unPostGoal(self);
		CurrentEngageOfficerGoal.Release();
		CurrentEngageOfficerGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentInvestigateGoal, none))
	{
		CurrentInvestigateGoal.unPostGoal(self);
		CurrentInvestigateGoal.Release();
		CurrentInvestigateGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentBarricadeGoal, none))
	{
		CurrentBarricadeGoal.unPostGoal(self);
		CurrentBarricadeGoal.Release();
		CurrentBarricadeGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentConverseWithHostagesGoal, none))
	{
		CurrentConverseWithHostagesGoal.unPostGoal(self);
		CurrentConverseWithHostagesGoal.Release();
		CurrentConverseWithHostagesGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentPatrolGoal, none))
	{
		CurrentPatrolGoal.unPostGoal(self);
		CurrentPatrolGoal.Release();
		CurrentPatrolGoal = none;
	}
	return;
}

protected function float GetSkillSpecificReactToThrownGrenadeChance()
{
	if(EqualEqual_IntInt(int(ISwatEnemy(m_pawn).GetEnemySkill()), int(2)))
	{
		return HighSkillReactToThrownGrenadeChance;
	}
	else
	{
		if(EqualEqual_IntInt(int(ISwatEnemy(m_pawn).GetEnemySkill()), int(1)))
		{
			return MediumSkillReactToThrownGrenadeChance;
		}
		else
		{
			return LowSkillReactToThrownGrenadeChance;
		}
	}
	return;
}

protected function bool WillReactToGrenadeBeingThrown()
{
	return Less_FloatFloat(FRand(), GetSkillSpecificReactToThrownGrenadeChance());
	return;
}

protected function bool IsTakingCover()
{
	return AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(CurrentEngageOfficerGoal, none), NotEqual_ObjectObject(CurrentEngageOfficerGoal.achievingAction, none)), CurrentEngageOfficerGoal.achievingAction.IsA('TakeCoverAction'));
	return;
}

protected function bool IsRunningAway()
{
	if(AndAnd_BoolBool(NotEqual_ObjectObject(CurrentEngageOfficerGoal, none), NotEqual_ObjectObject(CurrentEngageOfficerGoal.achievingAction, none)))
	{
		return OrOr_BoolBool(CurrentEngageOfficerGoal.achievingAction.IsA('FleeAction'), CurrentEngageOfficerGoal.achievingAction.IsA('RegroupAction'));
	}
	return false;
	return;
}

protected function bool IsThreateningHostage()
{
	return AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(CurrentEngageOfficerGoal, none), NotEqual_ObjectObject(CurrentEngageOfficerGoal.achievingAction, none)), CurrentEngageOfficerGoal.achievingAction.IsA('ThreatenHostageAction'));
	return;
}

private function bool ShouldEncounterNewEnemy(Pawn NewEnemy)
{
	local float DistanceToCurrentEnemy, DistanceToNewEnemy;

	if(AndAnd_BoolBool(NotEqual_ObjectObject(CurrentEnemy, none), NotEqual_ObjectObject(NewEnemy, CurrentEnemy)))
	{
		DistanceToCurrentEnemy = VSize(Subtract_VectorVector(CurrentEnemy.Location, m_pawn.Location));
		DistanceToNewEnemy = VSize(Subtract_VectorVector(NewEnemy.Location, m_pawn.Location));
		if(OrOr_BoolBool(AndAnd_BoolBool(Less_FloatFloat(DistanceToNewEnemy, DistanceToCurrentEnemy), Less_FloatFloat(DistanceToNewEnemy, DeltaDistanceToSwitchEnemies)), AndAnd_BoolBool(Not_PreBool(m_pawn.CanHit(CurrentEnemy)), m_pawn.CanHit(NewEnemy))))
		{
			return true;
		}
	}
	return false;
	return;
}

private function bool ShouldEncounterEnemy(Pawn Enemy)
{
	assert(NotEqual_ObjectObject(Enemy, none));
	if(m_pawn.logTyrion)
	{
		if(NotEqual_ObjectObject(CurrentEngageOfficerGoal, none))
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(m_pawn.Name), " ShouldEncounterEnemy ("), string(Enemy.Name)), ") CurrentInitialReactionGoal: "), string(CurrentInitialReactionGoal)), " CurrentEngageOfficerGoal.achievingAction: "), string(CurrentEngageOfficerGoal.achievingAction)));
		}
		else
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(m_pawn.Name), " ShouldEncounterEnemy ("), string(Enemy.Name)), ") CurrentInitialReactionGoal: "), string(CurrentInitialReactionGoal)), " CurrentEngageOfficerGoal: "), string(CurrentEngageOfficerGoal)));
		}
	}
	return AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(Class'Engine.Pawn'.static.checkConscious(Enemy), Not_PreBool(m_pawn.IsCompliant())), Not_PreBool(m_pawn.IsArrested())), OrOr_BoolBool(OrOr_BoolBool(EqualEqual_ObjectObject(CurrentEnemy, none), AndAnd_BoolBool(EqualEqual_ObjectObject(CurrentInitialReactionGoal, none), EqualEqual_ObjectObject(CurrentEngageOfficerGoal, none))), ShouldEncounterNewEnemy(Enemy)));
	return;
}

function EncounterEnemy(Pawn NewEnemy)
{
	if(ShouldEncounterEnemy(NewEnemy))
	{
		SetCurrentEnemy(NewEnemy);
		ISwatEnemy(m_pawn).SetCurrentState(2);
		ISwatAI(m_pawn).GetKnowledge().UpdateKnowledgeAboutPawn(CurrentEnemy);
		if(NotEqual_ObjectObject(CurrentPatrolGoal, none))
		{
			CurrentPatrolGoal.unPostGoal(self);
			CurrentPatrolGoal.Release();
			CurrentPatrolGoal = none;
		}
		if(NotEqual_ObjectObject(CurrentConverseWithHostagesGoal, none))
		{
			CurrentConverseWithHostagesGoal.unPostGoal(self);
			CurrentConverseWithHostagesGoal.Release();
			CurrentConverseWithHostagesGoal = none;
		}
		if(AndAnd_BoolBool(IsIdle(), EqualEqual_ObjectObject(CurrentInitialReactionGoal, none)))
		{
			runAction();
		}
		else
		{
			if(NotEqual_ObjectObject(CurrentEngageOfficerGoal, none))
			{
				CurrentEngageOfficerGoal.unPostGoal(self);
				CurrentEngageOfficerGoal.Release();
				CurrentEngageOfficerGoal = none;
			}
		}
	}
	return;
}

function SetCurrentEnemy(Pawn NewEnemy)
{
	OldEnemy = CurrentEnemy;
	CurrentEnemy = NewEnemy;
	return;
}

function NotifyTookHit()
{
	if(AndAnd_BoolBool(AndAnd_BoolBool(EqualEqual_ObjectObject(CurrentEnemy, none), Not_PreBool(m_pawn.IsCompliant())), Not_PreBool(m_pawn.IsArrested())))
	{
		bIgnoreCurrentEnemy = true;
		if(IsIdle())
		{
			runAction();
		}
	}
	return;
}

private function float GetInitialReactionChance()
{
	local ISwatEnemy.EnemySkill CurrentEnemySkill;

	if(m_pawn.IsA('SwatGuard'))
	{
		return 1.0000000;
	}
	else
	{
		CurrentEnemySkill = ISwatEnemy(m_pawn).GetEnemySkill();
		switch(CurrentEnemySkill)
		{
			case 0:
				return LowSkillInitialReactionChance;
			case 1:
				return MediumSkillInitialReactionChance;
			case 2:
				return HighSkillInitialReactionChance;
			default:
				assert(false);
				return 0.0000000;
				break;
		}
	}
	return;
}

private function bool ShouldDoInitialReaction()
{
	local Hive HiveMind;

	if(AndAnd_BoolBool(AndAnd_BoolBool(Not_PreBool(bHasHadInitialReactionChance), NotEqual_ObjectObject(CurrentEnemy, none)), LessEqual_FloatFloat(FRand(), GetInitialReactionChance())))
	{
		HiveMind = SwatAIRepository(m_pawn.Level.AIRepo).GetHive();
		assert(NotEqual_ObjectObject(HiveMind, none));
		return Not_PreBool(HiveMind.IsPawnWithinDistanceOfOfficers(m_pawn, MinDistanceToOfficersToDoInitialReaction, true));
	}
	return;
}

latent function ReactInitiallyToEnemy()
{
	assert(NotEqual_ObjectObject(CurrentEnemy, none));
	CurrentInitialReactionGoal = Class'SwatAICommon.InitialReactionGoal'.static.Allocate(self).;
	construct_AI_ResourcePawn(AI_Resource(m_pawn.CharacterAI), CurrentEnemy);
	assert(NotEqual_ObjectObject(CurrentInitialReactionGoal, none));
	CurrentInitialReactionGoal.AddRef();
	CurrentInitialReactionGoal.postGoal(self);
	waitForGoal(CurrentInitialReactionGoal);
	if(NotEqual_ObjectObject(CurrentInitialReactionGoal, none))
	{
		CurrentInitialReactionGoal.unPostGoal(self);
		CurrentInitialReactionGoal.Release();
		CurrentInitialReactionGoal = none;
	}
	return;
}

latent function EngageCurrentEnemy()
{
	assert(EqualEqual_ObjectObject(CurrentEngageOfficerGoal, none));
	if(OrOr_BoolBool(NotEqual_ObjectObject(CurrentEnemy, none), bIgnoreCurrentEnemy))
	{
		CurrentEngageOfficerGoal = Class'SwatAICommon.EngageOfficerGoal'.static.Allocate(self).;
		construct_AI_Resource(AI_Resource(m_pawn.CharacterAI));
		assert(NotEqual_ObjectObject(CurrentEngageOfficerGoal, none));
		CurrentEngageOfficerGoal.AddRef();
		CurrentEngageOfficerGoal.postGoal(self);
		waitForGoal(CurrentEngageOfficerGoal);
		bIgnoreCurrentEnemy = false;
		if(NotEqual_ObjectObject(CurrentEngageOfficerGoal, none))
		{
			CurrentEngageOfficerGoal.unPostGoal(self);
			CurrentEngageOfficerGoal.Release();
			CurrentEngageOfficerGoal = none;
		}
	}
	return;
}

function InterruptCurrentEngagement()
{
	if(AndAnd_BoolBool(NotEqual_ObjectObject(CurrentEngageOfficerGoal, none), NotEqual_ObjectObject(CurrentEngageOfficerGoal.achievingAction, none)))
	{
		CurrentEngageOfficerGoal.achievingAction.instantFail(1);
	}
	if(AndAnd_BoolBool(NotEqual_ObjectObject(CurrentInitialReactionGoal, none), NotEqual_ObjectObject(CurrentInitialReactionGoal.achievingAction, none)))
	{
		CurrentInitialReactionGoal.achievingAction.instantFail(1);
	}
	return;
}

function CreateInvestigateGoal(Vector InvestigateLocation)
{
	if(NotEqual_ObjectObject(CurrentInvestigateGoal, none))
	{
		CurrentInvestigateGoal.unPostGoal(self);
		CurrentInvestigateGoal.Release();
		CurrentInvestigateGoal = none;
	}
	CurrentInvestigateGoal = Class'SwatAICommon.InvestigateGoal'.static.Allocate(self).;
	construct_AI_ResourceVectorBool(characterResource(), InvestigateLocation, true);
	assert(NotEqual_ObjectObject(CurrentInvestigateGoal, none));
	CurrentInvestigateGoal.AddRef();
	CurrentInvestigateGoal.postGoal(self);
	return;
}

function CreateBarricadeGoal(Vector StimuliOrigin, bool bAllowBarricadeDelay, bool bCanCloseDoors)
{
	if(EqualEqual_ObjectObject(CurrentBarricadeGoal, none))
	{
		CurrentBarricadeGoal = Class'SwatAICommon.BarricadeGoal'.static.Allocate(self).;
		construct_AI_ResourceVectorBoolBool(AI_Resource(m_pawn.CharacterAI), StimuliOrigin, bAllowBarricadeDelay, bCanCloseDoors);
		assert(NotEqual_ObjectObject(CurrentBarricadeGoal, none));
		CurrentBarricadeGoal.AddRef();
		CurrentBarricadeGoal.postGoal(self);
	}
	return;
}

private function RemoveSuspiciousGoals()
{
	if(NotEqual_ObjectObject(CurrentBarricadeGoal, none))
	{
		CurrentBarricadeGoal.unPostGoal(self);
		CurrentBarricadeGoal.Release();
		CurrentBarricadeGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentInvestigateGoal, none))
	{
		CurrentInvestigateGoal.unPostGoal(self);
		CurrentInvestigateGoal.Release();
		CurrentInvestigateGoal = none;
	}
	return;
}

function NotifyDoorWedged(Door WedgedDoor)
{
	super.NotifyDoorWedged(WedgedDoor);
	CreateBarricadeGoal(WedgedDoor.Location, false, false);
	return;
}

function NotifyDoorBlocked(Door BlockedDoor)
{
	super.NotifyDoorBlocked(BlockedDoor);
	if(OrOr_BoolBool(ISwatDoor(BlockedDoor).WasBlockedBy('SwatOfficer'), ISwatDoor(BlockedDoor).WasBlockedBy('SwatPlayer')))
	{
		ISwatEnemy(m_pawn).GetEnemySpeechManagerAction().TriggerDoorBlockedSpeech();
		CreateBarricadeGoal(BlockedDoor.Location, false, false);
	}
	if(EqualEqual_ObjectObject(LastBlockedDoor, BlockedDoor))
	{
		AddAdd_Int(BlockedDoorCount);
		if(GreaterEqual_IntInt(BlockedDoorCount, MaxBlockedDoorCount))
		{
			if(NotEqual_ObjectObject(CurrentEngageOfficerGoal, none))
			{
				CurrentEngageOfficerGoal.unPostGoal(self);
				CurrentEngageOfficerGoal.Release();
				CurrentEngageOfficerGoal = none;
			}
			CreateBarricadeGoal(BlockedDoor.Location, false, false);
		}
	}
	else
	{
		LastBlockedDoor = BlockedDoor;
		BlockedDoorCount = 1;
	}
	return;
}

function bool HasFledWithoutUsableWeapon()
{
	return bHasFledWithoutUsableWeapon;
	return;
}

function SetHasFledWithoutUsableWeapon()
{
	bHasFledWithoutUsableWeapon = true;
	return;
}

latent function RespondToSeeingEnemy()
{
	RemoveSuspiciousGoals();
	if(AndAnd_BoolBool(Not_PreBool(bHasHadInitialReactionChance), Not_PreBool(bIgnoreCurrentEnemy)))
	{
		ISwatEnemy(m_pawn).GetEnemySpeechManagerAction().TriggerOfficerEncounteredSpeech();
	}
	if(ShouldDoInitialReaction())
	{
		ReactInitiallyToEnemy();
	}
	bHasHadInitialReactionChance = true;
	EngageCurrentEnemy();
	CheckOutOfUsableWeapons();
	return;
}

function Pawn GetBetterEnemy()
{
	local Pawn BetterEnemy;

	BetterEnemy = VisionSensor.GetVisibleConsciousPawnClosestTo(m_pawn.Location);
	return BetterEnemy;
	return;
}

function FindBetterEnemy()
{
	local Pawn NewEnemy;

	if(NotEqual_ObjectObject(CurrentEnemy, none))
	{
		if(Not_PreBool(m_pawn.CanHit(CurrentEnemy)))
		{
			NewEnemy = VisionSensor.GetVisibleConsciousPawnClosestTo(m_pawn.Location);
			if(AndAnd_BoolBool(NotEqual_ObjectObject(NewEnemy, none), NotEqual_ObjectObject(NewEnemy, CurrentEnemy)))
			{
				EncounterEnemy(NewEnemy);
			}
		}
		if(AndAnd_BoolBool(NotEqual_ObjectObject(CurrentEnemy, none), Not_PreBool(CurrentEnemy.IsConscious())))
		{
			SetCurrentEnemy(none);
		}
	}
	return;
}

latent function FinishedEngagingEnemies()
{
	local KnowledgeAboutPawn OldEnemyKnowledge;
	local Vector LastKnownLocation;

	assert(EqualEqual_ObjectObject(CurrentEnemy, none));
	if(ISwatAI(m_pawn).GetKnowledge().GetLastKnownKnowledgeAboutPawn(OldEnemy, OldEnemyKnowledge))
	{
		LastKnownLocation = OldEnemyKnowledge.Location;
	}
	else
	{
		LastKnownLocation = VisionSensor.LastLostPawnLocation;
	}
	J0x5D:

	if(Not_PreBool(resource.requiredResourcesAvailable(Class'SwatAICommon.BarricadeGoal'.static.GetDefaultPriority(), Class'SwatAICommon.BarricadeGoal'.static.GetDefaultPriority())))
	{
		yield();
		// [Loop Continue]
		goto J0x5D;
	}
	if(m_pawn.logAI)
	{
		Log("FinishedEngagingEnemies - creating barricade goal!");
	}
	CreateBarricadeGoal(LastKnownLocation, false, false);
	return;
}

function FinishedMovingEngageBehavior()
{
	if(OrOr_BoolBool(Not_PreBool(Class'Engine.Pawn'.static.checkConscious(CurrentEnemy)), Not_PreBool(m_pawn.LineOfSightTo(CurrentEnemy))))
	{
		SetCurrentEnemy(none);
	}
	return;
}

private function string GetStimuliResponseTypeName()
{
	if(ISwatEnemy(m_pawn).IsAnInvestigator())
	{
		return "Investigator";
	}
	else
	{
		return "Barricader";
	}
	return;
}

private function string GetEnemyStateName()
{
	local ISwatEnemy.EnemyState CurrentEnemyState;

	CurrentEnemyState = ISwatEnemy(m_pawn).GetCurrentState();
	switch(CurrentEnemyState)
	{
		case 0:
			return "Unaware";
		case 1:
			return "Suspicious";
		case 2:
			return "Aware";
		default:
			assert(false);
			return "";
			break;
	}
	return;
}

private function string GetEnemySkillName()
{
	local ISwatEnemy.EnemySkill Skill;

	Skill = ISwatEnemy(m_pawn).GetEnemySkill();
	switch(Skill)
	{
		case 0:
			return "Low";
		case 1:
			return "Medium";
		case 2:
			return "High";
		default:
			assert(false);
			return "";
			break;
	}
	return;
}

function SetSpecificDebugInfo()
{
	m_pawn.AddDebugMessage(" ");
	m_pawn.AddDebugMessage(At_StrStr("Enemy Responds As a:", GetStimuliResponseTypeName()), Class'Engine.Canvas'.static.MakeColor(byte(255), byte(255), 128));
	m_pawn.AddDebugMessage(At_StrStr("Is A Threat:        ", string(ISwatEnemy(m_pawn).IsAThreat())), Class'Engine.Canvas'.static.MakeColor(byte(255), byte(255), 128));
	m_pawn.AddDebugMessage(At_StrStr("Enemy State:        ", GetEnemyStateName()), Class'Engine.Canvas'.static.MakeColor(byte(255), byte(255), 128));
	m_pawn.AddDebugMessage(At_StrStr("Enemy Skill:        ", GetEnemySkillName()), Class'Engine.Canvas'.static.MakeColor(byte(255), byte(255), 128));
	m_pawn.AddDebugMessage(" ");
	m_pawn.AddDebugMessage(At_StrStr("Current Enemy:      ", string(CurrentEnemy)));
	if(NotEqual_ObjectObject(CurrentEnemy, none))
	{
		m_pawn.AddDebugMessage(At_StrStr("Can Hit Him:        ", string(m_pawn.CanHit(CurrentEnemy))));
	}
	return;
}

state Running
{Begin:

	if(m_pawn.logTyrion)
	{
		Log(Concat_StrStr(Concat_StrStr(string(Name), " paused at time "), string(Level.TimeSeconds)));
	}
	Pause();
	yield();
	if(m_pawn.logTyrion)
	{
		Log(Concat_StrStr(Concat_StrStr(string(Name), " started running at time "), string(Level.TimeSeconds)));
	}
	FindBetterEnemy();
	J0x9D:

	if(OrOr_BoolBool(NotEqual_ObjectObject(CurrentEnemy, none), bIgnoreCurrentEnemy))
	{
		if(m_pawn.logTyrion)
		{
			Log(Concat_StrStr("respond loop - CurrentEnemy: ", string(CurrentEnemy)));
		}
		RespondToSeeingEnemy();
		FindBetterEnemy();
		yield();
		// [Loop Continue]
		goto J0x9D;
	}
	FinishedEngagingEnemies();
	if(m_pawn.logAI)
	{
		Log(Concat_StrStr(Concat_StrStr(string(Name), " is finished engaging at time "), string(Level.TimeSeconds)));
	}
	goto 'Begin';
	stop;
}
