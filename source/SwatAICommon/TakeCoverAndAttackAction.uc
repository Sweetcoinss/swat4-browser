class TakeCoverAndAttackAction extends TakeCoverAction
	native
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

const kMoveTowardMinTime = 1.0;
const kMoveTowardMaxTime = 2.0;

var private AttackTargetGoal CurrentAttackTargetGoal;
var private RotateTowardRotationGoal CurrentRotateTowardRotationGoal;
var private MoveToOpponentGoal CurrentMoveToOpponentGoal;
var private AimAroundGoal CurrentAimAroundGoal;
var private config float LowSkillAttackWhileTakingCoverChance;
var private config float MediumSkillAttackWhileTakingCoverChance;
var private config float HighSkillAttackWhileTakingCoverChance;
var private config float MinCrouchTime;
var private config float MaxCrouchTime;
var private config float MinStandTime;
var private config float MaxStandTime;
var private config float MinLeanTime;
var private config float MaxLeanTime;
var private config float MinPassiveTakeCoverAndAttackPercentageChance;
var private config float MaxPassiveTakeCoverAndAttackPercentageChance;
var private config float MinAggressiveTakeCoverAndAttackPercentageChance;
var private config float MaxAggressiveTakeCoverAndAttackPercentageChance;
var private config float LowSkillSuccessAfterFiringChance;
var private config float MediumSkillSuccessAfterFiringChance;
var private config float HighSkillSuccessAfterFiringChance;
var private Rotator AttackRotation;
var private Pawn.ELeanState AttackLeanState;
var private AICoverFinder.EAICoverLocationType AttackCoverLocationType;
var array<Pawn> CachedSeenPawns;
var private DistanceToOfficersSensor DistanceToOfficersSensor;
var private config float MinDistanceToOfficersWhileTakingCover;
var private float MoveBrieflyChance;
var private config float MoveBrieflyChanceIncrement;
var private config float AimAroundInnerFovDegrees;
var private config float AimAroundOuterFovDegrees;
var private config float AimAroundMinAimTime;
var private config float AimAroundMaxAimTime;

private function bool CanTakeCoverAndAttack()
{
	local Hive HiveMind;

	HiveMind = SwatAIRepository(m_pawn.Level.AIRepo).GetHive();
	assert(NotEqual_ObjectObject(HiveMind, none));
	assert(NotEqual_ObjectObject(m_pawn, none));
	return AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(ISwatAI(m_pawn).HasUsableWeapon(), AICoverFinder.IsCoverAvailable()), Not_PreBool(HiveMind.IsPawnWithinDistanceOfOfficers(m_pawn, MinDistanceToOfficersWhileTakingCover, true))), FindBestCoverToAttackFrom()), Not_PreBool(CoverIsInBadPosition()));
	return;
}

private function bool CoverIsInBadPosition()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, CachedSeenPawns.Length))
	{
		if(Less_FloatFloat(VSize(Subtract_VectorVector(CoverResult.coverLocation, CachedSeenPawns[i].Location)), MinDistanceToOfficersWhileTakingCover))
		{
			return true;
		}
		if(Less_FloatFloat(Dot_VectorVector(Normal(Subtract_VectorVector(m_pawn.Location, CachedSeenPawns[i].Location)), Normal(Subtract_VectorVector(CoverResult.coverLocation, CachedSeenPawns[i].Location))), 0.0000000))
		{
			return true;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
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
	assert(m_pawn.IsA('SwatEnemy'));
	AICoverFinder = ISwatAI(m_pawn).GetCoverFinder();
	assert(NotEqual_ObjectObject(AICoverFinder, none));
	if(CanTakeCoverAndAttack())
	{
		if(ISwatAI(m_pawn).IsAggressive())
		{
			return FClamp(FRand(), MinAggressiveTakeCoverAndAttackPercentageChance, MaxAggressiveTakeCoverAndAttackPercentageChance);
		}
		else
		{
			return FClamp(FRand(), MinPassiveTakeCoverAndAttackPercentageChance, MaxPassiveTakeCoverAndAttackPercentageChance);
		}
	}
	else
	{
		return 0.0000000;
	}
	return;
}

function cleanup()
{
	super.cleanup();
	if(NotEqual_ObjectObject(CurrentAttackTargetGoal, none))
	{
		CurrentAttackTargetGoal.Release();
		CurrentAttackTargetGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentRotateTowardRotationGoal, none))
	{
		CurrentRotateTowardRotationGoal.Release();
		CurrentRotateTowardRotationGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentMoveToOpponentGoal, none))
	{
		CurrentMoveToOpponentGoal.Release();
		CurrentMoveToOpponentGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentAimAroundGoal, none))
	{
		CurrentAimAroundGoal.Release();
		CurrentAimAroundGoal = none;
	}
	if(NotEqual_ObjectObject(DistanceToOfficersSensor, none))
	{
		DistanceToOfficersSensor.deactivateSensor(self);
		DistanceToOfficersSensor = none;
	}
	StopLeaning();
	return;
}

function goalNotAchievedCB(AI_Goal Goal, AI_Action Child, ActionBase.ACT_ErrorCodes errorCode)
{
	super(AI_Action).goalNotAchievedCB(Goal, Child, errorCode);
	instantFail(errorCode);
	return;
}

function goalAchievedCB(AI_Goal Goal, AI_Action Action)
{
	super(AI_Action).goalAchievedCB(Goal, Action);
	if(EqualEqual_ObjectObject(Goal, CurrentAttackTargetGoal))
	{
		instantSucceed();
	}
	return;
}

function OnSensorMessage(AI_Sensor sensor, AI_SensorData Value, Object userData)
{
	if(m_pawn.logTyrion)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("TakeCoverAndAttackAction received sensor message from ", string(sensor.Name)), " value is "), string(Value.integerData)));
	}
	assert(EqualEqual_ObjectObject(sensor, DistanceToOfficersSensor));
	if(EqualEqual_IntInt(Value.integerData, 1))
	{
		if(m_pawn.logTyrion)
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(m_pawn.Name), " is too close while "), string(Name)), " taking cover.  failing!"));
		}
		instantFail(17);
	}
	return;
}

function float GetSkillSpecificSuccessAfterFiringChance()
{
	local ISwatEnemy.EnemySkill CurrentEnemySkill;

	CurrentEnemySkill = ISwatEnemy(m_pawn).GetEnemySkill();
	switch(CurrentEnemySkill)
	{
		case 0:
			return LowSkillSuccessAfterFiringChance;
		case 1:
			return MediumSkillSuccessAfterFiringChance;
		case 2:
			return HighSkillSuccessAfterFiringChance;
		default:
			assert(false);
			return 0.0000000;
			break;
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
			return LowSkillAttackWhileTakingCoverChance;
		case 1:
			return MediumSkillAttackWhileTakingCoverChance;
		case 2:
			return HighSkillAttackWhileTakingCoverChance;
		default:
			assert(false);
			return 0.0000000;
			break;
	}
	return;
}

function bool ShouldAttackWhileTakingCover()
{
	assert(ISwatAI(m_pawn).HasUsableWeapon());
	return Less_FloatFloat(FRand(), GetSkillSpecificAttackChance());
	return;
}

private function Pawn GetEnemy()
{
	return ISwatEnemy(m_pawn).GetEnemyCommanderAction().GetCurrentEnemy();
	return;
}

private function StopAttacking()
{
	if(NotEqual_ObjectObject(CurrentAttackTargetGoal, none))
	{
		CurrentAttackTargetGoal.unPostGoal(self);
		CurrentAttackTargetGoal.Release();
		CurrentAttackTargetGoal = none;
	}
	return;
}

private function Attack(Pawn Enemy, bool bCanSucceedAfterFiring)
{
	assert(NotEqual_ObjectObject(Enemy, none));
	if(EqualEqual_ObjectObject(CurrentAttackTargetGoal, none))
	{
		CurrentAttackTargetGoal = Class'SwatAICommon.AttackTargetGoal'.static.Allocate(self).;
		construct_AI_ResourceActor(weaponResource(), Enemy);
		assert(NotEqual_ObjectObject(CurrentAttackTargetGoal, none));
		CurrentAttackTargetGoal.AddRef();
		if(bCanSucceedAfterFiring)
		{
			CurrentAttackTargetGoal.SetChanceToSucceedAfterFiring(GetSkillSpecificSuccessAfterFiringChance());
		}
		CurrentAttackTargetGoal.postGoal(self);
	}
	return;
}

private function bool IsRotatedToAttackRotation()
{
	return EqualEqual_IntInt(m_pawn.Rotation.Yaw, AttackRotation.Yaw);
	return;
}

private latent function RotateToAttackRotation(Pawn Enemy)
{
	assert(EqualEqual_ObjectObject(CurrentRotateTowardRotationGoal, none));
	if(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(Enemy, none), Not_PreBool(IsRotatedToAttackRotation())), Not_PreBool(m_pawn.CanHit(Enemy))))
	{
		CurrentRotateTowardRotationGoal = Class'SwatAICommon.RotateTowardRotationGoal'.static.Allocate(self).;
		Construct_AI_ResourceIntRotator(movementResource(), achievingGoal.Priority, AttackRotation);
		assert(NotEqual_ObjectObject(CurrentRotateTowardRotationGoal, none));
		CurrentRotateTowardRotationGoal.AddRef();
		CurrentRotateTowardRotationGoal.postGoal(self);
		waitForGoal(CurrentRotateTowardRotationGoal);
		CurrentRotateTowardRotationGoal.unPostGoal(self);
		CurrentRotateTowardRotationGoal.Release();
		CurrentRotateTowardRotationGoal = none;
	}
	return;
}

private function bool CanLeanAtCoverResult()
{
	AssertWithDescription(EqualEqual_IntInt(int(CoverResult.coverLocationInfo), int(2)), Concat_StrStr("TakeCoverAndAttackAction::CanLeanAtCoverResult - expected coverLocationInfo to be kAICLI_InCover, got ", string(CoverResult.coverLocationInfo)));
	assert(NotEqual_IntInt(int(CoverResult.coverSide), int(0)));
	if(EqualEqual_IntInt(int(CoverResult.coverSide), int(1)))
	{
		AttackLeanState = 1;
	}
	else
	{
		AttackLeanState = 2;
	}
	return m_pawn.CanLean(AttackLeanState, CoverResult.coverLocation, AttackRotation);
	return;
}

private function bool CanUseCover()
{
	if(AndAnd_BoolBool(NotEqual_ObjectObject(CoverResult.coverActor, none), OrOr_BoolBool(EqualEqual_IntInt(int(CoverResult.coverLocationInfo), int(1)), AndAnd_BoolBool(EqualEqual_IntInt(int(CoverResult.coverLocationInfo), int(2)), CanLeanAtCoverResult()))))
	{
		return true;
	}
	else
	{
		return false;
	}
	return;
}

protected function bool FindBestCoverToAttackFrom()
{
	m_tookCover = false;
	assert(NotEqual_ObjectObject(m_pawn, none));
	assert(NotEqual_ObjectObject(SwatCharacterResource(m_pawn.CharacterAI).CommonSensorAction, none));
	assert(NotEqual_ObjectObject(SwatCharacterResource(m_pawn.CharacterAI).CommonSensorAction.GetVisionSensor(), none));
	CachedSeenPawns = SwatCharacterResource(m_pawn.CharacterAI).CommonSensorAction.GetVisionSensor().pawns;
	AttackCoverLocationType = 1;
	CoverResult = AICoverFinder.FindCover(CachedSeenPawns, AttackCoverLocationType);
	if(m_pawn.logAI)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("CoverResult.coverLocationInfo is: ", string(CoverResult.coverLocationInfo)), "  CoverResult.coverActor is: "), string(CoverResult.coverActor)));
	}
	if(EqualEqual_ObjectObject(CoverResult.coverActor, none))
	{
		return false;
	}
	if(Not_PreBool(CanUseCover()))
	{
		AttackCoverLocationType = 2;
		CoverResult = AICoverFinder.FindCoverBehindActor(CachedSeenPawns, CoverResult.coverActor, AttackCoverLocationType);
		if(EqualEqual_ObjectObject(CoverResult.coverActor, none))
		{
			return false;
		}
		if(Not_PreBool(CanUseCover()))
		{
			AttackCoverLocationType = 3;
			CoverResult = AICoverFinder.FindCoverBehindActor(CachedSeenPawns, CoverResult.coverActor, AttackCoverLocationType);
			return CanUseCover();
		}
		else
		{
			return true;
		}
	}
	return true;
	return;
}

protected latent function TakeCoverAtInitialCoverLocation()
{
	m_tookCover = false;
	assert(NotEqual_ObjectObject(m_pawn, none));
	assert(NotEqual_IntInt(int(CoverResult.coverLocationInfo), int(0)));
	TakeCover();
	return;
}

protected latent function TakeCover()
{
	if(ShouldAttackWhileTakingCover())
	{
		Attack(GetEnemy(), false);
	}
	else
	{
		SwapInFullBodyTakeCoverAnimations();
	}
	MoveToTakeCover(CoverResult.coverLocation);
	StopAttacking();
	ResetFullBodyAnimations();
	if(EqualEqual_IntInt(int(CoverResult.coverLocationInfo), int(1)))
	{
		m_pawn.ShouldCrouch(true);
	}
	m_tookCover = true;
	return;
}

private latent function MoveTowardEnemyBriefly(Pawn Enemy)
{
	CurrentMoveToOpponentGoal = Class'SwatAICommon.MoveToOpponentGoal'.static.Allocate(self).;
	construct_AI_ResourceIntActor(movementResource(), achievingGoal.Priority, Enemy);
	assert(NotEqual_ObjectObject(CurrentMoveToOpponentGoal, none));
	CurrentMoveToOpponentGoal.AddRef();
	CurrentMoveToOpponentGoal.SetAcceptNearbyPath(true);
	CurrentMoveToOpponentGoal.SetShouldCrouch(true);
	CurrentMoveToOpponentGoal.SetUseCoveredPaths();
	CurrentMoveToOpponentGoal.postGoal(self);
	Sleep(RandRange(1.0000000, 2.0000000));
	CurrentMoveToOpponentGoal.unPostGoal(self);
	CurrentMoveToOpponentGoal.Release();
	CurrentMoveToOpponentGoal = none;
	return;
}

private latent function AimAroundBriefly()
{
	CurrentAimAroundGoal = Class'SwatAICommon.AimAroundGoal'.static.Allocate(self).;
	construct_AI_ResourceInt(weaponResource(), Subtract_IntInt(CurrentAttackTargetGoal.Priority, 1));
	assert(NotEqual_ObjectObject(CurrentAimAroundGoal, none));
	CurrentAimAroundGoal.AddRef();
	CurrentAimAroundGoal.SetAimWeapon(true);
	CurrentAimAroundGoal.SetAimInnerFovDegrees(AimAroundInnerFovDegrees);
	CurrentAimAroundGoal.SetAimOuterFovDegrees(AimAroundOuterFovDegrees);
	CurrentAimAroundGoal.SetAimAtPointTime(AimAroundMinAimTime, AimAroundMaxAimTime);
	CurrentAimAroundGoal.SetDoOnce(true);
	CurrentAimAroundGoal.postGoal(self);
	waitForGoal(CurrentAimAroundGoal);
	CurrentAimAroundGoal.unPostGoal(self);
	CurrentAimAroundGoal.Release();
	CurrentAimAroundGoal = none;
	return;
}

private latent function AttackWhileCrouchingBehindCover(Pawn Enemy)
{
	if(Not_PreBool(m_pawn.CanHit(Enemy)))
	{
		m_pawn.ShouldCrouch(false);
		Sleep(RandRange(MinStandTime, MaxStandTime));
		if(Not_PreBool(m_pawn.CanHit(Enemy)))
		{
			if(Greater_FloatFloat(FRand(), MoveBrieflyChance))
			{
				AimAroundBriefly();
				AddEqual_FloatFloat(MoveBrieflyChance, MoveBrieflyChanceIncrement);
			}
			else
			{
				MoveTowardEnemyBriefly(Enemy);
			}
		}
		m_pawn.ShouldCrouch(true);
		Sleep(RandRange(MinCrouchTime, MaxCrouchTime));
	}
	return;
}

private function Lean()
{
	if(EqualEqual_IntInt(int(AttackLeanState), int(1)))
	{
		m_pawn.ShouldLeanRight(false);
		m_pawn.ShouldLeanLeft(true);
	}
	else
	{
		m_pawn.ShouldLeanLeft(false);
		m_pawn.ShouldLeanRight(true);
	}
	return;
}

private function StopLeaning()
{
	m_pawn.ShouldLeanLeft(false);
	m_pawn.ShouldLeanRight(false);
	return;
}

private latent function ReEvaluateCover()
{
	if(FindBestCoverToAttackFrom())
	{
		TakeCover();
	}
	else
	{
		fail(12);
	}
	return;
}

private latent function AttackWhileLeaningBehindCover(Pawn Enemy)
{
	local bool bReEvaluateCover;

	if(Not_PreBool(m_pawn.CanHit(Enemy)))
	{
		Lean();
		Sleep(RandRange(MinLeanTime, MaxLeanTime));
		if(Not_PreBool(m_pawn.CanHit(Enemy)))
		{
			if(m_pawn.logAI)
			{
				Log("re evaluate cover");
			}
			bReEvaluateCover = true;
		}
		StopLeaning();
		if(Not_PreBool(m_pawn.CanHit(Enemy)))
		{
			AimAroundBriefly();
		}
		if(bReEvaluateCover)
		{
			ReEvaluateCover();
		}
		else
		{
			Sleep(RandRange(MinStandTime, MaxStandTime));
		}
	}
	return;
}

protected latent function AttackFromBehindCover()
{
	local Pawn Enemy;

	J0x00:
	Enemy = GetEnemy();
	Attack(Enemy, true);
	AttackRotation.Yaw = CoverResult.coverYaw;
	RotateToAttackRotation(Enemy);
	if(EqualEqual_IntInt(int(CoverResult.coverLocationInfo), int(1)))
	{
		AttackWhileCrouchingBehindCover(Enemy);
	}
	else
	{
		AttackWhileLeaningBehindCover(Enemy);
	}
	yield();
	if(!(Not_PreBool(Class'Engine.Pawn'.static.checkConscious(Enemy))))
		goto J0x00;
	return;
}

state Running
{Begin:

	waitForResourcesAvailable(achievingGoal.Priority, achievingGoal.Priority);
	DistanceToOfficersSensor = DistanceToOfficersSensor(Class'Tyrion.AI_Sensor'.static.activateSensor(self, Class'SwatAICommon.DistanceToOfficersSensor', characterResource(), 0.0000000, 1000000.0000000));
	assert(NotEqual_ObjectObject(DistanceToOfficersSensor, none));
	DistanceToOfficersSensor.setParameters_FloatBool(MinDistanceToOfficersWhileTakingCover, true);
	TakeCoverAtInitialCoverLocation();
	if(m_tookCover)
	{
		AttackFromBehindCover();
		succeed();
	}
	else
	{
		fail(12);
	}
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.EngageOfficerGoal'
}