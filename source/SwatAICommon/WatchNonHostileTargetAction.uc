class WatchNonHostileTargetAction extends SwatCharacterAction
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

var private Pawn CurrentWatchTarget;
var private AimAtTargetGoal CurrentAimAtTargetGoal;
var private RotateTowardActorGoal CurrentRotateTowardActorGoal;
var config float MinWatchTargetTime;
var config float MaxWatchTargetTime;
var config float MinDistanceToAimGun;
var config float MinDeltaTimeBetweenSpeakingToTarget;
var config float MaxDeltaTimeBetweenSpeakingToTarget;
var private Pawn LastSpokenToWatchTarget;
var private float NextSpokenToWatchTargetTime;

function initAction(AI_Resource R, AI_Goal Goal)
{
	super.initAction(R, Goal);
	FindInitialWatchTarget();
	if(m_pawn.logTyrion)
	{
		Log(Concat_StrStr(Concat_StrStr(string(m_pawn.Name), " is going to watch CurrentWatchTarget: "), string(CurrentWatchTarget)));
	}
	return;
}

function cleanup()
{
	super(AI_CharacterAction).cleanup();
	if(NotEqual_ObjectObject(CurrentAimAtTargetGoal, none))
	{
		CurrentAimAtTargetGoal.Release();
		CurrentAimAtTargetGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentRotateTowardActorGoal, none))
	{
		CurrentRotateTowardActorGoal.Release();
		CurrentRotateTowardActorGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentWatchTarget, none))
	{
		SwatAIRepository(m_pawn.Level.AIRepo).GetHive().RemoveWatchedAI(CurrentWatchTarget);
	}
	return;
}

private function Pawn GetPotentialWatchTarget()
{
	local Pawn PotentialWatchTarget;

	PotentialWatchTarget = SwatAIRepository(m_pawn.Level.AIRepo).GetHive().FindTargetToWatchForOfficer(m_pawn);
	return PotentialWatchTarget;
	return;
}

private function FindInitialWatchTarget()
{
	CurrentWatchTarget = GetPotentialWatchTarget();
	if(NotEqual_ObjectObject(CurrentWatchTarget, none))
	{
		SwatAIRepository(m_pawn.Level.AIRepo).GetHive().AddWatchedAI(CurrentWatchTarget);
	}
	return;
}

private function bool FindNewWatchTarget()
{
	local Pawn OriginalWatchTarget;

	OriginalWatchTarget = CurrentWatchTarget;
	assert(NotEqual_ObjectObject(CurrentWatchTarget, none));
	SwatAIRepository(m_pawn.Level.AIRepo).GetHive().RemoveWatchedAI(CurrentWatchTarget);
	CurrentWatchTarget = GetPotentialWatchTarget();
	if(NotEqual_ObjectObject(CurrentWatchTarget, none))
	{
		SwatAIRepository(m_pawn.Level.AIRepo).GetHive().AddWatchedAI(CurrentWatchTarget);
	}
	return NotEqual_ObjectObject(OriginalWatchTarget, CurrentWatchTarget);
	return;
}

function float selectionHeuristic(AI_Goal Goal)
{
	local Pawn PotentialWatchTarget;

	if(EqualEqual_ObjectObject(m_pawn, none))
	{
		m_pawn = AI_CharacterResource(Goal.resource).m_pawn;
		assert(NotEqual_ObjectObject(m_pawn, none));
	}
	if(Not_PreBool(AI_Resource(m_pawn.CharacterAI).requiredResourcesAvailable(Goal.Priority, Goal.Priority, Goal.Priority)))
	{
		return 0.0000000;
	}
	PotentialWatchTarget = GetPotentialWatchTarget();
	if(NotEqual_ObjectObject(PotentialWatchTarget, none))
	{
		return 1.0000000;
	}
	else
	{
		return 0.0000000;
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
	instantFail(errorCode);
	return;
}

function AimAtWatchTarget()
{
	if(NotEqual_ObjectObject(CurrentAimAtTargetGoal, none))
	{
		CurrentAimAtTargetGoal.unPostGoal(self);
		CurrentAimAtTargetGoal.Release();
		CurrentAimAtTargetGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentRotateTowardActorGoal, none))
	{
		CurrentRotateTowardActorGoal.unPostGoal(self);
		CurrentRotateTowardActorGoal.Release();
		CurrentRotateTowardActorGoal = none;
	}
	if(Greater_FloatFloat(VSize2D(Subtract_VectorVector(m_pawn.Location, CurrentWatchTarget.Location)), MinDistanceToAimGun))
	{
		CurrentAimAtTargetGoal = Class'SwatAICommon.AimAtTargetGoal'.static.Allocate(self).;
		construct_AI_ResourceIntActor(weaponResource(), achievingGoal.Priority, CurrentWatchTarget);
		assert(NotEqual_ObjectObject(CurrentAimAtTargetGoal, none));
		CurrentAimAtTargetGoal.AddRef();
		CurrentAimAtTargetGoal.SetAimOnlyWhenCanHitTarget(true);
		CurrentAimAtTargetGoal.SetAimWeapon(true);
		CurrentAimAtTargetGoal.postGoal(self);
	}
	else
	{
		CurrentRotateTowardActorGoal = Class'SwatAICommon.RotateTowardActorGoal'.static.Allocate(self).;
		construct_AI_ResourceIntActor(movementResource(), achievingGoal.Priority, CurrentWatchTarget);
		assert(NotEqual_ObjectObject(CurrentRotateTowardActorGoal, none));
		CurrentRotateTowardActorGoal.AddRef();
		CurrentRotateTowardActorGoal.postGoal(self);
	}
	return;
}

private function SpeakToCompliantTarget()
{
	LastSpokenToWatchTarget = CurrentWatchTarget;
	NextSpokenToWatchTargetTime = Add_FloatFloat(Level.TimeSeconds, RandRange(MinDeltaTimeBetweenSpeakingToTarget, MaxDeltaTimeBetweenSpeakingToTarget));
	ISwatOfficer(m_pawn).GetOfficerSpeechManagerAction().TriggerCoveringTargetSpeech();
	return;
}

state Running
{Begin:

	if(Not_PreBool(Class'Engine.Pawn'.static.checkConscious(CurrentWatchTarget)))
	{
		fail(1);
	}
	AimAtWatchTarget();
	if(AndAnd_BoolBool(NotEqual_ObjectObject(CurrentAimAtTargetGoal, none), EqualEqual_ObjectObject(DummyMovementGoal, none)))
	{
		useResources(Class'Tyrion.AI_Resource'.4);
	}
	else
	{
		if(AndAnd_BoolBool(NotEqual_ObjectObject(CurrentRotateTowardActorGoal, none), EqualEqual_ObjectObject(DummyWeaponGoal, none)))
		{
			useResources(Class'Tyrion.AI_Resource'.2);
		}
	}
	J0x7C:

	Sleep(RandRange(MinWatchTargetTime, MaxWatchTargetTime));
	if(AndAnd_BoolBool(CurrentWatchTarget.IsCompliant(), OrOr_BoolBool(NotEqual_ObjectObject(LastSpokenToWatchTarget, CurrentWatchTarget), GreaterEqual_FloatFloat(Level.TimeSeconds, NextSpokenToWatchTargetTime))))
	{
		SpeakToCompliantTarget();
	}
	if(FindNewWatchTarget())
	{
		goto 'Begin';
	}
	else
	{
		goto 'Wait';
	}
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.WatchNonHostileTargetGoal'
}