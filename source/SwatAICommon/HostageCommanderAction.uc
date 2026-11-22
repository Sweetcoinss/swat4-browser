class HostageCommanderAction extends CommanderAction
	native
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

const kRunFromGunshotPriority = 86;

var private CowerGoal CurrentCowerGoal;
var private Pawn Rescuer;
var private HostageReactionToOfficersGoal CurrentHostageReactionToOfficersGoal;
var private bool bWasInDanger;
var config float DangerUpdateTime;
var config float RescuerUpdateTime;
var config float FlashbangedMoraleModification;
var config float GassedMoraleModification;
var config float PepperSprayedMoraleModification;
var config float StungMoraleModification;
var config float TasedMoraleModification;
var config float StunnedByC2MoraleModification;
var config float ShotMoraleModification;
var config float ReactToThrownGrenadeChance;
var config float ScreamChance;
var config float PassiveCrouchWhenHearsDeadlyNoiseChance;
var config float AggressiveCrouchWhenHearsDeadlyNoiseChance;
var private bool bHasHeardFirstDeadlyNoise;
var private float NextTimeToPlayInDangerSpeech;
var config float MinDeltaTimeToPlayInDangerSpeech;
var config float MaxDeltaTimeToPlayInDangerSpeech;

function initAction(AI_Resource R, AI_Goal Goal)
{
	super.initAction(R, Goal);
	ActivateComplySensor();
	InitializeMorale();
	return;
}

function cleanup()
{
	super.cleanup();
	if(NotEqual_ObjectObject(CurrentCowerGoal, none))
	{
		CurrentCowerGoal.Release();
		CurrentCowerGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentHostageReactionToOfficersGoal, none))
	{
		CurrentHostageReactionToOfficersGoal.Release();
		CurrentHostageReactionToOfficersGoal = none;
	}
	return;
}

function RemoveNonDeathGoals()
{
	super.RemoveNonDeathGoals();
	if(NotEqual_ObjectObject(CurrentCowerGoal, none))
	{
		CurrentCowerGoal.unPostGoal(self);
		CurrentCowerGoal.Release();
		CurrentCowerGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentHostageReactionToOfficersGoal, none))
	{
		CurrentHostageReactionToOfficersGoal.unPostGoal(self);
		CurrentHostageReactionToOfficersGoal.Release();
		CurrentHostageReactionToOfficersGoal = none;
	}
	return;
}

function goalNotAchievedCB(AI_Goal Goal, AI_Action Child, ActionBase.ACT_ErrorCodes errorCode)
{
	super.goalNotAchievedCB(Goal, Child, errorCode);
	if(EqualEqual_ObjectObject(Goal, CurrentCowerGoal))
	{
		CurrentCowerGoal.unPostGoal(self);
		CurrentCowerGoal.Release();
		CurrentCowerGoal = none;
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
	local Pawn SeenPawn;

	SeenPawn = VisionSensor.LastPawnSeen;
	assert(NotEqual_ObjectObject(SeenPawn, none));
	if(OrOr_BoolBool(SeenPawn.IsA('SwatOfficer'), SeenPawn.IsA('SwatPlayer')))
	{
		if(EqualEqual_ObjectObject(Rescuer, none))
		{
			Rescuer = SeenPawn;
			if(Not_PreBool(IsRunning()))
			{
				runAction();
			}
		}
	}
	return;
}

function OnPawnLostVisionNotification()
{
	return;
}

function float GetShotMoraleModification()
{
	return ShotMoraleModification;
	return;
}

function NotifyDoorBlocked(Door BlockedDoor)
{
	super.NotifyDoorBlocked(BlockedDoor);
	if(OrOr_BoolBool(ISwatDoor(BlockedDoor).WasBlockedBy('SwatOfficer'), ISwatDoor(BlockedDoor).WasBlockedBy('SwatPlayer')))
	{
		ISwatHostage(m_pawn).GetHostageSpeechManagerAction().TriggerDoorBlockedSpeech();
		if(NotEqual_ObjectObject(CurrentPatrolGoal, none))
		{
			CurrentPatrolGoal.unPostGoal(self);
			CurrentPatrolGoal.Release();
			CurrentPatrolGoal = none;
		}
	}
	return;
}

function float GetFlashbangedMoraleModification()
{
	return FlashbangedMoraleModification;
	return;
}

function float GetGassedMoraleModification()
{
	return GassedMoraleModification;
	return;
}

function float GetPepperSprayedMoraleModification()
{
	return PepperSprayedMoraleModification;
	return;
}

function float GetStungMoraleModification()
{
	return StungMoraleModification;
	return;
}

function float GetTasedMoraleModification()
{
	return TasedMoraleModification;
	return;
}

function float GetStunnedByC2DetonationMoraleModification()
{
	return StunnedByC2MoraleModification;
	return;
}

function PostComplianceCheck(Pawn ComplianceIssuer, bool bWillComply)
{
	if(Not_PreBool(bWillComply))
	{
		if(m_pawn.bIsCrouched)
		{
			m_pawn.ShouldCrouch(false);
		}
		ISwatAI(m_pawn).SetIdleCategory('NonCompliant');
		ISwatHostage(m_pawn).GetHostageSpeechManagerAction().TriggerUncompliantSpeech();
	}
	return;
}

protected function NotifyBecameCompliant()
{
	super.NotifyBecameCompliant();
	if(NotEqual_ObjectObject(CurrentHostageReactionToOfficersGoal, none))
	{
		CurrentHostageReactionToOfficersGoal.unPostGoal(self);
		CurrentHostageReactionToOfficersGoal.Release();
		CurrentHostageReactionToOfficersGoal = none;
	}
	return;
}

function OnHeardNoise()
{
	local Actor HeardActor;
	local Pawn HeardPawn, LastDoorInteractor;
	local name SoundCategory;
	local Vector SoundOrigin;

	HeardActor = HearingSensor.LastSoundMaker;
	HeardPawn = Pawn(HeardActor);
	SoundCategory = HearingSensor.LastSoundHeardCategory;
	SoundOrigin = HearingSensor.LastSoundHeardOrigin;
	Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("HeardActor: ", string(HeardActor)), " HeardActor.Location: "), string(HeardActor.Location)), " distance to heard actor: "), string(VSize(Subtract_VectorVector(HeardActor.Location, m_pawn.Location)))), " line of sight to heard actor: "), string(m_pawn.LineOfSightTo(HeardActor))));
	if(IsDeadlyNoise(SoundCategory))
	{
		OnHeardDeadlyNoise();
		if(HeardActor.IsA('FiredWeaponModel'))
		{
			HeardPawn = Pawn(FiredWeaponModel(HeardActor).HandheldEquipment.Owner);
			assert(NotEqual_ObjectObject(HeardPawn, none));
			RotateToFaceNoise(HeardPawn);
		}
		else
		{
			if(AndAnd_BoolBool(AndAnd_BoolBool(HeardActor.IsA('Ammunition'), Less_FloatFloat(VSize(Subtract_VectorVector(HeardActor.Location, m_pawn.Location)), MinReactToGunshotDistance)), m_pawn.LineOfSightTo(HeardActor)))
			{
				ReactToNearbyGunshot(HeardActor);
			}
		}
	}
	else
	{
		if(AndAnd_BoolBool(AndAnd_BoolBool(EqualEqual_NameName(SoundCategory, 'Footsteps'), EqualEqual_ObjectObject(Rescuer, none)), Not_PreBool(IsInDanger())))
		{
			RotateToFaceNoise(HeardPawn);
		}
		else
		{
			if(AndAnd_BoolBool(AndAnd_BoolBool(EqualEqual_NameName(SoundCategory, 'DoorInteraction'), EqualEqual_ObjectObject(Rescuer, none)), Not_PreBool(IsInDanger())))
			{
				LastDoorInteractor = ISwatDoor(HeardActor).GetLastInteractor();
				if(OrOr_BoolBool(LastDoorInteractor.IsA('SwatPlayer'), LastDoorInteractor.IsA('SwatOfficer')))
				{
					if(HasLineOfSightToDoor(Door(HeardActor)))
					{
						RotateToFace(LastDoorInteractor, 50);
					}
				}
			}
		}
	}
	return;
}

private function ReactToNearbyGunshot(Actor HeardActor)
{
	local NavigationPoint RunAwayDestination;

	if(OrOr_BoolBool(m_pawn.IsCompliant(), m_pawn.IsArrested()))
	{
		PlayFlinch();
	}
	else
	{
		RunAwayDestination = ISwatAI(m_pawn).FindRunToPoint(HeardActor.Location, MinReactToGunshotDistance);
		if(NotEqual_ObjectObject(RunAwayDestination, none))
		{
			if(MoveToActor(RunAwayDestination, 86, true))
			{
				Scream();
			}
		}
		else
		{
			PlayFlinch();
		}
	}
	return;
}

protected function bool ShouldScream()
{
	return Less_FloatFloat(FRand(), ScreamChance);
	return;
}

private function float GetHeardDeadlyNoiseCrouchChance()
{
	if(ISwatAI(m_pawn).IsAggressive())
	{
		return AggressiveCrouchWhenHearsDeadlyNoiseChance;
	}
	else
	{
		return PassiveCrouchWhenHearsDeadlyNoiseChance;
	}
	return;
}

private function OnHeardDeadlyNoise()
{
	if(Not_PreBool(bHasHeardFirstDeadlyNoise))
	{
		bHasHeardFirstDeadlyNoise = true;
		if(Less_FloatFloat(FRand(), GetHeardDeadlyNoiseCrouchChance()))
		{
			m_pawn.ShouldCrouch(true);
		}
		if(IsIdle())
		{
			runAction();
		}
	}
	return;
}

private function RotateToFaceNoise(Pawn HeardPawn)
{
	if(AndAnd_BoolBool(m_pawn.LineOfSightTo(HeardPawn), OrOr_BoolBool(EqualEqual_ObjectObject(CurrentRotateTowardRotationGoal, none), CurrentRotateTowardRotationGoal.hasCompleted())))
	{
		if(OrOr_BoolBool(HeardPawn.IsA('SwatPlayer'), HeardPawn.IsA('SwatOfficer')))
		{
			RotateToRotation(Rotator(Subtract_VectorVector(HeardPawn.Location, m_pawn.Location)), 50);
		}
	}
	return;
}

protected function bool WillReactToGrenadeBeingThrown()
{
	return Less_FloatFloat(FRand(), ReactToThrownGrenadeChance);
	return;
}

function OnThreatened()
{
	if(m_pawn.logAI)
	{
		Log(Concat_StrStr(string(m_pawn.Name), " is threatened"));
	}
	if(IsIdle())
	{
		runAction();
	}
	return;
}

function bool IsInDanger()
{
	local Pawn VisibleEnemy;

	assert(NotEqual_ObjectObject(m_pawn, none));
	assert(NotEqual_ObjectObject(ThreatenedSensorAction(ThreatenedSensor.sensorAction), none));
	if(ThreatenedSensorAction(ThreatenedSensor.sensorAction).IsThreatened())
	{
		return true;
	}
	else
	{
		VisibleEnemy = VisionSensor.GetVisibleConsciousPawnClosestTo(m_pawn.Location, 'SwatEnemy');
		if(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(VisibleEnemy, none), Not_PreBool(ISwatAI(VisibleEnemy).IsCompliant())), Not_PreBool(ISwatAI(VisibleEnemy).IsArrested())))
		{
			return true;
		}
		return SwatAIRepository(m_pawn.Level.AIRepo).DoesRoomContainAIs(m_pawn.GetRoomName(), 'SwatEnemy', true);
	}
	return;
}

latent function Cower()
{
	assert(EqualEqual_ObjectObject(CurrentCowerGoal, none));
	CurrentCowerGoal = Class'SwatAICommon.CowerGoal'.static.Allocate(self).;
	construct_AI_Resource(characterResource());
	assert(NotEqual_ObjectObject(CurrentCowerGoal, none));
	CurrentCowerGoal.AddRef();
	CurrentCowerGoal.postGoal(self);
	return;
}

latent function ReactToRescuer()
{
	CurrentHostageReactionToOfficersGoal = Class'SwatAICommon.HostageReactionToOfficersGoal'.static.Allocate(self).;
	construct_AI_ResourcePawnBool(characterResource(), Rescuer, bWasInDanger);
	assert(NotEqual_ObjectObject(CurrentHostageReactionToOfficersGoal, none));
	CurrentHostageReactionToOfficersGoal.AddRef();
	CurrentHostageReactionToOfficersGoal.postGoal(self);
	waitForGoal(CurrentHostageReactionToOfficersGoal);
	if(NotEqual_ObjectObject(CurrentHostageReactionToOfficersGoal, none))
	{
		CurrentHostageReactionToOfficersGoal.unPostGoal(self);
		CurrentHostageReactionToOfficersGoal.Release();
		CurrentHostageReactionToOfficersGoal = none;
	}
	return;
}

state Running
{Begin:

	Pause();
	if(AndAnd_BoolBool(Not_PreBool(m_pawn.IsCompliant()), Not_PreBool(m_pawn.IsArrested())))
	{
		ISwatAI(m_pawn).SetIdleCategory('None');
		if(NotEqual_ObjectObject(ThreatenedSensor.ThreatenedBy, none))
		{
			bWasInDanger = true;
			Cower();
		}
		J0x6B:

		if(IsInDanger())
		{
			bWasInDanger = true;
			if(Greater_FloatFloat(Level.TimeSeconds, NextTimeToPlayInDangerSpeech))
			{
				ISwatHostage(m_pawn).GetHostageSpeechManagerAction().TriggerInDangerSpeech();
				NextTimeToPlayInDangerSpeech = Add_FloatFloat(Level.TimeSeconds, RandRange(MinDeltaTimeToPlayInDangerSpeech, MaxDeltaTimeToPlayInDangerSpeech));
			}
			Sleep(DangerUpdateTime);
			// [Loop Continue]
			goto J0x6B;
		}
		if(NotEqual_ObjectObject(CurrentCowerGoal, none))
		{
			CurrentCowerGoal.unPostGoal(self);
			CurrentCowerGoal.Release();
			CurrentCowerGoal = none;
		}
		if(NotEqual_ObjectObject(Rescuer, none))
		{
			J0x11B:

			if(Not_PreBool(m_pawn.LineOfSightTo(Rescuer)))
			{
				Sleep(RescuerUpdateTime);
				// [Loop Continue]
				goto J0x11B;
			}
			ReactToRescuer();
		}
	}
	yield();
	goto 'Begin';
	stop;
}
