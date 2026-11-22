class StunnedAction extends SwatCharacterAction
	abstract
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

const kRunFromStunningDeviceMinDistSq = 40000.0;
const kRunFromStunningDeviceMaxDistSq = 640000.0;
const kRunFromStunningDevicePriority = 90;

var private MoveToActorGoal CurrentMoveToActorGoal;
var private float MoralePenalty;
var private float StartTime;
var private float EndTime;
var private bool bRecovering;
var private bool bPlayedAnimation;
var(Parameters) Vector StunningDeviceLocation;
var(Parameters) float StunnedDuration;
var(Parameters) bool bShouldRunFromStunningDevice;
var(Parameters) bool bPlayedReaction;

function initAction(AI_Resource R, AI_Goal Goal)
{
	super.initAction(R, Goal);
	DisableSenses();
	StartTime = Level.TimeSeconds;
	EndTime = Add_FloatFloat(StartTime, StunnedDuration);
	AffectMorale();
	if(m_pawn.IsA('SwatEnemy'))
	{
		SwatAIRepository(m_pawn.Level.AIRepo).GetHive().NotifyEnemyStunned(m_pawn);
	}
	return;
}

protected function float GetMoraleModificationAmount()
{
	assert(false);
	return 0.0000000;
	return;
}

private function AffectMorale()
{
	local float MoraleModification;

	MoraleModification = GetMoraleModificationAmount();
	AddEqual_FloatFloat(MoralePenalty, MoraleModification);
	ISwatAI(m_pawn).GetCommanderAction().ChangeMorale(Subtract_PreFloat(MoraleModification), achievingGoal.goalName);
	return;
}

private function ReturnMorale()
{
	if(Class'Engine.Pawn'.static.checkConscious(m_pawn))
	{
		ISwatAI(m_pawn).GetCommanderAction().ChangeMorale(MoralePenalty, Concat_StrStr(achievingGoal.goalName, " Ended"));
	}
	return;
}

function cleanup()
{
	super(AI_CharacterAction).cleanup();
	ISwatAI(m_pawn).UnlockAim();
	ISwatAI(m_pawn).UnsetUpperBodyAnimBehavior(11);
	ReturnMorale();
	EnableSenses();
	if(NotEqual_ObjectObject(CurrentMoveToActorGoal, none))
	{
		CurrentMoveToActorGoal.Release();
		CurrentMoveToActorGoal = none;
	}
	UnTriggerStunnedSpeech();
	m_pawn.EnableCollisionAvoidance();
	if(bPlayedAnimation)
	{
		ISwatAI(m_pawn).AnimStopSpecial();
	}
	return;
}

function bool ShouldAffectMoraleAgain()
{
	assert(false);
	return false;
	return;
}

protected function AddAdditionalStunnedTime(float AdditionalStunnedTime)
{
	assert(false);
	return;
}

function ExtendBeingStunned(float AdditionalStunnedTime)
{
	if(ShouldAffectMoraleAgain())
	{
		AffectMorale();
	}
	AddAdditionalStunnedTime(AdditionalStunnedTime);
	if(m_pawn.logAI)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("AdditionalStunnedTime is: ", string(AdditionalStunnedTime)), " EndTime is now: "), string(EndTime)), " Level.TimeSeconds: "), string(Level.TimeSeconds)), " bRecovering: "), string(bRecovering)));
	}
	if(ShouldReTriggerStunnedSpeech())
	{
		TriggerStunnedSpeech();
	}
	if(bRecovering)
	{
		bRecovering = false;
		GotoState('Running', 'Begin');
	}
	return;
}

function goalNotAchievedCB(AI_Goal Goal, AI_Action Child, ActionBase.ACT_ErrorCodes errorCode)
{
	super(AI_Action).goalNotAchievedCB(Goal, Child, errorCode);
	if(m_pawn.logTyrion)
	{
		Log(Concat_StrStr(string(Goal.Name), " was not achieved.  waiting to achieve."));
	}
	if(NotEqual_ObjectObject(CurrentMoveToActorGoal, none))
	{
		CurrentMoveToActorGoal.unPostGoal(self);
		CurrentMoveToActorGoal.Release();
		CurrentMoveToActorGoal = none;
	}
	bShouldRunFromStunningDevice = false;
	StunnedGoal(achievingGoal).bShouldRunFromStunningDevice = false;
	GotoState('Running', 'WaitToAchieve');
	return;
}

function TriggerStunnedSpeech()
{
	return;
}

protected function UnTriggerStunnedSpeech()
{
	return;
}

function NavigationPoint FindRunToPoint()
{
	local int i;
	local array<AwarenessKnowledge> PotentiallyVisibleSet;
	local AwarenessKnowledge Knowledge;
	local NavigationPoint NavigationPoint;
	local Vector DirectionToStunningDevice, DirectionToNavigationPoint;
	local float DistSq, Weight;
	local NavigationPoint BestRunToPoint;
	local float BestRunToPointWeight;

	DirectionToStunningDevice = Subtract_VectorVector(StunningDeviceLocation, m_pawn.Location);
	PotentiallyVisibleSet = ISwatAI(m_pawn).GetAwareness().GetPotentiallyVisibleKnowledge(m_pawn);
	i = 0;
	J0x4B:

	if(Less_IntInt(i, PotentiallyVisibleSet.Length))
	{
		Knowledge = PotentiallyVisibleSet[i];
		NavigationPoint = Knowledge.aboutAwarenessPoint.GetClosestNavigationPoint();
		if(AndAnd_BoolBool(NotEqual_ObjectObject(NavigationPoint, none), Not_PreBool(NavigationPoint.IsA('Door'))))
		{
			DistSq = VDistSquared(m_pawn.Location, NavigationPoint.Location);
			if(AndAnd_BoolBool(GreaterEqual_FloatFloat(DistSq, 40000.0000000), LessEqual_FloatFloat(DistSq, 640000.0000000)))
			{
				DirectionToNavigationPoint = Subtract_VectorVector(NavigationPoint.Location, m_pawn.Location);
				if(Less_FloatFloat(Dot_VectorVector(DirectionToNavigationPoint, DirectionToStunningDevice), 0.0000000))
				{
					Weight = Subtract_FloatFloat(Knowledge.Confidence, Multiply_FloatFloat(Knowledge.threat, 2.0000000));
					if(AndAnd_BoolBool(Greater_FloatFloat(Weight, 0.0000000), OrOr_BoolBool(EqualEqual_ObjectObject(BestRunToPoint, none), Greater_FloatFloat(Weight, BestRunToPointWeight))))
					{
						BestRunToPoint = NavigationPoint;
						BestRunToPointWeight = Weight;
					}
				}
			}
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x4B;
	}
	return BestRunToPoint;
	return;
}

latent function RunFromStunningDevice()
{
	local NavigationPoint RunToPoint;

	if(AndAnd_BoolBool(AndAnd_BoolBool(bShouldRunFromStunningDevice, Not_PreBool(ISwatAI(m_pawn).IsCompliant())), Not_PreBool(ISwatAI(m_pawn).IsArrested())))
	{
		RunToPoint = FindRunToPoint();
		if(NotEqual_ObjectObject(RunToPoint, none))
		{
			clearDummyMovementGoal();
			ISwatAI(m_pawn).UnlockAim();
			CurrentMoveToActorGoal = Class'SwatAICommon.MoveToActorGoal'.static.Allocate(self).;
			construct_AI_ResourceIntActor(movementResource(), 90, FindRunToPoint());
			assert(NotEqual_ObjectObject(CurrentMoveToActorGoal, none));
			CurrentMoveToActorGoal.AddRef();
			CurrentMoveToActorGoal.SetAcceptNearbyPath(true);
			CurrentMoveToActorGoal.SetRotateTowardsFirstPoint(true);
			CurrentMoveToActorGoal.SetRotateTowardsPointsDuringMovement(true);
			CurrentMoveToActorGoal.SetMoveToThreshold(8.0000000);
			CurrentMoveToActorGoal.SetWalkThreshold(0.0000000);
			CurrentMoveToActorGoal.postGoal(self);
			waitForGoal(CurrentMoveToActorGoal);
			if(NotEqual_ObjectObject(CurrentMoveToActorGoal, none))
			{
				CurrentMoveToActorGoal.unPostGoal(self);
				CurrentMoveToActorGoal.Release();
				CurrentMoveToActorGoal = none;
			}
			ISwatAI(m_pawn).AimToRotation(m_pawn.Rotation);
			ISwatAI(m_pawn).LockAim();
			useResources(Class'Tyrion.AI_Resource'.4);
		}
	}
	return;
}

function name GetReactionAnimation()
{
	assert(false);
	return 'None';
	return;
}

latent function PlayReactionAnimation()
{
	local int AnimSpecialChannel;

	bPlayedAnimation = true;
	AnimSpecialChannel = m_pawn.AnimPlaySpecial(GetReactionAnimation(), 0.1000000);
	m_pawn.FinishAnim(AnimSpecialChannel);
	bPlayedAnimation = false;
	return;
}

function name GetAffectedAnimation()
{
	assert(false);
	return 'None';
	return;
}

latent function PlayAffectedAnimation()
{
	local int AnimSpecialChannel;

	bPlayedAnimation = true;
	AnimSpecialChannel = m_pawn.AnimLoopSpecial(GetAffectedAnimation(), 0.1000000);
	J0x28:

	if(Less_FloatFloat(Level.TimeSeconds, EndTime))
	{
		yield();
		// [Loop Continue]
		goto J0x28;
	}
	m_pawn.FinishAnim(AnimSpecialChannel);
	bPlayedAnimation = false;
	return;
}

function name GetRecoveryAnimation()
{
	assert(false);
	return 'None';
	return;
}

latent function PlayRecoveryAnimation()
{
	local int AnimSpecialChannel;

	bPlayedAnimation = true;
	bRecovering = true;
	AnimSpecialChannel = m_pawn.AnimPlaySpecial(GetRecoveryAnimation(), 0.1000000);
	m_pawn.FinishAnim(AnimSpecialChannel);
	bPlayedAnimation = false;
	return;
}

private function SetPlayedReaction(bool inPlayedReaction)
{
	StunnedGoal(achievingGoal).bPlayedReaction = inPlayedReaction;
	bPlayedReaction = inPlayedReaction;
	return;
}

protected function bool ShouldDelayReaction()
{
	return Not_PreBool(bPlayedReaction);
	return;
}

protected function bool ShouldTriggerStunnedSpeech()
{
	return true;
	return;
}

protected function bool ShouldReTriggerStunnedSpeech()
{
	return true;
	return;
}

protected latent function NotifyFinishedAffectedAnimation()
{
	return;
}

state Running
{Begin:

	if(Not_PreBool(resource.requiredResourcesAvailable(achievingGoal.Priority, achievingGoal.Priority)))
	{
		goto 'WaitToAchieve';
	}
	ISwatAI(m_pawn).UnlockAim();
	ISwatAI(m_pawn).AimToRotation(m_pawn.Rotation);
	ISwatAI(m_pawn).LockAim();
	useResources(Or_IntInt(Class'Tyrion.AI_Resource'.2, Class'Tyrion.AI_Resource'.4));
	if(ShouldDelayReaction())
	{
		SleepInitialDelayTime(false);
	}
	ISwatAI(m_pawn).SetUpperBodyAnimBehavior(0, 11);
	if(ShouldTriggerStunnedSpeech())
	{
		TriggerStunnedSpeech();
	}
	m_pawn.ChangeAnimation();
	if(Not_PreBool(bPlayedReaction))
	{
		SetPlayedReaction(true);
		m_pawn.DisableCollisionAvoidance();
		PlayReactionAnimation();
		m_pawn.EnableCollisionAvoidance();
		RunFromStunningDevice();
	}
	m_pawn.DisableCollisionAvoidance();
	PlayAffectedAnimation();
	NotifyFinishedAffectedAnimation();
	PlayRecoveryAnimation();
	m_pawn.EnableCollisionAvoidance();
	m_pawn.ChangeAnimation();
	succeed();
WaitToAchieve:

	if(bPlayedAnimation)
	{
		ISwatAI(m_pawn).AnimStopSpecial();
	}
	clearDummyGoals();
	J0x188:

	if(AndAnd_BoolBool(Less_FloatFloat(Level.TimeSeconds, EndTime), Not_PreBool(resource.requiredResourcesAvailable(achievingGoal.Priority, achievingGoal.Priority))))
	{
		yield();
		// [Loop Continue]
		goto J0x188;
	}
	if(GreaterEqual_FloatFloat(Level.TimeSeconds, EndTime))
	{
		succeed();
	}
	else
	{
		yield();
		goto 'Begin';
	}
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.StunnedGoal'
}