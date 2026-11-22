class ConverseWithHostagesAction extends SwatCharacterAction
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

var config float ConverseChance;
var config float SubsequentEnemyResponseChance;
var config float MinPlayerDistanceForConversation;
var config name EnemyTalkToHostageTriggerEffectEvent;
var config name HostageReplyToEnemyTriggerEffectEvent;
var config name EnemyReplyToHostageTriggerEffectEvent;
var config float MinSleepTimeBetweenSpeech;
var config float MaxSleepTimeBetweenSpeech;
var config float MinTimeBetweenConversing;
var config float MaxTimeBetweenConversing;
var private Pawn TargetHostage;
var private RotateTowardRotationGoal CurrentRotateTowardRotationGoal;

function cleanup()
{
	super(AI_CharacterAction).cleanup();
	if(NotEqual_ObjectObject(CurrentRotateTowardRotationGoal, none))
	{
		CurrentRotateTowardRotationGoal.Release();
		CurrentRotateTowardRotationGoal = none;
	}
	SwatAIRepository(Level.AIRepo).DeactivateEnemyHostageConversation(m_pawn);
	return;
}

private function bool FindTargetHostage()
{
	local Pawn Iter, ClosestTarget;
	local float IterDistance, ClosestDistance;

	Iter = Level.PawnList;
	J0x14:

	if(NotEqual_ObjectObject(Iter, none))
	{
		if(AndAnd_BoolBool(AndAnd_BoolBool(Class'Engine.Pawn'.static.checkConscious(Iter), Iter.IsA('SwatHostage')), Iter.IsInRoom(m_pawn.GetRoomName())))
		{
			if(OrOr_BoolBool(EqualEqual_ObjectObject(ClosestTarget, none), Less_FloatFloat(IterDistance, ClosestDistance)))
			{
				ClosestTarget = Iter;
				ClosestDistance = IterDistance;
			}
		}
		Iter = Iter.nextPawn;
		// [Loop Continue]
		goto J0x14;
	}
	TargetHostage = ClosestTarget;
	return NotEqual_ObjectObject(TargetHostage, none);
	return;
}

private function bool CanPlayerHearConversation(bool bUsePropogationDistance)
{
	local Pawn Player;
	local Controller Iter;

	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
	{
		Player = Level.GetLocalPlayerController().Pawn;
		if(Class'Engine.Pawn'.static.checkConscious(Player))
		{
			if(OrOr_BoolBool(AndAnd_BoolBool(Not_PreBool(bUsePropogationDistance), Less_FloatFloat(VSize(Subtract_VectorVector(m_pawn.Location, Player.Location)), MinPlayerDistanceForConversation)), AndAnd_BoolBool(bUsePropogationDistance, Less_FloatFloat(m_pawn.Controller.GetDistanceToSound(Player, m_pawn.Location, Player.Location), MinPlayerDistanceForConversation))))
			{
				return true;
			}
		}
	}
	else
	{
		assert(Level.IsCOOPServer);
		Iter = Level.ControllerList;
		J0x100:

		if(NotEqual_ObjectObject(Iter, none))
		{
			if(Iter.IsA('PlayerController'))
			{
				Player = Iter.Pawn;
				if(Class'Engine.Pawn'.static.checkConscious(Player))
				{
					if(OrOr_BoolBool(AndAnd_BoolBool(Not_PreBool(bUsePropogationDistance), Less_FloatFloat(VSize(Subtract_VectorVector(m_pawn.Location, Player.Location)), MinPlayerDistanceForConversation)), AndAnd_BoolBool(bUsePropogationDistance, Less_FloatFloat(m_pawn.Controller.GetDistanceToSound(Player, m_pawn.Location, Player.Location), MinPlayerDistanceForConversation))))
					{
						return true;
					}
				}
			}
			Iter = Iter.nextController;
			// [Loop Continue]
			goto J0x100;
		}
	}
	return false;
	return;
}

private function bool CanEnemiesConverseWithHostages()
{
	local ISwatEnemy.EnemyState CurrentEnemyState;

	if(Level.NoEnemyHostageConversations)
	{
		return false;
	}
	if(Not_PreBool(Level.Game.bPostGameStarted))
	{
		return false;
	}
	CurrentEnemyState = ISwatEnemy(m_pawn).GetCurrentState();
	if(Level.EnemiesAlwaysTalkToHostages)
	{
		return LessEqual_IntInt(int(CurrentEnemyState), int(1));
	}
	else
	{
		return EqualEqual_IntInt(int(CurrentEnemyState), int(0));
	}
	return;
}

function float selectionHeuristic(AI_Goal Goal)
{
	if(EqualEqual_ObjectObject(m_pawn, none))
	{
		m_pawn = AI_CharacterResource(Goal.resource).m_pawn;
		assert(NotEqual_ObjectObject(m_pawn, none));
	}
	assert(m_pawn.IsA('SwatEnemy'));
	if(EqualEqual_ObjectObject(Level, none))
	{
		Level = m_pawn.Level;
		assert(NotEqual_ObjectObject(Level, none));
	}
	if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(LessEqual_FloatFloat(FRand(), ConverseChance), CanEnemiesConverseWithHostages()), CanPlayerHearConversation(false)), FindTargetHostage()))
	{
		return 1.0000000;
	}
	else
	{
		return 0.0000000;
	}
	return;
}

private latent function RotateToFaceTarget()
{
	assert(NotEqual_ObjectObject(TargetHostage, none));
	CurrentRotateTowardRotationGoal = Class'SwatAICommon.RotateTowardRotationGoal'.static.Allocate(self).;
	Construct_AI_ResourceIntRotator(movementResource(), achievingGoal.Priority, Rotator(Subtract_VectorVector(TargetHostage.Location, m_pawn.Location)));
	assert(NotEqual_ObjectObject(CurrentRotateTowardRotationGoal, none));
	CurrentRotateTowardRotationGoal.AddRef();
	CurrentRotateTowardRotationGoal.postGoal(self);
	waitForGoal(CurrentRotateTowardRotationGoal);
	CurrentRotateTowardRotationGoal.unPostGoal(self);
	CurrentRotateTowardRotationGoal.Release();
	CurrentRotateTowardRotationGoal = none;
	return;
}

private latent function ConverseWithTarget()
{
	if(Less_FloatFloat(FRand(), 0.5000000))
	{
		ISwatAI(TargetHostage).LatentAITriggerEffectEvent(HostageReplyToEnemyTriggerEffectEvent,,,,,, true);
		Sleep(RandRange(MinSleepTimeBetweenSpeech, MaxSleepTimeBetweenSpeech));
		ISwatAI(m_pawn).LatentAITriggerEffectEvent(EnemyTalkToHostageTriggerEffectEvent,,,,,, true);
	}
	else
	{
		ISwatAI(m_pawn).LatentAITriggerEffectEvent(EnemyTalkToHostageTriggerEffectEvent,,,,,, true);
		Sleep(RandRange(MinSleepTimeBetweenSpeech, MaxSleepTimeBetweenSpeech));
		ISwatAI(TargetHostage).LatentAITriggerEffectEvent(HostageReplyToEnemyTriggerEffectEvent,,,,,, true);
		if(LessEqual_FloatFloat(FRand(), SubsequentEnemyResponseChance))
		{
			Sleep(RandRange(MinSleepTimeBetweenSpeech, MaxSleepTimeBetweenSpeech));
			ISwatAI(m_pawn).LatentAITriggerEffectEvent(EnemyReplyToHostageTriggerEffectEvent,,,,,, true);
			if(m_pawn.logAI)
			{
				Log(Concat_StrStr(Concat_StrStr(string(m_pawn.Name), " replied to hostage "), string(TargetHostage.Name)));
			}
		}
	}
	return;
}

state Running
{Begin:

	useResources(Class'Tyrion.AI_Resource'.2);
	RotateToFaceTarget();
	useResources(Class'Tyrion.AI_Resource'.4);
	if(AndAnd_BoolBool(CanPlayerHearConversation(true), Not_PreBool(SwatAIRepository(Level.AIRepo).IsEnemyHostageConversationActive())))
	{
		SwatAIRepository(Level.AIRepo).ActivateEnemyHostageConversation(m_pawn);
		ConverseWithTarget();
		SwatAIRepository(Level.AIRepo).DeactivateEnemyHostageConversation(m_pawn);
		instantSucceed();
	}
	else
	{
		Sleep(RandRange(MinTimeBetweenConversing, MaxTimeBetweenConversing));
		instantFail(1);
	}
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.ConverseWithHostagesGoal'
}