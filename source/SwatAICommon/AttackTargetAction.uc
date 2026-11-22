class AttackTargetAction extends SwatWeaponAction implements ISensorNotification
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) Actor Target;
var(Parameters) Pawn TargetPawn;
var(Parameters) float ChanceToSucceedAfterFiring;
var(Parameters) bool bHavePerfectAim;
var(Parameters) bool bOrderedToAttackTarget;
var private TargetSensor TargetSensor;
var private bool bCanHitTarget;
var private float TimeToStopTryingToAttack;
var config float MaximumTimeToWaitToAttack;

function initAction(AI_Resource R, AI_Goal Goal)
{
	super.initAction(R, Goal);
	assert(NotEqual_ObjectObject(m_pawn, none));
	SetTimeToStopTryingToAttack();
	ISwatAI(m_pawn).SetUpperBodyAnimBehavior(2, 19);
	return;
}

function cleanup()
{
	local FiredWeapon CurrentWeapon;

	super(ActionBase).cleanup();
	if(NotEqual_ObjectObject(TargetSensor, none))
	{
		TargetSensor.deactivateSensor(self);
		TargetSensor = none;
	}
	CurrentWeapon = FiredWeapon(m_pawn.GetActiveItem());
	if(NotEqual_ObjectObject(CurrentWeapon, none))
	{
		if(Not_PreBool(CurrentWeapon.IsIdle()))
		{
			CurrentWeapon.AIInterrupt();
		}
	}
	ISwatAI(m_pawn).UnlockAim();
	ISwatAI(m_pawn).UnsetUpperBodyAnimBehavior(19);
	return;
}

private function ActivateTargetSensor()
{
	assert(NotEqual_ObjectObject(Target, none));
	TargetSensor = TargetSensor(Class'Tyrion.AI_Sensor'.static.activateSensor(self, Class'SwatAICommon.TargetSensor', characterResource(), 0.0000000, 1000000.0000000));
	assert(NotEqual_ObjectObject(TargetSensor, none));
	TargetSensor.setParameters(Target);
	return;
}

function OnSensorMessage(AI_Sensor sensor, AI_SensorData Value, Object userData)
{
	if(m_pawn.logTyrion)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("AttackTargetAction received sensor message from ", string(sensor.Name)), " value is "), string(Value.objectData)));
	}
	bCanHitTarget = true;
	return;
}

latent function ReadyWeapon()
{
	local FiredWeapon CurrentWeapon, PendingWeapon;

	CurrentWeapon = FiredWeapon(m_pawn.GetActiveItem());
	if(EqualEqual_ObjectObject(CurrentWeapon, none))
	{
		PendingWeapon = FiredWeapon(m_pawn.GetPendingItem());
		if(NotEqual_ObjectObject(PendingWeapon, none))
		{
			J0x4A:

			if(PendingWeapon.IsBeingEquipped())
			{
				yield();
				// [Loop Continue]
				goto J0x4A;
			}
			if(PendingWeapon.IsEquipped())
			{
				CurrentWeapon = PendingWeapon;
			}
		}
	}
	if(OrOr_BoolBool(EqualEqual_ObjectObject(CurrentWeapon, none), CurrentWeapon.IsEmpty()))
	{
		if(OrOr_BoolBool(EqualEqual_ObjectObject(GetBackupWeapon(), none), EqualEqual_ObjectObject(CurrentWeapon, GetBackupWeapon())))
		{
			fail(15);
			return;
		}
		SwitchWeapons();
	}
	return;
}

function SetFireMode(FiredWeapon CurrentWeapon)
{
	local FiredWeapon.FireMode DesiredFireMode;

	assert(NotEqual_ObjectObject(CurrentWeapon, none));
	DesiredFireMode = ISwatAI(m_pawn).GetDefaultAIFireModeForWeapon(CurrentWeapon);
	CurrentWeapon.SetCurrentFireMode(DesiredFireMode);
	return;
}

private function bool ShouldSucceed()
{
	return Less_FloatFloat(FRand(), ChanceToSucceedAfterFiring);
	return;
}

latent function AttackTarget()
{
	local FiredWeapon CurrentWeapon;

	ReadyWeapon();
	CurrentWeapon = FiredWeapon(m_pawn.GetActiveItem());
	if(EqualEqual_ObjectObject(CurrentWeapon, none))
	{
		instantFail(15);
	}
	if(m_pawn.logTyrion)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(m_pawn.Name), " AttackTargetAction::AttackTarget - CurrentWeapon: "), string(CurrentWeapon.Name)), " NeedsReload: "), string(CurrentWeapon.NeedsReload())), " CanReload: "), string(CurrentWeapon.CanReload())));
	}
	if(AndAnd_BoolBool(CurrentWeapon.NeedsReload(), CurrentWeapon.CanReload()))
	{
		CurrentWeapon.LatentReload();
	}
	else
	{
		if(CurrentWeapon.IsEmpty())
		{
			instantFail(15);
		}
	}
	AimAtActor(Target);
	ISwatAI(m_pawn).LockAim();
	if(Not_PreBool(CurrentWeapon.IsIdle()))
	{
		CurrentWeapon.AIInterrupt();
	}
	J0x17C:

	if(AndAnd_BoolBool(Not_PreBool(m_pawn.CanHit(Target)), OrOr_BoolBool(EqualEqual_ObjectObject(TargetPawn, none), Class'Engine.Pawn'.static.checkConscious(TargetPawn))))
	{
		if(m_pawn.logTyrion)
		{
			Log(Concat_StrStr(Concat_StrStr(string(m_pawn.Name), " is waiting to be able to hit target "), string(TargetPawn)));
		}
		yield();
		// [Loop Continue]
		goto J0x17C;
	}
	if(ISwatAI(m_pawn).AnimCanAimAtDesiredActor(Target))
	{
		ISwatAI(m_pawn).SetUpperBodyAnimBehavior(2, 19);
		if(bHavePerfectAim)
		{
			CurrentWeapon.SetPerfectAimNextShot();
		}
		AimAndFireAtTarget(CurrentWeapon);
		if(ShouldSucceed())
		{
			instantSucceed();
		}
		else
		{
			Sleep(ISwatAI(m_pawn).GetTimeToWaitBetweenFiring(CurrentWeapon));
		}
	}
	else
	{
		if(ISwatAI(m_pawn).AnimIsWeaponAimSet())
		{
			ISwatAI(m_pawn).UnsetUpperBodyAnimBehavior(19);
		}
	}
	ISwatAI(m_pawn).UnlockAim();
	return;
}

protected latent function AimAndFireAtTarget(FiredWeapon CurrentWeapon)
{
	SetFireMode(CurrentWeapon);
	LatentAimAtActor(Target);
	ShootWeaponAt(Target);
	return;
}

private function AimAtLastSeenPosition()
{
	local KnowledgeAboutPawn TargetKnowledge;

	if(ISwatAI(m_pawn).GetKnowledge().GetLastKnownKnowledgeAboutPawn(TargetPawn, TargetKnowledge))
	{
		AimAtPoint(TargetKnowledge.Location);
	}
	return;
}

private function bool IsTargetAThreat()
{
	return OrOr_BoolBool(OrOr_BoolBool(EqualEqual_ObjectObject(TargetPawn, none), Not_PreBool(TargetPawn.IsA('SwatEnemy'))), OrOr_BoolBool(ISwatEnemy(TargetPawn).IsAThreat(), bOrderedToAttackTarget));
	return;
}

private function SetTimeToStopTryingToAttack()
{
	assert(NotEqual_ObjectObject(Level, none));
	TimeToStopTryingToAttack = Add_FloatFloat(Level.TimeSeconds, MaximumTimeToWaitToAttack);
	return;
}

state Running
{Begin:

	if(m_pawn.logTyrion)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self.Name), " started "), string(Name)), " at time "), string(Level.TimeSeconds)));
	}
	ActivateTargetSensor();
	ReadyWeapon();
	J0x61:

	if(AndAnd_BoolBool(AndAnd_BoolBool(Class'Engine.Pawn'.static.checkConscious(m_pawn), OrOr_BoolBool(EqualEqual_ObjectObject(TargetPawn, none), Class'Engine.Pawn'.static.checkConscious(TargetPawn))), OrOr_BoolBool(Not_PreBool(m_pawn.IsA('SwatOfficer')), IsTargetAThreat())))
	{
		if(EqualEqual_ObjectObject(TargetSensor.queryObjectValue(), none))
		{
			if(m_pawn.logTyrion)
			{
				Log(Concat_StrStr(string(m_pawn.Name), " pausing because queryObjectValue == None"));
			}
			ISwatAI(m_pawn).GetCommanderAction().FindBetterEnemy();
			AimAtLastSeenPosition();
			bCanHitTarget = false;
			J0x153:

			if(AndAnd_BoolBool(Not_PreBool(bCanHitTarget), Less_FloatFloat(Level.TimeSeconds, TimeToStopTryingToAttack)))
			{
				yield();
				// [Loop Continue]
				goto J0x153;
			}
			if(m_pawn.logTyrion)
			{
				Log(Concat_StrStr(string(m_pawn.Name), " was told to run"));
			}
			if(Not_PreBool(Class'Engine.Pawn'.static.checkConscious(TargetPawn)))
			{
				if(m_pawn.logTyrion)
				{
					Log(Concat_StrStr(string(self.Name), " stopped. TARGET DEAD!"));
				}
				succeed();
			}
			else
			{
				if(GreaterEqual_FloatFloat(Level.TimeSeconds, TimeToStopTryingToAttack))
				{
					if(m_pawn.logTyrion)
					{
						Log(Concat_StrStr(string(self.Name), " ran out of time to attack.  failing!"));
					}
					instantFail(6);
				}
			}
		}
		SetTimeToStopTryingToAttack();
		AttackTarget();
		yield();
		// [Loop Continue]
		goto J0x61;
	}
	if(m_pawn.logTyrion)
	{
		if(AndAnd_BoolBool(NotEqual_ObjectObject(TargetPawn, none), Not_PreBool(Class'Engine.Pawn'.static.checkConscious(TargetPawn))))
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self.Name), " stopped because "), string(TargetPawn.Name)), " isn't conscious at time "), string(Level.TimeSeconds)));
		}
		else
		{
			if(Not_PreBool(Class'Engine.Pawn'.static.checkConscious(m_pawn)))
			{
				Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self.Name), " stopped because my pawn ("), string(m_pawn.Name)), ") isn't conscious at time "), string(Level.TimeSeconds)));
			}
			else
			{
				if(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(TargetPawn, none), TargetPawn.IsA('SwatEnemy')), Not_PreBool(ISwatEnemy(TargetPawn).IsAThreat())))
				{
					Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self.Name), " stopped because "), string(TargetPawn.Name)), " isn't currently a threat at time "), string(Level.TimeSeconds)));
				}
			}
		}
	}
	succeed();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.AttackTargetGoal'
}