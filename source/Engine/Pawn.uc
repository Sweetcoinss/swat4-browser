class Pawn extends Actor implements ICanHoldEquipment, ICanUseProtectiveEquipment
	abstract
	native
	nativereplication
	config(SwatPawn)
	placeable
	hidecategories(Karma);

const kMinRetestPathReachabilityDelta = 0.25;
const kMaxRetestPathReachabilityDelta = 0.75;
const kInvalidKillerLocationZ = -10000.0;

enum ELeanState
{
	kLeanStateNone,                 // 0
	kLeanStateLeft,                 // 1
	kLeanStateRight                 // 2
};

enum EAnimPlayType
{
	kAPT_Normal,                    // 0
	kAPT_Additive                   // 1
};

struct HavokCharacterObjectInteractionEvent
{
	var Vector Position;
	var Vector Normal;
	var float ObjectImpulse;
	var float Timestep;
	var float ProjectedVelocity;
	var float ObjectMassInv;
	var float CharacterMassInv;
	var Actor Body;
};

struct HavokCharacterObjectInteractionResult
{
	var Vector ObjectImpulse;
	var Vector ImpulsePosition;
	var Vector CharacterImpulse;
};

var Controller Controller;
var Vector m_LastSteerDirection;
var float m_LastSteerDirectionTime;
var Tyrion_ResourceBase CharacterAI;
var Tyrion_ResourceBase MovementAI;
var Tyrion_ResourceBase WeaponAI;
var bool logTyrion;
var bool logAI;
var Pawn nextPawn;
var bool bDisplayBattleDebug;
var float NetRelevancyTime;
var PlayerController LastRealViewer;
var Actor LastViewer;
var config float RelevancyPropogationDistance;
var config float RelevancyLOSDistance;
var bool bJustLanded;
var bool bUpAndOut;
var bool bIsWalking;
var bool bWarping;
var bool bWantsToCrouch;
var const bool bIsCrouched;
var const bool bTryToUncrouch;
var bool bCanCrouch;
var private bool bIsCurrentMeshRenderZValid;
var private float CurrentMeshRenderZ;
var private Controller LastUnPossessedController;
var private bool bForceCrouch;
var bool bWantsToLeanLeft;
var bool bWantsToLeanRight;
var const Pawn.ELeanState DesiredLeanState;
var const Pawn.ELeanState LeanState;
var const int LeanLockedYaw;
var const float LeanAlpha;
var private config float LeanTransitionDuration;
var private config float LeanHorizontalDistance;
var bool bCrawler;
var const bool bReducedSpeed;
var bool bJumpCapable;
var bool bCanJump;
var bool bCanWalk;
var bool bCanSwim;
var bool bCanFly;
var bool bCanStrafe;
var bool bCanDoubleJump;
var bool bAvoidLedges;
var bool bStopAtLedges;
var bool bNoJumpAdjust;
var bool bCountJumps;
var const bool bSimulateGravity;
var bool bUpdateEyeheight;
var bool bIgnoreForces;
var const bool bNoVelocityUpdate;
var bool bCanWalkOffLedges;
var bool bCanBeBaseForPawns;
var bool bClientCollision;
var const bool bSimGravityDisabled;
var bool bDirectHitWall;
var(Havok) bool bHavokCharacterCollisions "If true this pawn's bones will collide with Havok objects, push them out of the way, and generate collision events.";
var const transient bool bHavokInitCalled;
var(Havok) float bHavokCharacterCollisionExtraRadius "How much larger than the Unreal collision cylinder should the Havok collision cylinder be? Default is 1, which is enough to ensure that Havok can respond to collisions before Unreal does.\r" "\r" "WARNING: must be in Unreal units, not meters (1 Unreal unit == 1/50 meter)";
var bool bThumped;
var bool bInvulnerableBody;
var bool bIsFemale;
var bool bAutoActivate;
var bool bUpdatingDisplay;
var bool bAmbientCreature;
var(AI) bool bLOSHearing;
var(AI) bool bSameZoneHearing;
var(AI) bool bAdjacentZoneHearing;
var(AI) bool bMuffledHearing;
var(AI) bool bAroundCornerHearing;
var(AI) bool bDontPossess;
var bool bRollToDesired;
var bool bCachedRelevant;
var bool bUseCompressedPosition;
var config bool bWeaponBob;
var bool bHideRegularHUD;
var bool bSpecialHUD;
var bool bSpecialCalcView;
var bool bIsTyping;
var byte Visibility;
var float DesiredSpeed;
var float MaxDesiredSpeed;
var(AI) float HearingThreshold;
var(AI) float Alertness;
var(AI) float SightRadius;
var(AI) float PeripheralVision;
var float SkillModifier;
var const float AvgPhysicsTime;
var float MeleeRange;
var NavigationPoint Anchor;
var const NavigationPoint LastAnchor;
var float FindAnchorFailedTime;
var float LastValidAnchorTime;
var Vector LastValidAnchorLocation;
var float LastDistanceToAnchor;
var float DestinationOffset;
var float NextPathRadius;
var Vector SerpentineDir;
var float SerpentineDist;
var float SerpentineTime;
var const float UncrouchTime;
var float SpawnTime;
var const float VisionCounter;
var Range VisionUpdateRange;
var const array<Pawn> ViewablePawns;
var float NextPathReachabilityRetestedTime;
var bool bAlwaysUseWalkAimErrorWhenMoving;
var config float GroundSpeed;
var float WaterSpeed;
var float AirSpeed;
var float LadderSpeed;
var float AccelRate;
var float JumpZ;
var float AirControl;
var float MaxFallSpeed;
var Vector ConstantAcceleration;
var float ReachedDestinationThreshold;
var string OwnerName;
var config float BaseEyeHeight;
var config float CrouchEyeHeight;
var float EyeHeight;
var const Vector Floor;
var float SplashTime;
var config float CrouchHeight;
var config float CrouchRadius;
var float OldZ;
var PhysicsVolume HeadVolume;
var travel int Health;
var float LastPainTime;
var Class<DamageType> ReducedDamageType;
var float HeadScale;
var const Vector noise1spot;
var const float noise1time;
var const Pawn noise1other;
var const float noise1loudness;
var const Vector noise2spot;
var const float noise2time;
var const Pawn noise2other;
var const float noise2loudness;
var float LastPainSound;
var config float Bob;
var float LandBob;
var float AppliedBob;
var float bobtime;
var Vector WalkBob;
var float SoundDampening;
var float DamageScaling;
var localized string MenuName;
var ShadowProjector Shadow;
var Class<Effects> BloodEffect;
var Class<Effects> LowGoreBlood;
var(AI) string ControllerClassName;
var PlayerReplicationInfo PlayerReplicationInfo;
var name LandMovementState;
var name WaterMovementState;
var PlayerStart LastStartSpot;
var float LastStartTime;
var name AnimAction;
var Vector DeathHitLocation;
var Vector KillerLocation;
var Class<DamageType> DeathHitDamageType;
var Vector DeathHitMomentum;
var bool bPhysicsAnimUpdate;
var bool bWasCrouched;
var bool bWasWalking;
var bool bWasOnGround;
var bool bInitializeAnimation;
var bool bPlayedDeath;
var Actor.EPhysics OldPhysics;
var float OldRotYaw;
var Vector OldAcceleration;
var float BaseMovementRate;
var name MovementAnims[4];
var name TurnLeftAnim;
var name TurnRightAnim;
var(AnimTweaks) float BlendChangeTime;
var float MovementBlendStartTime;
var float ForwardStrafeBias;
var float BackwardStrafeBias;
var transient CompressedPosition PawnPosition;
var config float FirstPersonFOV;
var private Hands Hands;
var bool bRenderHands;
var private HandheldEquipment ActiveItem;
var private HandheldEquipment PendingItem;
var private HandheldEquipment.Pocket DesiredItemPocket;
var bool HasEquippedFirstItemYet;
var(Collision) const float CollisionSoftRadiusOffset;
var private int LastCollisionAvoidanceTick;
var private bool bCollisionAvoidanceEnabled;
var private bool bAvoidingCollision;
var private Door MovingThroughDoor;
var private CollisionAvoidanceNotifier CollisionAvoidanceNotifier;
var array<SkeletalRegionInformation> SkeletalRegionInformation;
var array<ProtectiveEquipment> SkeletalRegionProtection;
var float AccumulatedLimbInjury;
var private const bool bNotifiedDeathListeners;

replication
{
	// Pos:0x000
	reliable if(AndAnd_BoolBool(bNetDirty, EqualEqual_IntInt(int(Role), int(ROLE_Authority))))
		AnimAction, DeathHitDamageType,
		DeathHitLocation, HeadScale,
		KillerLocation, PlayerReplicationInfo,
		bForceCrouch, bIsCrouched,
		bIsTyping, bIsWalking,
		bSimulateGravity;

	// Pos:0x018
	reliable if(AndAnd_BoolBool(AndAnd_BoolBool(bTearOff, bNetDirty), EqualEqual_IntInt(int(Role), int(ROLE_Authority))))
		DeathHitMomentum;

	// Pos:0x03B
	reliable if(AndAnd_BoolBool(AndAnd_BoolBool(bNetDirty, bNetOwner), EqualEqual_IntInt(int(Role), int(ROLE_Authority))))
		AccelRate, AirControl,
		AirSpeed, Controller,
		GroundSpeed, JumpZ,
		WaterSpeed;

	// Pos:0x05E
	reliable if(AndAnd_BoolBool(bNetDirty, EqualEqual_IntInt(int(Role), int(ROLE_Authority))))
		DesiredItemPocket, Health;

	// Pos:0x076
	reliable if(AndAnd_BoolBool(Not_PreBool(bNetOwner), EqualEqual_IntInt(int(Role), int(ROLE_Authority))))
		DesiredLeanState, PawnPosition;

	// Pos:0x090
	reliable if(Less_IntInt(int(Role), int(ROLE_Authority)))
		ServerBeginFiringWeapon, ServerEndFiringWeapon,
		ServerRequestEquip, ServerRequestReload,
		ServerSetCurrentFireMode;
}

// Export UPawn::execAddPawn(FFrame&, void* const)
native function AddPawn();

// Export UPawn::execRemovePawn(FFrame&, void* const)
native function RemovePawn();

final function NotifyKilled(Controller Killer, Controller Killed, Pawn Other)
{
	if(NotEqual_ObjectObject(Controller, none))
	{
		Controller.NotifyKilled(Killer, Killed, Other);
	}
	return;
}

event bool IgnoresSeenPawnsOfType(Class<Pawn> SeenType)
{
	return false;
	return;
}

// Export UPawn::execCanSee(FFrame&, void* const)
native function bool CanSee(Actor Other);

event bool CanHitTargetAt(Actor Target, Vector AILocation)
{
	return false;
	return;
}

event bool CanHit(Actor Target)
{
	return false;
	return;
}

event bool HavokCharacterCollision(HavokCharacterObjectInteractionEvent data, out HavokCharacterObjectInteractionResult res)
{
	return false;
	return;
}

simulated event SetHeadScale(float NewScale)
{
	return;
}

// Export UPawn::execIsActorReachable(FFrame&, void* const)
native final function bool IsActorReachable(Actor Actor);

// Export UPawn::execIsLocationReachable(FFrame&, void* const)
native final function bool IsLocationReachable(Vector Location);

// Export UPawn::execFitsAtLocation(FFrame&, void* const)
native final function bool FitsAtLocation(Vector NewLocation);

// Export UPawn::execIsDoorBlockedForPawn(FFrame&, void* const)
native function bool IsDoorBlockedForPawn(Door Target);

function DisableCollisionAvoidance()
{
	bCollisionAvoidanceEnabled = false;
	return;
}

function EnableCollisionAvoidance()
{
	bCollisionAvoidanceEnabled = true;
	return;
}

function bool IsCollisionAvoidanceEnabled()
{
	return bCollisionAvoidanceEnabled;
	return;
}

function bool IsAtRunningSpeed()
{
	return GreaterEqual_FloatFloat(VSize(Velocity), default.GroundSpeed);
	return;
}

// Export UPawn::execClearRouteCache(FFrame&, void* const)
native function ClearRouteCache();

// Export UPawn::execReachedDestination(FFrame&, void* const)
native function bool ReachedDestination(Actor Goal);

// Export UPawn::execReachedLocation(FFrame&, void* const)
native function bool ReachedLocation(Vector Location);

// Export UPawn::execForceCrouchThisTick(FFrame&, void* const)
native function ForceCrouchThisTick();

simulated function SetForceCrouchState(bool inbForceCrouch)
{
	bForceCrouch = inbForceCrouch;
	return;
}

function Reset()
{
	if(OrOr_BoolBool(EqualEqual_ObjectObject(Controller, none), Controller.bIsPlayer))
	{
		Destroy();
	}
	else
	{
		super.Reset();
	}
	return;
}

function DrawHUD(Canvas Canvas)
{
	return;
}

function bool SpecialCalcView(out Actor ViewActor, out Vector CameraLocation, out Rotator CameraRotation)
{
	return;
}

simulated function bool IsControlledByLocalHuman()
{
	if(EqualEqual_ObjectObject(PlayerController(Controller), none))
	{
		return false;
	}
	if(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_IntInt(int(Level.NetMode), int(NM_DedicatedServer)), NotEqual_ObjectObject(Controller, none)), EqualEqual_ObjectObject(Controller, Level.GetLocalPlayerController())))
	{
		return true;
	}
	return false;
	return;
}

simulated function bool IsPrimaryWeapon(HandheldEquipment theItem)
{
	assert(false);
	return false;
	return;
}

simulated function string GetHumanReadableName()
{
	if(AndAnd_BoolBool(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)), NotEqual_ObjectObject(PlayerReplicationInfo, none)))
	{
		return PlayerReplicationInfo.PlayerName;
	}
	return MenuName;
	return;
}

simulated function string GetHumanReadableTeamName()
{
	if(AndAnd_BoolBool(NotEqual_ObjectObject(PlayerReplicationInfo, none), NotEqual_ObjectObject(PlayerReplicationInfo.Team, none)))
	{
		return PlayerReplicationInfo.Team.TeamName;
	}
	return "";
	return;
}

function PlayTeleportEffect(bool bOut, bool bSound)
{
	MakeNoise(1.0000000);
	return;
}

function PossessedBy(Controller C)
{
	Controller = C;
	NetPriority = 3.0000000;
	if(NotEqual_ObjectObject(C.PlayerReplicationInfo, none))
	{
		PlayerReplicationInfo = C.PlayerReplicationInfo;
		OwnerName = PlayerReplicationInfo.PlayerName;
	}
	if(C.IsA('PlayerController'))
	{
		if(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
		{
			RemoteRole = ROLE_AutonomousProxy;
		}
		BecomeViewTarget();
	}
	else
	{
		RemoteRole = default.RemoteRole;
	}
	SetOwner(Controller);
	EyeHeight = BaseEyeHeight;
	ChangeAnimation();
	return;
}

function UnPossessed()
{
	LastUnPossessedController = Controller;
	PlayerReplicationInfo = none;
	SetOwner(none);
	Controller = none;
	return;
}

simulated function bool PointOfView()
{
	return false;
	return;
}

function BecomeViewTarget()
{
	bUpdateEyeheight = true;
	return;
}

function DropToGround()
{
	bCollideWorld = true;
	bInterpolating = false;
	if(Greater_IntInt(Health, 0))
	{
		SetCollision(true, true, true);
		SetPhysics(2);
		if(IsHumanControlled())
		{
			Controller.GotoState(LandMovementState);
		}
	}
	return;
}

event SetWalking(bool bNewIsWalking)
{
	if(NotEqual_BoolBool(bNewIsWalking, bIsWalking))
	{
		bIsWalking = bNewIsWalking;
		ChangeAnimation();
	}
	return;
}

function bool CanSplash()
{
	if(AndAnd_BoolBool(AndAnd_BoolBool(Greater_FloatFloat(Subtract_FloatFloat(Level.TimeSeconds, SplashTime), 0.2500000), OrOr_BoolBool(EqualEqual_IntInt(int(Physics), int(2)), EqualEqual_IntInt(int(Physics), int(4)))), Greater_FloatFloat(Abs(Velocity.Z), float(100))))
	{
		SplashTime = Level.TimeSeconds;
		return true;
	}
	return false;
	return;
}

simulated function DisplayDebug(Canvas Canvas, out float YL, out float YPos)
{
	local string t;

	super.DisplayDebug(Canvas, YL, YPos);
	Canvas.SetDrawColor(byte(255), byte(255), byte(255));
	Canvas.DrawText(Concat_StrStr(Concat_StrStr(Concat_StrStr("Animation Action ", string(AnimAction)), " Health "), string(Health)));
	AddEqual_FloatFloat(YPos, YL);
	Canvas.SetPos(4.0000000, YPos);
	Canvas.DrawText(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("Anchor ", string(Anchor)), " Serpentine Dist "), string(SerpentineDist)), " Time "), string(SerpentineTime)));
	AddEqual_FloatFloat(YPos, YL);
	Canvas.SetPos(4.0000000, YPos);
	t = Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("Floor ", string(Floor)), " DesiredSpeed "), string(DesiredSpeed)), " Crouched "), string(bIsCrouched)), " Try to uncrouch "), string(UncrouchTime));
	Canvas.DrawText(t);
	AddEqual_FloatFloat(YPos, YL);
	Canvas.SetPos(4.0000000, YPos);
	Canvas.DrawText(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("EyeHeight ", string(EyeHeight)), " BaseEyeHeight "), string(BaseEyeHeight)), " Physics Anim "), string(bPhysicsAnimUpdate)));
	AddEqual_FloatFloat(YPos, YL);
	Canvas.SetPos(4.0000000, YPos);
	if(EqualEqual_ObjectObject(Controller, none))
	{
		Canvas.SetDrawColor(byte(255), 0, 0);
		Canvas.DrawText("NO CONTROLLER");
		AddEqual_FloatFloat(YPos, YL);
		Canvas.SetPos(4.0000000, YPos);
	}
	else
	{
		Controller.DisplayDebug(Canvas, YL, YPos);
	}
	if(EqualEqual_ObjectObject(GetActiveItem(), none))
	{
		Canvas.SetDrawColor(0, byte(255), 0);
		Canvas.DrawText("NO ACTIVE ITEM");
		AddEqual_FloatFloat(YPos, YL);
		Canvas.SetPos(4.0000000, YPos);
	}
	else
	{
		GetActiveItem().DisplayDebug(Canvas, YL, YPos);
	}
	return;
}

simulated function Vector CalcDrawOffset()
{
	local Vector DrawOffset;

	AssertWithDescription(NotEqual_ObjectObject(Hands, none), Concat_StrStr(Concat_StrStr("[tcohen] The Pawn named ", string(Name)), " was called to CalcDrawOffset().  But it has no Hands."));
	if(EqualEqual_ObjectObject(Controller, none))
	{
		return Add_VectorVector(GreaterGreater_VectorRotator(Hands.PlayerViewOffset, Rotation), Multiply_FloatVector(BaseEyeHeight, vect(0.0000000, 0.0000000, 1.0000000)));
	}
	DrawOffset = GreaterGreater_VectorRotator(Multiply_FloatVector(Divide_FloatFloat(float(90), FirstPersonFOV), Hands.PlayerViewOffset), GetViewRotation());
	if(Not_PreBool(IsLocallyControlled()))
	{
		AddEqual_FloatFloat(DrawOffset.Z, BaseEyeHeight);
	}
	else
	{
		AddEqual_FloatFloat(DrawOffset.Z, EyeHeight);
		if(AndAnd_BoolBool(bWeaponBob, NotEqual_ObjectObject(GetActiveItem(), none)))
		{
			AddEqual_VectorVector(DrawOffset, WeaponBob(0.0000000));
		}
	}
	return DrawOffset;
	return;
}

function Vector WeaponBob(float BobDamping)
{
	local Vector WBob;

	WBob = Multiply_FloatVector(BobDamping, WalkBob);
	WBob.Z = Multiply_FloatFloat(Add_FloatFloat(0.4500000, Multiply_FloatFloat(0.5500000, BobDamping)), WalkBob.Z);
	return WBob;
	return;
}

function CheckBob(float DeltaTime, Vector Y)
{
	local float Speed2D;

	if(Not_PreBool(bWeaponBob))
	{
		bobtime = 0.0000000;
		WalkBob = vect(0.0000000, 0.0000000, 0.0000000);
		return;
	}
	Bob = FClamp(Bob, -0.0100000, 0.0100000);
	if(EqualEqual_IntInt(int(Physics), int(1)))
	{
		Speed2D = VSize(Velocity);
		if(Less_FloatFloat(Speed2D, float(10)))
		{
			AddEqual_FloatFloat(bobtime, Multiply_FloatFloat(0.2000000, DeltaTime));
		}
		else
		{
			AddEqual_FloatFloat(bobtime, Multiply_FloatFloat(DeltaTime, Add_FloatFloat(0.3000000, Divide_FloatFloat(Multiply_FloatFloat(0.7000000, Speed2D), GroundSpeed))));
		}
		WalkBob = Multiply_VectorFloat(Multiply_VectorFloat(Multiply_VectorFloat(Y, Bob), Speed2D), Sin(Multiply_FloatFloat(8.0000000, bobtime)));
		AppliedBob = Multiply_FloatFloat(AppliedBob, Subtract_FloatFloat(float(1), FMin(1.0000000, Multiply_FloatFloat(16.0000000, DeltaTime))));
		WalkBob.Z = AppliedBob;
		if(Greater_FloatFloat(Speed2D, float(10)))
		{
			WalkBob.Z = Add_FloatFloat(WalkBob.Z, Multiply_FloatFloat(Multiply_FloatFloat(Multiply_FloatFloat(0.7500000, Bob), Speed2D), Sin(Multiply_FloatFloat(16.0000000, bobtime))));
		}
		if(Greater_FloatFloat(LandBob, 0.0100000))
		{
			AddEqual_FloatFloat(AppliedBob, Multiply_FloatFloat(FMin(1.0000000, Multiply_FloatFloat(16.0000000, DeltaTime)), LandBob));
			MultiplyEqual_FloatFloat(LandBob, Subtract_FloatFloat(float(1), Multiply_FloatFloat(float(8), DeltaTime)));
		}
	}
	else
	{
		if(EqualEqual_IntInt(int(Physics), int(3)))
		{
			Speed2D = Sqrt(Add_FloatFloat(Multiply_FloatFloat(Velocity.X, Velocity.X), Multiply_FloatFloat(Velocity.Y, Velocity.Y)));
			WalkBob = Multiply_VectorFloat(Multiply_VectorFloat(Multiply_VectorFloat(Multiply_VectorFloat(Y, Bob), 0.5000000), Speed2D), Sin(Multiply_FloatFloat(4.0000000, Level.TimeSeconds)));
			WalkBob.Z = Multiply_FloatFloat(Multiply_FloatFloat(Multiply_FloatFloat(Bob, 1.5000000), Speed2D), Sin(Multiply_FloatFloat(8.0000000, Level.TimeSeconds)));
		}
		else
		{
			bobtime = 0.0000000;
			WalkBob = Multiply_VectorFloat(WalkBob, Subtract_FloatFloat(float(1), FMin(1.0000000, Multiply_FloatFloat(8.0000000, DeltaTime))));
		}
	}
	return;
}

simulated function bool IsPlayerPawn()
{
	return AndAnd_BoolBool(NotEqual_ObjectObject(Controller, none), Controller.bIsPlayer);
	return;
}

simulated function bool WasPlayerPawn()
{
	return false;
	return;
}

simulated function bool IsHumanControlled()
{
	return NotEqual_ObjectObject(PlayerController(Controller), none);
	return;
}

simulated function bool IsLocallyControlled()
{
	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
	{
		return true;
	}
	if(EqualEqual_ObjectObject(Controller, none))
	{
		return false;
	}
	if(EqualEqual_ObjectObject(PlayerController(Controller), none))
	{
		return true;
	}
	return NotEqual_ObjectObject(Viewport(PlayerController(Controller).Player), none);
	return;
}

simulated function bool IsFirstPerson()
{
	local PlayerController PC;

	PC = PlayerController(Controller);
	return AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(PC, none), Not_PreBool(PC.bBehindView)), NotEqual_ObjectObject(Viewport(PC.Player), none));
	return;
}

simulated function Rotator GetViewRotation()
{
	if(EqualEqual_ObjectObject(Controller, none))
	{
		return Rotation;
	}
	return Controller.GetViewRotation();
	return;
}

simulated function SetViewLocation(Vector NewLocation)
{
	if(NotEqual_ObjectObject(Controller, none))
	{
		Controller.SetLocation(NewLocation);
	}
	return;
}

simulated function SetViewRotation(Rotator NewRotation)
{
	if(NotEqual_ObjectObject(Controller, none))
	{
		Controller.SetRotation(NewRotation);
	}
	return;
}

simulated function Rotator GetAimRotation()
{
	local Rotator R;

	assert(false);
	return R;
	return;
}

simulated function Vector GetAimOrigin()
{
	return Add_VectorVector(Location, EyePosition());
	return;
}

simulated function Vector GetThirdPersonEyesLocation()
{
	return;
}

simulated function float GetFireTweenTime()
{
	return 0.0000000;
	return;
}

final function bool InGodMode()
{
	return AndAnd_BoolBool(NotEqual_ObjectObject(Controller, none), Controller.bGodMode);
	return;
}

function bool NearMoveTarget()
{
	if(OrOr_BoolBool(EqualEqual_ObjectObject(Controller, none), EqualEqual_ObjectObject(Controller.MoveTarget, none)))
	{
		return false;
	}
	return ReachedDestination(Controller.MoveTarget);
	return;
}

final simulated function bool PressingFire()
{
	return AndAnd_BoolBool(NotEqual_ObjectObject(Controller, none), NotEqual_IntInt(int(Controller.bFire), 0));
	return;
}

final simulated function bool PressingAltFire()
{
	return AndAnd_BoolBool(NotEqual_ObjectObject(Controller, none), NotEqual_IntInt(int(Controller.bAltFire), 0));
	return;
}

function Actor GetMoveTarget()
{
	if(EqualEqual_ObjectObject(Controller, none))
	{
		return none;
	}
	return Controller.MoveTarget;
	return;
}

function SetMoveTarget(Actor NewTarget)
{
	if(NotEqual_ObjectObject(Controller, none))
	{
		Controller.MoveTarget = NewTarget;
	}
	return;
}

// Export UPawn::execLineOfSightTo(FFrame&, void* const)
native function bool LineOfSightTo(Actor Other);

simulated function Rotator AdjustAim(Ammunition FiredAmmunition, Vector projStart, int aimerror)
{
	if(EqualEqual_ObjectObject(Controller, none))
	{
		return Rotation;
	}
	return Controller.AdjustAim(FiredAmmunition, projStart, aimerror);
	return;
}

function float AdjustedStrength()
{
	return 0.0000000;
	return;
}

function ReceiveLocalizedMessage(Class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	if(NotEqual_ObjectObject(PlayerController(Controller), none))
	{
		PlayerController(Controller).ReceiveLocalizedMessage(Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
	}
	return;
}

event ClientMessage(coerce string S, optional name Type)
{
	if(NotEqual_ObjectObject(PlayerController(Controller), none))
	{
		PlayerController(Controller).ClientMessage(S, Type);
	}
	return;
}

function Trigger(Actor Other, Pawn EventInstigator)
{
	if(NotEqual_ObjectObject(Controller, none))
	{
		Controller.Trigger(Other, EventInstigator);
	}
	return;
}

function bool CanTrigger(Trigger t)
{
	return true;
	return;
}

function SetDisplayProperties(Actor.ERenderStyle NewStyle, Material NewTexture, bool bLighting)
{
	Style = NewStyle;
	Texture = NewTexture;
	bUnlit = bLighting;
	if(AndAnd_BoolBool(Not_PreBool(bUpdatingDisplay), NotEqual_ObjectObject(Inventory, none)))
	{
		bUpdatingDisplay = true;
		Inventory.SetOwnerDisplay();
	}
	bUpdatingDisplay = false;
	return;
}

function SetDefaultDisplayProperties()
{
	Style = default.Style;
	Texture = default.Texture;
	bUnlit = default.bUnlit;
	if(AndAnd_BoolBool(Not_PreBool(bUpdatingDisplay), NotEqual_ObjectObject(Inventory, none)))
	{
		bUpdatingDisplay = true;
		Inventory.SetOwnerDisplay();
	}
	bUpdatingDisplay = false;
	return;
}

function FinishedInterpolation()
{
	DropToGround();
	return;
}

function JumpOutOfWater(Vector jumpDir)
{
	Falling();
	Velocity = Multiply_VectorFloat(jumpDir, WaterSpeed);
	Acceleration = Multiply_VectorFloat(jumpDir, AccelRate);
	Velocity.Z = FMax(380.0000000, JumpZ);
	bUpAndOut = true;
	return;
}

simulated event ModifyVelocity(float DeltaTime, Vector OldVelocity)
{
	return;
}

event FellOutOfWorld(Actor.eKillZType KillType)
{
	if(Less_IntInt(int(Role), int(ROLE_Authority)))
	{
		return;
	}
	if(AndAnd_BoolBool(NotEqual_ObjectObject(Controller, none), Controller.AvoidCertainDeath()))
	{
		return;
	}
	Health = -1;
	if(EqualEqual_IntInt(int(KillType), int(1)))
	{
		Died(none, Class'Engine.fell', Location, vect(0.0000000, 0.0000000, 0.0000000));
	}
	else
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[ckline]: !!!! WARNING !!!!! Pawn ", string(self)), " in base Pawn state and Physics="), string(GetEnum(Enum'Engine.Actor.EPhysics', int(Physics)))), " fell out of the world and Died()! Pawn's location = "), string(Location)), ", look around this area in the editor for gaps in bsp."));
		SetPhysics(0);
		Died(none, Class'Engine.fell', Location, vect(0.0000000, 0.0000000, 0.0000000));
	}
	return;
}

function ShouldCrouch(bool Crouch)
{
	bWantsToCrouch = Crouch;
	return;
}

event EndCrouch(float HeightAdjust)
{
	SubtractEqual_FloatFloat(EyeHeight, HeightAdjust);
	AddEqual_FloatFloat(OldZ, HeightAdjust);
	BaseEyeHeight = default.BaseEyeHeight;
	return;
}

event StartCrouch(float HeightAdjust)
{
	AddEqual_FloatFloat(EyeHeight, HeightAdjust);
	SubtractEqual_FloatFloat(OldZ, HeightAdjust);
	BaseEyeHeight = CrouchEyeHeight;
	return;
}

// Export UPawn::execLean(FFrame&, void* const)
native function Lean(Pawn.ELeanState inLeanState);

// Export UPawn::execUnLean(FFrame&, void* const)
native function UnLean();

function ShouldLeanLeft(bool Lean)
{
	bWantsToLeanLeft = Lean;
	return;
}

function ShouldLeanRight(bool Lean)
{
	bWantsToLeanRight = Lean;
	return;
}

event OnLeanStateChange()
{
	return;
}

// Export UPawn::execGetLeanYawRanges(FFrame&, void* const)
native function GetLeanYawRanges(out int LeftYawLimit, out int RightYawLimit);

// Export UPawn::execCanLean(FFrame&, void* const)
native function bool CanLean(Pawn.ELeanState inLeanState, Vector testLocation, Rotator testRotation);

function RestartPlayer()
{
	return;
}

function AddVelocity(Vector NewVelocity)
{
	if(OrOr_BoolBool(bIgnoreForces, EqualEqual_VectorVector(NewVelocity, vect(0.0000000, 0.0000000, 0.0000000))))
	{
		return;
	}
	NewVelocity.Z = 0.0000000;
	if(AndAnd_BoolBool(Greater_FloatFloat(Velocity.Z, float(380)), Greater_FloatFloat(NewVelocity.Z, float(0))))
	{
		MultiplyEqual_FloatFloat(NewVelocity.Z, 0.5000000);
	}
	AddEqual_VectorVector(Velocity, NewVelocity);
	return;
}

function KilledBy(Pawn EventInstigator)
{
	local Controller Killer;

	Health = 0;
	if(NotEqual_ObjectObject(EventInstigator, none))
	{
		Killer = EventInstigator.Controller;
	}
	Died(Killer, Class'Engine.Suicided', Location, vect(0.0000000, 0.0000000, 0.0000000));
	return;
}

function TakeFallingDamage()
{
	local float Shake, EffectiveSpeed;

	if(Less_FloatFloat(Velocity.Z, Multiply_FloatFloat(-0.5000000, MaxFallSpeed)))
	{
		if(EqualEqual_IntInt(int(Role), int(ROLE_Authority)))
		{
			MakeNoise(1.0000000);
			if(Less_FloatFloat(Velocity.Z, Multiply_FloatFloat(float(-1), MaxFallSpeed)))
			{
				EffectiveSpeed = Velocity.Z;
				if(TouchingWaterVolume())
				{
					EffectiveSpeed = FMin(0.0000000, Add_FloatFloat(EffectiveSpeed, float(100)));
				}
				if(Less_FloatFloat(EffectiveSpeed, Multiply_FloatFloat(float(-1), MaxFallSpeed)))
				{
					TakeDamage(int(Divide_FloatFloat(Multiply_FloatFloat(float(-100), Add_FloatFloat(EffectiveSpeed, MaxFallSpeed)), MaxFallSpeed)), none, Location, vect(0.0000000, 0.0000000, 0.0000000), Class'Engine.fell');
				}
			}
		}
		if(NotEqual_ObjectObject(Controller, none))
		{
			Shake = FMin(1.0000000, Divide_FloatFloat(Multiply_FloatFloat(-1.0000000, Velocity.Z), MaxFallSpeed));
			Controller.ShakeView(Add_FloatFloat(0.1750000, Multiply_FloatFloat(0.1000000, Shake)), Multiply_FloatFloat(850.0000000, Shake), Multiply_FloatVector(Shake, vect(0.0000000, 0.0000000, 1.5000000)), 120000.0000000, vect(0.0000000, 0.0000000, 10.0000000), 1.0000000);
		}
	}
	else
	{
		if(Less_FloatFloat(Velocity.Z, Multiply_FloatFloat(-1.4000000, JumpZ)))
		{
			MakeNoise(0.5000000);
		}
	}
	return;
}

function ClientRestart()
{
	Velocity = vect(0.0000000, 0.0000000, 0.0000000);
	Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
	BaseEyeHeight = default.BaseEyeHeight;
	EyeHeight = BaseEyeHeight;
	PlayWaiting();
	return;
}

function ClientSetLocation(Vector NewLocation, Rotator NewRotation)
{
	if(NotEqual_ObjectObject(Controller, none))
	{
		Controller.ClientSetLocation(NewLocation, NewRotation);
	}
	return;
}

function ClientSetRotation(Rotator NewRotation)
{
	if(NotEqual_ObjectObject(Controller, none))
	{
		Controller.ClientSetRotation(NewRotation);
	}
	return;
}

simulated function FaceRotation(Rotator NewRotation)
{
	if(false)
	{
	}
	else
	{
		if(OrOr_BoolBool(EqualEqual_IntInt(int(Physics), int(1)), EqualEqual_IntInt(int(Physics), int(2))))
		{
			NewRotation.Pitch = 0;
		}
		SetRotation(NewRotation);
	}
	return;
}

function ClientDying(Class<DamageType> DamageType, Vector HitLocation, Vector HitMomentum, Vector inKillerLocation)
{
	if(NotEqual_ObjectObject(Controller, none))
	{
		Controller.ClientDying(DamageType, HitLocation, HitMomentum, inKillerLocation);
	}
	return;
}

function bool InCurrentCombo()
{
	return false;
	return;
}

function ServerRequestEquip(HandheldEquipment.EquipmentSlot Slot)
{
	return;
}

simulated function bool ValidateEquipSlot(HandheldEquipment.EquipmentSlot Slot)
{
	assert(false);
	return false;
	return;
}

event bool EncroachingOn(Actor Other)
{
	if(Other.bWorldGeometry)
	{
		return true;
	}
	if(AndAnd_BoolBool(OrOr_BoolBool(OrOr_BoolBool(EqualEqual_ObjectObject(Controller, none), Not_PreBool(Controller.bIsPlayer)), bWarping), NotEqual_ObjectObject(Pawn(Other), none)))
	{
		return true;
	}
	return false;
	return;
}

event EncroachedBy(Actor Other)
{
	return;
}

function JumpOffPawn()
{
	AddEqual_VectorVector(Velocity, Multiply_FloatVector(Add_FloatFloat(float(100), CollisionRadius), VRand()));
	Velocity.Z = Add_FloatFloat(200.0000000, CollisionHeight);
	SetPhysics(2);
	bNoJumpAdjust = true;
	Controller.SetFall();
	return;
}

singular event BaseChange()
{
	local float decorMass;

	if(bInterpolating)
	{
		return;
	}
	if(AndAnd_BoolBool(EqualEqual_ObjectObject(Base, none), EqualEqual_IntInt(int(Physics), int(0))))
	{
		SetPhysics(2);
	}
	else
	{
		if(NotEqual_ObjectObject(Pawn(Base), none))
		{
			if(Not_PreBool(Pawn(Base).bCanBeBaseForPawns))
			{
				JumpOffPawn();
			}
		}
		else
		{
			if(AndAnd_BoolBool(NotEqual_ObjectObject(Decoration(Base), none), Less_FloatFloat(Velocity.Z, float(-400))))
			{
				decorMass = FMax(Decoration(Base).Mass, 1.0000000);
				Base.TakeDamage(int(Divide_FloatFloat(Multiply_FloatFloat(Divide_FloatFloat(Multiply_FloatFloat(float(-2), Mass), decorMass), Velocity.Z), float(400))), self, Location, Multiply_FloatVector(0.5000000, Velocity), Class'Engine.Crushed');
			}
		}
	}
	return;
}

event UpdateEyeHeight(float DeltaTime)
{
	local float smooth, MaxEyeHeight, OldEyeHeight;
	local Actor HitActor;
	local Vector HitLocation, HitNormal;

	if(EqualEqual_ObjectObject(Controller, none))
	{
		EyeHeight = 0.0000000;
		return;
	}
	if(bTearOff)
	{
		EyeHeight = 0.0000000;
		bUpdateEyeheight = false;
		return;
	}
	HitActor = Trace(HitLocation, HitNormal, Add_VectorVector(Location, Multiply_FloatVector(Add_FloatFloat(Add_FloatFloat(CollisionHeight, 16.0000000), float(14)), vect(0.0000000, 0.0000000, 1.0000000))), Add_VectorVector(Location, Multiply_FloatVector(CollisionHeight, vect(0.0000000, 0.0000000, 1.0000000))), true);
	if(EqualEqual_ObjectObject(HitActor, none))
	{
		MaxEyeHeight = Add_FloatFloat(CollisionHeight, 16.0000000);
	}
	else
	{
		MaxEyeHeight = Subtract_FloatFloat(Subtract_FloatFloat(HitLocation.Z, Location.Z), float(14));
	}
	smooth = FMin(1.0000000, Divide_FloatFloat(Multiply_FloatFloat(10.0000000, DeltaTime), Level.TimeDilation));
	if(Controller.WantsSmoothedView())
	{
		OldEyeHeight = EyeHeight;
		EyeHeight = FClamp(Add_FloatFloat(Multiply_FloatFloat(Add_FloatFloat(Subtract_FloatFloat(EyeHeight, Location.Z), OldZ), Subtract_FloatFloat(float(1), smooth)), Multiply_FloatFloat(BaseEyeHeight, smooth)), Multiply_FloatFloat(-0.5000000, CollisionHeight), MaxEyeHeight);
	}
	else
	{
		bJustLanded = false;
		EyeHeight = FMin(Add_FloatFloat(Multiply_FloatFloat(EyeHeight, Subtract_FloatFloat(float(1), smooth)), Multiply_FloatFloat(BaseEyeHeight, smooth)), MaxEyeHeight);
	}
	Controller.AdjustView(DeltaTime);
	return;
}

// Export UPawn::execEyePosition(FFrame&, void* const)
native function Vector EyePosition();

// Export UPawn::execAddViewablePawn(FFrame&, void* const)
native function AddViewablePawn(Pawn NewViewablePawn);

// Export UPawn::execGetYawEdgeAlpha(FFrame&, void* const)
native function float GetYawEdgeAlpha(int Pitch);

simulated event Destroyed()
{
	local int i;

	if(NotEqual_ObjectObject(MovingThroughDoor, none))
	{
		i = 0;
		J0x12:

		if(Less_IntInt(i, MovingThroughDoor.CurrentlyMovingThroughDoor.Length))
		{
			if(EqualEqual_ObjectObject(MovingThroughDoor.CurrentlyMovingThroughDoor[i], self))
			{
				MovingThroughDoor.CurrentlyMovingThroughDoor.Remove(i, 1);
				// [Explicit Break]
				goto J0x67;
			}
			AddAdd_PreInt(i);
			// [Loop Continue]
			goto J0x12;
		}
		J0x67:

		MovingThroughDoor = none;
	}
	NotifyPawnDeathListeners();
	RemovePawn();
	if(NotEqual_ObjectObject(Shadow, none))
	{
		Shadow.Destroy();
	}
	if(NotEqual_ObjectObject(Controller, none))
	{
		Controller.PawnDied(self);
	}
	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)))
	{
		J0xC5:

		if(NotEqual_ObjectObject(Inventory, none))
		{
			Inventory.Destroy();
			// [Loop Continue]
			goto J0xC5;
		}
	}
	SetActiveItem(none);
	DestroyEquipment();
	super.Destroyed();
	return;
}

simulated event PreBeginPlay()
{
	super.PreBeginPlay();
	KillerLocation.X = 0.0000000;
	KillerLocation.Y = 0.0000000;
	KillerLocation.Z = -10000.0000000;
	Instigator = self;
	DesiredRotation = Rotation;
	if(bDeleteMe)
	{
		return;
	}
	if(EqualEqual_FloatFloat(BaseEyeHeight, float(0)))
	{
		BaseEyeHeight = Multiply_FloatFloat(0.8000000, CollisionHeight);
	}
	EyeHeight = BaseEyeHeight;
	if(EqualEqual_StrStr(MenuName, ""))
	{
		MenuName = GetItemName(string(Class));
	}
	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)))
	{
		AddPawn();
	}
	InitSkeletalRegions();
	return;
}

function CharacterAICreated()
{
	return;
}

function MovementAICreated()
{
	return;
}

function WeaponAICreated()
{
	return;
}

// Export UPawn::execIsInRoom(FFrame&, void* const)
native function bool IsInRoom(name RoomName);

// Export UPawn::execGetRoomName(FFrame&, void* const)
native function name GetRoomName();

// Export UPawn::execGetPathfindingDistanceToActor(FFrame&, void* const)
native function float GetPathfindingDistanceToActor(Actor Destination, optional bool bAcceptNearbyPath);

// Export UPawn::execGetPathfindingDistanceToPoint(FFrame&, void* const)
native function float GetPathfindingDistanceToPoint(Vector Point, optional bool bAcceptNearbyPath);

simulated event bool IsStunned()
{
	return false;
	return;
}

event PostBeginPlay()
{
	super.PostBeginPlay();
	SplashTime = 0.0000000;
	SpawnTime = Level.TimeSeconds;
	EyeHeight = BaseEyeHeight;
	OldRotYaw = float(Rotation.Yaw);
	if(AndAnd_BoolBool(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)), Not_PreBool(Level.IsCOOPServer)))
	{
		return;
	}
	if(AndAnd_BoolBool(Not_PreBool(IsHumanControlled()), NotEqual_IntInt(int(Level.NetMode), int(NM_Client))))
	{
		CharacterAI = Class<Tyrion_ResourceBase>(static.DynamicLoadObject("SwatAICommon.SwatCharacterResource", Class'Core.Class')).Allocate(self).;
		Construct_Void();
		assert(NotEqual_ObjectObject(CharacterAI, none));
		CharacterAI.setResourceOwner(self);
		CharacterAICreated();
		MovementAI = Class<Tyrion_ResourceBase>(static.DynamicLoadObject("SwatAICommon.SwatMovementResource", Class'Core.Class')).Allocate(self).;
		Construct_Void();
		assert(NotEqual_ObjectObject(MovementAI, none));
		MovementAI.setResourceOwner(self);
		MovementAICreated();
		WeaponAI = Class<Tyrion_ResourceBase>(static.DynamicLoadObject("Tyrion.AI_WeaponResource", Class'Core.Class')).Allocate(self).;
		Construct_Void();
		assert(NotEqual_ObjectObject(WeaponAI, none));
		WeaponAI.setResourceOwner(self);
		WeaponAICreated();
		CreateCollisionAvoidanceNotifier();
	}
	if(AndAnd_BoolBool(Greater_IntInt(Health, 0), Not_PreBool(bDontPossess)))
	{
		if(AndAnd_BoolBool(EqualEqual_ObjectObject(Controller, none), NotEqual_StrStr(ControllerClassName, "")))
		{
			Controller = Spawn(Class<Controller>(DynamicLoadObject(ControllerClassName, Class'Core.Class')));
			AssertWithDescription(NotEqual_ObjectObject(Controller, none), Concat_StrStr(Concat_StrStr(Concat_StrStr("Couldn't spawn controller of class ", ControllerClassName), " for "), string(self)));
		}
		if(NotEqual_ObjectObject(Controller, none))
		{
			Controller.Possess(self);
		}
	}
	return;
}

function CreateCollisionAvoidanceNotifier()
{
	CollisionAvoidanceNotifier = Class'Engine.CollisionAvoidanceNotifier'.static.Allocate(self).;
	construct_Pawn(self);
	assert(NotEqual_ObjectObject(CollisionAvoidanceNotifier, none));
	return;
}

function bool IsAvoidingCollision()
{
	return bAvoidingCollision;
	return;
}

function RegisterCollisionAvoidanceNotification(ICollisionAvoidanceNotification Registrant)
{
	CollisionAvoidanceNotifier.RegisterCollisionAvoidanceNotification(Registrant);
	return;
}

function UnregisterCollisionAvoidanceNotification(ICollisionAvoidanceNotification Registrant)
{
	CollisionAvoidanceNotifier.UnregisterCollisionAvoidanceNotification(Registrant);
	return;
}

event NotifyBeganCollisionAvoidance()
{
	CollisionAvoidanceNotifier.NotifyBeganCollisionAvoidance();
	return;
}

event NotifyEndedCollisionAvoidance()
{
	CollisionAvoidanceNotifier.NotifyEndedCollisionAvoidance();
	return;
}

function float GetCollisionSoftRadius()
{
	return Add_FloatFloat(CollisionRadius, CollisionSoftRadiusOffset);
	return;
}

simulated function InitSkeletalRegions()
{
	local int ct;

	ct = 0;
	J0x07:

	if(Less_IntInt(ct, int(7)))
	{
		SkeletalRegionInformation[ct] = Class'Engine.SkeletalRegionInformation'.static.Allocate(self, none, Concat_StrStr(string(GetEnum(Enum'Engine.Actor.ESkeletalRegion', ct)), "Info"), 0).;
		Construct_Void();
		AddAdd_Int(ct);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

final simulated function SwitchToMesh(Mesh NewMesh)
{
	LinkMesh(NewMesh);
	OnMeshChanged();
	return;
}

simulated function OnMeshChanged()
{
	return;
}

simulated function SetProtection(Actor.ESkeletalRegion Region, ProtectiveEquipment Protection)
{
	SkeletalRegionProtection[int(Region)] = Protection;
	return;
}

simulated function bool HasProtection(name ProtectionClass)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, SkeletalRegionProtection.Length))
	{
		if(AndAnd_BoolBool(NotEqual_ObjectObject(SkeletalRegionProtection[i], none), SkeletalRegionProtection[i].IsA(ProtectionClass)))
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

simulated function SkeletalRegionInformation GetSkeletalRegionInformation(Actor.ESkeletalRegion Region)
{
	return SkeletalRegionInformation[int(Region)];
	return;
}

simulated function ProtectiveEquipment GetSkeletalRegionProtection(Actor.ESkeletalRegion Region)
{
	if(Greater_IntInt(SkeletalRegionProtection.Length, int(Region)))
	{
		return SkeletalRegionProtection[int(Region)];
	}
	else
	{
		return none;
	}
	return;
}

simulated function OnSkeletalRegionHit(Actor.ESkeletalRegion RegionHit, Vector HitLocation, Vector HitNormal, int Damage, Class<DamageType> DamageType, Actor Instigator)
{
	return;
}

function InitializeHands()
{
	return;
}

final simulated function Hands GetHands()
{
	return Hands;
	return;
}

final simulated function SetHands(Hands inHands)
{
	Hands = inHands;
	return;
}

simulated event PostNetBeginPlay()
{
	if(OrOr_BoolBool(Level.bDropDetail, EqualEqual_IntInt(int(Level.DetailMode), int(0))))
	{
		MaxLights = byte(Min(4, int(MaxLights)));
	}
	if(EqualEqual_IntInt(int(Role), int(ROLE_Authority)))
	{
		return;
	}
	if(NotEqual_ObjectObject(Controller, none))
	{
		Controller.Pawn = self;
		if(AndAnd_BoolBool(NotEqual_ObjectObject(PlayerController(Controller), none), EqualEqual_ObjectObject(PlayerController(Controller).ViewTarget, Controller)))
		{
			PlayerController(Controller).SetViewTarget(self);
		}
	}
	if(EqualEqual_IntInt(int(Role), int(ROLE_AutonomousProxy)))
	{
		bUpdateEyeheight = true;
	}
	if(AndAnd_BoolBool(NotEqual_ObjectObject(PlayerReplicationInfo, none), EqualEqual_ObjectObject(PlayerReplicationInfo.Owner, none)))
	{
		PlayerReplicationInfo.SetOwner(Controller);
	}
	PlayWaiting();
	return;
}

event PostLoadGame()
{
	bInitializeAnimation = false;
	PlayWaiting();
	return;
}

simulated function SetMesh()
{
	if(NotEqual_ObjectObject(Mesh, none))
	{
		return;
	}
	LinkMesh(default.Mesh);
	return;
}

function Gasp()
{
	return;
}

function SetMovementPhysics()
{
	return;
}

// Export UPawn::execGetAdditionalBaseAimError(FFrame&, void* const)
native event float GetAdditionalBaseAimError();

function float GetInjuredAimErrorPenalty()
{
	return 0.0000000;
	return;
}

function PostTakeDamage(int Damage, Pawn InstigatedBy, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType)
{
	local int actualDamage;
	local bool bAlreadyDead;
	local Controller Killer;

	if(EqualEqual_ObjectObject(DamageType, none))
	{
		if(NotEqual_ObjectObject(InstigatedBy, none))
		{
			Log(Concat_StrStr("WARNING: No damagetype for damage by ", string(InstigatedBy)));
		}
		DamageType = Class'Engine.DamageType';
	}
	if(Less_IntInt(int(Role), int(ROLE_Authority)))
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self), " took client damage of type "), string(DamageType)), " by "), string(InstigatedBy)));
		return;
	}
	bAlreadyDead = LessEqual_IntInt(Health, 0);
	if(EqualEqual_IntInt(int(Physics), int(0)))
	{
		SetMovementPhysics();
	}
	actualDamage = Level.Game.ReduceDamage(Damage, self, InstigatedBy, HitLocation, Momentum, DamageType);
	SubtractEqual_IntInt(Health, actualDamage);
	if(EqualEqual_VectorVector(HitLocation, vect(0.0000000, 0.0000000, 0.0000000)))
	{
		HitLocation = Location;
	}
	if(bAlreadyDead)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("WARNING: ", string(self)), " took regular damage "), string(DamageType)), " from "), string(InstigatedBy)), " while already dead at "), string(Level.TimeSeconds)));
		ChunkUp(Rotation, DamageType);
		return;
	}
	PlayHit(float(actualDamage), InstigatedBy, HitLocation, DamageType, Momentum);
	if(LessEqual_IntInt(Health, 0))
	{
		if(NotEqual_ObjectObject(InstigatedBy, none))
		{
			Killer = InstigatedBy.GetKillerController();
			if(EqualEqual_ObjectObject(Killer, none))
			{
				Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("WARNING: could not determine killer of ", string(self)), " (instigatedBy=='"), string(InstigatedBy)), "')"));
				MPLog("---------Using the cached playerpawn");
				Killer = InstigatedBy.LastUnPossessedController;
			}
		}
		Died(Killer, DamageType, HitLocation, Momentum);
	}
	else
	{
		if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(InstigatedBy, none), NotEqual_ObjectObject(InstigatedBy, self)), NotEqual_ObjectObject(Controller, none)), NotEqual_ObjectObject(InstigatedBy.Controller, none)), InstigatedBy.Controller.SameTeamAs(Controller)))
		{
			MultiplyEqual_VectorFloat(Momentum, 0.5000000);
		}
		if(NotEqual_ObjectObject(Controller, none))
		{
			Controller.NotifyTakeHit(InstigatedBy, HitLocation, actualDamage, DamageType, Momentum);
		}
	}
	MakeNoise(1.0000000);
	return;
}

function TeamInfo GetTeam()
{
	if(NotEqual_ObjectObject(PlayerReplicationInfo, none))
	{
		return PlayerReplicationInfo.Team;
	}
	return none;
	return;
}

function Controller GetKillerController()
{
	return Controller;
	return;
}

// Export UPawn::execNotifyPawnDeathListeners(FFrame&, void* const)
native function NotifyPawnDeathListeners();

function Died(Controller Killer, Class<DamageType> DamageType, Vector HitLocation, Vector HitMomentum)
{
	local Vector LocalKillerLocation;

	if(OrOr_BoolBool(bDeleteMe, Level.bLevelChange))
	{
		return;
	}
	if(Level.Game.PreventDeath(self, Killer, DamageType, HitLocation))
	{
		Health = Max(Health, 1);
		return;
	}
	Health = Min(0, Health);
	NotifyPawnDeathListeners();
	if(NotEqual_ObjectObject(Controller, none))
	{
		Level.Game.Killed(Killer, Controller, self, DamageType);
		Controller.WasKilledBy(Killer);
	}
	else
	{
		Level.Game.Killed(Killer, Controller(Owner), self, DamageType);
	}
	if(NotEqual_ObjectObject(Killer, none))
	{
		TriggerEvent(Event, self, Killer.Pawn);
	}
	else
	{
		TriggerEvent(Event, self, none);
	}
	MultiplyEqual_FloatFloat(Velocity.Z, 1.3000000);
	if(IsHumanControlled())
	{
		PlayerController(Controller).ForceDeathUpdate();
	}
	if(false)
	{
	}
	else
	{
		if(NotEqual_ObjectObject(Killer, none))
		{
			if(NotEqual_ObjectObject(Killer.Pawn, none))
			{
				LocalKillerLocation = Killer.Pawn.Location;
			}
			else
			{
				LocalKillerLocation = Killer.Location;
			}
		}
		else
		{
			LocalKillerLocation = KillerLocation;
		}
		PlayDying(DamageType, HitLocation, HitMomentum, LocalKillerLocation);
		if(Level.Game.bGameEnded)
		{
			return;
		}
		if(AndAnd_BoolBool(Not_PreBool(bPhysicsAnimUpdate), Not_PreBool(IsLocallyControlled())))
		{
			ClientDying(DamageType, HitLocation, HitMomentum, LocalKillerLocation);
		}
	}
	return;
}

static final function bool checkAlive(Pawn Pawn)
{
	return AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(Pawn, none), Not_PreBool(Pawn.bDeleteMe)), Greater_IntInt(Pawn.Health, 0));
	return;
}

static final function bool checkDead(Pawn Pawn)
{
	return OrOr_BoolBool(OrOr_BoolBool(EqualEqual_ObjectObject(Pawn, none), Pawn.bDeleteMe), LessEqual_IntInt(Pawn.Health, 0));
	return;
}

static final function bool checkIsAThreat(Pawn Pawn)
{
	return AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(Pawn, none), Not_PreBool(Pawn.bDeleteMe)), Pawn.IsAThreat());
	return;
}

static final function bool checkConscious(Pawn Pawn)
{
	return AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(Pawn, none), Not_PreBool(Pawn.IsDead())), Not_PreBool(Pawn.IsIncapacitated()));
	return;
}

// Export UPawn::execIsDead(FFrame&, void* const)
native simulated function bool IsDead();

// Export UPawn::execIsConscious(FFrame&, void* const)
native simulated function bool IsConscious();

// Export UPawn::execIsIncapacitated(FFrame&, void* const)
native simulated function bool IsIncapacitated();

function float GetIncapacitatedDamageAmount()
{
	return 0.0000000;
	return;
}

function bool ShouldBecomeIncapacitated()
{
	return AndAnd_BoolBool(GreaterEqual_IntInt(Health, 0), Less_FloatFloat(float(Health), GetIncapacitatedDamageAmount()));
	return;
}

simulated event bool IsArrested()
{
	assert(false);
	return false;
	return;
}

event Pawn GetCurrentAssignment()
{
	assert(false);
	return none;
	return;
}

simulated event bool isAlive()
{
	return AndAnd_BoolBool(Not_PreBool(bDeleteMe), Greater_IntInt(Health, 0));
	return;
}

// Export UPawn::execIsInjured(FFrame&, void* const)
native simulated event bool IsInjured();

static final function bool checkIsInjured(Pawn Pawn)
{
	return AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(Pawn, none), Not_PreBool(Pawn.bDeleteMe)), Pawn.IsInjured());
	return;
}

// Export UPawn::execIsLowerBodyInjured(FFrame&, void* const)
native simulated event bool IsLowerBodyInjured();

event bool CanMoveFreely()
{
	return true;
	return;
}

// Export UPawn::execIsAThreat(FFrame&, void* const)
native simulated function bool IsAThreat();

// Export UPawn::execIsCompliant(FFrame&, void* const)
native simulated function bool IsCompliant();

function bool IsAttackingPlayer()
{
	return false;
	return;
}

function rematchGoals()
{
	return;
}

event Falling()
{
	if(NotEqual_ObjectObject(Controller, none))
	{
		Controller.SetFall();
	}
	return;
}

event HitWall(Vector HitNormal, Actor Wall)
{
	return;
}

event Landed(Vector HitNormal)
{
	LandBob = FMin(50.0000000, Multiply_FloatFloat(0.0550000, Velocity.Z));
	TakeFallingDamage();
	if(Greater_IntInt(Health, 0))
	{
		PlayLanded(Velocity.Z);
	}
	bJustLanded = true;
	TriggerEffectEvent('Landed');
	return;
}

event HeadVolumeChange(PhysicsVolume newHeadVolume)
{
	return;
}

function bool TouchingWaterVolume()
{
	local PhysicsVolume V;

	foreach TouchingActors(Class'Engine.PhysicsVolume', V)
	{
		if(V.bWaterVolume)
		{
			return true;
		}
	}
	return false;
	return;
}

function EnteredZone(ZoneInfo Zone)
{
	SLog(Concat_StrStr(Concat_StrStr(string(self), " entered zone "), string(Zone)));
	dispatchMessage(Class'Engine.MessageZoneEntered'.static.Allocate(self)., construct_NameName(Zone.Label, Label));
	TriggerEffectEvent('InZone');
	return;
}

function LeftZone(ZoneInfo Zone)
{
	SLog(Concat_StrStr(Concat_StrStr(string(self), " leaving zone "), string(Zone)));
	dispatchMessage(Class'Engine.MessageZoneExited'.static.Allocate(self)., construct_NameName(Zone.Label, Label));
	UnTriggerEffectEvent('InZone');
	return;
}

function bool IsInPain()
{
	return false;
	return;
}

function TakeDrowningDamage()
{
	return;
}

function bool CheckWaterJump(out Vector WallNormal)
{
	return false;
	return;
}

function DoDoubleJump(bool bUpdating)
{
	return;
}

function bool CanDoubleJump()
{
	return;
}

function bool Dodge(Actor.EDoubleClickDir DoubleClickMove)
{
	return false;
	return;
}

function bool DoJump(bool bUpdating)
{
	return false;
	return;
}

function PlayMoverHitSound()
{
	return;
}

simulated function bool CanBeAffectedByHurtRadius()
{
	return EqualEqual_IntInt(int(Role), int(ROLE_Authority));
	return;
}

function PlayHit(float Damage, Pawn InstigatedBy, Vector HitLocation, Class<DamageType> DamageType, Vector Momentum)
{
	local PlayerController PC;

	if(AndAnd_BoolBool(LessEqual_FloatFloat(Damage, float(0)), OrOr_BoolBool(EqualEqual_ObjectObject(Controller, none), Not_PreBool(Controller.bGodMode))))
	{
		return;
	}
	if(AndAnd_BoolBool(NotEqual_IntInt(int(Level.NetMode), int(NM_DedicatedServer)), NotEqual_IntInt(int(Level.NetMode), int(NM_ListenServer))))
	{
		PC = PlayerController(Controller);
		if(AndAnd_BoolBool(NotEqual_ObjectObject(PC, none), PC.bEnableDamageForceFeedback))
		{
			PC.ClientPlayForceFeedback("Damage");
		}
	}
	return;
}

simulated function ChunkUp(Rotator HitRotation, Class<DamageType> D)
{
	if(AndAnd_BoolBool(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)), NotEqual_ObjectObject(Controller, none)))
	{
		if(Controller.bIsPlayer)
		{
			Controller.PawnDied(self);
		}
		else
		{
			Controller.Destroy();
		}
	}
	Destroy();
	return;
}

simulated event SetAnimAction(name NewAction)
{
	return;
}

simulated function PlayRagdoll(Class<DamageType> DamageType, Vector HitLoc)
{
	return;
}

simulated event PlayDying(Class<DamageType> DamageType, Vector HitLoc, Vector HitMomentum, Vector inKillerLocation)
{
	MPLog(Concat_StrStr(string(self), "---Pawn::PlayDying()."));
	MPLog("...calling InterruptState().");
	InterruptState('Dying');
	Controller.InterruptState('Dying');
	GotoState('Dying');
	if(bPhysicsAnimUpdate)
	{
		bReplicateMovement = false;
		bTearOff = true;
		AddEqual_VectorVector(Velocity, DeathHitMomentum);
		SetPhysics(2);
	}
	bPlayedDeath = true;
	return;
}

simulated event ChangeAnimation()
{
	if(AndAnd_BoolBool(NotEqual_ObjectObject(Controller, none), Controller.bControlAnimations))
	{
		return;
	}
	PlayWaiting();
	PlayMoving();
	return;
}

simulated event AnimEnd(int Channel)
{
	if(EqualEqual_IntInt(Channel, 0))
	{
		PlayWaiting();
	}
	return;
}

function bool CannotJumpNow()
{
	return false;
	return;
}

simulated event PlayJump()
{
	return;
}

simulated event PlayFalling()
{
	return;
}

simulated function PlayMoving()
{
	return;
}

simulated function PlayWaiting()
{
	return;
}

function PlayLanded(float impactVel)
{
	if(Not_PreBool(bPhysicsAnimUpdate))
	{
		PlayLandingAnimation(impactVel);
	}
	return;
}

simulated event PlayLandingAnimation(float impactVel)
{
	return;
}

simulated function HandheldEquipment.Pocket GetDesiredItemPocket()
{
	return DesiredItemPocket;
	return;
}

function SetDesiredItemPocket(HandheldEquipment.Pocket NewPocket)
{
	assert(EqualEqual_IntInt(int(Role), int(ROLE_Authority)));
	DesiredItemPocket = NewPocket;
	return;
}

simulated event DesiredItemPocketChanged()
{
	return;
}

protected final simulated function SetActiveItem(HandheldEquipment inActiveItem)
{
	ActiveItem = inActiveItem;
	return;
}

final simulated function SetPendingItem(HandheldEquipment inPendingItem)
{
	PendingItem = inPendingItem;
	return;
}

// Export UPawn::execGetActiveItem(FFrame&, void* const)
native simulated function HandheldEquipment GetActiveItem();

simulated function HandheldEquipment GetPendingItem()
{
	return PendingItem;
	return;
}

final simulated function OnEquipKeyFrame()
{
	if(OrOr_BoolBool(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)), NotEqual_ObjectObject(GetPendingItem(), none)))
	{
		SetActiveItem(GetPendingItem());
		GetActiveItem().super(Pawn).OnEquipKeyFrame();
		OnActiveItemEquipped();
	}
	return;
}

simulated function OnActiveItemEquipped()
{
	return;
}

simulated function OnEquippingFinished()
{
	return;
}

simulated function OnUnequipKeyFrame()
{
	local HandheldEquipment theActiveItem;

	theActiveItem = GetActiveItem();
	if(NotEqual_ObjectObject(theActiveItem, none))
	{
		theActiveItem.super(Pawn).OnUnequipKeyFrame();
		OnActiveItemUnEquipped();
		SetActiveItem(none);
	}
	return;
}

simulated function OnActiveItemUnEquipped()
{
	return;
}

simulated function OnUseKeyFrame()
{
	local HandheldEquipment LocalActiveItem;

	LocalActiveItem = GetActiveItem();
	if(NotEqual_ObjectObject(LocalActiveItem, none))
	{
		LocalActiveItem.super(Pawn).OnUseKeyFrame();
	}
	if(AndAnd_BoolBool(NotEqual_ObjectObject(LocalActiveItem, none), LocalActiveItem.UnavailableAfterUsed))
	{
		if(Not_PreBool(Level.IsTraining))
		{
			LocalActiveItem.SetAvailable(false);
			SetActiveItem(none);
		}
	}
	return;
}

simulated function OnUsingBegan()
{
	return;
}

simulated function OnUsingFinished()
{
	return;
}

simulated function IWasNonlethaledAndFinishedSoDoAnEquipIfINeedToDoOne()
{
	return;
}

simulated function OnReloadKeyFrame()
{
	FiredWeapon(GetActiveItem()).super(Pawn).OnReloadKeyFrame();
	return;
}

simulated function OnReloadingFinished()
{
	return;
}

simulated function IdleHoldingEquipment()
{
	return;
}

simulated function DestroyEquipment()
{
	return;
}

final simulated function AIInterruptEquipment()
{
	local HandheldEquipment ActiveItem, PendingItem;

	ActiveItem = GetActiveItem();
	PendingItem = GetPendingItem();
	if(AndAnd_BoolBool(NotEqual_ObjectObject(ActiveItem, none), Not_PreBool(ActiveItem.IsIdle())))
	{
		ActiveItem.AIInterrupt();
	}
	if(AndAnd_BoolBool(NotEqual_ObjectObject(PendingItem, none), Not_PreBool(PendingItem.IsIdle())))
	{
		PendingItem.AIInterrupt();
	}
	return;
}

// Export UPawn::execFindAnchor(FFrame&, void* const)
native final function FindAnchor(bool bMustFindAnchor);

function ServerBeginFiringWeapon(HandheldEquipment.EquipmentSlot ItemSlot)
{
	return;
}

function ServerEndFiringWeapon()
{
	return;
}

function BroadcastEmptyFiredToClients()
{
	return;
}

function ServerSetCurrentFireMode(HandheldEquipment.EquipmentSlot ItemSlot, FiredWeapon.FireMode NewFireMode)
{
	local FiredWeapon theActiveItem;

	MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self), "---Pawn::ServerSetCurrentFireMode(). ItemSlot="), string(ItemSlot)), ", NewFireMode="), string(NewFireMode)));
	theActiveItem = FiredWeapon(GetActiveItem());
	if(AndAnd_BoolBool(NotEqual_ObjectObject(theActiveItem, none), EqualEqual_IntInt(int(theActiveItem.GetSlot()), int(ItemSlot))))
	{
		theActiveItem.SetCurrentFireMode(NewFireMode);
	}
	else
	{
		MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr("...SetCurrentFireMode() not possible. ItemSlot=", string(ItemSlot)), ", ActiveItem="), string(GetActiveItem())));
	}
	return;
}

simulated function OnFireModeChanged()
{
	return;
}

function ServerRequestReload(HandheldEquipment.EquipmentSlot ItemSlot)
{
	return;
}

simulated function int AnimGetSpecialChannel()
{
	return;
}

simulated function int AnimGetEquipmentChannel()
{
	return;
}

simulated function int AnimPlaySpecial(name AnimName, optional float TweenTime, optional name Bone, optional float Rate)
{
	return;
}

simulated function int AnimPlayEquipment(Pawn.EAnimPlayType AnimPlayType, name AnimName, optional float TweenTime, optional name Bone, optional float Rate)
{
	return;
}

simulated function int AnimLoopSpecial(name AnimName, optional float TweenTime, optional name Bone, optional float Rate)
{
	return;
}

simulated function int AnimLoopEquipment(Pawn.EAnimPlayType AnimPlayType, name AnimName, optional float TweenTime, optional name Bone, optional float Rate)
{
	return;
}

simulated function EnableAnimSpecialAlphaOverride(float Alpha)
{
	return;
}

simulated function DisableAnimSpecialAlphaOverride()
{
	return;
}

simulated function EnableAnimEquipmentAlphaOverride(float Alpha)
{
	return;
}

simulated function DisableAnimEquipmentAlphaOverride()
{
	return;
}

simulated function AnimStopSpecial()
{
	return;
}

simulated function AnimStopEquipment()
{
	return;
}

latent simulated function AnimFinishSpecial()
{
	return;
}

latent simulated function AnimFinishEquipment()
{
	return;
}

event OnCollisionAvoidanceMoveTo(Vector MoveToLocation)
{
	return;
}

simulated event Rotator ViewRotationOffset()
{
	assert(false);
	return rot(0, 0, 0);
	return;
}

simulated function Vector ViewLocationOffset(Rotator CameraRotation)
{
	assert(false);
	return vect(0.0000000, 0.0000000, 0.0000000);
	return;
}

simulated function bool WantsToContinueAutoFiring()
{
	assert(false);
	return false;
	return;
}

simulated function OnAutoFireStarted()
{
	return;
}

function HandheldEquipment FindItemForPickupToReplace(HandheldEquipment PickedUp)
{
	return;
}

function OnPickedUp(HandheldEquipment PickedUp)
{
	return;
}

simulated event BecomeRagdoll()
{
	return;
}

simulated event ApplyRotationOffset(out Vector Acceleration)
{
	return;
}

function OnEvidenceSecured(IEvidence Evidence)
{
	return;
}

simulated function InterruptState(name Reason)
{
	return;
}

state Dying
{
	event ChangeAnimation()
	{
		return;
	}

	event StopPlayFiring()
	{
		return;
	}

	function PlayFiring(float Rate, name FiringMode)
	{
		return;
	}

	function PlayWeaponSwitch(Weapon NewWeapon)
	{
		return;
	}

	simulated function PlayNextAnimation()
	{
		return;
	}

	function Died(Controller Killer, Class<DamageType> DamageType, Vector HitLocation, Vector HitMomentum)
	{
		return;
	}

	event FellOutOfWorld(Actor.eKillZType KillType)
	{
		if(EqualEqual_IntInt(int(KillType), int(1)))
		{
			return;
		}
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[ckline]: !!!! WARNING !!!!! Pawn ", string(self)), " in state Pawn.Dying and Physics="), string(GetEnum(Enum'Engine.Actor.EPhysics', int(Physics)))), " fell out of the world and was Destroy()ed! Pawn's location = "), string(Location)), ", look around this area in the editor for gaps in bsp."));
		Destroy();
		return;
	}

	function Timer()
	{
		if(Not_PreBool(PlayerCanSeeMe()))
		{
			Destroy();
		}
		else
		{
			SetTimer(2.0000000, false);
		}
		return;
	}

	function Landed(Vector HitNormal)
	{
		local Rotator finalRot;

		LandBob = FMin(50.0000000, Multiply_FloatFloat(0.0550000, Velocity.Z));
		if(Less_FloatFloat(Velocity.Z, float(-500)))
		{
			TakeDamage(int(Subtract_FloatFloat(float(1), Divide_FloatFloat(Velocity.Z, float(30)))), Instigator, Location, vect(0.0000000, 0.0000000, 0.0000000), Class'Engine.Crushed');
		}
		finalRot = Rotation;
		finalRot.Roll = 0;
		finalRot.Pitch = 0;
		SetRotation(finalRot);
		SetPhysics(0);
		SetCollision(true, false, false);
		if(Not_PreBool(IsAnimating(0)))
		{
			LieStill();
		}
		return;
	}

	function ReduceCylinder()
	{
		SetCollision(false, false, false);
		return;
	}

	function LandThump()
	{
		if(EqualEqual_IntInt(int(Physics), int(0)))
		{
			bThumped = true;
		}
		return;
	}

	event AnimEnd(int Channel)
	{
		return;
	}

	function LieStill()
	{
		if(Not_PreBool(bThumped))
		{
			LandThump();
		}
		SetCollision(false, false, false);
		return;
	}

	singular function BaseChange()
	{
		if(AndAnd_BoolBool(EqualEqual_ObjectObject(Base, none), EqualEqual_IntInt(int(Physics), int(0))))
		{
			SetPhysics(2);
		}
		else
		{
			if(NotEqual_ObjectObject(Pawn(Base), none))
			{
				ChunkUp(Rotation, Class'Engine.fell');
			}
		}
		return;
	}

	function PostTakeDamage(int Damage, Pawn InstigatedBy, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType)
	{
		SetPhysics(2);
		if(AndAnd_BoolBool(EqualEqual_IntInt(int(Physics), int(0)), Less_FloatFloat(Momentum.Z, float(0))))
		{
			MultiplyEqual_FloatFloat(Momentum.Z, float(-1));
		}
		AddEqual_VectorVector(Velocity, Divide_VectorFloat(Multiply_FloatVector(float(3), Momentum), Add_FloatFloat(Mass, float(200))));
		if(bInvulnerableBody)
		{
			return;
		}
		SubtractEqual_IntInt(Health, Damage);
		if(AndAnd_BoolBool(OrOr_BoolBool(Greater_IntInt(Damage, 30), Not_PreBool(IsAnimating())), Less_IntInt(Health, -80)))
		{
			ChunkUp(Rotation, DamageType);
		}
		return;
	}

	function BeginState()
	{
		if(AndAnd_BoolBool(NotEqual_ObjectObject(LastStartSpot, none), Less_FloatFloat(Subtract_FloatFloat(LastStartTime, Level.TimeSeconds), float(6))))
		{
			LastStartSpot.LastSpawnCampTime = Level.TimeSeconds;
		}
		if(AndAnd_BoolBool(bTearOff, EqualEqual_IntInt(int(Level.NetMode), int(NM_DedicatedServer))))
		{
			LifeSpan = 1.0000000;
		}
		else
		{
			SetTimer(12.0000000, false);
		}
		bInvulnerableBody = true;
		if(NotEqual_ObjectObject(Controller, none))
		{
			if(Controller.bIsPlayer)
			{
				Controller.PawnDied(self);
			}
			else
			{
				Controller.Destroy();
			}
		}
		return;
	}
Begin:

	Sleep(0.1500000);
	bInvulnerableBody = false;
	stop;
}

defaultproperties
{
	LeanTransitionDuration=0.3000000
	LeanHorizontalDistance=44.0000000
	bJumpCapable=true
	bCanJump=true
	bCanWalk=true
	bHavokCharacterCollisionExtraRadius=1.0000000
	bLOSHearing=true
	bUseCompressedPosition=true
	bWeaponBob=true
	Visibility=128
	DesiredSpeed=1.0000000
	MaxDesiredSpeed=1.0000000
	HearingThreshold=2800.0000000
	SightRadius=5000.0000000
	AvgPhysicsTime=0.1000000
	LastValidAnchorTime=-1.0000000
	VisionUpdateRange=(Min=0.1000000,Max=0.3000000)
	GroundSpeed=600.0000000
	WaterSpeed=300.0000000
	AirSpeed=600.0000000
	LadderSpeed=200.0000000
	AccelRate=2048.0000000
	JumpZ=420.0000000
	AirControl=0.0500000
	MaxFallSpeed=1200.0000000
	ReachedDestinationThreshold=8.0000000
	BaseEyeHeight=64.0000000
	CrouchEyeHeight=32.0000000
	EyeHeight=54.0000000
	CrouchHeight=40.0000000
	CrouchRadius=34.0000000
	Health=100
	HeadScale=1.0000000
	noise1time=-10.0000000
	noise2time=-10.0000000
	Bob=0.0080000
	SoundDampening=1.0000000
	DamageScaling=1.0000000
	ControllerClassName="Tyrion.AI_Controller"
	LandMovementState="PlayerWalking"
	WaterMovementState="PlayerSwimming"
	BaseMovementRate=525.0000000
	BlendChangeTime=0.2500000
	FirstPersonFOV=85.0000000
	bRenderHands=true
	DesiredItemPocket=24
	bCollisionAvoidanceEnabled=true
	DrawType=2
	bStasis=true
	bUpdateSimulatedPosition=true
	RemoteRole=2
	NetPriority=2.0000000
	Texture=Texture'Engine_res.S_Pawn'
	MaxLights=4
	bTravel=true
	bCanBeDamaged=true
	bShouldBaseAtStartup=true
	bOwnerNoSee=true
	bCanTeleport=true
	bDisturbFluidSurface=true
	CollisionRadius=34.0000000
	CollisionHeight=78.0000000
	bCollideActors=true
	bCollideWorld=true
	bBlockActors=true
	bBlockPlayers=true
	bProjTarget=true
	bRotateToDesired=true
	RotationRate=(Pitch=4096,Yaw=20000,Roll=3072)
	bNoRepMesh=true
	bDirectional=true
	bSendDestructionNotification=true
}