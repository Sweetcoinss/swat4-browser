class RestrainAndReportAction extends SwatCharacterAction
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) Pawn CompliantTarget;
var private MoveToActorGoal CurrentMoveToActorGoal;
var private RotateTowardRotationGoal CurrentRotateTowardRotationGoal;
var private HandheldEquipment Handcuffs;
var private ArrestedSensor TargetArrestedSensor;
var config float DistanceFromTargetToRestrain;

function cleanup()
{
	super(AI_CharacterAction).cleanup();
	if(NotEqual_ObjectObject(Handcuffs, none))
	{
		if(Handcuffs.IsBeingUsed())
		{
			IAmAQualifiedUseEquipment(Handcuffs).InstantInterrupt();
		}
		Handcuffs.AIInterrupt();
	}
	if(NotEqual_ObjectObject(CurrentMoveToActorGoal, none))
	{
		CurrentMoveToActorGoal.Release();
		CurrentMoveToActorGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentRotateTowardRotationGoal, none))
	{
		CurrentRotateTowardRotationGoal.Release();
		CurrentRotateTowardRotationGoal = none;
	}
	DeactivateArrestedSensor();
	ISwatAI(m_pawn).UnlockAim();
	m_pawn.EnableCollisionAvoidance();
	if(Class'Engine.Pawn'.static.checkConscious(CompliantTarget))
	{
		CompliantTarget.EnableCollisionAvoidance();
	}
	ISwatOfficer(m_pawn).InstantReEquipFiredWeapon();
	return;
}

function OnSensorMessage(AI_Sensor sensor, AI_SensorData Value, Object userData)
{
	if(m_pawn.logTyrion)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(Name), " received sensor message from "), string(sensor.Name)), " value is "), string(Value.objectData)));
	}
	assert(EqualEqual_ObjectObject(sensor, TargetArrestedSensor));
	if(AndAnd_BoolBool(EqualEqual_ObjectObject(Value.objectData, CompliantTarget), NotEqual_ObjectObject(ISwatAI(CompliantTarget).GetArrester(), m_pawn)))
	{
		instantSucceed();
	}
	return;
}

private function ActivateArrestedSensor()
{
	TargetArrestedSensor = ArrestedSensor(Class'Tyrion.AI_Sensor'.static.activateSensor(self, Class'SwatAICommon.ArrestedSensor', characterResource(), 0.0000000, 1000000.0000000));
	TargetArrestedSensor.setParameters(CompliantTarget);
	return;
}

private function DeactivateArrestedSensor()
{
	if(NotEqual_ObjectObject(TargetArrestedSensor, none))
	{
		TargetArrestedSensor.deactivateSensor(self);
		TargetArrestedSensor = none;
	}
	return;
}

function goalNotAchievedCB(AI_Goal Goal, AI_Action Child, ActionBase.ACT_ErrorCodes errorCode)
{
	super(AI_Action).goalNotAchievedCB(Goal, Child, errorCode);
	if(m_pawn.logTyrion)
	{
		Log(Concat_StrStr(string(Goal.Name), " was not achieved.  failing."));
	}
	if(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(CurrentMoveToActorGoal, none), EqualEqual_ObjectObject(Goal, CurrentMoveToActorGoal)), EqualEqual_IntInt(int(errorCode), int(4))))
	{
		ISwatOfficer(m_pawn).GetOfficerSpeechManagerAction().TriggerCouldntCompleteMoveSpeech();
	}
	instantFail(errorCode);
	return;
}

latent function MoveIntoPosition()
{
	CompliantTarget.DisableCollisionAvoidance();
	CurrentMoveToActorGoal = Class'SwatAICommon.MoveToActorGoal'.static.Allocate(self).;
	construct_AI_ResourceIntActor(movementResource(), achievingGoal.Priority, CompliantTarget);
	assert(NotEqual_ObjectObject(CurrentMoveToActorGoal, none));
	CurrentMoveToActorGoal.AddRef();
	CurrentMoveToActorGoal.SetRotateTowardsPointsDuringMovement(true);
	CurrentMoveToActorGoal.SetMoveToThreshold(Add_FloatFloat(CompliantTarget.CollisionRadius, DistanceFromTargetToRestrain));
	CurrentMoveToActorGoal.postGoal(self);
	waitForGoal(CurrentMoveToActorGoal);
	CurrentMoveToActorGoal.unPostGoal(self);
	CurrentMoveToActorGoal.Release();
	CurrentMoveToActorGoal = none;
	return;
}

latent function RotateTowardsTarget()
{
	local Rotator RotationToTarget;

	RotationToTarget = Rotator(Subtract_VectorVector(CompliantTarget.Location, m_pawn.Location));
	CurrentRotateTowardRotationGoal = Class'SwatAICommon.RotateTowardRotationGoal'.static.Allocate(self).;
	Construct_AI_ResourceIntRotator(movementResource(), achievingGoal.Priority, RotationToTarget);
	assert(NotEqual_ObjectObject(CurrentRotateTowardRotationGoal, none));
	CurrentRotateTowardRotationGoal.AddRef();
	CurrentRotateTowardRotationGoal.postGoal(self);
	waitForGoal(CurrentRotateTowardRotationGoal);
	CurrentRotateTowardRotationGoal.unPostGoal(self);
	CurrentRotateTowardRotationGoal.Release();
	CurrentRotateTowardRotationGoal = none;
	ISwatAI(m_pawn).AimToRotation(RotationToTarget);
	ISwatAI(m_pawn).LockAim();
	return;
}

latent function RestrainTarget()
{
	if(IAmUsedOnOther(Handcuffs).CanUseOnOtherNow(CompliantTarget))
	{
		Handcuffs.LatentWaitForIdleAndEquip();
		if(IAmUsedOnOther(Handcuffs).CanUseOnOtherNow(CompliantTarget))
		{
			TriggerReassuranceSpeech();
			IAmUsedOnOther(Handcuffs).LatentUseOn(CompliantTarget);
		}
		ISwatOfficer(m_pawn).ReEquipFiredWeapon();
		if(ISwatAI(CompliantTarget).IsArrested())
		{
			TriggerFinishedArrestSpeech();
		}
	}
	return;
}

private function TriggerReassuranceSpeech()
{
	if(CompliantTarget.IsA('SwatHostage'))
	{
		if(ISwatAI(CompliantTarget).IsAggressive())
		{
			ISwatOfficer(m_pawn).GetOfficerSpeechManagerAction().TriggerReassureAggressiveHostageSpeech();
		}
		else
		{
			ISwatOfficer(m_pawn).GetOfficerSpeechManagerAction().TriggerReassurePassiveHostageSpeech();
		}
	}
	return;
}

private function TriggerFinishedArrestSpeech()
{
	if(CompliantTarget.IsA('SwatEnemy'))
	{
		ISwatOfficer(m_pawn).GetOfficerSpeechManagerAction().TriggerArrestedSuspectSpeech();
	}
	ISwatOfficer(m_pawn).GetOfficerSpeechManagerAction().TriggerArrestedReportSpeech(CompliantTarget);
	return;
}

function TriggerTargetRestrainedSpeech()
{
	if(CompliantTarget.IsA('SwatEnemy'))
	{
		ISwatOfficer(m_pawn).GetOfficerSpeechManagerAction().TriggerReportedSuspectSecuredSpeech();
	}
	else
	{
		ISwatOfficer(m_pawn).GetOfficerSpeechManagerAction().TriggerReportedHostageSecuredSpeech();
	}
	return;
}

state Running
{Begin:

	if(resource.requiredResourcesAvailable(achievingGoal.Priority, achievingGoal.Priority))
	{
		ActivateArrestedSensor();
		useResources(Class'Tyrion.AI_Resource'.2);
		SwatAIRepository(Level.AIRepo).GetHive().NotifyOfficersOfTarget(CompliantTarget);
		Handcuffs = ISwatOfficer(m_pawn).GetItemAtSlot(11);
		assert(NotEqual_ObjectObject(Handcuffs, none));
		if(IAmUsedOnOther(Handcuffs).CanUseOnOtherNow(CompliantTarget))
		{
			MoveIntoPosition();
			m_pawn.DisableCollisionAvoidance();
			if(IAmUsedOnOther(Handcuffs).CanUseOnOtherNow(CompliantTarget))
			{
				RotateTowardsTarget();
				useResources(Class'Tyrion.AI_Resource'.4);
				RestrainTarget();
				TriggerTargetRestrainedSpeech();
				ISwatAI(m_pawn).UnlockAim();
			}
			CompliantTarget.EnableCollisionAvoidance();
			m_pawn.EnableCollisionAvoidance();
		}
	}
	succeed();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.RestrainAndReportGoal'
}