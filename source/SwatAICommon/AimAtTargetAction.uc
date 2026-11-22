class AimAtTargetAction extends SwatWeaponAction
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) private Actor Target;
var(Parameters) private bool bOnlyWhenCanHitTarget;
var(Parameters) private bool bShouldFinishOnSuccess;
var(Parameters) private bool bAimWeapon;
var(Parameters) private bool bHoldAimForPeriodOfTime;
var(Parameters) private float HoldAimTime;
var(Parameters) private float MinDistanceToTargetToAim;

function cleanup()
{
	super(ActionBase).cleanup();
	ISwatAI(m_pawn).UnsetUpperBodyAnimBehavior(15);
	return;
}

private function CheckAimingMode()
{
	if(AndAnd_BoolBool(bAimWeapon, m_pawn.CanHit(Target)))
	{
		ISwatAI(m_pawn).SetUpperBodyAnimBehavior(2, 15);
	}
	else
	{
		if(ISwatAI(m_pawn).CanPawnUseLowReady())
		{
			ISwatAI(m_pawn).SetUpperBodyAnimBehavior(1, 15);
		}
		else
		{
			ISwatAI(m_pawn).SetUpperBodyAnimBehavior(0, 15);
		}
	}
	return;
}

latent function AimAtTarget()
{
	J0x00:
	if(OrOr_BoolBool(Not_PreBool(bOnlyWhenCanHitTarget), AndAnd_BoolBool(m_pawn.CanHit(Target), OrOr_BoolBool(EqualEqual_FloatFloat(MinDistanceToTargetToAim, 0.0000000), Less_FloatFloat(VSize(Subtract_VectorVector(Target.Location, m_pawn.Location)), MinDistanceToTargetToAim)))))
	{
		LatentAimAtActor(Target);
		yield();
		// [Loop Continue]
		goto J0x00;
	}
	return;
}

state Running
{Begin:

	if(OrOr_BoolBool(EqualEqual_ObjectObject(Target, none), AndAnd_BoolBool(Target.IsA('Pawn'), Not_PreBool(Class'Engine.Pawn'.static.checkConscious(Pawn(Target))))))
	{
		succeed();
	}
	CheckAimingMode();
	AimAtTarget();
	if(bShouldFinishOnSuccess)
	{
		succeed();
	}
	else
	{
		if(bHoldAimForPeriodOfTime)
		{
			Sleep(HoldAimTime);
			succeed();
		}
	}
	yield();
	goto 'Begin';
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.AimAtTargetGoal'
}