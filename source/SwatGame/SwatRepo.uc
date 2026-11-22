class SwatRepo extends Repo
	transient
	native;

var SwatGUIConfig GuiConfig;
var SwatPlayerController PlayerController;
var private AnimationSetManager AnimationSetManager;
var private int SwatPlayerIDCounter;
var array<SwatRepoPlayerItem> PlayerItems;
var private bool bTravellingToNewRound;
var bool bFirstRound;
var bool NetRoundInProgress;
var private float CumulativeDelta;
var private float LastServerTime;
var private bool bDelayedFinish;
var private float CriticalMomentCountdown;
var private bool bFailedServerTransitionEnabled;
var const float PRECACHING_FUDGE;
var private int RoundsWon[2];
var SwatGameReplicationInfo CachedSGRI;
var bool bInitAsNetPlayer;
var MissionObjectives MissionObjectives;
var Procedures Procedures;
var private ConversationManager ConversationManager;
var private TrainingTextManager TrainingTextManager;
var private bool bShouldPerformQuickRoundReset;

function Initialize()
{
	AnimationSetManager = Class'SwatGame.AnimationSetManager'.static.Allocate(self).;
	Construct_Void();
	assert(NotEqual_ObjectObject(AnimationSetManager, none));
	SwatPlayerIDCounter = 1;
	GuiConfig = Class'SwatGame.SwatGUIConfig'.static.Allocate(self).;
	Construct_Void();
	assert(NotEqual_ObjectObject(GuiConfig, none));
	Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("[dkaplan] >>> SwatRepo::Initialize()... self = ", string(self)), ", GuiConfig = "), string(GuiConfig)));
	StateChange(0);
	RoleChange(3);
	bTravellingToNewRound = false;
	NetRoundInProgress = false;
	bFirstRound = true;
	bDelayedFinish = false;
	return;
}

event PostGameEngineInit()
{
	if(InitAsListenServer)
	{
		StartServer("?listen");
	}
	else
	{
		if(InitAsDedicatedServer)
		{
			StartServer("?dedicated");
		}
	}
	return;
}

function LoadLevel(string MapName)
{
	local string Cmd;

	AssertWithDescription(NotEqual_StrStr(MapName, ""), Concat_StrStr(Concat_StrStr("SwatRepo::LoadLevel(): 'MapName' for mission '", string(GuiConfig.CurrentMission)), "' was not set correctly. Please check SwatMissions.ini"));
	Cmd = At_StrStr("start", MapName);
	Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[dkaplan] >>> SwatRepo::LoadLevel()... MapName = '", MapName), "' ... ConsoleCommand = '"), Cmd), "'"));
	Level.ConsoleCommand(Cmd);
	return;
}

function StartServer(string AdditionalURLOptions)
{
	local string URL;
	local SwatGameSpyManager SGSM;

	SGSM = SwatGameSpyManager(Level.GetGameSpyManager());
	if(ServerSettings(Level.CurrentServerSettings).bLAN)
	{
		SGSM.SetShouldCheckClientCDKeys(false);
	}
	else
	{
		SGSM.SetShouldCheckClientCDKeys(true);
	}
	URL = Concat_StrStr(Concat_StrStr(Concat_StrStr(ServerSettings(Level.CurrentServerSettings).Maps[ServerSettings(Level.CurrentServerSettings).MapIndex], "?Name="), GuiConfig.MPName), AdditionalURLOptions);
	if(ServerSettings(Level.CurrentServerSettings).bPassworded)
	{
		URL = Concat_StrStr(Concat_StrStr(URL, "?GamePassword="), ServerSettings(Level.CurrentServerSettings).Password);
	}
	LoadLevel(URL);
	return;
}

function SetPlayerController(SwatPlayerController theController)
{
	PlayerController = theController;
	return;
}

event Tick(float DeltaSeconds)
{
	if(OrOr_BoolBool(OrOr_BoolBool(OrOr_BoolBool(EqualEqual_IntInt(int(GuiConfig.SwatGameState), int(3)), EqualEqual_IntInt(int(GuiConfig.SwatGameState), int(4))), EqualEqual_IntInt(int(GuiConfig.SwatGameState), int(5))), EqualEqual_IntInt(int(GuiConfig.SwatGameState), int(6))))
	{
		if(EqualEqual_IntInt(int(GuiConfig.SwatGameRole), int(4)))
		{
			if(bShouldPerformQuickRoundReset)
			{
				bShouldPerformQuickRoundReset = false;
				PerformQuickRoundReset();
				return;
			}
			if(AndAnd_BoolBool(EqualEqual_IntInt(int(Level.NetMode), int(NM_DedicatedServer)), Not_PreBool(AnyPlayersOnServer())))
			{
				return;
			}
			SubtractEqual_FloatFloat(GetSGRI().ServerCountdownTime, DeltaSeconds);
			if(Not_PreBool(bDelayedFinish))
			{
				SwatGameInfo(Level.Game).NetRoundTimeRemaining(GetSGRI().ServerCountdownTime);
			}
			switch(GuiConfig.SwatGameState)
			{
				case 3:
				case 5:
					AddEqual_FloatFloat(CumulativeDelta, DeltaSeconds);
					if(LessEqual_FloatFloat(GetSGRI().ServerCountdownTime, float(0)))
					{
						CumulativeDelta = 0.0000000;
						AllPlayersReady();
					}
					else
					{
						if(AndAnd_BoolBool(Greater_FloatFloat(CumulativeDelta, GuiConfig.MPPollingDelay), LessEqual_IntInt(NumberOfPlayersWhoShouldReturn(), NumberOfReturnedPlayers())))
						{
							CumulativeDelta = 0.0000000;
							CheckAllPlayersReady();
						}
					}
					break;
				case 4:
					if(LessEqual_FloatFloat(GetSGRI().ServerCountdownTime, float(0)))
					{
						if(bDelayedFinish)
						{
							bDelayedFinish = false;
							NetRoundDelayedFinish();
						}
						else
						{
							SwatGameInfo(Level.Game).NetRoundTimerExpired();
						}
					}
					break;
				default:
					break;
			}
		}
		else
		{
			if(EqualEqual_IntInt(int(GuiConfig.SwatGameRole), int(5)))
			{
				if(AndAnd_BoolBool(NotEqual_ObjectObject(GetSGRI(), none), NotEqual_FloatFloat(LastServerTime, GetSGRI().ServerCountdownTime)))
				{
					LastServerTime = GetSGRI().ServerCountdownTime;
					CumulativeDelta = 0.0000000;
				}
				else
				{
					AddEqual_FloatFloat(CumulativeDelta, DeltaSeconds);
					if(Greater_FloatFloat(CumulativeDelta, MPTimeOut))
					{
						FailedServerConnection();
					}
				}
			}
		}
		if(Greater_FloatFloat(CriticalMomentCountdown, float(0)))
		{
			SubtractEqual_FloatFloat(CriticalMomentCountdown, DeltaSeconds);
			if(LessEqual_FloatFloat(CriticalMomentCountdown, float(0)))
			{
				OnDelayedCriticalMoment();
			}
		}
	}
	return;
}

function QuickServerRestart(PlayerController PC)
{
	if(AndAnd_BoolBool(Level.Game.IsA('SwatGameInfo'), Not_PreBool(SwatGameInfo(Level.Game).Admin.IsAdmin(PC))))
	{
		return;
	}
	bShouldPerformQuickRoundReset = true;
	return;
}

private function PerformQuickRoundReset()
{
	switch(GuiConfig.SwatGameState)
	{
		case 3:
			NetRoundStart();
		case 4:
			NetRoundDelayedFinish();
		case 5:
			NetNextRound();
			break;
		default:
			break;
	}
	return;
}

event PreLevelChange(Player thePlayer, string MapName)
{
	Log(Concat_StrStr(Concat_StrStr("[dkaplan]: >>> SwatRepo::PreLevelChange( New Level == ", MapName), " )"));
	PreLevelChangeCleanup();
	if(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(PlayerController, none), NotEqual_ObjectObject(Level.Game, none)), NotEqual_ObjectObject(SwatGameInfo(Level.Game), none)))
	{
		SwatGameInfo(Level.Game).MissionEnded();
	}
	if(NotEqual_IntInt(int(GuiConfig.SwatGameState), int(6)))
	{
		if(AndAnd_BoolBool(Less_IntInt(InStr(MapName, "Entry"), 0), Less_IntInt(InStr(MapName, SplashSceneMapName), 0)))
		{
			StateChange(2);
		}
		else
		{
			if(AndAnd_BoolBool(EqualEqual_IntInt(int(GuiConfig.SwatGameRole), int(5)), EqualEqual_IntInt(int(GuiConfig.SwatGameState), int(0))))
			{
				StateChange(6);
			}
			else
			{
				StateChange(1);
			}
		}
	}
	GuiConfig.ClearCurrentMission();
	PlayerController = none;
	CachedSGRI = none;
	MissionObjectives = none;
	Procedures = none;
	ConversationManager = none;
	TrainingTextManager = none;
	return;
}

event PostLevelChange(Player thePlayer, string MapName)
{
	local GameSpyManager GSM;

	GSM = Level.GetGameSpyManager();
	ServerSettings(Level.CurrentServerSettings).bDirty = false;
	Log("[dkaplan]: >>> SwatRepo::PostLevelChange()");
	if(EqualEqual_IntInt(int(GuiConfig.SwatGameState), int(1)))
	{
		assert(OrOr_BoolBool(GreaterEqual_IntInt(InStr(MapName, "Entry"), 0), GreaterEqual_IntInt(InStr(MapName, SplashSceneMapName), 0)));
		StateChange(0);
	}
	else
	{
		if(EqualEqual_IntInt(int(Level.NetMode), int(NM_DedicatedServer)))
		{
			StateChange(NM_Client);
		}
	}
	if(NotEqual_ObjectObject(thePlayer, none))
	{
		PlayerController = SwatPlayerController(thePlayer.Actor);
	}
	if(EqualEqual_IntInt(int(GuiConfig.SwatGameRole), int(4)))
	{
		UpdateGameSpyStats();
		if(EqualEqual_IntInt(int(GuiConfig.SwatGameState), int(0)))
		{
			GSM.CleanUpGameSpy();
		}
		MPLog("Setting bTravellingToNewRound to false.");
		bTravellingToNewRound = false;
	}
	return;
}

event PostBeginPlay()
{
	if(OrOr_BoolBool(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)), Level.IsPlayingCOOP))
	{
		if(NotEqual_NameName(GuiConfig.GetCurrentMissionName(), Level.Label))
		{
			GuiConfig.SetCurrentMission(Level.Label, Level.Title);
		}
		else
		{
			GuiConfig.ResetCurrentMission();
		}
		AssertWithDescription(NotEqual_ObjectObject(GuiConfig.CurrentMission, none), Concat_StrStr("No Mission was created for level ", string(Level.Label)));
		MissionObjectives = GuiConfig.CurrentMission.Objectives;
		Log(Concat_StrStr("[MISSION] Mission Objectives created for Mission ", string(GuiConfig.CurrentMission)));
		AssertWithDescription(NotEqual_ObjectObject(MissionObjectives, none), Concat_StrStr("No Mission Objectives specified for mission ", GuiConfig.CurrentMission.FriendlyName));
		Procedures = Class'SwatGame.Procedures'.static.Allocate(self).;
		Construct_Void();
	}
	return;
}

event PostPlayerLogin(SwatPlayerController thePC)
{
	Log(Concat_StrStr("[dkaplan]: >>> SwatRepo::PostPlayerLogin(), the PlayerController = ", string(thePC)));
	PlayerController = thePC;
	if(OrOr_BoolBool(EqualEqual_IntInt(int(GuiConfig.SwatGameState), int(2)), EqualEqual_IntInt(int(GuiConfig.SwatGameState), int(6))))
	{
		StateChange(3);
	}
	return;
}

function FlushBogusPlayerItems()
{
	local int i, NumberOfPlayers;

	MPLog("---SwatRepo::FlushBogusPlayerItems().");
	NumberOfPlayers = PlayerItems.Length;
	i = Subtract_IntInt(NumberOfPlayers, 1);
	J0x47:

	if(GreaterEqual_IntInt(i, 0))
	{
		if(AndAnd_BoolBool(NotEqual_ObjectObject(PlayerItems[i], none), Not_PreBool(PlayerItems[i].bConnected)))
		{
			MPLog(Concat_StrStr("...flushed PlayerItem from Repo at index=", string(i)));
			PlayerItems.Remove(i, 1);
		}
		SubtractSubtract_Int(i);
		// [Loop Continue]
		goto J0x47;
	}
	UpdateGameSpyStats();
	return;
}

function Logout(SwatGamePlayerController SGPC)
{
	local int i;

	MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr("SwatRepo::Logout(). bTravellingToNewRound=", string(bTravellingToNewRound)), ", SGPC="), string(SGPC)));
	if(Not_PreBool(bTravellingToNewRound))
	{
		i = 0;
		J0x62:

		if(Less_IntInt(i, PlayerItems.Length))
		{
			if(AndAnd_BoolBool(NotEqual_ObjectObject(PlayerItems[i], none), EqualEqual_ObjectObject(PlayerItems[i], SGPC.SwatRepoPlayerItem)))
			{
				MPLog(Concat_StrStr("...removed PlayerItem from Repo at index=", string(i)));
				PlayerItems.Remove(i, 1);
			}
			AddAdd_PreInt(i);
			// [Loop Continue]
			goto J0x62;
		}
		UpdateGameSpyStats();
	}
	else
	{
		if(NotEqual_ObjectObject(SGPC.SwatRepoPlayerItem, none))
		{
			SGPC.SwatRepoPlayerItem.bConnected = false;
		}
	}
	return;
}

function OnMissionStarted()
{
	Log(Concat_StrStr("[dkaplan] >>> SwatRepo::MissionStarted() ", string(self)));
	StateChange(4);
	if(NotEqual_ObjectObject(Level.Game, none))
	{
		SwatGameInfo(Level.Game).OnMissionStarted();
	}
	return;
}

function OnMissionEnded()
{
	Log(Concat_StrStr("[dkaplan] >>> SwatRepo::MissionEnded() ", string(self)));
	if(NotEqual_IntInt(int(GuiConfig.SwatGameState), int(5)))
	{
		StateChange(5);
	}
	return;
}

function PreClientTravel()
{
	Log(Concat_StrStr("[dkaplan] >>> SwatRepo::PreClientTravel() ", string(self)));
	StateChange(6);
	return;
}

function StateChange(SwatGUIConfig.eSwatGameState NewState)
{
	local SwatGUIConfig.eSwatGameState oldState;
	local string errStr;

	oldState = GuiConfig.SwatGameState;
	if(AndAnd_BoolBool(EqualEqual_IntInt(int(oldState), int(7)), Not_PreBool(AndAnd_BoolBool(EqualEqual_IntInt(int(NewState), int(1)), bFailedServerTransitionEnabled))))
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[dkaplan] >>> NOT StateChanging from ", string(self)), ", newState == "), string(GetEnum(Enum'SwatGame.SwatGUIConfig.eSwatGameState', int(NewState)))), ", to oldState == "), string(GetEnum(Enum'SwatGame.SwatGUIConfig.eSwatGameState', int(oldState)))), ", bFailedServerTransitionEnabled = "), string(bFailedServerTransitionEnabled)));
		return;
	}
	Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[dkaplan] >>> StateChange of ", string(self)), ", newState == "), string(GetEnum(Enum'SwatGame.SwatGUIConfig.eSwatGameState', int(NewState)))), ", oldState == "), string(GetEnum(Enum'SwatGame.SwatGUIConfig.eSwatGameState', int(oldState)))));
	errStr = Concat_StrStr(Concat_StrStr(Concat_StrStr("[dkaplan]: Attempted to state change to ", string(GetEnum(Enum'SwatGame.SwatGUIConfig.eSwatGameState', int(NewState)))), ", but the oldState was "), string(GetEnum(Enum'SwatGame.SwatGUIConfig.eSwatGameState', int(oldState))));
	switch(NewState)
	{
		case 0:
			AssertWithDescription(OrOr_BoolBool(EqualEqual_IntInt(int(oldState), int(1)), EqualEqual_IntInt(int(oldState), int(0))), errStr);
			GuiConfig.FirstTimeThrough = true;
			break;
		case 1:
			AssertWithDescription(NotEqual_IntInt(int(oldState), int(2)), errStr);
			break;
		case 2:
			AssertWithDescription(NotEqual_IntInt(int(oldState), int(1)), errStr);
			break;
		case 3:
			AssertWithDescription(OrOr_BoolBool(EqualEqual_IntInt(int(oldState), int(2)), EqualEqual_IntInt(int(oldState), int(6))), errStr);
			if(EqualEqual_IntInt(int(GuiConfig.SwatGameRole), int(4)))
			{
				bDelayedFinish = false;
				GetSGRI().ServerCountdownTime = Add_FloatFloat(float(ServerSettings(Level.CurrentServerSettings).MPMissionReadyTime), PRECACHING_FUDGE);
				UpdateRoundsWon(0);
				UpdateRoundsWon(1);
			}
			break;
		case 4:
			AssertWithDescription(OrOr_BoolBool(EqualEqual_IntInt(int(oldState), int(3)), EqualEqual_IntInt(int(oldState), int(5))), errStr);
			if(EqualEqual_IntInt(int(GuiConfig.SwatGameRole), int(4)))
			{
				NetRoundInProgress = true;
				GetSGRI().ServerCountdownTime = float(ServerSettings(Level.CurrentServerSettings).RoundTimeLimit);
			}
			break;
		case 5:
			AssertWithDescription(EqualEqual_IntInt(int(oldState), int(4)), errStr);
			Log(Concat_StrStr("......FirstTimeThrough=", string(GuiConfig.FirstTimeThrough)));
			Log(Concat_StrStr("......SwatGameRole=", string(GuiConfig.SwatGameRole)));
			if(OrOr_BoolBool(EqualEqual_IntInt(int(GuiConfig.SwatGameRole), int(5)), EqualEqual_IntInt(int(GuiConfig.SwatGameRole), int(4))))
			{
				GuiConfig.FirstTimeThrough = false;
			}
			else
			{
				SwatGameInfo(Level.Game).MissionEnded();
			}
			if(EqualEqual_IntInt(int(GuiConfig.SwatGameRole), int(4)))
			{
				GetSGRI().ServerCountdownTime = float(ServerSettings(Level.CurrentServerSettings).PostGameTimeLimit);
			}
			NetRoundInProgress = false;
			break;
		case 6:
			AssertWithDescription(OrOr_BoolBool(OrOr_BoolBool(OrOr_BoolBool(EqualEqual_IntInt(int(oldState), int(0)), EqualEqual_IntInt(int(oldState), int(3))), EqualEqual_IntInt(int(oldState), int(4))), EqualEqual_IntInt(int(oldState), int(5))), errStr);
			break;
		case 7:
			bFailedServerTransitionEnabled = false;
			break;
		default:
			break;
	}
	if(EqualEqual_IntInt(int(GuiConfig.SwatGameRole), int(5)))
	{
		LastServerTime = GetSGRI().ServerCountdownTime;
		CumulativeDelta = 0.0000000;
	}
	GuiConfig.SwatGameState = NewState;
	if(NotEqual_ObjectObject(SwatGUIControllerBase(GUIController), none))
	{
		SwatGUIControllerBase(GUIController).OnStateChange(oldState, NewState);
	}
	if(NotEqual_ObjectObject(PlayerController, none))
	{
		PlayerController.OnStateChange(oldState, NewState);
	}
	return;
}

function RoleChange(SwatGUIConfig.eSwatGameRole newRole)
{
	local SwatGUIConfig.eSwatGameRole oldRole;

	oldRole = GuiConfig.SwatGameRole;
	Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[dkaplan] >>> RoleChange of ", string(self)), ", newRole == "), string(GetEnum(Enum'SwatGame.SwatGUIConfig.eSwatGameRole', int(newRole)))), ", oldRole == "), string(GetEnum(Enum'SwatGame.SwatGUIConfig.eSwatGameRole', int(oldRole)))));
	if(EqualEqual_IntInt(int(oldRole), int(newRole)))
	{
		return;
	}
	GuiConfig.SwatGameRole = newRole;
	if(NotEqual_ObjectObject(SwatGUIControllerBase(GUIController), none))
	{
		SwatGUIControllerBase(GUIController).OnRoleChange(oldRole, newRole);
	}
	if(NotEqual_ObjectObject(PlayerController, none))
	{
		PlayerController.OnRoleChange(oldRole, newRole);
	}
	return;
}

function OnCriticalMoment()
{
	Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("[dkaplan] >>> SwatRepo::OnCriticalMoment() ", string(self)), ", GuiConfig.CriticalMomentDelay = "), string(GuiConfig.CriticalMomentDelay)));
	if(Greater_FloatFloat(GuiConfig.CriticalMomentDelay, float(0)))
	{
		CriticalMomentCountdown = GuiConfig.CriticalMomentDelay;
	}
	else
	{
		OnDelayedCriticalMoment();
	}
	return;
}

function OnDelayedCriticalMoment()
{
	Log(Concat_StrStr("[dkaplan] >>> SwatRepo::OnDelayedCriticalMoment() ", string(self)));
	if(OrOr_BoolBool(GuiConfig.CurrentMission.IsMissionTerminal(), AndAnd_BoolBool(Not_PreBool(MissionObjectives.AnyVisibleObjectivesInProgress()), Procedures.ProceduresMaxed())))
	{
		SwatGameInfo(Level.Game).GameAbort();
	}
	return;
}

function FailedServerConnection()
{
	Log("[dkaplan] >>> SwatRepo::FailedServerConnection()");
	Level.ConsoleCommand("KILLNET");
	StateChange(7);
	return;
}

function FailedConnectionAccepted()
{
	Log("[dkaplan] >>> SwatRepo::FailedConnectionAccepted()");
	bFailedServerTransitionEnabled = true;
	return;
}

event NetworkClientLoading()
{
	Log(Concat_StrStr(string(self), "::NetworkClientLoading()"));
	RoleChange(5);
	NetworkPlayerLoading();
	return;
}

event NetworkHostLoading()
{
	Log(Concat_StrStr(string(self), "::NetworkHostLoading()"));
	RoleChange(4);
	NetworkPlayerLoading();
	return;
}

function NetworkPlayerLoading()
{
	Log(Concat_StrStr(string(self), "::NetworkPlayerLoading()"));
	if(NotEqual_ObjectObject(SwatGUIControllerBase(GUIController), none))
	{
		SwatGUIControllerBase(GUIController).OnNetworkPlayerLoading();
	}
	else
	{
		bInitAsNetPlayer = true;
	}
	return;
}

event OnDisconnected()
{
	if(NotEqual_ObjectObject(SwatGUIControllerBase(GUIController), none))
	{
		SwatGUIControllerBase(GUIController).super(SwatGUIControllerBase).OnDisconnected();
	}
	return;
}

final function CheckAllPlayersReady()
{
	assert(EqualEqual_IntInt(int(GuiConfig.SwatGameRole), int(4)));
	if(SwatGameReplicationInfo(Level.Game.GameReplicationInfo).AllPlayersAreReady())
	{
		AllPlayersReady();
	}
	return;
}

final function AllPlayersReady()
{
	Log("[dkaplan] >>> AllPlayersReady()");
	SwatGameReplicationInfo(Level.Game.GameReplicationInfo).ResetPlayerReadyValues();
	if(EqualEqual_IntInt(int(GuiConfig.SwatGameState), int(3)))
	{
		NetRoundStart();
	}
	else
	{
		if(EqualEqual_IntInt(int(GuiConfig.SwatGameState), int(5)))
		{
			NetNextRound();
		}
	}
	return;
}

function SwapServerSettings()
{
	local Actor tempRef;

	tempRef = Level.CurrentServerSettings;
	Level.CurrentServerSettings = Level.PendingServerSettings;
	Level.PendingServerSettings = tempRef;
	return;
}

function NetNextRound()
{
	Log("[dkaplan] >>> NetNextRound()");
	SwapServerSettings();
	AddAdd_Int(ServerSettings(Level.CurrentServerSettings).RoundNumber);
	if(ServerSettings(Level.CurrentServerSettings).bDirty)
	{
		ServerSettings(Level.CurrentServerSettings).RoundNumber = 0;
		ClearRoundsWon();
		NetSwitchLevels();
	}
	else
	{
		if(GreaterEqual_IntInt(ServerSettings(Level.CurrentServerSettings).RoundNumber, ServerSettings(Level.CurrentServerSettings).NumRounds))
		{
			ServerSettings(Level.CurrentServerSettings).RoundNumber = 0;
			ClearRoundsWon();
			NetSwitchLevels(true);
		}
		else
		{
			if(Not_PreBool(ServerSettings(Level.CurrentServerSettings).bQuickRoundReset))
			{
				NetSwitchLevels();
			}
			else
			{
				NetQuickStartNextRound();
			}
		}
	}
	Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("Advancing to the next round... ServerSettings(Level.CurrentServerSettings).RoundNumber=", string(ServerSettings(Level.CurrentServerSettings).RoundNumber)), ", ServerSettings(Level.CurrentServerSettings).NumRounds="), string(ServerSettings(Level.CurrentServerSettings).NumRounds)), ", ServerSettings(Level.CurrentServerSettings).MapIndex="), string(ServerSettings(Level.CurrentServerSettings).MapIndex)));
	return;
}

function NetSwitchLevels(optional bool bAdvanceToNextMap)
{
	Log("[dkaplan] >>> NetSwitchLevels()");
	assert(NotEqual_IntInt(int(Level.NetMode), int(NM_Client)));
	if(bAdvanceToNextMap)
	{
		AddAdd_Int(ServerSettings(Level.CurrentServerSettings).MapIndex);
		if(GreaterEqual_IntInt(ServerSettings(Level.CurrentServerSettings).MapIndex, ServerSettings(Level.CurrentServerSettings).NumMaps))
		{
			ServerSettings(Level.CurrentServerSettings).MapIndex = 0;
		}
	}
	ServerSettings(Level.CurrentServerSettings).SaveConfig();
	FlushBogusPlayerItems();
	SetTravellingToNewRound();
	Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("Beginning a new Map... ServerSettings(Level.CurrentServerSettings).RoundNumber=", string(ServerSettings(Level.CurrentServerSettings).RoundNumber)), ", ServerSettings(Level.CurrentServerSettings).NumRounds="), string(ServerSettings(Level.CurrentServerSettings).NumRounds)), ", ServerSettings(Level.CurrentServerSettings).MapIndex="), string(ServerSettings(Level.CurrentServerSettings).MapIndex)));
	Level.ServerTravel(ServerSettings(Level.CurrentServerSettings).Maps[ServerSettings(Level.CurrentServerSettings).MapIndex], false);
	return;
}

function NetQuickStartNextRound()
{
	local SwatGameInfo SGI;

	Log("[dkaplan] >>> NetStartNextRound()");
	ServerSettings(Level.CurrentServerSettings).SaveConfig();
	ServerSettings(Level.PendingServerSettings).ResetConfig();
	SGI = SwatGameInfo(Level.Game);
	SGI.PreQuickRoundRestart();
	SGI.InitializeGameMode();
	SGI.OnMissionStarted();
	NetRoundStart();
	return;
}

function NetRoundStart()
{
	local Controller Controller;
	local SwatGamePlayerController SwatController;
	local SwatGameInfo SGI;

	Log("[dkaplan] >>> NetRoundStart()");
	Log("SwatRepo::NetRoundStart() called.");
	SGI = SwatGameInfo(Level.Game);
	assert(NotEqual_ObjectObject(SGI, none));
	FlushBogusPlayerItems();
	SGI.SetStartClustersForRoundStart();
	SGI.AssignPlayerRoles();
	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_DedicatedServer)))
	{
		OnMissionStarted();
	}
	Controller = Level.ControllerList;
	J0xC1:

	if(NotEqual_ObjectObject(Controller, none))
	{
		SwatController = SwatGamePlayerController(Controller);
		if(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(SwatController, none), NotEqual_ObjectObject(SwatController.SwatRepoPlayerItem, none)), SwatController.SwatRepoPlayerItem.IsReadyToSpawn()))
		{
			SGI.RestartPlayer(Controller);
			SwatController.SwatRepoPlayerItem.SetHasEnteredFirstRound();
			SwatController.ClientRoundStarted();
		}
		Controller = Controller.nextController;
		// [Loop Continue]
		goto J0xC1;
	}
	return;
}

function OnNetRoundFinished(SwatGameInfo.ESwatRoundOutcome RoundOutcome)
{
	local string Result;

	Log("SwatRepo::OnNetRoundFinished() called.");
	bDelayedFinish = true;
	SwatGameInfo(Level.Game).NetRoundTimeRemaining(0.0000000);
	SwatGameInfo(Level.Game).MissionEnded();
	GetSGRI().ServerCountdownTime = GuiConfig.MPPostMissionTime;
	switch(RoundOutcome)
	{
		case 9:
			Level.Game.Broadcast(none, "", 'COOPCompleted');
			break;
		case 10:
			Level.Game.Broadcast(none, "", 'COOPFailed');
			break;
		case 1:
			Result = GuiConfig.MPSuspectsWinMessage;
			Level.Game.Broadcast(none, Result, 'SuspectsWin');
			break;
		case 0:
			Result = GuiConfig.MPSWATWinMessage;
			Level.Game.Broadcast(none, Result, 'SwatWin');
			break;
		case 2:
			Level.Game.Broadcast(none, "", 'AllBombsDisarmed');
			break;
		case 3:
			Level.Game.Broadcast(none, "", 'BombExploded');
			break;
		case 5:
			Level.Game.Broadcast(none, "", 'VIPSafe');
			break;
		case 6:
			Level.Game.Broadcast(none, "", 'WinSuspectsBadKill');
			break;
		case 7:
			Level.Game.Broadcast(none, "", 'WinSwatBadKill');
			break;
		case 8:
			Level.Game.Broadcast(none, "", 'WinSuspectsGoodKill');
			break;
		case 4:
			Result = GuiConfig.MPTieMessage;
			Level.Game.Broadcast(none, Result, 'GameTied');
			break;
		default:
			AssertWithDescription(false, Concat_StrStr("Invalid RoundOutcome in SwatRepo::OnNetRoundFinished(). outcome=", string(RoundOutcome)));
			break;
	}
	return;
}

private function NetRoundDelayedFinish()
{
	local Controller Controller;
	local SwatGamePlayerController SGPC;

	Log("SwatRepo::NetRoundDelayedFinish() called.");
	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_DedicatedServer)))
	{
		StateChange();
	}
	Controller = Level.ControllerList;
	J0x62:

	if(NotEqual_ObjectObject(Controller, none))
	{
		SGPC = SwatGamePlayerController(Controller);
		if(NotEqual_ObjectObject(SGPC, none))
		{
			if(Not_PreBool(SGPC.HasEnteredFirstRoundOfNetworkGame()))
			{
				SGPC.ClientRoundStarted();
			}
			SwatPlayerReplicationInfo(SGPC.PlayerReplicationInfo).COOPPlayerStatus = 0;
			SGPC.GameHasEnded();
			SGPC.ClientGameEnded();
		}
		Controller = Controller.nextController;
		// [Loop Continue]
		goto J0x62;
	}
	return;
}

simulated function AnimationSetManager GetAnimationSetManager()
{
	return AnimationSetManager;
	return;
}

function int GetNewSwatPlayerID()
{
	AddAdd_Int(SwatPlayerIDCounter);
	Log(Concat_StrStr("in SwatRepo::GetNewSwatPlayerID(). new ID=", string(SwatPlayerIDCounter)));
	return SwatPlayerIDCounter;
	return;
}

function SwatRepoPlayerItem GetRepoPlayerItem(int SwatPlayerID)
{
	local SwatRepoPlayerItem NewItem;
	local int i;

	Log(Concat_StrStr("in SwatRepo::GetRepoPlayerItem(). ID=", string(SwatPlayerID)));
	i = 0;
	J0x39:

	if(Less_IntInt(i, PlayerItems.Length))
	{
		if(AndAnd_BoolBool(NotEqual_ObjectObject(PlayerItems[i], none), EqualEqual_IntInt(PlayerItems[i].SwatPlayerID, SwatPlayerID)))
		{
			return PlayerItems[i];
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x39;
	}
	NewItem = Class'SwatGame.SwatRepoPlayerItem'.static.Allocate(self).;
	Construct_Void();
	NewItem.SwatPlayerID = SwatPlayerID;
	PlayerItems[PlayerItems.Length] = NewItem;
	NewItem.bIsAReconnectingClient = false;
	NewItem.bHasEnteredFirstRound = false;
	UpdateGameSpyStats();
	return NewItem;
	return;
}

function int NumberOfRepoPlayerItems()
{
	local int i, Count;

	Count = 0;
	i = 0;
	J0x0E:

	if(Less_IntInt(i, PlayerItems.Length))
	{
		if(NotEqual_ObjectObject(PlayerItems[i], none))
		{
			AddAdd_PreInt(Count);
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x0E;
	}
	return Count;
	return;
}

function int NumberOfPlayersWhoShouldReturn()
{
	local int i, Count;

	Count = 0;
	i = 0;
	J0x0E:

	if(Less_IntInt(i, PlayerItems.Length))
	{
		if(AndAnd_BoolBool(NotEqual_ObjectObject(PlayerItems[i], none), EqualEqual_BoolBool(PlayerItems[i].bIsAReconnectingClient, true)))
		{
			AddAdd_PreInt(Count);
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x0E;
	}
	return Count;
	return;
}

function SetTravellingToNewRound()
{
	local int i;

	MPLog("Setting bTravellingToNewRound to true.");
	bTravellingToNewRound = true;
	i = 0;
	J0x3D:

	if(Less_IntInt(i, PlayerItems.Length))
	{
		if(NotEqual_ObjectObject(PlayerItems[i], none))
		{
			PlayerItems[i].bIsAReconnectingClient = true;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x3D;
	}
	return;
}

final function SetDesiredEntryPoint(SwatStartPointBase.EEntryType EntrySet)
{
	GuiConfig.super(SwatRepo).SetDesiredEntryPoint(EntrySet);
	return;
}

final function SwatStartPointBase.EEntryType GetDesiredEntryPoint()
{
	if(Level.IsCOOPServer)
	{
		return ServerSettings(Level.CurrentServerSettings).DesiredMPEntryPoint;
	}
	else
	{
		return GuiConfig.super(SwatRepo).GetDesiredEntryPoint();
	}
	return;
}

function bool GetTravellingToNewRound()
{
	return bTravellingToNewRound;
	return;
}

function bool IsLANOnlyGame()
{
	return ServerSettings(Level.CurrentServerSettings).bLAN;
	return;
}

function SetSGRI(SwatGameReplicationInfo SGRI)
{
	CachedSGRI = SGRI;
	return;
}

function SwatGameReplicationInfo GetSGRI()
{
	if(EqualEqual_IntInt(int(GuiConfig.SwatGameRole), int(4)))
	{
		if(EqualEqual_ObjectObject(CachedSGRI, none))
		{
			CachedSGRI = SwatGameReplicationInfo(Level.GetGameReplicationInfo());
		}
	}
	return CachedSGRI;
	return;
}

function float GetExternalDamageModifier(Actor Damager, Actor Victim)
{
	if(AndAnd_BoolBool(NotEqual_ObjectObject(NetPlayer(Damager), none), NotEqual_ObjectObject(NetPlayer(Victim), none)))
	{
		if(EqualEqual_IntInt(NetPlayer(Damager).GetTeamNumber(), NetPlayer(Victim).GetTeamNumber()))
		{
			return GetFriendlyFireModifier();
		}
		else
		{
			return GetEnemyFireModifier();
		}
	}
	else
	{
		return super.GetExternalDamageModifier(Damager, Victim);
	}
	return;
}

function float GetFriendlyFireModifier()
{
	if(EqualEqual_FloatFloat(ServerSettings(Level.CurrentServerSettings).EnemyFireAmount, 0.0000000))
	{
		return 0.0000000;
	}
	return ServerSettings(Level.CurrentServerSettings).FriendlyFireAmount;
	return;
}

function float GetEnemyFireModifier()
{
	return ServerSettings(Level.CurrentServerSettings).EnemyFireAmount;
	return;
}

function TrainingTextManager GetTrainingTextManager()
{
	if(EqualEqual_ObjectObject(TrainingTextManager, none))
	{
		TrainingTextManager = Level.Spawn(Class'SwatGame.TrainingTextManager');
		AssertWithDescription(NotEqual_ObjectObject(TrainingTextManager, none), "[tcohen] SwatRepo::GetTrainingTextManager() failed to Spawn() the TrainingTextManager.");
	}
	return TrainingTextManager;
	return;
}

function ConversationManager GetConversationManager()
{
	if(EqualEqual_ObjectObject(ConversationManager, none))
	{
		ConversationManager = Level.Spawn(Class'SwatGame.ConversationManager');
		AssertWithDescription(NotEqual_ObjectObject(ConversationManager, none), "[tcohen] SwatRepo::GetConversationManager() failed to Spawn() the ConversationManager.");
	}
	return ConversationManager;
	return;
}

function int NumberOfReturnedPlayers()
{
	local Controller Controller;
	local SwatGamePlayerController SwatController;
	local int Count;

	Count = 0;
	Controller = Level.ControllerList;
	J0x1B:

	if(NotEqual_ObjectObject(Controller, none))
	{
		SwatController = SwatGamePlayerController(Controller);
		if(NotEqual_ObjectObject(SwatController, none))
		{
			if(SwatController.IsAReconnectingClient())
			{
				AddAdd_PreInt(Count);
			}
		}
		Controller = Controller.nextController;
		// [Loop Continue]
		goto J0x1B;
	}
	return Count;
	return;
}

function bool AnyPlayersOnServer()
{
	local Controller Controller;

	Controller = Level.ControllerList;
	J0x14:

	if(NotEqual_ObjectObject(Controller, none))
	{
		if(NotEqual_ObjectObject(SwatGamePlayerController(Controller), none))
		{
			return true;
		}
		Controller = Controller.nextController;
		// [Loop Continue]
		goto J0x14;
	}
	return false;
	return;
}

function SetObjectiveVisibility(name ObjectiveName, bool Visible)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, MissionObjectives.Objectives.Length))
	{
		if(EqualEqual_NameName(MissionObjectives.Objectives[i].Name, ObjectiveName))
		{
			MissionObjectives.Objectives[i].SetVisibility(Visible);
			return;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	AssertWithDescription(false, Concat_StrStr(Concat_StrStr("[tcohen] ActionSetObjectiveVisibility::Execute() The Objective named ", string(ObjectiveName)), " was not found to be a current Objective."));
	return;
}

function ClearRoundsWon()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, 2))
	{
		RoundsWon[i] = 0;
		UpdateRoundsWon(i);
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

function IncrementRoundsWon(int TeamID)
{
	AddAdd_Int(RoundsWon[TeamID]);
	UpdateRoundsWon(TeamID);
	return;
}

function UpdateRoundsWon(int TeamID)
{
	NetTeam(GetSGRI().Teams[TeamID]).NetScoreInfo.SetRoundsWon(RoundsWon[TeamID]);
	return;
}

function PreLevelChangeCleanup()
{
	local Pawn P;

	if(NotEqual_ObjectObject(SwatGUIControllerBase(GUIController), none))
	{
		SwatGUIControllerBase(GUIController).PreLevelChangeCleanup();
	}
	MPLog("PreLevelChangeCleanup: destroying all pawns...");
	if(NotEqual_ObjectObject(Level, none))
	{
		foreach Level.DynamicActors(Class'Engine.Pawn', P)
		{
			P.Destroy();
		}
	}
	return;
}

function UpdateGameSpyStats()
{
	local GameSpyManager GSM;

	GSM = Level.GetGameSpyManager();
	if(NotEqual_ObjectObject(GSM, none))
	{
		GSM.SendServerStateChanged();
	}
	return;
}

event bool ShouldShowSubtitles()
{
	return GuiConfig.bShowSubtitles;
	return;
}

defaultproperties
{
	PRECACHING_FUDGE=30.0000000
}