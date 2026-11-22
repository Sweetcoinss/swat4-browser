class FiredWeaponModel extends HandheldEquipmentModel
	abstract
	config(SwatGame)
	notplaceable
	hidecategories(Karma,Advanced,Events,Force,LightColor,Lighting,Movement,Object,Sound);

var(FiredWeaponModelAnimations) name BurstAnimation;
var(FiredWeaponModelAnimations) name HolderBurstAnimation;
var(FiredWeaponModelAnimations) name UseLastRoundAnimation;
var(FiredWeaponModelAnimations) name HolderUseLastRoundAnimation;
var(FiredWeaponModelAnimations) name UseEmptyAnimation;
var(FiredWeaponModelAnimations) name HolderUseEmptyAnimation;
var(FiredWeaponModelAnimations) name ReloadAnimation;
var(FiredWeaponModelAnimations) name EmptyReloadAnimation;
var(FiredWeaponModelAnimations) name HolderReloadAnimation;
var(FiredWeaponModelAnimations) name HolderEmptyReloadAnimation;
var int HolderReloadAnimationChannel;
var name SelectedReloadAnimation;
var name SelectedHolderReloadAnimation;
var config float ReloadTweenTime;

simulated function PostNetBeginPlay()
{
	super.PostNetBeginPlay();
	return;
}

simulated function SetHandHeldEquipment(HandheldEquipment HHE)
{
	super.SetHandHeldEquipment(HHE);
	if(NotEqual_IntInt(int(DrawType), int(2)))
	{
		AssertWithDescription(EqualEqual_NameName(BurstAnimation, 'None'), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] The ", string(HandheldEquipment.Class.Name)), "'s Model "), string(Class.Name)), " specifies a BurstAnimation, but its DrawType is not DT_Mesh.  Shawn should fix this."));
		AssertWithDescription(EqualEqual_NameName(UseLastRoundAnimation, 'None'), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] The ", string(HandheldEquipment.Class.Name)), "'s Model "), string(Class.Name)), " specifies a UseLastRoundAnimation, but its DrawType is not DT_Mesh.  Shawn should fix this."));
		AssertWithDescription(EqualEqual_NameName(UseEmptyAnimation, 'None'), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] The ", string(HandheldEquipment.Class.Name)), "'s Model "), string(Class.Name)), " specifies a UseEmptyAnimation, but its DrawType is not DT_Mesh.  Shawn should fix this."));
		AssertWithDescription(EqualEqual_NameName(ReloadAnimation, 'None'), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] The ", string(HandheldEquipment.Class.Name)), "'s Model "), string(Class.Name)), " specifies a ReloadAnimation, but its DrawType is not DT_Mesh.  Shawn should fix this."));
		AssertWithDescription(EqualEqual_NameName(EmptyReloadAnimation, 'None'), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] The ", string(HandheldEquipment.Class.Name)), "'s Model "), string(Class.Name)), " specifies an EmptyReloadAnimation, but its DrawType is not DT_Mesh.  Shawn should fix this."));
	}
	if(AndAnd_BoolBool(NotEqual_ObjectObject(FiredWeapon(HHE), none), FiredWeapon(HHE).HasFlashlight()))
	{
		CopyMaterialsToSkins(true);
	}
	return;
}

simulated function PlayReload()
{
	SelectedReloadAnimation = SelectReloadAnimation();
	SelectedHolderReloadAnimation = SelectHolderReloadAnimation();
	if(NotEqual_NameName(SelectedReloadAnimation, 'None'))
	{
		PlayAnim(SelectedReloadAnimation, FiredWeapon(HandheldEquipment).ReloadAnimationRate);
	}
	if(NotEqual_NameName(SelectedHolderReloadAnimation, 'None'))
	{
		if(Owner.IsA('SwatPawn'))
		{
			HolderReloadAnimationChannel = Pawn(Owner).AnimPlayEquipment(0, SelectedHolderReloadAnimation, ReloadTweenTime, HolderAnimationRootBone, FiredWeapon(HandheldEquipment).ReloadAnimationRate);
		}
		else
		{
			Owner.PlayAnim(SelectedHolderReloadAnimation, FiredWeapon(HandheldEquipment).ReloadAnimationRate, 0.2000000);
			HolderReloadAnimationChannel = 0;
		}
	}
	return;
}

latent simulated function FinishReload()
{
	if(NotEqual_NameName(SelectedReloadAnimation, 'None'))
	{
		FinishAnim();
	}
	if(NotEqual_NameName(SelectedHolderReloadAnimation, 'None'))
	{
		Owner.FinishAnim(HolderReloadAnimationChannel);
	}
	return;
}

simulated function OnReloadKeyFrame()
{
	return;
}

protected simulated function name SelectReloadAnimation()
{
	if(EqualEqual_NameName(EmptyReloadAnimation, 'None'))
	{
		return ReloadAnimation;
	}
	if(FiredWeapon(HandheldEquipment).Ammo.NeedsReload())
	{
		return EmptyReloadAnimation;
	}
	else
	{
		return ReloadAnimation;
	}
	return;
}

protected simulated function name SelectHolderReloadAnimation()
{
	if(EqualEqual_NameName(HolderEmptyReloadAnimation, 'None'))
	{
		return HolderReloadAnimation;
	}
	if(FiredWeapon(HandheldEquipment).Ammo.NeedsReload())
	{
		return HolderEmptyReloadAnimation;
	}
	else
	{
		return HolderReloadAnimation;
	}
	return;
}

protected simulated function SelectUseAnimations(out name outSelectedUseAnimation, out float outSelectedUseAnimationRate, out name outSelectedHolderUseAnimation, out float outSelectedHolderUseAnimationRate, out Pawn.EAnimPlayType outAnimPlayType)
{
	local name UseInFireMode, HolderUseInFireMode;
	local float BurstRateFactor;
	local FiredWeapon FiredWeapon;

	FiredWeapon = FiredWeapon(HandheldEquipment);
	outAnimPlayType = 1;
	UseInFireMode = UseAnimation;
	HolderUseInFireMode = HolderUseAnimation;
	outSelectedUseAnimationRate = HandheldEquipment.UseAnimationRate;
	outSelectedHolderUseAnimationRate = HandheldEquipment.UseAnimationRate;
	if(Greater_IntInt(int(FiredWeapon.CurrentFireMode), int(0)))
	{
		BurstRateFactor = FiredWeapon.BurstRateFactor;
		if(NotEqual_NameName(BurstAnimation, 'None'))
		{
			UseInFireMode = BurstAnimation;
		}
		if(NotEqual_NameName(HolderBurstAnimation, 'None'))
		{
			HolderUseInFireMode = HolderBurstAnimation;
		}
		outSelectedUseAnimationRate = BurstRateFactor;
		outSelectedHolderUseAnimationRate = BurstRateFactor;
	}
	if(FiredWeapon.Ammo.IsLastRound())
	{
		if(NotEqual_NameName(UseLastRoundAnimation, 'None'))
		{
			outSelectedUseAnimation = UseLastRoundAnimation;
			outSelectedHolderUseAnimation = HolderUseLastRoundAnimation;
		}
		else
		{
			outSelectedUseAnimation = UseInFireMode;
			outSelectedHolderUseAnimation = HolderUseInFireMode;
		}
	}
	else
	{
		if(FiredWeapon.Ammo.NeedsReload())
		{
			if(NotEqual_NameName(UseEmptyAnimation, 'None'))
			{
				outSelectedUseAnimation = UseEmptyAnimation;
				outSelectedHolderUseAnimation = HolderUseEmptyAnimation;
			}
			else
			{
				outSelectedUseAnimation = 'None';
				outSelectedHolderUseAnimation = 'None';
			}
		}
		else
		{
			outSelectedUseAnimation = UseInFireMode;
			outSelectedHolderUseAnimation = HolderUseInFireMode;
		}
	}
	return;
}

function PostTakeDamage(int Damage, Pawn InstigatedBy, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType)
{
	local Vector Impulse;

	super(Actor).PostTakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType);
	if(EqualEqual_IntInt(int(Physics), int(15)))
	{
		if(Less_FloatFloat(VSize(Momentum), 0.0010000))
		{
			return;
		}
		Impulse = Multiply_VectorFloat(Normal(Momentum), FClamp(VSize(Momentum), 0.0000000, 75.0000000));
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("Applying impulse to FiredWeaponModel ", string(Name)), ": "), string(Impulse)), " at location "), string(HitLocation)));
		HavokImpartImpulse(Impulse, HitLocation);
	}
	return;
}

defaultproperties
{
	HavokDataClass=Class'Engine.DefaultFiredWeaponModelHavokParams'
}