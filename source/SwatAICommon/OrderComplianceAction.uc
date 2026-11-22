class OrderComplianceAction extends SwatWeaponAction implements ISensorNotification
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

const kMinOrderComplyTime = 0.5;
const kMaxOrderComplyTime = 1.0;
const kPlayOrderComplianceAnimation = 0.375;

var(Parameters) Pawn TargetPawn;
var CompliantSensor CompliantSensor;
var private float TimeToStopTryingToEngage;
var config float MaximumTimeToWaitToEngage;
var config float MinComplianceOrderSleepTime;
var config float MaxComplianceOrderSleepTime;
var config float MinComplianceWaitTime;
var config float MaxComplianceWaitTime;
var config array<name> ComplyMGOrderAnims;
var config array<name> ComplySGOrderAnims;
var config array<name> ComplySMGOrderAnims;
var config array<name> ComplyHGOrderAnims;
var config array<name> ComplyPepperBallOrderAnims;

function initAction(AI_Resource R, AI_Goal Goal)
{
	super.initAction(R, Goal);
	SetTimeToStopTryingToEngage();
	ActivateComplianceSensor();
	assert(Greater_FloatFloat(MinComplianceOrderSleepTime, 0.0000000));
	assert(Greater_FloatFloat(MaxComplianceOrderSleepTime, 0.0000000));
	return;
}

private function ActivateComplianceSensor()
{
	assert(NotEqual_ObjectObject(TargetPawn, none));
	CompliantSensor = CompliantSensor(Class'Tyrion.AI_Sensor'.static.activateSensor(self, Class'SwatAICommon.CompliantSensor', characterResource(), 0.0000000, 1000000.0000000));
	CompliantSensor.setParameters(TargetPawn);
	return;
}

private latent function SetOrderComplianceAim()
{
	ISwatAI(m_pawn).SetUpperBodyAnimBehavior(2, 10);
	ISwatAI(m_pawn).AimAtActor(TargetPawn);
	ISwatAI(m_pawn).LockAim();
	LatentAimAtActor(TargetPawn);
	return;
}

private function UnsetOrderComplianceAim()
{
	ISwatAI(m_pawn).UnlockAim();
	ISwatAI(m_pawn).UnsetUpperBodyAnimBehavior(10);
	return;
}

function cleanup()
{
	super(ActionBase).cleanup();
	if(NotEqual_ObjectObject(CompliantSensor, none))
	{
		CompliantSensor.deactivateSensor(self);
		CompliantSensor = none;
	}
	UnsetOrderComplianceAim();
	return;
}

function OnSensorMessage(AI_Sensor sensor, AI_SensorData Value, Object userData)
{
	if(m_pawn.logTyrion)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("OrderComplianceAction received sensor message from ", string(sensor.Name)), " value is "), string(Value.integerData)));
	}
	if(EqualEqual_ObjectObject(sensor, CompliantSensor))
	{
		instantSucceed();
	}
	return;
}

function name GetComplyOrderAnimName()
{
	local HandheldEquipment ActiveItem;

	ActiveItem = m_pawn.GetActiveItem();
	if(ActiveItem.IsA('MachineGun'))
	{
		return ComplyMGOrderAnims[Rand(ComplyMGOrderAnims.Length)];
	}
	else
	{
		if(ActiveItem.IsA('Shotgun'))
		{
			return ComplySGOrderAnims[Rand(ComplySGOrderAnims.Length)];
		}
		else
		{
			if(ActiveItem.IsA('SubMachineGun'))
			{
				return ComplySMGOrderAnims[Rand(ComplySMGOrderAnims.Length)];
			}
			else
			{
				if(ActiveItem.IsA('CSBallLauncher'))
				{
					return ComplyPepperBallOrderAnims[Rand(ComplyPepperBallOrderAnims.Length)];
				}
				else
				{
					return ComplyHGOrderAnims[Rand(ComplyHGOrderAnims.Length)];
				}
			}
		}
	}
	return;
}

latent function OrderToComply()
{
	local int ComplyAnimationChannel;

	if(ISwatAI(TargetPawn).HasFiredWeaponEquipped())
	{
		ISwatOfficer(m_pawn).GetOfficerSpeechManagerAction().TriggerComplyWithGunSpeech();
	}
	else
	{
		ISwatOfficer(m_pawn).GetOfficerSpeechManagerAction().TriggerComplySpeech();
	}
	if(Less_FloatFloat(FRand(), 0.3750000))
	{
		ComplyAnimationChannel = m_pawn.AnimPlaySpecial(GetComplyOrderAnimName(), 0.1000000, ISwatAI(m_pawn).GetUpperBodyBone());
		m_pawn.FinishAnim(ComplyAnimationChannel);
	}
	else
	{
		Sleep(RandRange(0.5000000, 1.0000000));
	}
	ISwatAI(m_pawn).IssueComplianceTo(TargetPawn);
	return;
}

private function SetTimeToStopTryingToEngage()
{
	assert(NotEqual_ObjectObject(Level, none));
	TimeToStopTryingToEngage = Add_FloatFloat(Level.TimeSeconds, MaximumTimeToWaitToEngage);
	return;
}

state Running
{	J0x00:
	if(AndAnd_BoolBool(AndAnd_BoolBool(Class'Engine.Pawn'.static.checkConscious(TargetPawn), Not_PreBool(ISwatAI(TargetPawn).IsCompliant())), Less_FloatFloat(Level.TimeSeconds, TimeToStopTryingToEngage)))
	{
		if(ISwatAI(m_pawn).CanIssueComplianceTo(TargetPawn))
		{
			SetOrderComplianceAim();
			OrderToComply();
			SetTimeToStopTryingToEngage();
			Sleep(RandRange(MinComplianceOrderSleepTime, MaxComplianceOrderSleepTime));
		}
		else
		{
			Sleep(RandRange(MinComplianceWaitTime, MaxComplianceWaitTime));
		}
		// [Loop Continue]
		goto J0x00;
	}
	succeed();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.OrderComplianceGoal'
}