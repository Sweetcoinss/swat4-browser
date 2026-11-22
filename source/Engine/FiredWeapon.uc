class FiredWeapon extends Weapon implements DamageType
	native
	config(SwatEquipment)
	notplaceable
	hidecategories(Karma);

cpptext
{
    UBOOL IsFlashlightInitialized();
    UBOOL IsFlashlightOn();
    UBOOL IsFlashlightProjectionVisible();
    void  FlashlightProjectionLineCheck(FCheckResult & Hit, const FVector & End, const FVector & Start);
    static void ApplyRandomOffsetToRotation(const FRotator & OriginalRotation, float OffsetHalfAngleRadians, FRotator & NewRotation);

}

const FLASHLIGHT_TEXTURE_INDEX = 1;
const kFlashlightProjection_NumTestsPerSecond = 10;
const kFlashlightProjection_FailureTimeout = 1.0;
const kFlashlightProjection_ConeAnglePercent = 0.75;
const kFlashlightProjection_BrightnessAlphaLerpTime = 0.2;

enum AimPenaltyType
{
	AimPenalty_Equip,               // 0
	AimPenalty_StandToWalk,         // 1
	AimPenalty_WalkToRun,           // 2
	AimPenalty_TakeDamage,          // 3
	AimPenalty_Fire                 // 4
};

enum FireMode
{
	FireMode_Single,                // 0
	FireMode_Burst,                 // 1
	FireMode_Auto                   // 2
};

struct native EnemyAmmo
{
	var config string AmmoClass;
	var config int Chance;
	var Class<Ammunition> LoadedAmmoClass;
};

var config array<string> PlayerAmmoOption;
var config array<EnemyAmmo> EnemyUsesAmmo;
var Class<Ammunition> AmmoClass;
var Ammunition Ammo;
var config Vector ThirdPersonFireOffset;
var config float MuzzleVelocity;
var config bool bCanShootThroughGlass;
var config bool bAimAtHead;
var private float NextFireTime;
var private HandheldEquipment.ActionStatus ReloadingStatus;
var config float ReloadAnimationRate;
var private float aimerror;
var private float PendingAimErrorPenalty;
var config float MaxAimError;
var config float SmallAimErrorRecoveryRate;
var config float LargeAimErrorRecoveryRate;
var config float AimErrorBreakingPoint;
var float LookAimErrorQuantizationFactor;
var config float LookAimErrorPenaltyFactor;
var config float MaxLookAimErrorPenalty;
var config float InjuredAimErrorPenalty;
var config float MaxInjuredAimErrorPenalty;
var config float DamagedAimErrorPenalty;
var config float EquippedAimErrorPenalty;
var config float FiredAimErrorPenalty;
var config float WalkToRunAimErrorPenalty;
var config float StandToWalkAimErrorPenalty;
var config float StandingAimError;
var config float WalkingAimError;
var config float RunningAimError;
var config float CrouchingAimError;
var config float RecoilBackDuration;
var config float RecoilForeDuration;
var config float RecoilMagnitude;
var config float AutoFireRecoilMagnitudeIncrement;
var config bool DebugPerfectAim;
var config bool DebugDrawTraceFire;
var config bool DebugDrawAccuracyCone;
var private config bool HasAttachedFlashlight;
var private config Vector FlashlightPosition_1stPerson;
var private config Rotator FlashlightRotation_1stPerson;
var private config Vector FlashlightPosition_3rdPerson;
var private config Rotator FlashlightRotation_3rdPerson;
var private bool FlashlightProjection_IsInitializing;
var private name FlashlightProjection_StartBoneName;
var private float FlashlightProjection_LastTestTime;
var private bool FlashlightProjection_LastTestResult;
var private Vector FlashlightProjection_LastTestSuccessfulHitLocation;
var private float FlashlightProjection_LastSuccessfulTestTime;
var private float FlashlightProjection_CurrentBrightnessAlpha;
var private config Class<Light> FlashlightSpotLightClass;
var private config Class<Light> FlashlightPointLightClass;
var private config Class<Light> FlashlightCoronaLightClass;
var private config float PointLightDistanceFraction;
var private config float PointLightRadiusScale;
var private config float PointLightDistanceFadeRate;
var private Light FlashlightDynamicLight;
var private Actor FlashlightReferenceActor;
var config bool DebugDrawFlashlightDir;
var config int FlashlightUseFancyLights;
var config float MinFlashlightBrightness;
var config float MinFlashlightRadius;
var config float FlashlightFirstPersonDistance;
var config float MaxFlashlightDistance;
var config float ThirdPersonFlashlightRadiusPenalty;
var private bool bHighEndGraphicsBoard;
var private float BaseFlashlightBrightness;
var private float BaseFlashlightRadius;
var config array<FiredWeapon.FireMode> AvailableFireMode;
var FiredWeapon.FireMode CurrentFireMode;
var int FireModeIndex;
var private config int BurstShotCount;
var private int BurstShotsRemaining;
var config float BurstRateFactor;
var private int AutoFireShotIndex;
var private bool PerfectAimNextShot;
var private config float RagdollDeathImpactMomentumMultiplier;
var private config float OverrideArmDamageModifier;

simulated function PreBeginPlay()
{
	super(Actor).PreBeginPlay();
	AssertWithDescription(Greater_FloatFloat(MuzzleVelocity, float(0)), Concat_StrStr(Concat_StrStr("[tcohen] MuzzleVelocity for the FiredWeapon ", string(Class.Name)), " is not set.  Please set it in Content/System/SwatEquipment.ini."));
	if(Greater_IntInt(AvailableFireMode.Length, 0))
	{
		FireModeIndex = 0;
		SetCurrentFireMode(AvailableFireMode[FireModeIndex]);
	}
	UpdateAimError(0.0000000);
	Disable('Tick');
	return;
}

simulated event PostNetBeginPlay()
{
	super(HandheldEquipment).PostNetBeginPlay();
	Disable('Tick');
	return;
}

simulated event Destroyed()
{
	if(IsFlashlightInitialized())
	{
		DestroyFlashlight(ICanToggleWeaponFlashlight(Owner).GetDelayBeforeFlashlightShutoff());
	}
	if(NotEqual_ObjectObject(Ammo, none))
	{
		Ammo.Destroy();
		Ammo = none;
	}
	super(HandheldEquipment).Destroyed();
	return;
}

protected simulated function bool IsHandheldEquipmentIdleHook()
{
	return AndAnd_BoolBool(EqualEqual_IntInt(int(ReloadingStatus), int(0)), IsFiredWeaponIdleHook());
	return;
}

protected simulated function bool IsFiredWeaponIdleHook()
{
	return true;
	return;
}

simulated function bool IsBeingReloaded()
{
	return NotEqual_IntInt(int(ReloadingStatus), int(0));
	return;
}

simulated function bool CanReload()
{
	if(bDeleteMe)
	{
		return false;
	}
	AssertWithDescription(NotEqual_ObjectObject(Ammo, none), Concat_StrStr(Concat_StrStr("[tcohen] FiredWeapon::CanReload() ", string(Name)), "'s Ammo is None.  Terry should fix this."));
	return Ammo.CanReload();
	return;
}

simulated function bool IsEmpty()
{
	if(EqualEqual_ObjectObject(Ammo, none))
	{
		if(bDeleteMe)
		{
			return false;
		}
		AssertWithDescription(false, Concat_StrStr(Concat_StrStr("[tcohen] FiredWeapon::IsEmpty() ", string(Name)), "'s Ammo is None.  Terry should fix this."));
	}
	return Ammo.IsEmpty();
	return;
}

simulated function bool IsFull()
{
	if(EqualEqual_ObjectObject(Ammo, none))
	{
		if(bDeleteMe)
		{
			return false;
		}
		AssertWithDescription(false, Concat_StrStr(Concat_StrStr("[tcohen] FiredWeapon::IsFull() ", string(Name)), "'s Ammo is None.  Terry should fix this."));
	}
	return Ammo.IsFull();
	return;
}

simulated function bool NeedsReload()
{
	if(EqualEqual_ObjectObject(Ammo, none))
	{
		if(bDeleteMe)
		{
			return false;
		}
		AssertWithDescription(false, Concat_StrStr(Concat_StrStr("[tcohen] FiredWeapon::NeedsReload() ", string(Name)), "'s Ammo is None.  Terry should fix this."));
	}
	return Ammo.NeedsReload();
	return;
}

simulated event GetPerfectFireStart(out Vector outLocation, out Rotator outDirection)
{
	local Actor Junk;
	local Coords WeaponCoords;
	local bool InstigatorIsConscious;

	if(Instigator.IsA('SwatPlayer'))
	{
		InstigatorIsConscious = Class'Engine.Pawn'.static.checkConscious(Instigator);
		if(InstigatorIsConscious)
		{
			if(NotEqual_ObjectObject(Pawn(Owner).Controller, none))
			{
				PlayerController(Pawn(Owner).Controller).PlayerCalcView(Junk, outLocation, outDirection);
			}
			else
			{
				outLocation = Instigator.GetThirdPersonEyesLocation();
				outDirection = Instigator.GetAimRotation();
			}
		}
		else
		{
			WeaponCoords = Pawn(Owner).GetBoneCoords('GripRHand', true);
			outLocation = WeaponCoords.Origin;
			outDirection = Rotator(Subtract_PreVector(WeaponCoords.YAxis));
		}
	}
	else
	{
		if(Instigator.IsA('SwatAI'))
		{
			outLocation = Instigator.GetAimOrigin();
			outDirection = Instigator.GetAimRotation();
		}
		else
		{
			AssertWithDescription(false, Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] ", string(Class.Name)), " was called to GetFireStart(), but Instigator ("), string(Instigator)), ") is not a SwatAI nor a SwatPlayer.  \"Wha' happened?\""));
		}
	}
	return;
}

simulated function TraceFire()
{
	local Vector PerfectStartLocation, StartLocation;
	local Rotator PerfectStartDirection, StartDirection;
	local Vector StartTrace, EndTrace;
	local PlayerController LocalPlayerController;
	local int Shot;

	GetPerfectFireStart(PerfectStartLocation, PerfectStartDirection);
	Shot = 0;
	J0x17:

	if(Less_IntInt(Shot, Ammo.ShotsPerRound))
	{
		StartLocation = PerfectStartLocation;
		StartDirection = PerfectStartDirection;
		ApplyAimError(StartDirection);
		StartTrace = StartLocation;
		EndTrace = Add_VectorVector(StartLocation, Multiply_VectorFloat(Vector(StartDirection), float(Range)));
		BallisticFire(StartTrace, EndTrace);
		AddAdd_PreInt(Shot);
		// [Loop Continue]
		goto J0x17;
	}
	PerfectAimNextShot = false;
	LocalPlayerController = Level.GetLocalPlayerController();
	if(EqualEqual_ObjectObject(Pawn(Owner).Controller, LocalPlayerController))
	{
		if(EqualEqual_IntInt(int(CurrentFireMode), int(2)))
		{
			LocalPlayerController.AddRecoil(RecoilBackDuration, RecoilForeDuration, RecoilMagnitude, AutoFireRecoilMagnitudeIncrement, AutoFireShotIndex);
		}
		else
		{
			LocalPlayerController.AddRecoil(RecoilBackDuration, RecoilForeDuration, RecoilMagnitude);
		}
	}
	return;
}

simulated function SetPerfectAimNextShot()
{
	PerfectAimNextShot = true;
	return;
}

simulated function ApplyAimError(out Rotator FireDirection)
{
	local Rotator OriginalFireDirection, NewFireDirection;

	OriginalFireDirection = FireDirection;
	ApplyRandomOffsetToRotation(OriginalFireDirection, Multiply_FloatFloat(aimerror, 0.0174533), NewFireDirection);
	FireDirection = NewFireDirection;
	return;
}

// Export UFiredWeapon::execApplyRandomOffsetToRotation(FFrame&, void* const)
native function ApplyRandomOffsetToRotation(Rotator OriginalRotation, float OffsetHalfAngleRadians, out Rotator NewRotation);

simulated function BallisticFire(Vector StartTrace, Vector EndTrace)
{
	local Vector HitLocation, HitNormal, ExitLocation, ExitNormal;
	local Actor Victim;
	local Material HitMaterial, ExitMaterial;
	local float Momentum;
	local Actor.ESkeletalRegion HitRegion;

	Momentum = Multiply_FloatFloat(MuzzleVelocity, Ammo.Mass);
	if(Level.AnalyzeBallistics)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[BALLISTICS] BallisticFire(): Weapon ", string(Name)), ", shot by "), string(Owner.Name)), ", has MuzzleVelocity="), string(MuzzleVelocity)), ", Ammo "), string(Ammo.Name)), " has Mass="), string(Ammo.Mass)), ".  Initial Momentum is "), string(Momentum)), "."));
	}
	foreach TraceActors(Class'Engine.Actor', Victim, HitLocation, HitNormal, HitMaterial, EndTrace, StartTrace,, true, HitRegion, true, true, ExitLocation, ExitNormal, ExitMaterial)
	{
		if(Not_PreBool(HandleBallisticImpact(Victim, HitLocation, HitNormal, Normal(Subtract_VectorVector(HitLocation, StartTrace)), HitMaterial, HitRegion, Momentum, ExitLocation, ExitNormal, ExitMaterial)))
		{
			break;
		}
	}
	return;
}

simulated function DealDamage(Actor Victim, int Damage, Pawn Instigator, Vector HitLocation, Vector MomentumVector, Class<DamageType> DamageType)
{
	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Client)))
	{
		return;
	}
	if(OrOr_BoolBool(EqualEqual_ObjectObject(Pawn(Owner), none), EqualEqual_ObjectObject(Pawn(Owner).Controller, none)))
	{
		return;
	}
	Victim.TakeDamage(Damage, Pawn(Owner), HitLocation, MomentumVector, DamageType);
	return;
}

simulated function bool HandleBallisticImpact(Actor Victim, Vector HitLocation, Vector HitNormal, Vector NormalizedBulletDirection, Material HitMaterial, Actor.ESkeletalRegion HitRegion, out float Momentum, Vector ExitLocation, Vector ExitNormal, Material ExitMaterial)
{
	local float MomentumToPenetrateVictim, MomentumLostToVictim;
	local Vector MomentumVector;
	local bool PenetratesVictim;
	local int Damage;
	local SkeletalRegionInformation SkeletalRegionInformation;
	local ProtectiveEquipment Protection;
	local float DamageModifier, ExternalDamageModifier, LimbInjuryAimErrorPenalty;
	local IHaveSkeletalRegions SkelVictim;
	local Pawn PawnVictim;

	if(AndAnd_BoolBool(OrOr_BoolBool(Victim.bHidden, EqualEqual_IntInt(int(Victim.DrawType), int(0))), Not_PreBool(Victim.IsA('LevelInfo'))))
	{
		if(Level.AnalyzeBallistics)
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("BallisticFire: Skipping bHidden=true Victim ", string(Victim.Name)), " of class "), string(Victim.Class.Name)));
		}
		return true;
	}
	if(Victim.IsA('SwatDoor'))
	{
		return true;
	}
	if(AndAnd_BoolBool(Owner.IsA('SwatOfficer'), OrOr_BoolBool(Victim.IsA('SwatOfficer'), AndAnd_BoolBool(Victim.IsA('SwatPlayer'), Not_PreBool(Pawn(Owner).IsAttackingPlayer())))))
	{
		if(Level.AnalyzeBallistics)
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("BallisticFire: Skipping Victim ", string(Victim.Name)), " of class "), string(Victim.Class.Name)), " because officers shouldn't hit other friendly officers/players"));
		}
		return false;
	}
	if(OrOr_BoolBool(AndAnd_BoolBool(Victim.bHighDetail, EqualEqual_IntInt(int(Level.DetailMode), int(0))), AndAnd_BoolBool(Victim.bSuperHighDetail, NotEqual_IntInt(int(Level.DetailMode), int(2)))))
	{
		if(Level.AnalyzeBallistics)
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("BallisticFire: Skipping Victim ", string(Victim.Name)), " of class "), string(Victim.Class.Name)), " because Level.DetailMode="), string(GetEnum(Enum'Engine.Actor.EDetailMode', int(Level.DetailMode)))), " and Victim.bHighDetail="), string(Victim.bHighDetail)), " and Victim.bSuperHighDetail="), string(Victim.bSuperHighDetail)));
		}
		return true;
	}
	Ammo.SetLocation(HitLocation);
	Ammo.SetRotation(Rotator(HitNormal));
	if(EqualEqual_IntInt(int(Victim.DrawType), int(2)))
	{
		HitMaterial = Victim.GetCurrentMaterial(0);
		ExitMaterial = HitMaterial;
		if(AndAnd_BoolBool(NotEqual_IntInt(int(HitRegion), int(0)), Victim.IsA('IHaveSkeletalRegions')))
		{
			if(Victim.IsA('ICanUseProtectiveEquipment'))
			{
				SkeletalRegionInformation = ICanUseProtectiveEquipment(Victim).GetSkeletalRegionInformation(HitRegion);
				Protection = ICanUseProtectiveEquipment(Victim).GetSkeletalRegionProtection(HitRegion);
				if(NotEqual_ObjectObject(Protection, none))
				{
					Ammo.TriggerEffectEvent('BulletHit', Protection, HitMaterial);
					if(Not_PreBool(HandleProtectiveEquipmentBallisticImpact(Victim, Protection, HitRegion, HitLocation, HitNormal, NormalizedBulletDirection, Momentum)))
					{
						return false;
					}
				}
			}
		}
	}
	if(EqualEqual_ObjectObject(HitMaterial, none))
	{
		if(Level.AnalyzeBallistics)
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[WARNING!!] BallisticFire: Trace hit Victim ", string(Victim)), " of class "), string(Victim.Class.Name)), ", HitMaterial is None, treating as if no momentum required to penetrate."));
		}
		MomentumLostToVictim = 0.0000000;
	}
	else
	{
		if(OrOr_BoolBool(EqualEqual_NameName(Victim.Class.Name, 'LevelInfo'), Ammo.RoundsNeverPenetrate))
		{
			MomentumToPenetrateVictim = Momentum;
			MomentumLostToVictim = Momentum;
		}
		else
		{
			MomentumToPenetrateVictim = Victim.GetMomentumToPenetrate(HitLocation, HitNormal, HitMaterial);
			MomentumLostToVictim = FMin(Momentum, MomentumToPenetrateVictim);
		}
	}
	PenetratesVictim = Less_FloatFloat(MomentumLostToVictim, Momentum);
	Damage = int(Multiply_FloatFloat(MomentumLostToVictim, Level.GetRepo().MomentumToDamageConversionFactor));
	MomentumVector = Multiply_VectorFloat(NormalizedBulletDirection, MomentumLostToVictim);
	if(PenetratesVictim)
	{
		MultiplyEqual_VectorFloat(MomentumVector, Level.GetRepo().MomentumImpartedOnPenetrationFraction);
	}
	if(Not_PreBool(PenetratesVictim))
	{
		AddEqual_IntInt(Damage, Ammo.InternalDamage);
	}
	ExternalDamageModifier = Level.GetRepo().GetExternalDamageModifier(Owner, Victim);
	Damage = int(Multiply_FloatFloat(float(Damage), ExternalDamageModifier));
	if(AndAnd_BoolBool(AndAnd_BoolBool(Greater_IntInt(Damage, 0), NotEqual_ObjectObject(SkeletalRegionInformation, none)), Victim.IsA('Pawn')))
	{
		DamageModifier = RandRange(SkeletalRegionInformation.DamageModifier.Min, SkeletalRegionInformation.DamageModifier.Max);
		if(AndAnd_BoolBool(NotEqual_FloatFloat(OverrideArmDamageModifier, float(0)), OrOr_BoolBool(EqualEqual_IntInt(int(HitRegion), int(3)), EqualEqual_IntInt(int(HitRegion), int(4)))))
		{
			DamageModifier = OverrideArmDamageModifier;
		}
		MultiplyEqual_IntFloat(Damage, DamageModifier);
		LimbInjuryAimErrorPenalty = RandRange(SkeletalRegionInformation.AimErrorPenalty.Min, SkeletalRegionInformation.AimErrorPenalty.Max);
		AddEqual_FloatFloat(Pawn(Victim).AccumulatedLimbInjury, LimbInjuryAimErrorPenalty);
	}
	if(OrOr_BoolBool(EqualEqual_ObjectObject(HitMaterial, none), NotEqual_IntInt(int(HitMaterial.MaterialVisualType), int(27))))
	{
		if(LessEqual_IntInt(Damage, 0))
		{
			Ammo.AddContextForNextEffectEvent('NoDamage');
		}
		Ammo.TriggerEffectEvent('BulletHit', Victim, HitMaterial);
	}
	if(Level.AnalyzeBallistics)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("[BALLISTICS]   ->  Remaining Momentum is ", string(Momentum)), ". Bullet hit Victim "), string(Victim.Name)));
		if(NotEqual_ObjectObject(HitMaterial, none))
		{
			Log(Concat_StrStr("[BALLISTICS]   ... HitMaterial = ", string(HitMaterial)));
		}
		else
		{
			Log("[BALLISTICS]   ... HitMaterial = None");
		}
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[BALLISTICS]   ... MomentumToPenetrateVictim is ", string(MomentumToPenetrateVictim)), ", so the bullet will lose "), string(MomentumLostToVictim)), " momentum to the Victim."));
		if(AndAnd_BoolBool(NotEqual_IntInt(int(HitRegion), int(0)), Victim.IsA('IHaveSkeletalRegions')))
		{
			Log(Concat_StrStr(Concat_StrStr("[BALLISTICS]   ... Victim has SkeletalRegions.  ", string(GetEnum(Enum'Engine.Actor.ESkeletalRegion', int(HitRegion)))), " was hit."));
			if(NotEqual_ObjectObject(Protection, none))
			{
				Log(Concat_StrStr(Concat_StrStr("[BALLISTICS]   ... (Region is protected by ", string(Protection.Class.Name)), ".)"));
			}
			if(AndAnd_BoolBool(NotEqual_FloatFloat(OverrideArmDamageModifier, float(0)), OrOr_BoolBool(EqualEqual_IntInt(int(HitRegion), int(3)), EqualEqual_IntInt(int(HitRegion), int(4)))))
			{
				Log(Concat_StrStr("[BALLISTICS]   ... DamageModifier from the skeletal region was overriden for this arm hit, the OverrideArmDamageModifier is: ", string(OverrideArmDamageModifier)));
			}
			else
			{
				Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[BALLISTICS]   ... DamageModifier from the skeletal region is on the Range (Min=", string(SkeletalRegionInformation.DamageModifier.Min)), ", Max="), string(SkeletalRegionInformation.DamageModifier.Max)), "), Selected "), string(DamageModifier)), "."));
			}
			Log(Concat_StrStr(Concat_StrStr("[BALLISTICS]   ... ExternalDamageModifier = ", string(ExternalDamageModifier)), "."));
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[BALLISTICS]   ... AimErrorPenalty in on Range (Min=", string(SkeletalRegionInformation.AimErrorPenalty.Min)), ", Max="), string(SkeletalRegionInformation.AimErrorPenalty.Max)), "), Selected "), string(LimbInjuryAimErrorPenalty)), "."));
			if(PenetratesVictim)
			{
				Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[BALLISTICS]   ... Victim was penetrated:          Damage = MomentumLostToVictim * MomentumToDamageConversionFactor * DamageModifier * ExternalDamageModifier = ", string(MomentumLostToVictim)), " * "), string(Level.GetRepo().MomentumToDamageConversionFactor)), " * "), string(DamageModifier)), " * "), string(ExternalDamageModifier)), " = "), string(Damage)));
			}
			else
			{
				Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[BALLISTICS]   ... Bullet was buried in Victim:    Damage = ((MomentumLostToVictim * MomentumToDamageConversionFactor) + InternalDamage) * DamageModifier * ExternalDamageModifier = ((", string(MomentumLostToVictim)), " * "), string(Level.GetRepo().MomentumToDamageConversionFactor)), ") + "), string(Ammo.InternalDamage)), ") * "), string(DamageModifier)), " * "), string(ExternalDamageModifier)), " = "), string(Damage)));
			}
		}
		else
		{
			if(PenetratesVictim)
			{
				Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[BALLISTICS]   ... Victim was penetrated:          Damage = MomentumLostToVictim * MomentumToDamageConversionFactor = ", string(MomentumLostToVictim)), " * "), string(Level.GetRepo().MomentumToDamageConversionFactor)), " = "), string(Damage)));
			}
			else
			{
				Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[BALLISTICS]   ... Bullet was buried in Victim:    Damage = (MomentumLostToVictim * MomentumToDamageConversionFactor) + InternalDamage = (", string(MomentumLostToVictim)), " * "), string(Level.GetRepo().MomentumToDamageConversionFactor)), ") + "), string(Ammo.InternalDamage)), " = "), string(Damage)));
			}
		}
	}
	SkelVictim = IHaveSkeletalRegions(Victim);
	if(NotEqual_ObjectObject(SkelVictim, none))
	{
		SkelVictim.OnSkeletalRegionHit(HitRegion, HitLocation, HitNormal, Damage, GetDamageType(), Owner);
	}
	DealDamage(Victim, Damage, Pawn(Owner), HitLocation, MomentumVector, GetDamageType());
	if(Level.AnalyzeBallistics)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("[BALLISTICS]   ... Bullet will impart to victim the momentum it lost to the victim:  ", string(VSize(MomentumVector))), " in direction "), string(Normal(MomentumVector))));
	}
	Victim.TakeHitImpulse(HitLocation, MomentumVector, GetDamageType());
	SubtractEqual_FloatFloat(Momentum, MomentumLostToVictim);
	PawnVictim = Pawn(Victim);
	if(PenetratesVictim)
	{
		Ammo.SetLocation(ExitLocation);
		Ammo.SetRotation(Rotator(ExitNormal));
		Ammo.TriggerEffectEvent('BulletExited', Victim, ExitMaterial);
	}
	if(ShouldSpawnBloodForVictim(PawnVictim, Damage))
	{
		SpawnBloodEffects(Ammo, ExitLocation, Damage, NormalizedBulletDirection);
	}
	return PenetratesVictim;
	return;
}

simulated function bool ShouldSpawnBloodForVictim(Pawn PawnVictim, int Damage)
{
	return AndAnd_BoolBool(NotEqual_ObjectObject(PawnVictim, none), Greater_IntInt(Damage, 0));
	return;
}

simulated function bool SpawnBloodEffects(Ammunition Ammo, Vector ExitLocation, int Damage, Vector direction)
{
	local int NumPools, ct;
	local Rotator BloodRot;
	local Vector X, Y, Z;

	NumPools = Add_IntInt(Rand(3), 1);
	ct = 0;
	J0x14:

	if(Less_IntInt(ct, NumPools))
	{
		BloodRot = Rotator(Subtract_PreVector(direction));
		Ammo.SetRotation(BloodRot);
		GetAxes(BloodRot, X, Y, Z);
		Ammo.SetLocation(Add_VectorVector(Add_VectorVector(ExitLocation, Multiply_VectorFloat(Y, RandRange(-5.0000000, 5.0000000))), Multiply_VectorFloat(Z, RandRange(-5.0000000, 5.0000000))));
		Ammo.TriggerEffectEvent('BloodProjected');
		AddAdd_Int(ct);
		// [Loop Continue]
		goto J0x14;
	}
	return true;
	return;
}

simulated function bool HandleProtectiveEquipmentBallisticImpact(Actor Victim, ProtectiveEquipment Protection, Actor.ESkeletalRegion HitRegion, Vector HitLocation, Vector HitNormal, Vector NormalizedBulletDirection, out float Momentum)
{
	local bool PenetratesProtection;
	local Vector MomentumVector;
	local int Damage;
	local float MomentumLostToProtection;
	local Range DamageModifierRange;
	local float DamageModifier, ExternalDamageModifier;

	PenetratesProtection = Less_FloatFloat(Protection.MomentumToPenetrate, Momentum);
	if(PenetratesProtection)
	{
		DamageModifierRange = Protection.PenetratedDamageFactor;
	}
	else
	{
		DamageModifierRange = Protection.BlockedDamageFactor;
	}
	MomentumLostToProtection = FMin(Momentum, Protection.MomentumToPenetrate);
	Damage = int(Multiply_FloatFloat(MomentumLostToProtection, Level.GetRepo().MomentumToDamageConversionFactor));
	DamageModifier = RandRange(DamageModifierRange.Min, DamageModifierRange.Max);
	MultiplyEqual_IntFloat(Damage, DamageModifier);
	ExternalDamageModifier = Level.GetRepo().GetExternalDamageModifier(Owner, Victim);
	Damage = int(Multiply_FloatFloat(float(Damage), ExternalDamageModifier));
	MomentumVector = Multiply_VectorFloat(NormalizedBulletDirection, Protection.MomentumToPenetrate);
	if(PenetratesProtection)
	{
		MultiplyEqual_VectorFloat(MomentumVector, Level.GetRepo().MomentumImpartedOnPenetrationFraction);
	}
	if(Level.AnalyzeBallistics)
	{
		Log(Concat_StrStr(Concat_StrStr("[BALLISTICS]   ->  Remaining Momentum is ", string(Momentum)), "."));
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("[BALLISTICS]   ... Bullet hit ", string(Protection.Class.Name)), " ProtectiveEquipment on Victim "), string(Victim.Name)));
		Log(Concat_StrStr(Concat_StrStr("[BALLISTICS]   ... Protection.MomentumToPenetrate is ", string(Protection.MomentumToPenetrate)), "."));
		if(PenetratesProtection)
		{
			Log("[BALLISTICS]   ... The ProtectiveEquipment was penetrated.  Using PenetratedDamageFactor.");
		}
		else
		{
			Log("[BALLISTICS]   ... Bullet was buried in the ProtectiveEquipment  Using BlockedDamageFactor.");
		}
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[BALLISTICS]   ... DamageModifier is on the Range (Min=", string(DamageModifierRange.Min)), ", Max="), string(DamageModifierRange.Max)), "), selected "), string(DamageModifier)), "."));
		Log(Concat_StrStr(Concat_StrStr("[BALLISTICS]   ... ExternalDamageModifier = ", string(ExternalDamageModifier)), "."));
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[BALLISTICS]   ... Damage = MomentumLostToProtection * MomentumToDamageConversionFactor * DamageModifier * ExternalDamageModifier = ", string(MomentumLostToProtection)), " * "), string(Level.GetRepo().MomentumToDamageConversionFactor)), " * "), string(DamageModifier)), " * "), string(ExternalDamageModifier)), " = "), string(Damage)));
	}
	IHaveSkeletalRegions(Victim).OnSkeletalRegionHit(HitRegion, HitLocation, HitNormal, Damage, GetDamageType(), Owner);
	DealDamage(Victim, Damage, Pawn(Owner), HitLocation, MomentumVector, GetDamageType());
	SubtractEqual_FloatFloat(Momentum, Protection.MomentumToPenetrate);
	return PenetratesProtection;
	return;
}

function Class<DamageType> GetDamageType()
{
	return Class;
	return;
}

function OnGivenToOwner()
{
	super(Equipment).OnGivenToOwner();
	AssertWithDescription(EqualEqual_ObjectObject(Ammo, none), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] ", string(Name)), " was just given to "), string(Owner)), ", but it already has Ammo."));
	Instigator = Pawn(Owner);
	if(EqualEqual_ObjectObject(AmmoClass, none))
	{
		SelectAmmoClass();
	}
	Ammo = Spawn(AmmoClass, self);
	AssertWithDescription(NotEqual_ObjectObject(Ammo, none), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] The FiredWeapon ", string(Name)), " (owned by "), string(Owner.Name)), ") failed to spawn its Ammunition of class "), string(AmmoClass)), "."));
	Ammo.Initialize();
	return;
}

function SelectAmmoClass()
{
	local int TotalChance, RandChance, AccumulatedChance, i;

	AssertWithDescription(Greater_IntInt(EnemyUsesAmmo.Length, 0), Concat_StrStr(Concat_StrStr("[tcohen] The FiredWeapon ", string(Class.Name)), " was trying to SelectAmmoClass(), but there are no EnemyUsesAmmo options for that FiredWeapon.  Please provide at least one EnemyUsesAmmo for that FiredWeapon in SwatEquipment.ini."));
	i = 0;
	J0xFB:

	if(Less_IntInt(i, EnemyUsesAmmo.Length))
	{
		AddEqual_IntInt(TotalChance, EnemyUsesAmmo[i].Chance);
		EnemyUsesAmmo[i].LoadedAmmoClass = Class<Ammunition>(DynamicLoadObject(EnemyUsesAmmo[i].AmmoClass, Class'Core.Class'));
		AssertWithDescription(NotEqual_ObjectObject(EnemyUsesAmmo[i].LoadedAmmoClass, none), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] In the FiredWeapon ", string(Class.Name)), ", EnemyUsesAmmo option #"), string(i)), " (base zero) specifies AmmoClass "), EnemyUsesAmmo[i].AmmoClass), ", but that class is invalid.  This is configured in SwatEquipment.ini."));
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0xFB;
	}
	RandChance = Rand(TotalChance);
	i = 0;
	J0x260:

	if(Less_IntInt(i, EnemyUsesAmmo.Length))
	{
		AddEqual_IntInt(AccumulatedChance, EnemyUsesAmmo[i].Chance);
		if(GreaterEqual_IntInt(AccumulatedChance, RandChance))
		{
			AmmoClass = EnemyUsesAmmo[i].LoadedAmmoClass;
			return;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x260;
	}
	assert(false);
	return;
}

final simulated function Reload()
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---FiredWeapon::Reload()."));
	}
	ValidateReload();
	PreReload();
	GotoState('BeingReloaded');
	return;
}

simulated function PreReload()
{
	ReloadingStatus = 1;
	return;
}

final latent simulated function LatentReload()
{
	if(Owner.IsA('SwatAI'))
	{
		Pawn(Owner).AIInterruptEquipment();
		if(Not_PreBool(IsIdle()))
		{
			AIInterrupt();
		}
	}
	ValidateReload();
	if(Level.IsCOOPServer)
	{
		NotifyClientsToDoAIReload();
	}
	PreReload();
	DoReloading();
	return;
}

function NotifyClientsToDoAIReload()
{
	local Controller i, theLocalPlayerController;
	local PlayerController Current;

	assert(Level.IsCOOPServer);
	theLocalPlayerController = Level.GetLocalPlayerController();
	i = Level.ControllerList;
	J0x3B:

	if(NotEqual_ObjectObject(i, none))
	{
		Current = PlayerController(i);
		if(AndAnd_BoolBool(NotEqual_ObjectObject(Current, none), NotEqual_ObjectObject(Current, theLocalPlayerController)))
		{
			Current.ClientDoAIReload(Pawn(Owner));
		}
		i = i.nextController;
		// [Loop Continue]
		goto J0x3B;
	}
	return;
}

simulated function bool PrevalidateReload()
{
	assert(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)));
	return ValidateReload(true);
	return;
}

simulated function bool ValidateReload(optional bool Prevalidate)
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---FiredWeapon::ValidateReload()."));
	}
	if(Not_PreBool(Prevalidate))
	{
		if(Not_PreBool(IsEquipped()))
		{
			AssertWithDescription(false, Concat_StrStr(Concat_StrStr("[tcohen] The HandheldEquipment ", string(Name)), " was called to Reload().  But it doesn't think it is equipped."));
		}
		if(Not_PreBool(IsIdle()))
		{
			AssertWithDescription(false, Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] The HandheldEquipment ", string(Name)), " was called to Reload(), but it is busy doing something else. (EquippingStatus="), string(EquippingStatus)), ", UnequippingStatus="), string(UnequippingStatus)), ", UsingStatus="), string(UsingStatus)), ", ReloadingStatus="), string(ReloadingStatus)), ")"));
		}
	}
	return AndAnd_BoolBool(IsEquipped(), IsIdle());
	return;
}

simulated function string HandheldEquipmentStatusString()
{
	local string Result;

	Result = Concat_StrStr(", ReloadingStatus=", string(ReloadingStatus));
	return Result;
	return;
}

private latent simulated function DoReloading()
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---FiredWeapon::DoReloading()."));
	}
	if(NotEqual_ObjectObject(FirstPersonModel, none))
	{
		FiredWeaponModel(FirstPersonModel).PlayReload();
	}
	if(NotEqual_ObjectObject(ThirdPersonModel, none))
	{
		FiredWeaponModel(ThirdPersonModel).PlayReload();
	}
	if(NotEqual_ObjectObject(FirstPersonModel, none))
	{
		FiredWeaponModel(FirstPersonModel).FinishReload();
	}
	if(NotEqual_ObjectObject(ThirdPersonModel, none))
	{
		FiredWeaponModel(ThirdPersonModel).FinishReload();
	}
	ReloadingStatus = 0;
	if(NotEqual_ObjectObject(GetHands(), none))
	{
		GetHands().IdleHoldingEquipment();
	}
	Pawn(Owner).OnReloadingFinished();
	return;
}

final simulated function OnReloadKeyFrame()
{
	if(EqualEqual_IntInt(int(ReloadingStatus), int(1)))
	{
		FiredWeaponModel(ThirdPersonModel).OnReloadKeyFrame();
		if(NotEqual_ObjectObject(GetHands(), none))
		{
			FiredWeaponModel(FirstPersonModel).OnReloadKeyFrame();
		}
		Ammo.OnReloaded();
		ReloadedHook();
		ReloadingStatus = 2;
	}
	return;
}

simulated function ReloadedHook()
{
	return;
}

simulated function PreUse()
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---FiredWeapon::PreUse()."));
	}
	super(HandheldEquipment).PreUse();
	if(EqualEqual_IntInt(int(CurrentFireMode), int(2)))
	{
		AutoFireShotIndex = 0;
		Pawn(Owner).OnAutoFireStarted();
	}
	return;
}

protected latent simulated function DoUsingHook()
{
	DoFiring();
	return;
}

private latent simulated function DoFiring()
{
	if(Pawn(Owner).IsControlledByLocalHuman())
	{
		Pawn(Owner).ServerBeginFiringWeapon(GetSlot());
	}
	else
	{
		if(AndAnd_BoolBool(Level.IsCOOPServer, Owner.IsA('SwatAI')))
		{
			NotifyClientsAIBeginFiringWeapon();
		}
	}
	BeginFiring();
	Pawn(Owner).OnUsingBegan();
	switch(CurrentFireMode)
	{
		case 0:
			break;
		case 1:
			BurstShotsRemaining = BurstShotCount;
			break;
		case 2:
			break;
		default:
			assert(false);
			break;
	}
	J0xAD:

	Fire();
	if(!(OrOr_BoolBool(Not_PreBool(WantsToContinueFiring()), Ammo.NeedsReload())))
		goto J0xAD;
	if(AndAnd_BoolBool(AndAnd_BoolBool(EqualEqual_IntInt(int(CurrentFireMode), int(2)), Level.IsCOOPServer), Owner.IsA('SwatAI')))
	{
		NotifyClientsAIEndFiringWeapon();
	}
	Pawn(Owner).OnUsingFinished();
	EndFiring();
	return;
}

latent simulated function BeginFiring()
{
	return;
}

latent simulated function EndFiring()
{
	return;
}

function NotifyClientsAIBeginFiringWeapon()
{
	local Controller i, theLocalPlayerController;
	local PlayerController Current;

	assert(Level.IsCOOPServer);
	theLocalPlayerController = Level.GetLocalPlayerController();
	i = Level.ControllerList;
	J0x3B:

	if(NotEqual_ObjectObject(i, none))
	{
		Current = PlayerController(i);
		if(AndAnd_BoolBool(NotEqual_ObjectObject(Current, none), NotEqual_ObjectObject(Current, theLocalPlayerController)))
		{
			Current.ClientAIBeginFiringWeapon(Pawn(Owner), int(CurrentFireMode));
		}
		i = i.nextController;
		// [Loop Continue]
		goto J0x3B;
	}
	return;
}

function NotifyClientsAIEndFiringWeapon()
{
	local Controller i, theLocalPlayerController;
	local PlayerController Current;

	assert(Level.IsCOOPServer);
	theLocalPlayerController = Level.GetLocalPlayerController();
	i = Level.ControllerList;
	J0x3B:

	if(NotEqual_ObjectObject(i, none))
	{
		Current = PlayerController(i);
		if(AndAnd_BoolBool(NotEqual_ObjectObject(Current, none), NotEqual_ObjectObject(Current, theLocalPlayerController)))
		{
			Current.ClientAIEndFiringWeapon(Pawn(Owner));
		}
		i = i.nextController;
		// [Loop Continue]
		goto J0x3B;
	}
	return;
}

private simulated function bool WantsToContinueFiring()
{
	switch(CurrentFireMode)
	{
		case 0:
			return false;
		case 1:
			return Greater_IntInt(BurstShotsRemaining, 0);
		case 2:
			return Pawn(Owner).WantsToContinueAutoFiring();
		default:
			assert(false);
			return false;
			break;
	}
	return;
}

private latent simulated function Fire()
{
	local HandheldEquipmentModel EffectsSource;
	local Pawn OtherForEffectEvents;
	local float TweenTime;
	local Pawn PawnOwner;
	local name EffectSubsystemToIgnore;

	if(InFirstPersonView())
	{
		EffectsSource = FirstPersonModel;
		if(FirstPersonModel.bOwnerNoSee)
		{
			EffectSubsystemToIgnore = 'VisualEffectsSubsystem';
		}
	}
	else
	{
		EffectsSource = ThirdPersonModel;
	}
	PawnOwner = Pawn(Owner);
	if(Less_FloatFloat(EffectsSource.LastRenderTime, Subtract_FloatFloat(Level.TimeSeconds, 1.0000000)))
	{
		OtherForEffectEvents = PawnOwner;
	}
	TweenTime = PawnOwner.GetFireTweenTime();
	if(NotEqual_ObjectObject(FirstPersonModel, none))
	{
		FirstPersonModel.PlayUse(TweenTime);
	}
	if(NotEqual_ObjectObject(ThirdPersonModel, none))
	{
		ThirdPersonModel.PlayUse(TweenTime);
	}
	PreRoundUsed();
	if(Not_PreBool(NeedsReload()))
	{
		if(Greater_FloatFloat(TweenTime, float(0)))
		{
			Sleep(TweenTime);
		}
		TraceFire();
		Ammo.OnRoundUsed();
		if(EqualEqual_IntInt(int(CurrentFireMode), int(1)))
		{
			SubtractSubtract_Int(BurstShotsRemaining);
		}
		else
		{
			if(EqualEqual_IntInt(int(CurrentFireMode), int(2)))
			{
				AddAdd_Int(AutoFireShotIndex);
			}
		}
		AddAimError(4);
		if(NotEqual_ObjectObject(EffectsSource, none))
		{
			if(EqualEqual_IntInt(int(CurrentFireMode), int(0)))
			{
				EffectsSource.TriggerEffectEvent('Fired', OtherForEffectEvents,,,, NotEqual_ObjectObject(OtherForEffectEvents, none),,,, EffectSubsystemToIgnore);
			}
			else
			{
				EffectsSource.TriggerEffectEvent('BurstFired', OtherForEffectEvents,,,, NotEqual_ObjectObject(OtherForEffectEvents, none),,,, EffectSubsystemToIgnore);
			}
		}
	}
	else
	{
		if(NotEqual_ObjectObject(EffectsSource, none))
		{
			EffectsSource.TriggerEffectEvent('EmptyFired', OtherForEffectEvents,,,, NotEqual_ObjectObject(OtherForEffectEvents, none),,,, EffectSubsystemToIgnore);
			if(AndAnd_BoolBool(OrOr_BoolBool(EqualEqual_IntInt(int(Level.NetMode), int(NM_DedicatedServer)), EqualEqual_IntInt(int(Level.NetMode), int(NM_ListenServer))), NotEqual_ObjectObject(Pawn(Owner), none)))
			{
				Pawn(Owner).BroadcastEmptyFiredToClients();
			}
		}
	}
	if(NotEqual_ObjectObject(FirstPersonModel, none))
	{
		FirstPersonModel.FinishUse();
	}
	if(NotEqual_ObjectObject(ThirdPersonModel, none))
	{
		ThirdPersonModel.FinishUse();
	}
	PostRoundUsed();
	return;
}

latent simulated function PreRoundUsed()
{
	return;
}

latent simulated function PostRoundUsed()
{
	return;
}

simulated function NextFireMode()
{
	local FiredWeapon.FireMode NewFireMode;

	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---FiredWeapon::NextFireMode()."));
	}
	if(EqualEqual_IntInt(AvailableFireMode.Length, 0))
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog("...1");
		}
		return;
	}
	AddAdd_Int(FireModeIndex);
	if(GreaterEqual_IntInt(FireModeIndex, AvailableFireMode.Length))
	{
		FireModeIndex = 0;
	}
	NewFireMode = AvailableFireMode[FireModeIndex];
	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Client)))
	{
		Pawn(Owner).ServerSetCurrentFireMode(GetSlot(), NewFireMode);
	}
	SetCurrentFireMode(NewFireMode);
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog("...2");
	}
	return;
}

simulated function bool HasFireMode(FiredWeapon.FireMode TestFireMode)
{
	local int i;

	if(EqualEqual_IntInt(AvailableFireMode.Length, 0))
	{
		return EqualEqual_IntInt(int(TestFireMode), int(0));
	}
	i = 0;
	J0x21:

	if(Less_IntInt(i, AvailableFireMode.Length))
	{
		if(EqualEqual_IntInt(int(TestFireMode), int(AvailableFireMode[i])))
		{
			return true;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x21;
	}
	return false;
	return;
}

simulated function SetCurrentFireMode(FiredWeapon.FireMode NewFireMode)
{
	if(EqualEqual_IntInt(int(CurrentFireMode), int(NewFireMode)))
	{
		return;
	}
	CurrentFireMode = NewFireMode;
	AssertWithDescription(HasFireMode(NewFireMode), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] The ", string(Class.Name)), " FiredWeapon, Owned by "), string(Owner.Name)), " was called to SetCurrentFireMode() to "), string(GetEnum(Enum'Engine.FiredWeapon.FireMode', int(NewFireMode)))), ".  But that FiredWeapon doesn't support that FireMode."));
	TriggerEffectEvent('FireModeChanged', Owner,,,, true);
	Pawn(Owner).OnFireModeChanged();
	return;
}

simulated function FiredWeapon.FireMode GetCurrentFireMode()
{
	return CurrentFireMode;
	return;
}

simulated function EquippedHook()
{
	AddAimError(0);
	Enable('Tick');
	UpdateFlashlightState();
	return;
}

simulated function UnequippedHook()
{
	Disable('Tick');
	if(IsFlashlightOn())
	{
		DestroyFlashlight(ICanToggleWeaponFlashlight(Owner).GetDelayBeforeFlashlightShutoff());
	}
	return;
}

// Export UFiredWeapon::execGetBaseAimError(FFrame&, void* const)
native simulated function float GetBaseAimError();

simulated function AddAimError(FiredWeapon.AimPenaltyType Penalty)
{
	switch(Penalty)
	{
		case 0:
			AddEqual_FloatFloat(PendingAimErrorPenalty, EquippedAimErrorPenalty);
			break;
		case 1:
			AddEqual_FloatFloat(PendingAimErrorPenalty, StandToWalkAimErrorPenalty);
			break;
		case 2:
			AddEqual_FloatFloat(PendingAimErrorPenalty, WalkToRunAimErrorPenalty);
			break;
		case 3:
			AddEqual_FloatFloat(PendingAimErrorPenalty, DamagedAimErrorPenalty);
			break;
		case 4:
			AddEqual_FloatFloat(PendingAimErrorPenalty, FiredAimErrorPenalty);
			break;
		default:
			assert(false);
			break;
	}
	return;
}

simulated function float GetAimError()
{
	return aimerror;
	return;
}

simulated function Tick(float dTime)
{
	super(Actor).Tick(dTime);
	if(IsFlashlightOn())
	{
		UpdateFlashlightLighting(dTime);
	}
	if(Class'Engine.Pawn'.static.checkDead(Pawn(Owner)))
	{
		Disable('Tick');
		return;
	}
	if(Not_PreBool(IsEquipped()))
	{
		AssertWithDescription(false, Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] ", string(Class.Name)), ", owned by "), string(Owner)), " is Tick()ing, but it is not Equipped."));
	}
	UpdateAimError(dTime);
	return;
}

simulated function UpdateAimError(float dTime)
{
	local float AimErrorRecoveryRate, TargetAimError;

	TargetAimError = Add_FloatFloat(GetBaseAimError(), PendingAimErrorPenalty);
	PendingAimErrorPenalty = 0.0000000;
	if(Greater_FloatFloat(aimerror, TargetAimError))
	{
		if(Greater_FloatFloat(aimerror, AimErrorBreakingPoint))
		{
			AimErrorRecoveryRate = LargeAimErrorRecoveryRate;
		}
		else
		{
			AimErrorRecoveryRate = SmallAimErrorRecoveryRate;
		}
		aimerror = FMax(TargetAimError, Subtract_FloatFloat(aimerror, Multiply_FloatFloat(dTime, AimErrorRecoveryRate)));
	}
	else
	{
		aimerror = FMax(TargetAimError, aimerror);
	}
	return;
}

final simulated function bool HasFlashlight()
{
	return HasAttachedFlashlight;
	return;
}

// Export UFiredWeapon::execIsFlashlightOn(FFrame&, void* const)
native final function bool IsFlashlightOn();

simulated function OnHolderDesiredFlashlightStateChanged()
{
	local bool PawnWantsFlashlightOn;
	local name EventName;
	local string FlashlightTextureName;
	local Material FlashlightMaterial;

	if(HasAttachedFlashlight)
	{
		PawnWantsFlashlightOn = ICanToggleWeaponFlashlight(Owner).GetDesiredFlashlightState();
		if(PawnWantsFlashlightOn)
		{
			EventName = 'FlashlightSwitchedOn';
			FlashlightTextureName = "SWATgearTex.FlashlightLensOnShader";
		}
		else
		{
			EventName = 'FlashlightSwitchedOff';
			FlashlightTextureName = "SWATgearTex.FlashlightLensOff";
		}
		TriggerEffectEvent(EventName, Owner,,,, true);
		if(Not_PreBool(InFirstPersonView()))
		{
			if(PawnWantsFlashlightOn)
			{
				FlashlightMaterial = Material(DynamicLoadObject(FlashlightTextureName, Class'Engine.Material'));
				AssertWithDescription(NotEqual_ObjectObject(FlashlightMaterial, none), Concat_StrStr("[ckline]: Couldn't DLO flashlight lens texture ", FlashlightTextureName));
			}
			else
			{
				ThirdPersonModel.Skins[1] = none;
				FlashlightMaterial = ThirdPersonModel.GetCurrentMaterial(1);
			}
			ThirdPersonModel.Skins[1] = FlashlightMaterial;
		}
		UpdateFlashlightState();
	}
	return;
}

simulated function UpdateFlashlightState()
{
	local bool PawnWantsFlashlightOn;

	if(Not_PreBool(HasAttachedFlashlight))
	{
		return;
	}
	PawnWantsFlashlightOn = ICanToggleWeaponFlashlight(Owner).GetDesiredFlashlightState();
	if(EqualEqual_BoolBool(PawnWantsFlashlightOn, IsFlashlightOn()))
	{
		return;
	}
	if(PawnWantsFlashlightOn)
	{
		InitFlashlight();
		if(Not_PreBool(IsFlashlightInitialized()))
		{
			AssertWithDescription(false, "[ckline] Flashlight should be initialized but thinks it isn't. I must have messed something up.");
		}
	}
	else
	{
		if(IsFlashlightInitialized())
		{
			DestroyFlashlight(ICanToggleWeaponFlashlight(Owner).GetDelayBeforeFlashlightShutoff());
		}
	}
	return;
}

private simulated function UpdateFlashlightLighting(optional float dTime)
{
	local bool bIsFlashlightProjectionVisible;
	local HandheldEquipmentModel WeaponModel;
	local Vector PositionOffset;
	local Rotator RotationOffset, rayDirection;
	local Vector HitLocation, HitNormal, TraceStart, TraceEnd, PointLightPos, Delta;

	local Actor HitActor;
	local float oldDistance, newDistance;

	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_DedicatedServer)))
	{
		return;
	}
	bIsFlashlightProjectionVisible = IsFlashlightProjectionVisible();
	if(AndAnd_BoolBool(Not_PreBool(bIsFlashlightProjectionVisible), Less_FloatFloat(Subtract_FloatFloat(Level.TimeSeconds, FlashlightProjection_LastSuccessfulTestTime), 1.0000000)))
	{
		bIsFlashlightProjectionVisible = true;
	}
	if(FlashlightProjection_IsInitializing)
	{
		if(bIsFlashlightProjectionVisible)
		{
			FlashlightProjection_CurrentBrightnessAlpha = 1.0000000;
		}
		else
		{
			FlashlightProjection_CurrentBrightnessAlpha = 0.0000000;
		}
	}
	else
	{
		if(bIsFlashlightProjectionVisible)
		{
			AddEqual_FloatFloat(FlashlightProjection_CurrentBrightnessAlpha, Divide_FloatFloat(dTime, 0.2000000));
		}
		else
		{
			SubtractEqual_FloatFloat(FlashlightProjection_CurrentBrightnessAlpha, Divide_FloatFloat(dTime, 0.2000000));
		}
		FlashlightProjection_CurrentBrightnessAlpha = FClamp(FlashlightProjection_CurrentBrightnessAlpha, 0.0000000, 1.0000000);
	}
	if(EqualEqual_IntInt(FlashlightUseFancyLights, 1))
	{
		FlashlightDynamicLight.LightBrightness = Multiply_FloatFloat(BaseFlashlightBrightness, FlashlightProjection_CurrentBrightnessAlpha);
		return;
	}
	if(InFirstPersonView())
	{
		if(EqualEqual_ObjectObject(FirstPersonModel, none))
		{
			AssertWithDescription(false, Concat_StrStr(Concat_StrStr("[henry] Can't update flashlight for ", string(self)), ", FirstPersonModel is None"));
		}
		WeaponModel = FirstPersonModel;
		PositionOffset = FlashlightPosition_1stPerson;
		RotationOffset = FlashlightRotation_1stPerson;
	}
	else
	{
		if(EqualEqual_ObjectObject(ThirdPersonModel, none))
		{
			AssertWithDescription(false, Concat_StrStr(Concat_StrStr("[henry] Can't update flashlight for ", string(self)), ", ThirdPersonModel is None"));
		}
		WeaponModel = ThirdPersonModel;
		PositionOffset = FlashlightPosition_3rdPerson;
		RotationOffset = FlashlightRotation_3rdPerson;
	}
	TraceStart = FlashlightReferenceActor.Location;
	rayDirection = FlashlightReferenceActor.Rotation;
	if(InFirstPersonView())
	{
		TraceEnd = Add_VectorVector(TraceStart, Multiply_VectorFloat(Vector(rayDirection), FlashlightFirstPersonDistance));
	}
	else
	{
		TraceEnd = Add_VectorVector(TraceStart, Multiply_VectorFloat(Vector(rayDirection), MaxFlashlightDistance));
	}
	HitActor = Trace(HitLocation, HitNormal, TraceEnd, TraceStart, true,,,, true);
	if(EqualEqual_ObjectObject(HitActor, none))
	{
		HitLocation = TraceEnd;
	}
	if(DebugDrawFlashlightDir)
	{
		Level.GetLocalPlayerController().myHUD.AddDebugLine(Add_VectorVector(TraceStart, vect(0.0000000, 0.0000000, 1.0000000)), Add_VectorVector(HitLocation, vect(0.0000000, 0.0000000, 1.0000000)), Class'Engine.Canvas'.static.MakeColor(byte(255), 120, 0), 0.0200000);
		Level.GetLocalPlayerController().myHUD.AddDebugLine(TraceStart, TraceEnd, Class'Engine.Canvas'.static.MakeColor(byte(255), 120, 200), 0.0200000);
	}
	Delta = Subtract_VectorVector(HitLocation, TraceStart);
	oldDistance = VSize(Subtract_VectorVector(TraceStart, FlashlightDynamicLight.Location));
	newDistance = Multiply_FloatFloat(VSize(Delta), PointLightDistanceFraction);
	newDistance = Add_FloatFloat(oldDistance, Multiply_FloatFloat(Subtract_FloatFloat(newDistance, oldDistance), PointLightDistanceFadeRate));
	PointLightPos = Add_VectorVector(TraceStart, Multiply_FloatVector(newDistance, Vector(FlashlightReferenceActor.Rotation)));
	FlashlightDynamicLight.SetLocation(PointLightPos);
	if(InFirstPersonView())
	{
		FlashlightDynamicLight.LightRadius = Add_FloatFloat(MinFlashlightRadius, Multiply_FloatFloat(Subtract_FloatFloat(BaseFlashlightRadius, MinFlashlightRadius), Divide_FloatFloat(newDistance, FlashlightFirstPersonDistance)));
	}
	else
	{
		FlashlightDynamicLight.LightRadius = Add_FloatFloat(MinFlashlightRadius, Multiply_FloatFloat(newDistance, PointLightRadiusScale));
	}
	FlashlightDynamicLight.LightBrightness = Add_FloatFloat(BaseFlashlightBrightness, Multiply_FloatFloat(FMin(Divide_FloatFloat(newDistance, MaxFlashlightDistance), 1.0000000), Subtract_FloatFloat(MinFlashlightBrightness, BaseFlashlightBrightness)));
	MultiplyEqual_FloatFloat(FlashlightDynamicLight.LightBrightness, FlashlightProjection_CurrentBrightnessAlpha);
	FlashlightDynamicLight.bLightChanged = true;
	return;
}

private simulated function InitFlashlight()
{
	local HandheldEquipmentModel WeaponModel;
	local Vector PositionOffset;
	local Rotator RotationOffset;
	local bool AttachSucceeded;
	local float saveRate, SavedLastRenderTime;

	if(EqualEqual_IntInt(FlashlightUseFancyLights, -1))
	{
		bHighEndGraphicsBoard = bool(Level.GetLocalPlayerController().ConsoleCommand("SUPPORTS BUMPMAP"));
		if(bHighEndGraphicsBoard)
		{
			FlashlightUseFancyLights = 1;
		}
		else
		{
			FlashlightUseFancyLights = 0;
		}
		if(bool(Level.GetLocalPlayerController().ConsoleCommand("USE_ATI_R200_SPOTLIGHT_WORKAROUND")))
		{
			FlashlightUseFancyLights = 0;
		}
	}
	AssertWithDescription(HasAttachedFlashlight, "[ckline] Attempt to initialize flashlight resources for a weapon that is not flashlight-enabled.");
	AssertWithDescription(Not_PreBool(IsFlashlightInitialized()), "[ckline] Attempt to initialize flashlight resources twice.");
	if(InFirstPersonView())
	{
		AssertWithDescription(NotEqual_ObjectObject(FirstPersonModel, none), Concat_StrStr(Concat_StrStr("[ckline] Can't set up flashlight for ", string(self)), ", FirstPersonModel is None"));
		WeaponModel = FirstPersonModel;
		PositionOffset = FlashlightPosition_1stPerson;
		RotationOffset = FlashlightRotation_1stPerson;
	}
	else
	{
		AssertWithDescription(NotEqual_ObjectObject(ThirdPersonModel, none), Concat_StrStr(Concat_StrStr("[ckline] Can't set up flashlight for ", string(self)), ", ThirdPersonModel is None"));
		WeaponModel = ThirdPersonModel;
		PositionOffset = FlashlightPosition_3rdPerson;
		RotationOffset = FlashlightRotation_3rdPerson;
	}
	AssertWithDescription(NotEqual_ObjectObject(FlashlightSpotLightClass, none), Concat_StrStr(Concat_StrStr("[henry] Can't spawn flashlight spotlight for weapon of class ", string(Class)), " because FlashlightSpotLightClass is None"));
	AssertWithDescription(NotEqual_ObjectObject(FlashlightPointLightClass, none), Concat_StrStr(Concat_StrStr("[henry] Can't spawn flashlight pointlight for weapon of class ", string(Class)), " because FlashlightPointLightClass is None"));
	AssertWithDescription(NotEqual_ObjectObject(FlashlightCoronaLightClass, none), Concat_StrStr(Concat_StrStr("[henry] Can't spawn flashlight coronalight for weapon of class ", string(Class)), " because FlashlightCoronaLightClass is None"));
	if(EqualEqual_IntInt(FlashlightUseFancyLights, 1))
	{
		FlashlightDynamicLight = Spawn(FlashlightSpotLightClass, WeaponModel);
	}
	else
	{
		FlashlightDynamicLight = Spawn(FlashlightPointLightClass, WeaponModel);
	}
	FlashlightReferenceActor = Spawn(FlashlightCoronaLightClass, WeaponModel);
	FlashlightReferenceActor.bCorona = true;
	BaseFlashlightBrightness = FlashlightDynamicLight.LightBrightness;
	BaseFlashlightRadius = FlashlightDynamicLight.LightRadius;
	AssertWithDescription(NotEqual_ObjectObject(FlashlightDynamicLight, none), Concat_StrStr("[henry] Can't init flashlight, couldn't spawn pointlight of class ", string(FlashlightPointLightClass)));
	if(AndAnd_BoolBool(EqualEqual_IntInt(FlashlightUseFancyLights, 0), Not_PreBool(InFirstPersonView())))
	{
		MultiplyEqual_FloatFloat(FlashlightDynamicLight.LightBrightness, 0.5000000);
		MultiplyEqual_FloatFloat(BaseFlashlightBrightness, 0.5000000);
	}
	if(InFirstPersonView())
	{
		FlashlightDynamicLight.Tag = 'FirstPersonFlashlight';
		FlashlightReferenceActor.bCorona = false;
	}
	else
	{
		MultiplyEqual_FloatFloat(BaseFlashlightRadius, ThirdPersonFlashlightRadiusPenalty);
		MultiplyEqual_FloatFloat(FlashlightDynamicLight.LightRadius, ThirdPersonFlashlightRadiusPenalty);
	}
	if(Not_PreBool(DebugDrawFlashlightDir))
	{
		FlashlightDynamicLight.SetDrawType(0);
		FlashlightReferenceActor.SetDrawType(0);
	}
	else
	{
		FlashlightDynamicLight.bHidden = false;
		FlashlightReferenceActor.bHidden = false;
		FlashlightDynamicLight.SetDrawType(1);
		FlashlightReferenceActor.SetDrawType(1);
	}
	AttachSucceeded = WeaponModel.Owner.AttachToBone(FlashlightDynamicLight, WeaponModel.EquippedSocket);
	AssertWithDescription(AttachSucceeded, Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[henry] Failed to attach flashlight light to bone '", string(WeaponModel.EquippedSocket)), "' on actor '"), string(WeaponModel.Owner)), "', check log for reason (probably the bone doesn't exist)"));
	AttachSucceeded = WeaponModel.Owner.AttachToBone(FlashlightReferenceActor, WeaponModel.EquippedSocket);
	AssertWithDescription(AttachSucceeded, Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[henry] Failed to attach flashlight reference position to bone '", string(WeaponModel.EquippedSocket)), "' on actor '"), string(WeaponModel.Owner)), "', check log for reason (probably the bone doesn't exist)"));
	FlashlightDynamicLight.SetRelativeLocation(PositionOffset);
	FlashlightDynamicLight.SetRelativeRotation(RotationOffset);
	FlashlightReferenceActor.SetRelativeLocation(PositionOffset);
	FlashlightReferenceActor.SetRelativeRotation(RotationOffset);
	SavedLastRenderTime = WeaponModel.Owner.LastRenderTime;
	WeaponModel.Owner.LastRenderTime = 0.0000000;
	WeaponModel.Owner.UpdateAttachmentLocations();
	WeaponModel.Owner.LastRenderTime = SavedLastRenderTime;
	FlashlightProjection_IsInitializing = true;
	saveRate = PointLightDistanceFadeRate;
	PointLightDistanceFadeRate = 1.0000000;
	UpdateFlashlightLighting();
	PointLightDistanceFadeRate = saveRate;
	FlashlightProjection_IsInitializing = false;
	return;
}

// Export UFiredWeapon::execIsFlashlightInitialized(FFrame&, void* const)
protected native function bool IsFlashlightInitialized();

// Export UFiredWeapon::execIsFlashlightProjectionVisible(FFrame&, void* const)
protected native function bool IsFlashlightProjectionVisible();

private function DestroyFlashlight(float SecondsBeforeDestroying)
{
	local float Delay;

	AssertWithDescription(IsFlashlightInitialized(), "[ckline] Attempt to destroy an uninitialized flashlight.");
	if(LessEqual_FloatFloat(SecondsBeforeDestroying, float(0)))
	{
		Delay = 0.0100000;
	}
	else
	{
		Delay = SecondsBeforeDestroying;
	}
	FlashlightDynamicLight.LifeSpan = Delay;
	FlashlightDynamicLight = none;
	if(NotEqual_ObjectObject(FlashlightReferenceActor, none))
	{
		FlashlightReferenceActor.bCorona = false;
		FlashlightReferenceActor.LifeSpan = Add_FloatFloat(1.0000000, Delay);
		FlashlightReferenceActor = none;
	}
	return;
}

function OnPlayerViewChanged()
{
	if(IsFlashlightInitialized())
	{
		DestroyFlashlight(ICanToggleWeaponFlashlight(Owner).GetDelayBeforeFlashlightShutoff());
	}
	UpdateFlashlightState();
	return;
}

protected function AIInterruptHandheldEquipmentHook()
{
	if(Greater_IntInt(int(ReloadingStatus), int(0)))
	{
		AIInterrupt_Reloading();
	}
	return;
}

private function AIInterrupt_Reloading()
{
	GotoState('None');
	ReloadingStatus = 0;
	return;
}

static function float GetRagdollDeathImpactMomentumMultiplier()
{
	return default.RagdollDeathImpactMomentumMultiplier;
	return;
}

simulated function DrawAccuracyCone(Vector SourceLocation, Rotator SourceDirection)
{
	local float Rho, Theta;
	local Vector CurrentEndPoint, LastEndPoint;
	local Rotator CurrentDirection;
	local HUD HUD;
	local Color Blue;

	HUD = Level.GetLocalPlayerController().myHUD;
	Blue = Class'Engine.Canvas'.static.MakeColor(0, 0, byte(255));
	Rho = Tan(Multiply_FloatFloat(GetAimError(), 0.0174533));
	Theta = 0.0000000;
	J0x5B:

	if(Less_FloatFloat(Theta, 360.0000000))
	{
		CurrentDirection = SourceDirection;
		ApplyPolarOffset(CurrentDirection, Rho, Theta);
		CurrentEndPoint = Add_VectorVector(SourceLocation, Multiply_VectorFloat(Vector(CurrentDirection), float(Range)));
		HUD.AddDebugLine(SourceLocation, CurrentEndPoint, Blue);
		if(NotEqual_VectorVector(LastEndPoint, vect(0.0000000, 0.0000000, 0.0000000)))
		{
			HUD.AddDebugLine(LastEndPoint, CurrentEndPoint, Blue);
		}
		LastEndPoint = CurrentEndPoint;
		AddEqual_FloatFloat(Theta, 18.0000000);
		// [Loop Continue]
		goto J0x5B;
	}
	return;
}

simulated function ApplyPolarOffset(out Rotator outDirection, float Rho, float Theta)
{
	local float XScale, YScale;
	local Vector xPlanarVec, yPlanarVec, zPlanarVec, spherePoint, offsetSpherePoint;

	XScale = Multiply_FloatFloat(Rho, Cos(Multiply_FloatFloat(Theta, 0.0174533)));
	YScale = Multiply_FloatFloat(Rho, Sin(Multiply_FloatFloat(Theta, 0.0174533)));
	GetAxes(outDirection, xPlanarVec, yPlanarVec, zPlanarVec);
	spherePoint = Vector(outDirection);
	offsetSpherePoint = Add_VectorVector(Add_VectorVector(spherePoint, Multiply_FloatVector(XScale, yPlanarVec)), Multiply_FloatVector(YScale, zPlanarVec));
	offsetSpherePoint = Normal(offsetSpherePoint);
	outDirection = Rotator(offsetSpherePoint);
	return;
}

simulated state BeingReloaded
{Begin:

	DoReloading();
	GotoState('None');
	stop;
}

defaultproperties
{
	ReloadAnimationRate=1.0000000
	LookAimErrorQuantizationFactor=1.5000000
	FlashlightProjection_StartBoneName="'"
	PointLightDistanceFraction=0.6600000
	PointLightRadiusScale=0.0120000
	PointLightDistanceFadeRate=0.4000000
	FlashlightUseFancyLights=-1
	MinFlashlightBrightness=90.0000000
	MinFlashlightRadius=10.0000000
	FlashlightFirstPersonDistance=200.0000000
	MaxFlashlightDistance=800.0000000
	ThirdPersonFlashlightRadiusPenalty=0.5000000
	BurstShotCount=3
	BurstRateFactor=1.0000000
	RagdollDeathImpactMomentumMultiplier=30.0000000
}