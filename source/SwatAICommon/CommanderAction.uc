class CommanderAction extends SwatCharacterAction implements ISensorNotification
	abstract
	native
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

const kMoveAwayFromLocationGoalPriority = 94;

struct native MoraleHistoryEntry
{
	var float ChangeAmount;
	var string ReasonForChange;
};

var(Parameters) PatrolList Patrol;
var(Parameters) bool bStartIncapacitated;
var(Parameters) name StartIncapacitateIdleCategoryOverride;
var private RestrainedGoal CurrentRestrainedGoal;
var private FlashbangedGoal CurrentFlashbangedGoal;
var private GassedGoal CurrentGassedGoal;
var private PepperSprayedGoal CurrentPepperSprayedGoal;
var private PatrolGoal CurrentPatrolGoal;
var private IncapacitatedGoal CurrentIncapacitatedGoal;
var private IdleGoal CurrentIdleGoal;
var private ReactToBeingShotGoal CurrentReactToBeingShotGoal;
var private TasedGoal CurrentTasedGoal;
var private StunnedByC2Goal CurrentStunnedByC2Goal;
var private StungGoal CurrentStungGoal;
var private MoveToActorGoal CurrentMoveToActorGoal;
var private RotateTowardActorGoal CurrentRotateTowardActorGoal;
var private RotateTowardRotationGoal CurrentRotateTowardRotationGoal;
var private AimAtTargetGoal CurrentAimAtTargetGoal;
var private AvoidLocationGoal CurrentAvoidLocationGoal;
var private HearingSensor HearingSensor;
var private VisionSensor VisionSensor;
var private ThreatenedSensor ThreatenedSensor;
var private ComplySensor ComplySensor;
var array<MoraleHistoryEntry> MoraleHistory;
var private float CurrentMorale;
var private ComplianceGoal CurrentComplianceGoal;
var private bool bListeningForCompliance;
var private int ComplianceOrdersIgnored;
var config int MaxComplianceOrdersToIgnore;
var config float MaxMorale;
var private Timer ScreamTimer;
var config float MinScreamTime;
var config float MaxScreamTime;
var config float MinReactToGunshotDistance;

function initAction(AI_Resource R, AI_Goal Goal)
{
	super.initAction(R, Goal);
	ActivateVisionSensor();
	ActivateHearingSensor();
	ActivateThreatenedSensor();
	FindIdleGoal();
	StartPatrolling();
	if(bStartIncapacitated)
	{
		BecomeIncapacitated(StartIncapacitateIdleCategoryOverride);
	}
	return;
}

protected function ActivateVisionSensor()
{
	VisionSensor = VisionSensor(Class'Tyrion.AI_Sensor'.static.activateSensor(self, Class'SwatAICommon.VisionSensor', resource, 0.0000000, 1000000.0000000));
	assert(NotEqual_ObjectObject(VisionSensor, none));
	return;
}

private function ActivateHearingSensor()
{
	HearingSensor = HearingSensor(Class'Tyrion.AI_Sensor'.static.activateSensor(self, Class'SwatAICommon.HearingSensor', resource, 0.0000000, 1000000.0000000));
	assert(NotEqual_ObjectObject(HearingSensor, none));
	return;
}

private function ActivateThreatenedSensor()
{
	ThreatenedSensor = ThreatenedSensor(Class'Tyrion.AI_Sensor'.static.activateSensor(self, Class'SwatAICommon.ThreatenedSensor', resource, 0.0000000, 1000000.0000000));
	assert(NotEqual_ObjectObject(ThreatenedSensor, none));
	return;
}

protected function ActivateComplySensor()
{
	ComplySensor = ComplySensor(Class'Tyrion.AI_Sensor'.static.activateSensor(self, Class'SwatAICommon.ComplySensor', resource, 0.0000000, 1000000.0000000));
	assert(NotEqual_ObjectObject(ComplySensor, none));
	return;
}

protected function InitializeMorale()
{
	ChangeMorale(ISwatAI(m_pawn).GetInitialMorale(), "Initial Morale Setting");
	return;
}

private function FindIdleGoal()
{
	CurrentIdleGoal = IdleGoal(characterResource().findGoalByName("Idle"));
	assert(NotEqual_ObjectObject(CurrentIdleGoal, none));
	CurrentIdleGoal.AddRef();
	return;
}

function cleanup()
{
	super(AI_CharacterAction).cleanup();
	if(NotEqual_ObjectObject(CurrentComplianceGoal, none))
	{
		CurrentComplianceGoal.Release();
		CurrentComplianceGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentRestrainedGoal, none))
	{
		CurrentRestrainedGoal.Release();
		CurrentRestrainedGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentFlashbangedGoal, none))
	{
		CurrentFlashbangedGoal.Release();
		CurrentFlashbangedGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentGassedGoal, none))
	{
		CurrentGassedGoal.Release();
		CurrentGassedGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentPepperSprayedGoal, none))
	{
		CurrentPepperSprayedGoal.Release();
		CurrentPepperSprayedGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentPatrolGoal, none))
	{
		CurrentPatrolGoal.Release();
		CurrentPatrolGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentIncapacitatedGoal, none))
	{
		CurrentIncapacitatedGoal.Release();
		CurrentIncapacitatedGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentIdleGoal, none))
	{
		CurrentIdleGoal.Release();
		CurrentIdleGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentReactToBeingShotGoal, none))
	{
		CurrentReactToBeingShotGoal.Release();
		CurrentReactToBeingShotGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentTasedGoal, none))
	{
		CurrentTasedGoal.Release();
		CurrentTasedGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentStunnedByC2Goal, none))
	{
		CurrentStunnedByC2Goal.Release();
		CurrentStunnedByC2Goal = none;
	}
	if(NotEqual_ObjectObject(CurrentStungGoal, none))
	{
		CurrentStungGoal.Release();
		CurrentStungGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentMoveToActorGoal, none))
	{
		CurrentMoveToActorGoal.Release();
		CurrentMoveToActorGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentRotateTowardActorGoal, none))
	{
		CurrentRotateTowardActorGoal.Release();
		CurrentRotateTowardActorGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentRotateTowardRotationGoal, none))
	{
		CurrentRotateTowardRotationGoal.Release();
		CurrentRotateTowardRotationGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentAimAtTargetGoal, none))
	{
		CurrentAimAtTargetGoal.Release();
		CurrentAimAtTargetGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentAvoidLocationGoal, none))
	{
		CurrentAvoidLocationGoal.Release();
		CurrentAvoidLocationGoal = none;
	}
	if(NotEqual_ObjectObject(HearingSensor, none))
	{
		HearingSensor.deactivateSensor(self);
		HearingSensor = none;
	}
	if(NotEqual_ObjectObject(VisionSensor, none))
	{
		VisionSensor.deactivateSensor(self);
		VisionSensor = none;
	}
	if(NotEqual_ObjectObject(ThreatenedSensor, none))
	{
		ThreatenedSensor.deactivateSensor(self);
		ThreatenedSensor = none;
	}
	if(NotEqual_ObjectObject(ComplySensor, none))
	{
		ComplySensor.deactivateSensor(self);
		ComplySensor = none;
	}
	if(NotEqual_ObjectObject(ScreamTimer, none))
	{
		ScreamTimer.__TimerDelegate__Delegate = None;
		ScreamTimer.Destroy();
		ScreamTimer = none;
	}
	return;
}

function goalNotAchievedCB(AI_Goal Goal, AI_Action Child, ActionBase.ACT_ErrorCodes errorCode)
{
	super(AI_Action).goalNotAchievedCB(Goal, Child, errorCode);
	if(m_pawn.logTyrion)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(Goal.Name), " was not achieved on "), string(m_pawn.Name)), " because of error "), string(errorCode)), " child is "), string(Child)));
	}
	if(AndAnd_BoolBool(EqualEqual_ObjectObject(Goal, CurrentRestrainedGoal), Not_PreBool(ISwatAI(m_pawn).IsArrested())))
	{
		CurrentRestrainedGoal.unPostGoal(self);
		CurrentRestrainedGoal.Release();
		CurrentRestrainedGoal = none;
		PostComplianceGoal();
	}
	else
	{
		if(AndAnd_BoolBool(EqualEqual_ObjectObject(Goal, CurrentPatrolGoal), ShouldRemoveFailedPatrolGoal()))
		{
			CurrentPatrolGoal.unPostGoal(self);
			CurrentPatrolGoal.Release();
			CurrentPatrolGoal = none;
		}
		else
		{
			if(EqualEqual_ObjectObject(Goal, CurrentReactToBeingShotGoal))
			{
				CurrentReactToBeingShotGoal.unPostGoal(self);
				CurrentReactToBeingShotGoal.Release();
				CurrentReactToBeingShotGoal = none;
			}
		}
	}
	return;
}

protected function bool ShouldRemoveFailedPatrolGoal()
{
	return true;
	return;
}

function goalAchievedCB(AI_Goal Goal, AI_Action Child)
{
	super(AI_Action).goalAchievedCB(Goal, Child);
	if(EqualEqual_ObjectObject(Goal, CurrentReactToBeingShotGoal))
	{
		CurrentReactToBeingShotGoal.Release();
		CurrentReactToBeingShotGoal = none;
	}
	return;
}

function bool IsDeadlyNoise(name SoundCategory)
{
	if(OrOr_BoolBool(OrOr_BoolBool(EqualEqual_NameName(SoundCategory, 'Gunshots'), EqualEqual_NameName(SoundCategory, 'BulletHitSpangs')), EqualEqual_NameName(SoundCategory, 'Explosions')))
	{
		return true;
	}
	else
	{
		return false;
	}
	return;
}

function OnSensorMessage(AI_Sensor sensor, AI_SensorData Value, Object userData)
{
	if(AndAnd_BoolBool(m_pawn.logTyrion, NotEqual_ObjectObject(sensor, HearingSensor)))
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(m_pawn.Name), "'s CommanderAction received sensor message from "), string(sensor.Name)), " value is "), string(Value.integerData)));
	}
	if(EqualEqual_ObjectObject(sensor, VisionSensor))
	{
		if(NotEqual_ObjectObject(VisionSensor.LastPawnSeen, none))
		{
			OnPawnEncounteredVisionNotification();
		}
		else
		{
			assert(NotEqual_ObjectObject(VisionSensor.LastPawnLost, none));
			OnPawnLostVisionNotification();
		}
	}
	else
	{
		if(EqualEqual_ObjectObject(sensor, HearingSensor))
		{
			OnHeardNoise();
		}
		else
		{
			if(EqualEqual_ObjectObject(sensor, ThreatenedSensor))
			{
				if(NotEqual_ObjectObject(ThreatenedSensor.ThreatenedBy, none))
				{
					OnThreatened();
				}
				else
				{
					OnNoLongerThreatened();
				}
			}
			else
			{
				if(EqualEqual_ObjectObject(sensor, ComplySensor))
				{
					assert(NotEqual_ObjectObject(Value.objectData, none));
					assert(Value.objectData.IsA('Pawn'));
					OnComplianceIssued(Pawn(Value.objectData));
				}
			}
		}
	}
	return;
}

function OnPawnEncounteredVisionNotification()
{
	return;
}

function OnPawnLostVisionNotification()
{
	return;
}

function OnHeardNoise()
{
	return;
}

function OnThreatened()
{
	return;
}

function OnNoLongerThreatened()
{
	return;
}

protected function bool HasLineOfSightToDoor(Door TestDoor)
{
	local array<Actor> DoorModels;
	local int i;

	DoorModels = ISwatDoor(TestDoor).GetDoorModels();
	i = 0;
	J0x21:

	if(Less_IntInt(i, DoorModels.Length))
	{
		if(m_pawn.LineOfSightTo(DoorModels[i]))
		{
			return true;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x21;
	}
	return false;
	return;
}

function OnComplianceIssued(Pawn ComplianceIssuer)
{
	local bool bWillComply;
	local float RandomChance;

	if(m_pawn.logAI)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("Compliance issued from: ", string(ComplianceIssuer.Name)), " to: "), string(m_pawn.Name)));
	}
	if(AndAnd_BoolBool(AndAnd_BoolBool(Not_PreBool(ISwatAI(m_pawn).IsArrested()), Not_PreBool(ISwatAI(m_pawn).IsCompliant())), Not_PreBool(m_pawn.IsIncapacitated())))
	{
		PreComplianceCheck(ComplianceIssuer);
		if(bListeningForCompliance)
		{
			RandomChance = Subtract_FloatFloat(1.0000000, FRand());
			if(GreaterEqual_FloatFloat(RandomChance, GetCurrentMorale()))
			{
				if(m_pawn.logAI)
				{
					Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(m_pawn.Name), " will comply - morale is: "), string(GetCurrentMorale())), " RandomChance is: "), string(RandomChance)));
				}
				bWillComply = true;
			}
			else
			{
				if(m_pawn.logAI)
				{
					Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(m_pawn.Name), " will not comply - morale is: "), string(GetCurrentMorale())), " RandomChance is: "), string(RandomChance)));
				}
				bWillComply = false;
			}
			bListeningForCompliance = false;
			ComplianceOrdersIgnored = 0;
			if(bWillComply)
			{
				PostComplianceGoal();
			}
		}
		else
		{
			AddAdd_PreInt(ComplianceOrdersIgnored);
			if(IsIgnoringComplianceOrders())
			{
				SwatAIRepository(Level.AIRepo).GetHive().NotifyAIIgnoringOfficers(m_pawn);
			}
		}
		PostComplianceCheck(ComplianceIssuer, bWillComply);
	}
	return;
}

function PreComplianceCheck(Pawn ComplianceIssuer)
{
	return;
}

function PostComplianceCheck(Pawn ComplianceIssuer, bool bWillComply)
{
	return;
}

// Export UCommanderAction::execIsIgnoringComplianceOrders(FFrame&, void* const)
native function bool IsIgnoringComplianceOrders();

function bool IsListeningForCompliance()
{
	return bListeningForCompliance;
	return;
}

protected function DisableSensingSystems()
{
	ISwatAI(m_pawn).DisableAwareness();
	DisableSenses(true);
	return;
}

private function PostComplianceGoal()
{
	if(Not_PreBool(ISwatAI(m_pawn).IsCompliant()))
	{
		ISwatAI(m_pawn).SetIsCompliant();
	}
	if(EqualEqual_ObjectObject(CurrentComplianceGoal, none))
	{
		CurrentComplianceGoal = Class'SwatAICommon.ComplianceGoal'.static.Allocate(self).;
		construct_AI_Resource(characterResource());
		assert(NotEqual_ObjectObject(CurrentComplianceGoal, none));
		CurrentComplianceGoal.AddRef();
		CurrentComplianceGoal.postGoal(self);
	}
	ISwatAI(m_pawn).NotifyBecameCompliant();
	NotifyBecameCompliant();
	DisableSensingSystems();
	GotoState('None');
	return;
}

protected function NotifyBecameCompliant()
{
	if(NotEqual_ObjectObject(CurrentMoveToActorGoal, none))
	{
		CurrentMoveToActorGoal.unPostGoal(self);
		CurrentMoveToActorGoal.Release();
		CurrentMoveToActorGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentRotateTowardActorGoal, none))
	{
		CurrentRotateTowardActorGoal.unPostGoal(self);
		CurrentRotateTowardActorGoal.Release();
		CurrentRotateTowardActorGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentRotateTowardRotationGoal, none))
	{
		CurrentRotateTowardRotationGoal.unPostGoal(self);
		CurrentRotateTowardRotationGoal.Release();
		CurrentRotateTowardRotationGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentAimAtTargetGoal, none))
	{
		CurrentAimAtTargetGoal.unPostGoal(self);
		CurrentAimAtTargetGoal.Release();
		CurrentAimAtTargetGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentAvoidLocationGoal, none))
	{
		CurrentAvoidLocationGoal.unPostGoal(self);
		CurrentAvoidLocationGoal.Release();
		CurrentAvoidLocationGoal = none;
	}
	return;
}

function RemoveComplianceGoal()
{
	if(NotEqual_ObjectObject(CurrentComplianceGoal, none))
	{
		CurrentComplianceGoal.unPostGoal(self);
		CurrentComplianceGoal.Release();
		CurrentComplianceGoal = none;
	}
	return;
}

function NotifyBeginArrest(Pawn inRestrainer)
{
	assert(NotEqual_ObjectObject(inRestrainer, none));
	if(NotEqual_ObjectObject(CurrentRestrainedGoal, none))
	{
		CurrentRestrainedGoal.unPostGoal(self);
		CurrentRestrainedGoal.Release();
		CurrentRestrainedGoal = none;
	}
	CurrentRestrainedGoal = Class'SwatAICommon.RestrainedGoal'.static.Allocate(self).;
	construct_AI_ResourcePawn(characterResource(), inRestrainer);
	assert(NotEqual_ObjectObject(CurrentRestrainedGoal, none));
	CurrentRestrainedGoal.AddRef();
	CurrentRestrainedGoal.postGoal(self);
	return;
}

function NotifyArrestInterrupted()
{
	if(AndAnd_BoolBool(NotEqual_ObjectObject(CurrentRestrainedGoal, none), NotEqual_ObjectObject(CurrentRestrainedGoal.achievingAction, none)))
	{
		assert(CurrentRestrainedGoal.achievingAction.IsA('RestrainedAction'));
		RestrainedAction(CurrentRestrainedGoal.achievingAction).RestrainInterrupted();
	}
	return;
}

function NotifyRestrained()
{
	RemoveComplianceGoal();
	ISwatAI(m_pawn).GetSpeechManagerAction().TriggerRestrainedSpeech();
	return;
}

function bool IsRestrainedGoalRunning()
{
	return AndAnd_BoolBool(NotEqual_ObjectObject(CurrentRestrainedGoal, none), Not_PreBool(CurrentRestrainedGoal.hasCompleted()));
	return;
}

function ResetIdling()
{
	if(NotEqual_ObjectObject(CurrentIdleGoal, none))
	{
		if(NotEqual_ObjectObject(CurrentIdleGoal.achievingAction, none))
		{
			CurrentIdleGoal.achievingAction.instantSucceed();
		}
	}
	return;
}

function StartPatrolling()
{
	if(NotEqual_ObjectObject(Patrol, none))
	{
		CurrentPatrolGoal = Class'SwatAICommon.PatrolGoal'.static.Allocate(self).;
		construct_AI_ResourcePatrolList(characterResource(), Patrol);
		assert(NotEqual_ObjectObject(CurrentPatrolGoal, none));
		CurrentPatrolGoal.AddRef();
		CurrentPatrolGoal.postGoal(self);
	}
	return;
}

function BecomeIncapacitated(optional name IncapaciatedIdleCategoryOverride)
{
	RemoveNonDeathGoals();
	if(Not_PreBool(bStartIncapacitated))
	{
		RemoveIdleGoal();
	}
	if(EqualEqual_ObjectObject(CurrentIncapacitatedGoal, none))
	{
		CurrentIncapacitatedGoal = Class'SwatAICommon.IncapacitatedGoal'.static.Allocate(self).;
		construct_AI_ResourceBoolName(characterResource(), bStartIncapacitated, IncapaciatedIdleCategoryOverride);
		assert(NotEqual_ObjectObject(CurrentIncapacitatedGoal, none));
		CurrentIncapacitatedGoal.AddRef();
		CurrentIncapacitatedGoal.postGoal(self);
	}
	return;
}

private function RemoveIdleGoal()
{
	if(NotEqual_ObjectObject(CurrentIdleGoal, none))
	{
		CurrentIdleGoal.unPostGoal(none);
		CurrentIdleGoal.Release();
		CurrentIdleGoal = none;
	}
	return;
}

function RemoveNonDeathGoals()
{
	if(NotEqual_ObjectObject(ScreamTimer, none))
	{
		ScreamTimer.__TimerDelegate__Delegate = None;
		ScreamTimer.Destroy();
		ScreamTimer = none;
	}
	ISwatAI(m_pawn).DisableHearing(true);
	if(NotEqual_ObjectObject(CurrentComplianceGoal, none))
	{
		CurrentComplianceGoal.unPostGoal(self);
		CurrentComplianceGoal.Release();
		CurrentComplianceGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentRestrainedGoal, none))
	{
		CurrentRestrainedGoal.unPostGoal(self);
		CurrentRestrainedGoal.Release();
		CurrentRestrainedGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentFlashbangedGoal, none))
	{
		CurrentFlashbangedGoal.unPostGoal(self);
		CurrentFlashbangedGoal.Release();
		CurrentFlashbangedGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentGassedGoal, none))
	{
		CurrentGassedGoal.unPostGoal(self);
		CurrentGassedGoal.Release();
		CurrentGassedGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentPepperSprayedGoal, none))
	{
		CurrentPepperSprayedGoal.unPostGoal(self);
		CurrentPepperSprayedGoal.Release();
		CurrentPepperSprayedGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentStunnedByC2Goal, none))
	{
		CurrentPepperSprayedGoal.unPostGoal(self);
		CurrentPepperSprayedGoal.Release();
		CurrentPepperSprayedGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentStungGoal, none))
	{
		CurrentStungGoal.unPostGoal(self);
		CurrentStungGoal.Release();
		CurrentStungGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentPatrolGoal, none))
	{
		CurrentPatrolGoal.unPostGoal(self);
		CurrentPatrolGoal.Release();
		CurrentPatrolGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentReactToBeingShotGoal, none))
	{
		CurrentReactToBeingShotGoal.unPostGoal(self);
		CurrentReactToBeingShotGoal.Release();
		CurrentReactToBeingShotGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentTasedGoal, none))
	{
		CurrentTasedGoal.unPostGoal(self);
		CurrentTasedGoal.Release();
		CurrentTasedGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentMoveToActorGoal, none))
	{
		CurrentMoveToActorGoal.unPostGoal(self);
		CurrentMoveToActorGoal.Release();
		CurrentMoveToActorGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentRotateTowardActorGoal, none))
	{
		CurrentRotateTowardActorGoal.unPostGoal(self);
		CurrentRotateTowardActorGoal.Release();
		CurrentRotateTowardActorGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentRotateTowardRotationGoal, none))
	{
		CurrentRotateTowardRotationGoal.unPostGoal(self);
		CurrentRotateTowardRotationGoal.Release();
		CurrentRotateTowardRotationGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentAimAtTargetGoal, none))
	{
		CurrentAimAtTargetGoal.unPostGoal(self);
		CurrentAimAtTargetGoal.Release();
		CurrentAimAtTargetGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentAvoidLocationGoal, none))
	{
		CurrentAvoidLocationGoal.unPostGoal(self);
		CurrentAvoidLocationGoal.Release();
		CurrentAvoidLocationGoal = none;
	}
	return;
}

function RemoveGoalsToDie()
{
	RemoveNonDeathGoals();
	if(NotEqual_ObjectObject(CurrentIncapacitatedGoal, none))
	{
		CurrentIncapacitatedGoal.unPostGoal(self);
		CurrentIncapacitatedGoal.Release();
		CurrentIncapacitatedGoal = none;
	}
	RemoveIdleGoal();
	return;
}

function OnSkeletalRegionHit(Actor.ESkeletalRegion RegionHit, Vector HitLocation, Vector HitNormal, int Damage, Class<DamageType> DamageType)
{
	if(AndAnd_BoolBool(Greater_IntInt(Damage, 0), m_pawn.IsConscious()))
	{
		if(AndAnd_BoolBool(EqualEqual_ObjectObject(CurrentIncapacitatedGoal, none), EqualEqual_ObjectObject(CurrentReactToBeingShotGoal, none)))
		{
			CurrentReactToBeingShotGoal = Class'SwatAICommon.ReactToBeingShotGoal'.static.Allocate(self).;
			construct_AI_ResourceByteVectorVector(characterResource(), RegionHit, HitLocation, HitNormal);
			assert(NotEqual_ObjectObject(CurrentReactToBeingShotGoal, none));
			CurrentReactToBeingShotGoal.AddRef();
			CurrentReactToBeingShotGoal.postGoal(self);
		}
		else
		{
			if(AndAnd_BoolBool(NotEqual_ObjectObject(CurrentReactToBeingShotGoal, none), NotEqual_ObjectObject(CurrentReactToBeingShotGoal.achievingAction, none)))
			{
				ReactToBeingShotAction(CurrentReactToBeingShotGoal.achievingAction).PlayQuickHit(HitLocation);
			}
		}
		NotifyTookHit();
		ChangeMorale(Subtract_PreFloat(GetShotMoraleModification()), "Shot", true);
	}
	return;
}

function NotifyTookHit()
{
	return;
}

function float GetShotMoraleModification()
{
	return 0.0000000;
	return;
}

protected function Scream()
{
	if(EqualEqual_ObjectObject(ScreamTimer, none))
	{
		ScreamTimer = m_pawn.Spawn(Class'Engine.Timer');
		ScreamTimer.__TimerDelegate__Delegate = TriggerScreamSpeech;
	}
	ScreamTimer.StartTimer(RandRange(MinScreamTime, MaxScreamTime), false, true);
	return;
}

function TriggerScreamSpeech()
{
	if(m_pawn.IsConscious())
	{
		ISwatAI(m_pawn).GetSpeechManagerAction().TriggerScreamSpeech();
	}
	return;
}

protected function bool ShouldScream()
{
	return false;
	return;
}

protected function PlayFlinch()
{
	local name FlinchAnimationName;

	Log(Concat_StrStr("PlayFlinch called on server for ", string(m_pawn.Name)));
	if(AndAnd_BoolBool(AndAnd_BoolBool(Not_PreBool(m_pawn.IsAnimating(m_pawn.AnimGetSpecialChannel())), EqualEqual_FloatFloat(VSize(m_pawn.Velocity), 0.0000000)), Not_PreBool(ISwatAI(m_pawn).IsTurning())))
	{
		FlinchAnimationName = ISwatAI(m_pawn).GetFlinchAnimation();
		m_pawn.AnimPlaySpecial(FlinchAnimationName, 0.1000000);
		if(ShouldScream())
		{
			Scream();
		}
	}
	return;
}

function float GetFlashbangedMoraleModification()
{
	assert(false);
	return 0.0000000;
	return;
}

function float GetGassedMoraleModification()
{
	assert(false);
	return 0.0000000;
	return;
}

function float GetPepperSprayedMoraleModification()
{
	assert(false);
	return 0.0000000;
	return;
}

function float GetStungMoraleModification()
{
	assert(false);
	return 0.0000000;
	return;
}

function float GetTasedMoraleModification()
{
	assert(false);
	return 0.0000000;
	return;
}

function float GetStunnedByC2DetonationMoraleModification()
{
	assert(false);
	return 0.0000000;
	return;
}

function bool ShouldRunWhenFlashBanged()
{
	return true;
	return;
}

function bool ShouldRunWhenGassed()
{
	return true;
	return;
}

function bool ShouldRunWhenPepperSprayed()
{
	return false;
	return;
}

function bool ShouldRunWhenStung()
{
	return true;
	return;
}

function bool ShouldRunWhenTased()
{
	return false;
	return;
}

function bool ShouldRunWhenStunnedByC2()
{
	return true;
	return;
}

function NotifyFlashbanged(Vector FlashbangLocation, float StunnedDuration)
{
	if(NotEqual_ObjectObject(CurrentFlashbangedGoal, none))
	{
		if(OrOr_BoolBool(CurrentFlashbangedGoal.hasCompleted(), EqualEqual_ObjectObject(CurrentFlashbangedGoal.achievingAction, none)))
		{
			CurrentFlashbangedGoal.unPostGoal(self);
			CurrentFlashbangedGoal.Release();
			CurrentFlashbangedGoal = none;
		}
		else
		{
			assert(NotEqual_ObjectObject(FlashbangedAction(CurrentFlashbangedGoal.achievingAction), none));
			FlashbangedAction(CurrentFlashbangedGoal.achievingAction).ExtendBeingStunned(StunnedDuration);
		}
	}
	if(EqualEqual_ObjectObject(CurrentFlashbangedGoal, none))
	{
		CurrentFlashbangedGoal = Class'SwatAICommon.FlashbangedGoal'.static.Allocate(self).;
		construct_AI_ResourceVectorFloat(characterResource(), FlashbangLocation, StunnedDuration);
		assert(NotEqual_ObjectObject(CurrentFlashbangedGoal, none));
		CurrentFlashbangedGoal.AddRef();
		CurrentFlashbangedGoal.bShouldRunFromStunningDevice = ShouldRunWhenFlashBanged();
		CurrentFlashbangedGoal.postGoal(self);
	}
	return;
}

function NotifyGassed(Vector GasContainerLocation, float StunnedDuration)
{
	if(NotEqual_ObjectObject(CurrentGassedGoal, none))
	{
		if(OrOr_BoolBool(CurrentGassedGoal.hasCompleted(), EqualEqual_ObjectObject(CurrentGassedGoal.achievingAction, none)))
		{
			CurrentGassedGoal.unPostGoal(self);
			CurrentGassedGoal.Release();
			CurrentGassedGoal = none;
		}
		else
		{
			assert(NotEqual_ObjectObject(GassedAction(CurrentGassedGoal.achievingAction), none));
			GassedAction(CurrentGassedGoal.achievingAction).ExtendBeingStunned(StunnedDuration);
		}
	}
	if(EqualEqual_ObjectObject(CurrentGassedGoal, none))
	{
		CurrentGassedGoal = Class'SwatAICommon.GassedGoal'.static.Allocate(self).;
		construct_AI_ResourceVectorFloat(characterResource(), GasContainerLocation, StunnedDuration);
		assert(NotEqual_ObjectObject(CurrentGassedGoal, none));
		CurrentGassedGoal.AddRef();
		CurrentGassedGoal.bShouldRunFromStunningDevice = ShouldRunWhenGassed();
		CurrentGassedGoal.postGoal(self);
	}
	return;
}

function NotifyPepperSprayed(Vector PepperSprayLocation, float StunnedDuration)
{
	if(NotEqual_ObjectObject(CurrentPepperSprayedGoal, none))
	{
		if(OrOr_BoolBool(CurrentPepperSprayedGoal.hasCompleted(), EqualEqual_ObjectObject(CurrentPepperSprayedGoal.achievingAction, none)))
		{
			CurrentPepperSprayedGoal.unPostGoal(self);
			CurrentPepperSprayedGoal.Release();
			CurrentPepperSprayedGoal = none;
		}
		else
		{
			PepperSprayedAction(CurrentPepperSprayedGoal.achievingAction).ExtendBeingStunned(StunnedDuration);
		}
	}
	if(EqualEqual_ObjectObject(CurrentPepperSprayedGoal, none))
	{
		CurrentPepperSprayedGoal = Class'SwatAICommon.PepperSprayedGoal'.static.Allocate(self).;
		construct_AI_ResourceVectorFloat(characterResource(), PepperSprayLocation, StunnedDuration);
		assert(NotEqual_ObjectObject(CurrentPepperSprayedGoal, none));
		CurrentPepperSprayedGoal.AddRef();
		CurrentPepperSprayedGoal.bShouldRunFromStunningDevice = ShouldRunWhenPepperSprayed();
		CurrentPepperSprayedGoal.postGoal(self);
	}
	return;
}

function bool IsAffectedByPepperSpray()
{
	return AndAnd_BoolBool(NotEqual_ObjectObject(CurrentPepperSprayedGoal, none), Not_PreBool(CurrentPepperSprayedGoal.hasCompleted()));
	return;
}

function NotifyTased(Vector TaserLocation, float StunnedDuration)
{
	if(NotEqual_ObjectObject(CurrentTasedGoal, none))
	{
		if(OrOr_BoolBool(CurrentTasedGoal.hasCompleted(), EqualEqual_ObjectObject(CurrentTasedGoal.achievingAction, none)))
		{
			CurrentTasedGoal.unPostGoal(self);
			CurrentTasedGoal.Release();
			CurrentTasedGoal = none;
		}
		else
		{
			assert(NotEqual_ObjectObject(TasedAction(CurrentTasedGoal.achievingAction), none));
			TasedAction(CurrentTasedGoal.achievingAction).ExtendBeingStunned(StunnedDuration);
		}
	}
	if(EqualEqual_ObjectObject(CurrentTasedGoal, none))
	{
		CurrentTasedGoal = Class'SwatAICommon.TasedGoal'.static.Allocate(self).;
		construct_AI_ResourceVectorFloat(characterResource(), TaserLocation, StunnedDuration);
		assert(NotEqual_ObjectObject(CurrentTasedGoal, none));
		CurrentTasedGoal.AddRef();
		CurrentTasedGoal.bShouldRunFromStunningDevice = ShouldRunWhenTased();
		CurrentTasedGoal.postGoal(self);
	}
	return;
}

function NotifyStunnedByC2Detonation(Vector C2ChargeLocation, float StunnedDuration)
{
	if(NotEqual_ObjectObject(CurrentStunnedByC2Goal, none))
	{
		if(OrOr_BoolBool(CurrentStunnedByC2Goal.hasCompleted(), EqualEqual_ObjectObject(CurrentStunnedByC2Goal.achievingAction, none)))
		{
			CurrentStunnedByC2Goal.unPostGoal(self);
			CurrentStunnedByC2Goal.Release();
			CurrentStunnedByC2Goal = none;
		}
		else
		{
			assert(NotEqual_ObjectObject(StunnedByC2Action(CurrentStunnedByC2Goal.achievingAction), none));
			StunnedByC2Action(CurrentStunnedByC2Goal.achievingAction).ExtendBeingStunned(StunnedDuration);
		}
	}
	if(EqualEqual_ObjectObject(CurrentStunnedByC2Goal, none))
	{
		CurrentStunnedByC2Goal = Class'SwatAICommon.StunnedByC2Goal'.static.Allocate(self).;
		construct_AI_ResourceVectorFloat(characterResource(), C2ChargeLocation, StunnedDuration);
		assert(NotEqual_ObjectObject(CurrentStunnedByC2Goal, none));
		CurrentStunnedByC2Goal.AddRef();
		CurrentStunnedByC2Goal.bShouldRunFromStunningDevice = ShouldRunWhenStunnedByC2();
		CurrentStunnedByC2Goal.postGoal(self);
	}
	return;
}

function NotifyStung(Actor Grenade, Vector StungGrenadeLocation, float StunnedDuration)
{
	if(NotEqual_ObjectObject(CurrentStungGoal, none))
	{
		if(OrOr_BoolBool(CurrentStungGoal.hasCompleted(), EqualEqual_ObjectObject(CurrentStungGoal.achievingAction, none)))
		{
			CurrentStungGoal.unPostGoal(self);
			CurrentStungGoal.Release();
			CurrentStungGoal = none;
		}
		else
		{
			assert(NotEqual_ObjectObject(StungAction(CurrentStungGoal.achievingAction), none));
			StungAction(CurrentStungGoal.achievingAction).ExtendBeingStunned(StunnedDuration);
		}
	}
	if(EqualEqual_ObjectObject(CurrentStungGoal, none))
	{
		CurrentStungGoal = Class'SwatAICommon.StungGoal'.static.Allocate(self).;
		construct_AI_ResourceActorVectorFloat(characterResource(), Grenade, StungGrenadeLocation, StunnedDuration);
		assert(NotEqual_ObjectObject(CurrentStungGoal, none));
		CurrentStungGoal.AddRef();
		CurrentStungGoal.bShouldRunFromStunningDevice = ShouldRunWhenStung();
		CurrentStungGoal.postGoal(self);
	}
	return;
}

protected function bool WillReactToGrenadeBeingThrown()
{
	return true;
	return;
}

function NotifyGrenadeThrown(SwatGrenadeProjectile ThrownGrenade)
{
	if(AndAnd_BoolBool(Not_PreBool(ISwatAI(m_pawn).IsCompliant()), Not_PreBool(ISwatAI(m_pawn).IsArrested())))
	{
		if(AndAnd_BoolBool(NotEqual_ObjectObject(CurrentAvoidLocationGoal, none), CurrentAvoidLocationGoal.hasCompleted()))
		{
			CurrentAvoidLocationGoal.unPostGoal(self);
			CurrentAvoidLocationGoal.Release();
			CurrentAvoidLocationGoal = none;
		}
		if(EqualEqual_ObjectObject(CurrentAvoidLocationGoal, none))
		{
			if(AndAnd_BoolBool(WillReactToGrenadeBeingThrown(), m_pawn.CanSee(ThrownGrenade)))
			{
				CurrentAvoidLocationGoal = Class'SwatAICommon.AvoidLocationGoal'.static.Allocate(self).;
				construct_AI_ResourceVector(characterResource(), ThrownGrenade.Location);
				assert(NotEqual_ObjectObject(CurrentAvoidLocationGoal, none));
				CurrentAvoidLocationGoal.AddRef();
				CurrentAvoidLocationGoal.postGoal(self);
			}
		}
	}
	return;
}

function float GetCurrentMorale()
{
	return CurrentMorale;
	return;
}

function ChangeMorale(float inChangeAmount, string inReasonForChange, optional bool bDoNotStartListeningForCompliance)
{
	local MoraleHistoryEntry NewMoraleHistoryEntry;

	if(AndAnd_BoolBool(EqualEqual_ObjectObject(CurrentComplianceGoal, none), EqualEqual_ObjectObject(CurrentRestrainedGoal, none)))
	{
		if(NotEqual_FloatFloat(inChangeAmount, 0.0000000))
		{
			NewMoraleHistoryEntry.ChangeAmount = inChangeAmount;
			NewMoraleHistoryEntry.ReasonForChange = inReasonForChange;
			MoraleHistory[MoraleHistory.Length] = NewMoraleHistoryEntry;
			AddEqual_FloatFloat(CurrentMorale, inChangeAmount);
			CurrentMorale = FMin(CurrentMorale, MaxMorale);
			if(m_pawn.logAI)
			{
				Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("morale changed ", string(inChangeAmount)), " for "), string(m_pawn.Name)), " because "), inReasonForChange));
			}
			if(AndAnd_BoolBool(Less_FloatFloat(inChangeAmount, 0.0000000), Not_PreBool(bDoNotStartListeningForCompliance)))
			{
				bListeningForCompliance = true;
			}
		}
	}
	return;
}

function int GetMoraleHistoryCount()
{
	return MoraleHistory.Length;
	return;
}

function string GetMoraleHistoryEntrySummary(int Index)
{
	assert(GreaterEqual_IntInt(Index, 0));
	assert(Less_IntInt(Index, MoraleHistory.Length));
	return Concat_StrStr(Concat_StrStr(Concat_StrStr("Morale changed ", string(MoraleHistory[Index].ChangeAmount)), " because "), MoraleHistory[Index].ReasonForChange);
	return;
}

protected function RotateToFace(Actor Target, int BehaviorPriority)
{
	assert(NotEqual_ObjectObject(Target, none));
	if(NotEqual_ObjectObject(CurrentRotateTowardActorGoal, none))
	{
		CurrentRotateTowardActorGoal.unPostGoal(self);
		CurrentRotateTowardActorGoal.Release();
		CurrentRotateTowardActorGoal = none;
	}
	CurrentRotateTowardActorGoal = Class'SwatAICommon.RotateTowardActorGoal'.static.Allocate(self).;
	construct_AI_ResourceIntActor(movementResource(), BehaviorPriority, Target);
	assert(NotEqual_ObjectObject(CurrentRotateTowardActorGoal, none));
	CurrentRotateTowardActorGoal.AddRef();
	CurrentRotateTowardActorGoal.postGoal(self);
	return;
}

protected function RotateToRotation(Rotator Rotation, int BehaviorPriority)
{
	if(NotEqual_ObjectObject(CurrentRotateTowardRotationGoal, none))
	{
		CurrentRotateTowardRotationGoal.unPostGoal(self);
		CurrentRotateTowardRotationGoal.Release();
		CurrentRotateTowardRotationGoal = none;
	}
	CurrentRotateTowardRotationGoal = Class'SwatAICommon.RotateTowardRotationGoal'.static.Allocate(self).;
	Construct_AI_ResourceIntRotator(movementResource(), BehaviorPriority, Rotation);
	assert(NotEqual_ObjectObject(CurrentRotateTowardRotationGoal, none));
	CurrentRotateTowardRotationGoal.AddRef();
	CurrentRotateTowardRotationGoal.postGoal(self);
	return;
}

protected function AimAtTarget(Actor Target, int BehaviorPriority, bool bAimWeapon, optional float MinAimAtTargetTime, optional float MaxAimAtTargetTime)
{
	assert(NotEqual_ObjectObject(Target, none));
	if(NotEqual_ObjectObject(CurrentAimAtTargetGoal, none))
	{
		CurrentAimAtTargetGoal.unPostGoal(self);
		CurrentAimAtTargetGoal.Release();
		CurrentAimAtTargetGoal = none;
	}
	CurrentAimAtTargetGoal = Class'SwatAICommon.AimAtTargetGoal'.static.Allocate(self).;
	construct_AI_ResourceIntActor(weaponResource(), BehaviorPriority, Target);
	assert(NotEqual_ObjectObject(CurrentAimAtTargetGoal, none));
	CurrentAimAtTargetGoal.AddRef();
	if(AndAnd_BoolBool(Greater_FloatFloat(MinAimAtTargetTime, 0.0000000), Greater_FloatFloat(MaxAimAtTargetTime, 0.0000000)))
	{
		CurrentAimAtTargetGoal.SetHoldAimTime_FloatFloat(MinAimAtTargetTime, MaxAimAtTargetTime);
	}
	CurrentAimAtTargetGoal.SetAimOnlyWhenCanHitTarget(true);
	CurrentAimAtTargetGoal.SetAimWeapon(bAimWeapon);
	CurrentAimAtTargetGoal.postGoal(self);
	return;
}

function NotifyBlockingDoorClose(Door BlockedDoor)
{
	if(m_pawn.logAI)
	{
		Log(Concat_StrStr("NotifyBlockingDoorClose called for ", string(m_pawn)));
	}
	MoveMinimumDistanceAwayFromLocation(BlockedDoor.Location, Add_FloatFloat(BlockedDoor.CollisionRadius, Multiply_FloatFloat(m_pawn.CollisionRadius, 1.5000000)));
	return;
}

function NotifyBlockingDoorOpen(Door BlockedDoor)
{
	ISwatAI(m_pawn).GetSpeechManagerAction().TriggerHitByDoorSpeech();
	MoveMinimumDistanceAwayFromLocation(BlockedDoor.Location, Add_FloatFloat(BlockedDoor.CollisionRadius, Multiply_FloatFloat(m_pawn.CollisionRadius, 2.0000000)));
	return;
}

protected function bool CanMoveToActor()
{
	return OrOr_BoolBool(EqualEqual_ObjectObject(CurrentMoveToActorGoal, none), CurrentMoveToActorGoal.hasCompleted());
	return;
}

protected function bool MoveToActor(Actor Destination, int MovementBehaviorPriority, optional bool bZeroWalkThreshold)
{
	assert(NotEqual_ObjectObject(Destination, none));
	assert(Greater_IntInt(MovementBehaviorPriority, 0));
	if(m_pawn.logAI)
	{
		Log(Concat_StrStr("MoveToActor - CurrentMoveToActorGoal: ", string(CurrentMoveToActorGoal)));
	}
	if(NotEqual_ObjectObject(CurrentMoveToActorGoal, none))
	{
		if(CurrentMoveToActorGoal.hasCompleted())
		{
			CurrentMoveToActorGoal.unPostGoal(self);
			CurrentMoveToActorGoal.Release();
			CurrentMoveToActorGoal = none;
		}
	}
	if(EqualEqual_ObjectObject(CurrentMoveToActorGoal, none))
	{
		CurrentMoveToActorGoal = Class'SwatAICommon.MoveToActorGoal'.static.Allocate(self).;
		construct_AI_ResourceIntActor(movementResource(), MovementBehaviorPriority, Destination);
		assert(NotEqual_ObjectObject(CurrentMoveToActorGoal, none));
		CurrentMoveToActorGoal.AddRef();
		CurrentMoveToActorGoal.SetRotateTowardsPointsDuringMovement(true);
		if(bZeroWalkThreshold)
		{
			CurrentMoveToActorGoal.SetWalkThreshold(0.0000000);
		}
		if(m_pawn.logAI)
		{
			Log(Concat_StrStr(Concat_StrStr(string(m_pawn.Name), " going to move to: "), string(Destination)));
		}
		CurrentMoveToActorGoal.postGoal(self);
		return true;
	}
	return false;
	return;
}

protected function MoveMinimumDistanceAwayFromLocation(Vector Location, float MinimumDistance)
{
	local NavigationPoint ClosestPointToMoveTo;

	if(CanMoveToActor())
	{
		ClosestPointToMoveTo = SwatAIRepository(Level.AIRepo).GetClosestNavigationPointInRoom(m_pawn.GetRoomName(), Location, MinimumDistance);
		if(NotEqual_ObjectObject(ClosestPointToMoveTo, none))
		{
			MoveToActor(ClosestPointToMoveTo, 94);
		}
	}
	return;
}

function NotifyDoorWedged(Door WedgedDoor)
{
	ISwatPawn(m_pawn).SetDoorWedgedBelief(WedgedDoor, true);
	return;
}

function NotifyDoorLocked(Door LockedDoor)
{
	ISwatPawn(m_pawn).SetDoorLockedBelief(LockedDoor, true);
	return;
}

function NotifyDoorBlocked(Door LockedDoor)
{
	return;
}

function FindBetterEnemy()
{
	return;
}

event SetDebugMoraleHistoryInfo()
{
	local int i;

	m_pawn.AddDebugMessage(" ");
	i = 0;
	J0x19:

	if(Less_IntInt(i, GetMoraleHistoryCount()))
	{
		m_pawn.AddDebugMessage(GetMoraleHistoryEntrySummary(i), Class'Engine.Canvas'.static.MakeColor(byte(255), 220, byte(255)));
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x19;
	}
	m_pawn.AddDebugMessage(Concat_StrStr("Current Morale Value: ", string(GetCurrentMorale())), Class'Engine.Canvas'.static.MakeColor(220, byte(255), 220));
	return;
}

event SetDebugBlackboardInfo()
{
	m_pawn.AddDebugMessage(At_StrStr("Name:               ", string(m_pawn.Name)));
	m_pawn.AddDebugMessage(At_StrStr("Morale:             ", string(GetCurrentMorale())));
	m_pawn.AddDebugMessage(At_StrStr("Aggressive:         ", string(ISwatAI(m_pawn).IsAggressive())));
	m_pawn.AddDebugMessage(At_StrStr("Idle Category:      ", string(ISwatAI(m_pawn).GetIdleCategory())));
	SetSpecificDebugInfo();
	return;
}

function SetSpecificDebugInfo()
{
	return;
}

defaultproperties
{
	bListeningForCompliance=true
	satisfiesGoal=Class'SwatAICommon.CommanderGoal'
}