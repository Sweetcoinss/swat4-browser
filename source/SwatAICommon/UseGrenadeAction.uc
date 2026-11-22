class UseGrenadeAction extends SwatWeaponAction
	config(AI)
	collapsecategories
	hidecategories(Object,InternalParameters);

var private ThrownWeapon GrenadeWeapon;
var private bool bContinueToThrowGrenade;
var(Parameters) Vector vTargetLocation;
var(Parameters) HandheldEquipment.EquipmentSlot GrenadeSlot;
var(Parameters) bool bWaitToThrowGrenade;
var(Parameters) IInterestedGrenadeThrowing ThrowClient;
var private config name NodAnimation;

function initAction(AI_Resource R, AI_Goal Goal)
{
	super.initAction(R, Goal);
	ISwatAI(m_pawn).SetGrenadeTargetLocation(vTargetLocation);
	return;
}

function cleanup()
{
	super(ActionBase).cleanup();
	if(AndAnd_BoolBool(NotEqual_ObjectObject(GrenadeWeapon, none), Not_PreBool(GrenadeWeapon.IsIdle())))
	{
		GrenadeWeapon.AIInterrupt();
	}
	ISwatOfficer(m_pawn).InstantReEquipFiredWeapon();
	if(NotEqual_ObjectObject(ThrowClient, none))
	{
		GrenadeWeapon.UnRegisterInterestedGrenadeThrowing(ThrowClient);
	}
	return;
}

function SetContinueToThrowGrenade()
{
	bContinueToThrowGrenade = true;
	return;
}

private function float GetThrowSpeed(float ThrowAngle, Vector ThrowOrigin)
{
	local float Distance, Grav, SinValue, ProjectileSpeed;

	Distance = VSize(Subtract_VectorVector(vTargetLocation, ThrowOrigin));
	Grav = Multiply_FloatFloat(Subtract_PreFloat(m_pawn.PhysicsVolume.Gravity.Z), 0.5000000);
	SinValue = Sin(Multiply_FloatFloat(Multiply_FloatFloat(2.0000000, ThrowAngle), Divide_FloatFloat(3.1415930, 180.0000000)));
	ProjectileSpeed = Sqrt(Multiply_FloatFloat(Divide_FloatFloat(Distance, SinValue), Grav));
	return ProjectileSpeed;
	return;
}

private function PrepareToThrowGrenade()
{
	local float ThrowAngle, ThrowSpeed;
	local Vector InitialLocation;
	local Rotator InitialRotation;

	ICanThrowWeapons(m_pawn).GetThrownProjectileParams(InitialLocation, InitialRotation);
	ThrowAngle = Multiply_FloatFloat(ISwatAI(m_pawn).GetThrowAngle(), 10430.3800000);
	ThrowSpeed = GetThrowSpeed(ThrowAngle, InitialLocation);
	GrenadeWeapon.SetThrowSpeed(ThrowSpeed);
	return;
}

latent function EquipGrenade()
{
	GrenadeWeapon = ISwatOfficer(m_pawn).GetThrownWeapon(GrenadeSlot);
	assert(NotEqual_ObjectObject(GrenadeWeapon, none));
	GrenadeWeapon.LatentWaitForIdleAndEquip();
	return;
}

latent function ThrowGrenade()
{
	PrepareToThrowGrenade();
	if(NotEqual_ObjectObject(ThrowClient, none))
	{
		GrenadeWeapon.RegisterInterestedGrenadeThrowing(ThrowClient);
	}
	GrenadeWeapon.LatentUse();
	return;
}

private latent function PlayNodAnimation()
{
	local int SpecialChannel;

	SpecialChannel = m_pawn.AnimPlaySpecial(NodAnimation, 0.1000000, ISwatAI(m_pawn).GetUpperBodyBone());
	m_pawn.FinishAnim(SpecialChannel);
	return;
}

state Running
{Begin:

	EquipGrenade();
	if(NotEqual_ObjectObject(ThrowClient, none))
	{
		ThrowClient.NotifyGrenadeReadyToThrow();
	}
	if(bWaitToThrowGrenade)
	{
		PlayNodAnimation();
		if(Not_PreBool(bContinueToThrowGrenade))
		{
			Pause();
		}
	}
	ThrowGrenade();
	ISwatOfficer(m_pawn).ReEquipFiredWeapon();
	succeed();
	stop;
}

defaultproperties
{
	satisfiesGoal=Class'SwatAICommon.UseGrenadeGoal'
}