class SwatGamePlayerController extends SwatPlayerController implements IInterested_GameEvent_PawnIncapacitated, IInterested_GameEvent_PawnDamaged, IInterestedInDoorOpening, IInterested_GameEvent_PawnIncapacitated, IInterested_GameEvent_PawnDamaged, IInterestedInDoorOpening
	native
	config(SwatGame)
	hidecategories(Karma);

const kDeathCamDurationSeconds = 2.0;
const kDeathCamEndRotationDownPitch = -4563;
const kDeathCamStartDistanceScale = 3.0;
const kDeathCamEndDistanceScale = 12.0;
const kDeathCamZOffset = 12.0;
const kEndGameCamDesiredDistScale = 10.0;
const kEndGameCamRotationPitch = -4563;
const kEndGameCamZOffset = 12.0;
const kEndGameCamSlowestYawDeltaPerSecond = 3000.0;
const kEndGameCamFastestYawDeltaPerSecond = 20000.0;
const kEndGameCamDistScaleForSlowestYawDelta = 7.5;
const kEndGameCamDistScaleForFastestYawDelta = 0.0;
const HALF_PI = 1.5707963268;

enum EFocusInterface
{
	Focus_Use,                      // 0
	Focus_Fire,                     // 1
	Focus_ClassicCommand,           // 2
	Focus_GraphicCommand,           // 3
	Focus_PlayerTag,                // 4
	Focus_LowReady                  // 5
};

enum FocusInterfaceNetMode
{
	FNET_All,                       // 0
	FNET_StandaloneOnly,            // 1
	FNET_MultiplayerOnly            // 2
};

enum NumberRow
{
	Row_FunctionKeys,               // 0
	Row_NumberKeys                  // 1
};

enum MovingMode
{
	Moving_Standing,                // 0
	Moving_Walking,                 // 1
	Moving_Running                  // 2
};

struct native PlayerFocusInterfaceInfo
{
	var config SwatGamePlayerController.EFocusInterface Focus;
	var config Class<PlayerFocusInterface> FocusClass;
	var config name Label;
	var config SwatGamePlayerController.FocusInterfaceNetMode ValidNetMode;
};

var int FlashbangRetinaImageTextureWidth;
var int FlashbangRetinaImageTextureHeight;
var private FlashbangCameraEffect FlashbangCameraEffect;
var private CSGasCameraEffect CSGasCameraEffect;
var private StingCameraEffect StingCameraEffect;
var private PepperSprayCameraEffect PepperSprayCameraEffect;
var SwatPlayer SwatPlayer;
var private bool bIsKillerLocationValid;
var private Vector KillerLocation;
var private bool bShouldStartDeathCam;
var private bool bIsDeathCamRunning;
var private float DeathCamStartTimeSeconds;
var private Rotator DeathCamStartRotation;
var private Rotator DeathCamEndRotation;
var private float DeathCamStartDistance;
var private float DeathCamEndDistance;
var private Timer ForceObserverTimer;
var private float ForceObserverTime;
var private Timer ComplianceTimer;
var private float ComplianceTime;
var private Timer CommandTimer;
var private float CommandTime;
var private float EndGameCamYaw;
var private float EndGameCamLastDist;
var private float EndGameCamYawLastUpdateTime;
var private float LastMouseX;
var private float LastMouseY;
var private float MouseDistancePerSecond;
var private bool Recoiling;
var private float RecoilStartTime;
var private float RecoilBackDuration;
var private float RecoilForeDuration;
var private float RecoilMagnitude;
var private float LastRecoilFunctionValue;
var bool DebugShouldRecoil;
var config float FocusTestDistance;
var config float FocusTestInterval;
var private Timer FocusPollTimer;
var private name LastFocusSource;
var config array<PlayerFocusInterfaceInfo> FocusInterfaceInfos;
var array<PlayerFocusInterface> FocusInterfaces;
var private CommandInterface CurrentCommandInterface;
var private export editinline HUDPageBase HUDPage;
var private Material ZoomBlurFader;
var private SwatRepo Repo;
var private Pawn ReplicatedObserverCamTarget;
var private ExternalViewportManager ViewportManager;
var private IControllableThroughViewport ReplicatedViewportTeammate;
var Timer SniperAlertTimer;
var config float SniperAlertTime;
var string SniperAlertFilter;
var input byte bControlViewport;
var Vector FocusTraceOrigin;
var Vector FocusTraceVector;
var private SwatGamePlayerController.MovingMode LastMovingMode;
var input byte bReload;
var Vector LastDebugPoint;
var bool bAuditFocus;
var private OfficerLoadOut theLoadOut;
var int SwatPlayerID;
var SwatRepoPlayerItem SwatRepoPlayerItem;
var bool ThisPlayerIsTheVIP;
var private bool HaveCalledInterruptYet;
var bool SPBombExploded;
var private bool LastBehindView;
var private BattleRoomManager BattleRoomManager;
var private float BattleRoomZ;
var private int BattleRoomPitch;
var private input byte bBattleRoomRotation;
var input byte bBattleRoomControl;
var Actor OtherForQualifyingUse;
var HandheldEquipment.EquipmentSlot EquipmentSlotForQualify;
var private bool bPlayerIsCuffed;
var private config float BeingCuffedTimeout;
var(DEBUG) bool DebugLocationFrozen;
var private bool bAlwaysRun;
var private bool bChangingTeams;
var private bool bHaveAlreadyInterruptedOptiwand;
var Vector LastFocusUpdateOrigin;
var private name TeamSelectedBeforeControllingOfficerViewport;
var SwatGUIConfig.eVoiceType VoiceType;

replication
{
	// Pos:0x000
	reliable if(AndAnd_BoolBool(AndAnd_BoolBool(bNetOwner, bNetDirty), EqualEqual_IntInt(int(Role), int(ROLE_Authority))))
		SwatPlayer;

	// Pos:0x023
	reliable if(EqualEqual_IntInt(int(Role), int(ROLE_Authority)))
		ClientAIDroppedAllWeapons, ClientAITriggerEffectEvent,
		ClientAddPrecacheableMaterial, ClientAddPrecacheableMesh,
		ClientAddPrecacheableStaticMesh, ClientBeginFiringWeapon,
		ClientBroadcastStopAllSounds, ClientDestroyAllPawns,
		ClientDestroyPawnsForRespawn, ClientEndFiringWeapon,
		ClientEndThrow, ClientForceObserverCam,
		ClientInterruptAndGotoState, ClientInterruptState,
		ClientOnLoggedIn, ClientOnTargetUsed,
		ClientPlayDoorBlocked, ClientPlayDoorBreached,
		ClientPreQuickRoundRestart, ClientPrecacheAll,
		ClientReceiveCommand, ClientReloadForPawn,
		ClientReportableReportedToTOC, ClientRoundStarted,
		ClientSetEndRoundTarget, ClientSetObjectiveVisibility,
		ClientSetTrainingText, ClientSkeletalRegionHit,
		ClientStartConversation, ClientStartEndRoundSequence,
		ClientThrowPrep, ClientTriggerDynamicMusic,
		ClientViewFromLocation, ClientViewportChange,
		ReplicatedObserverCamTarget, ReplicatedViewportTeammate;

	// Pos:0x030
	reliable if(Less_IntInt(int(Role), int(ROLE_Authority)))
		ServerActivateOfficerViewport, ServerAutoSetPlayerTeam,
		ServerChangePlayerTeam, ServerEndThrow,
		ServerGiveCommand, ServerIssueCompliance,
		ServerOnEffectStopped, ServerRequestInteract,
		ServerRequestQualifyInterrupt, ServerRequestThrowPrep,
		ServerRequestViewportChange, ServerSetAlwaysRun,
		ServerSetMPLoadOutPocketItem, ServerSetMPLoadOutPocketWeapon,
		ServerSetMPLoadOutSpecComplete, ServerSetPlayerNotReady,
		ServerSetPlayerReady, ServerSetPlayerTeam,
		ServerSetVoiceType;
}

simulated function PreBeginPlay()
{
	Repo = SwatRepo(Level.GetRepo());
	super(PlayerController).PreBeginPlay();
	Label = 'PlayerController';
	FlashbangCameraEffect = Class'SwatGame.FlashbangCameraEffect'.static.Allocate(self).;
	Construct_Void();
	FlashbangCameraEffect.Initialize(self);
	CSGasCameraEffect = Class'SwatGame.CSGasCameraEffect'.static.Allocate(self).;
	Construct_Void();
	CSGasCameraEffect.Initialize(self);
	PepperSprayCameraEffect = Class'SwatGame.PepperSprayCameraEffect'.static.Allocate(self).;
	Construct_Void();
	PepperSprayCameraEffect.Initialize(self);
	StingCameraEffect = Class'SwatGame.StingCameraEffect'.static.Allocate(self).;
	Construct_Void();
	StingCameraEffect.Initialize(self);
	return;
}

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	SPBombExploded = false;
	if(EqualEqual_ObjectObject(self, Level.GetLocalPlayerController()))
	{
		InitializePlayerHUD();
	}
	ViewportManager = Spawn(Class'SwatGame.ExternalViewportManager', self);
	if(OrOr_BoolBool(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)), Level.IsCOOPServer))
	{
		SwatGameInfo(Level.Game).GameEvents.PawnIncapacitated.Register(self);
		SwatGameInfo(Level.Game).GameEvents.PawnDamaged.Register(self);
	}
	if(AndAnd_BoolBool(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)), NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone))))
	{
		ForceObserverTimer = Spawn(Class'Engine.Timer');
		assert(NotEqual_ObjectObject(ForceObserverTimer, none));
		ForceObserverTimer.__TimerDelegate__Delegate = ForceObserverTimerCallback;
	}
	return;
}

simulated function PostNetBeginPlay()
{
	local DynamicLoadOutSpec CurrentMultiplayerLoadOut;

	super(Actor).PostNetBeginPlay();
	if(EqualEqual_ObjectObject(self, Level.GetLocalPlayerController()))
	{
		SetAlwaysRun(Repo.GuiConfig.bAlwaysRun);
		UpdateVoiceType();
	}
	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Client)))
	{
		CurrentMultiplayerLoadOut = Spawn(Class'SwatGame.DynamicLoadOutSpec',, string("CurrentMultiplayerLoadOut"));
		SetMPLoadOut(CurrentMultiplayerLoadOut);
		CurrentMultiplayerLoadOut.Destroy();
	}
	return;
}

simulated function InitializePlayerHUD()
{
	local int ct;
	local PlayerFocusInterface CurrentFocusInterface;

	FocusPollTimer = Spawn(Class'Engine.Timer');
	assert(NotEqual_ObjectObject(FocusPollTimer, none));
	FocusPollTimer.__TimerDelegate__Delegate = UpdateFocus;
	FocusPollTimer.StartTimer(FocusTestInterval, true);
	ct = 0;
	J0x49:

	if(Less_IntInt(ct, FocusInterfaceInfos.Length))
	{
		if(OrOr_BoolBool(OrOr_BoolBool(EqualEqual_IntInt(int(FocusInterfaceInfos[ct].ValidNetMode), int(0)), AndAnd_BoolBool(EqualEqual_IntInt(int(FocusInterfaceInfos[ct].ValidNetMode), int(1)), EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))), AndAnd_BoolBool(EqualEqual_IntInt(int(FocusInterfaceInfos[ct].ValidNetMode), int(2)), Greater_IntInt(int(Level.NetMode), int(NM_Standalone)))))
		{
			CurrentFocusInterface = Spawn(FocusInterfaceInfos[ct].FocusClass, self);
			AssertWithDescription(NotEqual_ObjectObject(CurrentFocusInterface, none), Concat_StrStr("[tcohen] SwatGamePlayerController::InitializePlayerHUD() Failed to Spawn the PlayerFocusInterface labeled ", string(FocusInterfaceInfos[ct].Label)));
			FocusInterfaces[int(FocusInterfaceInfos[ct].Focus)] = CurrentFocusInterface;
		}
		AddAdd_Int(ct);
		// [Loop Continue]
		goto J0x49;
	}
	SetCommandInterface(Repo.GuiConfig.CurrentCommandInterfaceStyle);
	BattleRoomManager = Spawn(Class'SwatGame.BattleRoomManager', self);
	return;
}

simulated function PausePlayerFocusInterfaces()
{
	FocusPollTimer.StopTimer();
	return;
}

simulated function ResumePlayerFocusInterfaces()
{
	return;
}

simulated function SetCommandInterface(SwatGUIConfig.ECommandInterfaceStyle Style)
{
	local CommandInterface LastCommandInterface, ClassicCommandInterface, GraphicCommandInterface;

	ClassicCommandInterface = CommandInterface(FocusInterfaces[int(2)]);
	GraphicCommandInterface = CommandInterface(FocusInterfaces[int(3)]);
	LastCommandInterface = CurrentCommandInterface;
	switch(Style)
	{
		case 1:
			CurrentCommandInterface = ClassicCommandInterface;
			break;
		case 2:
			CurrentCommandInterface = GraphicCommandInterface;
			break;
		default:
			AssertWithDescription(false, "[tcohen] The SwatGamePlayerController's CurrentCommandInterfaceStyle is invalid.  Please check it in SwatGame.ini [SwatGame.SwatGamePlayerController].");
			break;
	}
	Log(Concat_StrStr("CommandInterface set to ", string(GetCommandInterface())));
	if(NotEqual_ObjectObject(CurrentCommandInterface, LastCommandInterface))
	{
		ClassicCommandInterface.OnSelectedCommandInterfaceChanged(CurrentCommandInterface);
		GraphicCommandInterface.OnSelectedCommandInterfaceChanged(CurrentCommandInterface);
		UpdateFocus();
	}
	return;
}

simulated function ClientInterruptAndGotoState(Pawn thePlayer, name Reason, name NewControllerState, name NewPawnState)
{
	local SwatPlayer PlayerPawn;

	PlayerPawn = SwatPlayer(thePlayer);
	if(EqualEqual_ObjectObject(PlayerPawn, none))
	{
		return;
	}
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---SGPC::ClientInterruptAndGotoState()."));
		MPLog(Concat_StrStr("...Pawn=", string(thePlayer)));
		MPLog(Concat_StrStr("...Reason=", string(Reason)));
		MPLog(Concat_StrStr("...NewControllerState=", string(NewControllerState)));
		MPLog(Concat_StrStr("...NewPawnState=", string(NewPawnState)));
	}
	PlayerPawn.InterruptState(Reason);
	if(NotEqual_ObjectObject(PlayerPawn.Controller, none))
	{
		PlayerPawn.Controller.InterruptState(Reason);
	}
	PlayerPawn.GotoState(NewPawnState);
	if(NotEqual_ObjectObject(PlayerPawn.Controller, none))
	{
		PlayerPawn.Controller.GotoState(NewControllerState);
	}
	return;
}

simulated function ClientInterruptState(Pawn thePlayer, name Reason)
{
	local SwatPlayer PlayerPawn;

	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---SGPC::ClientInterruptState()."));
		MPLog(Concat_StrStr("...Pawn=", string(thePlayer)));
		MPLog(Concat_StrStr("...Reason=", string(Reason)));
	}
	PlayerPawn = SwatPlayer(thePlayer);
	PlayerPawn.InterruptState(Reason);
	if(NotEqual_ObjectObject(PlayerPawn.Controller, none))
	{
		PlayerPawn.Controller.InterruptState(Reason);
	}
	return;
}

function Restart()
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---SGPC::Restart()."));
	}
	bChangingTeams = false;
	super(PlayerController).Restart();
	return;
}

function ClientRestart()
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---SGPC::ClientRestart()."));
	}
	super(PlayerController).ClientRestart();
	if(AndAnd_BoolBool(EqualEqual_ObjectObject(self, Level.GetLocalPlayerController()), HasHUDPage()))
	{
		GetHUDPage().OnPlayerRespawned();
	}
	ClientMessage("", 'ViewingFromEvent');
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "...ClientRestart is calling SwatPlayer.RemoveAllCameraEffects()."));
	}
	RemoveAllCameraEffects();
	if(EqualEqual_ObjectObject(self, Level.GetLocalPlayerController()))
	{
		UpdateVoiceType();
	}
	return;
}

simulated function ClientPreQuickRoundRestart()
{
	if(Level.GetEngine().EnableDevTools)
	{
		Log("Client in ClientPreQuickRoundRestart: Collecting garbage.");
	}
	ConsoleCommand("obj garbage");
	return;
}

function InitPlayerReplicationInfo()
{
	local SwatPlayerReplicationInfo SwatPlayerReplicationInfo;

	super(Controller).InitPlayerReplicationInfo();
	SwatPlayerReplicationInfo = SwatPlayerReplicationInfo(PlayerReplicationInfo);
	SwatPlayerReplicationInfo.NetScoreInfo = Spawn(Class'SwatGame.NetScoreInfo');
	return;
}

simulated event OnConnectionFailed()
{
	if(EqualEqual_IntInt(int(Role), int(ROLE_Authority)))
	{
		Repo.Logout(self);
	}
	return;
}

simulated event Destroyed()
{
	if(NotEqual_ObjectObject(FocusPollTimer, none))
	{
		FocusPollTimer.Destroy();
	}
	super(PlayerController).Destroyed();
	SwatGameInfo(Level.Game).GameEvents.PawnIncapacitated.UnRegister(self);
	SwatGameInfo(Level.Game).GameEvents.PawnDamaged.UnRegister(self);
	if(EqualEqual_IntInt(int(Role), int(ROLE_Authority)))
	{
		Repo.Logout(self);
	}
	return;
}

simulated function SpawnDefaultHUD()
{
	myHUD = Spawn(Class'SwatGame.SwatHUD', self);
	return;
}

simulated function CalcViewForFocus(out Actor ViewActor, out Vector ViewLocation, out Rotator ViewRotation)
{
	local IControllableThroughViewport ControllableThroughViewport;
	local Actor ViewportOwner;

	if(AndAnd_BoolBool(NotEqual_ObjectObject(ActiveViewport, none), ActiveViewport.CanIssueCommands()))
	{
		LastFocusSource = 'None';
		ControllableThroughViewport = ActiveViewport.GetCurrentControllable();
		if(NotEqual_ObjectObject(ControllableThroughViewport, none))
		{
			ViewportOwner = ControllableThroughViewport.GetViewportOwner();
			if(NotEqual_ObjectObject(ViewportOwner, none))
			{
				LastFocusSource = ViewportOwner.Label;
			}
		}
		ActiveViewport.ViewportCalcView(ViewLocation, ViewRotation);
	}
	else
	{
		LastFocusSource = 'Player';
		PlayerCalcView(ViewActor, ViewLocation, ViewRotation);
	}
	return;
}

simulated function name GetLastFocusSource()
{
	return LastFocusSource;
	return;
}

simulated function UpdateFocus()
{
	local Vector HitLocation, HitNormal;
	local Material HitMaterial;
	local Actor Candidate;
	local Vector CameraLocation;
	local Rotator CameraRotation;
	local float Distance;
	local bool Transparent;
	local export editinline HUDPageBase LocalHUDPage;
	local Actor.ESkeletalRegion SkeletalRegionHit;
	local HandheldEquipment ActiveItem;
	local array<byte> FocusInterfaceWantsUpdate;
	local int ct;

	if(EqualEqual_ObjectObject(Pawn, none))
	{
		return;
	}
	if(bBehindView)
	{
		return;
	}
	CalcViewForFocus(Candidate, CameraLocation, CameraRotation);
	LastFocusUpdateOrigin = CameraLocation;
	LocalHUDPage = GetHUDPage();
	if(bAuditFocus)
	{
		Log(Concat_StrStr(Concat_StrStr("[FOCUS] T", string(Level.TimeSeconds)), " Auditing Focus..."));
	}
	ActiveItem = Pawn.GetActiveItem();
	if(bAuditFocus)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("[FOCUS] ... ActiveItem=", string(ActiveItem.Class.Name)), ", IsIdle="), string(ActiveItem.IsIdle())));
	}
	FocusInterfaceWantsUpdate[Subtract_IntInt(FocusInterfaces.Length, 1)] = 0;
	ct = 0;
	J0x10F:

	if(Less_IntInt(ct, FocusInterfaces.Length))
	{
		if(AndAnd_BoolBool(NotEqual_ObjectObject(FocusInterfaces[ct], none), FocusInterfaces[ct].PreUpdate(self, LocalHUDPage)))
		{
			FocusInterfaceWantsUpdate[ct] = 1;
			FocusInterfaces[ct].ResetFocus(self, LocalHUDPage);
		}
		AddAdd_Int(ct);
		// [Loop Continue]
		goto J0x10F;
	}
	FocusTraceOrigin = CameraLocation;
	FocusTraceVector = Multiply_VectorFloat(Vector(CameraRotation), FocusTestDistance);
	foreach TraceActors(Class'Engine.Actor', Candidate, HitLocation, HitNormal, HitMaterial, Add_VectorVector(FocusTraceOrigin, FocusTraceVector), FocusTraceOrigin, vect(0.0000000, 0.0000000, 0.0000000), true, SkeletalRegionHit, true)
	{
		Distance = VSize(Subtract_VectorVector(HitLocation, CameraLocation));
		Transparent = AndAnd_BoolBool(NotEqual_ObjectObject(HitMaterial, none), OrOr_BoolBool(EqualEqual_IntInt(int(HitMaterial.MaterialVisualType), int(3)), EqualEqual_IntInt(int(HitMaterial.MaterialVisualType), int(4))));
		if(bAuditFocus)
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[FOCUS] ... Considering Candidate=", string(Candidate)), " at Distance="), string(Distance)), "..."));
		}
		if(Class'SwatGame.PlayerFocusInterface'.static.StaticRejectFocus(self, Candidate, HitLocation, HitNormal, HitMaterial, SkeletalRegionHit, Distance, Transparent, bAuditFocus))
		{
			continue;
		}
		ct = 0;
		J0x2E0:

		if(Less_IntInt(ct, FocusInterfaces.Length))
		{
			if(EqualEqual_ObjectObject(FocusInterfaces[ct], none))
			{
				// [Explicit Continue]
				goto J0x583;
			}
			if(EqualEqual_IntInt(int(FocusInterfaceWantsUpdate[ct]), 0))
			{
				if(bAuditFocus)
				{
					Log(Concat_StrStr(Concat_StrStr("[FOCUS] ... ... Skipping the ", string(FocusInterfaces[ct].Class.Name)), " because it doesn't want to be updated."));
				}
				// [Explicit Continue]
				goto J0x583;
			}
			if(FocusInterfaces[ct].RejectFocus(self, Candidate, HitLocation, HitNormal, HitMaterial, SkeletalRegionHit, Distance, Transparent))
			{
				if(bAuditFocus)
				{
					Log(Concat_StrStr(Concat_StrStr("[FOCUS] ... ... Skipping the ", string(FocusInterfaces[ct].Class.Name)), " because it rejected the candidate."));
				}
				// [Explicit Continue]
				goto J0x583;
			}
			if(Greater_FloatFloat(Distance, FocusInterfaces[ct].default.Range))
			{
				if(bAuditFocus)
				{
					Log(Concat_StrStr(Concat_StrStr("[FOCUS] ... ... Skipping the ", string(FocusInterfaces[ct].Class.Name)), " because the candidate is out of range."));
				}
				// [Explicit Continue]
				goto J0x583;
			}
			if(bAuditFocus)
			{
				Log(Concat_StrStr(Concat_StrStr("[FOCUS] ... ... The ", string(FocusInterfaces[ct].Class.Name)), " is getting to ConsiderNewFocus()"));
			}
			FocusInterfaces[ct].ConsiderNewFocus(SwatPlayer(Pawn), Candidate, Distance, HitLocation, HitNormal, HitMaterial, SkeletalRegionHit, Transparent);
			J0x583:

			AddAdd_Int(ct);
			// [Loop Continue]
			goto J0x2E0;
		}
	}
	ct = 0;
	J0x596:

	if(Less_IntInt(ct, FocusInterfaces.Length))
	{
		if(EqualEqual_IntInt(int(FocusInterfaceWantsUpdate[ct]), 1))
		{
			FocusInterfaces[ct].PostUpdate();
		}
		AddAdd_Int(ct);
		// [Loop Continue]
		goto J0x596;
	}
	LocalHUDPage.Feedback.UpdateCaption();
	bAuditFocus = false;
	return;
}

simulated function BeginLowReadyRefractoryPeriod()
{
	LowReadyInterface(GetFocusInterface(5)).BeginLowReadyRefractoryPeriod();
	return;
}

simulated event InitiateViewportUse(IControllableViewport inNewViewport)
{
	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
	{
		Log(Concat_StrStr("ActiveViewport actor is: ", string(Actor(ActiveViewport))));
		Log(Concat_StrStr("IControllableViewport of Actor is: ", string(IControllableViewport(Actor(ActiveViewport)))));
		if(Not_PreBool(SwatPlayer.IsNonlethaled()))
		{
			ActivateViewport(inNewViewport);
		}
	}
	else
	{
		if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Client)))
		{
			Log(Concat_StrStr("ActiveViewport actor is: ", string(Actor(ActiveViewport))));
			Log(Concat_StrStr("IControllableViewport of Actor is: ", string(IControllableViewport(Actor(ActiveViewport)))));
			if(Less_FloatFloat(VSize(Pawn.Velocity), 0.0500000))
			{
				ServerRequestViewportChange(EqualEqual_ObjectObject(inNewViewport, Pawn.GetActiveItem()));
			}
		}
		else
		{
			if(Less_FloatFloat(VSize(Pawn.Velocity), 0.0500000))
			{
				Log(Concat_StrStr("ActiveViewport actor is: ", string(Actor(ActiveViewport))));
				Log(Concat_StrStr("IControllableViewport of Actor is: ", string(IControllableViewport(Actor(ActiveViewport)))));
				if(Not_PreBool(SwatPlayer.IsNonlethaled()))
				{
					ActivateViewport(inNewViewport);
				}
			}
		}
	}
	return;
}

function ServerActivateOfficerViewport(bool ShouldActivate)
{
	local string ViewportType;

	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(string(self), "--ServerActivateOfficerViewport - ShouldActivate: "), string(ShouldActivate)));
	}
	if(ShouldActivate)
	{
		if(OrOr_BoolBool(EqualEqual_ObjectObject(Pawn, none), EqualEqual_ObjectObject(NetPlayer(Pawn), none)))
		{
			return;
		}
		ServerOfficerViewport = ViewportManager;
		ViewportManager.Initialize();
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog("Setting viewporttype manually for netgame");
		}
		if(Pawn.IsA('NetPlayerTeamA'))
		{
			ViewportType = "TeamA";
		}
		else
		{
			ViewportType = "TeamB";
		}
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog(Concat_StrStr("Setting viewporttype manually for netgame to ", ViewportType));
		}
		if(ViewportManager.HasOfficers(ViewportType))
		{
			ViewportManager.ShowViewport(ViewportType, "");
		}
		ReplicatedViewportTeammate = ViewportManager.GetCurrentControllable();
	}
	if(OrOr_BoolBool(Not_PreBool(ShouldActivate), EqualEqual_ObjectObject(ReplicatedViewportTeammate, none)))
	{
		ServerOfficerViewport = none;
		ReplicatedViewportTeammate = none;
		ViewportManager.SetFilter("");
		ViewportManager.HideViewport();
	}
	return;
}

private simulated event OnReplicatedViewportTeammateChanged()
{
	if(NotEqual_ObjectObject(ReplicatedViewportTeammate, none))
	{
		ViewportManager.Initialize();
		GetHUDPage().ExternalViewport.Show();
		ViewportManager.SetCurrentControllable(ReplicatedViewportTeammate);
	}
	else
	{
		HideViewportInternal();
	}
	return;
}

function ServerRequestViewportChange(bool ActivateActiveItemViewport)
{
	local HandheldEquipment theActiveItem;

	if(AndAnd_BoolBool(SwatPlayer.IsNonlethaled(), ActivateActiveItemViewport))
	{
		return;
	}
	if(ActivateActiveItemViewport)
	{
		theActiveItem = Pawn.GetActiveItem();
		if(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(theActiveItem, none), theActiveItem.IsA('IControllableViewport')), theActiveItem.IsIdle()))
		{
			ServerItemViewport = IControllableViewport(theActiveItem);
			ClientViewportChange(ActivateActiveItemViewport);
		}
	}
	else
	{
		ServerItemViewport = none;
		ClientViewportChange(ActivateActiveItemViewport);
	}
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr("ServerRequestUseOptiwand on: ", string(self)), " ActiveViewport is: "), string(ActiveViewport)));
	}
	return;
}

simulated function ClientViewportChange(bool ActivateActiveItemViewport)
{
	local HandheldEquipment theActiveItem;

	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---SGPC::ClientViewportChange()."));
	}
	if(ActivateActiveItemViewport)
	{
		theActiveItem = Pawn.GetActiveItem();
		if(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(theActiveItem, none), theActiveItem.IsA('IControllableViewport')), theActiveItem.IsIdle()))
		{
			ActivateViewport(IControllableViewport(theActiveItem));
		}
	}
	else
	{
		ActiveViewport = none;
	}
	return;
}

simulated event ActivateViewport(IControllableViewport inNewViewport)
{
	ActiveViewport = inNewViewport;
	if(NotEqual_ObjectObject(ActiveViewport, none))
	{
		GotoState(ActiveViewport.GetControllingStateName());
	}
	return;
}

exec function EnableMirrors(bool bInEnabledMirrors)
{
	Class'Engine.Mirror'.static.SetMirrorsEnabled(bInEnabledMirrors);
	return;
}

exec function ControlOfficerViewport()
{
	local string ViewportFilter;

	if(AndAnd_BoolBool(AndAnd_BoolBool(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)), Not_PreBool(IsDead())), ViewportManager.ShouldControlViewport()))
	{
		if(GetHUDPage().ExternalViewport.bVisible)
		{
			TeamSelectedBeforeControllingOfficerViewport = GetCommandInterface().GetCurrentTeam();
			ViewportFilter = ViewportManager.GetFilter();
			if(EqualEqual_StrStr(ViewportFilter, "Red"))
			{
				SetPlayerCommandInterfaceTeam('RedTeam');
			}
			else
			{
				if(EqualEqual_StrStr(ViewportFilter, "Blue"))
				{
					SetPlayerCommandInterfaceTeam('BlueTeam');
				}
			}
			ActivateViewport(ViewportManager);
		}
	}
	return;
}

exec function Fire()
{
	local HandheldEquipment ActiveItem;

	ActiveItem = Pawn.GetActiveItem();
	if(AndAnd_BoolBool(NotEqual_IntInt(int(EquipmentSlotForQualify), int(0)), NotEqual_IntInt(int(EquipmentSlotForQualify), int(ActiveItem.GetSlot()))))
	{
		InternalEquipSlot(EquipmentSlotForQualify);
	}
	else
	{
		if(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(ActiveItem, none), ActiveItem.IsA('IControllableViewport')), ActiveItem.IsIdle()))
		{
			InitiateViewportUse(IControllableViewport(ActiveItem));
		}
		else
		{
			if(OrOr_BoolBool(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)), AndAnd_BoolBool(Not_PreBool(SwatPlayer.IsNonlethaled()), Not_PreBool(SwatPlayer.IsArrested()))))
			{
				super(PlayerController).Fire();
			}
		}
	}
	return;
}

simulated function ClientBeginFiringWeapon(Pawn PawnWhoFired, HandheldEquipment.EquipmentSlot ItemSlot, FiredWeapon.FireMode CurrentFireMode)
{
	local NetPlayer theNetPlayer;
	local FiredWeapon theFiredWeapon;

	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self), "---SGPC::ClientBeginFiringWeapon(). PawnWhoFired="), string(PawnWhoFired)), ", ItemSlot="), string(ItemSlot)));
	}
	assert(EqualEqual_IntInt(int(Level.NetMode), int(NM_Client)));
	if(NotEqual_ObjectObject(PawnWhoFired, none))
	{
		theNetPlayer = NetPlayer(PawnWhoFired);
		theFiredWeapon = FiredWeapon(theNetPlayer.GetLoadOut().GetItemAtSlot(ItemSlot));
		if(AndAnd_BoolBool(AndAnd_BoolBool(EqualEqual_ObjectObject(theFiredWeapon, theNetPlayer.GetActiveItem()), theFiredWeapon.IsEquipped()), theFiredWeapon.IsIdle()))
		{
			if(Level.GetEngine().EnableDevTools)
			{
				MPLog(Concat_StrStr("...Calling OnPlayerUse() on ", string(theFiredWeapon)));
			}
			theFiredWeapon.SetCurrentFireMode(CurrentFireMode);
			theFiredWeapon.OnPlayerUse();
		}
		else
		{
			if(Level.GetEngine().EnableDevTools)
			{
				MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr("...Was told to fire, but the Item was not the ActiveItem. PawnWhoFired=", string(PawnWhoFired)), ", theFiredWeapon="), string(theFiredWeapon)));
			}
		}
	}
	return;
}

simulated function ClientAIBeginFiringWeapon(Pawn theAIPawn, int CurrentFireMode)
{
	local FiredWeapon theFiredWeapon;

	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self), "---SGPC::ClientAIBeginFiringWeapon(). PawnWhoFired="), string(theAIPawn)), ", FireMode="), string(CurrentFireMode)));
	}
	assert(EqualEqual_IntInt(int(Level.NetMode), int(NM_Client)));
	if(EqualEqual_ObjectObject(theAIPawn, none))
	{
		return;
	}
	theFiredWeapon = FiredWeapon(theAIPawn.GetActiveItem());
	if(EqualEqual_ObjectObject(theFiredWeapon, none))
	{
		return;
	}
	if(AndAnd_BoolBool(theFiredWeapon.IsEquipped(), theFiredWeapon.IsIdle()))
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog(Concat_StrStr("...Calling OnPlayerUse() on ", string(theFiredWeapon)));
		}
		theFiredWeapon.SetCurrentFireMode(byte(CurrentFireMode));
		theFiredWeapon.OnPlayerUse();
	}
	return;
}

simulated function ClientEndFiringWeapon(Pawn PawnWhoFired)
{
	local NetPlayer theNetPlayer;

	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(string(self), "---SGPC::ClientEndFiringWeapon(). PawnWhoFired="), string(PawnWhoFired)));
	}
	assert(EqualEqual_IntInt(int(Level.NetMode), int(NM_Client)));
	if(NotEqual_ObjectObject(PawnWhoFired, none))
	{
		theNetPlayer = NetPlayer(PawnWhoFired);
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog("...Stopping autofiring.");
		}
		theNetPlayer.bWantsToContinueAutoFiring = false;
	}
	return;
}

simulated function ClientAIEndFiringWeapon(Pawn theAIPawn)
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(string(self), "---SGPC::ClientAIEndFiringWeapon(). PawnWhoFired="), string(theAIPawn)));
	}
	assert(EqualEqual_IntInt(int(Level.NetMode), int(NM_Client)));
	if(NotEqual_ObjectObject(theAIPawn, none))
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog("...Stopping autofiring.");
		}
		SwatPawn(theAIPawn).bWantsToContinueAutoFiring = false;
	}
	return;
}

simulated function ClientAIDroppedAllWeapons(SwatEnemy theDropper)
{
	MPLog(Concat_StrStr("---SGPC::ClientAIDroppedAllWeapons(). dropper=", string(theDropper)));
	if(NotEqual_ObjectObject(theDropper, none))
	{
		theDropper.DropAllWeapons();
	}
	return;
}

simulated function ClientAIDroppedWeapon(string WeaponUniqueID, Vector ServerLocation, Rotator ServerRotation, Vector ThrowDirectionImpulse, Class<HandheldEquipmentModel> WeaponModelClass)
{
	local HandheldEquipmentModel WeaponModel;
	local bool PhysicsError;

	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("---SGPC::ClientAIDroppedWeapon(). UniqueID=", WeaponUniqueID), ", ServerLocation="), string(ServerLocation)), ", ServerRotation="), string(ServerRotation)));
		MPLog(Concat_StrStr("...ServerLocation=", string(ServerLocation)));
		MPLog(Concat_StrStr("...ServerRotation=", string(ServerRotation)));
		MPLog(Concat_StrStr("...ThrowDirectionImpulse=", string(ThrowDirectionImpulse)));
		MPLog(Concat_StrStr("...WeaponModelClass=", string(WeaponModelClass)));
	}
	assert(NotEqual_StrStr(WeaponUniqueID, ""));
	WeaponModel = HandheldEquipmentModel(FindByUniqueID(Class'Engine.HandheldEquipmentModel', WeaponUniqueID));
	if(EqualEqual_ObjectObject(WeaponModel, none))
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog("...There was not a weapon in the level with that UniqueID, so we're spawning it.");
		}
		WeaponModel = Spawn(WeaponModelClass);
		assert(NotEqual_ObjectObject(WeaponModel, none));
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog(Concat_StrStr("WeaponModel=", string(WeaponModel)));
		}
		WeaponModel.bHidden = false;
		WeaponModel.bIsDropped = true;
		WeaponModel.bBlockNonZeroExtentTraces = true;
		WeaponModel.bBlockZeroExtentTraces = true;
		WeaponModel.bProjTarget = true;
		WeaponModel.SetCollision(true, false, false);
		WeaponModel.SetLocation(ServerLocation);
		WeaponModel.SetRotation(ServerRotation);
		WeaponModel.SetUniqueID(WeaponUniqueID);
		PhysicsError = false;
		if(EqualEqual_ObjectObject(WeaponModel.HavokDataClass, none))
		{
			AssertWithDescription(false, Concat_StrStr(Concat_StrStr("SwatEnemy::DropWeapon - HavokDataClass for WeaponModel ", string(WeaponModel.Name)), " is NULL."));
			PhysicsError = true;
		}
		if(Not_PreBool(PhysicsError))
		{
			if(EqualEqual_ObjectObject(WeaponModel.StaticMesh, none))
			{
				if(Level.GetEngine().EnableDevTools)
				{
					AssertWithDescription(NotEqual_ObjectObject(WeaponModel.DroppedStaticMesh, none), Concat_StrStr(Concat_StrStr("WeaponModel ", string(WeaponModel.Name)), " does not have a Dropped static mesh set for it.  It must!  Bug Shawn!!!"));
					Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("Setting static mesh for ", string(WeaponModel.Name)), " to: "), string(WeaponModel.DroppedStaticMesh)));
				}
				WeaponModel.SetStaticMesh(WeaponModel.DroppedStaticMesh);
				WeaponModel.SetDrawType(8);
			}
			WeaponModel.HavokSetBlocking(true);
			WeaponModel.SetPhysics(15);
			WeaponModel.HavokImpartCOMImpulse(ThrowDirectionImpulse);
		}
		WeaponModel.bUseCylinderCollision = true;
	}
	else
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog(Concat_StrStr("...WeaponModel was not None: the weapon already existed in the Level. WeaponModel=", string(WeaponModel)));
			MPLog(Concat_StrStr("...WeaponModel.UniqueID()=", WeaponModel.UniqueID()));
		}
	}
	return;
}

simulated function ClientWeaponFellOutOfWorld(string WeaponUniqueID)
{
	local HandheldEquipmentModel theModel;

	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr("---SGPC::ClientWeaponFellOutOfWorld(). UniqueID=", WeaponUniqueID));
	}
	assert(NotEqual_StrStr(WeaponUniqueID, ""));
	theModel = HandheldEquipmentModel(FindByUniqueID(Class'Engine.HandheldEquipmentModel', WeaponUniqueID));
	if(NotEqual_ObjectObject(theModel, none))
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog("...calling Destroy() on the theModel.");
		}
		theModel.Destroy();
	}
	else
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog("...not calling Destroy() because theModel was None.");
		}
	}
	return;
}

simulated function ClientDroppedWeaponAtRest(string WeaponUniqueID, float ServerLocation_X, float ServerLocation_Y, float ServerLocation_Z, Rotator ServerRotation)
{
	local HandheldEquipmentModel theModel;
	local Vector ServerLocation;

	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr("---SGPC::ClientDroppedWeaponAtRest(). UniqueID=", WeaponUniqueID));
	}
	assert(NotEqual_StrStr(WeaponUniqueID, ""));
	ServerLocation.X = ServerLocation_X;
	ServerLocation.Y = ServerLocation_Y;
	ServerLocation.Z = ServerLocation_Z;
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr("...ServerLocation=", string(ServerLocation)));
		MPLog(Concat_StrStr("...ServerRotation=", string(ServerRotation)));
	}
	theModel = HandheldEquipmentModel(FindByUniqueID(Class'Engine.HandheldEquipmentModel', WeaponUniqueID));
	if(NotEqual_ObjectObject(theModel, none))
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog("...calling ProcessAtRestValuesFromServer().");
		}
		theModel.ProcessAtRestValuesFromServer(ServerLocation, ServerRotation);
	}
	else
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog("...theModel was None, so we're not calling ProcessAtRestValuesFromServer().");
		}
	}
	return;
}

simulated function HandheldEquipment.EquipmentSlot GetEquipmentSlotForQualify()
{
	return EquipmentSlotForQualify;
	return;
}

exec function NextFireMode()
{
	local HandheldEquipment ActiveItem;

	ActiveItem = Pawn.GetActiveItem();
	if(AndAnd_BoolBool(NotEqual_ObjectObject(ActiveItem, none), ActiveItem.IsA('FiredWeapon')))
	{
		FiredWeapon(ActiveItem).NextFireMode();
	}
	return;
}

simulated function SwatDoor GetDoorInWay()
{
	local SwatDoor DoorActor;

	DoorActor = SwatDoor(GetFocusInterface(1).GetDefaultFocusActor());
	if(AndAnd_BoolBool(NotEqual_ObjectObject(DoorActor, none), Less_FloatFloat(VSize(Subtract_VectorVector(DoorActor.Location, Pawn.Location)), 100.0000000)))
	{
		return DoorActor;
	}
	return none;
	return;
}

simulated function bool DoorInWay()
{
	local SwatDoor DoorActor;

	DoorActor = SwatDoor(GetFocusInterface(1).GetDefaultFocusActor());
	if(AndAnd_BoolBool(NotEqual_ObjectObject(DoorActor, none), Less_FloatFloat(VSize(Subtract_VectorVector(DoorActor.Location, Pawn.Location)), 100.0000000)))
	{
		return true;
	}
	return false;
	return;
}

simulated function bool CanOpenGCI()
{
	return true;
	return;
}

function ServerRequestInteract(ICanBeUsed Target, string UniqueID)
{
	local Controller i;
	local SwatGamePlayerController Current;

	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self), "---SGPC::ServerRequestInteract(). Target="), string(Target)), ", UniqueID = "), UniqueID));
	}
	if(AndAnd_BoolBool(EqualEqual_ObjectObject(Target, none), NotEqual_StrStr(UniqueID, "")))
	{
		Target = ICanBeUsed(FindByUniqueID(none, UniqueID));
	}
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self), "---SGPC::ServerRequestInteract()... Target="), string(Target)), ", UniqueID = "), UniqueID));
		MPLog(Concat_StrStr("...target's owner=", string(Actor(Target).Owner)));
	}
	if(AndAnd_BoolBool(NotEqual_ObjectObject(Target, none), Target.CanBeUsedNow()))
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog("...1");
		}
		Target.OnUsed(Pawn);
		Target.PostUsed();
		i = Level.ControllerList;
		J0x1C7:

		if(NotEqual_ObjectObject(i, none))
		{
			Current = SwatGamePlayerController(i);
			if(NotEqual_ObjectObject(Current, none))
			{
				Current.ClientOnTargetUsed(Target, UniqueID);
			}
			i = i.nextController;
			// [Loop Continue]
			goto J0x1C7;
		}
	}
	else
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog("...Interact request ignored.");
		}
	}
	return;
}

function ClientOnTargetUsed(ICanBeUsed Target, string UniqueID)
{
	if(AndAnd_BoolBool(EqualEqual_ObjectObject(Target, none), NotEqual_StrStr(UniqueID, "")))
	{
		Target = ICanBeUsed(FindByUniqueID(none, UniqueID));
	}
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(string(self), "---SGPC::ClientOnTargetUsed(). Target="), string(Target)));
	}
	Target.PostUsed();
	return;
}

simulated function ClientPlayDoorBlocked(SwatDoor TheDoor, bool OpeningBlocked, Door.DoorPosition NewPendingPosition)
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self), "---SGPC::ClientPlayDoorBlocked(). TheDoor="), string(TheDoor)), ", OpeningBlocked="), string(OpeningBlocked)), ", NewPendingPosition="), string(NewPendingPosition)));
	}
	TheDoor.PendingPosition = NewPendingPosition;
	if(OpeningBlocked)
	{
		TheDoor.GotoState('OpeningBlocked');
	}
	else
	{
		TheDoor.GotoState('ClosingBlocked');
	}
	return;
}

simulated function ClientPlayDoorBreached(SwatDoor TheDoor, DeployedC2ChargeBase TheCharge)
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self), "---SGPC::ClientPlayDoorBreached(). TheDoor="), string(TheDoor)), ", TheCharge="), string(TheCharge)));
	}
	assert(NotEqual_ObjectObject(TheDoor, none));
	assert(NotEqual_ObjectObject(TheCharge, none));
	TheDoor.PlayDoorBreached(TheCharge);
	return;
}

simulated function OnQualifyInterrupted()
{
	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
	{
		AssertWithDescription(false, "[tcohen] SwatGamePlayerController::OnQualifyInterrupted() but we're not QualifyingForUse.");
	}
	return;
}

simulated function OnQualifyCompleted()
{
	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)))
	{
		AssertWithDescription(false, "[tcohen] SwatGamePlayerController::OnQualifyCompleted() but we're not QualifyingForUse.");
	}
	return;
}

function ServerRequestQualifyInterrupt()
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---SGPC::ServerRequestQualifyInterrupt() in global state. Ignoring request."));
	}
	return;
}

simulated function AuthorizedInterruptQualification()
{
	return;
}

function NotifyDoorOpening(Door TargetDoor)
{
	AssertWithDescription(false, "[tcohen] SGPC::NotifyDoorOpening() We only expect to get this notification in state QualifyingForUse.  But we're in the Global state now.");
	return;
}

simulated function PawnDied(Pawn P)
{
	super(PlayerController).PawnDied(P);
	return;
}

exec function CycleOfficer()
{
	return;
}

exec function ShowViewport(string ViewportType)
{
	local string SpecificOfficer;
	local IControllableThroughViewport SavedReplicatedViewportTeammate;

	if(Not_PreBool(GetHUDPage().ExternalViewport.bVisible))
	{
		bControlViewport = 0;
	}
	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
	{
		SavedReplicatedViewportTeammate = ReplicatedViewportTeammate;
		ServerActivateOfficerViewport(true);
		if(AndAnd_BoolBool(EqualEqual_IntInt(int(Level.NetMode), int(NM_ListenServer)), NotEqual_ObjectObject(SavedReplicatedViewportTeammate, ReplicatedViewportTeammate)))
		{
			GetHUDPage().ExternalViewport.Show();
		}
	}
	else
	{
		if(ViewportManager.HasOfficers(ViewportType))
		{
			if(ComplementEqual_StrStr(ViewportType, "sniper"))
			{
				SpecificOfficer = SniperAlertFilter;
			}
			GetHUDPage().ExternalViewport.Show();
			ViewportManager.ShowViewport(ViewportType, SpecificOfficer);
			if(NotEqual_ObjectObject(ActiveViewport, none))
			{
				if(EqualEqual_StrStr(ViewportType, "Red"))
				{
					SetPlayerCommandInterfaceTeam('RedTeam');
				}
				else
				{
					if(EqualEqual_StrStr(ViewportType, "Blue"))
					{
						SetPlayerCommandInterfaceTeam('BlueTeam');
					}
				}
			}
		}
	}
	return;
}

exec function HideViewport()
{
	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Client)))
	{
		ServerActivateOfficerViewport(false);
	}
	HideViewportInternal();
	return;
}

private simulated function HideViewportInternal()
{
	ViewportManager.SetFilter("");
	ViewportManager.HideViewport();
	GetHUDPage().ExternalViewport.Hide();
	bControlViewport = 0;
	ActivateViewport(none);
	return;
}

function ExternalViewportManager GetExternalViewportManager()
{
	return ViewportManager;
	return;
}

function OnSniperTimerEnded()
{
	SniperAlertTimer.Destroy();
	SniperAlertTimer = none;
	SniperAlertFilter = "";
	return;
}

function OnSniperAlerted(SniperPawn AssociatedSniper)
{
	if(NotEqual_ObjectObject(SniperAlertTimer, none))
	{
		OnSniperTimerEnded();
	}
	SniperAlertTimer = Spawn(Class'Engine.Timer');
	assert(NotEqual_ObjectObject(SniperAlertTimer, none));
	SniperAlertTimer.__TimerDelegate__Delegate = OnSniperTimerEnded;
	SniperAlertTimer.StartTimer(SniperAlertTime);
	SniperAlertFilter = string(AssociatedSniper.Name);
	ClientMessage("", 'SniperAlerted');
	return;
}

exec function Use()
{
	local ReactiveWorldObject Candidate;

	ClientMessage("Using!");
	foreach RadiusActors(Class'RWOSupport.ReactiveWorldObject', Candidate, 400.0000000)
	{
		Candidate.ReactToUsed(self);
	}
	return;
}

exec function UseAmmo(string newAmmoClass)
{
	local FiredWeapon Weapon;
	local Class<Ammunition> AmmoClass;
	local Ammunition Ammo;

	Weapon = FiredWeapon(Pawn.GetActiveItem());
	AssertWithDescription(NotEqual_ObjectObject(Weapon, none), "[tcohen] UseAmmo: Pawn's ActiveItem isn't a FiredWeapon.");
	newAmmoClass = Concat_StrStr("SwatAmmo.", newAmmoClass);
	AmmoClass = Class<Ammunition>(DynamicLoadObject(newAmmoClass, Class'Core.Class'));
	AssertWithDescription(NotEqual_ObjectObject(AmmoClass, none), Concat_StrStr(Concat_StrStr("[tcohen] UseAmmo: couln't load the ammunition class ", newAmmoClass), "."));
	Ammo = Spawn(AmmoClass, Weapon);
	AssertWithDescription(NotEqual_ObjectObject(Ammo, none), Concat_StrStr(Concat_StrStr("[tcohen] UseAmmo: failed to spawn ammunition of class ", string(AmmoClass)), "."));
	Weapon.Ammo = Ammo;
	Ammo.Initialize();
	return;
}

exec function AddRegionInjury(Actor.ESkeletalRegion Region)
{
	local SkeletalRegionInformation SkeletalRegionInformation;
	local float LimbInjuryAimErrorPenalty;

	SkeletalRegionInformation = Pawn.GetSkeletalRegionInformation(Region);
	AssertWithDescription(EqualEqual_FloatFloat(SkeletalRegionInformation.AimErrorPenalty.Min, SkeletalRegionInformation.AimErrorPenalty.Max), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("AddRegionInjury: The AimErrorPenalty for the ", string(Region)), " SkeletalRegion randomly varies from "), string(SkeletalRegionInformation.AimErrorPenalty.Min)), " to "), string(SkeletalRegionInformation.AimErrorPenalty.Max)), ", so the result of TakeHit() will not be deterministic."));
	LimbInjuryAimErrorPenalty = RandRange(SkeletalRegionInformation.AimErrorPenalty.Min, SkeletalRegionInformation.AimErrorPenalty.Max);
	AddEqual_FloatFloat(Pawn.AccumulatedLimbInjury, LimbInjuryAimErrorPenalty);
	Log(Concat_StrStr("AddRegionInjury:   Region=", string(GetEnum(Enum'Engine.Actor.ESkeletalRegion', int(Region)))));
	Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("...                SkeletalRegionInformation.AimErrorPenalty=(Min=", string(SkeletalRegionInformation.AimErrorPenalty.Min)), ", Max="), string(SkeletalRegionInformation.AimErrorPenalty.Max)), ")"));
	Log(Concat_StrStr("...                LimbInjuryAimErrorPenalty=", string(LimbInjuryAimErrorPenalty)));
	Log(Concat_StrStr("...                Pawn.AccumulatedLimbInjury=", string(Pawn.AccumulatedLimbInjury)));
	return;
}

simulated function Possess(Pawn NewPawn)
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(string(self), "---SGPC::Possess() called. Pawn="), string(Pawn)));
	}
	super(PlayerController).Possess(NewPawn);
	SwatPlayer = SwatPlayer(NewPawn);
	AssertWithDescription(NotEqual_ObjectObject(SwatPlayer, none), Concat_StrStr(Concat_StrStr("[tcohen] SwatPlayerController::Possess(", string(NewPawn)), ") NewPawn is not a SwatPlayer."));
	if(EqualEqual_ObjectObject(self, Level.GetLocalPlayerController()))
	{
		assert(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)));
		SwatPlayer.InitializeHands();
	}
	return;
}

private simulated function InternalEquipSlot(coerce HandheldEquipment.EquipmentSlot Slot)
{
	local HandheldEquipment PendingItem;

	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(string(self), "---SGPC::InternalEquipSlot(). Slot="), string(Slot)));
	}
	if(OrOr_BoolBool(EqualEqual_ObjectObject(SwatPlayer, none), Class'Engine.Pawn'.static.checkDead(SwatPlayer)))
	{
		return;
	}
	if(SwatPlayer.IsNonlethaled())
	{
		return;
	}
	if(SwatPlayer.IsInProcessOfThrowing())
	{
		return;
	}
	PendingItem = SwatPlayer.GetPendingItem();
	if(AndAnd_BoolBool(NotEqual_ObjectObject(PendingItem, none), EqualEqual_IntInt(int(PendingItem.GetSlot()), int(Slot))))
	{
		return;
	}
	if(EqualEqual_ObjectObject(SwatPlayer.GetEquipmentAtSlot(Slot), none))
	{
		ClientMessage(string(int(Slot)), 'EquipNotAvailable');
	}
	if(SwatPlayer.ValidateEquipSlot(Slot))
	{
		SetZoom(false, true);
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog("...calling ServerRequestEquip().");
		}
		SwatPlayer.ServerRequestEquip(Slot);
	}
	return;
}

simulated function InternalReload()
{
	local FiredWeapon Weapon;

	if(Level.GetEngine().EnableDevTools)
	{
		Log("...in SwatGamePlayerController::InternalReload()");
	}
	if(SwatPlayer.IsNonlethaled())
	{
		return;
	}
	if(SwatPlayer.IsInProcessOfThrowing())
	{
		return;
	}
	Weapon = FiredWeapon(Pawn.GetActiveItem());
	if(Weapon.Ammo.IsFull())
	{
		return;
	}
	if(OrOr_BoolBool(EqualEqual_ObjectObject(Weapon, none), AndAnd_BoolBool(Weapon.IsA('RoundBasedWeapon'), Weapon.Ammo.IsFull())))
	{
		return;
	}
	if(SwatPlayer.ValidateReload())
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog("...calling ServerRequestReload().");
		}
		SwatPlayer.ServerRequestReload(SwatPlayer.GetActiveItem().GetSlot());
	}
	return;
}

simulated function ConsiderAutoReloading()
{
	if(Greater_IntInt(int(bReload), 0))
	{
		Reload();
	}
	return;
}

simulated exec function EquipSlot(int Slot)
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(string(self), "---SGPC::EquipSlot(). Slot="), string(Slot)));
	}
	InternalEquipSlot(byte(Slot));
	return;
}

simulated exec function EquipNextSlot()
{
	local HandheldEquipment ActiveItem;
	local HandheldEquipment.EquipmentSlot CurrentSlot;

	ActiveItem = Pawn.GetActiveItem();
	if(NotEqual_ObjectObject(ActiveItem, none))
	{
		CurrentSlot = ActiveItem.GetSlot();
	}
	if(EqualEqual_IntInt(int(CurrentSlot), int(1)))
	{
		InternalEquipSlot(2);
	}
	else
	{
		InternalEquipSlot(1);
	}
	return;
}

simulated exec function EquipPrevSlot()
{
	local HandheldEquipment ActiveItem;
	local HandheldEquipment.EquipmentSlot CurrentSlot;

	ActiveItem = Pawn.GetActiveItem();
	if(NotEqual_ObjectObject(ActiveItem, none))
	{
		CurrentSlot = ActiveItem.GetSlot();
	}
	if(EqualEqual_IntInt(int(CurrentSlot), int(2)))
	{
		InternalEquipSlot(1);
	}
	else
	{
		InternalEquipSlot(2);
	}
	return;
}

simulated function PlayerFocusInterface GetFocusInterface(SwatGamePlayerController.EFocusInterface FocusInterface)
{
	return FocusInterfaces[int(FocusInterface)];
	return;
}

simulated function CommandInterface GetCommandInterface()
{
	return CurrentCommandInterface;
	return;
}

exec function Arrest()
{
	local SwatPawn thePawn;

	thePawn = SwatPawn(GetFocusInterface(1).GetDefaultFocusActor());
	if(AndAnd_BoolBool(NotEqual_ObjectObject(thePawn, none), thePawn.CanBeArrestedNow()))
	{
		thePawn.OnArrestBegan(SwatPlayer);
	}
	return;
}

exec function FinishArrest(bool success)
{
	local SwatPawn thePawn;

	thePawn = SwatPawn(GetFocusInterface(1).GetDefaultFocusActor());
	if(NotEqual_ObjectObject(thePawn, none))
	{
		if(success)
		{
			thePawn.OnArrested(SwatPlayer);
		}
		else
		{
			thePawn.OnArrestInterrupted(SwatPlayer);
		}
	}
	return;
}

exec function Interact()
{
	if(Not_PreBool(Class'Engine.Pawn'.static.checkDead(Pawn)))
	{
		UseInterface(GetFocusInterface(0)).Interact();
	}
	return;
}

simulated function Throw()
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---SGPC::Throw()."));
	}
	ServerRequestThrowPrep();
	return;
}

function ServerRequestThrowPrep()
{
	local Controller i, theLocalPlayerController;
	local SwatGamePlayerController Current;
	local SwatPlayer PawnWhoIsThrowing;
	local ThrownWeapon theItem;

	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---SGPC::ServerRequestThrowPrep()."));
	}
	PawnWhoIsThrowing = SwatPlayer;
	if(Not_PreBool(PawnWhoIsThrowing.CanThrowPrep()))
	{
		return;
	}
	theItem = ThrownWeapon(PawnWhoIsThrowing.GetActiveItem());
	if(OrOr_BoolBool(EqualEqual_ObjectObject(theItem, none), Not_PreBool(theItem.IsIdle())))
	{
		return;
	}
	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
	{
		theLocalPlayerController = Level.GetLocalPlayerController();
		i = Level.ControllerList;
		J0xEB:

		if(NotEqual_ObjectObject(i, none))
		{
			Current = SwatGamePlayerController(i);
			if(AndAnd_BoolBool(NotEqual_ObjectObject(Current, none), NotEqual_ObjectObject(Current, theLocalPlayerController)))
			{
				if(Level.GetEngine().EnableDevTools)
				{
					MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr("...on server: calling ClientThrowPrep() on ", string(Current)), ", PawnWhoIsThrowing="), string(PawnWhoIsThrowing)));
				}
				Current.ClientThrowPrep(PawnWhoIsThrowing);
			}
			i = i.nextController;
			// [Loop Continue]
			goto J0xEB;
		}
	}
	SwatPlayer(Pawn).GotoState('ThrowingPrep');
	return;
}

simulated function ClientThrowPrep(SwatPlayer PawnWhoIsThrowing)
{
	local ThrownWeapon Grenade;

	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(string(self), "---SGPC::ClientThrowPrep(). PawnWhoIsThrowing="), string(PawnWhoIsThrowing)));
	}
	if(NotEqual_ObjectObject(PawnWhoIsThrowing, none))
	{
		if(PawnWhoIsThrowing.CanThrowPrep())
		{
			Grenade = ThrownWeapon(PawnWhoIsThrowing.GetActiveItem());
			if(AndAnd_BoolBool(NotEqual_ObjectObject(Grenade, none), Grenade.IsIdle()))
			{
				PawnWhoIsThrowing.GotoState('ThrowingPrep');
			}
		}
	}
	return;
}

function ServerEndThrow(float ThrowHeldTime)
{
	local Controller i, theLocalPlayerController;
	local SwatGamePlayerController Current;
	local SwatPlayer PawnWhoIsThrowing;

	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(string(self), "---SGPC::ServerEndThrow(). ThrowHeldTime="), string(ThrowHeldTime)));
	}
	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
	{
		PawnWhoIsThrowing = SwatPlayer;
		theLocalPlayerController = Level.GetLocalPlayerController();
		i = Level.ControllerList;
		J0xA8:

		if(NotEqual_ObjectObject(i, none))
		{
			Current = SwatGamePlayerController(i);
			if(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(Current, none), NotEqual_ObjectObject(Current, self)), NotEqual_ObjectObject(Current, theLocalPlayerController)))
			{
				if(Level.GetEngine().EnableDevTools)
				{
					MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self), "...on server: calling ClientEndThrow() on "), string(Current)), ", PawnWhoIsThrowing="), string(PawnWhoIsThrowing)));
				}
				Current.ClientEndThrow(PawnWhoIsThrowing, ThrowHeldTime);
			}
			i = i.nextController;
			// [Loop Continue]
			goto J0xA8;
		}
	}
	SwatPlayer(Pawn).EndThrow(ThrowHeldTime);
	return;
}

simulated function ClientEndThrow(SwatPlayer PawnWhoIsThrowing, float ThrowHeldTime)
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self), "---SGPC::ClientEndThrow(). PawnWhoIsThrowing="), string(PawnWhoIsThrowing)), ", ThrowHeldTime="), string(ThrowHeldTime)));
	}
	if(AndAnd_BoolBool(NotEqual_ObjectObject(PawnWhoIsThrowing, none), NotEqual_ObjectObject(ThrownWeapon(PawnWhoIsThrowing.GetActiveItem()), none)))
	{
		PawnWhoIsThrowing.EndThrow(ThrowHeldTime);
	}
	return;
}

function ClientOnLoggedIn()
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---SGPC::ClientOnLoggedIn()."));
	}
	Repo.PostPlayerLogin(self);
	return;
}

simulated function SetMPLoadOut(DynamicLoadOutSpec LoadOut)
{
	local int i;

	SetMPLoadOutPocketWeapon(0, LoadOut.LoadOutSpec[int(0)], LoadOut.LoadOutSpec[int(1)]);
	SetMPLoadOutPocketWeapon(2, LoadOut.LoadOutSpec[int(2)], LoadOut.LoadOutSpec[int(3)]);
	i = 4;
	J0x64:

	if(Less_IntInt(i, int(25)))
	{
		SetMPLoadOutPocketItem(byte(i), LoadOut.LoadOutSpec[i]);
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x64;
	}
	ServerSetMPLoadOutSpecComplete();
	if(EqualEqual_ObjectObject(self, Level.GetLocalPlayerController()))
	{
		UpdateVoiceType();
	}
	return;
}

simulated function SetMPLoadOutPocketWeapon(HandheldEquipment.Pocket Pocket, Class<Actor> WeaponItem, Class<Actor> AmmoItem)
{
	ServerSetMPLoadOutPocketWeapon(Pocket, WeaponItem, AmmoItem);
	return;
}

simulated function SetMPLoadOutPocketItem(HandheldEquipment.Pocket Pocket, Class<Actor> Item)
{
	assert(NotEqual_IntInt(int(Pocket), int(0)));
	assert(NotEqual_IntInt(int(Pocket), int(1)));
	assert(NotEqual_IntInt(int(Pocket), int(2)));
	assert(NotEqual_IntInt(int(Pocket), int(3)));
	ServerSetMPLoadOutPocketItem(Pocket, Item);
	return;
}

function ServerSetMPLoadOutPocketWeapon(HandheldEquipment.Pocket Pocket, Class<Actor> WeaponItem, Class<Actor> AmmoItem)
{
	if(OrOr_BoolBool(EqualEqual_ObjectObject(WeaponItem, none), EqualEqual_ObjectObject(AmmoItem, none)))
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog("...weaponitem or ammoitem was None. Returning...");
		}
		return;
	}
	assert(OrOr_BoolBool(EqualEqual_IntInt(int(Pocket), int(0)), EqualEqual_IntInt(int(Pocket), int(2))));
	if(EqualEqual_IntInt(int(Pocket), int(0)))
	{
		SwatRepoPlayerItem.SetPocketItemClass(0, WeaponItem);
		SwatRepoPlayerItem.SetPocketItemClass(1, AmmoItem);
	}
	else
	{
		SwatRepoPlayerItem.SetPocketItemClass(2, WeaponItem);
		SwatRepoPlayerItem.SetPocketItemClass(3, AmmoItem);
	}
	return;
}

function ServerSetMPLoadOutPocketItem(HandheldEquipment.Pocket Pocket, Class<Actor> Item)
{
	assert(NotEqual_IntInt(int(Pocket), int(0)));
	assert(NotEqual_IntInt(int(Pocket), int(1)));
	assert(NotEqual_IntInt(int(Pocket), int(2)));
	assert(NotEqual_IntInt(int(Pocket), int(3)));
	SwatRepoPlayerItem.SetPocketItemClass(Pocket, Item);
	return;
}

function ServerSetMPLoadOutSpecComplete()
{
	SwatRepoPlayerItem.SetReadyToSpawn();
	return;
}

simulated function UpdateVoiceType()
{
	ServerSetVoiceType(SwatRepo(Level.GetRepo()).GuiConfig.GetVoiceTypeForCurrentPlayer());
	return;
}

function ServerSetVoiceType(SwatGUIConfig.eVoiceType inVoiceType)
{
	VoiceType = inVoiceType;
	if(AndAnd_BoolBool(NotEqual_ObjectObject(Pawn, none), Pawn.IsA('NetPlayer')))
	{
		NetPlayer(Pawn).VoiceType = VoiceType;
	}
	return;
}

simulated function ClientDestroyPawnsForRespawn(int TeamID)
{
	local SwatGameReplicationInfo SGRI;

	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(string(self), "---SGPC::ClientDestroyPawnsForRespawn(). TeamID="), string(TeamID)));
	}
	SGRI = SwatGameReplicationInfo(GameReplicationInfo);
	if(NotEqual_ObjectObject(SGRI, none))
	{
		NetTeam(SGRI.Teams[TeamID]).DestroyPawnsForRespawn();
	}
	return;
}

simulated function ClientAITriggerEffectEvent(SwatAI SwatAI, string UniqueIdentifier, string EffectEvent, optional Actor Other, optional Material TargetMaterial, optional Vector HitLocation, optional Rotator HitNormal, optional bool PlayOnOther, optional string ReferenceTag, optional bool MoveMouth, optional int Seed)
{
	if(EqualEqual_ObjectObject(SwatAI, none))
	{
		SwatAI = SwatAI(FindByUniqueID(none, UniqueIdentifier));
	}
	if(NotEqual_ObjectObject(SwatAI, none))
	{
		SwatAI.AITriggerEffectEvent(string(EffectEvent), Other, TargetMaterial, HitLocation, HitNormal, PlayOnOther, string(ReferenceTag), MoveMouth, Seed);
	}
	return;
}

function ServerOnEffectStopped(SwatAI SourceActor, string UniqueIdentifier, string EffectName, int Seed)
{
	if(EqualEqual_ObjectObject(SourceActor, none))
	{
		SourceActor = SwatAI(FindByUniqueID(none, UniqueIdentifier));
	}
	if(NotEqual_ObjectObject(SourceActor, none))
	{
		SourceActor.ServerOnEffectStopped(EffectName, Seed);
	}
	return;
}

function WasKilledBy(Controller Other)
{
	if(NotEqual_ObjectObject(SwatGameInfo(Level.Game), none))
	{
		SwatGameInfo(Level.Game).GameEvents.PlayerDied.Triggered(self, Other);
	}
	return;
}

simulated function SetKillerLocation(Vector inKillerLocation)
{
	KillerLocation = inKillerLocation;
	bIsKillerLocationValid = true;
	return;
}

simulated function StartDeathCam()
{
	bShouldStartDeathCam = true;
	return;
}

simulated function ForceObserverTimerCallback()
{
	return;
}

simulated function ForceObserverCam()
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "--ForceObserverCam() ... calling ClientForceObserverCam"));
	}
	ClientForceObserverCam();
	return;
}

private simulated function ClientForceObserverCam()
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "--ClientForceObserverCam() ... about to GotoState('ObserveTeam')"));
	}
	GotoState('ObserveTeam');
	return;
}

private simulated event OnReplicatedObserverCamTargetChanged()
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self), "--OnReplicatedObserverCamTargetChanged(), ReplicatedObserverCamTarget = "), string(ReplicatedObserverCamTarget)), ", GetStateName() returned '"), string(GetStateName())), "'"));
	}
	if(AndAnd_BoolBool(NotEqual_ObjectObject(ReplicatedObserverCamTarget, none), EqualEqual_NameName(GetStateName(), 'ObserveTeam')))
	{
		ViewFromPlayer(ReplicatedObserverCamTarget);
	}
	return;
}

private simulated function ViewFromPlayer(Pawn PlayerPawn)
{
	local SwatPlayer SwatPlayerPawn;

	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(string(self), "---SGPC::ViewFromPlayer(). PlayerPawn="), string(PlayerPawn)));
	}
	if(AndAnd_BoolBool(NotEqual_ObjectObject(PlayerPawn, none), NotEqual_ObjectObject(PlayerPawn, ViewTarget)))
	{
		SetViewTarget(PlayerPawn);
		RefreshCameraEffects(SwatPlayer(PlayerPawn));
		bBehindView = false;
		if(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)))
		{
			SwatPlayerPawn = SwatPlayer(PlayerPawn);
			if(AndAnd_BoolBool(NotEqual_ObjectObject(SwatPlayerPawn, none), SwatPlayerPawn.IsTheVIP()))
			{
				ClientMessage(PlayerPawn.GetHumanReadableName(), 'ViewingFromVIPEvent');
			}
			else
			{
				ClientMessage(PlayerPawn.GetHumanReadableName(), 'ViewingFromEvent');
			}
		}
		GotoState('ObserveTeam');
	}
	return;
}

simulated function ViewFromLocation(name PositionMarkerLabel)
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(string(self), "---SGPC::ViewFromLocation(). PositionMarkerLabel="), string(PositionMarkerLabel)));
	}
	ClientMessage("", 'ViewingFromNoneEvent');
	GotoState('ObserveLocation');
	SetViewTarget(GetStaticLevelPositionMarker(PositionMarkerLabel));
	return;
}

simulated function ClientViewFromLocation(string PositionMarkerLabel)
{
	ViewFromLocation(string(PositionMarkerLabel));
	return;
}

private simulated function Actor GetStaticLevelPositionMarker(name CameraPositionLabel)
{
	local Actor Marker;

	Marker = findStaticByLabel(Class'Engine.Actor', CameraPositionLabel);
	return Marker;
	return;
}

function ServerViewNextPlayer()
{
	local PlayerController Player;
	local Pawn PlayerPawn;

	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---SGPC::ServerViewNextPlayer()."));
	}
	if(AndAnd_BoolBool(NotEqual_ObjectObject(Pawn, none), Not_PreBool(Class'Engine.Pawn'.static.checkDead(Pawn))))
	{
		return;
	}
	Player = FindNextOtherPlayerOnTeam();
	if(NotEqual_ObjectObject(Player, none))
	{
		PlayerPawn = Player.Pawn;
	}
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr("...ViewTarget=", string(ViewTarget)));
		MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr("...Player=", string(Player)), ", PlayerPawn="), string(PlayerPawn)));
	}
	if(NotEqual_ObjectObject(PlayerPawn, none))
	{
		ViewFromPlayer(PlayerPawn);
		if(NotEqual_ObjectObject(self, Level.GetLocalPlayerController()))
		{
			if(Level.GetEngine().EnableDevTools)
			{
				MPLog(Concat_StrStr("...assigning ReplicatedObserverCamTarget to ", string(PlayerPawn)));
			}
			ReplicatedObserverCamTarget = PlayerPawn;
		}
	}
	else
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog("...viewing from DefaultPositionMarker");
		}
		ViewFromLocation('DefaultPositionMarker');
		ClientViewFromLocation("DefaultPositionMarker");
	}
	return;
}

function DoSetEndRoundTarget(Actor Target, string TargetName, bool TargetIsOnSWAT)
{
	assert(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)));
	SetEndRoundTarget(Target, TargetName, TargetIsOnSWAT);
	if(NotEqual_ObjectObject(self, Level.GetLocalPlayerController()))
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog("...calling ClientSetEndRoundTarget().");
		}
		ClientSetEndRoundTarget(Target, TargetName, TargetIsOnSWAT);
	}
	return;
}

simulated function ClientTriggerDynamicMusic()
{
	local SoundEffectsSubsystem SoundSys;

	SoundSys = SoundEffectsSubsystem(EffectsSystem(Level.EffectsSystem).GetSubsystem('SoundEffectsSubsystem'));
	DynamicMusicManager(SoundSys.GetMusicManager()).TriggerDynamicMusic();
	return;
}

simulated function TriggerSoundEffectSpecification(name EffectSpecification, Actor Source, Actor Target, int inSpecificSoundRef, optional Material Material, optional Vector overrideWorldLocation, optional Rotator overrideWorldRotation, optional IEffectObserver Observer)
{
	local SoundEffectsSubsystem SoundSys;
	local SoundEffectSpecification SoundSpec;

	SoundSys = SoundEffectsSubsystem(EffectsSystem(Level.EffectsSystem).GetSubsystem('SoundEffectsSubsystem'));
	SoundSpec = SoundEffectSpecification(SoundSys.FindEffectSpecification(EffectSpecification));
	if(GreaterEqual_IntInt(inSpecificSoundRef, 0))
	{
		SoundSys.PlaySpecificSoundFromSchema(SoundSpec, Source, inSpecificSoundRef, Target, Material, overrideWorldLocation, overrideWorldRotation, Observer);
	}
	else
	{
		SoundSys.PlayEffectSpecification(SoundSpec, Source, Target, Material, overrideWorldLocation, overrideWorldRotation, Observer);
	}
	return;
}

private simulated function ClientSetEndRoundTarget(Actor Target, string TargetName, bool TargetIsOnSWAT)
{
	assert(EqualEqual_IntInt(int(Level.NetMode), int(NM_Client)));
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self), "---SGPC::ClientSetEndRoundTarget(). Target="), string(Target)), ", TargetName="), TargetName));
	}
	SetEndRoundTarget(Target, TargetName, TargetIsOnSWAT);
	return;
}

private simulated function SetEndRoundTarget(Actor Target, string TargetName, bool TargetIsOnSWAT)
{
	UnPossess();
	if(EqualEqual_ObjectObject(self, Level.GetLocalPlayerController()))
	{
		UpdatePlayerTag(TargetName, TargetIsOnSWAT);
	}
	GotoState('GameEnded');
	if(NotEqual_ObjectObject(Target, none))
	{
		if(NotEqual_ObjectObject(SwatPlayer(Target), none))
		{
			RefreshCameraEffects(SwatPlayer(Target));
		}
		SetViewTarget(Target);
	}
	if(EqualEqual_ObjectObject(self, Level.GetLocalPlayerController()))
	{
		SwatGUIControllerBase(Player.GUIController).FinishEndRoundSequence();
	}
	return;
}

simulated function UpdatePlayerTag(string TargetPlayerTag, bool TargetIsOnSWAT)
{
	local export editinline HUDPageBase CachedHUDPage;

	CachedHUDPage = GetHUDPage();
	AssertWithDescription(NotEqual_ObjectObject(CachedHUDPage, none), "Could not find the Hud Page in UpdatePlayerTag.");
	if(TargetIsOnSWAT)
	{
		CachedHUDPage.PlayerTag.Style = CachedHUDPage.Controller.GetStyle(Class'SwatGame.PlayerTagInterface'.default.FriendlyTagStyle);
	}
	else
	{
		CachedHUDPage.PlayerTag.Style = CachedHUDPage.Controller.GetStyle(Class'SwatGame.PlayerTagInterface'.default.EnemyTagStyle);
	}
	CachedHUDPage.PlayerTag.SetCaption(TargetPlayerTag);
	CachedHUDPage.PlayerTag.Show();
	return;
}

simulated function ClientDestroyAllPawns()
{
	local Pawn P;

	foreach AllActors(Class'Engine.Pawn', P)
	{
		P.Destroy();
	}
	return;
}

function DoStartEndRoundSequence()
{
	assert(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)));
	StartEndRoundSequence();
	if(NotEqual_ObjectObject(self, Level.GetLocalPlayerController()))
	{
		ClientStartEndRoundSequence();
	}
	return;
}

private simulated function ClientStartEndRoundSequence()
{
	assert(EqualEqual_IntInt(int(Level.NetMode), int(NM_Client)));
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---SGPC::ClientStartEndRoundSequence()."));
	}
	StartEndRoundSequence();
	return;
}

private simulated function StartEndRoundSequence()
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---SGPC::StartEndRoundSequence()."));
	}
	if(EqualEqual_ObjectObject(self, Level.GetLocalPlayerController()))
	{
		SwatGUIControllerBase(Player.GUIController).StartEndRoundSequence();
	}
	SwatPlayer.bWantsToContinueAutoFiring = false;
	return;
}

private function PlayerController FindNextOtherPlayerOnTeam()
{
	local Controller NewController, CurrentController;

	if(bChangingTeams)
	{
		return none;
	}
	CurrentController = Controller(ViewTarget);
	if(EqualEqual_ObjectObject(CurrentController, none))
	{
		if(NotEqual_ObjectObject(Pawn(ViewTarget), none))
		{
			CurrentController = Pawn(ViewTarget).Controller;
		}
	}
	if(NotEqual_ObjectObject(CurrentController, none))
	{
		CurrentController = CurrentController.nextController;
	}
	NewController = CurrentController;
	J0x79:

	if(NotEqual_ObjectObject(NewController, none))
	{
		if(IsOtherControllerObservable(NewController))
		{
			return PlayerController(NewController);
		}
		NewController = NewController.nextController;
		// [Loop Continue]
		goto J0x79;
	}
	NewController = Level.ControllerList;
	J0xC8:

	if(NotEqual_ObjectObject(NewController, CurrentController))
	{
		if(IsOtherControllerObservable(NewController))
		{
			return PlayerController(NewController);
		}
		NewController = NewController.nextController;
		// [Loop Continue]
		goto J0xC8;
	}
	return none;
	return;
}

private function bool IsOtherControllerObservable(Controller Other)
{
	return AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(Other.bIsPlayer, NotEqual_ObjectObject(SwatGamePlayerController(Other), none)), NotEqual_ObjectObject(SwatGamePlayerController(Other).SwatPlayer, none)), Not_PreBool(SwatGamePlayerController(Other).SwatPlayer.IsTheVIP())), NotEqual_ObjectObject(Other, self)), EqualEqual_BoolBool(PlayerController(Other).IsDead(), false)), EqualEqual_ObjectObject(PlayerReplicationInfo.Team, Other.PlayerReplicationInfo.Team));
	return;
}

simulated function bool IsCuffed()
{
	return false;
	return;
}

simulated function OnArrested()
{
	AssertWithDescription(false, "[mcj] OnArrested() called on SwatGamePlayerController, and was not in BeginCuffed state.");
	return;
}

simulated function PostArrested()
{
	AssertWithDescription(false, "[mcj] PostArrested() called on SwatGamePlayerController, and was not in BeginCuffed state.");
	return;
}

simulated function OnUnarrested()
{
	AssertWithDescription(false, "[mcj] OnUnarrested() called on SwatGamePlayerController, and was not in BeginUncuffed state.");
	return;
}

exec function GotoPlayerWalking()
{
	GotoState('PlayerWalking');
	return;
}

exec function HandsDown()
{
	ShowHands();
	return;
}

exec function ShowHands()
{
	Pawn.bRenderHands = Not_PreBool(Pawn.bRenderHands);
	if(Pawn.bRenderHands)
	{
		ClientMessage("Hand/Weapon rendering is now ON", 'DebugMessage');
	}
	else
	{
		ClientMessage("Hand/Weapon rendering is now OFF", 'DebugMessage');
	}
	return;
}

exec function BattleRoom()
{
	GotoState('BattleRooming');
	return;
}

function bool HasEnteredFirstRoundOfNetworkGame()
{
	assert(EqualEqual_IntInt(int(Role), int(ROLE_Authority)));
	return SwatRepoPlayerItem.HasEnteredFirstRound();
	return;
}

function bool IsAReconnectingClient()
{
	assert(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)));
	return SwatRepoPlayerItem.bIsAReconnectingClient;
	return;
}

function SetPlayerTeam(int TeamID)
{
	ServerSetPlayerTeam(TeamID);
	return;
}

function AutoSetPlayerTeam()
{
	ServerAutoSetPlayerTeam();
	return;
}

private function ServerSetPlayerTeam(int TeamID)
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(string(self), "---SGPC::ServerSetPlayerTeam(). TeamID="), string(TeamID)));
	}
	SwatGameInfo(Level.Game).SetPlayerTeam(self, TeamID);
	return;
}

private function ServerAutoSetPlayerTeam()
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---SGPC::ServerAutoSetPlayerTeam()."));
	}
	SwatGameInfo(Level.Game).AutoSetPlayerTeam(self);
	return;
}

function ServerChangePlayerTeam()
{
	local SwatRepo theRepo;

	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---SGPC::ServerChangePlayerTeam()"));
	}
	theRepo = SwatRepo(Level.GetRepo());
	assert(NotEqual_ObjectObject(theRepo, none));
	if(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(SwatPlayer, none), SwatPlayer.IsTheVIP()), EqualEqual_IntInt(int(theRepo.GuiConfig.SwatGameState), int(4))))
	{
		return;
	}
	if(AndAnd_BoolBool(NotEqual_ObjectObject(SwatPlayer, none), OrOr_BoolBool(SwatPlayer.IsNonlethaled(), SwatPlayer.IsBeingArrestedNow())))
	{
		return;
	}
	bChangingTeams = true;
	SwatGameInfo(Level.Game).ChangePlayerTeam(self);
	return;
}

function ServerSetPlayerReady()
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---SGPC::ServerSetPlayerReady()."));
	}
	SwatGameInfo(Level.Game).SetPlayerReady(self);
	return;
}

function ServerSetPlayerNotReady()
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---SGPC::ServerSetPlayerNotReady()."));
	}
	SwatGameInfo(Level.Game).SetPlayerNotReady(self);
	return;
}

function ClientGameEnded()
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---SGPC::ClientGameEnded()."));
	}
	super(Controller).ClientGameEnded();
	Repo.OnMissionEnded();
	LogScores();
	return;
}

function ClientRoundStarted()
{
	local Actor Marker;

	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---SGPC::ClientRoundStarted()."));
	}
	Marker = findStaticByLabel(Class'Engine.Actor', 'BombExplodedMarker');
	if(NotEqual_ObjectObject(Marker, none))
	{
		Marker.UnTriggerEffectEvent('PostBombExploded');
	}
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr("...Level   =", string(Level)));
		MPLog(Concat_StrStr("...Repo    =", string(Level.GetRepo())));
		MPLog(Concat_StrStr("...SwatRepo=", string(Repo)));
	}
	Repo.OnMissionStarted();
	return;
}

event ClientMessage(coerce string S, optional name Type)
{
	TeamMessage(PlayerReplicationInfo, S, Type);
	return;
}

event TeamMessage(PlayerReplicationInfo PRI, coerce string S, name Type)
{
	if(AndAnd_BoolBool(OrOr_BoolBool(EqualEqual_NameName(Type, 'Say'), EqualEqual_NameName(Type, 'TeamSay')), NotEqual_ObjectObject(PRI, none)))
	{
		S = Concat_StrStr(Concat_StrStr(PRI.PlayerName, "	"), S);
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("ChatMessage( ", S), ", "), string(Type)), " )"));
		}
	}
	switch(Type)
	{
		case 'None':
			Type = 'Event';
			break;
		case 'OneMinWarning':
			OnOneMinWarning();
			break;
		case 'BombExploded':
			OnBombExploded();
			break;
		case 'MissionEnded':
			dispatchMessage(Class'SwatGame.MessageMissionEnded'.static.Allocate(self)., Construct_Void());
			break;
		case 'MissionCompleted':
			dispatchMessage(Class'SwatGame.MessageMissionCompleted'.static.Allocate(self)., Construct_Void());
			break;
		case 'MissionFailed':
			dispatchMessage(Class'SwatGame.MessageMissionFailed'.static.Allocate(self)., Construct_Void());
			break;
		default:
			break;
	}
	TriggerEffectEvent(Type,,,,,,,, GetEnum(Enum'Engine.Repo.EMPMode', int(ServerSettings(Level.CurrentServerSettings).GameType)));
	if(OrOr_BoolBool(OrOr_BoolBool(EqualEqual_ObjectObject(Player, none), EqualEqual_ObjectObject(Player.GUIController, none)), SwatGUIControllerBase(Player.GUIController).OnMessageRecieved(S, Type)))
	{
		return;
	}
	if(NotEqual_ObjectObject(myHUD, none))
	{
		if(EqualEqual_NameName(Type, 'Say'))
		{
			myHUD.AddTextMessage(S, Class'SwatGame.ChatGlobalMessage', PRI);
		}
		else
		{
			if(EqualEqual_NameName(Type, 'TeamSay'))
			{
				myHUD.AddTextMessage(S, Class'SwatGame.ChatTeamMessage', PRI);
			}
			else
			{
				myHUD.Message(PRI, S, Type);
			}
		}
	}
	Player.Console.Message(S, 6.0000000);
	return;
}

exec function Talk()
{
	local Console Console;

	Console = Console(Player.InteractionMaster.Console);
	if(NotEqual_ObjectObject(Console, none))
	{
		Console.Talk();
	}
	return;
}

exec function TeamTalk()
{
	local Console Console;

	Console = Console(Player.InteractionMaster.Console);
	if(NotEqual_ObjectObject(Console, none))
	{
		Console.TeamTalk();
	}
	return;
}

exec function JoinTeam(string TeamName)
{
	if(ComplementEqual_StrStr(TeamName, "A"))
	{
		SetPlayerTeam(0);
	}
	else
	{
		if(ComplementEqual_StrStr(TeamName, "B"))
		{
			SetPlayerTeam(1);
		}
	}
	return;
}

exec function AutoJoinTeam()
{
	AutoSetPlayerTeam();
	return;
}

exec function ChangeTeam(int n)
{
	return;
}

exec function LogScores()
{
	local int i;
	local SwatGameReplicationInfo GameInfo;
	local SwatPlayerReplicationInfo PlayerInfo;
	local SwatGamePlayerController SGPC;

	GameInfo = SwatGameReplicationInfo(GameReplicationInfo);
	if(NotEqual_ObjectObject(GameInfo, none))
	{
		Log("=====================================");
		Log("Scores");
		Log("");
		Log("-- Teams --");
		Log("");
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("Team A", string(GameInfo.Teams[0].TeamIndex)), " (SWAT):     "), string(NetTeam(GameInfo.Teams[0]).NetScoreInfo.GetScore())));
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("Team B", string(GameInfo.Teams[1].TeamIndex)), " (Bad Guys): "), string(NetTeam(GameInfo.Teams[1]).NetScoreInfo.GetScore())));
		Log("");
		Log("");
		Log("-- Players --");
		Log("");
		i = 0;
		J0x151:

		if(Less_IntInt(i, 16))
		{
			PlayerInfo = GameInfo.PRIStaticArray[i];
			if(NotEqual_ObjectObject(PlayerInfo, none))
			{
				Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(PlayerInfo.PlayerName, " ["), PlayerInfo.Team.TeamName), "]: "), string(PlayerInfo.NetScoreInfo.GetScore())));
			}
			AddAdd_PreInt(i);
			// [Loop Continue]
			goto J0x151;
		}
		Log("=====================================");
		Log(" Mapping of names to playercontrollers:");
		Log("");
		foreach AllActors(Class'SwatGame.SwatGamePlayerController', SGPC)
		{
			Log(Concat_StrStr(Concat_StrStr(string(SGPC), " has name: "), SGPC.PlayerReplicationInfo.PlayerName));
		}
		Log("");
		Log("=====================================");
	}
	return;
}

exec function LogBestClusters()
{
	local GameModeMPBase GameModeMPBase;

	GameModeMPBase = GameModeMPBase(SwatGameInfo(Level.Game).GetGameMode());
	if(NotEqual_ObjectObject(GameModeMPBase, none))
	{
		GameModeMPBase.SetStartClusterForRespawn(0);
		GameModeMPBase.SetStartClusterForRespawn(1);
	}
	return;
}

event PlayerTick(float dTime)
{
	super(PlayerController).PlayerTick(dTime);
	UpdateLooking(dTime);
	UpdateRecoil();
	if(EqualEqual_ObjectObject(Pawn, none))
	{
		return;
	}
	if(SwatPawn(Pawn).bWantsToContinueAutoFiring)
	{
		SwatPawn(Pawn).bWantsToContinueAutoFiring = Greater_IntInt(int(bFire), 0);
		if(AndAnd_BoolBool(AndAnd_BoolBool(Not_PreBool(SwatPawn(Pawn).bWantsToContinueAutoFiring), NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone))), Pawn.IsControlledByLocalHuman()))
		{
			Pawn.ServerEndFiringWeapon();
		}
	}
	if(NotEqual_BoolBool(LastBehindView, bBehindView))
	{
		LastBehindView = bBehindView;
		SwatPawn(Pawn).OnPlayerViewChanged();
	}
	return;
}

simulated function RefreshCameraEffects(SwatPlayer Victim)
{
	if(NotEqual_ObjectObject(Victim, SwatPlayer(ViewTarget)))
	{
		return;
	}
	RemoveAllCameraEffects();
	if(OrOr_BoolBool(EqualEqual_ObjectObject(Victim, none), Victim.bDeleteMe))
	{
		return;
	}
	if(Victim.IsFlashbanged())
	{
		AddCameraEffect(FlashbangCameraEffect, true, true, false);
	}
	if(Victim.IsPepperSprayed())
	{
		AddCameraEffect(PepperSprayCameraEffect, true, true, false);
	}
	if(Victim.IsGassed())
	{
		AddCameraEffect(CSGasCameraEffect, true, true, false);
	}
	if(Victim.IsStung())
	{
		AddCameraEffect(StingCameraEffect, true, true, false);
	}
	return;
}

event RenderTexture(ScriptedTexture inTexture)
{
	local Actor ViewTarget;
	local Vector CameraLocation;
	local Rotator CameraRotation;

	PlayerCalcView(ViewTarget, CameraLocation, CameraRotation);
	inTexture.DrawPortal(0, 0, FlashbangRetinaImageTextureWidth, FlashbangRetinaImageTextureHeight, self, CameraLocation, CameraRotation, int(FovAngle));
	return;
}

simulated function UpdateLooking(float dTime)
{
	local float LastMouseDistance;

	LastMouseDistance = Add_FloatFloat(Square(Subtract_FloatFloat(aMouseX, LastMouseX)), Square(Subtract_FloatFloat(aMouseY, LastMouseY)));
	MouseDistancePerSecond = Multiply_FloatFloat(LastMouseDistance, dTime);
	LastMouseX = aMouseX;
	LastMouseY = aMouseY;
	return;
}

simulated function UpdateRecoil()
{
	local float Time;

	if(Not_PreBool(Recoiling))
	{
		return;
	}
	Time = Level.TimeSeconds;
	if(Greater_FloatFloat(Time, Add_FloatFloat(Add_FloatFloat(RecoilStartTime, RecoilBackDuration), RecoilForeDuration)))
	{
		FinishRecoiling();
		return;
	}
	if(Less_FloatFloat(Time, Add_FloatFloat(RecoilStartTime, RecoilBackDuration)))
	{
		UpdateRecoilBack(Time);
	}
	else
	{
		UpdateRecoilFore(Time);
	}
	return;
}

simulated function FinishRecoiling()
{
	local float Time;

	Time = Add_FloatFloat(Add_FloatFloat(RecoilStartTime, RecoilBackDuration), RecoilForeDuration);
	UpdateRecoilFore(Time);
	Recoiling = false;
	return;
}

simulated function UpdateRecoilBack(float Time)
{
	local float ElapsedRecoilBackTime, CurrentValue, DeltaPitch;
	local Rotator NewRotation;

	ElapsedRecoilBackTime = Subtract_FloatFloat(Time, RecoilStartTime);
	CurrentValue = Multiply_FloatFloat(Sin(ScaleRecoilDuration(ElapsedRecoilBackTime, RecoilBackDuration)), RecoilMagnitude);
	DeltaPitch = Subtract_FloatFloat(CurrentValue, LastRecoilFunctionValue);
	NewRotation = Rotation;
	if(LessEqual_IntInt(NewRotation.Pitch, 18000))
	{
		NewRotation.Pitch = Min(int(Add_FloatFloat(float(NewRotation.Pitch), DeltaPitch)), 18000);
	}
	else
	{
		AddEqual_IntInt(NewRotation.Pitch, int(DeltaPitch));
	}
	SetRotation(NewRotation);
	LastRecoilFunctionValue = CurrentValue;
	return;
}

simulated function UpdateRecoilFore(float Time)
{
	local float ElapsedRecoilForeTime, CurrentValue, DeltaPitch;
	local Rotator NewRotation;

	ElapsedRecoilForeTime = Subtract_FloatFloat(Subtract_FloatFloat(Time, RecoilStartTime), RecoilBackDuration);
	CurrentValue = Multiply_FloatFloat(Cos(ScaleRecoilDuration(ElapsedRecoilForeTime, RecoilForeDuration)), RecoilMagnitude);
	DeltaPitch = Subtract_FloatFloat(CurrentValue, LastRecoilFunctionValue);
	NewRotation = Rotation;
	if(LessEqual_IntInt(NewRotation.Pitch, 18000))
	{
		NewRotation.Pitch = Min(int(Add_FloatFloat(float(NewRotation.Pitch), DeltaPitch)), 18000);
	}
	else
	{
		AddEqual_IntInt(NewRotation.Pitch, int(DeltaPitch));
	}
	SetRotation(NewRotation);
	LastRecoilFunctionValue = CurrentValue;
	return;
}

simulated function float ScaleRecoilDuration(float ElapsedTime, float Duration)
{
	return Divide_FloatFloat(Multiply_FloatFloat(1.5707960, ElapsedTime), Duration);
	return;
}

function AddRecoil(float inRecoilBackDuration, float inRecoilForeDuration, float inRecoilMagnitude, optional float AutoFireRecoilMagnitudeIncrement, optional int AutoFireShotIndex)
{
	RecoilStartTime = Level.TimeSeconds;
	RecoilBackDuration = inRecoilBackDuration;
	RecoilForeDuration = inRecoilForeDuration;
	RecoilMagnitude = Add_FloatFloat(inRecoilMagnitude, Multiply_FloatFloat(AutoFireRecoilMagnitudeIncrement, float(AutoFireShotIndex)));
	LastRecoilFunctionValue = 0.0000000;
	Recoiling = true;
	return;
}

// Export USwatGamePlayerController::execGetLookAroundSpeed(FFrame&, void* const)
native simulated event float GetLookAroundSpeed();

exec function PawnCollision(int On)
{
	local Pawn Pawn;
	local bool bOn;

	bOn = NotEqual_IntInt(On, 0);
	Pawn = none;
	foreach AllActors(Class'Engine.Pawn', Pawn)
	{
		Pawn.bBlockPlayers = bOn;
		Pawn.bBlockActors = bOn;
	}
	return;
}

exec function ToggleLowReady()
{
	local SwatPlayer PlayerPawn;

	PlayerPawn = SwatPlayer(Pawn);
	if(NotEqual_ObjectObject(PlayerPawn, none))
	{
		PlayerPawn.SetLowReady(Not_PreBool(PlayerPawn.IsLowReady()));
	}
	return;
}

final function string Pad(int Length, coerce string S)
{
	J0x00:
	if(Less_IntInt(Len(S), Length))
	{
		S = Concat_StrStr(S, " ");
		// [Loop Continue]
		goto J0x00;
	}
	return S;
	return;
}

function int GetSwatPlayerID()
{
	return SwatPlayerID;
	return;
}

function bool HandsShouldIdle()
{
	local HandheldEquipment Item;

	Item = Pawn.GetActiveItem();
	return AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(Item, none), Item.IsIdle()), Item.IsAvailable()), SwatPlayer.HandsShouldIdle());
	return;
}

exec function CommandInterfaceNextGroup()
{
	local CommandInterface CCI, GCI;

	CCI = CommandInterface(GetFocusInterface(2));
	GCI = CommandInterface(GetFocusInterface(3));
	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
	{
		if(NotEqual_ObjectObject(CCI, none))
		{
			CCI.NextTeam();
		}
		if(NotEqual_ObjectObject(GCI, none))
		{
			GCI.NextTeam();
		}
	}
	else
	{
		if(NotEqual_ObjectObject(CCI, none))
		{
			CCI.NextMainPage();
		}
		if(NotEqual_ObjectObject(GCI, none))
		{
			GCI.NextMainPage();
		}
	}
	return;
}

simulated function SetPlayerCommandInterfaceTeam(name Team)
{
	local CommandInterface CCI, GCI;

	CCI = CommandInterface(GetFocusInterface(2));
	GCI = CommandInterface(GetFocusInterface(3));
	if(NotEqual_ObjectObject(CCI, none))
	{
		CCI.SetCurrentTeam_Name(Team);
	}
	if(NotEqual_ObjectObject(GCI, none))
	{
		GCI.SetCurrentTeam_Name(Team);
	}
	return;
}

exec function PlayerCommandInterfaceBack()
{
	GetCommandInterface().back();
	return;
}

exec function GiveCommand(int CommandIndex)
{
	local ClassicCommandInterface CCI;

	if(NotEqual_IntInt(int(Repo.GuiConfig.CurrentCommandInterfaceStyle), int(1)))
	{
		return;
	}
	if(OrOr_BoolBool(EqualEqual_ObjectObject(Pawn, none), Class'Engine.Pawn'.static.checkDead(Pawn)))
	{
		return;
	}
	CCI = ClassicCommandInterface(GetCommandInterface());
	assert(NotEqual_ObjectObject(CCI, none));
	if(Not_PreBool(CCI.Enabled))
	{
		return;
	}
	CCI.GiveCommandIndex(CommandIndex);
	return;
}

exec function OpenGraphicCommandInterface()
{
	local GraphicCommandInterface GCI;

	if(NotEqual_IntInt(int(Repo.GuiConfig.CurrentCommandInterfaceStyle), int(2)))
	{
		return;
	}
	if(OrOr_BoolBool(EqualEqual_ObjectObject(Pawn, none), Class'Engine.Pawn'.static.checkDead(Pawn)))
	{
		return;
	}
	GCI = GraphicCommandInterface(GetCommandInterface());
	assert(NotEqual_ObjectObject(GCI, none));
	GCI.Open();
	return;
}

exec function CommandOrEquip(SwatGamePlayerController.NumberRow Row, int Number)
{
	if(AndAnd_BoolBool(EqualEqual_IntInt(int(Row), int(1)), EqualEqual_IntInt(int(Repo.GuiConfig.CurrentCommandInterfaceStyle), int(1))))
	{
		GiveCommand(Number);
	}
	else
	{
		if(AndAnd_BoolBool(EqualEqual_IntInt(int(Row), int(0)), EqualEqual_IntInt(int(Repo.GuiConfig.CurrentCommandInterfaceStyle), int(2))))
		{
			return;
		}
		else
		{
			EquipSlot(Number);
		}
	}
	return;
}

function ServerGiveCommand(int CommandIndex, bool IsTaunt, Pawn Source, string SourceID, Actor TargetActor, string TargetID, Vector TargetLocation, SwatGUIConfig.eVoiceType VoiceType)
{
	local SwatGamePlayerController PC;
	local Controller Controller;
	local string SourceActorName;

	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("SwatGamePlayerController::ServerGiveCommand() Sending to clients CommandIndex=", string(CommandIndex)), ", TargetActor="), string(TargetActor)), ", TargetLocation="), string(TargetLocation)), ", Source="), string(Source)));
	}
	if(EqualEqual_ObjectObject(Source, none))
	{
		Source = Pawn(FindByUniqueID(Class'Engine.Pawn', SourceID));
	}
	SourceActorName = Source.Controller.GetHumanReadableName();
	Controller = Level.ControllerList;
	J0x122:

	if(NotEqual_ObjectObject(Controller, none))
	{
		PC = SwatGamePlayerController(Controller);
		if(AndAnd_BoolBool(NotEqual_ObjectObject(PC, none), NotEqual_ObjectObject(PC, self)))
		{
			if(OrOr_BoolBool(EqualEqual_ObjectObject(PC.Pawn, none), EqualEqual_ObjectObject(NetPlayer(PC.Pawn), none)))
			{
				if(Level.GetEngine().EnableDevTools)
				{
					MPLog(Concat_StrStr(Concat_StrStr("... skipping ClientReceiveCommand() for PC=", string(PC)), " because the PC doesnt have a pawn."));
				}
			}
			else
			{
				if(AndAnd_BoolBool(Not_PreBool(IsTaunt), NotEqual_IntInt(NetPlayer(PC.Pawn).GetTeamNumber(), NetPlayer(Pawn).GetTeamNumber())))
				{
					if(Level.GetEngine().EnableDevTools)
					{
						MPLog(Concat_StrStr(Concat_StrStr("... skipping ClientReceiveCommand() for PC=", string(PC)), " because the command is not a Taunt, and PC is on a different team."));
					}
				}
				else
				{
					if(Level.GetEngine().EnableDevTools)
					{
						MPLog(Concat_StrStr("... calling ClientReceiveCommand() on PC=", string(PC)));
					}
					PC.ClientReceiveCommand(CommandIndex, Source, SourceID, SourceActorName, TargetActor, TargetID, TargetLocation, VoiceType);
				}
			}
		}
		Controller = Controller.nextController;
		// [Loop Continue]
		goto J0x122;
	}
	return;
}

simulated function ClientReceiveCommand(int CommandIndex, Actor Source, string SourceID, string SourceActorName, Actor TargetActor, string TargetID, Vector TargetLocation, SwatGUIConfig.eVoiceType VoiceType)
{
	GetCommandInterface().ReceiveCommandMP(CommandIndex, Source, SourceID, SourceActorName, TargetActor, TargetID, TargetLocation, VoiceType);
	return;
}

private function OnOfficerIncapacitated()
{
	local CommandInterface CCI, GCI;

	CCI = CommandInterface(GetFocusInterface(2));
	GCI = CommandInterface(GetFocusInterface(3));
	if(NotEqual_ObjectObject(CCI, none))
	{
		CCI.CheckTeam();
	}
	if(NotEqual_ObjectObject(GCI, none))
	{
		GCI.CheckTeam();
	}
	return;
}

simulated function ClientReloadForPawn(SwatPlayer theSwatPlayer, HandheldEquipment.EquipmentSlot ItemSlot)
{
	local FiredWeapon Item;
	local OfficerLoadOut theLoadOut;

	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self), "---SGPC::ClientReloadForPawn(). Told by server to reload item. Pawn="), string(theSwatPlayer)), ", Slot="), string(ItemSlot)));
	}
	if(EqualEqual_ObjectObject(theSwatPlayer, none))
	{
		return;
	}
	theLoadOut = theSwatPlayer.GetLoadOut();
	if(EqualEqual_ObjectObject(theLoadOut, none))
	{
		return;
	}
	Item = FiredWeapon(theLoadOut.GetItemAtSlot(ItemSlot));
	if(EqualEqual_ObjectObject(Item, none))
	{
		return;
	}
	if(AndAnd_BoolBool(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)), Not_PreBool(Item.PrevalidateReload())))
	{
		return;
	}
	if(theSwatPlayer.ValidateReload())
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog(Concat_StrStr("...Calling Reload() on: ", string(Item)));
		}
		Item.Reload();
	}
	return;
}

simulated function ClientDoAIReload(Pawn theAIPawn)
{
	local FiredWeapon Item;

	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr("---SGPC::ClientDoAIReload(). Told by server to reload. Pawn=", string(theAIPawn)));
	}
	assert(EqualEqual_IntInt(int(Level.NetMode), int(NM_Client)));
	assert(Level.IsPlayingCOOP);
	if(EqualEqual_ObjectObject(theAIPawn, none))
	{
		return;
	}
	Item = FiredWeapon(theAIPawn.GetActiveItem());
	AssertWithDescription(NotEqual_ObjectObject(Item, none), Concat_StrStr("Was told to reload for an AI, but the active item was None. Pawn=", string(theAIPawn)));
	if(EqualEqual_ObjectObject(Item, none))
	{
		return;
	}
	if(Item.PrevalidateReload())
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog(Concat_StrStr("...Calling Reload() on: ", string(Item)));
		}
		Item.Reload();
	}
	return;
}

simulated function HUDPageBase GetHUDPage()
{
	if(EqualEqual_ObjectObject(HUDPage, none))
	{
		if(AndAnd_BoolBool(EqualEqual_ObjectObject(self, Level.GetLocalPlayerController()), NotEqual_ObjectObject(Repo.GUIController, none)))
		{
			HUDPage = SwatGUIControllerBase(Repo.GUIController).GetHUDPage();
		}
	}
	return HUDPage;
	return;
}

simulated function bool HasHUDPage()
{
	if(EqualEqual_ObjectObject(HUDPage, none))
	{
		GetHUDPage();
	}
	return NotEqual_ObjectObject(HUDPage, none);
	return;
}

exec function ToggleFlashLight()
{
	SwatPawn(Pawn).ToggleDesiredFlashlightState();
	return;
}

exec function IssueCompliance()
{
	local name PlayerTag;

	if(NotEqual_ObjectObject(NetPlayer(Pawn), none))
	{
		if(NetPlayer(Pawn).IsTheVIP())
		{
			PlayerTag = 'VIP';
		}
		else
		{
			PlayerTag = Repo.GuiConfig.GetTagForVoiceType(NetPlayer(Pawn).VoiceType);
		}
	}
	ServerIssueCompliance(string(PlayerTag));
	return;
}

function ServerIssueCompliance(string VoiceTag)
{
	local bool ACharacterHasAWeaponEquipped;
	local NetPlayer theNetPlayer;

	if(CanIssueCompliance())
	{
		StartIssueComplianceTimer();
		theNetPlayer = NetPlayer(Pawn);
		if(AndAnd_BoolBool(NotEqual_ObjectObject(theNetPlayer, none), Not_PreBool(Level.IsPlayingCOOP)))
		{
			if(AndAnd_BoolBool(AndAnd_BoolBool(theNetPlayer.IsTheVIP(), theNetPlayer.IsArrested()), Not_PreBool(theNetPlayer.IsNonlethaled())))
			{
				assert(EqualEqual_NameName(string(VoiceTag), 'VIP'));
				Pawn.BroadcastEffectEvent('VIPHelp',,,,,,,, string(VoiceTag));
			}
			return;
		}
		ACharacterHasAWeaponEquipped = SwatPawn(Pawn).IssueCompliance();
		if(ACharacterHasAWeaponEquipped)
		{
			Pawn.BroadcastEffectEvent('AnnouncedComplyWithGun',,,,,,,, string(VoiceTag));
		}
		else
		{
			Pawn.BroadcastEffectEvent('AnnouncedComply',,,,,,,, string(VoiceTag));
		}
	}
	return;
}

simulated function bool CanIssueCompliance()
{
	return OrOr_BoolBool(EqualEqual_ObjectObject(ComplianceTimer, none), Not_PreBool(ComplianceTimer.IsRunning()));
	return;
}

simulated function StartIssueComplianceTimer()
{
	if(EqualEqual_ObjectObject(ComplianceTimer, none))
	{
		ComplianceTimer = Spawn(Class'Engine.Timer');
	}
	assert(NotEqual_ObjectObject(ComplianceTimer, none));
	ComplianceTimer.StartTimer(ComplianceTime, false, true);
	return;
}

simulated function bool CanIssueCommand()
{
	return OrOr_BoolBool(EqualEqual_ObjectObject(CommandTimer, none), Not_PreBool(CommandTimer.IsRunning()));
	return;
}

simulated function StartIssueCommandTimer()
{
	if(EqualEqual_ObjectObject(CommandTimer, none))
	{
		CommandTimer = Spawn(Class'Engine.Timer');
	}
	assert(NotEqual_ObjectObject(CommandTimer, none));
	CommandTimer.StartTimer(CommandTime, false, true);
	return;
}

exec function IssueComplianceOrInteract()
{
	if(NotEqual_ObjectObject(GetFocusInterface(0).GetDefaultFocusActor(), none))
	{
		Interact();
	}
	else
	{
		IssueCompliance();
	}
	return;
}

exec function GiveDefaultCommand()
{
	if(OrOr_BoolBool(EqualEqual_ObjectObject(Pawn, none), Class'Engine.Pawn'.static.checkDead(Pawn)))
	{
		return;
	}
	if(GetCommandInterface().Enabled)
	{
		GetCommandInterface().GiveDefaultCommand();
	}
	return;
}

simulated function OnStateChange(SwatGUIConfig.eSwatGameState oldState, SwatGUIConfig.eSwatGameState NewState)
{
	local DynamicLoadOutSpec CurrentMultiplayerLoadOut;

	Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[dkaplan] >>> OnStateChange of (SwatGamePlayerController) ", string(self)), " from state "), string(GetEnum(Enum'SwatGame.SwatGUIConfig.eSwatGameState', int(oldState)))), " to state "), string(GetEnum(Enum'SwatGame.SwatGUIConfig.eSwatGameState', int(NewState)))));
	if(AndAnd_BoolBool(EqualEqual_IntInt(int(NewState), int(3)), OrOr_BoolBool(EqualEqual_IntInt(int(Repo.GuiConfig.SwatGameRole), int(5)), EqualEqual_IntInt(int(Repo.GuiConfig.SwatGameRole), int(4)))))
	{
		CurrentMultiplayerLoadOut = Spawn(Class'SwatGame.DynamicLoadOutSpec',, string("CurrentMultiplayerLoadOut"));
		SetMPLoadOut(CurrentMultiplayerLoadOut);
		CurrentMultiplayerLoadOut.Destroy();
		ViewFromLocation('InitialPositionMarker');
	}
	else
	{
		if(AndAnd_BoolBool(AndAnd_BoolBool(EqualEqual_IntInt(int(NewState), int(4)), NotEqual_IntInt(int(Repo.GuiConfig.SwatGameRole), int(5))), NotEqual_IntInt(int(Repo.GuiConfig.SwatGameRole), int(4))))
		{
			SetPause(false);
		}
		else
		{
			if(AndAnd_BoolBool(AndAnd_BoolBool(EqualEqual_IntInt(int(NewState), int(5)), NotEqual_IntInt(int(Repo.GuiConfig.SwatGameRole), int(5))), NotEqual_IntInt(int(Repo.GuiConfig.SwatGameRole), int(4))))
			{
				bIsObserving = true;
				SetPause(Not_PreBool(SPBombExploded));
			}
			else
			{
				if(AndAnd_BoolBool(EqualEqual_IntInt(int(NewState), int(5)), OrOr_BoolBool(EqualEqual_IntInt(int(Repo.GuiConfig.SwatGameRole), int(5)), EqualEqual_IntInt(int(Repo.GuiConfig.SwatGameRole), int(4)))))
				{
					SoundEffectsSubsystem(EffectsSystem(Level.EffectsSystem).GetSubsystem('SoundEffectsSubsystem')).StopAllLoopingSchemas();
				}
			}
		}
	}
	return;
}

event PreClientTravel()
{
	Repo.PreClientTravel();
	super(PlayerController).PreClientTravel();
	return;
}

exec function TestStung()
{
	local Range Range;

	Range.Min = 0.0000000;
	Range.Max = 0.0000000;
	SwatPlayer(Pawn).ReactToStingGrenade(none, none, 0.0000000, 0.0000000, Range, 0.0000000, 0.0000000, 10.0000000, 6.0000000, 0.0000000, 0.0000000);
	return;
}

exec function Loc()
{
	local Actor Act;
	local Vector Loc;
	local Rotator Rot;

	PlayerCalcView(Act, Loc, Rot);
	Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("Player == ", string(Act)), ", Location == "), string(Loc)), ", Rotation == "), string(Rot)));
	return;
}

simulated function SetAlwaysRun(bool NewValue)
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(string(self), "---SGPC::SetAlwaysRun(). NewValue="), string(NewValue)));
	}
	bAlwaysRun = NewValue;
	ServerSetAlwaysRun(NewValue);
	return;
}

function ServerSetAlwaysRun(bool NewValue)
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(string(self), "---SGPC::ServerSetAlwaysRun(). NewValue="), string(NewValue)));
	}
	bAlwaysRun = NewValue;
	return;
}

function HandleWalking()
{
	local bool WantsToWalk;

	if(IsLocationFrozen())
	{
		aForward = 0.0000000;
		aStrafe = 0.0000000;
	}
	if(IsRotationFrozen())
	{
		aLookUp = 0.0000000;
		aTurn = 0.0000000;
	}
	if(NotEqual_ObjectObject(Pawn, none))
	{
		WantsToWalk = EqualEqual_BoolBool(bool(bRun), bAlwaysRun);
		Pawn.SetWalking(AndAnd_BoolBool(WantsToWalk, Not_PreBool(Region.Zone.IsA('WarpZoneInfo'))));
		if(AndAnd_BoolBool(EqualEqual_FloatFloat(aForward, float(0)), EqualEqual_FloatFloat(aStrafe, float(0))))
		{
			if(NotEqual_IntInt(int(LastMovingMode), int(0)))
			{
				TransitionToStanding(LastMovingMode);
			}
		}
		else
		{
			if(WantsToWalk)
			{
				if(NotEqual_IntInt(int(LastMovingMode), int(1)))
				{
					TransitionToWalking(LastMovingMode);
				}
			}
			else
			{
				if(NotEqual_IntInt(int(LastMovingMode), int(2)))
				{
					TransitionToRunning(LastMovingMode);
				}
			}
		}
	}
	return;
}

function TransitionToStanding(SwatGamePlayerController.MovingMode inLastMovingMode)
{
	LastMovingMode = 0;
	return;
}

function TransitionToWalking(SwatGamePlayerController.MovingMode inLastMovingMode)
{
	LastMovingMode = 1;
	if(AndAnd_BoolBool(EqualEqual_IntInt(int(inLastMovingMode), int(0)), EqualEqual_IntInt(int(Pawn.LeanState), int(0))))
	{
		ConsiderAddingAimError(1);
	}
	return;
}

function TransitionToRunning(SwatGamePlayerController.MovingMode inLastMovingMode)
{
	LastMovingMode = 2;
	if(EqualEqual_IntInt(int(Pawn.LeanState), int(0)))
	{
		ConsiderAddingAimError(2);
		if(EqualEqual_IntInt(int(inLastMovingMode), int(0)))
		{
			ConsiderAddingAimError(1);
		}
	}
	return;
}

function ConsiderAddingAimError(FiredWeapon.AimPenaltyType Penalty)
{
	local HandheldEquipment ActiveItem;

	ActiveItem = Pawn.GetActiveItem();
	if(AndAnd_BoolBool(NotEqual_ObjectObject(ActiveItem, none), ActiveItem.IsA('FiredWeapon')))
	{
		FiredWeapon(ActiveItem).AddAimError(Penalty);
	}
	return;
}

function ClientSkeletalRegionHit(Actor.ESkeletalRegion RegionHit, int Damage)
{
	assert(EqualEqual_ObjectObject(self, Level.GetLocalPlayerController()));
	GetHUDPage().SkeletalRegionHit(RegionHit, Damage);
	return;
}

simulated function OnBombExploded()
{
	local BombBase Bomb;
	local Actor Marker;
	local Pawn P;

	Marker = findStaticByLabel(Class'Engine.Actor', 'BombExplodedMarker');
	Marker.TriggerEffectEvent('PostBombExploded');
	foreach DynamicActors(Class'SwatGame.BombBase', Bomb)
	{
		Bomb.TriggerEffectEvent('BombExploded');
		Bomb.Hide();
	}
	foreach DynamicActors(Class'Engine.Pawn', P)
	{
		P.Died(none, Class'Engine.GenericDamageType', vect(0.0000000, 0.0000000, 0.0000000), vect(0.0000000, 0.0000000, 0.0000000));
	}
	dispatchMessage(Class'SwatGame.MessageBombExploded'.static.Allocate(self)., Construct_Void());
	if(AndAnd_BoolBool(NotEqual_IntInt(int(Repo.GuiConfig.SwatGameRole), int(5)), NotEqual_IntInt(int(Repo.GuiConfig.SwatGameRole), int(4))))
	{
		SPBombExploded = true;
		SetViewTarget(Marker);
		UnPossess();
		GotoState('GameEnded');
	}
	return;
}

simulated function OnOneMinWarning()
{
	local BombBase Bomb;

	foreach DynamicActors(Class'SwatGame.BombBase', Bomb)
	{
		if(Bomb.isActive())
		{
			Bomb.TriggerEffectEvent('OneMinWarning');
		}
	}
	return;
}

simulated function bool IsLocationFrozen()
{
	local SwatPlayer thePlayer;

	thePlayer = SwatPlayer(Pawn);
	if(NotEqual_ObjectObject(Pawn, none))
	{
		if(thePlayer.IsTheVIP())
		{
			return OrOr_BoolBool(OrOr_BoolBool(DebugLocationFrozen, thePlayer.IsTased()), AndAnd_BoolBool(thePlayer.IsNonlethaled(), thePlayer.IsArrested()));
		}
		else
		{
			return OrOr_BoolBool(DebugLocationFrozen, thePlayer.IsTased());
		}
	}
	else
	{
		return false;
	}
	return;
}

simulated function bool IsRotationFrozen()
{
	local SwatPlayer thePlayer;

	thePlayer = SwatPlayer(Pawn);
	if(NotEqual_ObjectObject(Pawn, none))
	{
		return OrOr_BoolBool(DebugLocationFrozen, AndAnd_BoolBool(thePlayer.IsTased(), Not_PreBool(thePlayer.IsArrested())));
	}
	else
	{
		return false;
	}
	return;
}

function OnPawnIncapacitated(Pawn Pawn, Actor Incapacitator, bool WasAThreat)
{
	if(AndAnd_BoolBool(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)), Pawn.IsA('SwatOfficer')))
	{
		OnOfficerIncapacitated();
	}
	return;
}

function OnPawnDamaged(Pawn Pawn, Actor Damager)
{
	Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self), "::OnPawnDamaged( "), string(Pawn)), " )... Pawn.Health = "), string(Pawn.Health)));
	if(AndAnd_BoolBool(Level.IsCOOPServer, Pawn.IsA('SwatPlayer')))
	{
		OnPlayerDamaged(Pawn);
	}
	return;
}

function OnPlayerDamaged(Pawn Pawn)
{
	local SwatPlayerReplicationInfo SPRI;

	if(NotEqual_ObjectObject(Pawn.Controller, none))
	{
		SPRI = SwatPlayerReplicationInfo(SwatGamePlayerController(Pawn.Controller).PlayerReplicationInfo);
		if(AndAnd_BoolBool(NotEqual_ObjectObject(SPRI, none), NotEqual_IntInt(int(SPRI.COOPPlayerStatus), int(4))))
		{
			SPRI.COOPPlayerStatus = 3;
		}
	}
	return;
}

simulated function ClientBroadcastStopAllSounds(SwatPawn SourceActor, string UniqueIdentifier)
{
	if(EqualEqual_ObjectObject(SourceActor, none))
	{
		SourceActor = SwatPawn(FindByUniqueID(none, UniqueIdentifier));
		if(EqualEqual_ObjectObject(SourceActor, none))
		{
			if(Level.GetEngine().EnableDevTools)
			{
				MPLog("Warning!  ClientBroadcastStopAllEffectEvents called with a non-relevant source actor!");
			}
			return;
		}
	}
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr("Client: ", string(self)), ", stopping all effect events on source actor: "), string(SourceActor)));
	}
	SourceActor.StopAllSounds();
	return;
}

exec function GCIButtons(int Mode)
{
	Repo.GuiConfig.GCIButtonMode = Mode;
	return;
}

exec function GCICancelPad(bool Show)
{
	Repo.GuiConfig.bUseExitMenu = Show;
	return;
}

exec function TestClientMessage(name Type, string msg)
{
	ClientMessage(msg, Type);
	return;
}

exec function AuditFocus()
{
	bAuditFocus = true;
	return;
}

exec function EditAtFocus()
{
	local name it;

	it = FocusInterfaces[int(3)].GetDefaultFocusActor().Name;
	Log(Concat_StrStr("EditAtFocus: name=", string(it)));
	ConsoleCommand(Concat_StrStr("editactor name=", string(it)));
	return;
}

function PostGameStarted()
{
	if(NotEqual_ObjectObject(SwatGameInfo(Level.Game), none))
	{
		SwatGameInfo(Level.Game).PostGameStarted();
	}
	return;
}

function OnServerSettingsUpdated()
{
	SwatGameInfo(Level.Game).OnServerSettingsUpdated(self);
	return;
}

exec function LogScoring()
{
	local SwatGameReplicationInfo SGRI;

	SGRI = SwatGameReplicationInfo(GameReplicationInfo);
	if(NotEqual_ObjectObject(SGRI, none))
	{
		SGRI.LogScoring(Repo);
	}
	return;
}

function ClientStartConversation(name ConversationName)
{
	Repo.GetConversationManager().ClientStartConversation(ConversationName);
	return;
}

function ClientSetTrainingText(name TrainingText)
{
	Repo.GetTrainingTextManager().ClientSetTrainingText(TrainingText);
	return;
}

function ClientSetObjectiveVisibility(string ObjectiveName, bool Visible)
{
	Repo.SetObjectiveVisibility(string(ObjectiveName), Visible);
	return;
}

simulated function ClientReportableReportedToTOC(IAmReportableCharacter ReportableCharacter, string inUniqueID, string PlayerTag, string PlayerName)
{
	local SwatPlayer Player;

	if(NotEqual_ObjectObject(Pawn, none))
	{
		Player = SwatPlayer(Pawn);
	}
	if(AndAnd_BoolBool(EqualEqual_ObjectObject(Player, none), NotEqual_ObjectObject(ViewTarget, none)))
	{
		Player = SwatPlayer(ViewTarget);
	}
	if(NotEqual_ObjectObject(Player, none))
	{
		Player.OnClientReportableReportedToTOC(ReportableCharacter, inUniqueID, PlayerTag, PlayerName);
	}
	return;
}

exec function ShowInGamePopup()
{
	SwatGUIControllerBase(Repo.GUIController).ShowGamePopup(false);
	return;
}

exec function GUICloseMenu()
{
	SwatGUIControllerBase(Repo.GUIController).ShowGamePopup(true);
	return;
}

exec function OpenHudChat(bool bGlobal)
{
	SwatGUIControllerBase(Repo.GUIController).OpenChat(bGlobal);
	return;
}

exec function ScrollChatPageUp()
{
	SwatGUIControllerBase(Repo.GUIController).ScrollChatPageUp();
	return;
}

exec function ScrollChatPageDown()
{
	SwatGUIControllerBase(Repo.GUIController).ScrollChatPageDown();
	return;
}

exec function ScrollChatUp()
{
	SwatGUIControllerBase(Repo.GUIController).ScrollChatUp();
	return;
}

exec function ScrollChatDown()
{
	SwatGUIControllerBase(Repo.GUIController).ScrollChatDown();
	return;
}

exec function ScrollChatToHome()
{
	SwatGUIControllerBase(Repo.GUIController).ScrollChatToHome();
	return;
}

exec function ScrollChatToEnd()
{
	SwatGUIControllerBase(Repo.GUIController).ScrollChatToEnd();
	return;
}

simulated function ClientAddPrecacheableMaterial(string materialName)
{
	local Material Precacheable;

	Precacheable = Material(DynamicLoadObject(materialName, Class'Engine.Material'));
	if(NotEqual_ObjectObject(Precacheable, none))
	{
		Level.AddPrecacheMaterial(Precacheable);
	}
	return;
}

simulated function ClientAddPrecacheableMesh(string MeshName)
{
	local Mesh Precacheable;

	Precacheable = Mesh(DynamicLoadObject(MeshName, Class'Engine.Mesh'));
	if(NotEqual_ObjectObject(Precacheable, none))
	{
		Level.AddPrecacheMesh(Precacheable);
	}
	return;
}

simulated function ClientAddPrecacheableStaticMesh(string StaticMeshName)
{
	local StaticMesh Precacheable;

	Precacheable = StaticMesh(DynamicLoadObject(StaticMeshName, Class'Engine.StaticMesh'));
	if(NotEqual_ObjectObject(Precacheable, none))
	{
		Level.AddPrecacheStaticMesh(Precacheable);
	}
	return;
}

simulated function ClientPrecacheAll(bool LoadFemaleAnimSets)
{
	local array<string> AnimSetNames;

	Class'SwatGame.SwatPawn'.static.StaticGetAnimPackageGroups(AnimSetNames, LoadFemaleAnimSets);
	LoadAnimationSets(AnimSetNames, true);
	return;
}

// Export USwatGamePlayerController::execFlagForPrecache(FFrame&, void* const)
native simulated function FlagForPrecache();

// Export USwatGamePlayerController::execIsNetRelevant(FFrame&, void* const)
native simulated function bool IsNetRelevant(Pawn PawnInQuestion);

simulated event RenderOverlays(Canvas Canvas)
{
	local HandheldEquipment ActiveItem;

	if(AndAnd_BoolBool(Greater_FloatFloat(ZoomAlpha, float(0)), NotEqual_ObjectObject(ZoomBlurFader, none)))
	{
		ActiveItem = Pawn.GetActiveItem();
		if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(ActiveItem, none), NotEqual_FloatFloat(ActiveItem.ZoomedFOV, BaseFOV)), NotEqual_FloatFloat(ActiveItem.ZoomedFOV, float(0))), NotEqual_ObjectObject(ActiveItem.ZoomBlurOverlay, none)))
		{
			ColorModifier(ZoomBlurFader).Material = ActiveItem.ZoomBlurOverlay;
			ColorModifier(ZoomBlurFader).Color.A = byte(Multiply_FloatFloat(ZoomAlpha, float(255)));
			Canvas.SetPos(0.0000000, 0.0000000);
			Canvas.DrawTile(ZoomBlurFader, Canvas.ClipX, Canvas.ClipY, 0.0000000, 0.0000000, 512.0000000, 512.0000000);
		}
	}
	return;
}

state ControllingViewport
{
	exec function ToggleFlashLight()
	{
		return;
	}

	event WindowFocusRegained()
	{
		ViewportManager.InstantMinimize();
		GotoState('PlayerWalking');
		bControlViewport = 0;
		return;
	}

	exec function HideViewport()
	{
		global.HideViewport();
		GotoState('PlayerWalking');
		return;
	}

	exec function GiveCommand(int CommandIndex)
	{
		if(ActiveViewport.CanIssueCommands())
		{
			global.GiveCommand(CommandIndex);
		}
		return;
	}

	exec function GiveDefaultCommand()
	{
		if(AndAnd_BoolBool(ActiveViewport.CanIssueCommands(), GetCommandInterface().Enabled))
		{
			GetCommandInterface().GiveDefaultCommand();
		}
		return;
	}

	exec function OpenGraphicCommandInterface()
	{
		if(ActiveViewport.CanIssueCommands())
		{
			global.OpenGraphicCommandInterface();
		}
		return;
	}

	exec function Reload()
	{
		ActiveViewport.HandleReload();
		return;
	}

	exec function ToggleZoom()
	{
		ActiveViewport.HandleAltFire();
		return;
	}

	exec function Fire()
	{
		ActiveViewport.HandleFire();
		return;
	}

	exec function ViewportRightMouse()
	{
		ActiveViewport.HandleAltFire();
		return;
	}

	simulated function BeginState()
	{
		Pawn.SetPhysics(0);
		ActiveViewport.OnBeginControlling();
		return;
	}

	simulated function EndState()
	{
		Pawn.SetPhysics(1);
		ActiveViewport.OnEndControlling();
		global.ActivateViewport(none);
		bControlViewport = 0;
		SetPlayerCommandInterfaceTeam(TeamSelectedBeforeControllingOfficerViewport);
		return;
	}

	simulated function PlayerTick(float DeltaTime)
	{
		super(PlayerController).PlayerTick(DeltaTime);
		ActiveViewport.SetInput(int(aTurn), int(aLookUp));
		if(Not_PreBool(ActiveViewport.ShouldControlViewport()))
		{
			GotoState('PlayerWalking');
		}
		ViewShake(DeltaTime);
		ViewFlash(DeltaTime);
		return;
	}
	stop;
}

state ControllingSniperViewport extends ControllingViewport
{	stop;
}

simulated state ControllingOptiwandViewport
{
	simulated function BeginState()
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog("ControllingOptiwandViewport::BeginState()");
		}
		bHaveAlreadyInterruptedOptiwand = false;
		Pawn.SetPhysics(0);
		ActiveViewport.OnBeginControlling();
		SwatPlayer.CachedPlayerControllerForOptiwand = self;
		SwatPlayer.SetIsUsingOptiwand(true);
		return;
	}

	simulated function EndState()
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog("ControllingOptiwandViewport::EndState()");
		}
		CleanupOptiwandingState();
		return;
	}

	simulated function InterruptState(name PendingState)
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog(Concat_StrStr(string(self), "---SGPC::InterruptState() in state 'ControllingOptiwandViewport'."));
		}
		if(Not_PreBool(bHaveAlreadyInterruptedOptiwand))
		{
			CleanupOptiwandingState();
			GotoState('PlayerWalking');
		}
		return;
	}

	simulated function CleanupOptiwandingState()
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog("ControllingOptiwandViewport::CleanupOptiwandingState()");
		}
		if(Not_PreBool(bHaveAlreadyInterruptedOptiwand))
		{
			bHaveAlreadyInterruptedOptiwand = true;
			SwatPlayer.SetForceCrouchWhileOptiwanding(false);
			SwatPlayer.SetIsUsingOptiwand(false);
			Pawn.SetPhysics(1);
			ActiveViewport.OnEndControlling();
			ServerRequestViewportChange(false);
			Pawn.GetActiveItem().InterruptUsing();
		}
		return;
	}

	simulated function PlayerTick(float DeltaTime)
	{
		super(PlayerController).PlayerTick(DeltaTime);
		ActiveViewport.SetInput(int(aTurn), int(aLookUp));
		return;
	}

	exec function GiveCommand(int CommandIndex)
	{
		if(ActiveViewport.CanIssueCommands())
		{
			global.GiveCommand(CommandIndex);
		}
		return;
	}

	exec function GiveDefaultCommand()
	{
		if(AndAnd_BoolBool(ActiveViewport.CanIssueCommands(), GetCommandInterface().Enabled))
		{
			GetCommandInterface().GiveDefaultCommand();
		}
		return;
	}

	exec function OpenGraphicCommandInterface()
	{
		if(ActiveViewport.CanIssueCommands())
		{
			global.OpenGraphicCommandInterface();
		}
		return;
	}

	exec function OpenHudChat(bool bGlobal)
	{
		if(SwatGUIControllerBase(Repo.GUIController).CanChat())
		{
			GotoState('PlayerWalking');
			global.OpenHudChat(bGlobal);
		}
		return;
	}
Begin:

	assert(Pawn.GetActiveItem().IsA('optiwand'));
	if(DoorInWay())
	{
		SwatPlayer.SetForceCrouchWhileOptiwanding(true);
	}
	Pawn.GetActiveItem().LatentUse();
	SwatPlayer.SetForceCrouchWhileOptiwanding(false);
	GotoState('PlayerWalking');
	stop;
}

state QualifyingForUse
{
	simulated function BeginState()
	{
		local EquipmentUsedOnOther theEquipmentUsedOnOther;
		local SwatDoor TargetDoor;

		SwatPlayer.AnimSnapBaseToAim();
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog(Concat_StrStr(string(self), " entering state 'QualifyingForUse'."));
		}
		Pawn.SetPhysics(0);
		HaveCalledInterruptYet = false;
		if(EqualEqual_ObjectObject(self, Level.GetLocalPlayerController()))
		{
			GetHUDPage().Reticle.CenterPreviewImage = none;
		}
		if(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
		{
			theEquipmentUsedOnOther = EquipmentUsedOnOther(Pawn.GetActiveItem());
			if(NotEqual_ObjectObject(theEquipmentUsedOnOther, none))
			{
				theEquipmentUsedOnOther.BeginQualifying(OtherForQualifyingUse);
			}
		}
		if(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)))
		{
			TargetDoor = SwatDoor(OtherForQualifyingUse);
			if(NotEqual_ObjectObject(TargetDoor, none))
			{
				TargetDoor.RegisterInterestedInDoorOpening(self);
			}
		}
		return;
	}

	function NotifyDoorOpening(Door TargetDoor)
	{
		assert(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)));
		InterruptState('None');
		return;
	}

	simulated function EndState()
	{
		local SwatDoor TargetDoor;

		if(Level.GetEngine().EnableDevTools)
		{
			MPLog(Concat_StrStr(string(self), " leaving state 'QualifyingForUse'."));
		}
		Pawn.SetPhysics(1);
		if(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)))
		{
			TargetDoor = SwatDoor(OtherForQualifyingUse);
			if(NotEqual_ObjectObject(TargetDoor, none))
			{
				TargetDoor.UnRegisterInterestedInDoorOpening(self);
			}
		}
		return;
	}

	simulated function PlayerTick(float dTime)
	{
		global.PlayerTick(dTime);
		if(EqualEqual_ObjectObject(self, Level.GetLocalPlayerController()))
		{
			if(AndAnd_BoolBool(Not_PreBool(HaveCalledInterruptYet), EqualEqual_IntInt(int(bFire), 0)))
			{
				PlayerRequestOrInitiateInterrupt();
			}
		}
		return;
	}

	simulated function PlayerRequestOrInitiateInterrupt()
	{
		AssertWithDescription(Pawn.GetActiveItem().IsA('QualifiedUseEquipment'), Concat_StrStr(Concat_StrStr("[tcohen] While QualifyingForUse, SwatGamePlayerController found that the Fire button was released.  But the ActiveItem (", string(Pawn.GetActiveItem())), ") is no longer a QualifiedUseEquipment."));
		HaveCalledInterruptYet = true;
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog(Concat_StrStr(Concat_StrStr(string(self), "......Calling Interrupt() on Item: "), string(QualifiedUseEquipment(Pawn.GetActiveItem()))));
		}
		QualifiedUseEquipment(Pawn.GetActiveItem()).Interrupt();
		return;
	}

	function ServerRequestQualifyInterrupt()
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog(Concat_StrStr(string(self), "---SGPC::ServerRequestQualifyInterrupt() in state 'QualifyingForUse'."));
		}
		assert(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)));
		AuthorizedInterruptQualification();
		return;
	}

	simulated function InterruptState(name PendingState)
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog(Concat_StrStr(string(self), "---SGPC::InterruptState() in state 'QualifyingForUse'."));
		}
		AuthorizedInterruptQualification();
		return;
	}

	simulated function AuthorizedInterruptQualification()
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog(Concat_StrStr(string(self), "---SGPC::AuthorizedInterruptQualification() in state 'QualifyingForUse'."));
			MPLog(Concat_StrStr("...HaveCalledInterruptYet=", string(HaveCalledInterruptYet)));
		}
		AssertWithDescription(Pawn.GetActiveItem().IsA('QualifiedUseEquipment'), Concat_StrStr(Concat_StrStr("[tcohen] While QualifyingForUse, SwatGamePlayerController found that the Fire button was released.  But the ActiveItem (", string(Pawn.GetActiveItem())), ") is no longer a QualifiedUseEquipment."));
		HaveCalledInterruptYet = true;
		QualifiedUseEquipment(Pawn.GetActiveItem()).DoInterrupt();
		return;
	}

	simulated function OnQualifyInterrupted()
	{
		Done(false);
		return;
	}

	simulated function OnQualifyCompleted()
	{
		Done(true);
		return;
	}

	simulated function Done(bool Completed)
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog(Concat_StrStr(Concat_StrStr(string(self), "---SGPC::Done() in state 'QualifyingForUse'. Completed="), string(Completed)));
		}
		if(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)))
		{
			if(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
			{
				SwatPlayer(Pawn).NotifyClientsOfFinishQualify(OtherForQualifyingUse, Completed);
			}
			GotoState('PlayerWalking');
			ClientGotoState('PlayerWalking', 'Begin');
		}
		return;
	}
Begin:

	AssertWithDescription(Pawn.GetActiveItem().IsA('QualifiedUseEquipment'), Concat_StrStr(Concat_StrStr("[tcohen] SwatGamePlayerController began QualifyingForUse.  But the ActiveItem (", string(Pawn.GetActiveItem())), ") is not a QualifiedUseEquipment."));
	stop;
}

auto state NetPlayerLimbo
{
	exec function Fire()
	{
		return;
	}

	exec function AltFire()
	{
		return;
	}

	exec function Use()
	{
		return;
	}
	stop;
}

state Dead
{
	function BeginState()
	{
		super.BeginState();
		if(EqualEqual_ObjectObject(self, Level.GetLocalPlayerController()))
		{
			HideViewport();
		}
		PrepareDeathCam();
		if(bShouldStartDeathCam)
		{
			StartDeathCam();
			bShouldStartDeathCam = false;
		}
		if(AndAnd_BoolBool(EqualEqual_ObjectObject(self, Level.GetLocalPlayerController()), HasHUDPage()))
		{
			GetHUDPage().OnPlayerDied();
		}
		if(NotEqual_ObjectObject(ForceObserverTimer, none))
		{
			ForceObserverTimer.StartTimer(ForceObserverTime);
		}
		return;
	}

	function EndState()
	{
		bIsDeathCamRunning = false;
		return;
	}

	function PrepareDeathCam()
	{
		DeathCamStartRotation.Yaw = Add_IntInt(ViewTarget.Rotation.Yaw, 32768);
		DeathCamStartRotation.Pitch = 0;
		DeathCamStartDistance = Multiply_FloatFloat(ViewTarget.default.CollisionRadius, 3.0000000);
		DeathCamEndDistance = Multiply_FloatFloat(ViewTarget.default.CollisionRadius, 12.0000000);
		bBlockCloseCamera = false;
		return;
	}

	function StartDeathCam()
	{
		local bool bEndRotationWasFound;
		local Vector KillerDirection;
		local Rotator KillerDirectionRotator;

		if(Not_PreBool(bIsDeathCamRunning))
		{
			if(bIsKillerLocationValid)
			{
				KillerDirection = Subtract_VectorVector(KillerLocation, ViewTarget.Location);
				if(OrOr_BoolBool(NotEqual_FloatFloat(KillerDirection.X, 0.0000000), NotEqual_FloatFloat(KillerDirection.Y, 0.0000000)))
				{
					KillerDirectionRotator = Rotator(KillerDirection);
					DeathCamEndRotation.Yaw = KillerDirectionRotator.Yaw;
					DeathCamEndRotation.Pitch = KillerDirectionRotator.Pitch;
					if(Less_IntInt(WrapAngleNegPiToPi(DeathCamEndRotation.Pitch), Divide_IntInt(65536, 8)))
					{
						AddEqual_IntInt(DeathCamEndRotation.Pitch, -4563);
					}
					bEndRotationWasFound = true;
				}
				bIsKillerLocationValid = false;
			}
			if(Not_PreBool(bEndRotationWasFound))
			{
				DeathCamEndRotation.Yaw = ViewTarget.Rotation.Yaw;
				DeathCamEndRotation.Pitch = -4563;
			}
			bIsDeathCamRunning = true;
			DeathCamStartTimeSeconds = Level.TimeSeconds;
		}
		return;
	}

	exec function Fire()
	{
		if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
		{
			super.Fire();
		}
		else
		{
			if(EqualEqual_FloatFloat(GetDeathCamZoomAlpha(), 1.0000000))
			{
				if(Level.GetEngine().EnableDevTools)
				{
					MPLog(Concat_StrStr(string(self), "--Dead::Fire() ... calling ForceObserverCam"));
				}
				ForceObserverCam();
			}
		}
		return;
	}

	simulated function ForceObserverTimerCallback()
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog(Concat_StrStr(string(self), "--Dead::ForceObserverTimerCallback() ... calling ForceObserverCam"));
		}
		ForceObserverCam();
		return;
	}

	function CalcBehindView(out Vector CameraLocation, out Rotator CameraRotation, float dist)
	{
		local float DeathCamZoomAlpha;

		AddEqual_FloatFloat(CameraLocation.Z, 12.0000000);
		DeathCamZoomAlpha = GetDeathCamZoomAlpha();
		dist = Lerp(DeathCamZoomAlpha, DeathCamStartDistance, DeathCamEndDistance);
		if(Less_FloatFloat(DeathCamZoomAlpha, 1.0000000))
		{
			SetRotation(RotatorLerp(DeathCamStartRotation, DeathCamEndRotation, DeathCamZoomAlpha));
		}
		super(PlayerController).CalcBehindView(CameraLocation, CameraRotation, dist);
		return;
	}

	private function float GetDeathCamZoomAlpha()
	{
		local float LinearAlpha, CubicAlpha;

		if(bIsDeathCamRunning)
		{
			LinearAlpha = Divide_FloatFloat(Subtract_FloatFloat(Level.TimeSeconds, DeathCamStartTimeSeconds), 2.0000000);
			LinearAlpha = FClamp(LinearAlpha, 0.0000000, 1.0000000);
			CubicAlpha = Add_FloatFloat(Multiply_FloatFloat(Multiply_FloatFloat(Multiply_FloatFloat(-2.0000000, LinearAlpha), LinearAlpha), LinearAlpha), Multiply_FloatFloat(Multiply_FloatFloat(3.0000000, LinearAlpha), LinearAlpha));
			return CubicAlpha;
		}
		else
		{
			return 0.0000000;
		}
		return;
	}

	exec function TeamSay(string msg)
	{
		SwatGameInfo(Level.Game).BroadcastObservers(self, msg, 'TeamSay');
		return;
	}
	stop;
}

state ObserveFromTeamOrLocation
{
	simulated function BeginState()
	{
		bIsObserving = true;
		return;
	}

	simulated function EndState()
	{
		bIsObserving = false;
		return;
	}

	simulated function bool IsDead()
	{
		return true;
		return;
	}

	exec function TeamSay(string msg)
	{
		SwatGameInfo(Level.Game).BroadcastObservers(self, msg, 'TeamSay');
		return;
	}
	stop;
}

state ObserveTeam extends ObserveFromTeamOrLocation
{
	simulated function BeginState()
	{
		super.BeginState();
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog(Concat_StrStr(string(self), "--entering state ObserveTeam."));
		}
		if(EqualEqual_ObjectObject(self, Level.GetLocalPlayerController()))
		{
			ServerViewNextPlayer();
		}
		return;
	}

	simulated function EndState()
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog(Concat_StrStr(string(self), "--leaving state ObserveTeam., setting ReplicatedObserverCamTarget to None"));
		}
		ReplicatedObserverCamTarget = none;
		super.EndState();
		return;
	}

	simulated event PlayerCalcView(out Actor ViewActor, out Vector CameraLocation, out Rotator CameraRotation)
	{
		local Pawn ViewTargetPawn;
		local Coords HeadCoords;

		if(NotEqual_ObjectObject(ViewTarget, none))
		{
			ViewActor = ViewTarget;
			ViewTargetPawn = Pawn(ViewTarget);
			if(OrOr_BoolBool(OrOr_BoolBool(EqualEqual_IntInt(int(Level.NetMode), int(NM_DedicatedServer)), EqualEqual_ObjectObject(ViewTargetPawn, none)), ViewTargetPawn.IsConscious()))
			{
				CameraLocation = TargetViewLocation;
				CameraRotation = TargetViewRotation;
			}
			else
			{
				HeadCoords = ViewTargetPawn.GetBoneCoords('Bone01Eye', true);
				CameraLocation = HeadCoords.Origin;
				CameraRotation = Rotator(HeadCoords.XAxis);
			}
		}
		else
		{
			global.PlayerCalcView(ViewActor, CameraLocation, CameraRotation);
		}
		return;
	}

	exec function Fire()
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog(Concat_StrStr(string(self), "--ObserveTeam::Fire, calling ServerViewNextPlayer."));
		}
		ServerViewNextPlayer();
		return;
	}
	stop;
}

state ObserveLocation extends ObserveFromTeamOrLocation
{
	simulated event PlayerCalcView(out Actor ViewActor, out Vector CameraLocation, out Rotator CameraRotation)
	{
		if(NotEqual_ObjectObject(ViewTarget, none))
		{
			ViewActor = ViewTarget;
			CameraLocation = ViewTarget.Location;
			CameraRotation = ViewTarget.Rotation;
		}
		else
		{
			global.PlayerCalcView(ViewActor, CameraLocation, CameraRotation);
		}
		return;
	}

	exec function Fire()
	{
		return;
	}
	stop;
}

state GameEnded
{
	simulated function BeginState()
	{
		bBehindView = true;
		super.BeginState();
		return;
	}

	exec function Fire()
	{
		return;
	}

	simulated event PlayerCalcView(out Actor ViewActor, out Vector CameraLocation, out Rotator CameraRotation)
	{
		local Rotator FinalTargetRotation;
		local float ViewDist;

		if(NotEqual_ObjectObject(ViewTarget, none))
		{
			AddEqual_FloatFloat(EndGameCamYaw, GetEndGameCamYawDelta());
			FinalTargetRotation.Pitch = -4563;
			FinalTargetRotation.Yaw = int(EndGameCamYaw);
			ViewActor = ViewTarget;
			ViewDist = Multiply_FloatFloat(ViewTarget.default.CollisionRadius, 10.0000000);
			if(NotEqual_ObjectObject(Pawn(ViewTarget), none))
			{
				CameraRotation = Add_RotatorRotator(TargetViewRotation, FinalTargetRotation);
				CameraLocation = TargetViewLocation;
				AddEqual_FloatFloat(CameraLocation.Z, 12.0000000);
			}
			else
			{
				CameraRotation = Add_RotatorRotator(ViewTarget.Rotation, FinalTargetRotation);
				CameraLocation = ViewTarget.Location;
			}
			CalcBehindView(CameraLocation, CameraRotation, ViewDist);
		}
		else
		{
			global.PlayerCalcView(ViewActor, CameraLocation, CameraRotation);
		}
		return;
	}

	simulated function CalcBehindView(out Vector CameraLocation, out Rotator CameraRotation, float dist)
	{
		local Vector View, HitLocation, HitNormal;
		local float ViewDist;

		View = GreaterGreater_VectorRotator(vect(1.0000000, 0.0000000, 0.0000000), CameraRotation);
		if(NotEqual_ObjectObject(Trace(HitLocation, HitNormal, Subtract_VectorVector(CameraLocation, Multiply_FloatVector(dist, Vector(CameraRotation))), CameraLocation, false, vect(10.0000000, 10.0000000, 10.0000000)), none))
		{
			ViewDist = FMin(Dot_VectorVector(Subtract_VectorVector(CameraLocation, HitLocation), View), dist);
		}
		else
		{
			ViewDist = dist;
		}
		CameraLocation = Subtract_VectorVector(CameraLocation, Multiply_FloatVector(ViewDist, View));
		EndGameCamLastDist = ViewDist;
		return;
	}

	simulated function float GetEndGameCamYawDelta()
	{
		local float LastDistScale, LastDistScaleAlpha, YawDeltaPerSecond, YawDelta;

		LastDistScale = Divide_FloatFloat(EndGameCamLastDist, ViewTarget.default.CollisionRadius);
		LastDistScaleAlpha = Divide_FloatFloat(Subtract_FloatFloat(7.5000000, LastDistScale), Subtract_FloatFloat(7.5000000, 0.0000000));
		LastDistScaleAlpha = FClamp(LastDistScaleAlpha, 0.0000000, 1.0000000);
		YawDeltaPerSecond = Lerp(LastDistScaleAlpha, 3000.0000000, 20000.0000000);
		YawDelta = Multiply_FloatFloat(YawDeltaPerSecond, Subtract_FloatFloat(Level.TimeSeconds, EndGameCamYawLastUpdateTime));
		EndGameCamYawLastUpdateTime = Level.TimeSeconds;
		return YawDelta;
		return;
	}
	stop;
}

state BeingCuffed
{
	simulated function bool IsCuffed()
	{
		return bPlayerIsCuffed;
		return;
	}

	simulated function OnArrested()
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog(Concat_StrStr(string(self), "---SGPC::OnArrested() in state 'BeingCuffed'."));
		}
		bPlayerIsCuffed = true;
		return;
	}

	simulated function PostArrested()
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog(Concat_StrStr(string(self), "---SGPC::PostArrested() in state 'BeingCuffed'."));
		}
		if(SwatPlayer.IsTheVIP())
		{
			SwatPlayer.SetForceCrouchState(true);
			GotoState('PlayerWalking');
			ClientGotoState('PlayerWalking', 'Begin');
		}
		else
		{
			Pawn.UnPossessed();
			Pawn = none;
			if(NotEqual_ObjectObject(ForceObserverTimer, none))
			{
				ForceObserverTimer.StartTimer(ForceObserverTime);
			}
		}
		return;
	}

	exec function Fire()
	{
		if(AndAnd_BoolBool(bPlayerIsCuffed, Not_PreBool(SwatPlayer.IsTheVIP())))
		{
			if(Level.GetEngine().EnableDevTools)
			{
				MPLog(Concat_StrStr(string(self), "::Fire()  in state BeingCuffed... about to ForceObserverCam();"));
			}
			ForceObserverCam();
		}
		return;
	}

	simulated function ForceObserverTimerCallback()
	{
		ForceObserverCam();
		return;
	}

	function BeginState()
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog(Concat_StrStr(string(self), " entering state 'BeingCuffed'."));
		}
		bPlayerIsCuffed = false;
		SetZoom(false, true);
		bBehindView = true;
		bFrozen = true;
		bJumpStatus = false;
		bPressedJump = false;
		bBlockCloseCamera = true;
		bValidBehindCamera = false;
		FindGoodView();
		StopForceFeedback();
		CleanOutSavedMoves();
		Pawn.SetPhysics(0);
		Pawn.UnLean();
		if(EqualEqual_ObjectObject(self, Level.GetLocalPlayerController()))
		{
			GetHUDPage().Overlay.Hide();
		}
		return;
	}

	function EndState()
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog(Concat_StrStr(string(self), " leaving state 'BeingCuffed'."));
		}
		bBlockCloseCamera = false;
		CleanOutSavedMoves();
		Velocity = vect(0.0000000, 0.0000000, 0.0000000);
		Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
		if(Not_PreBool(PlayerReplicationInfo.bOutOfLives))
		{
			bBehindView = false;
		}
		bPressedJump = false;
		Pawn.SetPhysics(1);
		if(EqualEqual_ObjectObject(self, Level.GetLocalPlayerController()))
		{
			GetHUDPage().Overlay.Show();
		}
		if(Not_PreBool(SwatPlayer.IsTheVIP()))
		{
			if(bPlayerIsCuffed)
			{
				GetRidOfPawn();
			}
			bPlayerIsCuffed = false;
		}
		else
		{
			bBehindView = false;
			bFrozen = false;
			bJumpStatus = false;
			bPressedJump = false;
			bBlockCloseCamera = false;
			bValidBehindCamera = true;
			CleanOutSavedMoves();
		}
		return;
	}

	simulated function GetRidOfPawn()
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog(Concat_StrStr(string(self), "---SGPC::GetRidOfPawn() in state 'BeingCuffed'."));
		}
		if(NotEqual_ObjectObject(SwatPlayer, none))
		{
			SwatPlayer.Destroy();
			SwatPlayer = none;
		}
		return;
	}

	simulated function InterruptState(name PendingState)
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog(Concat_StrStr(Concat_StrStr(string(self), "---SGPC::InterruptState() in state 'BeingCuffed'. PendingState="), string(PendingState)));
		}
		AssertWithDescription(NotEqual_ObjectObject(SwatPlayer(Pawn).LastArrester, none), "[tcohen] SwatGamePlayerController@BeingCuffed::InterruptState() BeingCuffed is interrupted, but we don't know who's Arresting us.");
		if(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)))
		{
			SwatPlayer(Pawn).LastArrester.AuthorizedInterruptQualification();
		}
		return;
	}
	stop;
}

state BeingUncuffed
{
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

	simulated function bool IsCuffed()
	{
		return bPlayerIsCuffed;
		return;
	}

	simulated function OnUnarrested()
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog(Concat_StrStr(string(self), "---SGPC::OnUnarrested() in state 'BeingUncuffed'."));
		}
		bPlayerIsCuffed = false;
		SwatPlayer.SetForceCrouchState(false);
		SwatPlayer.ShouldCrouch(false);
		return;
	}

	function BeginState()
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog(Concat_StrStr(string(self), " entering state 'BeingUncuffed'."));
		}
		assert(SwatPlayer.IsTheVIP());
		SetZoom(false, true);
		bBehindView = true;
		bFrozen = true;
		bJumpStatus = false;
		bPressedJump = false;
		bBlockCloseCamera = true;
		bValidBehindCamera = false;
		FindGoodView();
		StopForceFeedback();
		CleanOutSavedMoves();
		Pawn.SetPhysics(0);
		if(EqualEqual_ObjectObject(self, Level.GetLocalPlayerController()))
		{
			GetHUDPage().Overlay.Hide();
		}
		return;
	}

	function EndState()
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog(Concat_StrStr(string(self), " leaving state 'BeingUncuffed'."));
		}
		bBlockCloseCamera = false;
		CleanOutSavedMoves();
		Velocity = vect(0.0000000, 0.0000000, 0.0000000);
		Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
		if(Not_PreBool(PlayerReplicationInfo.bOutOfLives))
		{
			bBehindView = false;
		}
		bPressedJump = false;
		Pawn.SetPhysics(1);
		if(EqualEqual_ObjectObject(self, Level.GetLocalPlayerController()))
		{
			GetHUDPage().Overlay.Show();
		}
		bBehindView = false;
		bFrozen = false;
		bJumpStatus = false;
		bPressedJump = false;
		bBlockCloseCamera = false;
		bValidBehindCamera = true;
		CleanOutSavedMoves();
		return;
	}
Begin:

	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), " Begin: of state 'BeingUncuffed'."));
	}
	stop;
}

state BattleRooming extends BaseSpectating
{
	function InputOffset(out float aForward, out float aStrafe)
	{
		return;
	}

	simulated function UpdateLooking(float dTime)
	{
		return;
	}

	exec function BattleRoomToggleSimulation()
	{
		Level.bPlayersOnly = Not_PreBool(Level.bPlayersOnly);
		return;
	}

	exec function BattleRoom()
	{
		GotoState('PlayerWalking');
		return;
	}

	exec function BattleSelectedHealth(int Health)
	{
		BattleRoomManager.SetSelectedHealth(Health);
		return;
	}

	simulated function CalcViewForFocus(out Actor ViewActor, out Vector ViewLocation, out Rotator ViewRotation)
	{
		ViewLocation = Location;
		ViewRotation = Rotator(BattleRoomManager.GetMouseLookDir());
		ViewActor = self;
		return;
	}

	function BeginState()
	{
		local Rotator Rot;

		SetCollision(true, true, true);
		SetCollisionSize(32.0000000, 32.0000000);
		BattleRoomZ = Add_FloatFloat(Pawn.Location.Z, float(200));
		SetLocation(Pawn.Location);
		Rot = Rotation;
		Rot.Pitch = int(Multiply_FloatFloat(float(-65), 182.0444000));
		SetRotation(Rot);
		GetHUDPage().bActiveInput = true;
		GetHUDPage().BattleRoom.Activate();
		GetHUDPage().BattleRoom.Show();
		GetHUDPage().bHideMouseCursor = false;
		BattleRoomManager.Open();
		Log("Starting battleroom!");
		bBehindView = true;
		Pawn.bHidden = false;
		bGodMode = true;
		return;
	}

	event PlayerCalcView(out Actor ViewActor, out Vector CameraLocation, out Rotator CameraRotation)
	{
		CameraLocation = Location;
		CameraRotation = Rotation;
		CameraLocation.Z = BattleRoomZ;
		SetLocation(CameraLocation);
		ViewActor = self;
		return;
	}

	exec function BattleSelectAllPawns()
	{
		BattleRoomManager.SelectAllPawns();
		return;
	}

	function UpdateRotation(float DeltaTime, float maxPitch)
	{
		local Rotator NewRotation, ViewRotation;

		ViewRotation = Rotation;
		DesiredRotation = ViewRotation;
		TurnTarget = none;
		bRotateToDesired = false;
		bSetTurnRot = false;
		if(NotEqual_IntInt(int(bBattleRoomRotation), 0))
		{
			AddEqual_IntInt(ViewRotation.Yaw, int(Multiply_FloatFloat(Multiply_FloatFloat(32.0000000, DeltaTime), aTurn)));
			AddEqual_IntInt(ViewRotation.Pitch, int(Multiply_FloatFloat(Multiply_FloatFloat(32.0000000, DeltaTime), aLookUp)));
			if(NotEqual_IntInt(ViewRotation.Pitch, Rotation.Pitch))
			{
				ViewRotation.Pitch = Clamp(ViewRotation.Pitch, int(Multiply_FloatFloat(float(-80), 182.0444000)), int(Multiply_FloatFloat(float(20), 182.0444000)));
			}
			SetRotation(ViewRotation);
		}
		NewRotation = ViewRotation;
		NewRotation.Roll = Rotation.Roll;
		return;
	}

	function PlayerMove(float DeltaTime)
	{
		local Vector X, Y, Z;

		UpdateRotation(DeltaTime, 1.0000000);
		GetAxes(Rotation, X, Y, Z);
		Acceleration = Multiply_FloatVector(Multiply_FloatFloat(float(80), DeltaTime), Add_VectorVector(Add_VectorVector(Multiply_FloatVector(aForward, X), Multiply_FloatVector(aStrafe, Y)), Multiply_FloatVector(aUp, vect(0.0000000, 0.0000000, 1.0000000))));
		if(NotEqual_IntInt(int(bRun), 0))
		{
			BattleRoomZ = float(Clamp(int(Add_FloatFloat(BattleRoomZ, Multiply_FloatFloat(Multiply_FloatFloat(aLookUp, 0.4000000), DeltaTime))), int(Pawn.Location.Z), int(Add_FloatFloat(Pawn.Location.Z, float(1000)))));
		}
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

	exec function BattleRoomSelect()
	{
		Log("Alt fire!!");
		BattleRoomManager.RightClickBattleRoom();
		return;
	}

	function EndState()
	{
		GetHUDPage().BattleRoom.Hide();
		GetHUDPage().DeActivate();
		bBehindView = false;
		Level.bPlayersOnly = false;
		bGodMode = false;
		Log("Ending battleroom!!");
		return;
	}
	stop;
}

defaultproperties
{
	FlashbangRetinaImageTextureWidth=800
	FlashbangRetinaImageTextureHeight=600
	ForceObserverTime=5.0000000
	ComplianceTime=1.5000000
	CommandTime=1.0000000
	DebugShouldRecoil=true
	ZoomBlurFader=ColorModifier'HUD.ZoomBlurFader'
	SniperAlertTime=4.0000000
	BeingCuffedTimeout=10.0000000
	SpectateSpeed=200.0000000
	PlayerReplicationInfoClass=Class'SwatGame.SwatPlayerReplicationInfo'
}