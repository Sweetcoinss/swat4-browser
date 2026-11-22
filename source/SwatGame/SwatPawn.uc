class SwatPawn extends Pawn implements ISwatPawn, ICanToggleWeaponFlashlight, ICanBeArrested
	abstract
	native
	config(SwatPawn)
	hidecategories(Karma);

const kAimHighLimitDegrees = 70.0f;
const kAimLowLimitDegrees = 62.0f;
const kAimLeftLimitDegrees = 54.0f;
const kAimRightLimitDegrees = 77.0f;
const kDeathRenderBoundingBoxExpansionSize = 100.0;

enum EAnimFlag
{
	kAF_TurnInPlace,                // 0
	kAF_Move,                       // 1
	kAF_Aim,                        // 2
	kAF_Equipment,                  // 3
	kAF_Special                     // 4
};

enum EAnimRotationUrgency
{
	kARU_Normal,                    // 0
	kARU_Fast,                      // 1
	kARU_VeryFast,                  // 2
	kARU_Instant                    // 3
};

enum EAnimAimRotationUrgency
{
	kAARU_Normal,                   // 0
	kAARU_Fast                      // 1
};

enum EAnimAimType
{
	kAAT_None,                      // 0
	kAAT_Rotation,                  // 1
	kAAT_Point,                     // 2
	kAAT_Actor                      // 3
};

enum ELeanTransitionState
{
	kLST_LeanLeft,                  // 0
	kLST_LeanRight,                 // 1
	kLST_UnleanLeft,                // 2
	kLST_UnleanRight                // 3
};

var private AnimationSet AnimSet;
var private config name AnimBoneBase;
var private config name AnimBoneSpineLow;
var private config name AnimBoneRightShoulder;
var private config name AnimBoneHead;
var private config name AnimBoneJaw;
var private config name NormalAimLocationBone;
var private config name LeanAimLocationBone;
var private config name NormalFireLocationBone;
var private config name LeanFireLocationBone;
var private config name AnimSocketGripRhand;
var private config name AnimSocketGripBack;
var private config name AnimSocketGripHolster;
var private config name AnimSocketGripBelt1;
var private config name AnimSocketGripBelt2;
var private config name AnimSocketHolster;
var private config name AnimSocketPouch;
var private config name AnimSocketHeadGear;
var config array<string> MaleAnimGroups;
var config array<string> FemaleAnimGroups;
var private config float PercentageHealthForIntenseInjury;
var private int AnimFlags[5];
var private bool bWasSpecialChannelAnimatingLastFrame;
var private bool bWasEquipmentChannelAnimatingLastFrame;
var private float AnimSpecialAlphaOverride;
var private bool bIsAnimSpecialAlphaOverrideEnabled;
var private float AnimEquipmentAlphaOverride;
var private bool bIsAnimEquipmentAlphaOverrideEnabled;
var private float AnimBaseYaw;
var private float AnimBaseTurnToYaw;
var private bool bIsAnimBaseTurnToYawValid;
var private SwatPawn.EAnimRotationUrgency AnimRotationUrgency;
var private SwatPawn.EAnimAimRotationUrgency AnimAimRotationUrgency;
var private bool bIsTurning;
var private float AverageSpeedSamples[5];
var private int AverageSpeedSampleIndex;
var private int LastSpeedSampleTick;
var private float AimBlendChangeTime;
var private float InertialAimAcceleration;
var private float InertialAimDeceleration;
var private float InertialAimMaxVelocity;
var private float InertialAimPositionPitch;
var private float InertialAimPositionYaw;
var private float InertialAimVelocityPitch;
var private float InertialAimVelocityYaw;
var private bool bIsMouthMoving;
var private PerlinNoise MouthMovementPerlinNoise;
var private SwatPawn.EAnimAimType AnimAimType;
var private Rotator AnimAimRotator;
var private Vector AnimAimPoint;
var private Actor AnimAimActor;
var private Pawn.ELeanState AnimLeanState;
var private bool bAnimDrawDebugLines;
var native const transient map<name, PawnDoorKnowledge> DoorKnowledgeMap;
var private bool FlashlightShouldBeOn;
var private bool bIsLowReady;
var private name ReasonForLowReady;
var private bool bShouldBeAtLowReady;
var private name ReasonForShouldBeAtLowReady;
var private bool bIsOnStairs;
var private bool bGoingUpStairs;
var private Vector LastLocation;
var private bool bIsFlashbanged;
var private bool bIsGassed;
var private bool bIsPepperSprayed;
var private bool bIsStung;
var private bool bIsStunnedByC2;
var private bool bIsTased;
var private config float MaxComplianceIssueDistance;
var private bool bArrested;
var private bool BeingArrested;
var private Pawn ArrestedBy;
var private config float QualifyTimeForArrest;
var bool bWantsToContinueAutoFiring;
var(Shadow) float ShadowLightDistance "Specifies how far the shadow-casting light source is from the pawn";
var(Shadow) float ShadowExtraDrawScale "This allows us to contol the scale of the shadow texture when it is rendered onto the world";
var(Shadow) float MaxShadowTraceDistance "Distance from the pawn after shadows do not project onto surfaces";
var(Shadow) float ShadowCullDistance "Shadows will completely disappear when the pawn is further than this distance away from the viewer";
var private Vector LeanPositionOffset;
var private Rotator LeanRotationOffset;
var private float LastLeanOffsetsUpdateTime;
var private config float LeanVerticalDistance;
var private config float LeanRollDegrees;
var private config float LeanBezierPt1X;
var private config float LeanBezierPt1Y;
var private config float LeanBezierPt2X;
var private config float LeanBezierPt2Y;
var Controller CachedPlayerControllerForOptiwand;
var const float RenderBoundingBoxExpansionSize;
var private Rotator LastAimRotator;

replication
{
	// Pos:0x0B7
	unreliable if(AndAnd_BoolBool(AndAnd_BoolBool(OrOr_BoolBool(Not_PreBool(bSkipActorPropertyReplication), bNetInitial), bReplicateMovement), EqualEqual_IntInt(int(Role), int(ROLE_AutonomousProxy))))
		ServerSetAimRotation;

	// Pos:0x000
	reliable if(AndAnd_BoolBool(AndAnd_BoolBool(OrOr_BoolBool(Not_PreBool(bSkipActorPropertyReplication), bNetInitial), bReplicateMovement), OrOr_BoolBool(OrOr_BoolBool(AndAnd_BoolBool(EqualEqual_IntInt(int(RemoteRole), int(ROLE_AutonomousProxy)), bNetInitial), AndAnd_BoolBool(AndAnd_BoolBool(EqualEqual_IntInt(int(RemoteRole), int(ROLE_SimulatedProxy)), OrOr_BoolBool(bNetInitial, bUpdateSimulatedPosition)), OrOr_BoolBool(EqualEqual_ObjectObject(Base, none), Base.bWorldGeometry))), AndAnd_BoolBool(EqualEqual_IntInt(int(RemoteRole), int(ROLE_DumbProxy)), OrOr_BoolBool(EqualEqual_ObjectObject(Base, none), Base.bWorldGeometry)))))
		AnimAimRotator;

	// Pos:0x0E7
	reliable if(Less_IntInt(int(Role), int(ROLE_Authority)))
		ServerSetLowReadyStatus, ServerToggleDesiredFlashlightState;

	// Pos:0x0F4
	reliable if(EqualEqual_IntInt(int(Role), int(ROLE_Authority)))
		AnimFlags, BeingArrested,
		FlashlightShouldBeOn, ReasonForShouldBeAtLowReady,
		bArrested, bShouldBeAtLowReady;

	// Pos:0x101
	reliable if(AndAnd_BoolBool(EqualEqual_IntInt(int(Role), int(ROLE_Authority)), NotEqual_IntInt(int(RemoteRole), int(ROLE_AutonomousProxy))))
		bIsFlashbanged, bIsGassed,
		bIsPepperSprayed, bIsStung,
		bIsStunnedByC2, bIsTased;
}

simulated event PostBeginPlay()
{
	Log(Concat_StrStr(string(self), "---SwatPawn::PostBeginPlay()."));
	super.PostBeginPlay();
	if(AndAnd_BoolBool(bActorShadows, NotEqual_IntInt(int(Level.NetMode), int(NM_DedicatedServer))))
	{
		Shadow = Spawn(Class'Engine.ShadowProjector', self, 'None', Location);
		Shadow.ShadowActor = self;
		Shadow.bBlobShadow = false;
		Shadow.LightDirection = Normal(vect(1.0000000, 1.0000000, 3.0000000));
		Shadow.LightDistance = ShadowLightDistance;
		Shadow.ShadowExtraDrawScale = ShadowExtraDrawScale;
		Shadow.MaxTraceDistance = int(MaxShadowTraceDistance);
		Shadow.RootMotion = true;
		Shadow.CullDistance = ShadowCullDistance;
		Shadow.Resolution = 256;
		Shadow.InitShadow();
	}
	InitAnimationForCurrentMesh();
	InitMouthMovementPerlinNoise();
	return;
}

simulated event PostNetBeginPlay()
{
	super.PostNetBeginPlay();
	AnimBaseYaw = float(AnimAimRotator.Yaw);
	return;
}

simulated event Destroyed()
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(string(self), "---SwatPawn::Destroyed(). controller="), string(Controller)));
	}
	super.Destroyed();
	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)))
	{
		SwatGameInfo(Level.Game).GameEvents.PawnDestroyed.Triggered(self);
	}
	return;
}

simulated function InitAnimationForCurrentMesh()
{
	Log(Concat_StrStr(string(self), "---SwatPawn::InitAnimationForCurrentMesh()."));
	Log(Concat_StrStr("...AnimSet=", string(AnimSet)));
	if(EqualEqual_ObjectObject(AnimSet, none))
	{
		Log("...creating new AnimationSet.");
		AnimSet = Class'SwatGame.AnimationSet'.static.Allocate(self).;
		Construct_Void();
	}
	AnimLoadPackageGroups();
	InitNativeAnimationSystemForPawn();
	ChangeAnimation();
	return;
}

// Export USwatPawn::execInitNativeAnimationSystemForPawn(FFrame&, void* const)
private native function InitNativeAnimationSystemForPawn();

simulated function array<string> GetAnimPackageGroups()
{
	Log(Concat_StrStr(string(self), "---SwatPawn::GetAnimPackageGroups()."));
	return MaleAnimGroups;
	return;
}

simulated function AnimLoadPackageGroups()
{
	Log(Concat_StrStr(string(self), "---SwatPawn::AnimLoadPackageGroups()."));
	LoadAnimationSets(GetAnimPackageGroups());
	return;
}

static simulated function StaticGetAnimPackageGroups(out array<string> AnimationSetNames, bool LoadFemalePackageGroups)
{
	local int i;

	Log(Concat_StrStr(Concat_StrStr("SwatPawn::StaticGetAnimPackageGroups( ", string(LoadFemalePackageGroups)), " )"));
	i = 0;
	J0x41:

	if(Less_IntInt(i, default.MaleAnimGroups.Length))
	{
		AnimationSetNames[AnimationSetNames.Length] = default.MaleAnimGroups[i];
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x41;
	}
	if(LoadFemalePackageGroups)
	{
		i = 0;
		J0x83:

		if(Less_IntInt(i, default.FemaleAnimGroups.Length))
		{
			AnimationSetNames[AnimationSetNames.Length] = default.FemaleAnimGroups[i];
			AddAdd_PreInt(i);
			// [Loop Continue]
			goto J0x83;
		}
	}
	return;
}

simulated function AnimSwapInSet(AnimationSetManager.EAnimationSet Set)
{
	local AnimationSetManager AnimationSetManager;
	local AnimationSet setObject;

	if(NotEqual_ObjectObject(AnimSet, none))
	{
		AnimationSetManager = SwatRepo(Level.GetRepo()).GetAnimationSetManager();
		if(NotEqual_ObjectObject(AnimationSetManager, none))
		{
			setObject = AnimationSetManager.GetAnimationSet(Set);
			assert(NotEqual_ObjectObject(setObject, none));
			AnimSwapInSet_Native(setObject);
		}
	}
	return;
}

// Export USwatPawn::execAnimSwapInSet_Native(FFrame&, void* const)
private native function AnimSwapInSet_Native(AnimationSet Set);

simulated function bool ShouldUseCuffedAnims()
{
	return OrOr_BoolBool(IsArrested(), IsBeingArrestedNow());
	return;
}

simulated function AnimationSetManager.EAnimationSet GetCompliantAnimSet()
{
	return 43;
	return;
}

simulated function AnimationSetManager.EAnimationSet GetRestrainedAnimSet()
{
	return 44;
	return;
}

simulated function AnimationSetManager.EAnimationSet GetStandingWalkAnimSet()
{
	return 5;
	return;
}

simulated function AnimationSetManager.EAnimationSet GetStandingWalkUpStairsAnimSet()
{
	return 7;
	return;
}

simulated function AnimationSetManager.EAnimationSet GetStandingWalkDownStairsAnimSet()
{
	return 8;
	return;
}

simulated function AnimationSetManager.EAnimationSet GetStandingRunAnimSet()
{
	return 1;
	return;
}

simulated function AnimationSetManager.EAnimationSet GetStandingRunUpStairsAnimSet()
{
	return 3;
	return;
}

simulated function AnimationSetManager.EAnimationSet GetStandingRunDownStairsAnimSet()
{
	return 4;
	return;
}

simulated function AnimationSetManager.EAnimationSet GetCrouchingAnimSet()
{
	return 9;
	return;
}

simulated function AnimationSetManager.EAnimationSet GetStandingInjuredAnimSet()
{
	return 11;
	return;
}

simulated function AnimationSetManager.EAnimationSet GetStandingInjuredUpStairsAnimSet()
{
	return 7;
	return;
}

simulated function AnimationSetManager.EAnimationSet GetStandingInjuredDownStairsAnimSet()
{
	return 8;
	return;
}

simulated function AnimationSetManager.EAnimationSet GetCrouchingInjuredAnimSet()
{
	return 14;
	return;
}

// Export USwatPawn::execIsLowerBodyInjured(FFrame&, void* const)
native simulated event bool IsLowerBodyInjured();

simulated function AnimationSetManager.EAnimationSet GetMovementAnimSet()
{
	if(IsArrested())
	{
		return GetRestrainedAnimSet();
	}
	else
	{
		if(IsCompliant())
		{
			return GetCompliantAnimSet();
		}
		else
		{
			if(OrOr_BoolBool(IsLowerBodyInjured(), CanBeArrestedNow()))
			{
				if(bIsCrouched)
				{
					return GetCrouchingInjuredAnimSet();
				}
				else
				{
					if(bIsOnStairs)
					{
						if(bGoingUpStairs)
						{
							return GetStandingInjuredUpStairsAnimSet();
						}
						else
						{
							return GetStandingInjuredDownStairsAnimSet();
						}
					}
					else
					{
						return GetStandingInjuredAnimSet();
					}
				}
			}
			else
			{
				if(bIsCrouched)
				{
					return GetCrouchingAnimSet();
				}
				else
				{
					if(bIsWalking)
					{
						if(bIsOnStairs)
						{
							if(bGoingUpStairs)
							{
								return GetStandingWalkUpStairsAnimSet();
							}
							else
							{
								return GetStandingWalkDownStairsAnimSet();
							}
						}
						else
						{
							return GetStandingWalkAnimSet();
						}
					}
					else
					{
						if(bIsOnStairs)
						{
							if(bGoingUpStairs)
							{
								return GetStandingRunUpStairsAnimSet();
							}
							else
							{
								return GetStandingRunDownStairsAnimSet();
							}
						}
						else
						{
							return GetStandingRunAnimSet();
						}
					}
				}
			}
		}
	}
	return;
}

protected simulated function SetThirdPersonMovementAnims()
{
	AnimSwapInSet(GetMovementAnimSet());
	return;
}

simulated function AnimationSetManager.EAnimationSet GetHandgunAimPoseSet()
{
	if(Not_PreBool(bIsCrouched))
	{
		return 45;
	}
	else
	{
		return 47;
	}
	return;
}

simulated function AnimationSetManager.EAnimationSet GetSubMachineGunAimPoseSet()
{
	if(Not_PreBool(bIsCrouched))
	{
		return 50;
	}
	else
	{
		return 52;
	}
	return;
}

simulated function AnimationSetManager.EAnimationSet GetMachineGunAimPoseSet()
{
	if(Not_PreBool(bIsCrouched))
	{
		return 55;
	}
	else
	{
		return 57;
	}
	return;
}

simulated function AnimationSetManager.EAnimationSet GetShotgunAimPoseSet()
{
	if(Not_PreBool(bIsCrouched))
	{
		return 60;
	}
	else
	{
		return 62;
	}
	return;
}

simulated function AnimationSetManager.EAnimationSet GetThrownWeaponAimPoseSet()
{
	if(Not_PreBool(bIsCrouched))
	{
		return 65;
	}
	else
	{
		return 67;
	}
	return;
}

simulated function AnimationSetManager.EAnimationSet GetTacticalAidAimPoseSet()
{
	if(Not_PreBool(bIsCrouched))
	{
		return 70;
	}
	else
	{
		return 72;
	}
	return;
}

simulated function AnimationSetManager.EAnimationSet GetTacticalAidUseAimPoseSet()
{
	return 75;
	return;
}

simulated function AnimationSetManager.EAnimationSet GetPepperSprayAimPoseSet()
{
	if(Not_PreBool(bIsCrouched))
	{
		return 76;
	}
	else
	{
		return 78;
	}
	return;
}

simulated function AnimationSetManager.EAnimationSet GetM4AimPoseSet()
{
	if(Not_PreBool(bIsCrouched))
	{
		return 81;
	}
	else
	{
		return 83;
	}
	return;
}

simulated function AnimationSetManager.EAnimationSet GetUMPAimPoseSet()
{
	if(Not_PreBool(bIsCrouched))
	{
		return 86;
	}
	else
	{
		return 88;
	}
	return;
}

simulated function AnimationSetManager.EAnimationSet GetOptiwandAimPoseSet()
{
	if(Not_PreBool(bIsCrouched))
	{
		return 91;
	}
	else
	{
		return 93;
	}
	return;
}

simulated function AnimationSetManager.EAnimationSet GetPaintballAimPoseSet()
{
	if(Not_PreBool(bIsCrouched))
	{
		return 96;
	}
	else
	{
		return 98;
	}
	return;
}

simulated function AnimationSetManager.EAnimationSet GetCuffedAimPoseSet()
{
	return 103;
	return;
}

simulated function AnimationSetManager.EAnimationSet GetEquipmentAimSet()
{
	local HandheldEquipment Equipment;

	if(ShouldUseCuffedAnims())
	{
		return GetCuffedAimPoseSet();
	}
	Equipment = GetActiveItem();
	if(NotEqual_ObjectObject(GetActiveItem(), none))
	{
		if(OrOr_BoolBool(Equipment.IsA('Handgun'), Equipment.IsA('Taser')))
		{
			return GetHandgunAimPoseSet();
		}
		else
		{
			if(Equipment.IsA('SubMachineGun'))
			{
				if(Equipment.IsA('UMP45SMG'))
				{
					return GetUMPAimPoseSet();
				}
				else
				{
					return GetSubMachineGunAimPoseSet();
				}
			}
			else
			{
				if(Equipment.IsA('MachineGun'))
				{
					if(Equipment.IsA('M4A1MG'))
					{
						return GetM4AimPoseSet();
					}
					else
					{
						return GetMachineGunAimPoseSet();
					}
				}
				else
				{
					if(Equipment.IsA('Shotgun'))
					{
						return GetShotgunAimPoseSet();
					}
					else
					{
						if(Equipment.IsA('ThrownWeapon'))
						{
							return GetThrownWeaponAimPoseSet();
						}
						else
						{
							if(Equipment.IsA('ITacticalAid'))
							{
								if(Equipment.IsA('PepperSpray'))
								{
									return GetPepperSprayAimPoseSet();
								}
								else
								{
									if(Equipment.IsBeingUsed())
									{
										return GetTacticalAidUseAimPoseSet();
									}
									else
									{
										return GetTacticalAidAimPoseSet();
									}
								}
							}
							else
							{
								if(Equipment.IsA('optiwand'))
								{
									return GetOptiwandAimPoseSet();
								}
								else
								{
									if(Equipment.IsA('CSBallLauncher'))
									{
										return GetPaintballAimPoseSet();
									}
									else
									{
										if(Equipment.IsA('IAmCuffed'))
										{
											return GetCuffedAimPoseSet();
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}
	return 0;
	return;
}

// Export USwatPawn::execAnimStopAimChannels(FFrame&, void* const)
native function AnimStopAimChannels();

protected simulated function SetThirdPersonEquipmentAnims()
{
	local AnimationSetManager.EAnimationSet AnimationSet;

	AnimationSet = GetEquipmentAimSet();
	if(NotEqual_IntInt(int(AnimationSet), int(0)))
	{
		AnimSwapInSet(AnimationSet);
	}
	else
	{
		AnimStopAimChannels();
	}
	return;
}

simulated function AnimationSetManager.EAnimationSet GetHandgunLowReadyAimPoseSet()
{
	if(Not_PreBool(bIsCrouched))
	{
		return 46;
	}
	else
	{
		return 48;
	}
	return;
}

simulated function AnimationSetManager.EAnimationSet GetSubMachineGunLowReadyAimPoseSet()
{
	if(Not_PreBool(bIsCrouched))
	{
		return 51;
	}
	else
	{
		return 53;
	}
	return;
}

simulated function AnimationSetManager.EAnimationSet GetMachineGunLowReadyAimPoseSet()
{
	if(Not_PreBool(bIsCrouched))
	{
		return 56;
	}
	else
	{
		return 58;
	}
	return;
}

simulated function AnimationSetManager.EAnimationSet GetShotgunLowReadyAimPoseSet()
{
	if(Not_PreBool(bIsCrouched))
	{
		return 61;
	}
	else
	{
		return 63;
	}
	return;
}

simulated function AnimationSetManager.EAnimationSet GetThrownWeaponLowReadyAimPoseSet()
{
	if(Not_PreBool(bIsCrouched))
	{
		return 66;
	}
	else
	{
		return 68;
	}
	return;
}

simulated function AnimationSetManager.EAnimationSet GetTacticalAidLowReadyAimPoseSet()
{
	if(Not_PreBool(bIsCrouched))
	{
		return 71;
	}
	else
	{
		return 73;
	}
	return;
}

simulated function AnimationSetManager.EAnimationSet GetPepperSprayLowReadyAimPoseSet()
{
	if(Not_PreBool(bIsCrouched))
	{
		return 77;
	}
	else
	{
		return 79;
	}
	return;
}

simulated function AnimationSetManager.EAnimationSet GetM4LowReadyAimPoseSet()
{
	if(Not_PreBool(bIsCrouched))
	{
		return 82;
	}
	else
	{
		return 84;
	}
	return;
}

simulated function AnimationSetManager.EAnimationSet GetUMPLowReadyAimPoseSet()
{
	if(Not_PreBool(bIsCrouched))
	{
		return 87;
	}
	else
	{
		return 89;
	}
	return;
}

simulated function AnimationSetManager.EAnimationSet GetOptiwandLowReadyAimPoseSet()
{
	if(Not_PreBool(bIsCrouched))
	{
		return 92;
	}
	else
	{
		return 94;
	}
	return;
}

simulated function AnimationSetManager.EAnimationSet GetPaintballLowReadyAimPoseSet()
{
	if(Not_PreBool(bIsCrouched))
	{
		return 97;
	}
	else
	{
		return 99;
	}
	return;
}

simulated function AnimationSetManager.EAnimationSet GetLowReadySet()
{
	local HandheldEquipment Equipment;

	assert(EqualEqual_BoolBool(bIsLowReady, true));
	if(ShouldUseCuffedAnims())
	{
		return 0;
	}
	Equipment = GetActiveItem();
	if(NotEqual_ObjectObject(GetActiveItem(), none))
	{
		if(OrOr_BoolBool(Equipment.IsA('Handgun'), Equipment.IsA('Taser')))
		{
			return GetHandgunLowReadyAimPoseSet();
		}
		else
		{
			if(Equipment.IsA('SubMachineGun'))
			{
				if(Equipment.IsA('UMP45SMG'))
				{
					return GetUMPLowReadyAimPoseSet();
				}
				else
				{
					return GetSubMachineGunLowReadyAimPoseSet();
				}
			}
			else
			{
				if(Equipment.IsA('MachineGun'))
				{
					if(Equipment.IsA('M4A1MG'))
					{
						return GetM4LowReadyAimPoseSet();
					}
					else
					{
						return GetMachineGunLowReadyAimPoseSet();
					}
				}
				else
				{
					if(Equipment.IsA('Shotgun'))
					{
						return GetShotgunLowReadyAimPoseSet();
					}
					else
					{
						if(Equipment.IsA('ThrownWeapon'))
						{
							return GetThrownWeaponLowReadyAimPoseSet();
						}
						else
						{
							if(Equipment.IsA('ITacticalAid'))
							{
								if(Equipment.IsA('PepperSpray'))
								{
									return GetPepperSprayLowReadyAimPoseSet();
								}
								else
								{
									if(Not_PreBool(Equipment.IsBeingUsed()))
									{
										return GetTacticalAidLowReadyAimPoseSet();
									}
								}
							}
							else
							{
								if(Equipment.IsA('optiwand'))
								{
									return GetOptiwandLowReadyAimPoseSet();
								}
								else
								{
									if(Equipment.IsA('CSBallLauncher'))
									{
										return GetPaintballLowReadyAimPoseSet();
									}
								}
							}
						}
					}
				}
			}
		}
	}
	return 0;
	return;
}

protected simulated function SetThirdPersonLowReadyAnims()
{
	local AnimationSetManager.EAnimationSet AnimationSet;

	if(bIsLowReady)
	{
		AnimationSet = GetLowReadySet();
		if(NotEqual_IntInt(int(AnimationSet), int(0)))
		{
			AnimSwapInSet(AnimationSet);
		}
	}
	return;
}

simulated function AnimationSetManager.EAnimationSet GetFlashbangedAnimSet()
{
	if(Not_PreBool(ShouldUseCuffedAnims()))
	{
		return 105;
	}
	else
	{
		return 106;
	}
	return;
}

simulated function AnimationSetManager.EAnimationSet GetGassedAnimSet()
{
	if(Not_PreBool(ShouldUseCuffedAnims()))
	{
		return 107;
	}
	else
	{
		return 108;
	}
	return;
}

simulated function AnimationSetManager.EAnimationSet GetPepperSprayedAnimSet()
{
	if(Not_PreBool(ShouldUseCuffedAnims()))
	{
		return 109;
	}
	else
	{
		return 110;
	}
	return;
}

simulated function AnimationSetManager.EAnimationSet GetStungAnimSet()
{
	if(Not_PreBool(ShouldUseCuffedAnims()))
	{
		return 111;
	}
	else
	{
		return 112;
	}
	return;
}

simulated function AnimationSetManager.EAnimationSet GetTasedAnimSet()
{
	if(Not_PreBool(ShouldUseCuffedAnims()))
	{
		return 113;
	}
	else
	{
		return 114;
	}
	return;
}

simulated function AnimationSetManager.EAnimationSet GetAffectedByTacticalAidAnimSet()
{
	if(IsFlashbanged())
	{
		return GetFlashbangedAnimSet();
	}
	else
	{
		if(IsGassed())
		{
			return GetGassedAnimSet();
		}
		else
		{
			if(IsPepperSprayed())
			{
				return GetPepperSprayedAnimSet();
			}
			else
			{
				if(IsStung())
				{
					return GetStungAnimSet();
				}
				else
				{
					if(IsStunnedByC2())
					{
						return GetFlashbangedAnimSet();
					}
					else
					{
						if(IsTased())
						{
							return GetTasedAnimSet();
						}
					}
				}
			}
		}
	}
	return 0;
	return;
}

protected simulated function SetThirdPersonNonlethalReactionAnims()
{
	local AnimationSetManager.EAnimationSet AffectedByTacticalAidAnimSet;

	AffectedByTacticalAidAnimSet = GetAffectedByTacticalAidAnimSet();
	if(NotEqual_IntInt(int(AffectedByTacticalAidAnimSet), int(0)))
	{
		AnimSwapInSet(AffectedByTacticalAidAnimSet);
	}
	return;
}

protected simulated function AnimationSetManager.EAnimationSet GetMouthMovementSet()
{
	return 120;
	return;
}

private simulated function SetThirdPersonMouthMovementAnims()
{
	AnimSwapInSet(GetMouthMovementSet());
	return;
}

// Export USwatPawn::execSetThirdPersonLeanAnims(FFrame&, void* const)
protected native function SetThirdPersonLeanAnims();

simulated event ChangeAnimation()
{
	super.ChangeAnimation();
	if(bPhysicsAnimUpdate)
	{
		SetThirdPersonMovementAnims();
		if(Not_PreBool(IsNonlethaled()))
		{
			SetThirdPersonEquipmentAnims();
			SetThirdPersonLowReadyAnims();
			SetAdditionalAnimSets();
		}
		SetThirdPersonNonlethalReactionAnims();
		SetThirdPersonMouthMovementAnims();
		if(EqualEqual_BoolBool(ShouldUseCuffedAnims(), false))
		{
			SetThirdPersonLeanAnims();
		}
	}
	return;
}

protected simulated function SetAdditionalAnimSets()
{
	return;
}

simulated function StartMouthMovement()
{
	bIsMouthMoving = true;
	return;
}

simulated function StopMouthMovement()
{
	bIsMouthMoving = false;
	return;
}

private simulated function InitMouthMovementPerlinNoise()
{
	MouthMovementPerlinNoise = Class'Engine.PerlinNoise'.static.Allocate(self).;
	Construct_Void();
	MouthMovementPerlinNoise.Reinitialize();
	return;
}

simulated event OnLeanStateChange()
{
	super.OnLeanStateChange();
	if(NotEqual_IntInt(int(LeanState), int(0)))
	{
		bIsAnimBaseTurnToYawValid = true;
		AnimBaseTurnToYaw = float(LeanLockedYaw);
	}
	SetThirdPersonLeanAnims();
	return;
}

simulated function bool IsTurning()
{
	return bIsTurning;
	return;
}

simulated function OnActiveItemEquipped()
{
	if(NotEqual_ObjectObject(GetActiveItem(), none))
	{
		ChangeAnimation();
	}
	if(HasEquippedFirstItemYet)
	{
		TriggerEffectEvent('Equipped', GetActiveItem());
	}
	dispatchMessage(Class'SwatGame.MessageItemEquipped'.static.Allocate(self)., construct_NameName(Label, GetActiveItem().Class.Name));
	if(IsControlledByLocalHuman())
	{
		UpdateHUDFireMode();
	}
	return;
}

simulated function OnEquippingFinished()
{
	super.OnEquippingFinished();
	HasEquippedFirstItemYet = true;
	return;
}

simulated function OnActiveItemUnEquipped()
{
	TriggerEffectEvent('UnEquipped', GetActiveItem());
	if(IsControlledByLocalHuman())
	{
		UpdateHUDFireMode();
	}
	return;
}

simulated event OnNonlethalEffectChanged()
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---SwatPawn::OnNonlethalEffectChanged()."));
	}
	if(NotEqual_ObjectObject(Level.GetLocalPlayerController().Pawn, self))
	{
		ChangeAnimation();
	}
	return;
}

simulated event OnbIsTasedChanged()
{
	OnNonlethalEffectChanged();
	return;
}

simulated event OnArrestedStatusChanged()
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---SwatPawn::OnArrestedStatusChanged()."));
	}
	if(NotEqual_ObjectObject(Level.GetLocalPlayerController().Pawn, self))
	{
		ChangeAnimation();
	}
	return;
}

simulated function AimToRotation(Rotator DesiredRotation)
{
	return;
}

simulated function Vector GetViewDirection()
{
	return;
}

simulated function Vector GetViewPoint()
{
	return;
}

function ServerSetAimRotation(Rotator Rotator)
{
	if(IsBeingArrestedNow())
	{
		return;
	}
	AnimAimRotator = Rotator;
	AnimAimType = 1;
	return;
}

simulated function Rotator GetAimRotation()
{
	return AnimAimRotator;
	return;
}

simulated function Rotator AdjustAim(Ammunition FiredAmmunition, Vector projStart, int aimerror)
{
	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Client)))
	{
		return AnimAimRotator;
	}
	else
	{
		return super.AdjustAim(FiredAmmunition, projStart, aimerror);
	}
	return;
}

simulated function AnimSetAimRotation(Rotator Rotator)
{
	AnimAimRotator = Rotator;
	AnimAimType = 1;
	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
	{
		if(NotEqual_RotatorRotator(Rotator, LastAimRotator))
		{
			ServerSetAimRotation(Rotator);
			LastAimRotator = Rotator;
		}
	}
	return;
}

simulated function AnimSetAimPoint(Vector Point)
{
	AnimAimPoint = Point;
	AnimAimType = 2;
	return;
}

simulated function AnimSetAimActor(Actor Actor)
{
	AnimAimActor = Actor;
	AnimAimType = 3;
	return;
}

simulated function AnimAimUnset()
{
	AnimAimType = 0;
	return;
}

simulated function bool AnimIsAimSet()
{
	return NotEqual_IntInt(int(AnimAimType), int(0));
	return;
}

// Export USwatPawn::execAnimGetAimRotation(FFrame&, void* const)
native function Rotator AnimGetAimRotation();

// Export USwatPawn::execAnimIsAimedAtDesired(FFrame&, void* const)
native function bool AnimIsAimedAtDesired();

// Export USwatPawn::execAnimCanAimAtDesiredPoint(FFrame&, void* const)
native function bool AnimCanAimAtDesiredPoint(Vector Point);

// Export USwatPawn::execAnimCanAimAtDesiredActor(FFrame&, void* const)
native function bool AnimCanAimAtDesiredActor(Actor Actor);

// Export USwatPawn::execAnimCanAimAtDesiredRotation(FFrame&, void* const)
native function bool AnimCanAimAtDesiredRotation(Rotator Rotation);

simulated function bool IsLowReady()
{
	return bIsLowReady;
	return;
}

simulated function SetLowReady(bool bEnable, optional name Reason)
{
	if(Not_PreBool(CanPawnUseLowReady()))
	{
		bEnable = false;
		Reason = 'None';
	}
	if(IsControlledByLocalHuman())
	{
		ServerSetLowReadyStatus(bEnable, Reason);
	}
	if(OrOr_BoolBool(NotEqual_BoolBool(bIsLowReady, bEnable), NotEqual_NameName(ReasonForLowReady, Reason)))
	{
		bIsLowReady = bEnable;
		ReasonForLowReady = Reason;
		ChangeAnimation();
	}
	return;
}

protected simulated function bool CanPawnUseLowReady()
{
	return false;
	return;
}

function ServerSetLowReadyStatus(bool bEnable, name Reason)
{
	bShouldBeAtLowReady = bEnable;
	ReasonForShouldBeAtLowReady = Reason;
	if(Not_PreBool(IsControlledByLocalHuman()))
	{
		SetLowReady(bEnable, Reason);
	}
	return;
}

simulated event OnLowReadyStatusChanged()
{
	SetLowReady(bShouldBeAtLowReady, ReasonForShouldBeAtLowReady);
	return;
}

// Export USwatPawn::execAnimGetSpecialChannel(FFrame&, void* const)
native function int AnimGetSpecialChannel();

// Export USwatPawn::execAnimGetEquipmentChannel(FFrame&, void* const)
native function int AnimGetEquipmentChannel();

// Export USwatPawn::execAnimGetQuickHitChannel(FFrame&, void* const)
native function int AnimGetQuickHitChannel();

simulated function int AnimPlaySpecial(name AnimName, optional float TweenTime, optional name Bone, optional float Rate)
{
	local int Channel;

	Channel = AnimGetSpecialChannel();
	AnimSetTweenAndBoneForChannel(Channel, TweenTime, Bone);
	if(EqualEqual_FloatFloat(Rate, float(0)))
	{
		Rate = 1.0000000;
	}
	PlayAnim(AnimName, Rate, TweenTime, Channel);
	return Channel;
	return;
}

simulated function int AnimPlayEquipment(Pawn.EAnimPlayType AnimPlayType, name AnimName, optional float TweenTime, optional name Bone, optional float Rate)
{
	local int Channel;

	Channel = AnimGetEquipmentChannel();
	AnimSetTweenAndBoneForChannel(Channel, TweenTime, Bone);
	if(EqualEqual_FloatFloat(Rate, float(0)))
	{
		Rate = 1.0000000;
	}
	if(EqualEqual_IntInt(int(AnimPlayType), int(0)))
	{
		PlayAnim(AnimName, Rate, TweenTime, Channel);
	}
	else
	{
		PlayAnimAdditive(AnimName, Rate, TweenTime, Channel);
	}
	return Channel;
	return;
}

simulated function int AnimLoopSpecial(name AnimName, optional float TweenTime, optional name Bone, optional float Rate)
{
	local int Channel;

	Channel = AnimGetSpecialChannel();
	AnimSetTweenAndBoneForChannel(Channel, TweenTime, Bone);
	if(Greater_FloatFloat(Rate, float(0)))
	{
		LoopAnim(AnimName, Rate, TweenTime, Channel);
	}
	else
	{
		LoopAnim(AnimName,, TweenTime, Channel);
	}
	return Channel;
	return;
}

simulated function int AnimLoopEquipment(Pawn.EAnimPlayType AnimPlayType, name AnimName, optional float TweenTime, optional name Bone, optional float Rate)
{
	local int Channel;

	Channel = AnimGetEquipmentChannel();
	AnimSetTweenAndBoneForChannel(Channel, TweenTime, Bone);
	if(EqualEqual_FloatFloat(Rate, float(0)))
	{
		Rate = 1.0000000;
	}
	if(EqualEqual_IntInt(int(AnimPlayType), int(0)))
	{
		LoopAnim(AnimName, Rate, TweenTime, Channel);
	}
	else
	{
		LoopAnimAdditive(AnimName,, TweenTime, Channel);
	}
	return Channel;
	return;
}

simulated function int AnimPlayQuickHit(name AnimName, optional float TweenTime, optional name Bone, optional float Rate)
{
	local int Channel;

	Channel = AnimGetQuickHitChannel();
	AnimSetTweenAndBoneForChannel(Channel, TweenTime, Bone);
	if(EqualEqual_FloatFloat(Rate, float(0)))
	{
		Rate = 1.0000000;
	}
	PlayAnimAdditive(AnimName, Rate, TweenTime, Channel);
	return Channel;
	return;
}

simulated function EnableAnimSpecialAlphaOverride(float Alpha)
{
	bIsAnimSpecialAlphaOverrideEnabled = true;
	AnimSpecialAlphaOverride = Alpha;
	return;
}

simulated function DisableAnimSpecialAlphaOverride()
{
	bIsAnimSpecialAlphaOverrideEnabled = false;
	return;
}

simulated function EnableAnimEquipmentAlphaOverride(float Alpha)
{
	bIsAnimEquipmentAlphaOverrideEnabled = true;
	AnimEquipmentAlphaOverride = Alpha;
	return;
}

simulated function DisableAnimEquipmentAlphaOverride()
{
	bIsAnimEquipmentAlphaOverrideEnabled = false;
	return;
}

// Export USwatPawn::execAnimStopSpecial(FFrame&, void* const)
native function AnimStopSpecial();

// Export USwatPawn::execAnimStopEquipment(FFrame&, void* const)
native function AnimStopEquipment();

// Export USwatPawn::execAnimStopQuickHit(FFrame&, void* const)
native function AnimStopQuickHit();

latent simulated function AnimFinishSpecial()
{
	FinishAnim(AnimGetSpecialChannel());
	return;
}

latent simulated function AnimFinishEquipment()
{
	FinishAnim(AnimGetEquipmentChannel());
	return;
}

private simulated function AnimSetTweenAndBoneForChannel(int Channel, float TweenTime, name Bone)
{
	local float previousChannelAlpha;

	previousChannelAlpha = AnimGetChannelAlpha(Channel);
	if(EqualEqual_NameName(Bone, 'None'))
	{
		Bone = AnimBoneBase;
	}
	AnimBlendParams(Channel, previousChannelAlpha,,, Bone);
	return;
}

simulated function name GetUpperBodyBone()
{
	return AnimBoneSpineLow;
	return;
}

simulated function AnimSetRotationUrgency(SwatPawn.EAnimRotationUrgency Urgency)
{
	AnimRotationUrgency = Urgency;
	return;
}

simulated function AnimSetAnimAimRotationUrgency(SwatPawn.EAnimAimRotationUrgency Urgency)
{
	AnimAimRotationUrgency = Urgency;
	return;
}

// Export USwatPawn::execAnimSetIdle(FFrame&, void* const)
native function AnimSetIdle(name NewIdleAnimation, float TweenTime);

simulated function AnimSetFlag(SwatPawn.EAnimFlag Flag, bool bEnable)
{
	AnimFlags[int(Flag)] = int(bEnable);
	return;
}

simulated function bool AnimGetFlag(SwatPawn.EAnimFlag Flag)
{
	assert(LessEqual_IntInt(int(Flag), int(4)));
	return bool(AnimFlags[int(Flag)]);
	return;
}

// Export USwatPawn::execAnimAreChannelsAtZeroAlpha(FFrame&, void* const)
native function bool AnimAreChannelsAtZeroAlpha(int StartChannel, int LastChannel);

// Export USwatPawn::execAnimAreAimingChannelsMuted(FFrame&, void* const)
native function bool AnimAreAimingChannelsMuted();

simulated function float GetAnimBaseYaw()
{
	return AnimBaseYaw;
	return;
}

// Export USwatPawn::execAnimSnapBaseToAim(FFrame&, void* const)
native function AnimSnapBaseToAim();

simulated function bool AnimIsBaseAtAim()
{
	return Not_PreBool(bIsAnimBaseTurnToYawValid);
	return;
}

// Export USwatPawn::execAnimSnapRotationToBase(FFrame&, void* const)
native function AnimSnapRotationToBase();

// Export USwatPawn::execAnimGetAimOrigin(FFrame&, void* const)
native function Vector AnimGetAimOrigin();

simulated function ToggleAnimDrawDebugLines()
{
	bAnimDrawDebugLines = Not_PreBool(bAnimDrawDebugLines);
	return;
}

// Export USwatPawn::execSetRenderBoundingBoxExpansionSize(FFrame&, void* const)
native function SetRenderBoundingBoxExpansionSize(float NewRenderBoundingBoxExpansionSize);

simulated function Died(Controller Killer, Class<DamageType> DamageType, Vector HitLocation, Vector HitMomentum)
{
	super.Died(Killer, DamageType, HitLocation, HitMomentum);
	TriggerPawnDied(Killer);
	SetRenderBoundingBoxExpansionSize(100.0000000);
	bWantsToContinueAutoFiring = false;
	return;
}

protected simulated function TriggerPawnDied(Controller Killer)
{
	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)))
	{
		SwatGameInfo(Level.Game).GameEvents.PawnDied.Triggered(self, Killer.Pawn, false);
	}
	return;
}

simulated function bool IsIntenseInjury()
{
	return LessEqual_FloatFloat(Divide_FloatFloat(float(Health), float(default.Health)), PercentageHealthForIntenseInjury);
	return;
}

simulated event SetWalking(bool bNewIsWalking)
{
	if(NotEqual_BoolBool(bNewIsWalking, bIsWalking))
	{
		bIsWalking = bNewIsWalking;
		ChangeAnimation();
	}
	return;
}

singular simulated event BaseChange()
{
	local BlockingVolume BaseBlockingVolume;

	super.BaseChange();
	BaseBlockingVolume = BlockingVolume(Base);
	if(AndAnd_BoolBool(NotEqual_ObjectObject(BaseBlockingVolume, none), BaseBlockingVolume.bIsStairs))
	{
		bIsOnStairs = true;
		ChangeAnimation();
	}
	else
	{
		bIsOnStairs = false;
		ChangeAnimation();
	}
	return;
}

function bool IsAtRunningSpeed()
{
	local AnimationSetManager AnimationSetManager;
	local AnimationSet setObject;

	AnimationSetManager = SwatRepo(Level.GetRepo()).GetAnimationSetManager();
	assert(NotEqual_ObjectObject(AnimationSetManager, none));
	setObject = AnimationSetManager.GetAnimationSet(1);
	return GreaterEqual_FloatFloat(VSize2D(Velocity), setObject.AnimSpeedForward);
	return;
}

// Export USwatPawn::execGetDoorKnowledge(FFrame&, void* const)
native event PawnDoorKnowledge GetDoorKnowledge(Door inDoor);

protected event InitializeDoorKnowledge(Door inDoor, PawnDoorKnowledge DoorKnowledge)
{
	return;
}

// Export USwatPawn::execDoesBelieveDoorLocked(FFrame&, void* const)
native function bool DoesBelieveDoorLocked(Door inDoor);

// Export USwatPawn::execDoesBelieveDoorWedged(FFrame&, void* const)
native function bool DoesBelieveDoorWedged(Door inDoor);

function SetDoorLockedBelief(Door inDoor, bool bBelievesDoorLocked)
{
	assert(NotEqual_ObjectObject(inDoor, none));
	GetDoorKnowledge(inDoor).SetBelievesDoorLocked(bBelievesDoorLocked);
	return;
}

function SetDoorWedgedBelief(Door inDoor, bool bBelievesDoorWedged)
{
	assert(NotEqual_ObjectObject(inDoor, none));
	GetDoorKnowledge(inDoor).SetBelievesDoorWedged(bBelievesDoorWedged);
	return;
}

function SetIsFlashbanged(bool Value)
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(string(self), "---SwatPawn::SetIsFlashbanged(). Value="), string(Value)));
	}
	bIsFlashbanged = Value;
	return;
}

function SetIsGassed(bool Value)
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(string(self), "---SwatPawn::SetIsGassed(). Value="), string(Value)));
	}
	bIsGassed = Value;
	return;
}

function SetIsPepperSprayed(bool Value)
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(string(self), "---SwatPawn::SetIsPepperSprayed(). Value="), string(Value)));
	}
	bIsPepperSprayed = Value;
	return;
}

function SetIsStung(bool Value)
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(string(self), "---SwatPawn::SetIsStung(). Value="), string(Value)));
	}
	bIsStung = Value;
	return;
}

function SetIsStunnedByC2(bool Value)
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(string(self), "---SwatPawn::SetIsStunnedByC2(). Value="), string(Value)));
	}
	bIsStunnedByC2 = Value;
	return;
}

function SetIsTased(bool Value)
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(string(self), "---SwatPawn::SetIsTased(). Value="), string(Value)));
	}
	bIsTased = Value;
	return;
}

simulated function bool IsFlashbanged()
{
	return bIsFlashbanged;
	return;
}

simulated function bool IsGassed()
{
	return bIsGassed;
	return;
}

simulated function bool IsPepperSprayed()
{
	return bIsPepperSprayed;
	return;
}

simulated function bool IsStung()
{
	return bIsStung;
	return;
}

simulated function bool IsStunnedByC2()
{
	return bIsStunnedByC2;
	return;
}

simulated function bool IsTased()
{
	return bIsTased;
	return;
}

simulated function bool IsNonlethaled()
{
	return OrOr_BoolBool(OrOr_BoolBool(OrOr_BoolBool(OrOr_BoolBool(IsFlashbanged(), IsGassed()), IsPepperSprayed()), IsStung()), IsTased());
	return;
}

function ResetNonlethalEffects()
{
	return;
}

final simulated event bool GetDesiredFlashlightState()
{
	return FlashlightShouldBeOn;
	return;
}

simulated function float GetDelayBeforeFlashlightShutoff()
{
	if(OrOr_BoolBool(IsIncapacitated(), IsDead()))
	{
		return 10.0000000;
	}
	else
	{
		return 0.0000000;
	}
	return;
}

simulated function ToggleDesiredFlashlightState()
{
	ServerToggleDesiredFlashlightState();
	return;
}

function ServerToggleDesiredFlashlightState()
{
	SetDesiredFlashlightState(Not_PreBool(GetDesiredFlashlightState()));
	return;
}

simulated event FlashlightShouldBeOnChanged()
{
	UpdateFlashlight();
	return;
}

protected final simulated function SetDesiredFlashlightState(bool DesireFlashlightOn)
{
	local FiredWeapon CurrentWeapon;

	if(EqualEqual_BoolBool(FlashlightShouldBeOn, DesireFlashlightOn))
	{
		return;
	}
	CurrentWeapon = FiredWeapon(GetActiveItem());
	if(AndAnd_BoolBool(NotEqual_ObjectObject(none, CurrentWeapon), CurrentWeapon.HasFlashlight()))
	{
		FlashlightShouldBeOn = DesireFlashlightOn;
		UpdateFlashlight();
	}
	return;
}

simulated function UpdateFlashlight()
{
	local FiredWeapon CurrentWeapon;

	CurrentWeapon = FiredWeapon(GetActiveItem());
	if(NotEqual_ObjectObject(none, CurrentWeapon))
	{
		CurrentWeapon.OnHolderDesiredFlashlightStateChanged();
	}
	return;
}

simulated function OnPlayerViewChanged()
{
	if(NotEqual_ObjectObject(GetActiveItem(), none))
	{
		GetActiveItem().OnPlayerViewChanged();
	}
	return;
}

simulated function bool CanIssueComplianceTo(Pawn otherPawn)
{
	assert(NotEqual_ObjectObject(otherPawn, none));
	if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(otherPawn.IsA('SwatAICharacter'), LessEqual_FloatFloat(VSize(Subtract_VectorVector(otherPawn.Location, Location)), MaxComplianceIssueDistance)), LineOfSightTo(otherPawn)), NotEqual_ObjectObject(SwatCharacterResource(otherPawn.CharacterAI).CommonSensorAction.GetComplySensor(), none)))
	{
		return true;
	}
	return false;
	return;
}

simulated function bool HasFiredWeaponEquipped()
{
	return AndAnd_BoolBool(NotEqual_ObjectObject(GetActiveItem(), none), GetActiveItem().IsA('FiredWeapon'));
	return;
}

simulated function IssueComplianceTo(Pawn TargetPawn)
{
	assert(NotEqual_ObjectObject(TargetPawn, none));
	assert(TargetPawn.IsA('SwatAICharacter'));
	assert(NotEqual_ObjectObject(SwatCharacterResource(TargetPawn.CharacterAI).CommonSensorAction.GetComplySensor(), none));
	SwatCharacterResource(TargetPawn.CharacterAI).CommonSensorAction.GetComplySensor().NotifyComply(self);
	return;
}

simulated function bool IssueCompliance()
{
	local Pawn Iter;
	local bool ACharacterHasAWeaponEquipped;

	Iter = Level.PawnList;
	J0x14:

	if(NotEqual_ObjectObject(Iter, none))
	{
		if(Class'Engine.Pawn'.static.checkConscious(Iter))
		{
			if(CanIssueComplianceTo(Iter))
			{
				IssueComplianceTo(Iter);
				if(SwatPawn(Iter).HasFiredWeaponEquipped())
				{
					ACharacterHasAWeaponEquipped = true;
				}
			}
		}
		Iter = Iter.nextPawn;
		// [Loop Continue]
		goto J0x14;
	}
	return ACharacterHasAWeaponEquipped;
	return;
}

simulated function bool CanBeArrestedNow()
{
	return false;
	return;
}

simulated function bool IsBeingArrestedNow()
{
	return BeingArrested;
	return;
}

simulated function OnArrestBegan(Pawn Arrester)
{
	BeingArrested = true;
	return;
}

simulated function OnArrested(Pawn Arrester)
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(string(self), "---SwatPawn::OnArrested(). Arrester="), string(Arrester)));
	}
	if(Not_PreBool(bArrested))
	{
		ArrestedBy = Arrester;
		bArrested = true;
		BeingArrested = false;
		dispatchMessage(Class'SwatGame.MessagePawnArrested'.static.Allocate(self)., construct_NameName(Arrester.Label, Label));
		OnArrestedSwatPawn(Arrester);
	}
	return;
}

simulated function OnArrestedSwatPawn(Pawn Arrester)
{
	return;
}

simulated function OnUnarrestedSwatPawn(Pawn Unarrester)
{
	bArrested = false;
	return;
}

simulated function OnArrestInterrupted(Pawn Arrester)
{
	BeingArrested = false;
	return;
}

simulated function float GetQualifyTimeForArrest()
{
	return QualifyTimeForArrest;
	return;
}

// Export USwatPawn::execIsArrested(FFrame&, void* const)
native simulated function bool IsArrested();

simulated function Pawn GetArrester()
{
	return ArrestedBy;
	return;
}

simulated function bool WantsToContinueAutoFiring()
{
	return AndAnd_BoolBool(bWantsToContinueAutoFiring, Not_PreBool(IsNonlethaled()));
	return;
}

simulated function OnAutoFireStarted()
{
	bWantsToContinueAutoFiring = true;
	return;
}

simulated function OnFireModeChanged()
{
	if(IsControlledByLocalHuman())
	{
		UpdateHUDFireMode();
	}
	return;
}

simulated function OnMeshChanged()
{
	InitAnimationForCurrentMesh();
	return;
}

simulated function UpdateHUDFireMode()
{
	local SwatGamePlayerController PC;

	PC = SwatGamePlayerController(Controller);
	if(AndAnd_BoolBool(EqualEqual_ObjectObject(PC, Level.GetLocalPlayerController()), PC.HasHUDPage()))
	{
		SwatGamePlayerController(Controller).GetHUDPage().UpdateFireMode();
	}
	return;
}

function PostTakeDamage(int Damage, Pawn InstigatedBy, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType)
{
	local HandheldEquipment ActiveItem;

	super.PostTakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType);
	if(Greater_IntInt(Damage, 0))
	{
		if(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)))
		{
			SwatGameInfo(Level.Game).GameEvents.PawnDamaged.Triggered(self, InstigatedBy);
		}
		ActiveItem = GetActiveItem();
		if(AndAnd_BoolBool(NotEqual_ObjectObject(ActiveItem, none), ActiveItem.IsA('FiredWeapon')))
		{
			FiredWeapon(ActiveItem).AddAimError(3);
		}
	}
	return;
}

function OnEvidenceSecured(IEvidence Evidence)
{
	SwatGameInfo(Level.Game).GameEvents.EvidenceSecured.Triggered(Evidence);
	BroadcastEffectEvent('SecuredEvidence');
	return;
}

function int GetTeamNumber()
{
	return;
}

function UnPossessed()
{
	MenuName = PlayerReplicationInfo.PlayerName;
	super.UnPossessed();
	return;
}

simulated function BroadcastStopAllSounds()
{
	local Controller Itr;

	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
	{
		Itr = Level.ControllerList;
		J0x2D:

		if(NotEqual_ObjectObject(Itr, none))
		{
			if(Itr.IsA('SwatGamePlayerController'))
			{
				SwatGamePlayerController(Itr).ClientBroadcastStopAllSounds(self, UniqueID());
			}
			Itr = Itr.nextController;
			// [Loop Continue]
			goto J0x2D;
		}
	}
	else
	{
		StopAllSounds();
	}
	return;
}

simulated event StopAllSounds()
{
	SoundEffectsSubsystem(EffectsSystem(Level.EffectsSystem).GetSubsystem('SoundEffectsSubsystem')).StopMySchemas(self);
	return;
}

simulated function name GetPlayerTag()
{
	return 'None';
	return;
}

defaultproperties
{
	AnimFlags[0]=1
	AnimFlags[1]=1
	AnimFlags[2]=1
	AnimFlags[3]=1
	AnimFlags[4]=1
	AimBlendChangeTime=0.5000000
	InertialAimAcceleration=20.0000000
	InertialAimDeceleration=-5.0000000
	InertialAimMaxVelocity=10.0000000
	ShadowLightDistance=200.0000000
	ShadowExtraDrawScale=0.6250000
	MaxShadowTraceDistance=350.0000000
	ShadowCullDistance=750.0000000
	bCanCrouch=true
	bJumpCapable=false
	bCanJump=false
	bCanWalkOffLedges=true
	BaseEyeHeight=40.0000000
	CrouchRadius=24.0000000
	bPhysicsAnimUpdate=true
	CollisionSoftRadiusOffset=8.0000000
	bActorShadows=true
	bAcceptsShadowProjectors=false
	Mesh=SkeletalMesh'SWATMaleAnimation.SwatOfficer'
	Skins=/* Array type was not detected. */
	CollisionRadius=24.0000000
	CollisionHeight=68.0000000
	bUseCollisionBoneBoundingBox=true
	bTriggerEffectEventsBeforeGameStarts=true
}