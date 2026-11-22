class PlayerController extends Controller
	native
	nativereplication
	config(User)
	notplaceable
	hidecategories(Karma);

var const Player Player;
var globalconfig bool bLookUpStairs;
var globalconfig bool bSnapToLevel;
var globalconfig bool bAlwaysMouseLook;
var globalconfig bool bKeyboardLook;
var bool bCenterView;
var bool bBehindView;
var bool bFrozen;
var bool bPressedJump;
var bool bDoubleJump;
var bool bUpdatePosition;
var bool bIsTyping;
var bool bFixedCamera;
var bool bJumpStatus;
var bool bUpdating;
var globalconfig bool bAlwaysLevel;
var bool bSetTurnRot;
var bool bCheatFlying;
var bool bFreeCamera;
var bool bZeroRoll;
var bool bCameraPositionLocked;
var bool bViewBot;
var bool UseFixedVisibility;
var bool bBlockCloseCamera;
var bool bValidBehindCamera;
var bool bForcePrecache;
var bool bClientDemo;
var const bool bAllActorsRelevant;
var bool bShortConnectTimeOut;
var bool bPendingDestroy;
var globalconfig bool bNoVoiceMessages;
var globalconfig bool bNoVoiceTaunts;
var globalconfig bool bNoAutoTaunts;
var globalconfig bool bAutoTaunt;
var globalconfig bool bNoMatureLanguage;
var globalconfig bool bDynamicNetSpeed;
var globalconfig byte AnnouncerLevel;
var globalconfig byte AnnouncerVolume;
var globalconfig float AimingHelp;
var globalconfig float MaxResponseTime;
var float WaitDelay;
var input float aBaseX;
var input float aBaseY;
var input float aBaseZ;
var input float aMouseX;
var input float aMouseY;
var input float aForward;
var input float aTurn;
var input float aStrafe;
var input float aUp;
var input float aLookUp;
var input byte bStrafe;
var input byte bSnapLevel;
var input byte bLook;
var input byte bFreeLook;
var input byte bTurn180;
var input byte bTurnToNearest;
var input byte bXAxis;
var input byte bYAxis;
var Actor.EDoubleClickDir DoubleClickDir;
var int ShowFlags;
var int ExShowFlags;
var int Misc1;
var int Misc2;
var int RendMap;
var float OrthoZoom;
var const Actor ViewTarget;
var const Controller RealViewTarget;
var PlayerController DemoViewer;
var float CameraDist;
var Vector OldCameraLoc;
var Rotator OldCameraRot;
var transient array<CameraEffect> CameraEffects;
var float BaseFOV;
var float ZoomedFOV;
var private config float ZoomTime;
var private config float ZoomBezierPt1X;
var private config float ZoomBezierPt1Y;
var private config float ZoomBezierPt2X;
var private config float ZoomBezierPt2Y;
var float ZoomAlpha;
var bool WantsZoom;
var Vector FixedLocation;
var Rotator FixedRotation;
var Matrix RenderWorldToCamera;
var Vector FlashScale;
var Vector FlashFog;
var float ConstantGlowScale;
var Vector ConstantGlowFog;
var bool bManualFogUpdate;
var Color LastDistanceFogColor;
var float LastDistanceFogStart;
var float LastDistanceFogEnd;
var float CurrentDistanceFogEnd;
var float TimeSinceLastFogChange;
var int LastZone;
var Vector TargetViewLocation;
var Rotator TargetViewRotation;
var Rotator BlendedTargetViewRotation;
var HUD myHUD;
var float LastPlaySound;
var float LastPlaySpeech;
var string Song;
var Actor.EMusicTransition Transition;
var SavedMove SavedMoves;
var SavedMove FreeMoves;
var SavedMove PendingMove;
var float CurrentTimeStamp;
var float LastUpdateTime;
var float ServerTimeStamp;
var float TimeMargin;
var float ClientUpdateTime;
var globalconfig float MaxTimeMargin;
var string ProgressMessage[4];
var Color ProgressColor[4];
var float ProgressTimeOut;
var localized string QuickSaveString;
var localized string NoPauseMessage;
var localized string OwnCamera;
var GameReplicationInfo GameReplicationInfo;
var globalconfig string StatsUsername;
var globalconfig string StatsPassword;
var Class<LocalMessage> LocalMessageClass;
var float MaxShakeRoll;
var Vector MaxShakeOffset;
var float ShakeRollRate;
var Vector ShakeOffsetRate;
var Vector ShakeOffset;
var float ShakeRollTime;
var Vector ShakeOffsetTime;
var Pawn TurnTarget;
var config int EnemyTurnSpeed;
var int GroundPitch;
var Rotator TurnRot180;
var Vector OldFloor;
var private transient CheatManager CheatManager;
var Class<CheatManager> CheatClass;
var private transient PlayerInput PlayerInput;
var config Class<PlayerInput> InputClass;
var const Vector FailedPathStart;
var int DemoViewPitch;
var int DemoViewYaw;
var bool bAlreadyNotifiedLevelOfGameStarted;
var Security PlayerSecurity;
var float ForcePrecacheTime;
var float LastPingUpdate;
var float ExactPing;
var float OldPing;
var float SpectateSpeed;
var globalconfig float DynamicPingThreshold;
var float NextSpeedChange;
var int ClientCap;
var(ForceFeedback) globalconfig bool bEnableWeaponForceFeedback;
var(ForceFeedback) globalconfig bool bEnableDamageForceFeedback;
var(ForceFeedback) globalconfig bool bEnableGUIForceFeedback;
var(ForceFeedback) bool bForceFeedbackSupported;
var float FOVBias;
var float LastDeltaTime;
var IControllableViewport ActiveViewport;
var IControllableViewport ServerItemViewport;
var IControllableViewport ServerOfficerViewport;
var bool bIsObserving;
var bool bIgnoreNextRunRelease;
var bool bIgnoreNextCrouchRelease;
var private config float PostFullscreenManualFlushDelay;
var private Timer ManualFlushTimer;

replication
{
	// Pos:0x0B3
	unreliable if(AndAnd_BoolBool(EqualEqual_IntInt(int(Role), int(ROLE_Authority)), Not_PreBool(bDemoRecording)))
		ClientPlaySound, PlayAnnouncement;

	// Pos:0x0E7
	unreliable if(EqualEqual_IntInt(int(Role), int(ROLE_Authority)))
		ClientAdjustPosition, ClientFlash,
		ClientShake, LongClientAdjustPosition,
		ShortClientAdjustPosition, VeryShortClientAdjustPosition;

	// Pos:0x0F4
	unreliable if(AndAnd_BoolBool(OrOr_BoolBool(Not_PreBool(bDemoRecording), AndAnd_BoolBool(bClientDemoRecording, bClientDemoNetFunc)), EqualEqual_IntInt(int(Role), int(ROLE_Authority))))
		ClientHearSound;

	// Pos:0x149
	unreliable if(Less_IntInt(int(Role), int(ROLE_Authority)))
		Say, ServerDrive,
		ServerMove, ServerUpdatePing,
		ServerUse, ServerViewNextPlayer,
		ServerViewSelf, ShortServerMove,
		TeamSay;

	// Pos:0x000
	reliable if(AndAnd_BoolBool(AndAnd_BoolBool(bNetDirty, bNetOwner), EqualEqual_IntInt(int(Role), int(ROLE_Authority))))
		GameReplicationInfo;

	// Pos:0x023
	reliable if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(bNetOwner, EqualEqual_IntInt(int(Role), int(ROLE_Authority))), NotEqual_ObjectObject(ViewTarget, Pawn)), NotEqual_ObjectObject(Pawn(ViewTarget), none)))
		TargetViewLocation, TargetViewRotation;

	// Pos:0x05E
	reliable if(AndAnd_BoolBool(bDemoRecording, EqualEqual_IntInt(int(Role), int(ROLE_Authority))))
		DemoViewPitch, DemoViewYaw;

	// Pos:0x076
	reliable if(EqualEqual_IntInt(int(Role), int(ROLE_Authority)))
		ClearProgressMessages, ClientAdjustGlow,
		ClientCapBandwidth, ClientChangeVoiceChatter,
		ClientCloseMenu, ClientGotoState,
		ClientLeaveVoiceChat, ClientOpenMenu,
		ClientReliablePlaySound, ClientRestart,
		ClientSetBehindView, ClientSetFixedCamera,
		ClientSetHUD, ClientSetMusic,
		ClientSetViewTarget, ClientValidate,
		GivePawn, SetProgressMessage,
		SetProgressTime;

	// Pos:0x083
	reliable if(AndAnd_BoolBool(EqualEqual_IntInt(int(Role), int(ROLE_Authority)), OrOr_BoolBool(Not_PreBool(bDemoRecording), AndAnd_BoolBool(bClientDemoRecording, bClientDemoNetFunc))))
		ClientMessage, ReceiveLocalizedMessage,
		TeamMessage;

	// Pos:0x0CD
	reliable if(AndAnd_BoolBool(EqualEqual_IntInt(int(Role), int(ROLE_Authority)), Not_PreBool(bDemoRecording)))
		ClientStopForceFeedback, ClientTravel;

	// Pos:0x124
	reliable if(AndAnd_BoolBool(bClientDemoRecording, EqualEqual_IntInt(int(Role), int(ROLE_Authority))))
		DemoClientSetHUD;

	// Pos:0x13C
	reliable if(Less_IntInt(int(Role), int(ROLE_Authority)))
		ActiveViewport;

	// Pos:0x156
	reliable if(Less_IntInt(int(Role), int(ROLE_Authority)))
		AskForPawn, BehindView,
		ChangeName, ChangeTeam,
		Mutate, Pause,
		ServerChangeVoiceChatter, ServerGetVoiceChatters,
		ServerRestartGame, ServerSetClientDemo,
		ServerSpectateSpeed, ServerValidationResponse,
		ServerVerifyViewTarget, SetPause,
		Speech, Suicide,
		Typing;

	// Pos:0x163
	reliable if(Less_IntInt(int(Role), int(ROLE_Authority)))
		ServerUTrace;

	// Pos:0x170
	reliable if(EqualEqual_IntInt(int(Role), int(ROLE_Authority)))
		ClientAIBeginFiringWeapon, ClientAIDroppedWeapon,
		ClientAIEndFiringWeapon, ClientBroadcastEffectEvent,
		ClientBroadcastSoundEffectSpecification, ClientBroadcastTrigger,
		ClientBroadcastUnTriggerEffectEvent, ClientDoAIReload,
		ClientDroppedWeaponAtRest, ClientWeaponFellOutOfWorld;

	// Pos:0x17D
	reliable if(EqualEqual_IntInt(int(Role), int(ROLE_Authority)))
		ClientBroadcastReactToBumped, ClientBroadcastReactToDamaged,
		ClientBroadcastReactToTriggered, ClientBroadcastReactToUsed;
}

// Export UPlayerController::execSetNetSpeed(FFrame&, void* const)
native final function SetNetSpeed(int NewSpeed);

// Export UPlayerController::execGetPlayerNetworkAddress(FFrame&, void* const)
native final function string GetPlayerNetworkAddress();

// Export UPlayerController::execGetServerNetworkAddress(FFrame&, void* const)
native final function string GetServerNetworkAddress();

// Export UPlayerController::execConsoleCommand(FFrame&, void* const)
native function string ConsoleCommand(string Command);

// Export UPlayerController::execGetEntryLevel(FFrame&, void* const)
native final function LevelInfo GetEntryLevel();

// Export UPlayerController::execResetKeyboard(FFrame&, void* const)
native(544) final function ResetKeyboard();

// Export UPlayerController::execSetViewTarget(FFrame&, void* const)
native final function SetViewTarget(Actor NewViewTarget);

// Export UPlayerController::execClientTravel(FFrame&, void* const)
native event ClientTravel(string URL, Actor.ETravelType TravelType, bool bItems);

// Export UPlayerController::execUpdateURL(FFrame&, void* const)
native(546) final function UpdateURL(string NewOption, string NewValue, bool bSaveDefault);

// Export UPlayerController::execGetDefaultURL(FFrame&, void* const)
native final function string GetDefaultURL(string Option);

// Export UPlayerController::execCopyToClipboard(FFrame&, void* const)
native function CopyToClipboard(string Text);

// Export UPlayerController::execPasteFromClipboard(FFrame&, void* const)
native function string PasteFromClipboard();

event WindowFocusLost()
{
	return;
}

event WindowFocusRegained()
{
	return;
}

// Export UPlayerController::execClientValidate(FFrame&, void* const)
private native event ClientValidate(string C);

// Export UPlayerController::execServerValidationResponse(FFrame&, void* const)
private native event ServerValidationResponse(string R);

// Export UPlayerController::execFindStairRotation(FFrame&, void* const)
native(524) final function int FindStairRotation(float DeltaTime);

// Export UPlayerController::execClientHearSound(FFrame&, void* const)
native event int ClientHearSound(Actor Actor, Sound S, Vector SoundLocation, Vector Parameters, float InnerRadius, int flags, float FadeInTime, bool Attenuate);

event PreBeginPlay()
{
	super.PreBeginPlay();
	Level.GetLocalPlayerController();
	assert(OrOr_BoolBool(EqualEqual_IntInt(int(Level.NetMode), int(NM_DedicatedServer)), NotEqual_ObjectObject(Level.GetLocalPlayerController(), none)));
	return;
}

event PostBeginPlay()
{
	super.PostBeginPlay();
	SpawnDefaultHUD();
	if(NotEqual_StrStr(Level.LevelEnterText, ""))
	{
		ClientMessage(Level.LevelEnterText);
	}
	SetZoom(false, true);
	SetViewTarget(self);
	if(OrOr_BoolBool(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)), Level.IsCOOPServer))
	{
		AddCheats();
	}
	bManualFogUpdate = false;
	return;
}

simulated function ClientBroadcastReactToDamaged(string UniqueIdentifier, int Damage, Pawn EventInstigator, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType)
{
	local Actor SourceActor;

	SourceActor = FindByUniqueID(none, UniqueIdentifier);
	if(EqualEqual_ObjectObject(SourceActor, none))
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog("Warning!  ClientBroadcastReactToDamaged called with a non-relevant source actor!");
		}
		return;
	}
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr("Client: ", string(self)), ", ReactToDamaged on source actor: "), string(SourceActor)));
	}
	SourceActor.ReactToDamaged(Damage, EventInstigator, HitLocation, Momentum, DamageType);
	return;
}

simulated function ClientBroadcastReactToBumped(string UniqueIdentifier, Actor Other)
{
	local Actor SourceActor;

	SourceActor = FindByUniqueID(none, UniqueIdentifier);
	if(EqualEqual_ObjectObject(SourceActor, none))
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog("Warning!  ClientBroadcastReactToBumped called with a non-relevant source actor!");
		}
		return;
	}
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr("Client: ", string(self)), ", ReactToBumped on source actor: "), string(SourceActor)));
	}
	SourceActor.ReactToBumped(Other);
	return;
}

simulated function ClientBroadcastReactToUsed(string UniqueIdentifier, Actor Other)
{
	local Actor SourceActor;

	SourceActor = FindByUniqueID(none, UniqueIdentifier);
	if(EqualEqual_ObjectObject(SourceActor, none))
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog("Warning!  ClientBroadcastReactToUsed called with a non-relevant source actor!");
		}
		return;
	}
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr("Client: ", string(self)), ", ReactToUsed on source actor: "), string(SourceActor)));
	}
	SourceActor.ReactToUsed(Other);
	return;
}

simulated function ClientBroadcastReactToTriggered(string UniqueIdentifier, Actor Other)
{
	local Actor SourceActor;

	SourceActor = FindByUniqueID(none, UniqueIdentifier);
	if(EqualEqual_ObjectObject(SourceActor, none))
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog("Warning!  ClientBroadcastReactToTriggered called with a non-relevant source actor!");
		}
		return;
	}
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr("Client: ", string(self)), ", ReactToTriggered on source actor: "), string(SourceActor)));
	}
	SourceActor.ReactToTriggered(Other);
	return;
}

simulated function ClientBroadcastSoundEffectSpecification(name EffectSpecification, Actor Source, Actor Target, int SpecificSoundRef, optional Material Material, optional Vector overrideWorldLocation, optional Rotator overrideWorldRotation, optional IEffectObserver Observer)
{
	TriggerSoundEffectSpecification(EffectSpecification, Source, Target, SpecificSoundRef, Material, overrideWorldLocation, overrideWorldRotation, Observer);
	return;
}

simulated function TriggerSoundEffectSpecification(name EffectSpecification, Actor Source, Actor Target, int SpecificSoundRef, optional Material Material, optional Vector overrideWorldLocation, optional Rotator overrideWorldRotation, optional IEffectObserver Observer)
{
	return;
}

simulated function ClientBroadcastEffectEvent(Actor SourceActor, string UniqueIdentifier, string EffectEvent, optional Actor Other, optional Material TargetMaterial, optional Vector HitLocation, optional Rotator HitNormal, optional bool PlayOnOther, optional bool QueryOnly, optional IEffectObserver Observer, optional string ReferenceTag)
{
	if(EqualEqual_ObjectObject(SourceActor, none))
	{
		SourceActor = FindByUniqueID(none, UniqueIdentifier);
		if(EqualEqual_ObjectObject(SourceActor, none))
		{
			MPLog("Warning!  ClientBroadcastEffectEvent called with a non-relevant source actor!");
			return;
		}
	}
	MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("Client: ", string(self)), ", playing effect event: "), EffectEvent), " on source actor: "), string(SourceActor)));
	SourceActor.TriggerEffectEvent(string(EffectEvent), Other, TargetMaterial, HitLocation, HitNormal, PlayOnOther, QueryOnly, Observer, string(ReferenceTag));
	return;
}

simulated function ClientBroadcastUnTriggerEffectEvent(Actor SourceActor, string UniqueIdentifier, string EffectEvent, optional string ReferenceTag)
{
	if(EqualEqual_ObjectObject(SourceActor, none))
	{
		SourceActor = FindByUniqueID(none, UniqueIdentifier);
		if(EqualEqual_ObjectObject(SourceActor, none))
		{
			MPLog("Warning!  ClientBroadcastUnTriggerEffectEvent called with a non-relevant source actor!");
			return;
		}
	}
	MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("Client: ", string(self)), ", stopping effect event: "), EffectEvent), " on source actor: "), string(SourceActor)));
	SourceActor.UnTriggerEffectEvent(string(EffectEvent), string(ReferenceTag));
	return;
}

simulated function ClientBroadcastTrigger(Actor SourceActor, string UniqueIdentifier, Actor Other, Pawn EventInstigator)
{
	if(EqualEqual_ObjectObject(SourceActor, none))
	{
		SourceActor = FindByUniqueID(none, UniqueIdentifier);
		if(EqualEqual_ObjectObject(SourceActor, none))
		{
			MPLog("Warning!  ClientBroadcastTrigger called with a non-relevant source actor!");
			return;
		}
	}
	MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr("Client: ", string(self)), ", Triggering source actor: "), string(SourceActor)));
	SourceActor.Trigger(Other, EventInstigator);
	return;
}

simulated function ClientDoAIReload(Pawn theAIPawn)
{
	return;
}

simulated function ClientAIBeginFiringWeapon(Pawn theAIPawn, int CurrentFireMode)
{
	return;
}

simulated function ClientAIEndFiringWeapon(Pawn theAIPawn)
{
	return;
}

simulated function ClientWeaponFellOutOfWorld(string WeaponModelUniqueID)
{
	return;
}

simulated function ClientDroppedWeaponAtRest(string WeaponModelUniqueID, float Location_X, float Location_Y, float Location_Z, Rotator Rotation)
{
	return;
}

simulated function ClientAIDroppedWeapon(string WeaponModelUniqueID, Vector Location, Rotator Rotation, Vector ThrowDirectionImpulse, Class<HandheldEquipmentModel> WeaponModelClass)
{
	return;
}

exec function SetSpectateSpeed(float F)
{
	SpectateSpeed = F;
	ServerSpectateSpeed(F);
	return;
}

function ServerSpectateSpeed(float F)
{
	SpectateSpeed = F;
	return;
}

function ServerGivePawn()
{
	GivePawn(Pawn);
	return;
}

function ClientCapBandwidth(int Cap)
{
	ClientCap = Cap;
	if(AndAnd_BoolBool(NotEqual_ObjectObject(Player, none), Greater_IntInt(Player.CurrentNetSpeed, Cap)))
	{
		SetNetSpeed(Cap);
	}
	return;
}

function PendingStasis()
{
	bStasis = true;
	Pawn = none;
	GotoState('Scripting');
	return;
}

function AddCheats()
{
	if(Not_PreBool(Level.GetEngine().EnableDevTools))
	{
		return;
	}
	if(AndAnd_BoolBool(EqualEqual_ObjectObject(CheatManager, none), EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone))))
	{
		CheatManager = CheatClass.static.Allocate(self, self).;
		Construct_Void();
	}
	return;
}

event ClientSetViewTarget(Actor A)
{
	if(EqualEqual_ObjectObject(A, none))
	{
		ServerVerifyViewTarget();
	}
	SetViewTarget(A);
	return;
}

function ServerVerifyViewTarget()
{
	if(EqualEqual_ObjectObject(ViewTarget, self))
	{
		return;
	}
	ClientSetViewTarget(ViewTarget);
	return;
}

function SpawnDefaultHUD()
{
	myHUD = Spawn(Class'Engine.HUD', self);
	return;
}

function Reset()
{
	PawnDied(Pawn);
	super.Reset();
	SetViewTarget(self);
	bBehindView = false;
	WaitDelay = Add_FloatFloat(Level.TimeSeconds, float(2));
	FixFOV();
	if(Not_PreBool(PlayerReplicationInfo.bOnlySpectator))
	{
		GotoState('PlayerWaiting');
	}
	return;
}

function CleanOutSavedMoves()
{
	local SavedMove Next;

	J0x00:
	if(NotEqual_ObjectObject(SavedMoves, none))
	{
		Next = SavedMoves.NextMove;
		SavedMoves.Destroy();
		SavedMoves = Next;
		// [Loop Continue]
		goto J0x00;
	}
	if(NotEqual_ObjectObject(PendingMove, none))
	{
		PendingMove.Destroy();
		PendingMove = none;
	}
	return;
}

event InitInputSystem()
{
	PlayerInput = InputClass.static.Allocate(self, self).;
	Construct_Void();
	return;
}

function ClientGotoState(name NewState, name NewLabel)
{
	GotoState(NewState, NewLabel);
	return;
}

function AskForPawn()
{
	if(IsInState('GameEnded'))
	{
		ClientGotoState('GameEnded', 'Begin');
	}
	else
	{
		if(NotEqual_ObjectObject(Pawn, none))
		{
			GivePawn(Pawn);
		}
		else
		{
			bFrozen = false;
			ServerReStartPlayer();
		}
	}
	return;
}

function GivePawn(Pawn NewPawn)
{
	if(EqualEqual_ObjectObject(NewPawn, none))
	{
		return;
	}
	Pawn = NewPawn;
	NewPawn.Controller = self;
	ClientRestart();
	return;
}

function int GetFacingDirection()
{
	local Vector X, Y, Z, Dir;

	GetAxes(Pawn.Rotation, X, Y, Z);
	Dir = Normal(Pawn.Acceleration);
	if(Greater_FloatFloat(Dot_VectorVector(Y, Dir), float(0)))
	{
		return int(Add_FloatFloat(float(49152), Multiply_FloatFloat(float(16384), Dot_VectorVector(X, Dir))));
	}
	else
	{
		return int(Subtract_FloatFloat(float(16384), Multiply_FloatFloat(float(16384), Dot_VectorVector(X, Dir))));
	}
	return;
}

function Possess(Pawn aPawn)
{
	if(PlayerReplicationInfo.bOnlySpectator)
	{
		return;
	}
	SetRotation(aPawn.Rotation);
	aPawn.PossessedBy(self);
	Pawn = aPawn;
	Pawn.bStasis = false;
	CleanOutSavedMoves();
	PlayerReplicationInfo.bIsFemale = Pawn.bIsFemale;
	Restart();
	return;
}

function UnPossess()
{
	if(NotEqual_ObjectObject(Pawn, none))
	{
		SetLocation(Pawn.Location);
		Pawn.RemoteRole = ROLE_SimulatedProxy;
		Pawn.UnPossessed();
		CleanOutSavedMoves();
		if(EqualEqual_ObjectObject(ViewTarget, Pawn))
		{
			SetViewTarget(self);
		}
	}
	Pawn = none;
	GotoState('Spectating');
	return;
}

function ViewNextBot()
{
	if(NotEqual_ObjectObject(CheatManager, none))
	{
		CheatManager.ViewBot();
	}
	return;
}

function PawnDied(Pawn P)
{
	if(NotEqual_ObjectObject(P, Pawn))
	{
		return;
	}
	SetZoom(false, true);
	if(NotEqual_ObjectObject(Pawn, none))
	{
		Pawn.RemoteRole = ROLE_SimulatedProxy;
	}
	if(EqualEqual_ObjectObject(ViewTarget, Pawn))
	{
		bBehindView = true;
	}
	super.PawnDied(P);
	return;
}

function ClientSetHUD(Class<HUD> newHUDType, Class<ScoreBoard> newScoringType)
{
	local HUD NewHUD;

	if(OrOr_BoolBool(EqualEqual_ObjectObject(myHUD, none), AndAnd_BoolBool(NotEqual_ObjectObject(newHUDType, none), NotEqual_ObjectObject(newHUDType, myHUD.Class))))
	{
		NewHUD = Spawn(newHUDType, self);
		if(NotEqual_ObjectObject(NewHUD, none))
		{
			if(NotEqual_ObjectObject(myHUD, none))
			{
				myHUD.Destroy();
			}
			myHUD = NewHUD;
		}
	}
	if(AndAnd_BoolBool(NotEqual_ObjectObject(myHUD, none), NotEqual_ObjectObject(newScoringType, none)))
	{
		myHUD.SpawnScoreBoard(newScoringType);
	}
	return;
}

simulated function ClientPlayForceFeedback(string EffectName)
{
	if(AndAnd_BoolBool(bForceFeedbackSupported, NotEqual_ObjectObject(Viewport(Player), none)))
	{
		PlayFeedbackEffect(EffectName);
	}
	return;
}

simulated function StopForceFeedback(optional string EffectName)
{
	if(AndAnd_BoolBool(bForceFeedbackSupported, NotEqual_ObjectObject(Viewport(Player), none)))
	{
		if(NotEqual_StrStr(EffectName, ""))
		{
			StopFeedbackEffect(EffectName);
		}
		else
		{
			StopFeedbackEffect();
		}
	}
	return;
}

function ClientStopForceFeedback(optional string EffectName)
{
	if(AndAnd_BoolBool(bForceFeedbackSupported, NotEqual_ObjectObject(Viewport(Player), none)))
	{
		if(NotEqual_StrStr(EffectName, ""))
		{
			StopFeedbackEffect(EffectName);
		}
		else
		{
			StopFeedbackEffect();
		}
	}
	return;
}

final function float UpdateFlashComponent(float Current, float Step, float Goal)
{
	if(Greater_FloatFloat(Goal, Current))
	{
		return FMin(Add_FloatFloat(Current, Step), Goal);
	}
	else
	{
		return FMax(Subtract_FloatFloat(Current, Step), Goal);
	}
	return;
}

function ViewFlash(float DeltaTime)
{
	local Vector goalFog;
	local float goalscale, Delta, Step;

	if(bManualFogUpdate)
	{
		return;
	}
	Delta = FMin(0.1000000, DeltaTime);
	goalscale = 1.0000000;
	goalFog = vect(0.0000000, 0.0000000, 0.0000000);
	if(NotEqual_ObjectObject(Pawn, none))
	{
		AddEqual_FloatFloat(goalscale, Pawn.HeadVolume.ViewFlash.X);
		AddEqual_VectorVector(goalFog, Pawn.HeadVolume.ViewFog);
	}
	Step = Multiply_FloatFloat(0.6000000, Delta);
	FlashScale.X = UpdateFlashComponent(FlashScale.X, Step, goalscale);
	FlashScale = Multiply_FloatVector(FlashScale.X, vect(1.0000000, 1.0000000, 1.0000000));
	FlashFog.X = UpdateFlashComponent(FlashFog.X, Step, goalFog.X);
	FlashFog.Y = UpdateFlashComponent(FlashFog.Y, Step, goalFog.Y);
	FlashFog.Z = UpdateFlashComponent(FlashFog.Z, Step, goalFog.Z);
	return;
}

simulated event ReceiveLocalizedMessage(Class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	Message.static.ClientReceive(self, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
	if(AndAnd_BoolBool(AndAnd_BoolBool(Message.default.bIsConsoleMessage, NotEqual_ObjectObject(Player, none)), NotEqual_ObjectObject(Player.Console, none)))
	{
		Player.Console.Message(Message.static.GetString(Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject), 0.0000000);
	}
	return;
}

event ClientMessage(coerce string S, optional name Type)
{
	if(EqualEqual_NameName(Type, 'None'))
	{
		Type = 'Event';
	}
	TeamMessage(PlayerReplicationInfo, S, Type);
	return;
}

event TeamMessage(PlayerReplicationInfo PRI, coerce string S, name Type)
{
	if(NotEqual_ObjectObject(myHUD, none))
	{
		myHUD.Message(PRI, S, Type);
	}
	if(AndAnd_BoolBool(OrOr_BoolBool(EqualEqual_NameName(Type, 'Say'), EqualEqual_NameName(Type, 'TeamSay')), NotEqual_ObjectObject(PRI, none)))
	{
		S = Concat_StrStr(Concat_StrStr(PRI.PlayerName, ": "), S);
	}
	Player.Console.Message(S, 6.0000000);
	return;
}

simulated function PlayBeepSound()
{
	return;
}

simulated function PlayAnnouncement(Sound ASound, byte AnnouncementLevel, optional bool bForce)
{
	local float Atten;

	if(Greater_IntInt(int(AnnouncementLevel), int(AnnouncerLevel)))
	{
		return;
	}
	if(AndAnd_BoolBool(Not_PreBool(bForce), Less_FloatFloat(Subtract_FloatFloat(Level.TimeSeconds, LastPlaySound), float(1))))
	{
		return;
	}
	LastPlaySound = Level.TimeSeconds;
	LastPlaySpeech = Level.TimeSeconds;
	Atten = FClamp(Add_FloatFloat(0.1000000, Multiply_FloatFloat(float(AnnouncerVolume), 0.2250000)), 0.2000000, 1.0000000);
	ClientPlaySound(ASound, true, Atten);
	return;
}

function bool AllowVoiceMessage(name MessageType)
{
	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
	{
		return true;
	}
	if(Less_FloatFloat(Subtract_FloatFloat(Level.TimeSeconds, OldMessageTime), float(3)))
	{
		if(OrOr_BoolBool(EqualEqual_NameName(MessageType, 'TAUNT'), EqualEqual_NameName(MessageType, 'AutoTaunt')))
		{
			return false;
		}
		if(Less_FloatFloat(Subtract_FloatFloat(Level.TimeSeconds, OldMessageTime), float(1)))
		{
			return false;
		}
	}
	if(Less_FloatFloat(Subtract_FloatFloat(Level.TimeSeconds, OldMessageTime), float(6)))
	{
		OldMessageTime = Add_FloatFloat(Level.TimeSeconds, float(3));
	}
	else
	{
		OldMessageTime = Level.TimeSeconds;
	}
	return true;
	return;
}

simulated function ClientPlaySound(Sound ASound, optional bool bVolumeControl, optional float inAtten)
{
	local float Atten;

	Atten = 0.9000000;
	if(bVolumeControl)
	{
		Atten = FClamp(inAtten, 0.0000000, 1.0000000);
	}
	if(NotEqual_ObjectObject(ViewTarget, none))
	{
		ViewTarget.PlaySound(ASound, Atten,,,,,,, false);
	}
	return;
}

simulated function ClientReliablePlaySound(Sound ASound, optional bool bVolumeControl)
{
	ClientPlaySound(ASound, bVolumeControl);
	return;
}

simulated function FlushAllViewports()
{
	if(Level.GetEngine().EnableDevTools)
	{
		Log("Flushing all viewports manually");
	}
	ConsoleCommand("FLUSH");
	if(Level.GetEngine().EnableDevTools)
	{
		Log(Concat_StrStr("Finished flushing all viewports manually at ", string(Level.TimeSeconds)));
	}
	ManualFlushTimer.Destroy();
	ManualFlushTimer = none;
	return;
}

simulated event OnFinishedPrecaching(bool doExtraFlush)
{
	FlushInput();
	if(AndAnd_BoolBool(doExtraFlush, Greater_FloatFloat(PostFullscreenManualFlushDelay, float(0))))
	{
		ManualFlushTimer = Class'Engine.Timer'.static.Allocate(self).;
		Construct_Void();
		if(Level.GetEngine().EnableDevTools)
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("Starting timer at time ", string(Level.TimeSeconds)), " to flush all viewports manually in "), string(PostFullscreenManualFlushDelay)), " seconds."));
		}
		ManualFlushTimer.__TimerDelegate__Delegate = FlushAllViewports;
		ManualFlushTimer.StartTimer(PostFullscreenManualFlushDelay, false);
	}
	return;
}

// Export UPlayerController::execFlushInput(FFrame&, void* const)
native function FlushInput();

simulated event OnConnectionFailed()
{
	return;
}

simulated event Destroyed()
{
	local SavedMove Next;
	local Pawn OldPawn;

	StopFeedbackEffect();
	if(NotEqual_ObjectObject(Pawn, none))
	{
		OldPawn = Pawn;
		UnPossess();
		OldPawn.Health = 0;
		OldPawn.Died(self, Class'Engine.Suicided', OldPawn.Location, vect(0.0000000, 0.0000000, 0.0000000));
	}
	myHUD.Destroy();
	J0x6B:

	if(NotEqual_ObjectObject(FreeMoves, none))
	{
		Next = FreeMoves.NextMove;
		FreeMoves.Destroy();
		FreeMoves = Next;
		// [Loop Continue]
		goto J0x6B;
	}
	J0xA4:

	if(NotEqual_ObjectObject(SavedMoves, none))
	{
		Next = SavedMoves.NextMove;
		SavedMoves.Destroy();
		SavedMoves = Next;
		// [Loop Continue]
		goto J0xA4;
	}
	if(NotEqual_ObjectObject(PlayerSecurity, none))
	{
		PlayerSecurity.Destroy();
		PlayerSecurity = none;
	}
	super.Destroyed();
	return;
}

function ClientSetMusic(string NewSong, Actor.EMusicTransition NewTransition)
{
	StopAllMusic(0.0000000);
	PlayMusic(NewSong, 3.0000000);
	Song = NewSong;
	Transition = NewTransition;
	return;
}

exec function ToggleZoom()
{
	if(OrOr_BoolBool(EqualEqual_ObjectObject(Pawn, none), Class'Engine.Pawn'.static.checkDead(Pawn)))
	{
		return;
	}
	SetZoom(Not_PreBool(WantsZoom));
	return;
}

exec function SetZoom(bool Zoom, optional bool Instantly)
{
	WantsZoom = Zoom;
	if(Instantly)
	{
		if(Zoom)
		{
			ZoomAlpha = 1.0000000;
		}
		else
		{
			ZoomAlpha = 0.0000000;
		}
	}
	return;
}

function FixFOV()
{
	return;
}

exec function Mutate(string MutateString)
{
	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Client)))
	{
		return;
	}
	Level.Game.BaseMutator.Mutate(MutateString, self);
	return;
}

exec function SetSensitivity(float F)
{
	PlayerInput.UpdateSensitivity(F);
	return;
}

exec function SetMouseSmoothing(int Mode)
{
	PlayerInput.UpdateSmoothing(Mode);
	return;
}

exec function SetMouseAccel(float F)
{
	PlayerInput.UpdateAccel(F);
	return;
}

exec function Reload()
{
	InternalReload();
	return;
}

private simulated function InternalReload()
{
	local HandheldEquipment ActiveItem;
	local FiredWeapon Weapon;

	ActiveItem = Pawn.GetActiveItem();
	Weapon = FiredWeapon(ActiveItem);
	if(EqualEqual_ObjectObject(Weapon, none))
	{
		return;
	}
	if(Not_PreBool(Weapon.IsIdle()))
	{
		return;
	}
	if(Not_PreBool(Weapon.Ammo.CanReload()))
	{
		return;
	}
	Weapon.Reload();
	return;
}

exec function Say(string msg)
{
	if(AndAnd_BoolBool(PlayerReplicationInfo.bAdmin, EqualEqual_StrStr(Left(msg, 1), "#")))
	{
		Level.Game.AdminSay(Right(msg, Subtract_IntInt(Len(msg), 1)));
		return;
	}
	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_DedicatedServer)))
	{
		MPLog(Concat_StrStr(Concat_StrStr("ChatMessage( ", msg), ", Say )"));
	}
	Level.Game.Broadcast(self, msg, 'Say');
	return;
}

exec function TeamSay(string msg)
{
	if(Not_PreBool(GameReplicationInfo.bTeamGame))
	{
		Say(msg);
		return;
	}
	Level.Game.BroadcastTeam(self, Level.Game.ParseMessageString(Level.Game.BaseMutator, self, msg), 'TeamSay');
	return;
}

function bool IsDead()
{
	return false;
	return;
}

event PreClientTravel()
{
	Log("PreClientTravel");
	ClientStopForceFeedback();
	return;
}

function ClientSetFixedCamera(bool B)
{
	bFixedCamera = B;
	return;
}

function ClientSetBehindView(bool B)
{
	bBehindView = B;
	return;
}

function ClientVoiceMessage(PlayerReplicationInfo Sender, PlayerReplicationInfo Recipient, name MessageType, byte MessageID)
{
	local VoicePack V;

	if(OrOr_BoolBool(OrOr_BoolBool(EqualEqual_ObjectObject(Sender, none), EqualEqual_ObjectObject(Sender.VoiceType, none)), EqualEqual_ObjectObject(Player.Console, none)))
	{
		return;
	}
	V = Spawn(Sender.VoiceType, self);
	if(NotEqual_ObjectObject(V, none))
	{
		V.ClientInitialize(Sender, Recipient, MessageType, MessageID);
	}
	return;
}

function ForceDeathUpdate()
{
	LastUpdateTime = Subtract_FloatFloat(Level.TimeSeconds, float(10));
	return;
}

function ShortServerMove(float TimeStamp, Vector ClientLoc, bool NewbRun, bool NewbDuck, bool NewbJumpStatus, bool NewbLeanLeft, bool NewbLeanRight, byte ClientRoll, int View)
{
	ServerMove(TimeStamp, vect(0.0000000, 0.0000000, 0.0000000), ClientLoc, NewbRun, NewbDuck, NewbJumpStatus, false, NewbLeanLeft, NewbLeanRight, 0, ClientRoll, View);
	return;
}

function ServerMove(float TimeStamp, Vector InAccel, Vector ClientLoc, bool NewbRun, bool NewbDuck, bool NewbJumpStatus, bool NewbDoubleJump, bool NewbLeanLeft, bool NewbLeanRight, Actor.EDoubleClickDir DoubleClickMove, byte ClientRoll, int View, optional byte OldTimeDelta, optional int OldAccel)
{
	local float DeltaTime, clientErr, OldTimeStamp;
	local Rotator DeltaRot, Rot, ViewRot;
	local Vector Accel, LocDiff, ClientVel, ClientFloor;
	local int maxPitch, ViewPitch, ViewYaw;
	local bool NewbPressedJump, OldbRun, OldbDoubleJump;
	local Actor.EDoubleClickDir OldDoubleClickMove;
	local Actor ClientBase;
	local Actor.EPhysics ClientPhysics;

	if(GreaterEqual_FloatFloat(CurrentTimeStamp, TimeStamp))
	{
		return;
	}
	bShortConnectTimeOut = true;
	if(NotEqual_IntInt(int(OldTimeDelta), 0))
	{
		OldTimeStamp = Subtract_FloatFloat(Subtract_FloatFloat(TimeStamp, Divide_FloatFloat(float(OldTimeDelta), float(500))), 0.0010000);
		if(Less_FloatFloat(CurrentTimeStamp, Subtract_FloatFloat(OldTimeStamp, 0.0010000)))
		{
			Accel.X = float(GreaterGreaterGreater_IntInt(OldAccel, 23));
			if(Greater_FloatFloat(Accel.X, float(127)))
			{
				Accel.X = Multiply_FloatFloat(-1.0000000, Subtract_FloatFloat(Accel.X, float(128)));
			}
			Accel.Y = float(And_IntInt(int(float(GreaterGreaterGreater_IntInt(OldAccel, 15))), 255));
			if(Greater_FloatFloat(Accel.Y, float(127)))
			{
				Accel.Y = Multiply_FloatFloat(-1.0000000, Subtract_FloatFloat(Accel.Y, float(128)));
			}
			Accel.Z = float(And_IntInt(int(float(GreaterGreaterGreater_IntInt(OldAccel, 7))), 255));
			if(Greater_FloatFloat(Accel.Z, float(127)))
			{
				Accel.Z = Multiply_FloatFloat(-1.0000000, Subtract_FloatFloat(Accel.Z, float(128)));
			}
			MultiplyEqual_VectorFloat(Accel, float(20));
			OldbRun = NotEqual_IntInt(And_IntInt(OldAccel, 64), 0);
			OldbDoubleJump = NotEqual_IntInt(And_IntInt(OldAccel, 32), 0);
			NewbPressedJump = NotEqual_IntInt(And_IntInt(OldAccel, 16), 0);
			if(NewbPressedJump)
			{
				bJumpStatus = NewbJumpStatus;
			}
			switch(And_IntInt(OldAccel, 7))
			{
				case 0:
					OldDoubleClickMove = 0;
					break;
				case 1:
					OldDoubleClickMove = 1;
					break;
				case 2:
					OldDoubleClickMove = 2;
					break;
				case 3:
					OldDoubleClickMove = 3;
					break;
				case 4:
					OldDoubleClickMove = 4;
					break;
				default:
					break;
			}
			OldTimeStamp = FMin(OldTimeStamp, Add_FloatFloat(CurrentTimeStamp, MaxResponseTime));
			MoveAutonomous(Subtract_FloatFloat(OldTimeStamp, CurrentTimeStamp), OldbRun, EqualEqual_IntInt(int(bDuck), 1), NewbPressedJump, OldbDoubleJump, EqualEqual_IntInt(int(bLeanLeft), 1), EqualEqual_IntInt(int(bLeanRight), 1), OldDoubleClickMove, Accel, rot(0, 0, 0));
			CurrentTimeStamp = OldTimeStamp;
		}
	}
	ViewPitch = Divide_IntInt(View, 32768);
	ViewYaw = Multiply_IntInt(2, Subtract_IntInt(View, Multiply_IntInt(32768, ViewPitch)));
	MultiplyEqual_IntFloat(ViewPitch, float(2));
	Accel = Divide_VectorFloat(InAccel, float(10));
	NewbPressedJump = NotEqual_BoolBool(bJumpStatus, NewbJumpStatus);
	bJumpStatus = NewbJumpStatus;
	DeltaTime = FMin(MaxResponseTime, Subtract_FloatFloat(TimeStamp, CurrentTimeStamp));
	if(Greater_FloatFloat(ServerTimeStamp, float(0)))
	{
		TimeMargin = FMax(0.0000000, Subtract_FloatFloat(Add_FloatFloat(TimeMargin, DeltaTime), Multiply_FloatFloat(1.0100000, Subtract_FloatFloat(Level.TimeSeconds, ServerTimeStamp))));
		if(Greater_FloatFloat(TimeMargin, MaxTimeMargin))
		{
			SubtractEqual_FloatFloat(TimeMargin, DeltaTime);
			if(Less_FloatFloat(TimeMargin, 0.5000000))
			{
				MaxTimeMargin = default.MaxTimeMargin;
			}
			else
			{
				MaxTimeMargin = 0.5000000;
			}
			DeltaTime = 0.0000000;
		}
	}
	CurrentTimeStamp = TimeStamp;
	ServerTimeStamp = Level.TimeSeconds;
	ViewRot.Pitch = ViewPitch;
	ViewRot.Yaw = ViewYaw;
	ViewRot.Roll = 0;
	SetRotation(ViewRot);
	if(NotEqual_ObjectObject(Pawn, none))
	{
		Rot.Roll = Multiply_IntInt(256, int(ClientRoll));
		Rot.Yaw = ViewYaw;
		if(OrOr_BoolBool(EqualEqual_IntInt(int(Pawn.Physics), int(3)), EqualEqual_IntInt(int(Pawn.Physics), int(4))))
		{
			maxPitch = 2;
		}
		else
		{
			maxPitch = 0;
		}
		if(AndAnd_BoolBool(Greater_IntInt(ViewPitch, Multiply_IntInt(maxPitch, RotationRate.Pitch)), Less_IntInt(ViewPitch, Subtract_IntInt(65536, Multiply_IntInt(maxPitch, RotationRate.Pitch)))))
		{
			if(Less_IntInt(ViewPitch, 32768))
			{
				Rot.Pitch = Multiply_IntInt(maxPitch, RotationRate.Pitch);
			}
			else
			{
				Rot.Pitch = Subtract_IntInt(65536, Multiply_IntInt(maxPitch, RotationRate.Pitch));
			}
		}
		else
		{
			Rot.Pitch = ViewPitch;
		}
		DeltaRot = Subtract_RotatorRotator(Rotation, Rot);
		Pawn.SetRotation(Rot);
	}
	if(AndAnd_BoolBool(EqualEqual_ObjectObject(Level.Pauser, none), Greater_FloatFloat(DeltaTime, float(0))))
	{
		MoveAutonomous(DeltaTime, NewbRun, NewbDuck, NewbPressedJump, NewbDoubleJump, NewbLeanLeft, NewbLeanRight, DoubleClickMove, Accel, DeltaRot);
	}
	if(Greater_FloatFloat(Subtract_FloatFloat(Level.TimeSeconds, LastUpdateTime), 0.3000000))
	{
		clientErr = 10000.0000000;
	}
	else
	{
		if(Greater_FloatFloat(Subtract_FloatFloat(Level.TimeSeconds, LastUpdateTime), Divide_FloatFloat(180.0000000, float(Player.CurrentNetSpeed))))
		{
			if(EqualEqual_ObjectObject(Pawn, none))
			{
				LocDiff = Subtract_VectorVector(Location, ClientLoc);
			}
			else
			{
				LocDiff = Subtract_VectorVector(Pawn.Location, ClientLoc);
			}
			clientErr = Dot_VectorVector(LocDiff, LocDiff);
		}
	}
	if(Greater_FloatFloat(clientErr, float(3)))
	{
		if(EqualEqual_ObjectObject(Pawn, none))
		{
			ClientPhysics = Physics;
			ClientLoc = Location;
			ClientVel = Velocity;
		}
		else
		{
			ClientPhysics = Pawn.Physics;
			ClientVel = Pawn.Velocity;
			ClientBase = Pawn.Base;
			if(NotEqual_ObjectObject(Mover(Pawn.Base), none))
			{
				ClientLoc = Subtract_VectorVector(Pawn.Location, Pawn.Base.Location);
			}
			else
			{
				ClientLoc = Pawn.Location;
			}
			ClientFloor = Pawn.Floor;
		}
		LastUpdateTime = Level.TimeSeconds;
		if(OrOr_BoolBool(EqualEqual_ObjectObject(Pawn, none), NotEqual_IntInt(int(Pawn.Physics), int(9))))
		{
			if(EqualEqual_VectorVector(ClientVel, vect(0.0000000, 0.0000000, 0.0000000)))
			{
				ShortClientAdjustPosition(TimeStamp, GetStateName(), ClientPhysics, ClientLoc.X, ClientLoc.Y, ClientLoc.Z, ClientBase);
			}
			else
			{
				ClientAdjustPosition(TimeStamp, GetStateName(), ClientPhysics, ClientLoc.X, ClientLoc.Y, ClientLoc.Z, ClientVel.X, ClientVel.Y, ClientVel.Z, ClientBase);
			}
		}
		else
		{
			LongClientAdjustPosition(TimeStamp, GetStateName(), ClientPhysics, ClientLoc.X, ClientLoc.Y, ClientLoc.Z, ClientVel.X, ClientVel.Y, ClientVel.Z, ClientBase, ClientFloor.X, ClientFloor.Y, ClientFloor.Z);
		}
	}
	return;
}

function ServerDrive(float InForward, float InStrafe, float InUp, bool InJump)
{
	ProcessDrive(InForward, InStrafe, InUp, InJump);
	return;
}

function ProcessDrive(float InForward, float InStrafe, float InUp, bool InJump)
{
	Log("ProcessDrive Not Valid Outside State PlayerDriving");
	return;
}

function ProcessMove(float DeltaTime, Vector newAccel, Actor.EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
{
	if(NotEqual_ObjectObject(Pawn, none))
	{
		Pawn.Acceleration = newAccel;
	}
	return;
}

final function MoveAutonomous(float DeltaTime, bool NewbRun, bool NewbDuck, bool NewbPressedJump, bool NewbDoubleJump, bool NewbLeanLeft, bool NewbLeanRight, Actor.EDoubleClickDir DoubleClickMove, Vector newAccel, Rotator DeltaRot)
{
	if(NewbRun)
	{
		bRun = 1;
	}
	else
	{
		bRun = 0;
	}
	if(NewbDuck)
	{
		bDuck = 1;
	}
	else
	{
		bDuck = 0;
	}
	if(NewbLeanLeft)
	{
		bLeanLeft = 1;
	}
	else
	{
		bLeanLeft = 0;
	}
	if(NewbLeanRight)
	{
		bLeanRight = 1;
	}
	else
	{
		bLeanRight = 0;
	}
	bPressedJump = NewbPressedJump;
	bDoubleJump = NewbDoubleJump;
	HandleWalking();
	ProcessMove(DeltaTime, newAccel, DoubleClickMove, DeltaRot);
	if(NotEqual_ObjectObject(Pawn, none))
	{
		Pawn.AutonomousPhysics(DeltaTime);
	}
	else
	{
		AutonomousPhysics(DeltaTime);
	}
	bDoubleJump = false;
	return;
}

function VeryShortClientAdjustPosition(float TimeStamp, float NewLocX, float NewLocY, float NewLocZ, Actor NewBase)
{
	local Vector Floor;

	if(NotEqual_ObjectObject(Pawn, none))
	{
		Floor = Pawn.Floor;
	}
	LongClientAdjustPosition(TimeStamp, 'PlayerWalking', 1, NewLocX, NewLocY, NewLocZ, 0.0000000, 0.0000000, 0.0000000, NewBase, Floor.X, Floor.Y, Floor.Z);
	return;
}

function ShortClientAdjustPosition(float TimeStamp, name NewState, Actor.EPhysics newPhysics, float NewLocX, float NewLocY, float NewLocZ, Actor NewBase)
{
	local Vector Floor;

	if(NotEqual_ObjectObject(Pawn, none))
	{
		Floor = Pawn.Floor;
	}
	LongClientAdjustPosition(TimeStamp, NewState, newPhysics, NewLocX, NewLocY, NewLocZ, 0.0000000, 0.0000000, 0.0000000, NewBase, Floor.X, Floor.Y, Floor.Z);
	return;
}

function ClientAdjustPosition(float TimeStamp, name NewState, Actor.EPhysics newPhysics, float NewLocX, float NewLocY, float NewLocZ, float NewVelX, float NewVelY, float NewVelZ, Actor NewBase)
{
	local Vector Floor;

	if(NotEqual_ObjectObject(Pawn, none))
	{
		Floor = Pawn.Floor;
	}
	LongClientAdjustPosition(TimeStamp, NewState, newPhysics, NewLocX, NewLocY, NewLocZ, NewVelX, NewVelY, NewVelZ, NewBase, Floor.X, Floor.Y, Floor.Z);
	return;
}

function LongClientAdjustPosition(float TimeStamp, name NewState, Actor.EPhysics newPhysics, float NewLocX, float NewLocY, float NewLocZ, float NewVelX, float NewVelY, float NewVelZ, Actor NewBase, float NewFloorX, float NewFloorY, float NewFloorZ)
{
	local Vector NewLocation, NewVelocity, NewFloor;
	local Actor MoveActor;
	local SavedMove CurrentMove;

	if(AndAnd_BoolBool(NotEqual_ObjectObject(PlayerReplicationInfo, none), Not_PreBool(bDemoOwner)))
	{
		if(Less_FloatFloat(ExactPing, 0.0060000))
		{
			ExactPing = Subtract_FloatFloat(Level.TimeSeconds, TimeStamp);
		}
		else
		{
			ExactPing = Add_FloatFloat(Multiply_FloatFloat(0.9900000, ExactPing), Multiply_FloatFloat(0.0080000, Subtract_FloatFloat(Level.TimeSeconds, TimeStamp)));
		}
		PlayerReplicationInfo.Ping = int(Multiply_FloatFloat(float(1000), ExactPing));
		if(Greater_FloatFloat(Subtract_FloatFloat(Level.TimeSeconds, LastPingUpdate), float(4)))
		{
			if(AndAnd_BoolBool(AndAnd_BoolBool(bDynamicNetSpeed, Greater_FloatFloat(OldPing, Multiply_FloatFloat(DynamicPingThreshold, 0.0010000))), Greater_FloatFloat(ExactPing, Multiply_FloatFloat(DynamicPingThreshold, 0.0010000))))
			{
				if(Greater_IntInt(Player.CurrentNetSpeed, 5000))
				{
					SetNetSpeed(5000);
				}
				else
				{
					if(Less_FloatFloat(Level.MoveRepSize, float(80)))
					{
						AddEqual_FloatFloat(Level.MoveRepSize, float(8));
					}
					else
					{
						if(Greater_IntInt(Player.CurrentNetSpeed, 4000))
						{
							SetNetSpeed(4000);
						}
					}
				}
				OldPing = 0.0000000;
			}
			else
			{
				OldPing = ExactPing;
			}
			LastPingUpdate = Level.TimeSeconds;
			ServerUpdatePing(int(Multiply_FloatFloat(float(1000), ExactPing)));
		}
	}
	if(NotEqual_ObjectObject(Pawn, none))
	{
		if(Pawn.bTearOff)
		{
			Pawn = none;
			if(AndAnd_BoolBool(AndAnd_BoolBool(Not_PreBool(IsInState('GameEnded')), Not_PreBool(IsInState('Dead'))), Not_PreBool(IsInState('ObserveTeam'))))
			{
				GotoState('Dead');
			}
			return;
		}
		MoveActor = Pawn;
		if(AndAnd_BoolBool(NotEqual_ObjectObject(ViewTarget, Pawn), OrOr_BoolBool(EqualEqual_ObjectObject(ViewTarget, self), AndAnd_BoolBool(NotEqual_ObjectObject(Pawn(ViewTarget), none), LessEqual_IntInt(Pawn(ViewTarget).Health, 0)))))
		{
			bBehindView = false;
			SetViewTarget(Pawn);
		}
	}
	else
	{
		MoveActor = self;
		if(NotEqual_NameName(GetStateName(), NewState))
		{
			if(EqualEqual_NameName(NewState, 'GameEnded'))
			{
				GotoState(NewState);
			}
			else
			{
				if(IsInState('Dead'))
				{
					if(AndAnd_BoolBool(NotEqual_NameName(NewState, 'PlayerWalking'), NotEqual_NameName(NewState, 'PlayerSwimming')))
					{
						GotoState(NewState);
					}
					return;
				}
				else
				{
					if(AndAnd_BoolBool(EqualEqual_NameName(NewState, 'Dead'), Not_PreBool(IsInState('ObserveTeam'))))
					{
						GotoState(NewState);
					}
				}
			}
		}
	}
	if(GreaterEqual_FloatFloat(CurrentTimeStamp, TimeStamp))
	{
		return;
	}
	CurrentTimeStamp = TimeStamp;
	NewLocation.X = NewLocX;
	NewLocation.Y = NewLocY;
	NewLocation.Z = NewLocZ;
	NewVelocity.X = NewVelX;
	NewVelocity.Y = NewVelY;
	NewVelocity.Z = NewVelZ;
	CurrentMove = SavedMoves;
	J0x377:

	if(NotEqual_ObjectObject(CurrentMove, none))
	{
		if(LessEqual_FloatFloat(CurrentMove.TimeStamp, CurrentTimeStamp))
		{
			SavedMoves = CurrentMove.NextMove;
			CurrentMove.NextMove = FreeMoves;
			FreeMoves = CurrentMove;
			if(EqualEqual_FloatFloat(CurrentMove.TimeStamp, CurrentTimeStamp))
			{
				FreeMoves.Clear();
				if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(Less_FloatFloat(VSize(Subtract_VectorVector(CurrentMove.SavedLocation, NewLocation)), float(3)), Less_FloatFloat(VSize(Subtract_VectorVector(CurrentMove.SavedVelocity, NewVelocity)), float(3))), EqualEqual_NameName(GetStateName(), NewState)), OrOr_BoolBool(NotEqual_IntInt(int(MoveActor.Physics), int(4)), Not_PreBool(IsInState('PlayerWalking')))))
				{
					return;
				}
				CurrentMove = none;
			}
			else
			{
				FreeMoves.Clear();
				CurrentMove = SavedMoves;
			}
		}
		else
		{
			CurrentMove = none;
		}
		// [Loop Continue]
		goto J0x377;
	}
	NewFloor.X = NewFloorX;
	NewFloor.Y = NewFloorY;
	NewFloor.Z = NewFloorZ;
	MoveActor.SetBase(NewBase, NewFloor);
	if(NotEqual_ObjectObject(Mover(NewBase), none))
	{
		AddEqual_VectorVector(NewLocation, NewBase.Location);
	}
	if(Not_PreBool(bDemoOwner))
	{
		MoveActor.bCanTeleport = false;
		if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(Not_PreBool(MoveActor.SetLocation(NewLocation)), NotEqual_ObjectObject(Pawn(MoveActor), none)), Greater_FloatFloat(MoveActor.CollisionHeight, Pawn(MoveActor).CrouchHeight)), Not_PreBool(Pawn(MoveActor).bIsCrouched)), EqualEqual_IntInt(int(newPhysics), int(1))), NotEqual_IntInt(int(MoveActor.Physics), int(13))), NotEqual_IntInt(int(MoveActor.Physics), int(14))), NotEqual_IntInt(int(MoveActor.Physics), int(15))), NotEqual_IntInt(int(MoveActor.Physics), int(16))))
		{
			MoveActor.SetPhysics(newPhysics);
			MoveActor.SetLocation(NewLocation);
		}
		MoveActor.bCanTeleport = true;
	}
	if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_IntInt(int(MoveActor.Physics), int(13)), NotEqual_IntInt(int(MoveActor.Physics), int(14))), NotEqual_IntInt(int(MoveActor.Physics), int(15))), NotEqual_IntInt(int(MoveActor.Physics), int(16))), NotEqual_IntInt(int(newPhysics), int(13))), NotEqual_IntInt(int(newPhysics), int(14))), NotEqual_IntInt(int(newPhysics), int(15))), NotEqual_IntInt(int(newPhysics), int(16))))
	{
		MoveActor.SetPhysics(newPhysics);
	}
	MoveActor.Velocity = NewVelocity;
	if(OrOr_BoolBool(AndAnd_BoolBool(NotEqual_NameName(GetStateName(), NewState), NotEqual_NameName(NewState, 'Dead')), Not_PreBool(IsInState('ObserveTeam'))))
	{
		GotoState(NewState);
	}
	bUpdatePosition = true;
	return;
}

function ServerUpdatePing(int NewPing)
{
	PlayerReplicationInfo.Ping = NewPing;
	PlayerReplicationInfo.bReceivedPing = true;
	return;
}

function ClientUpdatePosition()
{
	local SavedMove CurrentMove;
	local int realbRun, realbDuck, realbLeanLeft, realbLeanRight;
	local bool bRealJump;

	if(AndAnd_BoolBool(NotEqual_ObjectObject(Pawn, none), OrOr_BoolBool(OrOr_BoolBool(OrOr_BoolBool(EqualEqual_IntInt(int(Pawn.Physics), int(13)), EqualEqual_IntInt(int(Pawn.Physics), int(14))), EqualEqual_IntInt(int(Pawn.Physics), int(15))), EqualEqual_IntInt(int(Pawn.Physics), int(16)))))
	{
		return;
	}
	bUpdatePosition = false;
	realbRun = int(bRun);
	realbDuck = int(bDuck);
	realbLeanLeft = int(bLeanLeft);
	realbLeanRight = int(bLeanRight);
	bRealJump = bPressedJump;
	CurrentMove = SavedMoves;
	bUpdating = true;
	J0xD5:

	if(NotEqual_ObjectObject(CurrentMove, none))
	{
		if(LessEqual_FloatFloat(CurrentMove.TimeStamp, CurrentTimeStamp))
		{
			SavedMoves = CurrentMove.NextMove;
			CurrentMove.NextMove = FreeMoves;
			FreeMoves = CurrentMove;
			FreeMoves.Clear();
			CurrentMove = SavedMoves;
		}
		else
		{
			MoveAutonomous(CurrentMove.Delta, CurrentMove.bRun, CurrentMove.bDuck, CurrentMove.bPressedJump, CurrentMove.bDoubleJump, CurrentMove.bLeanLeft, CurrentMove.bLeanRight, CurrentMove.DoubleClickMove, CurrentMove.Acceleration, rot(0, 0, 0));
			CurrentMove = CurrentMove.NextMove;
		}
		// [Loop Continue]
		goto J0xD5;
	}
	if(NotEqual_ObjectObject(PendingMove, none))
	{
		MoveAutonomous(PendingMove.Delta, PendingMove.bRun, PendingMove.bDuck, PendingMove.bPressedJump, PendingMove.bDoubleJump, PendingMove.bLeanLeft, PendingMove.bLeanRight, PendingMove.DoubleClickMove, PendingMove.Acceleration, rot(0, 0, 0));
	}
	bUpdating = false;
	bDuck = byte(realbDuck);
	bRun = byte(realbRun);
	bPressedJump = bRealJump;
	bLeanLeft = byte(realbLeanLeft);
	bLeanRight = byte(realbLeanRight);
	return;
}

final function SavedMove GetFreeMove()
{
	local SavedMove S, first;
	local int i;

	if(EqualEqual_ObjectObject(FreeMoves, none))
	{
		S = SavedMoves;
		J0x16:

		if(NotEqual_ObjectObject(S, none))
		{
			AddAdd_Int(i);
			if(Greater_IntInt(i, 100))
			{
				first = SavedMoves;
				SavedMoves = SavedMoves.NextMove;
				first.Clear();
				first.NextMove = none;
				J0x72:

				if(NotEqual_ObjectObject(SavedMoves, none))
				{
					S = SavedMoves;
					SavedMoves = SavedMoves.NextMove;
					S.Clear();
					S.NextMove = FreeMoves;
					FreeMoves = S;
					// [Loop Continue]
					goto J0x72;
				}
				return first;
			}
			S = S.NextMove;
			// [Loop Continue]
			goto J0x16;
		}
		return Spawn(Class'Engine.SavedMove');
	}
	else
	{
		S = FreeMoves;
		FreeMoves = FreeMoves.NextMove;
		S.NextMove = none;
		return S;
	}
	return;
}

function int CompressAccel(int C)
{
	if(GreaterEqual_IntInt(C, 0))
	{
		C = Min(C, 127);
	}
	else
	{
		C = Add_IntInt(Min(int(Abs(float(C))), 127), 128);
	}
	return C;
	return;
}

function ReplicateMove(float DeltaTime, Vector newAccel, Actor.EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
{
	local SavedMove NewMove, OldMove, LastMove;
	local byte ClientRoll;
	local float OldTimeDelta, NetMoveDelta;
	local int OldAccel;
	local Vector BuildAccel, AccelNorm, MoveLoc;

	if(NotEqual_ObjectObject(SavedMoves, none))
	{
		LastMove = SavedMoves;
		AccelNorm = Normal(newAccel);
		J0x23:

		if(NotEqual_ObjectObject(LastMove.NextMove, none))
		{
			if(OrOr_BoolBool(OrOr_BoolBool(OrOr_BoolBool(LastMove.bPressedJump, LastMove.bDoubleJump), AndAnd_BoolBool(NotEqual_IntInt(int(LastMove.DoubleClickMove), int(0)), Less_IntInt(int(LastMove.DoubleClickMove), 5))), AndAnd_BoolBool(NotEqual_VectorVector(LastMove.Acceleration, newAccel), Less_FloatFloat(Dot_VectorVector(Normal(LastMove.Acceleration), AccelNorm), 0.9500000))))
			{
				OldMove = LastMove;
			}
			LastMove = LastMove.NextMove;
			// [Loop Continue]
			goto J0x23;
		}
		if(OrOr_BoolBool(OrOr_BoolBool(OrOr_BoolBool(LastMove.bPressedJump, LastMove.bDoubleJump), AndAnd_BoolBool(NotEqual_IntInt(int(LastMove.DoubleClickMove), int(0)), Less_IntInt(int(LastMove.DoubleClickMove), 5))), AndAnd_BoolBool(NotEqual_VectorVector(LastMove.Acceleration, newAccel), Less_FloatFloat(Dot_VectorVector(Normal(LastMove.Acceleration), AccelNorm), 0.9500000))))
		{
			OldMove = LastMove;
		}
	}
	if(NotEqual_ObjectObject(PendingMove, none))
	{
		PendingMove.SetMoveFor(Level.TimeSeconds, self, DeltaTime, newAccel, DoubleClickMove);
	}
	NewMove = GetFreeMove();
	if(EqualEqual_ObjectObject(NewMove, none))
	{
		return;
	}
	NewMove.SetMoveFor(Level.TimeSeconds, self, DeltaTime, newAccel, DoubleClickMove);
	bDoubleJump = false;
	ProcessMove(NewMove.Delta, NewMove.Acceleration, NewMove.DoubleClickMove, DeltaRot);
	if(NotEqual_ObjectObject(Pawn, none))
	{
		Pawn.AutonomousPhysics(NewMove.Delta);
	}
	else
	{
		AutonomousPhysics(DeltaTime);
	}
	if(EqualEqual_ObjectObject(PendingMove, none))
	{
		PendingMove = NewMove;
	}
	else
	{
		NewMove.NextMove = FreeMoves;
		FreeMoves = NewMove;
		FreeMoves.Clear();
		NewMove = PendingMove;
	}
	NewMove.PostUpdate(self);
	NetMoveDelta = FMax(Divide_FloatFloat(80.0000000, float(Player.CurrentNetSpeed)), 0.0150000);
	if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(Not_PreBool(Level.bCapFramerate), Not_PreBool(PendingMove.bPressedJump)), Not_PreBool(PendingMove.bDoubleJump)), OrOr_BoolBool(EqualEqual_IntInt(int(PendingMove.DoubleClickMove), int(0)), EqualEqual_IntInt(int(PendingMove.DoubleClickMove), int(5)))), OrOr_BoolBool(EqualEqual_VectorVector(PendingMove.Acceleration, newAccel), Greater_FloatFloat(Dot_VectorVector(Normal(newAccel), Normal(PendingMove.Acceleration)), 0.9500000))), Less_FloatFloat(PendingMove.Delta, Subtract_FloatFloat(NetMoveDelta, ClientUpdateTime))))
	{
		return;
	}
	else
	{
		ClientUpdateTime = Subtract_FloatFloat(PendingMove.Delta, NetMoveDelta);
		if(EqualEqual_ObjectObject(SavedMoves, none))
		{
			SavedMoves = PendingMove;
		}
		else
		{
			LastMove.NextMove = PendingMove;
		}
		PendingMove = none;
	}
	if(NotEqual_ObjectObject(OldMove, none))
	{
		OldTimeDelta = FMin(255.0000000, Multiply_FloatFloat(Subtract_FloatFloat(Level.TimeSeconds, OldMove.TimeStamp), float(500)));
		BuildAccel = Add_VectorVector(Multiply_FloatVector(0.0500000, OldMove.Acceleration), vect(0.5000000, 0.5000000, 0.5000000));
		OldAccel = Add_IntInt(Add_IntInt(LessLess_IntInt(CompressAccel(int(BuildAccel.X)), 23), LessLess_IntInt(CompressAccel(int(BuildAccel.Y)), 15)), LessLess_IntInt(CompressAccel(int(BuildAccel.Z)), 7));
		if(OldMove.bRun)
		{
			AddEqual_IntInt(OldAccel, 64);
		}
		if(OldMove.bDoubleJump)
		{
			AddEqual_IntInt(OldAccel, 32);
		}
		if(OldMove.bPressedJump)
		{
			AddEqual_IntInt(OldAccel, 16);
		}
		AddEqual_IntInt(OldAccel, int(OldMove.DoubleClickMove));
	}
	ClientRoll = byte(And_IntInt(int(byte(GreaterGreater_IntInt(Rotation.Roll, 8))), 255));
	if(NewMove.bPressedJump)
	{
		bJumpStatus = Not_PreBool(bJumpStatus);
	}
	if(EqualEqual_ObjectObject(Pawn, none))
	{
		MoveLoc = Location;
	}
	else
	{
		MoveLoc = Pawn.Location;
	}
	if(AndAnd_BoolBool(AndAnd_BoolBool(EqualEqual_VectorVector(NewMove.Acceleration, vect(0.0000000, 0.0000000, 0.0000000)), EqualEqual_IntInt(int(NewMove.DoubleClickMove), int(0))), Not_PreBool(NewMove.bDoubleJump)))
	{
		ShortServerMove(NewMove.TimeStamp, MoveLoc, NewMove.bRun, NewMove.bDuck, bJumpStatus, NewMove.bLeanLeft, NewMove.bLeanRight, ClientRoll, Add_IntInt(Multiply_IntInt(And_IntInt(32767, Divide_IntInt(Rotation.Pitch, 2)), 32768), And_IntInt(32767, Divide_IntInt(Rotation.Yaw, 2))));
	}
	else
	{
		ServerMove(NewMove.TimeStamp, Multiply_VectorFloat(NewMove.Acceleration, float(10)), MoveLoc, NewMove.bRun, NewMove.bDuck, bJumpStatus, NewMove.bDoubleJump, NewMove.bLeanLeft, NewMove.bLeanRight, NewMove.DoubleClickMove, ClientRoll, Add_IntInt(Multiply_IntInt(And_IntInt(32767, Divide_IntInt(Rotation.Pitch, 2)), 32768), And_IntInt(32767, Divide_IntInt(Rotation.Yaw, 2))), byte(OldTimeDelta), OldAccel);
	}
	return;
}

function HandleWalking()
{
	if(NotEqual_ObjectObject(Pawn, none))
	{
		Pawn.SetWalking(AndAnd_BoolBool(NotEqual_IntInt(int(bRun), 0), Not_PreBool(Region.Zone.IsA('WarpZoneInfo'))));
	}
	return;
}

function ServerRestartGame()
{
	return;
}

function SetFOVAngle(float newFOV)
{
	FovAngle = newFOV;
	return;
}

function ClientFlash(float Scale, Vector fog)
{
	FlashScale = Multiply_FloatVector(Scale, vect(1.0000000, 1.0000000, 1.0000000));
	FlashFog = Multiply_FloatVector(0.0010000, fog);
	return;
}

function ClientAdjustGlow(float Scale, Vector fog)
{
	AddEqual_FloatFloat(ConstantGlowScale, Scale);
	AddEqual_VectorVector(ConstantGlowFog, Multiply_FloatVector(0.0010000, fog));
	return;
}

private function ClientShake(Vector ShakeRoll, Vector OffsetMag, Vector ShakeRate, float OffsetTime)
{
	if(OrOr_BoolBool(Less_FloatFloat(MaxShakeRoll, ShakeRoll.X), Less_FloatFloat(ShakeRollTime, Multiply_FloatFloat(0.0100000, ShakeRoll.Y))))
	{
		MaxShakeRoll = ShakeRoll.X;
		ShakeRollTime = Multiply_FloatFloat(0.0100000, ShakeRoll.Y);
		ShakeRollRate = Multiply_FloatFloat(0.0100000, ShakeRoll.Z);
	}
	if(Greater_FloatFloat(VSize(OffsetMag), VSize(MaxShakeOffset)))
	{
		ShakeOffsetTime = Multiply_FloatVector(OffsetTime, vect(1.0000000, 1.0000000, 1.0000000));
		MaxShakeOffset = OffsetMag;
		ShakeOffsetRate = ShakeRate;
	}
	return;
}

function ShakeView(float shaketime, float RollMag, Vector OffsetMag, float RollRate, Vector OffsetRate, float OffsetTime)
{
	local Vector ShakeRoll;

	ShakeRoll.X = RollMag;
	ShakeRoll.Y = Multiply_FloatFloat(100.0000000, shaketime);
	ShakeRoll.Z = Multiply_FloatFloat(100.0000000, RollRate);
	ClientShake(ShakeRoll, OffsetMag, OffsetRate, OffsetTime);
	return;
}

function damageAttitudeTo(Pawn Other, float Damage)
{
	if(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(Other, none), NotEqual_ObjectObject(Other, Pawn)), Greater_FloatFloat(Damage, float(0))))
	{
		Enemy = Other;
	}
	return;
}

function Typing(bool bTyping)
{
	bIsTyping = bTyping;
	Pawn.bIsTyping = bIsTyping;
	if(AndAnd_BoolBool(AndAnd_BoolBool(bTyping, NotEqual_ObjectObject(Pawn, none)), Not_PreBool(Pawn.bTearOff)))
	{
		Pawn.ChangeAnimation();
	}
	return;
}

exec function Jump(optional float F)
{
	if(EqualEqual_ObjectObject(Level.Pauser, PlayerReplicationInfo))
	{
		SetPause(false);
	}
	else
	{
		bPressedJump = true;
	}
	return;
}

exec function Speech(name Type, int Index, string Callsign)
{
	if(NotEqual_ObjectObject(PlayerReplicationInfo.VoiceType, none))
	{
		PlayerReplicationInfo.VoiceType.static.PlayerSpeech(Type, Index, Callsign, self);
	}
	return;
}

exec function RestartLevel()
{
	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
	{
		ClientTravel("?restart", NM_ListenServer, false);
	}
	return;
}

exec function LocalTravel(string URL)
{
	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
	{
		ClientTravel(URL, 2, true);
	}
	return;
}

exec function QuickSave()
{
	if(AndAnd_BoolBool(Greater_IntInt(Pawn.Health, 0), EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone))))
	{
		ClientMessage(QuickSaveString);
		ConsoleCommand("SaveGame 9");
	}
	return;
}

exec function QuickLoad()
{
	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
	{
		ClientTravel("?load=9", NM_Standalone, false);
	}
	return;
}

function bool SetPause(bool bPause)
{
	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
	{
		bFire = 0;
		bAltFire = 0;
		return Level.Game.SetPause(bPause, self);
	}
	else
	{
		return false;
	}
	return;
}

exec function Pause()
{
	if(EqualEqual_ObjectObject(Level.Pauser, none))
	{
		SetPause(true);
	}
	else
	{
		SetPause(false);
	}
	return;
}

exec function ExecSetPause(bool bPause)
{
	SetPause(bPause);
	return;
}

exec function ShowMenu()
{
	if(EqualEqual_ObjectObject(Level.Pauser, none))
	{
		SetPause(true);
	}
	StopForceFeedback();
	return;
}

exec function Fire()
{
	local HandheldEquipment ActiveItem;

	ActiveItem = Pawn.GetActiveItem();
	if(EqualEqual_ObjectObject(ActiveItem, none))
	{
		Log("[tcohen] Fire() was called on the PlayerController.  But either the Pawn is None, the Pawn has no ActiveItem, or the Pawn's ActiveItem is not a HandheldEquipment.");
		return;
	}
	if(OrOr_BoolBool(Not_PreBool(ActiveItem.IsIdle()), Not_PreBool(ActiveItem.IsAvailable())))
	{
		return;
	}
	ActiveItem.OnPlayerUse();
	return;
}

simulated function Throw()
{
	return;
}

exec function Use()
{
	local HandheldEquipment ActiveItem;

	ActiveItem = Pawn.GetActiveItem();
	AssertWithDescription(NotEqual_ObjectObject(ActiveItem, none), "[tcohen] Use() was called on the PlayerController.  But either the Pawn is None, the Pawn has no ActiveItem, or the Pawn's ActiveItem is not a HandheldEquipment.");
	if(Not_PreBool(ActiveItem.IsIdle()))
	{
		return;
	}
	ActiveItem.super(PlayerController).Use();
	return;
}

function ServerUse()
{
	local Actor A;

	if(EqualEqual_ObjectObject(Level.Pauser, PlayerReplicationInfo))
	{
		SetPause(false);
		return;
	}
	if(EqualEqual_ObjectObject(Pawn, none))
	{
		return;
	}
	foreach Pawn.TouchingActors(Class'Engine.Actor', A)
	{
		A.UsedBy(Pawn);
	}
	return;
}

exec function Suicide()
{
	if(AndAnd_BoolBool(NotEqual_ObjectObject(Pawn, none), Greater_FloatFloat(Subtract_FloatFloat(Level.TimeSeconds, Pawn.LastStartTime), float(1))))
	{
		Pawn.KilledBy(Pawn);
	}
	return;
}

exec function Name(coerce string S)
{
	SetName(S);
	return;
}

exec function Assert()
{
	assert(false);
	return;
}

exec function SetName(coerce string S)
{
	ChangeName(S);
	UpdateURL("Name", S, true);
	SaveConfig();
	return;
}

function ChangeName(coerce string S)
{
	if(Greater_IntInt(Len(S), 20))
	{
		S = Left(S, 20);
	}
	ReplaceText(S, " ", "_");
	Level.Game.ChangeName(self, S, true);
	return;
}

exec function SwitchTeam()
{
	if(OrOr_BoolBool(EqualEqual_ObjectObject(PlayerReplicationInfo.Team, none), EqualEqual_IntInt(PlayerReplicationInfo.Team.TeamIndex, 1)))
	{
		ChangeTeam(0);
	}
	else
	{
		ChangeTeam(1);
	}
	return;
}

exec function ChangeTeam(int n)
{
	local TeamInfo OldTeam;

	OldTeam = PlayerReplicationInfo.Team;
	Level.Game.ChangeTeam(self, n, true);
	if(AndAnd_BoolBool(Level.Game.bTeamGame, NotEqual_ObjectObject(PlayerReplicationInfo.Team, OldTeam)))
	{
		if(NotEqual_ObjectObject(Pawn, none))
		{
			Pawn.Died(none, Class'Engine.DamageType', Pawn.Location, vect(0.0000000, 0.0000000, 0.0000000));
		}
	}
	return;
}

exec function SwitchLevel(string URL)
{
	Log(Concat_StrStr("In PlayerController::SwitchLevel. URL=", URL));
	if(OrOr_BoolBool(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)), EqualEqual_IntInt(int(Level.NetMode), int(NM_ListenServer))))
	{
		Level.ServerTravel(URL, false);
	}
	return;
}

exec function ClearProgressMessages()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, 4))
	{
		ProgressMessage[i] = "";
		ProgressColor[i] = Class'Engine.Canvas'.static.MakeColor(byte(255), byte(255), byte(255));
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

exec event SetProgressMessage(int Index, string S, Color C)
{
	if(Less_IntInt(Index, 4))
	{
		ProgressMessage[Index] = S;
		ProgressColor[Index] = C;
	}
	return;
}

exec event SetProgressTime(float t)
{
	ProgressTimeOut = Add_FloatFloat(t, Level.TimeSeconds);
	return;
}

function Restart()
{
	super.Restart();
	ServerTimeStamp = 0.0000000;
	TimeMargin = 0.0000000;
	EnterStartState();
	SetViewTarget(Pawn);
	bBehindView = Pawn.PointOfView();
	ClientRestart();
	return;
}

function EnterStartState()
{
	local name NewState;

	if(Pawn.PhysicsVolume.bWaterVolume)
	{
		NewState = Pawn.WaterMovementState;
	}
	else
	{
		NewState = Pawn.LandMovementState;
	}
	if(IsInState(NewState))
	{
		BeginState();
	}
	else
	{
		GotoState(NewState);
	}
	return;
}

function ClientRestart()
{
	MPLog(Concat_StrStr(string(self), "---PlayerController::ClientRestart()."));
	if(AndAnd_BoolBool(NotEqual_ObjectObject(Pawn, none), Pawn.bTearOff))
	{
		Pawn.Controller = none;
		Pawn = none;
	}
	if(EqualEqual_ObjectObject(Pawn, none))
	{
		GotoState('WaitingForPawn');
		return;
	}
	Pawn.ClientRestart();
	SetViewTarget(Pawn);
	bBehindView = Pawn.PointOfView();
	CleanOutSavedMoves();
	bDuck = 0;
	bRun = 0;
	bLeanLeft = 0;
	bLeanRight = 0;
	bIgnoreNextRunRelease = true;
	bIgnoreNextCrouchRelease = true;
	EnterStartState();
	return;
}

exec function BehindView(bool B)
{
	if(OrOr_BoolBool(OrOr_BoolBool(OrOr_BoolBool(OrOr_BoolBool(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)), Level.Game.bAllowBehindView), PlayerReplicationInfo.bOnlySpectator), PlayerReplicationInfo.bAdmin), IsA('Admin')))
	{
		bBehindView = B;
		ClientSetBehindView(bBehindView);
	}
	return;
}

exec function ToggleBehindView()
{
	ServerToggleBehindView();
	return;
}

function ServerToggleBehindView()
{
	bBehindView = Not_PreBool(bBehindView);
	ClientSetBehindView(bBehindView);
	return;
}

event TravelPostAccept()
{
	if(LessEqual_IntInt(Pawn.Health, 0))
	{
		Pawn.Health = Pawn.default.Health;
	}
	return;
}

event PlayerTick(float DeltaTime)
{
	LastDeltaTime = DeltaTime;
	PlayerInput.PlayerInput(DeltaTime);
	if(bUpdatePosition)
	{
		ClientUpdatePosition();
	}
	PlayerMove(DeltaTime);
	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Client)))
	{
		if(Not_PreBool(bAlreadyNotifiedLevelOfGameStarted))
		{
			MPLog("Notifying gamestarted");
			bAlreadyNotifiedLevelOfGameStarted = true;
			Level.NotifyGameStarted();
		}
	}
	return;
}

function PlayerMove(float DeltaTime)
{
	return;
}

function bool NotifyLanded(Vector HitNormal)
{
	return bUpdating;
	return;
}

function AdjustView(float DeltaTime)
{
	return;
}

function CalcBehindView(out Vector CameraLocation, out Rotator CameraRotation, float dist)
{
	local Vector View, HitLocation, HitNormal;
	local float ViewDist, RealDist;

	CameraRotation = Rotation;
	if(bBlockCloseCamera)
	{
		AddEqual_FloatFloat(CameraLocation.Z, float(12));
	}
	View = GreaterGreater_VectorRotator(vect(1.0000000, 0.0000000, 0.0000000), CameraRotation);
	RealDist = dist;
	if(NotEqual_ObjectObject(Trace(HitLocation, HitNormal, Subtract_VectorVector(CameraLocation, Multiply_FloatVector(dist, Vector(CameraRotation))), CameraLocation, false, vect(10.0000000, 10.0000000, 10.0000000)), none))
	{
		ViewDist = FMin(Dot_VectorVector(Subtract_VectorVector(CameraLocation, HitLocation), View), dist);
	}
	else
	{
		ViewDist = dist;
	}
	if(OrOr_BoolBool(OrOr_BoolBool(Not_PreBool(bBlockCloseCamera), Not_PreBool(bValidBehindCamera)), Greater_FloatFloat(ViewDist, Add_FloatFloat(float(10), FMax(ViewTarget.CollisionRadius, ViewTarget.CollisionHeight)))))
	{
		bValidBehindCamera = true;
		OldCameraLoc = Subtract_VectorVector(CameraLocation, Multiply_FloatVector(ViewDist, View));
		OldCameraRot = CameraRotation;
	}
	else
	{
		SetRotation(OldCameraRot);
	}
	CameraLocation = OldCameraLoc;
	CameraRotation = OldCameraRot;
	return;
}

function CalcFirstPersonView(out Vector CameraLocation, out Rotator CameraRotation)
{
	CameraRotation = Add_RotatorRotator(Rotation, Pawn.ViewRotationOffset());
	CameraLocation = Add_VectorVector(Add_VectorVector(CameraLocation, Pawn.EyePosition()), Pawn.ViewLocationOffset(CameraRotation));
	return;
}

event AddCameraEffect(CameraEffect NewEffect, bool UniqueClass, bool UniqueObject, bool RemoveConflicting)
{
	local int i;

	if(UniqueClass)
	{
		i = 0;
		J0x10:

		if(Less_IntInt(i, CameraEffects.Length))
		{
			J0x20:

			if(EqualEqual_ObjectObject(CameraEffects[i].Class, NewEffect.Class))
			{
				if(Not_PreBool(RemoveConflicting))
				{
					return;
				}
				CameraEffects[i].OnRemoved();
				CameraEffects.Remove(i, 1);
				if(GreaterEqual_IntInt(i, CameraEffects.Length))
				{
					// [Explicit Break]
					goto J0x8B;
				}
				// [Loop Continue]
				goto J0x20;
			}
			J0x8B:

			AddAdd_PreInt(i);
			// [Loop Continue]
			goto J0x10;
		}
	}
	else
	{
		if(UniqueObject)
		{
			i = 0;
			J0xA8:

			if(Less_IntInt(i, CameraEffects.Length))
			{
				J0xB8:

				if(EqualEqual_ObjectObject(CameraEffects[i], NewEffect))
				{
					if(Not_PreBool(RemoveConflicting))
					{
						return;
					}
					CameraEffects[i].OnRemoved();
					CameraEffects.Remove(i, 1);
					if(GreaterEqual_IntInt(i, CameraEffects.Length))
					{
						// [Explicit Break]
						goto J0x111;
					}
					// [Loop Continue]
					goto J0xB8;
				}
				J0x111:

				AddAdd_PreInt(i);
				// [Loop Continue]
				goto J0xA8;
			}
		}
	}
	CameraEffects[CameraEffects.Length] = NewEffect;
	NewEffect.OnAdded();
	return;
}

event RemoveCameraEffect(CameraEffect ExEffect, optional bool ByClass)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, CameraEffects.Length))
	{
		J0x17:

		if(OrOr_BoolBool(AndAnd_BoolBool(Not_PreBool(ByClass), EqualEqual_ObjectObject(CameraEffects[i], ExEffect)), AndAnd_BoolBool(ByClass, EqualEqual_ObjectObject(CameraEffects[i].Class, ExEffect.Class))))
		{
			CameraEffects[i].OnRemoved();
			CameraEffects.Remove(i, 1);
			if(GreaterEqual_IntInt(i, CameraEffects.Length))
			{
				// [Explicit Break]
				goto J0xA4;
			}
			// [Loop Continue]
			goto J0x17;
		}
		J0xA4:

		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

function RemoveAllCameraEffects()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, CameraEffects.Length))
	{
		CameraEffects[i].OnRemoved();
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	CameraEffects.Remove(0, CameraEffects.Length);
	return;
}

simulated function Rotator GetViewRotation()
{
	if(AndAnd_BoolBool(bBehindView, NotEqual_ObjectObject(Pawn, none)))
	{
		return Pawn.Rotation;
	}
	return Rotation;
	return;
}

event PlayerCalcView(out Actor ViewActor, out Vector CameraLocation, out Rotator CameraRotation)
{
	local Pawn PTarget;

	if(AndAnd_BoolBool(NotEqual_ObjectObject(Pawn, none), Pawn.bSpecialCalcView))
	{
		if(Pawn.SpecialCalcView(ViewActor, CameraLocation, CameraRotation))
		{
			return;
		}
	}
	if(OrOr_BoolBool(EqualEqual_ObjectObject(ViewTarget, none), ViewTarget.bDeleteMe))
	{
		if(AndAnd_BoolBool(bViewBot, NotEqual_ObjectObject(CheatManager, none)))
		{
			CheatManager.ViewBot();
		}
		else
		{
			if(AndAnd_BoolBool(NotEqual_ObjectObject(Pawn, none), Not_PreBool(Pawn.bDeleteMe)))
			{
				SetViewTarget(Pawn);
			}
			else
			{
				if(NotEqual_ObjectObject(RealViewTarget, none))
				{
					SetViewTarget(RealViewTarget);
				}
				else
				{
					SetViewTarget(self);
				}
			}
		}
	}
	ViewActor = ViewTarget;
	CameraLocation = ViewTarget.Location;
	if(EqualEqual_ObjectObject(ViewTarget, Pawn))
	{
		if(bBehindView)
		{
			CalcBehindView(CameraLocation, CameraRotation, Multiply_FloatFloat(CameraDist, Pawn.default.CollisionRadius));
		}
		else
		{
			CalcFirstPersonView(CameraLocation, CameraRotation);
		}
		return;
	}
	if(EqualEqual_ObjectObject(ViewTarget, self))
	{
		if(bCameraPositionLocked)
		{
			CameraRotation = CheatManager.LockedRotation;
		}
		else
		{
			CameraRotation = Rotation;
		}
		return;
	}
	if(AndAnd_BoolBool(ViewTarget.IsA('Projectile'), Not_PreBool(bBehindView)))
	{
		AddEqual_VectorVector(CameraLocation, Multiply_FloatVector(ViewTarget.CollisionHeight, vect(0.0000000, 0.0000000, 1.0000000)));
		CameraRotation = Rotation;
		return;
	}
	CameraRotation = ViewTarget.Rotation;
	PTarget = Pawn(ViewTarget);
	if(NotEqual_ObjectObject(PTarget, none))
	{
		if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Client)))
		{
			PTarget.SetViewLocation(TargetViewLocation);
			PTarget.SetViewRotation(TargetViewRotation);
			CameraRotation = BlendedTargetViewRotation;
		}
		else
		{
			if(PTarget.IsPlayerPawn())
			{
				CameraRotation = PTarget.GetViewRotation();
			}
		}
		if(Not_PreBool(bBehindView))
		{
			AddEqual_VectorVector(CameraLocation, PTarget.EyePosition());
		}
	}
	if(bBehindView)
	{
		CameraLocation = Add_VectorVector(CameraLocation, Multiply_FloatVector(Subtract_FloatFloat(ViewTarget.default.CollisionHeight, ViewTarget.CollisionHeight), vect(0.0000000, 0.0000000, 1.0000000)));
		CalcBehindView(CameraLocation, CameraRotation, Multiply_FloatFloat(CameraDist, ViewTarget.default.CollisionRadius));
	}
	return;
}

function int BlendRot(float DeltaTime, int BlendC, int NewC)
{
	if(Greater_FloatFloat(Abs(float(Subtract_IntInt(BlendC, NewC))), float(32767)))
	{
		if(Greater_IntInt(BlendC, NewC))
		{
			AddEqual_IntInt(NewC, 65536);
		}
		else
		{
			AddEqual_IntInt(BlendC, 65536);
		}
	}
	if(Greater_FloatFloat(Abs(float(Subtract_IntInt(BlendC, NewC))), float(4096)))
	{
		BlendC = NewC;
	}
	else
	{
		BlendC = int(Add_FloatFloat(float(BlendC), Multiply_FloatFloat(float(Subtract_IntInt(NewC, BlendC)), FMin(1.0000000, Multiply_FloatFloat(24.0000000, DeltaTime)))));
	}
	return And_IntInt(BlendC, 65535);
	return;
}

function CheckShake(out float MaxOffset, out float Offset, out float Rate, out float Time)
{
	if(Less_FloatFloat(Abs(Offset), Abs(MaxOffset)))
	{
		return;
	}
	Offset = MaxOffset;
	if(Greater_FloatFloat(Time, float(1)))
	{
		if(LessEqual_FloatFloat(Multiply_FloatFloat(Time, Abs(Divide_FloatFloat(MaxOffset, Rate))), float(1)))
		{
			MaxOffset = Multiply_FloatFloat(MaxOffset, Subtract_FloatFloat(Divide_FloatFloat(float(1), Time), float(1)));
		}
		else
		{
			MultiplyEqual_FloatFloat(MaxOffset, float(-1));
		}
		SubtractEqual_FloatFloat(Time, float(1));
		MultiplyEqual_FloatFloat(Rate, float(-1));
	}
	else
	{
		MaxOffset = 0.0000000;
		Offset = 0.0000000;
		Rate = 0.0000000;
	}
	return;
}

function ViewShake(float DeltaTime)
{
	local Rotator ViewRotation;
	local float FRoll;

	if(NotEqual_VectorVector(ShakeOffsetRate, vect(0.0000000, 0.0000000, 0.0000000)))
	{
		AddEqual_FloatFloat(ShakeOffset.X, Multiply_FloatFloat(DeltaTime, ShakeOffsetRate.X));
		CheckShake(MaxShakeOffset.X, ShakeOffset.X, ShakeOffsetRate.X, ShakeOffsetTime.X);
		AddEqual_FloatFloat(ShakeOffset.Y, Multiply_FloatFloat(DeltaTime, ShakeOffsetRate.Y));
		CheckShake(MaxShakeOffset.Y, ShakeOffset.Y, ShakeOffsetRate.Y, ShakeOffsetTime.Y);
		AddEqual_FloatFloat(ShakeOffset.Z, Multiply_FloatFloat(DeltaTime, ShakeOffsetRate.Z));
		CheckShake(MaxShakeOffset.Z, ShakeOffset.Z, ShakeOffsetRate.Z, ShakeOffsetTime.Z);
	}
	ViewRotation = Rotation;
	if(NotEqual_FloatFloat(ShakeRollRate, float(0)))
	{
		ViewRotation.Roll = And_IntInt(int(Add_FloatFloat(float(And_IntInt(ViewRotation.Roll, 65535)), Multiply_FloatFloat(ShakeRollRate, DeltaTime))), 65535);
		if(Greater_IntInt(ViewRotation.Roll, 32768))
		{
			SubtractEqual_IntInt(ViewRotation.Roll, 65536);
		}
		FRoll = float(ViewRotation.Roll);
		CheckShake(MaxShakeRoll, FRoll, ShakeRollRate, ShakeRollTime);
		ViewRotation.Roll = int(FRoll);
	}
	else
	{
		if(bZeroRoll)
		{
			ViewRotation.Roll = 0;
		}
	}
	SetRotation(ViewRotation);
	return;
}

function bool TurnTowardNearestEnemy()
{
	return;
}

function TurnAround()
{
	if(Not_PreBool(bSetTurnRot))
	{
		TurnRot180 = Rotation;
		AddEqual_IntInt(TurnRot180.Yaw, 32768);
		bSetTurnRot = true;
	}
	DesiredRotation = TurnRot180;
	bRotateToDesired = NotEqual_IntInt(DesiredRotation.Yaw, Rotation.Yaw);
	return;
}

function UpdateRotation(float DeltaTime, float maxPitch)
{
	local Rotator NewRotation, ViewRotation;
	local int LeftYawLimit, RightYawLimit, ViewYawRelativeToLockedYaw;
	local float YawEdgeAlpha;

	if(OrOr_BoolBool(bInterpolating, AndAnd_BoolBool(NotEqual_ObjectObject(Pawn, none), Pawn.bInterpolating)))
	{
		ViewShake(DeltaTime);
		return;
	}
	ViewRotation = Rotation;
	DesiredRotation = ViewRotation;
	if(NotEqual_IntInt(int(bTurnToNearest), 0))
	{
		TurnTowardNearestEnemy();
	}
	else
	{
		if(NotEqual_IntInt(int(bTurn180), 0))
		{
			TurnAround();
		}
		else
		{
			TurnTarget = none;
			bRotateToDesired = false;
			bSetTurnRot = false;
			AddEqual_IntInt(ViewRotation.Yaw, int(Multiply_FloatFloat(Multiply_FloatFloat(32.0000000, DeltaTime), aTurn)));
			AddEqual_IntInt(ViewRotation.Pitch, int(Multiply_FloatFloat(Multiply_FloatFloat(32.0000000, DeltaTime), aLookUp)));
		}
	}
	ViewRotation.Pitch = And_IntInt(ViewRotation.Pitch, 65535);
	if(AndAnd_BoolBool(Greater_IntInt(ViewRotation.Pitch, 18000), Less_IntInt(ViewRotation.Pitch, 49152)))
	{
		if(Greater_FloatFloat(aLookUp, float(0)))
		{
			ViewRotation.Pitch = 18000;
		}
		else
		{
			ViewRotation.Pitch = 49152;
		}
	}
	if(AndAnd_BoolBool(NotEqual_ObjectObject(Pawn, none), NotEqual_IntInt(int(Pawn.LeanState), int(0))))
	{
		ViewYawRelativeToLockedYaw = WrapAngle0To2Pi(Subtract_IntInt(ViewRotation.Yaw, Pawn.LeanLockedYaw));
		YawEdgeAlpha = Pawn.GetYawEdgeAlpha(ViewRotation.Pitch);
		Pawn.GetLeanYawRanges(LeftYawLimit, RightYawLimit);
		LeftYawLimit = WrapAngle0To2Pi(int(Subtract_FloatFloat(float(65536), Multiply_FloatFloat(float(LeftYawLimit), YawEdgeAlpha))));
		RightYawLimit = WrapAngle0To2Pi(int(Multiply_FloatFloat(float(RightYawLimit), YawEdgeAlpha)));
		if(AndAnd_BoolBool(Greater_IntInt(ViewYawRelativeToLockedYaw, RightYawLimit), LessEqual_IntInt(ViewYawRelativeToLockedYaw, 32768)))
		{
			ViewRotation.Yaw = Add_IntInt(Pawn.LeanLockedYaw, RightYawLimit);
		}
		else
		{
			if(AndAnd_BoolBool(Less_IntInt(ViewYawRelativeToLockedYaw, LeftYawLimit), Greater_IntInt(ViewYawRelativeToLockedYaw, 32768)))
			{
				ViewRotation.Yaw = Add_IntInt(Pawn.LeanLockedYaw, LeftYawLimit);
			}
		}
	}
	SetRotation(ViewRotation);
	ViewShake(DeltaTime);
	ViewFlash(DeltaTime);
	NewRotation = ViewRotation;
	NewRotation.Roll = Rotation.Roll;
	if(AndAnd_BoolBool(AndAnd_BoolBool(Not_PreBool(bRotateToDesired), NotEqual_ObjectObject(Pawn, none)), OrOr_BoolBool(Not_PreBool(bFreeCamera), Not_PreBool(bBehindView))))
	{
		Pawn.FaceRotation(NewRotation);
	}
	return;
}

function ClearDoubleClick()
{
	if(NotEqual_ObjectObject(PlayerInput, none))
	{
		PlayerInput.DoubleClickTimer = 0.0000000;
	}
	return;
}

function bool IsSpectating()
{
	return false;
	return;
}

function ServerViewNextPlayer()
{
	local Controller C, Pick;
	local bool bFound, bRealSpec, bWasSpec;
	local TeamInfo RealTeam;

	bRealSpec = PlayerReplicationInfo.bOnlySpectator;
	bWasSpec = AndAnd_BoolBool(AndAnd_BoolBool(Not_PreBool(bBehindView), NotEqual_ObjectObject(ViewTarget, Pawn)), NotEqual_ObjectObject(ViewTarget, self));
	PlayerReplicationInfo.bOnlySpectator = true;
	RealTeam = PlayerReplicationInfo.Team;
	C = Level.ControllerList;
	J0x7C:

	if(NotEqual_ObjectObject(C, none))
	{
		if(Level.Game.CanSpectate(self, true, C))
		{
			if(EqualEqual_ObjectObject(Pick, none))
			{
				Pick = C;
			}
			if(bFound)
			{
				Pick = C;
				// [Explicit Break]
				goto J0x114;
			}
			else
			{
				bFound = OrOr_BoolBool(EqualEqual_ObjectObject(RealViewTarget, C), EqualEqual_ObjectObject(ViewTarget, C));
			}
		}
		C = C.nextController;
		// [Loop Continue]
		goto J0x7C;
	}
	J0x114:

	PlayerReplicationInfo.Team = RealTeam;
	SetViewTarget(Pick);
	ClientSetViewTarget(Pick);
	if(OrOr_BoolBool(EqualEqual_ObjectObject(ViewTarget, self), bWasSpec))
	{
		bBehindView = false;
	}
	else
	{
		bBehindView = true;
	}
	ClientSetBehindView(bBehindView);
	PlayerReplicationInfo.bOnlySpectator = bRealSpec;
	return;
}

function ServerViewSelf()
{
	bBehindView = false;
	SetViewTarget(self);
	ClientSetViewTarget(self);
	ClientMessage(OwnCamera, 'DebugMessage');
	return;
}

function LoadPlayers()
{
	local int i;

	if(EqualEqual_ObjectObject(GameReplicationInfo, none))
	{
		return;
	}
	i = 0;
	J0x14:

	if(Less_IntInt(i, GameReplicationInfo.PRIArray.Length))
	{
		GameReplicationInfo.PRIArray[i].UpdatePrecacheRenderData();
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x14;
	}
	return;
}

function FindGoodView()
{
	local Vector cameraLoc;
	local Rotator cameraRot, ViewRotation;
	local int tries, besttry;
	local float bestDist, newdist;
	local int startYaw;
	local Actor ViewActor;

	ViewRotation = Rotation;
	ViewRotation.Pitch = 56000;
	tries = 0;
	besttry = 0;
	bestDist = 0.0000000;
	startYaw = ViewRotation.Yaw;
	tries = 0;
	J0x4B:

	if(Less_IntInt(tries, 16))
	{
		cameraLoc = ViewTarget.Location;
		SetRotation(ViewRotation);
		PlayerCalcView(ViewActor, cameraLoc, cameraRot);
		newdist = VSize(Subtract_VectorVector(cameraLoc, ViewTarget.Location));
		if(Greater_FloatFloat(newdist, bestDist))
		{
			bestDist = newdist;
			besttry = tries;
		}
		AddEqual_IntInt(ViewRotation.Yaw, 4096);
		AddAdd_Int(tries);
		// [Loop Continue]
		goto J0x4B;
	}
	ViewRotation.Yaw = Add_IntInt(startYaw, Multiply_IntInt(besttry, 4096));
	SetRotation(ViewRotation);
	return;
}

function ChangeStairLook(bool B)
{
	bLookUpStairs = B;
	if(bLookUpStairs)
	{
		bAlwaysMouseLook = false;
	}
	return;
}

function ChangeAlwaysMouseLook(bool B)
{
	bAlwaysMouseLook = B;
	if(bAlwaysMouseLook)
	{
		bLookUpStairs = false;
	}
	return;
}

event ClientOpenMenu(string MenuClass, optional string MenuName, optional bool bDisconnect, optional string Msg1, optional string Msg2, optional int Msg3)
{
	Player.GUIController.OpenMenu(MenuClass, MenuName, Msg1, Msg2, Msg3);
	if(bDisconnect)
	{
		ConsoleCommand("Disconnect");
	}
	return;
}

event ClientCloseMenu(optional bool bCloseAll)
{
	if(bCloseAll)
	{
		Player.GUIController.CloseAll();
	}
	else
	{
		Player.GUIController.CloseMenu();
	}
	return;
}

function bool CanRestartPlayer()
{
	return Not_PreBool(PlayerReplicationInfo.bOnlySpectator);
	return;
}

event ServerChangeVoiceChatter(PlayerController Player, int IpAddr, int Handle, bool Add)
{
	if(OrOr_BoolBool(EqualEqual_IntInt(int(Level.NetMode), int(NM_DedicatedServer)), EqualEqual_IntInt(int(Level.NetMode), int(NM_ListenServer))))
	{
		Level.Game.ChangeVoiceChatter(Player, IpAddr, Handle, Add);
	}
	return;
}

event ServerGetVoiceChatters(PlayerController Player)
{
	local int i;

	if(OrOr_BoolBool(EqualEqual_IntInt(int(Level.NetMode), int(NM_DedicatedServer)), EqualEqual_IntInt(int(Level.NetMode), int(NM_ListenServer))))
	{
		i = 0;
		J0x3B:

		if(Less_IntInt(i, Level.Game.VoiceChatters.Length))
		{
			if(NotEqual_ObjectObject(Player, Level.Game.VoiceChatters[i].Controller))
			{
				Player.ClientChangeVoiceChatter(Level.Game.VoiceChatters[i].IpAddr, Level.Game.VoiceChatters[i].Handle, true);
			}
			AddAdd_Int(i);
			// [Loop Continue]
			goto J0x3B;
		}
	}
	return;
}

simulated function ClientChangeVoiceChatter(int IpAddr, int Handle, bool Add)
{
	ChangeVoiceChatter(IpAddr, Handle, Add);
	return;
}

simulated function ClientLeaveVoiceChat()
{
	LeaveVoiceChat();
	return;
}

// Export UPlayerController::execLeaveVoiceChat(FFrame&, void* const)
native final function LeaveVoiceChat();

// Export UPlayerController::execChangeVoiceChatter(FFrame&, void* const)
native final function ChangeVoiceChatter(int IpAddr, int Handle, bool Add);

simulated event StartClientDemoRec()
{
	DemoClientSetHUD(myHUD.Class, myHUD.ScoreBoard.Class);
	bClientDemo = true;
	ServerSetClientDemo();
	return;
}

function ServerSetClientDemo()
{
	bClientDemo = true;
	return;
}

simulated function DemoClientSetHUD(Class<HUD> newHUDClass, Class<ScoreBoard> newScoringClass)
{
	if(EqualEqual_ObjectObject(myHUD, none))
	{
		ClientSetHUD(newHUDClass, newScoringClass);
	}
	return;
}

function ServerUTrace()
{
	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
	{
		return;
	}
	UTrace();
	return;
}

exec function UTrace()
{
	ConsoleCommand("HideLog");
	if(NotEqual_IntInt(int(Role), int(ROLE_Authority)))
	{
		ServerUTrace();
	}
	SetUTracing(Not_PreBool(IsUTracing()));
	Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("UTracing changed to ", string(IsUTracing())), " at "), string(Level.TimeSeconds)));
	return;
}

// Export UPlayerController::execGetLookAroundSpeed(FFrame&, void* const)
native simulated event float GetLookAroundSpeed();

function AddRecoil(float RecoilBackTime, float RecoilForeTime, float RecoilMagnitude, optional float AutoFireRecoilMagnitudeIncrement, optional int AutoFireShotIndex)
{
	return;
}

function int GetSwatPlayerID()
{
	assert(false);
	return 0;
	return;
}

function bool HandsShouldIdle()
{
	assert(false);
	return false;
	return;
}

function InputOffset(out float aForward, out float aStrafe)
{
	return;
}

function OnMissionExitDoorUsed()
{
	Player.GUIController.OpenMenu("SwatGui.SwatMissionAbortMenu", "SwatMissionAbortMenu");
	return;
}

exec function ToggleRunning(bool bRelease)
{
	if(AndAnd_BoolBool(bRelease, bIgnoreNextRunRelease))
	{
		return;
	}
	bIgnoreNextRunRelease = false;
	if(EqualEqual_IntInt(int(bRun), 0))
	{
		bRun = 1;
	}
	else
	{
		bRun = 0;
	}
	return;
}

exec function ToggleCrouching(bool bRelease)
{
	if(AndAnd_BoolBool(bRelease, bIgnoreNextCrouchRelease))
	{
		return;
	}
	bIgnoreNextCrouchRelease = false;
	if(EqualEqual_IntInt(int(bDuck), 0))
	{
		bDuck = 1;
	}
	else
	{
		bDuck = 0;
	}
	return;
}

exec function Suppress(string NameToSuppress)
{
	SuppressName(string(NameToSuppress));
	return;
}

// Export UPlayerController::execSuppressName(FFrame&, void* const)
native function SuppressName(name NameToSuppress);

state PlayerWalking
{
	function bool NotifyPhysicsVolumeChange(PhysicsVolume NewVolume)
	{
		if(NewVolume.bWaterVolume)
		{
			GotoState(Pawn.WaterMovementState);
		}
		return false;
		return;
	}

	function ProcessMove(float DeltaTime, Vector newAccel, Actor.EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
	{
		local Vector OldAccel;
		local bool OldCrouch;

		if(EqualEqual_ObjectObject(Pawn, none))
		{
			return;
		}
		OldAccel = Pawn.Acceleration;
		Pawn.Acceleration = newAccel;
		if(AndAnd_BoolBool(bDoubleJump, OrOr_BoolBool(bUpdating, Pawn.CanDoubleJump())))
		{
			Pawn.DoDoubleJump(bUpdating);
		}
		else
		{
			if(bPressedJump)
			{
				Pawn.DoJump(bUpdating);
			}
		}
		if(NotEqual_IntInt(int(Pawn.Physics), int(2)))
		{
			OldCrouch = Pawn.bWantsToCrouch;
			if(EqualEqual_IntInt(int(bDuck), 0))
			{
				Pawn.ShouldCrouch(false);
			}
			else
			{
				if(Pawn.bCanCrouch)
				{
					Pawn.ShouldCrouch(true);
				}
			}
			if(EqualEqual_IntInt(int(bLeanLeft), 0))
			{
				Pawn.ShouldLeanLeft(false);
			}
			else
			{
				Pawn.ShouldLeanLeft(true);
			}
			if(EqualEqual_IntInt(int(bLeanRight), 0))
			{
				Pawn.ShouldLeanRight(false);
			}
			else
			{
				Pawn.ShouldLeanRight(true);
			}
		}
		return;
	}

	function PlayerMove(float DeltaTime)
	{
		local Vector X, Y, Z, newAccel;
		local Actor.EDoubleClickDir DoubleClickMove;
		local Rotator OldRotation, ViewRotation;
		local bool bSaveJump;

		GetAxes(Pawn.Rotation, X, Y, Z);
		newAccel = Add_VectorVector(Multiply_FloatVector(aForward, X), Multiply_FloatVector(aStrafe, Y));
		newAccel.Z = 0.0000000;
		if(Less_FloatFloat(VSize(newAccel), 1.0000000))
		{
			newAccel = vect(0.0000000, 0.0000000, 0.0000000);
		}
		DoubleClickMove = PlayerInput.CheckForDoubleClickMove(DeltaTime);
		GroundPitch = 0;
		ViewRotation = Rotation;
		if(EqualEqual_IntInt(int(Pawn.Physics), int(1)))
		{
			if(AndAnd_BoolBool(EqualEqual_IntInt(int(bLook), 0), OrOr_BoolBool(AndAnd_BoolBool(NotEqual_VectorVector(Pawn.Acceleration, vect(0.0000000, 0.0000000, 0.0000000)), bSnapToLevel), Not_PreBool(bKeyboardLook))))
			{
				if(OrOr_BoolBool(bLookUpStairs, bSnapToLevel))
				{
					GroundPitch = FindStairRotation(DeltaTime);
					ViewRotation.Pitch = GroundPitch;
				}
				else
				{
					if(bCenterView)
					{
						ViewRotation.Pitch = And_IntInt(ViewRotation.Pitch, 65535);
						if(Greater_IntInt(ViewRotation.Pitch, 32768))
						{
							SubtractEqual_IntInt(ViewRotation.Pitch, 65536);
						}
						ViewRotation.Pitch = int(Multiply_FloatFloat(float(ViewRotation.Pitch), Subtract_FloatFloat(float(1), Multiply_FloatFloat(float(12), FMin(0.0833000, DeltaTime)))));
						if(Less_FloatFloat(Abs(float(ViewRotation.Pitch)), float(200)))
						{
							ViewRotation.Pitch = 0;
						}
					}
				}
			}
		}
		else
		{
			if(AndAnd_BoolBool(AndAnd_BoolBool(Not_PreBool(bKeyboardLook), EqualEqual_IntInt(int(bLook), 0)), bCenterView))
			{
				ViewRotation.Pitch = And_IntInt(ViewRotation.Pitch, 65535);
				if(Greater_IntInt(ViewRotation.Pitch, 32768))
				{
					SubtractEqual_IntInt(ViewRotation.Pitch, 65536);
				}
				ViewRotation.Pitch = int(Multiply_FloatFloat(float(ViewRotation.Pitch), Subtract_FloatFloat(float(1), Multiply_FloatFloat(float(12), FMin(0.0833000, DeltaTime)))));
				if(Less_FloatFloat(Abs(float(ViewRotation.Pitch)), float(200)))
				{
					ViewRotation.Pitch = 0;
				}
			}
		}
		Pawn.CheckBob(DeltaTime, Y);
		SetRotation(ViewRotation);
		OldRotation = Rotation;
		UpdateRotation(DeltaTime, 1.0000000);
		bDoubleJump = false;
		if(AndAnd_BoolBool(bPressedJump, Pawn.CannotJumpNow()))
		{
			bSaveJump = true;
			bPressedJump = false;
		}
		else
		{
			bSaveJump = false;
		}
		if(Less_IntInt(int(Role), int(ROLE_Authority)))
		{
			ReplicateMove(DeltaTime, newAccel, DoubleClickMove, Subtract_RotatorRotator(OldRotation, Rotation));
		}
		else
		{
			ProcessMove(DeltaTime, newAccel, DoubleClickMove, Subtract_RotatorRotator(OldRotation, Rotation));
		}
		bPressedJump = bSaveJump;
		return;
	}

	function BeginState()
	{
		DoubleClickDir = 0;
		bPressedJump = false;
		GroundPitch = 0;
		if(NotEqual_ObjectObject(Pawn, none))
		{
			if(EqualEqual_ObjectObject(Pawn.Mesh, none))
			{
				Pawn.SetMesh();
			}
			Pawn.ShouldCrouch(false);
			if(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_IntInt(int(Pawn.Physics), int(2)), NotEqual_IntInt(int(Pawn.Physics), int(13))), NotEqual_IntInt(int(Pawn.Physics), int(15))))
			{
				Pawn.SetPhysics(1);
			}
		}
		return;
	}

	function EndState()
	{
		GroundPitch = 0;
		if(AndAnd_BoolBool(NotEqual_ObjectObject(Pawn, none), EqualEqual_IntInt(int(bDuck), 0)))
		{
			Pawn.ShouldCrouch(false);
		}
		return;
	}
Begin:

	stop;
}

state PlayerClimbing
{
	function bool NotifyPhysicsVolumeChange(PhysicsVolume NewVolume)
	{
		if(NewVolume.bWaterVolume)
		{
			GotoState(Pawn.WaterMovementState);
		}
		else
		{
			GotoState(Pawn.LandMovementState);
		}
		return false;
		return;
	}

	function ProcessMove(float DeltaTime, Vector newAccel, Actor.EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
	{
		local Vector OldAccel;

		OldAccel = Pawn.Acceleration;
		Pawn.Acceleration = newAccel;
		if(bPressedJump)
		{
			Pawn.DoJump(bUpdating);
			if(EqualEqual_IntInt(int(Pawn.Physics), int(2)))
			{
				GotoState('PlayerWalking');
			}
		}
		return;
	}

	function PlayerMove(float DeltaTime)
	{
		local Vector X, Y, Z, newAccel;
		local Actor.EDoubleClickDir DoubleClickMove;
		local Rotator OldRotation, ViewRotation;
		local bool bSaveJump;

		GetAxes(Rotation, X, Y, Z);
		newAccel = Add_VectorVector(Multiply_FloatVector(aForward, X), Multiply_FloatVector(aStrafe, Y));
		if(Less_FloatFloat(VSize(newAccel), 1.0000000))
		{
			newAccel = vect(0.0000000, 0.0000000, 0.0000000);
		}
		ViewRotation = Rotation;
		SetRotation(ViewRotation);
		OldRotation = Rotation;
		UpdateRotation(DeltaTime, 1.0000000);
		if(Less_IntInt(int(Role), int(ROLE_Authority)))
		{
			ReplicateMove(DeltaTime, newAccel, DoubleClickMove, Subtract_RotatorRotator(OldRotation, Rotation));
		}
		else
		{
			ProcessMove(DeltaTime, newAccel, DoubleClickMove, Subtract_RotatorRotator(OldRotation, Rotation));
		}
		bPressedJump = bSaveJump;
		return;
	}

	function BeginState()
	{
		Pawn.ShouldCrouch(false);
		bPressedJump = false;
		return;
	}

	function EndState()
	{
		if(NotEqual_ObjectObject(Pawn, none))
		{
			Pawn.ShouldCrouch(false);
		}
		return;
	}
	stop;
}

state PlayerSpidering
{
	event bool NotifyHitWall(Vector HitNormal, Actor HitActor)
	{
		Pawn.SetPhysics(9);
		Pawn.SetBase(HitActor, HitNormal);
		return true;
		return;
	}

	function UpdateRotation(float DeltaTime, float maxPitch)
	{
		local Rotator ViewRotation;
		local Vector MyFloor, CrossDir, FwdDir, OldFwdDir, OldX, RealFloor;

		if(OrOr_BoolBool(bInterpolating, Pawn.bInterpolating))
		{
			ViewShake(DeltaTime);
			return;
		}
		TurnTarget = none;
		bRotateToDesired = false;
		bSetTurnRot = false;
		if(OrOr_BoolBool(EqualEqual_ObjectObject(Pawn.Base, none), EqualEqual_VectorVector(Pawn.Floor, vect(0.0000000, 0.0000000, 0.0000000))))
		{
			MyFloor = vect(0.0000000, 0.0000000, 1.0000000);
		}
		else
		{
			MyFloor = Pawn.Floor;
		}
		if(NotEqual_VectorVector(MyFloor, OldFloor))
		{
			RealFloor = MyFloor;
			MyFloor = Normal(Add_VectorVector(Multiply_FloatVector(Multiply_FloatFloat(float(6), DeltaTime), MyFloor), Multiply_FloatVector(Subtract_FloatFloat(float(1), Multiply_FloatFloat(float(6), DeltaTime)), OldFloor)));
			if(Greater_FloatFloat(Dot_VectorVector(RealFloor, MyFloor), 0.9990000))
			{
				MyFloor = RealFloor;
			}
			CrossDir = Normal(Cross_VectorVector(RealFloor, OldFloor));
			FwdDir = Cross_VectorVector(CrossDir, MyFloor);
			OldFwdDir = Cross_VectorVector(CrossDir, OldFloor);
			ViewX = Add_VectorVector(Add_VectorVector(Multiply_VectorFloat(MyFloor, Dot_VectorVector(OldFloor, ViewX)), Multiply_VectorFloat(CrossDir, Dot_VectorVector(CrossDir, ViewX))), Multiply_VectorFloat(FwdDir, Dot_VectorVector(OldFwdDir, ViewX)));
			ViewX = Normal(ViewX);
			ViewZ = Add_VectorVector(Add_VectorVector(Multiply_VectorFloat(MyFloor, Dot_VectorVector(OldFloor, ViewZ)), Multiply_VectorFloat(CrossDir, Dot_VectorVector(CrossDir, ViewZ))), Multiply_VectorFloat(FwdDir, Dot_VectorVector(OldFwdDir, ViewZ)));
			ViewZ = Normal(ViewZ);
			OldFloor = MyFloor;
			ViewY = Normal(Cross_VectorVector(MyFloor, ViewX));
		}
		if(OrOr_BoolBool(NotEqual_FloatFloat(aTurn, float(0)), NotEqual_FloatFloat(aLookUp, float(0))))
		{
			if(NotEqual_FloatFloat(aTurn, float(0)))
			{
				ViewX = Normal(Add_VectorVector(ViewX, Multiply_VectorFloat(Multiply_FloatVector(float(2), ViewY), Sin(Multiply_FloatFloat(Multiply_FloatFloat(0.0005000, DeltaTime), aTurn)))));
			}
			if(NotEqual_FloatFloat(aLookUp, float(0)))
			{
				OldX = ViewX;
				ViewX = Normal(Add_VectorVector(ViewX, Multiply_VectorFloat(Multiply_FloatVector(float(2), ViewZ), Sin(Multiply_FloatFloat(Multiply_FloatFloat(0.0005000, DeltaTime), aLookUp)))));
				ViewZ = Normal(Cross_VectorVector(ViewX, ViewY));
				if(Less_FloatFloat(Dot_VectorVector(ViewZ, MyFloor), 0.7070000))
				{
					OldX = Normal(Subtract_VectorVector(OldX, Multiply_VectorFloat(MyFloor, Dot_VectorVector(MyFloor, OldX))));
					if(Greater_FloatFloat(Dot_VectorVector(ViewX, MyFloor), float(0)))
					{
						ViewX = Normal(Add_VectorVector(OldX, MyFloor));
					}
					else
					{
						ViewX = Normal(Subtract_VectorVector(OldX, MyFloor));
					}
					ViewZ = Normal(Cross_VectorVector(ViewX, ViewY));
				}
			}
			ViewY = Normal(Cross_VectorVector(MyFloor, ViewX));
		}
		ViewRotation = OrthoRotation(ViewX, ViewY, ViewZ);
		SetRotation(ViewRotation);
		ViewShake(DeltaTime);
		ViewFlash(DeltaTime);
		Pawn.FaceRotation(ViewRotation);
		return;
	}

	function bool NotifyLanded(Vector HitNormal)
	{
		Pawn.SetPhysics(9);
		return bUpdating;
		return;
	}

	function bool NotifyPhysicsVolumeChange(PhysicsVolume NewVolume)
	{
		if(NewVolume.bWaterVolume)
		{
			GotoState(Pawn.WaterMovementState);
		}
		return false;
		return;
	}

	function ProcessMove(float DeltaTime, Vector newAccel, Actor.EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
	{
		local Vector OldAccel;

		OldAccel = Pawn.Acceleration;
		Pawn.Acceleration = newAccel;
		if(bPressedJump)
		{
			Pawn.DoJump(bUpdating);
		}
		return;
	}

	function PlayerMove(float DeltaTime)
	{
		local Vector newAccel;
		local Actor.EDoubleClickDir DoubleClickMove;
		local Rotator OldRotation, ViewRotation;
		local bool bSaveJump;

		GroundPitch = 0;
		ViewRotation = Rotation;
		if(AndAnd_BoolBool(AndAnd_BoolBool(Not_PreBool(bKeyboardLook), EqualEqual_IntInt(int(bLook), 0)), bCenterView))
		{
		}
		Pawn.CheckBob(DeltaTime, vect(0.0000000, 0.0000000, 0.0000000));
		SetRotation(ViewRotation);
		OldRotation = Rotation;
		UpdateRotation(DeltaTime, 1.0000000);
		newAccel = Add_VectorVector(Multiply_FloatVector(aForward, Normal(Subtract_VectorVector(ViewX, Multiply_VectorFloat(OldFloor, Dot_VectorVector(OldFloor, ViewX))))), Multiply_FloatVector(aStrafe, ViewY));
		if(Less_FloatFloat(VSize(newAccel), 1.0000000))
		{
			newAccel = vect(0.0000000, 0.0000000, 0.0000000);
		}
		if(AndAnd_BoolBool(bPressedJump, Pawn.CannotJumpNow()))
		{
			bSaveJump = true;
			bPressedJump = false;
		}
		else
		{
			bSaveJump = false;
		}
		if(Less_IntInt(int(Role), int(ROLE_Authority)))
		{
			ReplicateMove(DeltaTime, newAccel, DoubleClickMove, Subtract_RotatorRotator(OldRotation, Rotation));
		}
		else
		{
			ProcessMove(DeltaTime, newAccel, DoubleClickMove, Subtract_RotatorRotator(OldRotation, Rotation));
		}
		bPressedJump = bSaveJump;
		return;
	}

	function BeginState()
	{
		if(EqualEqual_ObjectObject(Pawn.Mesh, none))
		{
			Pawn.SetMesh();
		}
		OldFloor = vect(0.0000000, 0.0000000, 1.0000000);
		GetAxes(Rotation, ViewX, ViewY, ViewZ);
		DoubleClickDir = 0;
		Pawn.ShouldCrouch(false);
		bPressedJump = false;
		if(NotEqual_IntInt(int(Pawn.Physics), int(2)))
		{
			Pawn.SetPhysics(9);
		}
		GroundPitch = 0;
		Pawn.bCrawler = true;
		Pawn.SetCollisionSize(Pawn.default.CollisionHeight, Pawn.default.CollisionHeight);
		return;
	}

	function EndState()
	{
		GroundPitch = 0;
		if(NotEqual_ObjectObject(Pawn, none))
		{
			Pawn.SetCollisionSize(Pawn.default.CollisionRadius, Pawn.default.CollisionHeight);
			Pawn.ShouldCrouch(false);
			Pawn.bCrawler = Pawn.default.bCrawler;
		}
		return;
	}
	stop;
}

state PlayerSwimming
{
	function bool WantsSmoothedView()
	{
		return Not_PreBool(Pawn.bJustLanded);
		return;
	}

	function bool NotifyLanded(Vector HitNormal)
	{
		if(Pawn.PhysicsVolume.bWaterVolume)
		{
			Pawn.SetPhysics(3);
		}
		else
		{
			GotoState(Pawn.LandMovementState);
		}
		return bUpdating;
		return;
	}

	function bool NotifyPhysicsVolumeChange(PhysicsVolume NewVolume)
	{
		local Actor HitActor;
		local Vector HitLocation, HitNormal, checkpoint;

		if(Not_PreBool(NewVolume.bWaterVolume))
		{
			Pawn.SetPhysics(2);
			if(Greater_FloatFloat(Pawn.Velocity.Z, float(0)))
			{
				if(AndAnd_BoolBool(Pawn.bUpAndOut, Pawn.CheckWaterJump(HitNormal)))
				{
					Pawn.Velocity.Z = Add_FloatFloat(FMax(Pawn.JumpZ, 420.0000000), Multiply_FloatFloat(float(2), Pawn.CollisionRadius));
					GotoState(Pawn.LandMovementState);
				}
				else
				{
					if(OrOr_BoolBool(Greater_FloatFloat(Pawn.Velocity.Z, float(160)), Not_PreBool(Pawn.TouchingWaterVolume())))
					{
						GotoState(Pawn.LandMovementState);
					}
					else
					{
						checkpoint = Pawn.Location;
						SubtractEqual_FloatFloat(checkpoint.Z, Add_FloatFloat(Pawn.CollisionHeight, 6.0000000));
						HitActor = Trace(HitLocation, HitNormal, checkpoint, Pawn.Location, false);
						if(NotEqual_ObjectObject(HitActor, none))
						{
							GotoState(Pawn.LandMovementState);
						}
						else
						{
							Enable('Timer');
							SetTimer(0.7000000, false);
						}
					}
				}
			}
		}
		else
		{
			Disable('Timer');
			Pawn.SetPhysics(3);
		}
		return false;
		return;
	}

	function ProcessMove(float DeltaTime, Vector newAccel, Actor.EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
	{
		local Vector X, Y, Z, OldAccel;

		GetAxes(Rotation, X, Y, Z);
		OldAccel = Pawn.Acceleration;
		Pawn.Acceleration = newAccel;
		Pawn.bUpAndOut = AndAnd_BoolBool(Greater_FloatFloat(Dot_VectorVector(X, Pawn.Acceleration), float(0)), OrOr_BoolBool(Greater_FloatFloat(Pawn.Acceleration.Z, float(0)), Greater_IntInt(Rotation.Pitch, 2048)));
		if(Not_PreBool(Pawn.PhysicsVolume.bWaterVolume))
		{
			NotifyPhysicsVolumeChange(Pawn.PhysicsVolume);
		}
		return;
	}

	function PlayerMove(float DeltaTime)
	{
		local Rotator OldRotation;
		local Vector X, Y, Z, newAccel;

		GetAxes(Rotation, X, Y, Z);
		newAccel = Add_VectorVector(Add_VectorVector(Multiply_FloatVector(aForward, X), Multiply_FloatVector(aStrafe, Y)), Multiply_FloatVector(aUp, vect(0.0000000, 0.0000000, 1.0000000)));
		if(Less_FloatFloat(VSize(newAccel), 1.0000000))
		{
			newAccel = vect(0.0000000, 0.0000000, 0.0000000);
		}
		Pawn.CheckBob(DeltaTime, Y);
		OldRotation = Rotation;
		UpdateRotation(DeltaTime, 2.0000000);
		if(Less_IntInt(int(Role), int(ROLE_Authority)))
		{
			ReplicateMove(DeltaTime, newAccel, 0, Subtract_RotatorRotator(OldRotation, Rotation));
		}
		else
		{
			ProcessMove(DeltaTime, newAccel, 0, Subtract_RotatorRotator(OldRotation, Rotation));
		}
		bPressedJump = false;
		return;
	}

	function Timer()
	{
		if(AndAnd_BoolBool(Not_PreBool(Pawn.PhysicsVolume.bWaterVolume), EqualEqual_IntInt(int(Role), int(ROLE_Authority))))
		{
			GotoState(Pawn.LandMovementState);
		}
		Disable('Timer');
		return;
	}

	function BeginState()
	{
		Disable('Timer');
		Pawn.SetPhysics(3);
		return;
	}
	stop;
}

state PlayerFlying
{
	function PlayerMove(float DeltaTime)
	{
		local Vector X, Y, Z;

		GetAxes(Rotation, X, Y, Z);
		Pawn.Acceleration = Add_VectorVector(Multiply_FloatVector(aForward, X), Multiply_FloatVector(aStrafe, Y));
		if(Less_FloatFloat(VSize(Pawn.Acceleration), 1.0000000))
		{
			Pawn.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
		}
		if(AndAnd_BoolBool(bCheatFlying, EqualEqual_VectorVector(Pawn.Acceleration, vect(0.0000000, 0.0000000, 0.0000000))))
		{
			Pawn.Velocity = vect(0.0000000, 0.0000000, 0.0000000);
		}
		UpdateRotation(DeltaTime, 2.0000000);
		if(Less_IntInt(int(Role), int(ROLE_Authority)))
		{
			ReplicateMove(DeltaTime, Pawn.Acceleration, 0, rot(0, 0, 0));
		}
		else
		{
			ProcessMove(DeltaTime, Pawn.Acceleration, 0, rot(0, 0, 0));
		}
		return;
	}

	function BeginState()
	{
		Pawn.SetPhysics(4);
		return;
	}
	stop;
}

state BaseSpectating
{
	function bool IsSpectating()
	{
		return true;
		return;
	}

	function ProcessMove(float DeltaTime, Vector newAccel, Actor.EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
	{
		Acceleration = newAccel;
		MoveSmooth(Multiply_VectorFloat(Multiply_FloatVector(SpectateSpeed, Normal(Acceleration)), DeltaTime));
		return;
	}

	function PlayerMove(float DeltaTime)
	{
		local Vector X, Y, Z;

		if(AndAnd_BoolBool(NotEqual_ObjectObject(Pawn(ViewTarget), none), EqualEqual_IntInt(int(Level.NetMode), int(NM_Client))))
		{
			if(Pawn(ViewTarget).bSimulateGravity)
			{
				TargetViewRotation.Roll = 0;
			}
			BlendedTargetViewRotation.Pitch = BlendRot(DeltaTime, BlendedTargetViewRotation.Pitch, And_IntInt(TargetViewRotation.Pitch, 65535));
			BlendedTargetViewRotation.Yaw = BlendRot(DeltaTime, BlendedTargetViewRotation.Yaw, And_IntInt(TargetViewRotation.Yaw, 65535));
			BlendedTargetViewRotation.Roll = BlendRot(DeltaTime, BlendedTargetViewRotation.Roll, And_IntInt(TargetViewRotation.Roll, 65535));
		}
		GetAxes(Rotation, X, Y, Z);
		Acceleration = Multiply_FloatVector(0.0200000, Add_VectorVector(Add_VectorVector(Multiply_FloatVector(aForward, X), Multiply_FloatVector(aStrafe, Y)), Multiply_FloatVector(aUp, vect(0.0000000, 0.0000000, 1.0000000))));
		UpdateRotation(DeltaTime, 1.0000000);
		if(Less_IntInt(int(Role), int(ROLE_Authority)))
		{
			ReplicateMove(DeltaTime, Acceleration, 0, rot(0, 0, 0));
		}
		else
		{
			ProcessMove(DeltaTime, Acceleration, 0, rot(0, 0, 0));
		}
		return;
	}
	stop;
}

state Scripting
{
	exec function Fire()
	{
		return;
	}

	exec function AltFire(optional float F)
	{
		Fire();
		return;
	}
	stop;
}

state Spectating extends BaseSpectating
{
	ignores Suicide, ClientRestart, RestartLevel;

	exec function Fire()
	{
		ServerViewNextPlayer();
		return;
	}

	exec function AltFire(optional float F)
	{
		bBehindView = false;
		ServerViewSelf();
		return;
	}

	function BeginState()
	{
		if(NotEqual_ObjectObject(Pawn, none))
		{
			SetLocation(Pawn.Location);
			UnPossess();
		}
		bCollideWorld = true;
		return;
	}

	function EndState()
	{
		PlayerReplicationInfo.bIsSpectator = false;
		bCollideWorld = false;
		return;
	}
	stop;
}

auto state PlayerWaiting extends BaseSpectating
{
	ignores PostTakeDamage;

	exec function Jump(optional float F)
	{
		return;
	}

	exec function Suicide()
	{
		return;
	}

	function ChangeTeam(int n)
	{
		Level.Game.ChangeTeam(self, n, true);
		return;
	}

	function ServerReStartPlayer()
	{
		if(Less_FloatFloat(Level.TimeSeconds, WaitDelay))
		{
			return;
		}
		if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Client)))
		{
			return;
		}
		if(Level.Game.bWaitingToStartMatch)
		{
			PlayerReplicationInfo.bReadyToPlay = true;
		}
		else
		{
			Level.Game.RestartPlayer(self);
		}
		return;
	}

	exec function Fire()
	{
		LoadPlayers();
		ServerReStartPlayer();
		return;
	}

	exec function AltFire(optional float F)
	{
		Fire();
		return;
	}

	function EndState()
	{
		if(NotEqual_ObjectObject(Pawn, none))
		{
			Pawn.SetMesh();
		}
		if(NotEqual_ObjectObject(PlayerReplicationInfo, none))
		{
			PlayerReplicationInfo.SetWaitingPlayer(false);
		}
		bCollideWorld = false;
		return;
	}

	function BeginState()
	{
		if(NotEqual_ObjectObject(PlayerReplicationInfo, none))
		{
			PlayerReplicationInfo.SetWaitingPlayer(true);
		}
		bCollideWorld = true;
		return;
	}
	stop;
}

state WaitingForPawn extends BaseSpectating
{
	ignores KilledBy;

	exec function Fire()
	{
		AskForPawn();
		return;
	}

	exec function AltFire(optional float F)
	{
		return;
	}

	function LongClientAdjustPosition(float TimeStamp, name NewState, Actor.EPhysics newPhysics, float NewLocX, float NewLocY, float NewLocZ, float NewVelX, float NewVelY, float NewVelZ, Actor NewBase, float NewFloorX, float NewFloorY, float NewFloorZ)
	{
		if(EqualEqual_NameName(NewState, 'GameEnded'))
		{
			GotoState(NewState);
		}
		return;
	}

	function PlayerTick(float DeltaTime)
	{
		global.PlayerTick(DeltaTime);
		if(NotEqual_ObjectObject(Pawn, none))
		{
			Pawn.Controller = self;
			Pawn.bUpdateEyeheight = true;
			ClientRestart();
		}
		else
		{
			if(OrOr_BoolBool(LessEqual_FloatFloat(TimerRate, 0.0000000), Greater_FloatFloat(TimerRate, 1.0000000)))
			{
				SetTimer(0.2000000, true);
				AskForPawn();
			}
		}
		return;
	}

	function Timer()
	{
		AskForPawn();
		return;
	}

	function BeginState()
	{
		SetTimer(0.2000000, true);
		AskForPawn();
		return;
	}

	function EndState()
	{
		bBehindView = false;
		SetTimer(0.0000000, false);
		return;
	}
	stop;
}

state GameEnded
{
	ignores Suicide, PostTakeDamage, KilledBy;

	function ServerReStartPlayer()
	{
		return;
	}

	function bool IsSpectating()
	{
		return true;
		return;
	}

	function ServerRestartGame()
	{
		Level.Game.RestartGame();
		return;
	}

	exec function Fire()
	{
		if(Less_IntInt(int(Role), int(ROLE_Authority)))
		{
			return;
		}
		if(Not_PreBool(bFrozen))
		{
			ServerRestartGame();
		}
		else
		{
			if(LessEqual_FloatFloat(TimerRate, float(0)))
			{
				SetTimer(1.5000000, false);
			}
		}
		return;
	}

	exec function AltFire(optional float F)
	{
		Fire();
		return;
	}

	function PlayerMove(float DeltaTime)
	{
		local Vector X, Y, Z;
		local Rotator ViewRotation;

		GetAxes(Rotation, X, Y, Z);
		if(Not_PreBool(bFixedCamera))
		{
			ViewRotation = Rotation;
			AddEqual_IntInt(ViewRotation.Yaw, int(Multiply_FloatFloat(Multiply_FloatFloat(32.0000000, DeltaTime), aTurn)));
			AddEqual_IntInt(ViewRotation.Pitch, int(Multiply_FloatFloat(Multiply_FloatFloat(32.0000000, DeltaTime), aLookUp)));
			ViewRotation.Pitch = And_IntInt(ViewRotation.Pitch, 65535);
			if(AndAnd_BoolBool(Greater_IntInt(ViewRotation.Pitch, 18000), Less_IntInt(ViewRotation.Pitch, 49152)))
			{
				if(Greater_FloatFloat(aLookUp, float(0)))
				{
					ViewRotation.Pitch = 18000;
				}
				else
				{
					ViewRotation.Pitch = 49152;
				}
			}
			SetRotation(ViewRotation);
		}
		else
		{
			if(NotEqual_ObjectObject(ViewTarget, none))
			{
				SetRotation(ViewTarget.Rotation);
			}
		}
		ViewShake(DeltaTime);
		ViewFlash(DeltaTime);
		if(Less_IntInt(int(Role), int(ROLE_Authority)))
		{
			ReplicateMove(DeltaTime, vect(0.0000000, 0.0000000, 0.0000000), 0, rot(0, 0, 0));
		}
		else
		{
			ProcessMove(DeltaTime, vect(0.0000000, 0.0000000, 0.0000000), 0, rot(0, 0, 0));
		}
		bPressedJump = false;
		return;
	}

	function ServerMove(float TimeStamp, Vector InAccel, Vector ClientLoc, bool NewbRun, bool NewbDuck, bool NewbJumpStatus, bool NewbDoubleJump, bool NewbLeanLeft, bool NewbLeanRight, Actor.EDoubleClickDir DoubleClickMove, byte ClientRoll, int View, optional byte OldTimeDelta, optional int OldAccel)
	{
		global.ServerMove(TimeStamp, InAccel, ClientLoc, NewbRun, NewbDuck, NewbJumpStatus, NewbDoubleJump, NewbLeanLeft, NewbLeanRight, DoubleClickMove, ClientRoll, Add_IntInt(Multiply_IntInt(And_IntInt(32767, Divide_IntInt(Rotation.Pitch, 2)), 32768), And_IntInt(32767, Divide_IntInt(Rotation.Yaw, 2))));
		return;
	}

	function Timer()
	{
		bFrozen = false;
		return;
	}

	function LongClientAdjustPosition(float TimeStamp, name NewState, Actor.EPhysics newPhysics, float NewLocX, float NewLocY, float NewLocZ, float NewVelX, float NewVelY, float NewVelZ, Actor NewBase, float NewFloorX, float NewFloorY, float NewFloorZ)
	{
		return;
	}

	function BeginState()
	{
		local Pawn P;

		SetZoom(false, true);
		bFire = 0;
		bAltFire = 0;
		if(NotEqual_ObjectObject(Pawn, none))
		{
			Pawn.Velocity = vect(0.0000000, 0.0000000, 0.0000000);
			Pawn.SetPhysics(0);
			Pawn.bSpecialHUD = false;
			Pawn.SetCollision(true, false, false);
			StopFiring();
			Pawn.bIgnoreForces = true;
		}
		myHUD.bShowScores = true;
		bFrozen = true;
		if(Not_PreBool(bFixedCamera))
		{
			FindGoodView();
			bBehindView = true;
		}
		SetTimer(5.0000000, false);
		foreach DynamicActors(Class'Engine.Pawn', P)
		{
			if(EqualEqual_IntInt(int(P.Role), int(ROLE_Authority)))
			{
				P.RemoteRole = ROLE_DumbProxy;
			}
			P.SetCollision(true, false, false);
			P.Velocity = vect(0.0000000, 0.0000000, 0.0000000);
			P.SetPhysics(0);
			P.bIgnoreForces = true;
		}
		return;
	}
Begin:

	stop;
}

state Dead
{
	ignores KilledBy;

	function bool IsDead()
	{
		return true;
		return;
	}

	function ServerReStartPlayer()
	{
		super.ServerReStartPlayer();
		return;
	}

	exec function Fire()
	{
		if(bFrozen)
		{
			if(OrOr_BoolBool(LessEqual_FloatFloat(TimerRate, 0.0000000), Greater_FloatFloat(TimerRate, 1.0000000)))
			{
				bFrozen = false;
			}
			return;
		}
		LoadPlayers();
		ServerReStartPlayer();
		return;
	}

	exec function AltFire(optional float F)
	{
		Fire();
		return;
	}

	function ServerMove(float TimeStamp, Vector Accel, Vector ClientLoc, bool NewbRun, bool NewbDuck, bool NewbJumpStatus, bool NewbDoubleJump, bool NewbLeanLeft, bool NewbLeanRight, Actor.EDoubleClickDir DoubleClickMove, byte ClientRoll, int View, optional byte OldTimeDelta, optional int OldAccel)
	{
		global.ServerMove(TimeStamp, Accel, ClientLoc, false, false, false, false, false, false, DoubleClickMove, ClientRoll, View);
		return;
	}

	function PlayerMove(float DeltaTime)
	{
		local Vector X, Y, Z;
		local Rotator ViewRotation;

		if(Not_PreBool(bFrozen))
		{
			if(bPressedJump)
			{
				Fire();
				bPressedJump = false;
			}
			GetAxes(Rotation, X, Y, Z);
			ViewRotation = Rotation;
			AddEqual_IntInt(ViewRotation.Yaw, int(Multiply_FloatFloat(Multiply_FloatFloat(32.0000000, DeltaTime), aTurn)));
			AddEqual_IntInt(ViewRotation.Pitch, int(Multiply_FloatFloat(Multiply_FloatFloat(32.0000000, DeltaTime), aLookUp)));
			ViewRotation.Pitch = And_IntInt(ViewRotation.Pitch, 65535);
			if(AndAnd_BoolBool(Greater_IntInt(ViewRotation.Pitch, 18000), Less_IntInt(ViewRotation.Pitch, 49152)))
			{
				if(Greater_FloatFloat(aLookUp, float(0)))
				{
					ViewRotation.Pitch = 18000;
				}
				else
				{
					ViewRotation.Pitch = 49152;
				}
			}
			SetRotation(ViewRotation);
			if(Less_IntInt(int(Role), int(ROLE_Authority)))
			{
				ReplicateMove(DeltaTime, vect(0.0000000, 0.0000000, 0.0000000), 0, rot(0, 0, 0));
			}
		}
		else
		{
			if(OrOr_BoolBool(LessEqual_FloatFloat(TimerRate, 0.0000000), Greater_FloatFloat(TimerRate, 1.0000000)))
			{
				bFrozen = false;
			}
		}
		ViewShake(DeltaTime);
		ViewFlash(DeltaTime);
		return;
	}

	function Timer()
	{
		if(Not_PreBool(bFrozen))
		{
			return;
		}
		bFrozen = false;
		bPressedJump = false;
		return;
	}

	function BeginState()
	{
		if(AndAnd_BoolBool(NotEqual_ObjectObject(Pawn, none), EqualEqual_ObjectObject(Pawn.Controller, self)))
		{
			Pawn.Controller = none;
		}
		SetZoom(false, true);
		Pawn = none;
		Enemy = none;
		bBehindView = true;
		bFrozen = true;
		bJumpStatus = false;
		bPressedJump = false;
		bBlockCloseCamera = true;
		bValidBehindCamera = false;
		FindGoodView();
		SetTimer(1.0000000, false);
		StopForceFeedback();
		ClientPlayForceFeedback("Damage");
		CleanOutSavedMoves();
		return;
	}

	function EndState()
	{
		bBlockCloseCamera = false;
		CleanOutSavedMoves();
		Velocity = vect(0.0000000, 0.0000000, 0.0000000);
		Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
		if(Not_PreBool(PlayerReplicationInfo.bOutOfLives))
		{
			bBehindView = false;
		}
		bPressedJump = false;
		myHUD.bShowScores = false;
		return;
	}
Begin:

	Sleep(3.0000000);
	myHUD.bShowScores = true;
	stop;
}

defaultproperties
{
	bAlwaysMouseLook=true
	bZeroRoll=true
	bDynamicNetSpeed=true
	AnnouncerVolume=4
	MaxResponseTime=0.7000000
	OrthoZoom=40000.0000000
	CameraDist=9.0000000
	BaseFOV=85.0000000
	ZoomedFOV=85.0000000
	FlashScale=(X=1.0000000,Y=1.0000000,Z=1.0000000)
	MaxTimeMargin=0.3500000
	ProgressTimeOut=8.0000000
	QuickSaveString="Quick Saving"
	NoPauseMessage="Game is not pauseable"
	OwnCamera="Now viewing from own camera"
	LocalMessageClass=Class'Engine.LocalMessage'
	EnemyTurnSpeed=45000
	CheatClass=Class'Engine.CheatManager'
	InputClass=Class'Engine.PlayerInput'
	SpectateSpeed=600.0000000
	DynamicPingThreshold=400.0000000
	bEnableWeaponForceFeedback=true
	bEnableDamageForceFeedback=true
	bEnableGUIForceFeedback=true
	bForceFeedbackSupported=true
	FovAngle=85.0000000
	bIsPlayer=true
	bCanOpenDoors=true
	bCanDoSpecial=true
	NetPriority=3.0000000
	bTravel=true
}