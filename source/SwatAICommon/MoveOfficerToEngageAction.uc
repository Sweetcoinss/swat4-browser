class MoveOfficerToEngageAction extends MoveToOpponentAction
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

const kMinSleepTimeBetweenFindEngagePointTests = 1.0;
const kMaxSleepTimeBetweenFindEngagePointTests = 3.0;

var(Parameters) Pawn Opponent;
var private TargetSensor TargetSensor;
var private NavigationPoint PointToEngageFrom;
var private name RoomNameToEngageFrom;

function initAction(AI_Resource R, AI_Goal Goal)
{
	super(MoveToActionBase).initAction(R, Goal);
	RoomNameToEngageFrom = m_pawn.GetRoomName();
	return;
}

function cleanup()
{
	super(MoveToActionBase).cleanup();
	if(NotEqual_ObjectObject(TargetSensor, none))
	{
		TargetSensor.deactivateSensor(self);
		TargetSensor = none;
	}
	if(NotEqual_ObjectObject(PointToEngageFrom, none))
	{
		SwatAIRepository(Level.AIRepo).GetHive().ClearEngagingPointForOfficer(m_pawn);
	}
	return;
}

private function ActivateTargetSensor()
{
	assert(NotEqual_ObjectObject(Opponent, none));
	TargetSensor = TargetSensor(Class'Tyrion.AI_Sensor'.static.activateSensor(self, Class'SwatAICommon.TargetSensor', characterResource(), 0.0000000, 1000000.0000000));
	assert(NotEqual_ObjectObject(TargetSensor, none));
	TargetSensor.setParameters(Opponent);
	return;
}

function OnSensorMessage(AI_Sensor sensor, AI_SensorData Value, Object userData)
{
	if(m_pawn.logTyrion)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("MoveOfficerToEngageAction received sensor message from ", string(sensor.Name)), " value is "), string(Value.objectData)));
	}
	if(AndAnd_BoolBool(EqualEqual_ObjectObject(Value.objectData, none), IsIdle()))
	{
		runAction();
	}
	return;
}

function bool ShouldStopMovingToOpponent(Pawn MovingPawn)
{
	local FiredWeapon CurrentWeapon;
	local float DistanceToOpponent;

	if(m_pawn.Anchor.IsA('Door'))
	{
		return false;
	}
	CurrentWeapon = FiredWeapon(m_pawn.GetActiveItem());
	if(NotEqual_ObjectObject(CurrentWeapon, none))
	{
		if(CurrentWeapon.IsBeingReloaded())
		{
			return true;
		}
		if(Not_PreBool(Class'Engine.Pawn'.static.checkConscious(Opponent)))
		{
			if(MovingPawn.logTyrion)
			{
				Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(Name), " failed because Opponent "), string(Opponent)), " isn't conscious"));
			}
			return true;
		}
		DistanceToOpponent = VSize(Subtract_VectorVector(Opponent.Location, m_pawn.Location));
		if(Less_FloatFloat(DistanceToOpponent, DistanceToStopMoving))
		{
			return true;
		}
		if(m_pawn.CanHit(Opponent))
		{
			if(EqualEqual_FloatFloat(FirstCanHitTime, 0.0000000))
			{
				FirstCanHitTime = Level.TimeSeconds;
			}
			else
			{
				if(AndAnd_BoolBool(NotEqual_FloatFloat(FirstCanHitTime, 0.0000000), Greater_FloatFloat(Level.TimeSeconds, Add_FloatFloat(FirstCanHitTime, 0.1000000))))
				{
					return true;
				}
			}
			return false;
		}
		FirstCanHitTime = 0.0000000;
		return false;
	}
	FirstCanHitTime = 0.0000000;
	return true;
	return;
}

private latent function MoveToPointToEngageFrom()
{
	assert(NotEqual_ObjectObject(PointToEngageFrom, none));
	MoveToActorGoal(achievingGoal).SetDestinationActor(PointToEngageFrom);
	MoveToActor();
	return;
}

state Running
{Begin:

	ActivateTargetSensor();
RunningLoop:

	bSucceeded = false;
	if(TargetSensor.bCanHitTarget)
	{
		Pause();
	}
	else
	{
		PointToEngageFrom = SwatAIRepository(Level.AIRepo).GetHive().RequestNewEngagingPointForOfficer(m_pawn, Opponent);
		if(NotEqual_ObjectObject(PointToEngageFrom, none))
		{
			MoveToPointToEngageFrom();
		}
		Sleep(RandRange(1.0000000, 3.0000000));
	}
	yield();
	goto 'RunningLoop';
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.MoveOfficerToEngageGoal'
}