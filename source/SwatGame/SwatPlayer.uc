class SwatPlayer extends SwatRagdollPawn implements ICanThrowWeapons, IReactToFlashbangGrenade, IReactToCSGas, IReactToStingGrenade, IReactToC2Detonation, ICanUseC2Charge, ICanQualifyForUse, ICanBeTased, ICanBePepperSprayed, IEffectObserver, IInterested_GameEvent_ReportableReportedToTOC, IControllableThroughViewport, IAmReportableCharacter
	native
	config(SwatPawn)
	hidecategories(Karma);

const OneFrameNudgeDirectionStrength = 2.0;

enum ELastStingWeapon
{
	stingGrenade,                   // 0
	LessLethalShotgun               // 1
};

var private OfficerLoadOut LoadOut;
var config int ThrownProjectilePitch;
var config float MinimumLongThrowSpeed;
var config name PreThrowAnimation;
var config name ThrowShortAnimation;
var config name ThrowLongAnimation;
var config name ThrowAnimationRootBone;
var config float ThrowAnimationTweenTime;
var config float ThrowSpeedTimeFactor;
var config Range ThrowSpeedRange;
var private Material SuspectHandsMaterial;
var private Material VIPHandsMaterial;
var config bool bTestingCameraEffects;
var private Timer StungTimer;
var private Timer FlashbangedTimer;
var private Timer GassedTimer;
var private Timer PepperSprayedTimer;
var private Timer TasedTimer;
var SwatPlayer.ELastStingWeapon LastStingWeapon;
var float LastStungTime;
var float LastStungDuration;
var float LastFlashbangedTime;
var float LastGassedTime;
var float LastGassedDuration;
var float LastPepperedTime;
var float LastPepperedDuration;
var float LastTasedTime;
var float LastTasedDuration;
var private byte bIsTriggered_ReactedBang;
var private byte bIsTriggered_ReactedGas;
var private byte bIsTriggered_ReactedPepper;
var private byte bIsTriggered_ReactedSting;
var private byte bIsTriggered_ReactedTaser;
var private PerlinNoise PerlinNoiseAxisA;
var private PerlinNoise PerlinNoiseAxisB;
var config float StingEffectDropOffTimePercent;
var config float StingEffectFrequency;
var config Rotator StingViewEffectAmplitude;
var config float StingInputEffectMagnitude;
var config float TasedViewEffectAmplitude;
var config float TasedViewEffectFrequency;
var bool EquipOtherAfterUsed;
var HandheldEquipment.EquipmentSlot SlotForReequip;
var bool DoneThrowing;
var float ThrowHeldTime;
var private bool bForceCrouchWhileOptiwanding;
var private bool bIsUsingOptiwand;
var private DeployedC2ChargeBase DeployedC2Charge;
var config float LowReadyFireTweenTime;
var private IAmReportableCharacter CurrentReportableCharacter;
var private bool bNotifiedPlayerTheyAreVIP;
var SwatPlayer LastArrester;
var private Vector OneFrameNudgeDirection;
var private const config float LimpThreshold;
var private config float CurrentLimp;
var private config float StandardLimpPenalty;
var private config localized string YouString;
var private config float PawnModelApparentBaseEyeHeight;
var private config float PawnModelApparentCrouchEyeHeight;
var private bool bHasBeenReportedToTOC;
var private CommandArrow CommandArrow;
var EquipmentUsedOnOther CachedQualifyEquipment;
var Actor CachedQualifyTarget;

replication
{
	// Pos:0x000
	reliable if(Less_IntInt(int(Role), int(ROLE_Authority)))
		ServerRequestQualify, ServerRequestUse,
		ServerSetForceCrouchWhileOptiwanding, ServerSetIsUsingOptiwand;

	// Pos:0x00D
	reliable if(EqualEqual_IntInt(int(Role), int(ROLE_Authority)))
		ClientDoFlashbangReaction, ClientDoGassedReaction,
		ClientDoPepperSprayedReaction, ClientDoStungReaction,
		ClientDoTasedReaction, ClientFaceRotation,
		ClientFinishQualify, ClientOnFlashbangTimerExpired,
		ClientOnGassedTimerExpired, ClientOnPepperSprayedTimerExpired,
		ClientOnStungTimerExpired, ClientOnTasedTimerExpired,
		ClientPlayEmptyFired, ClientStartQualify,
		ClientUse, CurrentLimp,
		DeployedC2Charge, bHasBeenReportedToTOC,
		bIsUsingOptiwand;
}

simulated function Actor GetViewportOwner()
{
	return self;
	return;
}

simulated function AdjustMouseAcceleration(out Vector MouseAccel)
{
	return;
}

function OnMouseAccelerated(out Vector MouseAccel)
{
	return;
}

simulated function string GetViewportType()
{
	if(OrOr_BoolBool(checkDead(self), IsIncapacitated()))
	{
		return "DeadPlayer";
	}
	if(IsTheVIP())
	{
		return "VIP";
	}
	else
	{
		return string(Name);
	}
	return;
}

function OffsetViewportRotation(out Rotator ViewportRotation)
{
	return;
}

simulated function string GetViewportDescription()
{
	return "";
	return;
}

simulated function string GetViewportName()
{
	return GetHumanReadableName();
	return;
}

simulated function bool CanIssueCommands()
{
	return false;
	return;
}

simulated function Vector GetViewportLocation()
{
	return GetViewPoint();
	return;
}

simulated function Rotator GetViewportDirection()
{
	return GetViewRotation();
	return;
}

simulated function float GetViewportPitchClamp()
{
	return 0.0000000;
	return;
}

simulated function float GetViewportYawClamp()
{
	return 0.0000000;
	return;
}

simulated function SetRotationToViewport(Rotator inNewRotation)
{
	return;
}

simulated function bool ShouldDrawViewport()
{
	return AndAnd_BoolBool(Not_PreBool(checkDead(self)), Not_PreBool(IsIncapacitated()));
	return;
}

simulated function bool ShouldDrawReticle()
{
	return false;
	return;
}

simulated function Material GetViewportOverlay()
{
	return;
}

simulated function float GetFOV()
{
	return;
}

simulated function HandleFire()
{
	return;
}

simulated function HandleAltFire()
{
	return;
}

simulated function HandleReload()
{
	return;
}

simulated function Rotator GetOriginalDirection()
{
	return;
}

simulated function float GetViewportPitchSpeed()
{
	return;
}

simulated function float GetViewportYawSpeed()
{
	return;
}

simulated function OnBeginControlling()
{
	return;
}

simulated function OnEndControlling()
{
	return;
}

simulated event PreBeginPlay()
{
	super(Pawn).PreBeginPlay();
	Label = 'Player';
	StungTimer = Spawn(Class'Engine.Timer');
	FlashbangedTimer = Spawn(Class'Engine.Timer');
	GassedTimer = Spawn(Class'Engine.Timer');
	PepperSprayedTimer = Spawn(Class'Engine.Timer');
	TasedTimer = Spawn(Class'Engine.Timer');
	StungTimer.__TimerDelegate__Delegate = OnStungTimerExpired;
	FlashbangedTimer.__TimerDelegate__Delegate = OnFlashbangedTimerExpired;
	GassedTimer.__TimerDelegate__Delegate = OnGassedTimerExpired;
	PepperSprayedTimer.__TimerDelegate__Delegate = OnPepperSprayedTimerExpired;
	TasedTimer.__TimerDelegate__Delegate = OnTasedTimerExpired;
	return;
}

simulated event PostBeginPlay()
{
	super.PostBeginPlay();
	SetPhysics(2);
	PerlinNoiseAxisA = Class'Engine.PerlinNoise'.static.Allocate(self).;
	Construct_Void();
	PerlinNoiseAxisB = Class'Engine.PerlinNoise'.static.Allocate(self).;
	Construct_Void();
	if(OrOr_BoolBool(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)), Level.IsCOOPServer))
	{
		SwatGameInfo(Level.Game).GameEvents.ReportableReportedToTOC.Register(self);
	}
	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
	{
		CommandArrow = Spawn(Class'SwatGame.CommandArrow');
		CommandArrow.Hide();
	}
	return;
}

simulated event PostNetBeginPlay()
{
	super.PostNetBeginPlay();
	return;
}

simulated function InitializeHands()
{
	local Hands Hands;

	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---SwatPlayer::InitializeHands()."));
	}
	Hands = Spawn(Class'Engine.Hands', self);
	assert(NotEqual_ObjectObject(Hands, none));
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr("...Hands=", string(Hands)));
	}
	if(AndAnd_BoolBool(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)), Not_PreBool(Level.IsCOOPServer)))
	{
		if(NotEqual_ObjectObject(NetPlayerTeamB(self), none))
		{
			Hands.SetMaterialForHands(SuspectHandsMaterial);
		}
		else
		{
			if(IsTheVIP())
			{
				Hands.SetMaterialForHands(VIPHandsMaterial);
			}
		}
	}
	SetHands(Hands);
	return;
}

simulated function InitAnimationForCurrentMesh()
{
	super(SwatPawn).InitAnimationForCurrentMesh();
	AnimSetRotationUrgency(1);
	return;
}

simulated function FaceRotation(Rotator NewRotation)
{
	AnimSetAimRotation(NewRotation);
	super(Pawn).FaceRotation(NewRotation);
	return;
}

simulated function ClientFaceRotation(Rotator NewRotation)
{
	FaceRotation(NewRotation);
	return;
}

simulated function AnimationSetManager.EAnimationSet GetHandgunLowReadyAimPoseSet()
{
	if(EqualEqual_NameName(ReasonForLowReady, 'Obstruction'))
	{
		return 49;
	}
	else
	{
		return super(SwatPawn).GetHandgunLowReadyAimPoseSet();
	}
	return;
}

simulated function AnimationSetManager.EAnimationSet GetSubMachineGunLowReadyAimPoseSet()
{
	if(EqualEqual_NameName(ReasonForLowReady, 'Obstruction'))
	{
		return 54;
	}
	else
	{
		return super(SwatPawn).GetSubMachineGunLowReadyAimPoseSet();
	}
	return;
}

simulated function AnimationSetManager.EAnimationSet GetMachineGunLowReadyAimPoseSet()
{
	if(EqualEqual_NameName(ReasonForLowReady, 'Obstruction'))
	{
		return 59;
	}
	else
	{
		return super(SwatPawn).GetMachineGunLowReadyAimPoseSet();
	}
	return;
}

simulated function AnimationSetManager.EAnimationSet GetShotgunLowReadyAimPoseSet()
{
	if(EqualEqual_NameName(ReasonForLowReady, 'Obstruction'))
	{
		return 64;
	}
	else
	{
		return super(SwatPawn).GetShotgunLowReadyAimPoseSet();
	}
	return;
}

simulated function AnimationSetManager.EAnimationSet GetThrownWeaponLowReadyAimPoseSet()
{
	if(EqualEqual_NameName(ReasonForLowReady, 'Obstruction'))
	{
		return 69;
	}
	else
	{
		return super(SwatPawn).GetThrownWeaponLowReadyAimPoseSet();
	}
	return;
}

simulated function AnimationSetManager.EAnimationSet GetTacticalAidLowReadyAimPoseSet()
{
	if(EqualEqual_NameName(ReasonForLowReady, 'Obstruction'))
	{
		return 74;
	}
	else
	{
		return super(SwatPawn).GetTacticalAidLowReadyAimPoseSet();
	}
	return;
}

simulated function AnimationSetManager.EAnimationSet GetPepperSprayLowReadyAimPoseSet()
{
	if(EqualEqual_NameName(ReasonForLowReady, 'Obstruction'))
	{
		return 80;
	}
	else
	{
		return super(SwatPawn).GetPepperSprayLowReadyAimPoseSet();
	}
	return;
}

simulated function AnimationSetManager.EAnimationSet GetM4LowReadyAimPoseSet()
{
	if(EqualEqual_NameName(ReasonForLowReady, 'Obstruction'))
	{
		return 85;
	}
	else
	{
		return super(SwatPawn).GetM4LowReadyAimPoseSet();
	}
	return;
}

simulated function AnimationSetManager.EAnimationSet GetUMPLowReadyAimPoseSet()
{
	if(EqualEqual_NameName(ReasonForLowReady, 'Obstruction'))
	{
		return 90;
	}
	else
	{
		return super(SwatPawn).GetUMPLowReadyAimPoseSet();
	}
	return;
}

simulated function AnimationSetManager.EAnimationSet GetOptiwandLowReadyAimPoseSet()
{
	if(AndAnd_BoolBool(EqualEqual_NameName(ReasonForLowReady, 'Obstruction'), Not_PreBool(IsUsingOptiwand())))
	{
		return 95;
	}
	else
	{
		return super(SwatPawn).GetOptiwandLowReadyAimPoseSet();
	}
	return;
}

simulated function AnimationSetManager.EAnimationSet GetPaintballLowReadyAimPoseSet()
{
	if(EqualEqual_NameName(ReasonForLowReady, 'Obstruction'))
	{
		return 100;
	}
	else
	{
		return super(SwatPawn).GetPaintballLowReadyAimPoseSet();
	}
	return;
}

protected simulated function bool CanPawnUseLowReady()
{
	return true;
	return;
}

simulated function SetLowReady(bool bEnable, optional name Reason)
{
	if(EqualEqual_BoolBool(bEnable, IsLowReady()))
	{
		return;
	}
	super(SwatPawn).SetLowReady(bEnable, Reason);
	if(NotEqual_ObjectObject(GetHands(), none))
	{
		GetHands().SetLowReady(bEnable);
	}
	return;
}

simulated function OfficerLoadOut GetLoadOut()
{
	return LoadOut;
	return;
}

simulated function ReceiveLoadOut(OfficerLoadOut inLoadOut)
{
	AssertWithDescription(EqualEqual_ObjectObject(LoadOut, none), "[tcohen] Player received LoadOut more than once.");
	LoadOut = inLoadOut;
	SetPlayerSkins(inLoadOut);
	ChangeAnimation();
	DoDefaultEquip();
	return;
}

// Export USwatPlayer::execHasA(FFrame&, void* const)
native function bool HasA(name HandheldEquipmentName);

simulated function SetPlayerSkins(OfficerLoadOut inLoadOut)
{
	Skins[0] = inLoadOut.GetPantsMaterial();
	Skins[1] = inLoadOut.GetFaceMaterial();
	Skins[2] = inLoadOut.GetNameMaterial();
	Skins[3] = inLoadOut.GetVestMaterial();
	return;
}

simulated function DoDefaultEquip()
{
	local FiredWeapon PrimaryWeapon, BackupWeapon, WeaponToEquip;

	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---SwatPlayer::DoDefaultEquip()."));
	}
	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Client)))
	{
		return;
	}
	PrimaryWeapon = LoadOut.GetPrimaryWeapon();
	BackupWeapon = LoadOut.GetBackupWeapon();
	WeaponToEquip = PrimaryWeapon;
	if(OrOr_BoolBool(OrOr_BoolBool(Level.IsTraining, EqualEqual_ObjectObject(PrimaryWeapon, none)), AndAnd_BoolBool(PrimaryWeapon.Ammo.IsEmpty(), Not_PreBool(BackupWeapon.Ammo.IsEmpty()))))
	{
		WeaponToEquip = BackupWeapon;
	}
	AssertWithDescription(NotEqual_ObjectObject(WeaponToEquip, none), "[tcohen] SwatPlayer::DoDefaultEquip() The selected weapon evaluates to None.");
	AuthorizedEquipOnServer(WeaponToEquip.GetSlot());
	return;
}

simulated function bool ValidateEquipSlot(HandheldEquipment.EquipmentSlot Slot)
{
	local HandheldEquipment NewItem;

	NewItem = GetEquipmentAtSlot(Slot);
	if(EqualEqual_ObjectObject(NewItem, none))
	{
		return false;
	}
	return ValidateEquipPocket(NewItem.GetPocket());
	return;
}

simulated function bool ValidateEquipPocket(HandheldEquipment.Pocket ThePocket)
{
	local Actor PocketContents;
	local HandheldEquipment NewItem, PendingItem, ActiveItem;

	PocketContents = LoadOut.GetItemAtPocket(ThePocket);
	ActiveItem = GetActiveItem();
	PendingItem = GetPendingItem();
	if(EqualEqual_ObjectObject(PocketContents, none))
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog(Concat_StrStr(Concat_StrStr(string(self), "---SwatPlayer::ValidateEquipPocket(). Validate failed. Pocket="), string(ThePocket)));
			MPLog("......Validate failed because there was nothing in the specified pocket.");
			MPLog(Concat_StrStr("...PocketContents =", string(PocketContents)));
			MPLog(Concat_StrStr("...ActiveItem     =", string(ActiveItem)));
			MPLog(Concat_StrStr("...PendingItem    =", string(PendingItem)));
		}
		return false;
	}
	NewItem = HandheldEquipment(PocketContents);
	if(EqualEqual_ObjectObject(NewItem, none))
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog(Concat_StrStr(Concat_StrStr(string(self), "---SwatPlayer::ValidateEquipPocket(). Validate failed. Pocket="), string(ThePocket)));
			MPLog("......Validate failed because the thing in the specified pocket was not handheld equipment.");
			MPLog(Concat_StrStr("...PocketContents =", string(PocketContents)));
			MPLog(Concat_StrStr("...NewItem        =", string(NewItem)));
			MPLog(Concat_StrStr("...ActiveItem     =", string(ActiveItem)));
			MPLog(Concat_StrStr("...PendingItem    =", string(PendingItem)));
		}
		return false;
	}
	if(EqualEqual_ObjectObject(NewItem, ActiveItem))
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog(Concat_StrStr(Concat_StrStr(string(self), "---SwatPlayer::ValidateEquipPocket(). Validate failed. Pocket="), string(ThePocket)));
			MPLog("......Validate failed because requested item is the same as the active item.");
			MPLog(Concat_StrStr("...PocketContents =", string(PocketContents)));
			MPLog(Concat_StrStr("...NewItem        =", string(NewItem)));
			MPLog(Concat_StrStr("...ActiveItem     =", string(ActiveItem)));
			MPLog(Concat_StrStr("...PendingItem    =", string(PendingItem)));
		}
		return false;
	}
	if(Not_PreBool(NewItem.IsAvailable()))
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog(Concat_StrStr(Concat_StrStr(string(self), "---SwatPlayer::ValidateEquipPocket(). Validate failed. Pocket="), string(ThePocket)));
			MPLog("......Validate failed because requested item is unavailable.");
			MPLog(Concat_StrStr("...PocketContents =", string(PocketContents)));
			MPLog(Concat_StrStr("...NewItem        =", string(NewItem)));
			MPLog(Concat_StrStr("...ActiveItem     =", string(ActiveItem)));
			MPLog(Concat_StrStr("...PendingItem    =", string(PendingItem)));
		}
		return false;
	}
	if(AndAnd_BoolBool(NotEqual_ObjectObject(ActiveItem, none), Not_PreBool(ActiveItem.IsIdle())))
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog(Concat_StrStr(Concat_StrStr(string(self), "---SwatPlayer::ValidateEquipPocket(). Validate failed. Pocket="), string(ThePocket)));
			MPLog("......Validate failed because active item is not idle.");
			MPLog(Concat_StrStr("...PocketContents =", string(PocketContents)));
			MPLog(Concat_StrStr("...NewItem        =", string(NewItem)));
			MPLog(Concat_StrStr("...ActiveItem     =", string(ActiveItem)));
			MPLog(Concat_StrStr("...PendingItem    =", string(PendingItem)));
		}
		return false;
	}
	if(AndAnd_BoolBool(NotEqual_ObjectObject(PendingItem, none), Not_PreBool(PendingItem.IsIdle())))
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog(Concat_StrStr(Concat_StrStr(string(self), "---SwatPlayer::ValidateEquipPocket(). Validate failed. Pocket="), string(ThePocket)));
			MPLog("......Validate failed because pending item was not idle.");
			MPLog(Concat_StrStr("...PocketContents =", string(PocketContents)));
			MPLog(Concat_StrStr("...NewItem        =", string(NewItem)));
			MPLog(Concat_StrStr("...ActiveItem     =", string(ActiveItem)));
			MPLog(Concat_StrStr("...PendingItem    =", string(PendingItem)));
		}
		return false;
	}
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self), "---SwatPlayer::ValidateEquipPocket(). Validate succeeded. Pocket="), string(ThePocket)), ", NewItem="), string(NewItem)));
	}
	return true;
	return;
}

simulated function SetProtection(Actor.ESkeletalRegion Region, ProtectiveEquipment Protection)
{
	local SwatGamePlayerController PC;

	super(Pawn).SetProtection(Region, Protection);
	PC = SwatGamePlayerController(Controller);
	if(AndAnd_BoolBool(EqualEqual_ObjectObject(PC, Level.GetLocalPlayerController()), PC.HasHUDPage()))
	{
		PC.GetHUDPage().UpdateProtectiveEquipmentOverlay();
	}
	return;
}

simulated function DestroyEquipment()
{
	LoadOut.Destroy();
	super(Pawn).DestroyEquipment();
	return;
}

simulated event Destroyed()
{
	super.Destroyed();
	if(NotEqual_ObjectObject(GetHands(), none))
	{
		GetHands().Destroy();
	}
	StungTimer.Destroy();
	FlashbangedTimer.Destroy();
	GassedTimer.Destroy();
	PepperSprayedTimer.Destroy();
	TasedTimer.Destroy();
	PerlinNoiseAxisA.Delete();
	PerlinNoiseAxisA = none;
	PerlinNoiseAxisB.Delete();
	PerlinNoiseAxisB = none;
	LoadOut.Destroy();
	UnTriggerAllNonLethalEffectEvents();
	if(OrOr_BoolBool(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)), Level.IsCOOPServer))
	{
		SwatGameInfo(Level.Game).GameEvents.ReportableReportedToTOC.UnRegister(self);
	}
	return;
}

simulated function Died(Controller Killer, Class<DamageType> DamageType, Vector HitLocation, Vector HitMomentum)
{
	super.Died(Killer, DamageType, HitLocation, HitMomentum);
	if(OrOr_BoolBool(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)), Level.IsCOOPServer))
	{
		SwatAIRepository(Level.AIRepo).GetHive().NotifyPlayerDied(self);
	}
	UnTriggerAllNonLethalEffectEvents();
	return;
}

function ServerRequestEquip(HandheldEquipment.EquipmentSlot Slot)
{
	local HandheldEquipment NewEquipment, PendingItem, CurrentItem;

	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(string(self), "---SwatPlayer::ServerRequestEquip(). Slot="), string(Slot)));
	}
	if(Not_PreBool(RequestEquipShouldBeAllowed()))
	{
		return;
	}
	CurrentItem = GetActiveItem();
	PendingItem = GetPendingItem();
	if(AndAnd_BoolBool(NotEqual_ObjectObject(CurrentItem, none), Not_PreBool(CurrentItem.PlayerCanUnequip)))
	{
		return;
	}
	if(AndAnd_BoolBool(NotEqual_ObjectObject(PendingItem, none), Not_PreBool(PendingItem.PlayerCanUnequip)))
	{
		return;
	}
	if(ValidateEquipSlot(Slot))
	{
		NewEquipment = GetEquipmentAtSlot(Slot);
		if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
		{
			NewEquipment.Equip();
		}
		else
		{
			SetDesiredItemPocket(NewEquipment.GetPocket());
			CheckDesiredItemAndEquipIfNeeded();
		}
	}
	return;
}

simulated function OnActiveItemEquipped()
{
	super(SwatPawn).OnActiveItemEquipped();
	if(EqualEqual_ObjectObject(Controller, Level.GetLocalPlayerController()))
	{
		if(Greater_FloatFloat(GetActiveItem().ZoomedFOV, float(0)))
		{
			PlayerController(Controller).ZoomedFOV = GetActiveItem().ZoomedFOV;
		}
		else
		{
			PlayerController(Controller).ZoomedFOV = PlayerController(Controller).BaseFOV;
		}
	}
	return;
}

function AuthorizedEquipOnServer(HandheldEquipment.EquipmentSlot Slot)
{
	local HandheldEquipment NewEquipment;

	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(string(self), "---SwatPlayer::AuthorizedEquipOnServer(). Slot="), string(Slot)));
	}
	assert(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)));
	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
	{
		if(ValidateEquipSlot(Slot))
		{
			NewEquipment = GetEquipmentAtSlot(Slot);
			NewEquipment.Equip();
		}
	}
	else
	{
		NewEquipment = GetEquipmentAtSlot(Slot);
		SetDesiredItemPocket(NewEquipment.GetPocket());
		if(ValidateEquipSlot(Slot))
		{
			CheckDesiredItemAndEquipIfNeeded();
		}
	}
	return;
}

function ServerRequestReload(HandheldEquipment.EquipmentSlot Slot)
{
	local FiredWeapon ActiveItem, ItemToReload;
	local Controller i, theLocalPlayerController;
	local SwatGamePlayerController Current;

	Log("In SwatPlayer::ServerRequestReload().");
	ActiveItem = FiredWeapon(GetActiveItem());
	ItemToReload = FiredWeapon(GetEquipmentAtSlot(Slot));
	Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("   ActiveItem=", string(ActiveItem)), ", ItemToReload="), string(ItemToReload)));
	if(OrOr_BoolBool(NotEqual_ObjectObject(ItemToReload, ActiveItem), EqualEqual_ObjectObject(ActiveItem, none)))
	{
		return;
	}
	if(AndAnd_BoolBool(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)), Not_PreBool(ActiveItem.PrevalidateReload())))
	{
		return;
	}
	if(AndAnd_BoolBool(ActiveItem.IsA('RoundBasedWeapon'), ActiveItem.Ammo.IsFull()))
	{
		return;
	}
	if(ValidateReload())
	{
		if(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
		{
			theLocalPlayerController = Level.GetLocalPlayerController();
			i = Level.ControllerList;
			J0x154:

			if(NotEqual_ObjectObject(i, none))
			{
				Current = SwatGamePlayerController(i);
				if(NotEqual_ObjectObject(Current, none))
				{
					if(AndAnd_BoolBool(NotEqual_ObjectObject(Current, theLocalPlayerController), NotEqual_ObjectObject(Current.Pawn, none)))
					{
						if(Level.GetEngine().EnableDevTools)
						{
							MPLog(Concat_StrStr(Concat_StrStr(string(self), " on server: calling ClientReloadForPawn() on "), string(Current.Pawn)));
						}
						Current.ClientReloadForPawn(self, ItemToReload.GetSlot());
					}
				}
				i = i.nextController;
				// [Loop Continue]
				goto J0x154;
			}
		}
		ItemToReload.Reload();
	}
	return;
}

function ServerRequestUse(SwatPlayer inUsePawn)
{
	local SwatGamePlayerController Current;
	local Controller iController, LocalPC;
	local NetPlayer theNetPlayer;
	local HandheldEquipment Equipment;

	assert(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)));
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(string(self), "---SwatPlayer::ServerRequestUse(). PawnUser="), string(inUsePawn)));
	}
	Equipment = inUsePawn.GetActiveItem();
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr("...Equipment=", string(Equipment)));
	}
	if(Level.GetEngine().EnableDevTools)
	{
		if(NotEqual_ObjectObject(Equipment, none))
		{
			if(Not_PreBool(Equipment.IsEquipped()))
			{
				MPLog("...failing because equipment wasn't equipped.");
			}
			if(Not_PreBool(Equipment.IsIdle()))
			{
				MPLog("...failing because equipment wasn't idle.");
			}
		}
	}
	if(OrOr_BoolBool(EqualEqual_ObjectObject(Equipment, none), Not_PreBool(Equipment.PrevalidateUse())))
	{
		return;
	}
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog("...Equipment.PrevalidateUse()=True");
	}
	LocalPC = Level.GetLocalPlayerController();
	iController = Level.ControllerList;
	J0x20D:

	if(NotEqual_ObjectObject(iController, none))
	{
		Current = SwatGamePlayerController(iController);
		if(AndAnd_BoolBool(NotEqual_ObjectObject(Current, none), NotEqual_ObjectObject(Current, LocalPC)))
		{
			theNetPlayer = NetPlayer(Current.Pawn);
			if(NotEqual_ObjectObject(theNetPlayer, none))
			{
				Log(Concat_StrStr(Concat_StrStr(string(self), " on server: calling ClientUse() by "), string(theNetPlayer)));
				theNetPlayer.ClientUse(inUsePawn);
			}
		}
		iController = iController.nextController;
		// [Loop Continue]
		goto J0x20D;
	}
	Equipment.Use();
	return;
}

simulated function ClientUse(Pawn inUsePawn)
{
	local HandheldEquipment Equipment;

	assert(EqualEqual_IntInt(int(Level.NetMode), int(NM_Client)));
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self), "---SwatPlayer::ClientUse(). PawnUser="), string(inUsePawn)), ", his equipment is: "), string(inUsePawn.GetActiveItem())), ", inUsePawn.GetActiveItem().PrevalidateUse() = "), string(inUsePawn.GetActiveItem().PrevalidateUse())));
	}
	if(EqualEqual_ObjectObject(inUsePawn, none))
	{
		return;
	}
	Equipment = inUsePawn.GetActiveItem();
	if(OrOr_BoolBool(EqualEqual_ObjectObject(Equipment, none), Not_PreBool(Equipment.PrevalidateUse())))
	{
		return;
	}
	Equipment.Use();
	return;
}

function ServerRequestQualify(Actor DefaultFireFocusActor)
{
	local SwatGamePlayerController Current;
	local Controller i, LPC;
	local NetPlayer theNetPlayer;
	local SwatAI theSwatAI;
	local Actor QualifyTarget;
	local HandheldEquipment theEquipment;

	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(string(self), "---SwatPlayer::ServerRequestQualify(). TargetActor="), string(DefaultFireFocusActor)));
	}
	assert(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)));
	QualifyTarget = DefaultFireFocusActor;
	if(EqualEqual_ObjectObject(QualifyTarget, none))
	{
		return;
	}
	theEquipment = GetActiveItem();
	if(OrOr_BoolBool(EqualEqual_ObjectObject(theEquipment, none), Not_PreBool(theEquipment.IsIdle())))
	{
		return;
	}
	theNetPlayer = NetPlayer(DefaultFireFocusActor);
	if(NotEqual_ObjectObject(theNetPlayer, none))
	{
		if(AndAnd_BoolBool(theEquipment.IsA('Cuffs'), Not_PreBool(theNetPlayer.CanBeArrestedNow())))
		{
			return;
		}
		if(AndAnd_BoolBool(theEquipment.IsA('Toolkit'), Not_PreBool(theNetPlayer.CanBeUnarrestedNow())))
		{
			return;
		}
	}
	theSwatAI = SwatAI(DefaultFireFocusActor);
	if(NotEqual_ObjectObject(theSwatAI, none))
	{
		if(AndAnd_BoolBool(theEquipment.IsA('Cuffs'), Not_PreBool(theSwatAI.CanBeArrestedNow())))
		{
			return;
		}
	}
	SwatGamePlayerController(Controller).OtherForQualifyingUse = DefaultFireFocusActor;
	SwatGamePlayerController(Controller).GotoState('QualifyingForUse');
	SwatGamePlayerController(Controller).ClientGotoState('QualifyingForUse', 'Begin');
	LPC = Level.GetLocalPlayerController();
	i = Level.ControllerList;
	J0x1F4:

	if(NotEqual_ObjectObject(i, none))
	{
		Current = SwatGamePlayerController(i);
		if(NotEqual_ObjectObject(Current, none))
		{
			theNetPlayer = NetPlayer(Current.Pawn);
			if(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(Current, LPC), NotEqual_ObjectObject(theNetPlayer, none)), NotEqual_ObjectObject(theNetPlayer, self)))
			{
				theNetPlayer.ClientStartQualify(self, QualifyTarget);
			}
		}
		i = i.nextController;
		// [Loop Continue]
		goto J0x1F4;
	}
	return;
}

simulated function ClientStartQualify(SwatPlayer Qualifier, Actor QualifyTarget)
{
	local EquipmentUsedOnOther theEquipment;

	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self), "---SwatPlayer::ClientStartQualify(). Qualifier="), string(Qualifier)), ", QualifyTarget="), string(QualifyTarget)));
	}
	assert(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)));
	if(OrOr_BoolBool(EqualEqual_ObjectObject(Qualifier, none), EqualEqual_ObjectObject(QualifyTarget, none)))
	{
		return;
	}
	assert(NotEqual_ObjectObject(Qualifier, self));
	if(EqualEqual_ObjectObject(Qualifier, self))
	{
		return;
	}
	theEquipment = EquipmentUsedOnOther(Qualifier.GetActiveItem());
	if(EqualEqual_ObjectObject(theEquipment, none))
	{
		return;
	}
	Qualifier.AnimSnapBaseToAim();
	if(theEquipment.IsIdle())
	{
		theEquipment.BeginQualifying(QualifyTarget);
	}
	else
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog("...equipment was not idle. Caching request to qualify.");
		}
		Qualifier.CachedQualifyEquipment = theEquipment;
		Qualifier.CachedQualifyTarget = QualifyTarget;
	}
	return;
}

simulated function bool WeHaveACachedQualify()
{
	return NotEqual_ObjectObject(CachedQualifyEquipment, none);
	return;
}

simulated function BeginCachedQualification()
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---SwatPlayer::BeginCachedQualification()."));
	}
	assert(NotEqual_ObjectObject(CachedQualifyEquipment, none));
	CachedQualifyEquipment.BeginQualifying(CachedQualifyTarget);
	CachedQualifyEquipment = none;
	CachedQualifyTarget = none;
	return;
}

function NotifyClientsOfFinishQualify(Actor QualifyTarget, bool success)
{
	local Controller i;
	local PlayerController Current;
	local SwatPlayer PlayerPawn;
	local PlayerController theLocalPlayerController;

	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---SwatPlayer::NotifyClientsOfFinishQualify()"));
	}
	assert(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)));
	theLocalPlayerController = Level.GetLocalPlayerController();
	i = Level.ControllerList;
	J0x98:

	if(NotEqual_ObjectObject(i, none))
	{
		Current = PlayerController(i);
		if(NotEqual_ObjectObject(Current, none))
		{
			PlayerPawn = SwatPlayer(i.Pawn);
			if(AndAnd_BoolBool(NotEqual_ObjectObject(i, theLocalPlayerController), NotEqual_ObjectObject(PlayerPawn, none)))
			{
				PlayerPawn.ClientFinishQualify(self, QualifyTarget, success);
			}
		}
		i = i.nextController;
		// [Loop Continue]
		goto J0x98;
	}
	return;
}

simulated function ClientFinishQualify(SwatPlayer Qualifier, Actor QualifyTarget, bool success)
{
	local QualifiedUseEquipment QualifiedUseEquipment;

	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self), "---SwatPlayer::ClientFinishQualify(). Qualifier="), string(Qualifier)), ", QualifyTarget="), string(QualifyTarget)), ", Success="), string(success)));
	}
	assert(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)));
	if(EqualEqual_ObjectObject(Qualifier, none))
	{
		return;
	}
	QualifiedUseEquipment = QualifiedUseEquipment(Qualifier.GetActiveItem());
	if(NotEqual_ObjectObject(QualifiedUseEquipment, none))
	{
		if(success)
		{
			QualifiedUseEquipment.DoQualifyComplete();
		}
		else
		{
			QualifiedUseEquipment.DoInterrupt();
		}
	}
	return;
}

simulated event DesiredItemPocketChanged()
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---SwatPlayer::DesiredItemPocketChanged()."));
	}
	if(Not_PreBool(RequestEquipShouldBeAllowed()))
	{
		return;
	}
	CheckDesiredItemAndEquipIfNeeded();
	return;
}

simulated function OnEquippingFinished()
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---SwatPlayer::OnEquippingFinished()."));
	}
	super(SwatPawn).OnEquippingFinished();
	NotifyPlayerHeIsVIPIfNecessary();
	if(EqualEqual_ObjectObject(Controller, Level.GetLocalPlayerController()))
	{
		if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(Not_PreBool(Class'Engine.Pawn'.static.checkDead(self)), Not_PreBool(CheckDesiredItemAndEquipIfNeeded())), NotEqual_IntInt(int(SwatGamePlayerController(Controller).EquipmentSlotForQualify), int(0))), EqualEqual_IntInt(int(GetActiveItem().GetSlot()), int(SwatGamePlayerController(Controller).EquipmentSlotForQualify))), Greater_IntInt(int(Controller.bFire), 0)))
		{
			if(Level.GetEngine().EnableDevTools)
			{
				MPLog("...complicated test succeeded and we're inside the if-block.");
			}
			SwatGamePlayerController(Controller).EquipmentSlotForQualify = 0;
			SwatGamePlayerController(Controller).UpdateFocus();
			PlayerController(Controller).Fire();
		}
	}
	else
	{
		if(Not_PreBool(Class'Engine.Pawn'.static.checkDead(self)))
		{
			if(Level.GetEngine().EnableDevTools)
			{
				MPLog(Concat_StrStr("...WeHaveACachedQualify()=", string(WeHaveACachedQualify())));
			}
			if(AndAnd_BoolBool(EqualEqual_IntInt(int(Level.NetMode), int(NM_Client)), WeHaveACachedQualify()))
			{
				BeginCachedQualification();
			}
			else
			{
				CheckDesiredItemAndEquipIfNeeded();
			}
		}
	}
	return;
}

simulated function NotifyPlayerHeIsVIPIfNecessary()
{
	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
	{
		if(EqualEqual_ObjectObject(Controller, Level.GetLocalPlayerController()))
		{
			if(AndAnd_BoolBool(IsTheVIP(), Not_PreBool(bNotifiedPlayerTheyAreVIP)))
			{
				ClientMessage("", 'YouAreVIP');
				bNotifiedPlayerTheyAreVIP = true;
			}
		}
	}
	return;
}

simulated function OnUsingBegan()
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---SwatPlayer::OnUsingBegan()."));
	}
	SetupReequip();
	if(AndAnd_BoolBool(IsLowReady(), GetActiveItem().ShouldUseWhileLowReady()))
	{
		SetLowReady(false);
	}
	if(IsControlledByLocalHuman())
	{
		SwatGamePlayerController(Controller).BeginLowReadyRefractoryPeriod();
	}
	return;
}

simulated function SetupReequip()
{
	local HandheldEquipment ActiveItem;

	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---SwatPlayer::SetupReequip()."));
	}
	ActiveItem = GetActiveItem();
	EquipOtherAfterUsed = OrOr_BoolBool(ActiveItem.UnavailableAfterUsed, ActiveItem.EquipOtherAfterUsed);
	SlotForReequip = ActiveItem.GetSlotForReequip();
	return;
}

simulated function OnUsingFinished()
{
	local HandheldEquipment ItemToEquip;

	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---SwatPlayer::OnUsingFinished()."));
	}
	if(Class'Engine.Pawn'.static.checkDead(self))
	{
		return;
	}
	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)))
	{
		if(EquipOtherAfterUsed)
		{
			ItemToEquip = LoadOut.GetItemAtSlot(SlotForReequip);
			if(NotEqual_ObjectObject(ItemToEquip, none))
			{
				AuthorizedEquipOnServer(SlotForReequip);
			}
			else
			{
				DoDefaultEquip();
			}
		}
	}
	else
	{
		CheckDesiredItemAndEquipIfNeeded();
	}
	return;
}

simulated function IWasNonlethaledAndFinishedSoDoAnEquipIfINeedToDoOne()
{
	local HandheldEquipment theActiveItem, thePendingItem;

	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---SwatPlayer::IWasNonlethaledAndFinishedSoDoAnEquipIfINeedToDoOne()."));
	}
	if(Class'Engine.Pawn'.static.checkDead(self))
	{
		return;
	}
	theActiveItem = GetActiveItem();
	if(AndAnd_BoolBool(NotEqual_ObjectObject(theActiveItem, none), theActiveItem.IsA('IAmCuffed')))
	{
		return;
	}
	thePendingItem = GetPendingItem();
	if(AndAnd_BoolBool(NotEqual_ObjectObject(thePendingItem, none), thePendingItem.IsA('IAmCuffed')))
	{
		return;
	}
	if(IsArrested())
	{
		return;
	}
	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)))
	{
		theActiveItem = GetActiveItem();
		if(OrOr_BoolBool(EqualEqual_ObjectObject(theActiveItem, none), Not_PreBool(theActiveItem.IsAvailable())))
		{
			DoDefaultEquip();
		}
	}
	else
	{
		CheckDesiredItemAndEquipIfNeeded();
	}
	return;
}

simulated function OnReloadingFinished()
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---SwatPlayer::OnReloadingFinished()."));
	}
	if(Not_PreBool(Class'Engine.Pawn'.static.checkDead(self)))
	{
		if(Not_PreBool(CheckDesiredItemAndEquipIfNeeded()))
		{
			SwatGamePlayerController(Controller).ConsiderAutoReloading();
		}
	}
	return;
}

protected simulated function bool CheckDesiredItemAndEquipIfNeeded()
{
	local HandheldEquipment.Pocket DesiredItemPocket;
	local HandheldEquipment ActiveItem, NewEquipment;

	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---SwatPlayer::CheckDesiredItemAndEquipIfNeeded()."));
	}
	if(AndAnd_BoolBool(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)), NotEqual_ObjectObject(LoadOut, none)))
	{
		DesiredItemPocket = GetDesiredItemPocket();
		ActiveItem = GetActiveItem();
		if(AndAnd_BoolBool(NotEqual_ObjectObject(ActiveItem, none), EqualEqual_IntInt(int(DesiredItemPocket), int(ActiveItem.GetPocket()))))
		{
			if(Level.GetEngine().EnableDevTools)
			{
				MPLog(Concat_StrStr(Concat_StrStr(string(self), "...returning false: Pockets are same="), string(DesiredItemPocket)));
			}
			return false;
		}
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog(Concat_StrStr(string(self), "...Pockets differ:"));
		}
		if(Level.GetEngine().EnableDevTools)
		{
			if(NotEqual_ObjectObject(ActiveItem, none))
			{
				MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr("...DesiredItemPocket=", string(DesiredItemPocket)), ", ActiveItemPocket="), string(ActiveItem.GetPocket())));
			}
			else
			{
				MPLog(Concat_StrStr(Concat_StrStr("...DesiredItemPocket=", string(DesiredItemPocket)), ", ActiveItem=None"));
			}
		}
		if(ValidateEquipPocket(DesiredItemPocket))
		{
			NewEquipment = HandheldEquipment(LoadOut.GetItemAtPocket(DesiredItemPocket));
			if(Level.GetEngine().EnableDevTools)
			{
				MPLog(Concat_StrStr("...LoadOut.GetItemAtPocket( DesiredItemPocket ) = ", string(NewEquipment)));
			}
			NewEquipment.Equip();
		}
		return true;
	}
	else
	{
		return false;
	}
	return;
}

simulated function HandheldEquipment GetEquipmentAtSlot(HandheldEquipment.EquipmentSlot Slot)
{
	return LoadOut.GetItemAtSlot(Slot);
	return;
}

simulated function bool ValidateReload()
{
	local HandheldEquipment ActiveItem;
	local FiredWeapon Weapon;

	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---SwatPlayer::ValidateReload()."));
	}
	ActiveItem = GetActiveItem();
	Weapon = FiredWeapon(ActiveItem);
	if(EqualEqual_ObjectObject(Weapon, none))
	{
		return false;
	}
	if(Not_PreBool(Weapon.IsIdle()))
	{
		return false;
	}
	if(Not_PreBool(Weapon.Ammo.CanReload()))
	{
		return false;
	}
	return true;
	return;
}

simulated function float GetFireTweenTime()
{
	if(IsLowReady())
	{
		return LowReadyFireTweenTime;
	}
	else
	{
		return 0.0000000;
	}
	return;
}

function bool HandsShouldIdle()
{
	return true;
	return;
}

simulated function bool IsInProcessOfThrowing()
{
	return Not_PreBool(CanThrowPrep());
	return;
}

simulated function bool CanThrowPrep()
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---SwatPlayer::CanThrowPrep()."));
	}
	return true;
	return;
}

simulated function bool RequestEquipShouldBeAllowed()
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---SwatPlayer::RequestEquipShouldBeAllowed()."));
	}
	return true;
	return;
}

simulated function EndThrow(float ThrowHeldTimeFromNetwork)
{
	local ThrownWeapon theItem;

	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---SwatPlayer::EndThrow()."));
	}
	theItem = ThrownWeapon(GetActiveItem());
	if(OrOr_BoolBool(EqualEqual_ObjectObject(theItem, none), Not_PreBool(theItem.IsIdle())))
	{
		return;
	}
	ThrowHeldTime = ThrowHeldTimeFromNetwork;
	GotoState('ThrowingFinish');
	return;
}

function GetThrownProjectileParams(out Vector outLocation, out Rotator outRotation)
{
	local PlayerController PC;
	local Actor ViewActor;

	PC = PlayerController(Controller);
	if(NotEqual_ObjectObject(PC, none))
	{
		PC.PlayerCalcView(ViewActor, outLocation, outRotation);
		AddEqual_IntInt(outRotation.Pitch, ThrownProjectilePitch);
	}
	return;
}

simulated function name GetPreThrowAnimation()
{
	return PreThrowAnimation;
	return;
}

simulated function name GetThrowAnimation(float ThrowSpeed)
{
	if(Less_FloatFloat(ThrowSpeed, MinimumLongThrowSpeed))
	{
		return ThrowShortAnimation;
	}
	else
	{
		return ThrowLongAnimation;
	}
	return;
}

simulated function name GetPawnThrowRootBone()
{
	return ThrowAnimationRootBone;
	return;
}

simulated function float GetPawnThrowTweenTime()
{
	return ThrowAnimationTweenTime;
	return;
}

simulated function bool IsPlayerPawn()
{
	return true;
	return;
}

simulated function bool IsHumanControlled()
{
	return true;
	return;
}

function ServerBeginFiringWeapon(HandheldEquipment.EquipmentSlot ItemSlot)
{
	local Controller i;
	local SwatGamePlayerController Current;
	local FiredWeapon theFiredWeapon;
	local PlayerController theLocalPlayerController;

	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(string(self), "---SwatPlayer::ServerBeginFiringWeapon(). ItemSlot="), string(ItemSlot)));
	}
	theFiredWeapon = FiredWeapon(GetLoadOut().GetItemAtSlot(ItemSlot));
	if(EqualEqual_ObjectObject(theFiredWeapon, GetActiveItem()))
	{
		if(OrOr_BoolBool(theFiredWeapon.IsIdle(), Pawn(theFiredWeapon.Owner).IsControlledByLocalHuman()))
		{
			if(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
			{
				if(Not_PreBool(theFiredWeapon.Ammo.NeedsReload()))
				{
					theLocalPlayerController = Level.GetLocalPlayerController();
					i = Level.ControllerList;
					J0x128:

					if(NotEqual_ObjectObject(i, none))
					{
						Current = SwatGamePlayerController(i);
						if(NotEqual_ObjectObject(Current, none))
						{
							if(AndAnd_BoolBool(NotEqual_ObjectObject(i.Pawn, self), NotEqual_ObjectObject(i, theLocalPlayerController)))
							{
								if(Current.IsNetRelevant(self))
								{
									Current.ClientBeginFiringWeapon(self, theFiredWeapon.GetSlot(), theFiredWeapon.GetCurrentFireMode());
								}
							}
						}
						i = i.nextController;
						// [Loop Continue]
						goto J0x128;
					}
				}
			}
			if(Not_PreBool(IsControlledByLocalHuman()))
			{
				theFiredWeapon.OnPlayerUse();
			}
		}
	}
	else
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self), " was told to begin firing with "), string(theFiredWeapon)), ", but the ActiveItem="), string(GetActiveItem())));
		}
	}
	return;
}

function BroadcastEmptyFiredToClients()
{
	local Controller i;
	local SwatGamePlayerController Current;
	local PlayerController theLocalPlayerController;

	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---SwatPlayer::BroadcastEmptyFiredToClients()."));
	}
	assert(OrOr_BoolBool(EqualEqual_IntInt(int(Level.NetMode), int(NM_DedicatedServer)), EqualEqual_IntInt(int(Level.NetMode), int(NM_ListenServer))));
	theLocalPlayerController = Level.GetLocalPlayerController();
	i = Level.ControllerList;
	J0xB4:

	if(NotEqual_ObjectObject(i, none))
	{
		Current = SwatGamePlayerController(i);
		if(NotEqual_ObjectObject(Current, none))
		{
			if(AndAnd_BoolBool(NotEqual_ObjectObject(i.Pawn, self), NotEqual_ObjectObject(i, theLocalPlayerController)))
			{
				if(Current.IsNetRelevant(self))
				{
					SwatPlayer(Current.Pawn).ClientPlayEmptyFired(self);
				}
			}
		}
		i = i.nextController;
		// [Loop Continue]
		goto J0xB4;
	}
	return;
}

simulated function ClientPlayEmptyFired(Pawn PawnWhoFired)
{
	local FiredWeapon theActiveItem;
	local HandheldEquipmentModel EffectsSource;
	local Pawn OtherForEffectEvents;
	local name EffectSubsystemToIgnore;

	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr("---ClientPlayEmptyFired(). PawnWhoFired=", string(PawnWhoFired)));
	}
	if(EqualEqual_ObjectObject(PawnWhoFired, none))
	{
		return;
	}
	theActiveItem = FiredWeapon(PawnWhoFired.GetActiveItem());
	if(EqualEqual_ObjectObject(theActiveItem, none))
	{
		return;
	}
	EffectsSource = theActiveItem.ThirdPersonModel;
	if(NotEqual_ObjectObject(EffectsSource, none))
	{
		if(Less_FloatFloat(EffectsSource.LastRenderTime, Subtract_FloatFloat(Level.TimeSeconds, 1.0000000)))
		{
			OtherForEffectEvents = PawnWhoFired;
		}
		EffectsSource.TriggerEffectEvent('EmptyFired', OtherForEffectEvents,,,, NotEqual_ObjectObject(OtherForEffectEvents, none),,,, EffectSubsystemToIgnore);
	}
	return;
}

function ServerEndFiringWeapon()
{
	local Controller i;
	local SwatGamePlayerController Current;
	local FiredWeapon theFiredWeapon;
	local PlayerController theLocalPlayerController;

	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---SwatPlayer::ServerEndFiringWeapon()."));
	}
	assert(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)));
	bWantsToContinueAutoFiring = false;
	theFiredWeapon = FiredWeapon(GetActiveItem());
	theLocalPlayerController = Level.GetLocalPlayerController();
	i = Level.ControllerList;
	J0xAB:

	if(NotEqual_ObjectObject(i, none))
	{
		Current = SwatGamePlayerController(i);
		if(NotEqual_ObjectObject(Current, none))
		{
			if(AndAnd_BoolBool(NotEqual_ObjectObject(i.Pawn, self), NotEqual_ObjectObject(i, theLocalPlayerController)))
			{
				if(Current.IsNetRelevant(self))
				{
					Current.ClientEndFiringWeapon(self);
				}
			}
		}
		i = i.nextController;
		// [Loop Continue]
		goto J0xAB;
	}
	return;
}

function ReactToFlashbangGrenade(SwatGrenadeProjectile Grenade, Pawn Instigator, float Damage, float DamageRadius, Range KarmaImpulse, float KarmaImpulseRadius, float StunRadius, float PlayerFlashbangStunDuration, float AIStunDuration, float MoraleModifier)
{
	local Vector direction, GrenadeLocation;
	local float Distance;
	local name Reason, NewControllerState, NewPawnState;
	local Actor ViewTarget;
	local Vector CameraLocation;
	local Rotator CameraRotation;
	local bool FOVMatters, CanSee;

	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Client)))
	{
		return;
	}
	if(AndAnd_BoolBool(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)), HasProtection('IProtectFromFlashbang')))
	{
		return;
	}
	if(AndAnd_BoolBool(NotEqual_ObjectObject(Controller, none), Controller.bGodMode))
	{
		return;
	}
	if(Class'Engine.Pawn'.static.checkDead(self))
	{
		return;
	}
	if(NotEqual_ObjectObject(Grenade, none))
	{
		GrenadeLocation = Grenade.Location;
		direction = Subtract_VectorVector(Location, Grenade.Location);
		Distance = VSize(direction);
		if(EqualEqual_ObjectObject(Instigator, none))
		{
			Instigator = Pawn(Grenade.Owner);
		}
	}
	else
	{
		GrenadeLocation = Location;
		Distance = 0.0000000;
	}
	PlayerController(Controller).PlayerCalcView(ViewTarget, CameraLocation, CameraRotation);
	FOVMatters = OrOr_BoolBool(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)), Level.IsPlayingCOOP);
	CanSee = OrOr_BoolBool(Not_PreBool(FOVMatters), PointWithinInfiniteCone(CameraLocation, Vector(CameraRotation), GrenadeLocation, Multiply_FloatFloat(Controller.FovAngle, 0.0174533)));
	Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("TMC FOVMatters=", string(FOVMatters)), ", CanSee="), string(CanSee)));
	if(OrOr_BoolBool(bTestingCameraEffects, AndAnd_BoolBool(LessEqual_FloatFloat(Distance, StunRadius), CanSee)))
	{
		if(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)))
		{
			FlashbangedTimer.StartTimer(PlayerFlashbangStunDuration, false, true);
			if(AndAnd_BoolBool(NotEqual_NameName(Controller.GetStateName(), 'BeingCuffed'), NotEqual_NameName(Controller.GetStateName(), 'BeingUncuffed')))
			{
				Reason = 'ReactingToNonlethal';
				NewControllerState = 'PlayerWalking';
				NewPawnState = 'None';
				if(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
				{
					SwatGameReplicationInfo(Level.GetGameReplicationInfo()).NotifyClientsToInterruptAndGotoState(self, Reason, NewControllerState, NewPawnState);
				}
				InterruptState(Reason);
				Controller.InterruptState(Reason);
				GotoState(NewPawnState);
				Controller.GotoState(NewControllerState);
			}
		}
		LastFlashbangedTime = Level.TimeSeconds;
		SetIsFlashbanged(true);
		RefreshCameraEffects(self);
		ChangeAnimation();
		bIsTriggered_ReactedBang = 0;
		UpdateNonLethalEffectEvents();
		if(NotEqual_ObjectObject(Controller, Level.GetLocalPlayerController()))
		{
			ClientDoFlashbangReaction();
		}
	}
	if(LessEqual_FloatFloat(Distance, DamageRadius))
	{
		TakeDamage(int(Damage), Instigator, GrenadeLocation, vect(0.0000000, 0.0000000, 0.0000000), Class'Engine.GrenadeDamageType');
	}
	return;
}

simulated function ClientDoFlashbangReaction()
{
	if(AndAnd_BoolBool(EqualEqual_IntInt(int(Level.NetMode), int(NM_Client)), EqualEqual_ObjectObject(Controller, Level.GetLocalPlayerController())))
	{
		if(Class'Engine.Pawn'.static.checkDead(self))
		{
			return;
		}
		LastFlashbangedTime = Level.TimeSeconds;
		SetIsFlashbanged(true);
		RefreshCameraEffects(self);
		ChangeAnimation();
		bIsTriggered_ReactedBang = 0;
		UpdateNonLethalEffectEvents();
	}
	return;
}

function ReactToCSGas(Actor GasContainer, float Duration, float SPPlayerProtectiveEquipmentDurationScaleFactor, float MPPlayerProtectiveEquipmentDurationScaleFactor)
{
	local name Reason, NewControllerState, NewPawnState;

	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Client)))
	{
		return;
	}
	if(AndAnd_BoolBool(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)), Not_PreBool(bTestingCameraEffects)))
	{
		return;
	}
	if(HasProtection('IProtectFromCSGas'))
	{
		if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
		{
			MultiplyEqual_FloatFloat(Duration, SPPlayerProtectiveEquipmentDurationScaleFactor);
		}
		else
		{
			MultiplyEqual_FloatFloat(Duration, MPPlayerProtectiveEquipmentDurationScaleFactor);
		}
		if(LessEqual_FloatFloat(Duration, float(0)))
		{
			return;
		}
	}
	if(AndAnd_BoolBool(NotEqual_ObjectObject(Controller, none), Controller.bGodMode))
	{
		return;
	}
	if(Class'Engine.Pawn'.static.checkDead(self))
	{
		return;
	}
	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)))
	{
		GassedTimer.StartTimer(Duration, false, true);
		if(AndAnd_BoolBool(NotEqual_NameName(Controller.GetStateName(), 'BeingCuffed'), NotEqual_NameName(Controller.GetStateName(), 'BeingUncuffed')))
		{
			Reason = 'ReactingToNonlethal';
			NewControllerState = 'PlayerWalking';
			NewPawnState = 'None';
			if(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
			{
				SwatGameReplicationInfo(Level.GetGameReplicationInfo()).NotifyClientsToInterruptAndGotoState(self, Reason, NewControllerState, NewPawnState);
			}
			InterruptState(Reason);
			Controller.InterruptState(Reason);
			GotoState(NewPawnState);
			Controller.GotoState(NewControllerState);
		}
	}
	LastGassedTime = Level.TimeSeconds;
	LastGassedDuration = Duration;
	SetIsGassed(true);
	RefreshCameraEffects(self);
	ChangeAnimation();
	UpdateNonLethalEffectEvents();
	if(NotEqual_ObjectObject(Controller, Level.GetLocalPlayerController()))
	{
		ClientDoGassedReaction(Duration);
	}
	return;
}

simulated function ClientDoGassedReaction(float Duration)
{
	if(AndAnd_BoolBool(EqualEqual_IntInt(int(Level.NetMode), int(NM_Client)), EqualEqual_ObjectObject(Controller, Level.GetLocalPlayerController())))
	{
		if(Class'Engine.Pawn'.static.checkDead(self))
		{
			return;
		}
		LastGassedTime = Level.TimeSeconds;
		LastGassedDuration = Duration;
		SetIsGassed(true);
		RefreshCameraEffects(self);
		ChangeAnimation();
		UpdateNonLethalEffectEvents();
	}
	return;
}

function ReactToStingGrenade(SwatGrenadeProjectile Grenade, Pawn Instigator, float Damage, float DamageRadius, Range KarmaImpulse, float KarmaImpulseRadius, float StingRadius, float PlayerStingDuration, float HeavilyArmoredPlayerStingDuration, float AIStingDuration, float MoraleModifier)
{
	local Vector direction, GrenadeLocation;
	local float Distance;
	local name Reason, NewControllerState, NewPawnState;
	local float StingDuration;
	local Class<DamageType> ActualDamageType;

	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Client)))
	{
		return;
	}
	if(AndAnd_BoolBool(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)), HasProtection('IProtectFromSting')))
	{
		return;
	}
	if(AndAnd_BoolBool(NotEqual_ObjectObject(Controller, none), Controller.bGodMode))
	{
		return;
	}
	if(Class'Engine.Pawn'.static.checkDead(self))
	{
		return;
	}
	if(NotEqual_ObjectObject(Grenade, none))
	{
		GrenadeLocation = Grenade.Location;
		direction = Subtract_VectorVector(Location, Grenade.Location);
		Distance = VSize(direction);
		if(EqualEqual_ObjectObject(Instigator, none))
		{
			Instigator = Pawn(Grenade.Owner);
		}
		ActualDamageType = Class'Engine.GrenadeDamageType';
	}
	else
	{
		GrenadeLocation = Location;
		Distance = 0.0000000;
		ActualDamageType = Class<DamageType>(DynamicLoadObject("SwatEquipment.LessLethalSG", Class'Core.Class'));
	}
	if(GetLoadOut().HasHeavyArmor())
	{
		StingDuration = HeavilyArmoredPlayerStingDuration;
	}
	else
	{
		StingDuration = PlayerStingDuration;
	}
	if(LessEqual_FloatFloat(Distance, StingRadius))
	{
		PerlinNoiseAxisA.Reinitialize();
		PerlinNoiseAxisB.Reinitialize();
		if(NotEqual_ObjectObject(Grenade, none))
		{
			LastStingWeapon = 0;
		}
		else
		{
			LastStingWeapon = 1;
		}
		if(Greater_FloatFloat(Level.TimeSeconds, Add_FloatFloat(LastStungTime, LastStungDuration)))
		{
			LastStungDuration = StingDuration;
		}
		else
		{
			LastStungDuration = FMax(StingDuration, Subtract_FloatFloat(LastStungDuration, Subtract_FloatFloat(Level.TimeSeconds, LastStungTime)));
		}
		LastStungTime = Level.TimeSeconds;
		if(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)))
		{
			StungTimer.StartTimer(LastStungDuration, false, true);
			if(AndAnd_BoolBool(NotEqual_NameName(Controller.GetStateName(), 'BeingCuffed'), NotEqual_NameName(Controller.GetStateName(), 'BeingUncuffed')))
			{
				Reason = 'ReactingToNonlethal';
				NewControllerState = 'PlayerWalking';
				NewPawnState = 'None';
				if(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
				{
					SwatGameReplicationInfo(Level.GetGameReplicationInfo()).NotifyClientsToInterruptAndGotoState(self, Reason, NewControllerState, NewPawnState);
				}
				InterruptState(Reason);
				Controller.InterruptState(Reason);
				GotoState(NewPawnState);
				Controller.GotoState(NewControllerState);
			}
		}
		SetIsStung(true);
		RefreshCameraEffects(self);
		ChangeAnimation();
		bIsTriggered_ReactedSting = 0;
		UpdateNonLethalEffectEvents();
		if(NotEqual_ObjectObject(Controller, Level.GetLocalPlayerController()))
		{
			ClientDoStungReaction(LastStungDuration, LastStingWeapon);
		}
	}
	if(LessEqual_FloatFloat(Distance, DamageRadius))
	{
		TakeDamage(int(Damage), Instigator, GrenadeLocation, vect(0.0000000, 0.0000000, 0.0000000), ActualDamageType);
	}
	return;
}

simulated function ClientDoStungReaction(float PlayerDuration, SwatPlayer.ELastStingWeapon iLastStingWeapon)
{
	if(AndAnd_BoolBool(EqualEqual_IntInt(int(Level.NetMode), int(NM_Client)), EqualEqual_ObjectObject(Controller, Level.GetLocalPlayerController())))
	{
		if(Class'Engine.Pawn'.static.checkDead(self))
		{
			return;
		}
		PerlinNoiseAxisA.Reinitialize();
		PerlinNoiseAxisB.Reinitialize();
		LastStingWeapon = iLastStingWeapon;
		LastStungDuration = PlayerDuration;
		LastStungTime = Level.TimeSeconds;
		SetIsStung(true);
		RefreshCameraEffects(self);
		ChangeAnimation();
		bIsTriggered_ReactedSting = 0;
		UpdateNonLethalEffectEvents();
	}
	return;
}

function ReactToBeingPepperSprayed(Actor PepperSpray, float PlayerDuration, float AIDuration, float SPPlayerProtectiveEquipmentDurationScaleFactor, float MPPlayerProtectiveEquipmentDurationScaleFactor)
{
	local name Reason, NewControllerState, NewPawnState;

	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Client)))
	{
		return;
	}
	if(Class'Engine.Pawn'.static.checkDead(self))
	{
		return;
	}
	if(HasProtection('IProtectFromPepperSpray'))
	{
		if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
		{
			MultiplyEqual_FloatFloat(PlayerDuration, SPPlayerProtectiveEquipmentDurationScaleFactor);
		}
		else
		{
			MultiplyEqual_FloatFloat(PlayerDuration, MPPlayerProtectiveEquipmentDurationScaleFactor);
		}
		if(LessEqual_FloatFloat(PlayerDuration, float(0)))
		{
			return;
		}
	}
	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)))
	{
		PepperSprayedTimer.StartTimer(PlayerDuration, false, true);
		if(AndAnd_BoolBool(NotEqual_NameName(Controller.GetStateName(), 'BeingCuffed'), NotEqual_NameName(Controller.GetStateName(), 'BeingUncuffed')))
		{
			Reason = 'ReactingToNonlethal';
			NewControllerState = 'PlayerWalking';
			NewPawnState = 'None';
			if(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
			{
				SwatGameReplicationInfo(Level.GetGameReplicationInfo()).NotifyClientsToInterruptAndGotoState(self, Reason, NewControllerState, NewPawnState);
			}
			InterruptState(Reason);
			Controller.InterruptState(Reason);
			GotoState(NewPawnState);
			Controller.GotoState(NewControllerState);
		}
	}
	LastPepperedTime = Level.TimeSeconds;
	LastPepperedDuration = PlayerDuration;
	SetIsPepperSprayed(true);
	RefreshCameraEffects(self);
	ChangeAnimation();
	UpdateNonLethalEffectEvents();
	if(NotEqual_ObjectObject(Controller, Level.GetLocalPlayerController()))
	{
		ClientDoPepperSprayedReaction(PlayerDuration);
	}
	return;
}

simulated function ClientDoPepperSprayedReaction(float PlayerDuration)
{
	if(AndAnd_BoolBool(EqualEqual_IntInt(int(Level.NetMode), int(NM_Client)), EqualEqual_ObjectObject(Controller, Level.GetLocalPlayerController())))
	{
		if(Class'Engine.Pawn'.static.checkDead(self))
		{
			return;
		}
		LastPepperedTime = Level.TimeSeconds;
		LastPepperedDuration = PlayerDuration;
		SetIsPepperSprayed(true);
		RefreshCameraEffects(self);
		ChangeAnimation();
		UpdateNonLethalEffectEvents();
	}
	return;
}

function ReactToBeingTased(Actor Taser, float PlayerDuration, float AIDuration)
{
	local name Reason, NewControllerState, NewPawnState;

	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Client)))
	{
		return;
	}
	if(Class'Engine.Pawn'.static.checkDead(self))
	{
		return;
	}
	PerlinNoiseAxisA.Reinitialize();
	PerlinNoiseAxisB.Reinitialize();
	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)))
	{
		TasedTimer.StartTimer(PlayerDuration, false, true);
		if(AndAnd_BoolBool(NotEqual_NameName(Controller.GetStateName(), 'BeingCuffed'), NotEqual_NameName(Controller.GetStateName(), 'BeingUncuffed')))
		{
			Reason = 'ReactingToNonlethal';
			NewControllerState = 'PlayerWalking';
			NewPawnState = 'None';
			if(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
			{
				SwatGameReplicationInfo(Level.GetGameReplicationInfo()).NotifyClientsToInterruptAndGotoState(self, Reason, NewControllerState, NewPawnState);
			}
			InterruptState(Reason);
			Controller.InterruptState(Reason);
			GotoState(NewPawnState);
			Controller.GotoState(NewControllerState);
		}
	}
	LastTasedTime = Level.TimeSeconds;
	LastTasedDuration = PlayerDuration;
	SetIsTased(true);
	SetForceCrouchState(true);
	RefreshCameraEffects(self);
	ChangeAnimation();
	UpdateNonLethalEffectEvents();
	if(NotEqual_ObjectObject(Controller, Level.GetLocalPlayerController()))
	{
		ClientDoTasedReaction(PlayerDuration);
	}
	return;
}

simulated function ClientDoTasedReaction(float PlayerDuration)
{
	if(AndAnd_BoolBool(EqualEqual_IntInt(int(Level.NetMode), int(NM_Client)), EqualEqual_ObjectObject(Controller, Level.GetLocalPlayerController())))
	{
		if(Class'Engine.Pawn'.static.checkDead(self))
		{
			return;
		}
		PerlinNoiseAxisA.Reinitialize();
		PerlinNoiseAxisB.Reinitialize();
		LastTasedTime = Level.TimeSeconds;
		LastTasedDuration = PlayerDuration;
		SetIsTased(true);
		SetForceCrouchState(true);
		RefreshCameraEffects(self);
		ChangeAnimation();
		UpdateNonLethalEffectEvents();
	}
	return;
}

simulated function bool IsVulnerableToTaser()
{
	return true;
	return;
}

function ReactToC2Detonation(Actor C2Charge, float StunRadius, float AIStunDuration)
{
	return;
}

function OnFlashbangedTimerExpired()
{
	assert(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)));
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---SwatPlayer::OnFlashbangedTimerExpired()."));
	}
	SetIsFlashbanged(false);
	RefreshNonlethalCommon();
	if(NotEqual_ObjectObject(Controller, Level.GetLocalPlayerController()))
	{
		ClientOnFlashbangTimerExpired();
	}
	return;
}

simulated function ClientOnFlashbangTimerExpired()
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---SwatPlayer::ClientOnFlashbangedTimerExpired()."));
	}
	SetIsFlashbanged(false);
	RefreshNonlethalCommon();
	return;
}

function OnGassedTimerExpired()
{
	assert(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)));
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---SwatPlayer::OnGassedTimerExpired()."));
	}
	SetIsGassed(false);
	RefreshNonlethalCommon();
	if(NotEqual_ObjectObject(Controller, Level.GetLocalPlayerController()))
	{
		ClientOnGassedTimerExpired();
	}
	return;
}

simulated function ClientOnGassedTimerExpired()
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---SwatPlayer::ClientOnGassedTimerExpired()."));
	}
	SetIsGassed(false);
	RefreshNonlethalCommon();
	return;
}

function OnStungTimerExpired()
{
	assert(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)));
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---SwatPlayer::OnStungTimerExpired()."));
	}
	SetIsStung(false);
	RefreshNonlethalCommon();
	if(NotEqual_ObjectObject(Controller, Level.GetLocalPlayerController()))
	{
		ClientOnStungTimerExpired();
	}
	return;
}

simulated function ClientOnStungTimerExpired()
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---SwatPlayer::ClientOnStungTimerExpired()."));
	}
	SetIsStung(false);
	RefreshNonlethalCommon();
	return;
}

function OnPepperSprayedTimerExpired()
{
	assert(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)));
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---SwatPlayer::OnPepperSprayedTimerExpired()."));
	}
	SetIsPepperSprayed(false);
	RefreshNonlethalCommon();
	if(NotEqual_ObjectObject(Controller, Level.GetLocalPlayerController()))
	{
		ClientOnPepperSprayedTimerExpired();
	}
	return;
}

simulated function ClientOnPepperSprayedTimerExpired()
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---SwatPlayer::ClientOnPepperSprayedTimerExpired()."));
	}
	SetIsPepperSprayed(false);
	RefreshNonlethalCommon();
	return;
}

function OnTasedTimerExpired()
{
	assert(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)));
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---SwatPlayer::OnTasedTimerExpired()."));
	}
	SetIsTased(false);
	SetForceCrouchState(false);
	RefreshNonlethalCommon();
	if(NotEqual_ObjectObject(Controller, Level.GetLocalPlayerController()))
	{
		ClientOnTasedTimerExpired();
	}
	return;
}

simulated function ClientOnTasedTimerExpired()
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---SwatPlayer::ClientOnTasedTimerExpired()."));
	}
	SetIsTased(false);
	SetForceCrouchState(false);
	RefreshNonlethalCommon();
	return;
}

function RefreshNonlethalCommon()
{
	RefreshCameraEffects(self);
	ChangeAnimation();
	UpdateNonLethalEffectEvents();
	if(Not_PreBool(IsNonlethaled()))
	{
		IWasNonlethaledAndFinishedSoDoAnEquipIfINeedToDoOne();
	}
	return;
}

simulated function RefreshCameraEffects(SwatPlayer Pawn)
{
	if(NotEqual_ObjectObject(Level.GetLocalPlayerController(), none))
	{
		SwatGamePlayerController(Level.GetLocalPlayerController()).RefreshCameraEffects(Pawn);
	}
	return;
}

// Export USwatPlayer::execUpdateNonLethalEffectEvents(FFrame&, void* const)
native simulated function UpdateNonLethalEffectEvents();

// Export USwatPlayer::execUnTriggerAllNonLethalEffectEvents(FFrame&, void* const)
native simulated function UnTriggerAllNonLethalEffectEvents();

function ResetNonlethalEffects()
{
	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)))
	{
		SetIsFlashbanged(false);
		SetIsGassed(false);
		SetIsPepperSprayed(false);
		SetIsStung(false);
		SetIsTased(false);
		RefreshNonlethalCommon();
	}
	return;
}

simulated event OnbIsTasedChanged()
{
	assert(EqualEqual_IntInt(int(Level.NetMode), int(NM_Client)));
	assert(EqualEqual_ObjectObject(Controller, none));
	if(Not_PreBool(bIsTased))
	{
		SetForceCrouchState(false);
	}
	OnNonlethalEffectChanged();
	return;
}

simulated event OnNonlethalEffectChanged()
{
	assert(EqualEqual_IntInt(int(Level.NetMode), int(NM_Client)));
	assert(EqualEqual_ObjectObject(Controller, none));
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---SwatPlayer::OnNonlethalEffectChanged()."));
		MPLog(Concat_StrStr("...bIsFlashbanged   =", string(bIsFlashbanged)));
		MPLog(Concat_StrStr("...bIsGassed        =", string(bIsGassed)));
		MPLog(Concat_StrStr("...bIsPepperSprayed =", string(bIsPepperSprayed)));
		MPLog(Concat_StrStr("...bIsStung         =", string(bIsStung)));
		MPLog(Concat_StrStr("...bIsTased         =", string(bIsTased)));
	}
	super(SwatPawn).OnNonlethalEffectChanged();
	RefreshCameraEffects(self);
	UpdateNonLethalEffectEvents();
	return;
}

simulated event OnCurrentLimpChanged()
{
	ChangeAnimation();
	return;
}

simulated function OnQualifyInterrupted()
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---SwatPlayer::OnQualifyInterrupted()."));
	}
	if(NotEqual_ObjectObject(Controller, none))
	{
		SwatGamePlayerController(Controller).OnQualifyInterrupted();
	}
	EquipOtherAfterUsed = false;
	return;
}

simulated function OnQualifyCompleted()
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---SwatPlayer::OnQualifyCompleted()."));
	}
	if(NotEqual_ObjectObject(Controller, none))
	{
		SwatGamePlayerController(Controller).OnQualifyCompleted();
	}
	return;
}

simulated function SetDeployedC2Charge(DeployedC2ChargeBase Charge)
{
	AssertWithDescription(OrOr_BoolBool(EqualEqual_ObjectObject(Charge, none), EqualEqual_ObjectObject(DeployedC2Charge, none)), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] SwatPlayer::SetDeployedC2Charge() tried to set DeployedC2Charge=", string(Charge)), ", but DeployedC2Charge is already "), string(DeployedC2Charge)), "."));
	DeployedC2Charge = Charge;
	return;
}

simulated function DeployedC2ChargeBase GetDeployedC2Charge()
{
	return DeployedC2Charge;
	return;
}

simulated function bool CanBeArrestedNow()
{
	local HandheldEquipment theActiveItem, thePendingItem;

	if(checkDead(self))
	{
		return false;
	}
	theActiveItem = GetActiveItem();
	if(AndAnd_BoolBool(NotEqual_ObjectObject(theActiveItem, none), theActiveItem.IsA('IAmCuffed')))
	{
		return false;
	}
	thePendingItem = GetPendingItem();
	if(AndAnd_BoolBool(NotEqual_ObjectObject(thePendingItem, none), thePendingItem.IsA('IAmCuffed')))
	{
		return false;
	}
	return IsNonlethaled();
	return;
}

simulated function bool CanBeUnarrestedNow()
{
	assert(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)));
	if(EqualEqual_NameName(Controller.GetStateName(), 'BeingUncuffed'))
	{
		return false;
	}
	return true;
	return;
}

simulated function float GetQualifyTimeForArrest()
{
	return QualifyTimeForArrest;
	return;
}

function AuthorizedInterruptQualification()
{
	assert(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)));
	SwatGamePlayerController(Controller).AuthorizedInterruptQualification();
	return;
}

// Export USwatPlayer::execGetViewPoint(FFrame&, void* const)
native function Vector GetViewPoint();

simulated function Vector GetThirdPersonEyesLocation()
{
	local float EyeHeightCompensation;
	local Vector ThirdPersonEyesLocation;

	ThirdPersonEyesLocation = GetViewPoint();
	if(bIsCrouched)
	{
		EyeHeightCompensation = Subtract_FloatFloat(PawnModelApparentCrouchEyeHeight, default.CrouchEyeHeight);
	}
	else
	{
		EyeHeightCompensation = Subtract_FloatFloat(PawnModelApparentBaseEyeHeight, default.BaseEyeHeight);
	}
	AddEqual_FloatFloat(ThirdPersonEyesLocation.Z, EyeHeightCompensation);
	return ThirdPersonEyesLocation;
	return;
}

simulated event Rotator ViewRotationOffset()
{
	return Add_RotatorRotator(GetStungRotationOffset(), GetLeanRotationOffset());
	return;
}

simulated function Vector ViewLocationOffset(Rotator CameraRotation)
{
	return GetTasedViewLocationOffset(CameraRotation);
	return;
}

simulated function Vector CalcDrawOffset()
{
	return Add_VectorVector(super(Pawn).CalcDrawOffset(), GetLeanPositionOffset());
	return;
}

simulated function Rotator GetViewRotation()
{
	local Rotator baseRotation;

	if(NotEqual_ObjectObject(Controller, none))
	{
		baseRotation = Controller.GetViewRotation();
	}
	else
	{
		baseRotation = GetAimRotation();
	}
	return Add_RotatorRotator(Add_RotatorRotator(baseRotation, GetStungRotationOffset()), GetLeanRotationOffset());
	return;
}

simulated event ApplyRotationOffset(out Vector Acceleration)
{
	super(Pawn).ApplyRotationOffset(Acceleration);
	ApplyStungRotationOffset(Acceleration);
	ApplyOneFrameNudgeRotationOffset(Acceleration);
	return;
}

function Rotator GetStungRotationOffset()
{
	local float Now, Alpha, Ordinate, RollAndYawAbcissa;
	local Rotator Result;

	if(bDeleteMe)
	{
		Log(Concat_StrStr("ERROR: attempt to GetStungRotationOffset() on destroyed actor ", string(Name)));
		return Result;
	}
	if(IsStung())
	{
		Now = Level.TimeSeconds;
		Alpha = Divide_FloatFloat(Subtract_FloatFloat(Now, LastStungTime), LastStungDuration);
		Alpha = FClamp(Alpha, 0.0000000, 1.0000000);
		Ordinate = Multiply_FloatFloat(Alpha, StingEffectFrequency);
		Result.Pitch = int(Multiply_FloatFloat(ScaleStingEffectAmplitude(float(StingViewEffectAmplitude.Pitch), Alpha), PerlinNoiseAxisA.Noise1(Ordinate)));
		RollAndYawAbcissa = PerlinNoiseAxisB.Noise1(Ordinate);
		Result.Roll = int(Multiply_FloatFloat(RollAndYawAbcissa, ScaleStingEffectAmplitude(float(StingViewEffectAmplitude.Roll), Alpha)));
		Result.Yaw = int(Multiply_FloatFloat(RollAndYawAbcissa, ScaleStingEffectAmplitude(float(StingViewEffectAmplitude.Yaw), Alpha)));
	}
	return Result;
	return;
}

simulated event ApplyStungRotationOffset(out Vector Acceleration)
{
	local Rotator StungRotation;

	if(IsStung())
	{
		StungRotation = GetStungRotationOffset();
		StungRotation.Pitch = 0;
		Acceleration = LessLess_VectorRotator(Acceleration, Multiply_RotatorFloat(StungRotation, StingInputEffectMagnitude));
	}
	return;
}

function Vector GetTasedViewLocationOffset(Rotator CameraRotation)
{
	local float Now, Alpha;
	local Vector LocalXAxis, Result;

	if(bDeleteMe)
	{
		Log(Concat_StrStr("ERROR: attempt to GetTasedViewLocationOffset() on destroyed actor ", string(Name)));
		return Result;
	}
	if(IsTased())
	{
		Now = Level.TimeSeconds;
		Alpha = Divide_FloatFloat(Subtract_FloatFloat(Now, LastTasedTime), LastTasedDuration);
		Alpha = FClamp(Alpha, 0.0000000, 1.0000000);
		LocalXAxis = GreaterGreater_VectorRotator(vect(0.0000000, 1.0000000, 0.0000000), CameraRotation);
		Result = Multiply_VectorFloat(Multiply_VectorFloat(LocalXAxis, TasedViewEffectAmplitude), PerlinNoiseAxisA.Noise1(Multiply_FloatFloat(Alpha, TasedViewEffectFrequency)));
		Result.Z = Multiply_FloatFloat(TasedViewEffectAmplitude, PerlinNoiseAxisB.Noise1(Multiply_FloatFloat(Alpha, TasedViewEffectFrequency)));
	}
	return Result;
	return;
}

function float ScaleStingEffectAmplitude(float Amplitude, float DurationAlpha)
{
	local float NormalTime, DropOffAlpha;

	NormalTime = Subtract_FloatFloat(1.0000000, StingEffectDropOffTimePercent);
	if(Less_FloatFloat(DurationAlpha, NormalTime))
	{
		return Amplitude;
	}
	DropOffAlpha = Divide_FloatFloat(Subtract_FloatFloat(DurationAlpha, NormalTime), StingEffectDropOffTimePercent);
	return Multiply_FloatFloat(Amplitude, Subtract_FloatFloat(1.0000000, DropOffAlpha));
	return;
}

// Export USwatPlayer::execGetLeanPositionOffset(FFrame&, void* const)
native function Vector GetLeanPositionOffset();

// Export USwatPlayer::execGetLeanRotationOffset(FFrame&, void* const)
native function Rotator GetLeanRotationOffset();

simulated function string GetHumanReadableName()
{
	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
	{
		return YouString;
	}
	return super(Pawn).GetHumanReadableName();
	return;
}

simulated function bool IsTheVIP()
{
	return false;
	return;
}

simulated function bool IsLowerBodyInjured()
{
	return Greater_FloatFloat(CurrentLimp, LimpThreshold);
	return;
}

simulated function OnSkeletalRegionHit(Actor.ESkeletalRegion RegionHit, Vector HitLocation, Vector HitNormal, int Damage, Class<DamageType> DamageType, Actor Instigator)
{
	local SkeletalRegionInformation RegionInfo;

	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)))
	{
		if(NotEqual_ObjectObject(Controller, none))
		{
			SwatGamePlayerController(Controller).ClientSkeletalRegionHit(RegionHit, Damage);
		}
		if(Greater_IntInt(Damage, 0))
		{
			RegionInfo = SkeletalRegionInformation[int(RegionHit)];
			AddEqual_FloatFloat(CurrentLimp, Multiply_FloatFloat(StandardLimpPenalty, RandRange(RegionInfo.LimpModifier.Min, RegionInfo.LimpModifier.Max)));
			ChangeAnimation();
		}
	}
	return;
}

function HandheldEquipment FindItemForPickupToReplace(HandheldEquipment PickedUp)
{
	return LoadOut.FindItemToReplace(PickedUp);
	return;
}

function OnPickedUp(HandheldEquipment PickedUp)
{
	LoadOut.OnPickedUp(PickedUp);
	return;
}

event EndCrouch(float HeightAdjust)
{
	super(Pawn).EndCrouch(HeightAdjust);
	if(AndAnd_BoolBool(EqualEqual_ObjectObject(Controller, Level.GetLocalPlayerController()), SwatGamePlayerController(Controller).HasHUDPage()))
	{
		SwatGamePlayerController(Controller).GetHUDPage().SetCrouched(false);
	}
	return;
}

event StartCrouch(float HeightAdjust)
{
	super(Pawn).StartCrouch(HeightAdjust);
	if(AndAnd_BoolBool(EqualEqual_ObjectObject(Controller, Level.GetLocalPlayerController()), SwatGamePlayerController(Controller).HasHUDPage()))
	{
		SwatGamePlayerController(Controller).GetHUDPage().SetCrouched(true);
	}
	return;
}

simulated function SetForceCrouchState(bool inbForceCrouch)
{
	if(EqualEqual_BoolBool(inbForceCrouch, false))
	{
		if(OrOr_BoolBool(OrOr_BoolBool(AndAnd_BoolBool(IsTheVIP(), IsArrested()), IsTased()), bForceCrouchWhileOptiwanding))
		{
			inbForceCrouch = true;
		}
	}
	super(Pawn).SetForceCrouchState(inbForceCrouch);
	return;
}

simulated function SetForceCrouchWhileOptiwanding(bool B)
{
	bForceCrouchWhileOptiwanding = B;
	SetForceCrouchState(B);
	if(bForceCrouchWhileOptiwanding)
	{
		ForceCrouchThisTick();
	}
	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Client)))
	{
		ServerSetForceCrouchWhileOptiwanding(B);
	}
	return;
}

function ServerSetForceCrouchWhileOptiwanding(bool B)
{
	SetForceCrouchWhileOptiwanding(B);
	return;
}

simulated function bool IsUsingOptiwand()
{
	return bIsUsingOptiwand;
	return;
}

simulated function SetIsUsingOptiwand(bool B)
{
	bIsUsingOptiwand = B;
	ChangeAnimation();
	ServerSetIsUsingOptiwand(B);
	return;
}

function ServerSetIsUsingOptiwand(bool B)
{
	bIsUsingOptiwand = B;
	ChangeAnimation();
	return;
}

simulated function SetOneFrameNudgeDirection(Vector direction)
{
	OneFrameNudgeDirection = direction;
	return;
}

simulated event ApplyOneFrameNudgeRotationOffset(out Vector Acceleration)
{
	local Vector NormalizedOneFrameNudgeDirection;

	if(Not_PreBool(IsNearlyZero(OneFrameNudgeDirection)))
	{
		NormalizedOneFrameNudgeDirection = Normal(OneFrameNudgeDirection);
		Acceleration = Normal(Add_VectorVector(Acceleration, Multiply_VectorFloat(NormalizedOneFrameNudgeDirection, 2.0000000)));
		OneFrameNudgeDirection.X = 0.0000000;
		OneFrameNudgeDirection.Y = 0.0000000;
		OneFrameNudgeDirection.Z = 0.0000000;
	}
	return;
}

function OnReportableReportedToTOC(IAmReportableCharacter ReportableCharacter, Pawn Reporter)
{
	local string PlayerTag;

	if(NotEqual_ObjectObject(Reporter, self))
	{
		return;
	}
	CurrentReportableCharacter = ReportableCharacter;
	assert(Reporter.IsA('SwatPlayer'));
	PlayerTag = string(SwatPlayer(Reporter).GetPlayerTag());
	BroadcastReportableReportedToTOC(ReportableCharacter, ReportableCharacter.UniqueID(), PlayerTag, Reporter.GetHumanReadableName());
	return;
}

function BroadcastReportableReportedToTOC(IAmReportableCharacter ReportableCharacter, string inUniqueID, string PlayerTag, string PlayerName)
{
	local Controller i;
	local SwatGamePlayerController Current;

	i = Level.ControllerList;
	J0x14:

	if(NotEqual_ObjectObject(i, none))
	{
		Current = SwatGamePlayerController(i);
		if(NotEqual_ObjectObject(Current, none))
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self), "::BroadcastReportableReportedToTOC( "), string(ReportableCharacter)), ", "), inUniqueID), " ), current = "), string(Current)), ", PlayerTag = "), PlayerTag), ", PlayerName = "), PlayerName));
			Current.ClientReportableReportedToTOC(ReportableCharacter, inUniqueID, PlayerTag, PlayerName);
		}
		i = i.nextController;
		// [Loop Continue]
		goto J0x14;
	}
	return;
}

simulated function OnClientReportableReportedToTOC(IAmReportableCharacter ReportableCharacter, string inUniqueID, string PlayerTag, string PlayerName)
{
	local name EffectEventName;

	CurrentReportableCharacter = ReportableCharacter;
	if(EqualEqual_ObjectObject(CurrentReportableCharacter, none))
	{
		CurrentReportableCharacter = IAmReportableCharacter(FindByUniqueID(Class'Engine.Pawn', inUniqueID));
	}
	Log(Concat_StrStr(Concat_StrStr(string(self), "::OnClientReportableReportedToTOC() ... CurrentReportableCharacter = "), string(CurrentReportableCharacter)));
	EffectEventName = CurrentReportableCharacter.GetEffectEventForReportingToTOC();
	if(NotEqual_NameName(EffectEventName, 'None'))
	{
		SoundEffectsSubsystem(EffectsSystem(Level.EffectsSystem).GetSubsystem('SoundEffectsSubsystem')).OverrideCaptionSpeakerNameForNextEffectEvent = PlayerName;
		TriggerEffectEvent(EffectEventName, Actor(CurrentReportableCharacter),,,,,, self, string(PlayerTag));
	}
	return;
}

simulated event TriggerNonLethaledEffectEvent(name EffectEventName)
{
	if(NotEqual_NameName(EffectEventName, 'None'))
	{
		TriggerEffectEvent(EffectEventName,,,,,,,, GetPlayerTag());
	}
	return;
}

simulated event UnTriggerNonLethaledEffectEvent(name EffectEventName)
{
	if(NotEqual_NameName(EffectEventName, 'None'))
	{
		UnTriggerEffectEvent(EffectEventName, GetPlayerTag());
	}
	return;
}

simulated function name GetPlayerTag()
{
	if(EqualEqual_ObjectObject(NetPlayer(self), none))
	{
		return 'None';
	}
	if(NetPlayer(self).IsTheVIP())
	{
		return 'VIP';
	}
	return SwatRepo(Level.GetRepo()).GuiConfig.GetTagForVoiceType(NetPlayer(self).VoiceType);
	return;
}

simulated function OnEffectStarted(Actor inStartedEffect)
{
	return;
}

simulated function OnEffectStopped(Actor inStoppedEffect, bool Completed)
{
	local name EffectEventName;

	if(Completed)
	{
		EffectEventName = CurrentReportableCharacter.GetEffectEventForReportResponseFromTOC();
		if(NotEqual_NameName(EffectEventName, 'None'))
		{
			Log(Concat_StrStr("TOC is responding with ", string(EffectEventName)));
			TriggerEffectEvent(EffectEventName, Actor(CurrentReportableCharacter),,,,,,, 'TOC');
		}
	}
	CurrentReportableCharacter = none;
	return;
}

simulated function OnEffectInitialized(Actor inInitializedEffect)
{
	return;
}

simulated function bool CanBeUsedNow()
{
	return AndAnd_BoolBool(AndAnd_BoolBool(Level.IsPlayingCOOP, Not_PreBool(bHasBeenReportedToTOC)), Not_PreBool(Class.static.checkConscious(self)));
	return;
}

simulated function OnUsed(Pawn Other)
{
	assert(Not_PreBool(bHasBeenReportedToTOC));
	SwatGameInfo(Level.Game).GameEvents.ReportableReportedToTOC.Triggered(self, Other);
	return;
}

simulated function PostUsed()
{
	bHasBeenReportedToTOC = true;
	return;
}

final simulated function name GetEffectEventForReportingToTOC()
{
	return 'ReportedOfficerDownToTOC';
	return;
}

final simulated function name GetEffectEventForReportResponseFromTOC()
{
	return 'RepliedOfficerDown';
	return;
}

simulated function ShowCommandArrow(float inLifeSpan, Actor inSource, Actor inTarget, optional Vector inSourceLocation, optional Vector inTargetLocation, optional bool inPointAtSource)
{
	CommandArrow.ShowArrow(inLifeSpan, inSource, inTarget, inSourceLocation, inTargetLocation, inPointAtSource);
	return;
}

simulated function bool ReadyToTriggerEffectEvents()
{
	return HasEquippedFirstItemYet;
	return;
}

simulated state ThrowingPrep
{
	simulated function bool CanThrowPrep()
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog(Concat_StrStr(string(self), "---CanThrowPrep() of state 'ThrowingPrep'."));
		}
		return false;
		return;
	}

	simulated function bool RequestEquipShouldBeAllowed()
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog(Concat_StrStr(string(self), "---RequestEquipShouldBeAllowed() of state 'ThrowingPrep'."));
		}
		return false;
		return;
	}

	simulated function BeginState()
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog(Concat_StrStr(string(self), "---BeginState() of state 'ThrowingPrep'."));
		}
		ThrowHeldTime = 0.0000000;
		DoneThrowing = false;
		AssertWithDescription(Greater_FloatFloat(ThrowSpeedTimeFactor, 0.0000000), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] ThrowSpeedTimeFactor is not specified for the class ", string(Class.Name)), ".  Please set it in SwatGame.ini, section [SwatGame."), string(Class.Name)), "]."));
		AssertWithDescription(Greater_FloatFloat(ThrowSpeedRange.Min, 0.0000000), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] ThrowSpeedRange.Min is not specified for the class ", string(Class.Name)), ".  Please set it in SwatGame.ini, section [SwatGame."), string(Class.Name)), "]."));
		return;
	}

	simulated function EndState()
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog(Concat_StrStr(string(self), "---EndState() of state 'ThrowingPrep'."));
		}
		return;
	}

	latent simulated function DoThrowingPrep()
	{
		local ThrownWeapon Grenade;
		local HandheldEquipmentModel GrenadeFirstPersonModel;
		local Hands Hands;
		local int PawnThrowAnimationChannel;

		if(Level.GetEngine().EnableDevTools)
		{
			MPLog(Concat_StrStr(string(self), "---SwatPlayer::DoThrowingPrep() in state 'ThrowingPrep'."));
		}
		Hands = GetHands();
		if(NotEqual_ObjectObject(Hands, none))
		{
			Hands.PlayAnim(Hands.GetPreThrowAnimation(),, Hands.PreThrowTweenTime);
		}
		PawnThrowAnimationChannel = AnimPlaySpecial(GetPreThrowAnimation(), GetPawnThrowTweenTime(), GetPawnThrowRootBone());
		Grenade = ThrownWeapon(GetActiveItem());
		AssertWithDescription(NotEqual_ObjectObject(Grenade, none), "[tcohen] SwatPlayer was called to PlayGrenadePreThrow(), but its Pawn's ActiveItem isn't a ThrownWeapon.");
		GrenadeFirstPersonModel = Grenade.GetFirstPersonModel();
		if(NotEqual_ObjectObject(GrenadeFirstPersonModel, none))
		{
			GrenadeFirstPersonModel.PlayAnim(Grenade.FirstPersonPreThrowAnimation);
		}
		if(NotEqual_ObjectObject(Hands, none))
		{
			Hands.FinishAnim();
		}
		FinishAnim(PawnThrowAnimationChannel);
		if(NotEqual_ObjectObject(GrenadeFirstPersonModel, none))
		{
			GrenadeFirstPersonModel.FinishAnim();
		}
		AnimSwapInSet(70);
		return;
	}

	simulated function Tick(float dTime)
	{
		global.Tick(dTime);
		if(Not_PreBool(DoneThrowing))
		{
			if(EqualEqual_ObjectObject(Controller, Level.GetLocalPlayerController()))
			{
				if(EqualEqual_IntInt(int(Controller.bFire), 0))
				{
					DoneThrowing = true;
					SwatGamePlayerController(Controller).ServerEndThrow(ThrowHeldTime);
				}
				else
				{
					AddEqual_FloatFloat(ThrowHeldTime, dTime);
				}
			}
		}
		return;
	}

	simulated function EndThrow(float ThrowHeldTimeFromNetwork)
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog(Concat_StrStr(string(self), "---EndThrow() of state 'ThrowingPrep'."));
		}
		DoneThrowing = true;
		ThrowHeldTime = ThrowHeldTimeFromNetwork;
		return;
	}
Begin:

	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), " Begin: of state 'ThrowingPrep'."));
	}
	DoThrowingPrep();
	GotoState('Throwing');
	stop;
}

simulated state Throwing
{
	simulated function BeginState()
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog(Concat_StrStr(string(self), "---BeginState() of state 'Throwing'."));
		}
		return;
	}

	simulated function EndState()
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog(Concat_StrStr(string(self), "---EndState() of state 'Throwing'."));
		}
		return;
	}

	simulated function bool CanThrowPrep()
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog(Concat_StrStr(string(self), "---CanThrowPrep() of state 'Throwing'."));
		}
		return false;
		return;
	}

	simulated function bool RequestEquipShouldBeAllowed()
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog(Concat_StrStr(string(self), "---RequestEquipShouldBeAllowed() of state 'Throwing'."));
		}
		return false;
		return;
	}

	simulated function Tick(float dTime)
	{
		global.Tick(dTime);
		if(Not_PreBool(DoneThrowing))
		{
			if(EqualEqual_ObjectObject(Controller, Level.GetLocalPlayerController()))
			{
				if(EqualEqual_IntInt(int(Controller.bFire), 0))
				{
					DoneThrowing = true;
					SwatGamePlayerController(Controller).ServerEndThrow(ThrowHeldTime);
				}
				else
				{
					AddEqual_FloatFloat(ThrowHeldTime, dTime);
				}
			}
		}
		else
		{
			if(Level.GetEngine().EnableDevTools)
			{
				MPLog(Concat_StrStr(string(self), " calling GotoState('ThrowingFinish') in Tick() of state 'Throwing'."));
			}
			GotoState('ThrowingFinish');
		}
		return;
	}

	simulated function EndThrow(float ThrowHeldTimeFromNetwork)
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog(Concat_StrStr(string(self), "---EndThrow() of state 'Throwing'."));
		}
		DoneThrowing = true;
		ThrowHeldTime = ThrowHeldTimeFromNetwork;
		return;
	}

	simulated function InterruptState(name Reason)
	{
		local HandheldEquipment ActiveItem;
		local ThrownWeapon ThrownWeapon;

		if(Level.GetEngine().EnableDevTools)
		{
			MPLog(Concat_StrStr(string(self), "---SwatPlayer::InterruptState() in state 'Throwing'."));
		}
		if(OrOr_BoolBool(NotEqual_NameName(Reason, 'BeingCuffed'), NotEqual_NameName(Reason, 'ReactingToNonlethal')))
		{
			ActiveItem = GetActiveItem();
			AssertWithDescription(NotEqual_ObjectObject(ActiveItem, none), "[tcohen] SwatPlayer@Throwing::InterruptState(), ActiveItem is None.");
			ThrownWeapon = ThrownWeapon(ActiveItem);
			AssertWithDescription(NotEqual_ObjectObject(ThrownWeapon, none), Concat_StrStr(Concat_StrStr("[tcohen] SwatPlayer@Throwing::InterruptState(), ActiveItem (", string(ActiveItem)), ") is not a ThrownWeapon."));
			ThrownWeapon.SetThrowSpeed(0.0000000);
			ThrownWeapon.OnUseKeyFrame(true);
			ThrownWeapon.AIInterrupt();
		}
		return;
	}
	stop;
}

simulated state ThrowingFinish
{
	simulated function bool CanThrowPrep()
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog(Concat_StrStr(string(self), "---CanThrowPrep() of state 'ThrowingFinish'."));
		}
		return false;
		return;
	}

	simulated function bool RequestEquipShouldBeAllowed()
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog(Concat_StrStr(string(self), "---RequestEquipShouldBeAllowed() of state 'ThrowingFinish'."));
		}
		return false;
		return;
	}

	simulated function BeginState()
	{
		local HandheldEquipment ActiveItem;
		local ThrownWeapon ThrownWeapon;
		local float ThrowSpeed;

		if(Level.GetEngine().EnableDevTools)
		{
			MPLog(Concat_StrStr(string(self), "---BeginState() of state 'ThrowingFinish'."));
		}
		ActiveItem = GetActiveItem();
		AssertWithDescription(NotEqual_ObjectObject(ActiveItem, none), "[tcohen] SwatPlayer in state Throwing noticed that the throw button was released.  But the ActiveItem is None.");
		ThrownWeapon = ThrownWeapon(ActiveItem);
		AssertWithDescription(NotEqual_ObjectObject(ThrownWeapon, none), Concat_StrStr(Concat_StrStr("[tcohen] SwatPlayer in state Throwing noticed that the throw button was released.  But the ActiveItem (", string(ActiveItem)), ") is not a ThrownWeapon."));
		ThrowSpeed = Add_FloatFloat(Multiply_FloatFloat(ThrowSpeedTimeFactor, ThrowHeldTime), ThrowSpeedRange.Min);
		ThrownWeapon.SetThrowSpeed(FClamp(ThrowSpeed, ThrowSpeedRange.Min, ThrowSpeedRange.Max));
		return;
	}

	simulated function EndState()
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog(Concat_StrStr(string(self), "---EndState() of state 'ThrowingFinish'."));
		}
		if(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)))
		{
			assert(OrOr_BoolBool(DoneThrowing, Class'Engine.Pawn'.static.checkDead(self)));
		}
		return;
	}

	simulated function EndThrow(float ThrowHeldTimeFromNetwork)
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog(Concat_StrStr(string(self), "---SwatPlayer::EndThrow() in state 'ThrowingFinish'."));
			MPLog("... *** This shouldn't happen. It's extremely unlikely unless network lag is horrible. ***");
			MPLog("... The SwatPlayer was told to end a throw while a previous throw was still in the process of ending.");
		}
		return;
	}

	simulated function InterruptState(name Reason)
	{
		local HandheldEquipment ActiveItem;
		local ThrownWeapon ThrownWeapon;

		if(Level.GetEngine().EnableDevTools)
		{
			MPLog(Concat_StrStr(string(self), "---SwatPlayer::InterruptState() in state 'ThrowingFinish'."));
		}
		DoneThrowing = true;
		ActiveItem = GetActiveItem();
		if(EqualEqual_ObjectObject(ActiveItem, none))
		{
			return;
		}
		AssertWithDescription(NotEqual_ObjectObject(ActiveItem, none), "[tcohen] SwatPlayer@ThrowingFinish::InterruptState(), ActiveItem is None.");
		ThrownWeapon = ThrownWeapon(ActiveItem);
		AssertWithDescription(NotEqual_ObjectObject(ThrownWeapon, none), Concat_StrStr(Concat_StrStr("[tcohen] SwatPlayer@ThrowingFinish::InterruptState(), ActiveItem (", string(ActiveItem)), ") is not a ThrownWeapon."));
		if(ThrownWeapon.IsAvailable())
		{
			if(Level.GetEngine().EnableDevTools)
			{
				MPLog("...attempting to drop weapon.");
			}
			ThrownWeapon.SetThrowSpeed(0.0000000);
			ThrownWeapon.OnUseKeyFrame(true);
			ThrownWeapon.AIInterrupt();
		}
		return;
	}
Begin:

	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), " Begin: of state 'ThrowingFinish'."));
		MPLog(Concat_StrStr("...ActiveItem=", string(GetActiveItem())));
		MPLog(Concat_StrStr("...ActiveItem's state=", string(GetActiveItem().GetStateName())));
	}
	GetActiveItem().LatentUse();
	DoneThrowing = true;
	GotoState('None');
	stop;
}

defaultproperties
{
	SuspectHandsMaterial=Shader'SWAT1stPersonTex.HandGang_aShader'
	VIPHandsMaterial=Shader'SWAT1stPersonTex.HandVIPshader'
	LimpThreshold=10.0000000
	StandardLimpPenalty=3.0000000
	YouString="You"
	AimBlendChangeTime=0.0500000
	InertialAimAcceleration=80.0000000
	InertialAimDeceleration=-20.0000000
	InertialAimMaxVelocity=40.0000000
	LeanVerticalDistance=-16.0000000
	LeanRollDegrees=8.0000000
	LeanBezierPt1X=0.4000000
	LeanBezierPt2X=0.6000000
	LeanBezierPt2Y=1.0000000
	ReachedDestinationThreshold=48.0000000
}