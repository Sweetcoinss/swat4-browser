class ThreatenHostageAction extends SwatCharacterAction implements IInterestedPawnDied
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

const kWaitForOfficerAbleToHearUpdateTime = 0.25;

var private Pawn Hostage;
var private Pawn Officer;
var private MoveToOpponentGoal CurrentMoveToOpponentGoal;
var private AimAtTargetGoal CurrentAimAtTargetGoal;
var private AttackTargetGoal CurrentAttackTargetGoal;
var private config float MinTimeToShootHostage;
var private config float MaxTimeToShootHostage;
var private config float MinRequiredDistanceToOfficer;
var private config float MinRequiredDistanceToHostage;
var private config float MaxDistanceOfficerCanComeCloser;
var private config float MinAgressiveThreatenHostageChance;
var private config float MaxAgressiveThreatenHostageChance;
var private config float MaxPassiveThreatenHostageChance;
var private config float MinPassiveThreatenHostageChance;
var config name ThreatenHostageTriggerEffectEvent;
var config array<name> HostageResponseTriggerEffectEvents;
var config float MinSleepTimeBetweenSpeech;
var config float MaxSleepTimeBetweenSpeech;
var private DistanceToOfficersSensor DistanceToOfficersSensor;
var private bool bHurryUpAndKillHostage;
var private float DistanceToHurryUp;
var private config float RequiredHearingDistance;

function cleanup()
{
	super(AI_CharacterAction).cleanup();
	Level.UnRegisterNotifyPawnDied(self);
	if(NotEqual_ObjectObject(CurrentMoveToOpponentGoal, none))
	{
		CurrentMoveToOpponentGoal.Release();
		CurrentMoveToOpponentGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentAimAtTargetGoal, none))
	{
		CurrentAimAtTargetGoal.Release();
		CurrentAimAtTargetGoal = none;
	}
	if(NotEqual_ObjectObject(CurrentAttackTargetGoal, none))
	{
		CurrentAttackTargetGoal.Release();
		CurrentAttackTargetGoal = none;
	}
	if(NotEqual_ObjectObject(DistanceToOfficersSensor, none))
	{
		DistanceToOfficersSensor.deactivateSensor(self);
		DistanceToOfficersSensor = none;
	}
	return;
}

function OnSensorMessage(AI_Sensor sensor, AI_SensorData Value, Object userData)
{
	Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("ThreatenHostage received sensor message from ", string(sensor.Name)), " value is "), string(Value.integerData)));
	assert(EqualEqual_ObjectObject(sensor, DistanceToOfficersSensor));
	if(EqualEqual_IntInt(Value.integerData, 1))
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(m_pawn.Name), " on sensor message - CurrentAimAtTargetGoal: "), string(CurrentAimAtTargetGoal)), " time is: "), string(m_pawn.Level.TimeSeconds)));
		if(NotEqual_ObjectObject(CurrentAimAtTargetGoal, none))
		{
			bHurryUpAndKillHostage = true;
		}
		else
		{
			if(m_pawn.logTyrion)
			{
				Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(m_pawn.Name), " is too close while "), string(Name)), " running.  failing!"));
			}
			instantFail(17);
		}
	}
	return;
}

function OnOtherPawnDied(Pawn DeadPawn)
{
	if(AndAnd_BoolBool(EqualEqual_ObjectObject(DeadPawn, Hostage), EqualEqual_ObjectObject(CurrentAttackTargetGoal, none)))
	{
		instantFail(1);
	}
	return;
}

private function bool CanThreatenHostage()
{
	local FiredWeapon CurrentWeapon;

	Officer = ISwatEnemy(m_pawn).GetEnemyCommanderAction().GetCurrentEnemy();
	Hostage = none;
	CurrentWeapon = FiredWeapon(m_pawn.GetActiveItem());
	if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(CurrentWeapon, none), NotEqual_ObjectObject(Officer, none)), HasLineOfSightToAPlayer()), Not_PreBool(IsWithinDistanceOfOfficers())))
	{
		Hostage = GetClosestUsableHostageInRoom(Officer);
	}
	return NotEqual_ObjectObject(Hostage, none);
	return;
}

private function bool IsWithinDistanceOfOfficers()
{
	local Hive HiveMind;

	HiveMind = SwatAIRepository(m_pawn.Level.AIRepo).GetHive();
	assert(NotEqual_ObjectObject(HiveMind, none));
	assert(NotEqual_ObjectObject(m_pawn, none));
	return HiveMind.IsPawnWithinDistanceOfOfficers(m_pawn, MinRequiredDistanceToOfficer, true);
	return;
}

private function bool HasLineOfSightToAPlayer()
{
	local Pawn Player;
	local Controller Iter;

	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
	{
		Player = Level.GetLocalPlayerController().Pawn;
		return Player.LineOfSightTo(m_pawn);
	}
	else
	{
		assert(Level.IsCOOPServer);
		Iter = Level.ControllerList;
		J0x75:

		if(NotEqual_ObjectObject(Iter, none))
		{
			if(Iter.IsA('PlayerController'))
			{
				Player = Iter.Pawn;
				if(AndAnd_BoolBool(Class'Engine.Pawn'.static.checkConscious(Player), Player.LineOfSightTo(m_pawn)))
				{
					return true;
				}
			}
			Iter = Iter.nextController;
			// [Loop Continue]
			goto J0x75;
		}
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
	if(EqualEqual_ObjectObject(Level, none))
	{
		Level = m_pawn.Level;
	}
	if(CanThreatenHostage())
	{
		if(ISwatAI(m_pawn).IsAggressive())
		{
			return FClamp(FRand(), MinAgressiveThreatenHostageChance, MaxAgressiveThreatenHostageChance);
		}
		else
		{
			return FClamp(FRand(), MinPassiveThreatenHostageChance, MaxPassiveThreatenHostageChance);
		}
	}
	else
	{
		return 0.0000000;
	}
	return;
}

function bool IsHostageInUsableLocation(Pawn Officer, Pawn Hostage)
{
	assert(NotEqual_ObjectObject(m_pawn, none));
	return Greater_FloatFloat(Dot_VectorVector(Normal(Subtract_VectorVector(Officer.Location, m_pawn.Location)), Normal(Subtract_VectorVector(Hostage.Location, m_pawn.Location))), -0.5000000);
	return;
}

function Pawn GetClosestUsableHostageInRoom(Pawn Officer)
{
	local Pawn PawnIter, ClosestHostage;
	local float IterDistance, ClosestDistance;

	PawnIter = m_pawn.Level.PawnList;
	J0x1D:

	if(NotEqual_ObjectObject(PawnIter, none))
	{
		if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(PawnIter.IsA('SwatHostage'), Class'Engine.Pawn'.static.checkConscious(PawnIter)), m_pawn.IsInRoom(PawnIter.GetRoomName())), IsHostageInUsableLocation(Officer, PawnIter)))
		{
			IterDistance = VSize(Subtract_VectorVector(PawnIter.Location, m_pawn.Location));
			if(Less_FloatFloat(IterDistance, MinRequiredDistanceToHostage))
			{
				if(OrOr_BoolBool(EqualEqual_ObjectObject(ClosestHostage, none), Less_FloatFloat(IterDistance, ClosestDistance)))
				{
					ClosestHostage = PawnIter;
					ClosestDistance = IterDistance;
				}
			}
		}
		PawnIter = PawnIter.nextPawn;
		// [Loop Continue]
		goto J0x1D;
	}
	return ClosestHostage;
	return;
}

function bool CanAimAtHostage()
{
	local FiredWeapon CurrentWeapon;

	CurrentWeapon = FiredWeapon(m_pawn.GetActiveItem());
	return AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(CurrentWeapon, none), m_pawn.CanHit(Hostage)), ISwatAI(m_pawn).AnimCanAimAtDesiredActor(Hostage));
	return;
}

private function CreateDistanceToOfficersSensor(Pawn Officer)
{
	local float DistanceToOfficer;

	if(Class'Engine.Pawn'.static.checkConscious(Officer))
	{
		DistanceToOfficer = VSize(Subtract_VectorVector(Officer.Location, m_pawn.Location));
		if(GreaterEqual_FloatFloat(DistanceToOfficer, MaxDistanceOfficerCanComeCloser))
		{
			DistanceToHurryUp = Subtract_FloatFloat(DistanceToOfficer, MaxDistanceOfficerCanComeCloser);
		}
		else
		{
			DistanceToHurryUp = DistanceToOfficer;
		}
		if(m_pawn.logAI)
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("ThreatenHostageAction (", string(m_pawn.Name)), ") - DistanceToOfficer: "), string(DistanceToOfficer)), " MaxDistanceOfficerCanComeCloser: "), string(MaxDistanceOfficerCanComeCloser)), " DistanceToHurryUp: "), string(DistanceToHurryUp)));
		}
	}
	else
	{
		DistanceToHurryUp = MaxDistanceOfficerCanComeCloser;
	}
	DistanceToOfficersSensor = DistanceToOfficersSensor(Class'Tyrion.AI_Sensor'.static.activateSensor(self, Class'SwatAICommon.DistanceToOfficersSensor', characterResource(), 0.0000000, 1000000.0000000));
	assert(NotEqual_ObjectObject(DistanceToOfficersSensor, none));
	DistanceToOfficersSensor.setParameters_FloatBool(DistanceToHurryUp, true);
	return;
}

latent function MoveTowardsHostage()
{
	CurrentMoveToOpponentGoal = Class'SwatAICommon.MoveToOpponentGoal'.static.Allocate(self).;
	construct_AI_ResourceIntActor(movementResource(), achievingGoal.Priority, Hostage);
	assert(NotEqual_ObjectObject(CurrentMoveToOpponentGoal, none));
	CurrentMoveToOpponentGoal.AddRef();
	CurrentMoveToOpponentGoal.SetRotateTowardsPointsDuringMovement(true);
	CurrentMoveToOpponentGoal.SetStopWhenSuccessful(true);
	CurrentMoveToOpponentGoal.postGoal(self);
	waitForGoal(CurrentMoveToOpponentGoal);
	CurrentMoveToOpponentGoal.unPostGoal(self);
	CurrentMoveToOpponentGoal.Release();
	CurrentMoveToOpponentGoal = none;
	return;
}

latent function AimAtHostage()
{
	CurrentAimAtTargetGoal = Class'SwatAICommon.AimAtTargetGoal'.static.Allocate(self).;
	construct_AI_ResourceIntActor(weaponResource(), achievingGoal.Priority, Hostage);
	assert(NotEqual_ObjectObject(CurrentAimAtTargetGoal, none));
	CurrentAimAtTargetGoal.AddRef();
	CurrentAimAtTargetGoal.postGoal(self);
	return;
}

latent function ShootHostage()
{
	CurrentAttackTargetGoal = Class'SwatAICommon.AttackTargetGoal'.static.Allocate(self).;
	construct_AI_ResourceActor(weaponResource(), Hostage);
	assert(NotEqual_ObjectObject(CurrentAttackTargetGoal, none));
	CurrentAttackTargetGoal.AddRef();
	waitForGoal(CurrentAttackTargetGoal.postGoal(self));
	CurrentAttackTargetGoal.unPostGoal(self);
	CurrentAttackTargetGoal.Release();
	CurrentAttackTargetGoal = none;
	return;
}

latent function TriggerThreatenHostageSpeech(bool bCreateDistanceSensor)
{
	ISwatAI(m_pawn).LatentAITriggerEffectEvent(ThreatenHostageTriggerEffectEvent,,,,,, true);
	if(bCreateDistanceSensor)
	{
		CreateDistanceToOfficersSensor(Officer);
	}
	if(Not_PreBool(bHurryUpAndKillHostage))
	{
		Sleep(RandRange(MinSleepTimeBetweenSpeech, MaxSleepTimeBetweenSpeech));
	}
	if(Not_PreBool(bHurryUpAndKillHostage))
	{
		ISwatAI(Hostage).LatentAITriggerEffectEvent(HostageResponseTriggerEffectEvents[Rand(HostageResponseTriggerEffectEvents.Length)],,,,,, true);
	}
	return;
}

latent function WaitToKillHostage()
{
	local float EndTime, HalfEndTime, RandomTime;
	local Pawn CurrentEnemy;

	J0x00:
	if(GreaterEqual_FloatFloat(m_pawn.Controller.GetDistanceToSound(Officer, m_pawn.Location, Officer.Location), RequiredHearingDistance))
	{
		CurrentEnemy = ISwatEnemy(m_pawn).GetEnemyCommanderAction().GetCurrentEnemy();
		if(AndAnd_BoolBool(NotEqual_ObjectObject(CurrentEnemy, Officer), Class'Engine.Pawn'.static.checkConscious(CurrentEnemy)))
		{
			Officer = CurrentEnemy;
		}
		TriggerThreatenHostageSpeech(false);
		Sleep(0.2500000);
		// [Loop Continue]
		goto J0x00;
	}
	if(Not_PreBool(CanAimAtHostage()))
	{
		instantFail(1);
	}
	TriggerThreatenHostageSpeech(true);
	RandomTime = RandRange(MinTimeToShootHostage, MaxTimeToShootHostage);
	EndTime = Add_FloatFloat(RandomTime, Level.TimeSeconds);
	HalfEndTime = Add_FloatFloat(Divide_FloatFloat(RandomTime, 2.0000000), Level.TimeSeconds);
	J0x119:

	if(AndAnd_BoolBool(Less_FloatFloat(Level.TimeSeconds, HalfEndTime), Not_PreBool(bHurryUpAndKillHostage)))
	{
		if(Not_PreBool(CanAimAtHostage()))
		{
			instantFail(1);
		}
		yield();
		// [Loop Continue]
		goto J0x119;
	}
	if(Not_PreBool(bHurryUpAndKillHostage))
	{
		TriggerThreatenHostageSpeech(false);
		J0x16C:

		if(AndAnd_BoolBool(Less_FloatFloat(Level.TimeSeconds, EndTime), Not_PreBool(bHurryUpAndKillHostage)))
		{
			if(Not_PreBool(CanAimAtHostage()))
			{
				instantFail(1);
			}
			yield();
			// [Loop Continue]
			goto J0x16C;
		}
	}
	return;
}

state Running
{Begin:

	if(Not_PreBool(Class'Engine.Pawn'.static.checkConscious(Hostage)))
	{
		instantFail(1);
	}
	Level.RegisterNotifyPawnDied(self);
	waitForResourcesAvailable(achievingGoal.Priority, achievingGoal.Priority);
	J0x53:

	if(Not_PreBool(CanAimAtHostage()))
	{
		MoveTowardsHostage();
		yield();
		// [Loop Continue]
		goto J0x53;
	}
	useResources(Class'Tyrion.AI_Resource'.4);
	AimAtHostage();
	WaitToKillHostage();
	CurrentAimAtTargetGoal.unPostGoal(self);
	CurrentAimAtTargetGoal.Release();
	CurrentAimAtTargetGoal = none;
	J0xAC:

	if(Class'Engine.Pawn'.static.checkConscious(Hostage))
	{
		if(Not_PreBool(CanAimAtHostage()))
		{
			instantFail(1);
		}
		ShootHostage();
		// [Loop Continue]
		goto J0xAC;
	}
	succeed();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.EngageOfficerGoal'
}