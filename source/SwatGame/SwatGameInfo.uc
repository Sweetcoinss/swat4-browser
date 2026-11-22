class SwatGameInfo extends GameInfo implements IInterested_GameEvent_EvidenceSecured, IInterested_GameEvent_ReportableReportedToTOC
	native
	config(SwatGame)
	hidecategories(Karma,Movement,Collision,Lighting,LightColor,Karma,Force);

enum EMPTeam
{
	MPT_Swat,                       // 0
	MPT_Suspects                    // 1
};

enum ESwatRoundOutcome
{
	SRO_SwatVictoriousNormal,       // 0
	SRO_SuspectsVictoriousNormal,   // 1
	SRO_SwatVictoriousRapidDeployment,// 2
	SRO_SuspectsVictoriousRapidDeployment,// 3
	SRO_RoundEndedInTie,            // 4
	SRO_SwatVictoriousVIPEscaped,   // 5
	SRO_SuspectsVictoriousKilledVIPValid,// 6
	SRO_SwatVictoriousSuspectsKilledVIPInvalid,// 7
	SRO_SuspectsVictoriousSwatKilledVIP,// 8
	SRO_COOPCompleted,              // 9
	SRO_COOPFailed                  // 10
};

var array<Mesh> PrecacheMeshes;
var array<StaticMesh> PrecacheStaticMeshes;
var array<Material> PrecacheMaterials;
var private bool LevelHasFemaleCharacters;
var bool bDebugFrames;
var array<DebugFrameData> DebugFrameData;
var DebugFrameData CurrentDebugFrameData;
var private SpawningManager SpawningManager;
var private SwatRepo Repo;
var GameEventsContainer GameEvents;
var private Timer ObjectiveTimer;
var private NavigationPoint LastPlayerStartSpot;
var private NavigationPoint LastStartSpot;
var array<PlayerStart> PlayerStartArray;
var private int NextPlayerStartPoint;
var private GameMode GameMode;
var private int PreviousNetRoundTimeRemaining;
var private config float SPDamageModifierEasy;
var private config float SPDamageModifierNormal;
var private config float SPDamageModifierHard;
var private config float SPDamageModifierElite;
var private config float MPDamageModifier;
var private config float COOPDamageModifier;
var private int NumSpawnedOfficers;
var config bool DebugObjectives;
var config bool DebugLeadership;
var config bool DebugLeadershipStatus;
var config bool DebugSpawning;
var private bool bAlreadyCompleted;
var private bool bAlreadyFailed;
var private bool bAlreadyEnded;
var private config float ScoringUpdateInterval;
var private Timer ScoringUpdateTimer;
var private Timer ReconnectionTimer;
var private config float ReconnectionTime;
var SwatAdmin Admin;
//var delegate<MissionObjectiveTimeExpired> __MissionObjectiveTimeExpired__Delegate;

delegate MissionObjectiveTimeExpired()
{
	return;
}

function PreBeginPlay()
{
	local SwatPlayerStart Point;

	Label = 'Game';
	Repo = SwatRepo(Level.GetRepo());
	DebugObjectives = AndAnd_BoolBool(DebugObjectives, Level.GetEngine().EnableDevTools);
	DebugLeadership = AndAnd_BoolBool(DebugLeadership, Level.GetEngine().EnableDevTools);
	DebugLeadershipStatus = AndAnd_BoolBool(DebugLeadershipStatus, Level.GetEngine().EnableDevTools);
	DebugSpawning = AndAnd_BoolBool(DebugSpawning, Level.GetEngine().EnableDevTools);
	bAlreadyCompleted = false;
	bAlreadyFailed = false;
	bAlreadyEnded = false;
	bPostGameStarted = false;
	GameEvents = Class'SwatGame.GameEventsContainer'.static.Allocate(self).;
	Construct_Void();
	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
	{
		bDelayedStart = true;
		bTeamGame = true;
	}
	super.PreBeginPlay();
	Admin = Spawn(Class'SwatGame.SwatAdmin');
	Admin.SetAdminPassword(SwatRepo(Level.GetRepo()).GuiConfig.AdminPassword);
	RegisterNotifyGameStarted();
	if(bDebugFrames)
	{
		AddDebugFrameData();
	}
	foreach AllActors(Class'SwatGame.SwatPlayerStart', Point)
	{
		if(OrOr_BoolBool(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)), Not_PreBool(Point.IsA('SwatOfficerStart'))))
		{
			PlayerStartArray[PlayerStartArray.Length] = Point;
		}
	}
	if(EqualEqual_IntInt(PlayerStartArray.Length, 0))
	{
		AssertWithDescription(false, "Fatal Error: Failed to find any SwatPlayerStart points to spawn at -- make sure your start points are SwatPlayerStarts and not PlayerStarts!");
		assert(false);
	}
	NextPlayerStartPoint = 0;
	InitializeGameMode();
	if(OrOr_BoolBool(EqualEqual_IntInt(int(Level.NetMode), int(NM_ListenServer)), EqualEqual_IntInt(int(Level.NetMode), int(NM_DedicatedServer))))
	{
		SetAssertWithDescriptionShouldUseDialog(true);
	}
	return;
}

function PostBeginPlay()
{
	super.PostBeginPlay();
	if(OrOr_BoolBool(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)), Level.IsCOOPServer))
	{
		if(NotEqual_ObjectObject(GetCustomScenario(), none))
		{
			Log("[MISSION] Playing Custom Scenario");
		}
		else
		{
			Log("[MISSION] Playing a Campaign or Multiplayer Mission (not a Custom Scenario)");
		}
		Repo.MissionObjectives.Initialize(self);
		Log(Concat_StrStr("[MISSION] Mission Objectives Initialized for Mission ", string(Repo.GuiConfig.CurrentMission)));
		SpawningManager = SpawningManager(Level.SpawningManager);
		if(EqualEqual_ObjectObject(SpawningManager, none))
		{
			Warn("SKIPPING SPAWNING: This map has no SpawningManager in its LevelInfo.");
		}
		else
		{
			SpawningManager.Initialize(Level);
			SpawningManager.DoSpawning(self);
		}
		MissionStatus();
		Repo.Procedures.Init(self);
		ScoringUpdateTimer = Spawn(Class'Engine.Timer');
		assert(NotEqual_ObjectObject(ScoringUpdateTimer, none));
		ScoringUpdateTimer.__TimerDelegate__Delegate = UpdateScoring;
		ScoringUpdateTimer.StartTimer(ScoringUpdateInterval, true);
	}
	Level.TickSpecialEnabled = false;
	if(AndAnd_BoolBool(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)), Greater_IntInt(Repo.NumberOfRepoPlayerItems(), GetNumPlayers())))
	{
		ReconnectionTimer = Spawn(Class'Engine.Timer');
		assert(NotEqual_ObjectObject(ReconnectionTimer, none));
		ReconnectionTimer.__TimerDelegate__Delegate = ReconnectionTimerExpired;
		ReconnectionTimer.StartTimer(ReconnectionTime);
	}
	return;
}

function ReconnectionTimerExpired()
{
	Repo.FlushBogusPlayerItems();
	TestWaitingForPlayersToReconnect();
	if(NotEqual_ObjectObject(ReconnectionTimer, none))
	{
		ReconnectionTimer.Destroy();
	}
	return;
}

function TestWaitingForPlayersToReconnect()
{
	SwatGameReplicationInfo(GameReplicationInfo).SetWaitingForPlayers(Greater_IntInt(Repo.NumberOfRepoPlayerItems(), GetNumPlayers()));
	return;
}

final function UpdateScoring()
{
	local int i;
	local SwatGameReplicationInfo SGRI;

	SGRI = SwatGameReplicationInfo(GameReplicationInfo);
	i = 0;
	J0x17:

	if(Less_IntInt(i, SGRI.20))
	{
		if(AndAnd_BoolBool(Less_IntInt(i, Repo.Procedures.Procedures.Length), OrOr_BoolBool(NotEqual_IntInt(int(Repo.GuiConfig.SwatGameState), int(4)), Repo.Procedures.Procedures[i].IsShownInObjectivesPanel)))
		{
			SGRI.ProcedureCalculations[i] = Repo.Procedures.Procedures[i].Status();
			SGRI.ProcedureValue[i] = Repo.Procedures.Procedures[i].GetCurrentValue();
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x17;
	}
	i = 0;
	J0x127:

	if(Less_IntInt(i, SGRI.30))
	{
		if(Less_IntInt(i, Repo.MissionObjectives.Objectives.Length))
		{
			SGRI.ObjectiveStatus[i] = Repo.MissionObjectives.Objectives[i].GetStatus();
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x127;
	}
	return;
}

function BombExploded()
{
	Broadcast(none, "", 'BombExploded');
	return;
}

final function ClearTimedMissionObjective()
{
	local SwatGameReplicationInfo SGRI;

	SGRI = SwatGameReplicationInfo(GameReplicationInfo);
	SGRI.SpecialTime = 0;
	SGRI.TimedObjectiveIndex = -1;
	__MissionObjectiveTimeExpired__Delegate = None;
	if(NotEqual_ObjectObject(ObjectiveTimer, none))
	{
		ObjectiveTimer.Destroy();
	}
	return;
}

final function SetTimedMissionObjective(Objective Objective)
{
	local SwatGameReplicationInfo SGRI;
	local int i;

	SGRI = SwatGameReplicationInfo(GameReplicationInfo);
	SGRI.SpecialTime = int(Objective.Time);
	i = 0;
	J0x36:

	if(Less_IntInt(i, Repo.MissionObjectives.Objectives.Length))
	{
		if(EqualEqual_ObjectObject(Repo.MissionObjectives.Objectives[i], Objective))
		{
			SGRI.TimedObjectiveIndex = i;
			// [Explicit Break]
			goto J0xA0;
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x36;
	}
	J0xA0:

	__MissionObjectiveTimeExpired__Delegate = Objective.OnTimeExpired;
	ObjectiveTimer = Spawn(Class'Engine.Timer');
	assert(NotEqual_ObjectObject(ObjectiveTimer, none));
	ObjectiveTimer.__TimerDelegate__Delegate = UpdateTimedMissionObjective;
	ObjectiveTimer.StartTimer(1.0000000, true);
	return;
}

final function UpdateTimedMissionObjective()
{
	local SwatGameReplicationInfo SGRI;

	SGRI = SwatGameReplicationInfo(GameReplicationInfo);
	SubtractSubtract_Int(SGRI.SpecialTime);
	if(LessEqual_IntInt(SGRI.SpecialTime, 0))
	{
		MissionObjectiveTimeExpired();
	}
	return;
}

final function OnMissionObjectiveCompleted(Objective Objective)
{
	if(DebugObjectives)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[OBJECTIVES] ", string(Objective.Name)), " ("), Objective.Description), ") Completed"));
	}
	dispatchMessage(Class'SwatGame.MessageMissionObjectiveCompleted'.static.Allocate(self)., construct_Name(Objective.Name));
	if(Repo.GuiConfig.CurrentMission.IsMissionCompleted())
	{
		if(AndAnd_BoolBool(Not_PreBool(bAlreadyCompleted), Not_PreBool(bAlreadyFailed)))
		{
			MissionCompleted();
		}
		OnCriticalMoment();
	}
	return;
}

final function OnMissionObjectiveFailed(Objective Objective)
{
	if(DebugObjectives)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[OBJECTIVES] ", string(Objective.Name)), " ("), Objective.Description), ") Failed"));
	}
	dispatchMessage(Class'SwatGame.MessageMissionObjectiveFailed'.static.Allocate(self)., construct_Name(Objective.Name));
	if(Repo.GuiConfig.CurrentMission.IsMissionFailed())
	{
		if(Not_PreBool(bAlreadyFailed))
		{
			MissionFailed();
		}
		OnCriticalMoment();
	}
	return;
}

final function MissionCompleted()
{
	Log("[dkaplan] >>> MissionCompleted");
	bAlreadyCompleted = true;
	Broadcast(none, "", 'MissionCompleted');
	GameEvents.ReportableReportedToTOC.Register(self);
	GameEvents.EvidenceSecured.Register(self);
	GameEvents.MissionCompleted.Triggered();
	return;
}

final function MissionFailed()
{
	Log("[dkaplan] >>> MissionFailed");
	bAlreadyFailed = true;
	Broadcast(none, "", 'MissionFailed');
	GameEvents.ReportableReportedToTOC.Register(self);
	GameEvents.EvidenceSecured.Register(self);
	GameEvents.MissionFailed.Triggered();
	return;
}

final function MissionEnded()
{
	Log("[dkaplan] >>> MissionEnded");
	if(bAlreadyEnded)
	{
		return;
	}
	if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(Not_PreBool(bAlreadyCompleted), Not_PreBool(bAlreadyFailed)), NotEqual_IntInt(int(Repo.GuiConfig.SwatGameRole), int(5))), NotEqual_IntInt(int(Repo.GuiConfig.SwatGameRole), int(4))))
	{
		if(Repo.GuiConfig.CurrentMission.IsMissionCompleted())
		{
			MissionCompleted();
		}
		else
		{
			MissionFailed();
		}
	}
	bAlreadyEnded = true;
	Broadcast(none, "", 'MissionEnded');
	GameEvents.MissionEnded.Triggered();
	return;
}

function GameAbort()
{
	if(NotEqual_IntInt(int(Repo.GuiConfig.SwatGameState), int(4)))
	{
		return;
	}
	if(bAlreadyEnded)
	{
		return;
	}
	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
	{
		Repo.OnMissionEnded();
	}
	else
	{
		GameMode.EndGame();
	}
	UpdateScoring();
	bAlreadyEnded = true;
	return;
}

final function OnCriticalMoment()
{
	Log("[dkaplan] in SwatGameinfo OnCriticalMoment()");
	Repo.OnCriticalMoment();
	return;
}

function OnEvidenceSecured(IEvidence Secured)
{
	if(OrOr_BoolBool(bAlreadyCompleted, bAlreadyFailed))
	{
		OnCriticalMoment();
	}
	return;
}

function OnReportableReportedToTOC(IAmReportableCharacter ReportableCharacter, Pawn Reporter)
{
	if(OrOr_BoolBool(bAlreadyCompleted, bAlreadyFailed))
	{
		OnCriticalMoment();
	}
	return;
}

function InitGameReplicationInfo()
{
	local SwatRepo theRepo;
	local Repo.EMPMode currentGameMode;
	local SwatGameReplicationInfo SGRI;

	theRepo = SwatRepo(Level.GetRepo());
	currentGameMode = ServerSettings(Level.CurrentServerSettings).GameType;
	if(EqualEqual_IntInt(int(currentGameMode), int(0)))
	{
		GameModeString = "0";
	}
	else
	{
		if(EqualEqual_IntInt(int(currentGameMode), int(2)))
		{
			GameModeString = "1";
		}
		else
		{
			if(EqualEqual_IntInt(int(currentGameMode), int(1)))
			{
				GameModeString = "2";
			}
			else
			{
				GameModeString = "3";
			}
		}
	}
	MPLog(Concat_StrStr(Concat_StrStr(string(self), "...GameModeString="), GameModeString));
	super.InitGameReplicationInfo();
	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
	{
		GameReplicationInfo.Teams[0] = Spawn(Class'SwatGame.NetTeamA');
		GameReplicationInfo.Teams[1] = Spawn(Class'SwatGame.NetTeamB');
	}
	SGRI = SwatGameReplicationInfo(GameReplicationInfo);
	GameReplicationInfo.ServerName = ServerSettings(Level.CurrentServerSettings).ServerName;
	if(ServerSettings(Level.CurrentServerSettings).bShowTeammateNames)
	{
		SGRI.ShowTeammateNames = 2;
	}
	else
	{
		SGRI.ShowTeammateNames = 1;
	}
	if(ServerSettings(Level.CurrentServerSettings).bShowEnemyNames)
	{
		SGRI.ShowEnemyNames = 2;
	}
	else
	{
		SGRI.ShowEnemyNames = 1;
	}
	MPLog(Concat_StrStr("---SwatGameInfo::InitGameReplicationInfo(). Level.Title=", Level.Title));
	MPLog(Concat_StrStr("...ShowTeammateNames=", string(SGRI.ShowTeammateNames)));
	MPLog(Concat_StrStr("...ShowEnemyNames=", string(SGRI.ShowEnemyNames)));
	return;
}

function InitializeGameMode()
{
	local Repo.EMPMode GUIGameMode;

	bAlreadyEnded = false;
	Log("Initializing GameMode.");
	if(NotEqual_ObjectObject(GameMode, none))
	{
		GameMode.OnMissionEnded();
		GameMode.Destroy();
		GameMode = none;
	}
	assert(EqualEqual_ObjectObject(GameMode, none));
	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
	{
		GameMode = Spawn(Class'SwatGame.GameModeStandalone', self);
	}
	else
	{
		assert(NotEqual_ObjectObject(ServerSettings(Level.CurrentServerSettings), none));
		GUIGameMode = ServerSettings(Level.CurrentServerSettings).GameType;
		if(EqualEqual_IntInt(int(GUIGameMode), int(1)))
		{
			GameMode = Spawn(Class'SwatGame.GameModeVIP', self);
		}
		else
		{
			if(EqualEqual_IntInt(int(GUIGameMode), int(2)))
			{
				GameMode = Spawn(Class'SwatGame.GameModeRD', self);
			}
			else
			{
				if(EqualEqual_IntInt(int(GUIGameMode), int(3)))
				{
					GameMode = Spawn(Class'SwatGame.GameModeCOOP', self);
				}
				else
				{
					AssertWithDescription(EqualEqual_IntInt(int(GUIGameMode), int(0)), "GameType was not set by GUI; defaulting to Barricaded Suspects");
					GameMode = Spawn(Class'SwatGame.GameModeBS', self);
				}
			}
		}
	}
	GameMode.Initialize();
	return;
}

function GameMode GetGameMode()
{
	return GameMode;
	return;
}

function string GetGameModeName()
{
	local Repo.EMPMode GUIGameMode;

	assert(NotEqual_ObjectObject(ServerSettings(Level.CurrentServerSettings), none));
	GUIGameMode = ServerSettings(Level.CurrentServerSettings).GameType;
	if(EqualEqual_IntInt(int(GUIGameMode), int(1)))
	{
		return "VIP Escort";
	}
	else
	{
		if(EqualEqual_IntInt(int(GUIGameMode), int(2)))
		{
			return "Rapid Deployment";
		}
		else
		{
			if(EqualEqual_IntInt(int(GUIGameMode), int(3)))
			{
				return "CO-OP";
			}
			else
			{
				AssertWithDescription(EqualEqual_IntInt(int(GUIGameMode), int(0)), "We need to get the name of the GameMode, but it hasn't been set yet; defaulting to Barricaded Suspects");
				return "Barricaded Suspects";
			}
		}
	}
	return;
}

function GetServerInfo(out ServerResponseLine ServerState)
{
	ServerState.ServerName = ServerSettings(Level.CurrentServerSettings).ServerName;
	ServerState.MapName = Level.Title;
	ServerState.GameType = GetGameModeName();
	ServerState.CurrentPlayers = NumberOfPlayersForServerBrowser();
	ServerState.MaxPlayers = MaxPlayersForServerBrowser();
	ServerState.IP = "";
	ServerState.Port = GetServerPort();
	ServerState.ModName = Level.ModName;
	ServerState.GameVersion = Level.BuildVersion;
	ServerState.ServerInfo.Length = 0;
	ServerState.PlayerInfo.Length = 0;
	return;
}

function GetServerDetails(out ServerResponseLine ServerState)
{
	local int i;
	local Mutator M;
	local GameRules G;

	i = ServerState.ServerInfo.Length;
	ServerState.ServerInfo.Length = Add_IntInt(i, 1);
	ServerState.ServerInfo[i].Key = "servermode";
	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_ListenServer)))
	{
		ServerState.ServerInfo[AddAdd_Int(i)].Value = "non-dedicated";
	}
	else
	{
		ServerState.ServerInfo[AddAdd_Int(i)].Value = "dedicated";
	}
	ServerState.ServerInfo.Length = Add_IntInt(i, 1);
	ServerState.ServerInfo[i].Key = "ServerVersion";
	ServerState.ServerInfo[AddAdd_Int(i)].Value = Level.EngineVersion;
	if(AccessControl.RequiresPassword())
	{
		ServerState.ServerInfo.Length = Add_IntInt(i, 1);
		ServerState.ServerInfo[i].Key = "password";
		ServerState.ServerInfo[AddAdd_Int(i)].Value = "true";
	}
	M = BaseMutator.NextMutator;
	J0x184:

	if(NotEqual_ObjectObject(M, none))
	{
		M.GetServerDetails(ServerState);
		M = M.NextMutator;
		// [Loop Continue]
		goto J0x184;
	}
	G = GameRulesModifiers;
	J0x1C5:

	if(NotEqual_ObjectObject(G, none))
	{
		G.GetServerDetails(ServerState);
		G = G.NextGameRules;
		// [Loop Continue]
		goto J0x1C5;
	}
	return;
}

function GetServerPlayers(out ServerResponseLine ServerState)
{
	local Mutator M;
	local Controller C;
	local SwatPlayerReplicationInfo PRI;
	local int i;

	return;
	i = ServerState.PlayerInfo.Length;
	C = Level.ControllerList;
	J0x27:

	if(NotEqual_ObjectObject(C, none))
	{
		PRI = SwatPlayerReplicationInfo(C.PlayerReplicationInfo);
		if(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(PRI, none), Not_PreBool(PRI.bBot)), EqualEqual_ObjectObject(MessagingSpectator(C), none)))
		{
			ServerState.PlayerInfo.Length = Add_IntInt(i, 1);
			ServerState.PlayerInfo[i].PlayerNum = PRI.SwatPlayerID;
			ServerState.PlayerInfo[i].PlayerName = PRI.PlayerName;
			ServerState.PlayerInfo[i].Score = PRI.NetScoreInfo.GetScore();
			ServerState.PlayerInfo[i].Ping = PRI.Ping;
			AddAdd_Int(i);
		}
		C = C.nextController;
		// [Loop Continue]
		goto J0x27;
	}
	M = BaseMutator.NextMutator;
	J0x15E:

	if(NotEqual_ObjectObject(M, none))
	{
		M.GetServerPlayers(ServerState);
		M = M.NextMutator;
		// [Loop Continue]
		goto J0x15E;
	}
	return;
}

function SpawningManager GetSpawningManager()
{
	return SpawningManager;
	return;
}

function CustomScenario GetCustomScenario()
{
	if(EqualEqual_ObjectObject(Repo.GuiConfig.CurrentMission, none))
	{
		return none;
	}
	return Repo.GuiConfig.CurrentMission.CustomScenario;
	return;
}

function bool UsingCustomScenario()
{
	return NotEqual_ObjectObject(GetCustomScenario(), none);
	return;
}

function bool CampaignObjectivesAreInEffect()
{
	if(EqualEqual_ObjectObject(GetCustomScenario(), none))
	{
		return true;
	}
	return GetCustomScenario().UseCampaignObjectives;
	return;
}

function PostGameStarted()
{
	bPostGameStarted = true;
	GameEvents.PostGameStarted.Triggered();
	return;
}

function OnGameStarted()
{
	local SwatRepo RepoObj;

	Log("[dkaplan] >>> SwatGameInfo::OnGameStarted()");
	if(bDebugFrames)
	{
		Enable('Tick');
	}
	GameEvents.GameStarted.Triggered();
	RepoObj = Repo;
	assert(NotEqual_ObjectObject(RepoObj, none));
	if(OrOr_BoolBool(OrOr_BoolBool(OrOr_BoolBool(EqualEqual_IntInt(int(RepoObj.GuiConfig.SwatGameRole), int(0)), EqualEqual_IntInt(int(RepoObj.GuiConfig.SwatGameRole), int(1))), EqualEqual_IntInt(int(RepoObj.GuiConfig.SwatGameRole), int(2))), EqualEqual_IntInt(int(RepoObj.GuiConfig.SwatGameRole), int(3))))
	{
		RepoObj.OnMissionStarted();
	}
	return;
}

function OnMissionStarted()
{
	Level.TickSpecialEnabled = true;
	GameEvents.MissionStarted.Triggered();
	dispatchMessage(Class'Gameplay.MessageLevelStart'.static.Allocate(self)., construct_Bool(NotEqual_ObjectObject(GetCustomScenario(), none)));
	return;
}

function bool GameInfoShouldTick()
{
	return bDebugFrames;
	return;
}

function Tick(float DeltaTime)
{
	super.Tick(DeltaTime);
	if(bDebugFrames)
	{
		CurrentDebugFrameData.DeltaTime = DeltaTime;
		AddDebugFrameData();
	}
	return;
}

function NetRoundTimeRemaining(float TimeRemaining)
{
	local int IntTimeRemaining;

	assert(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)));
	IntTimeRemaining = int(TimeRemaining);
	if(NotEqual_IntInt(IntTimeRemaining, PreviousNetRoundTimeRemaining))
	{
		PreviousNetRoundTimeRemaining = IntTimeRemaining;
		GameMode.NetRoundTimeRemaining(IntTimeRemaining);
	}
	return;
}

function NetRoundTimerExpired()
{
	assert(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)));
	GameMode.NetRoundTimerExpired();
	return;
}

exec function DumpEffects(name SystemName)
{
	local EffectsSystem FX;
	local EffectsSubsystem SubSys;
	local name ClassName;

	FX = EffectsSystem(Level.EffectsSystem);
	assert(NotEqual_ObjectObject(FX, none));
	if(EqualEqual_NameName(SystemName, 'Sound'))
	{
		ClassName = 'SoundEffectsSubsystem';
	}
	else
	{
		if(EqualEqual_NameName(SystemName, 'VISUAL'))
		{
			ClassName = 'VisualEffectsSubsystem';
		}
	}
	SubSys = FX.GetSubsystem(ClassName);
	if(EqualEqual_ObjectObject(SubSys, none))
	{
		Warn(Concat_StrStr("WARNING: Cannot dump effects; subsystem not found: ", string(ClassName)));
		return;
	}
	SubSys.LogState();
	return;
}

exec function DebugFrames(name Option, string Param)
{
	local float Mean, Variance, StandardDeviation;
	local int i;
	local bool QualifiedFrame;

	i = 0;
	J0x07:

	if(Less_IntInt(i, DebugFrameData.Length))
	{
		AddEqual_FloatFloat(Mean, DebugFrameData[i].DeltaTime);
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	Mean = Divide_FloatFloat(Mean, float(DebugFrameData.Length));
	i = 0;
	J0x58:

	if(Less_IntInt(i, DebugFrameData.Length))
	{
		AddEqual_FloatFloat(Variance, Square(Subtract_FloatFloat(DebugFrameData[i].DeltaTime, Mean)));
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x58;
	}
	Variance = Divide_FloatFloat(Variance, float(DebugFrameData.Length));
	StandardDeviation = Sqrt(Variance);
	Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("DebugFrames: NumFrames=", string(DebugFrameData.Length)), ", MeanTime="), string(Mean)), ", StandardDeviation="), string(StandardDeviation)));
	switch(Option)
	{
		case 'hitches':
			Log("                Hitches - Frames with time > a standard deviation from the mean:");
			break;
		case 'keyword':
			Log(Concat_StrStr(Concat_StrStr("                Keyword - Frames with the string '", Param), "' found in GuardString:"));
			break;
		case 'All':
			Log("                All - all frame data:");
			break;
		default:
			Log("DebugFrames Usage: debugframes [name Option] [string Param]");
			Log("             Options: 'hitches' (string Param ignored), 'keyword' (specified in string Param), 'all' (string param ignored)");
			return;
			break;
	}
	i = 0;
	J0x2DD:

	if(Less_IntInt(i, DebugFrameData.Length))
	{
		switch(Option)
		{
			case 'hitches':
				QualifiedFrame = Greater_FloatFloat(DebugFrameData[i].DeltaTime, Add_FloatFloat(Mean, StandardDeviation));
				break;
			case 'keyword':
				QualifiedFrame = NotEqual_IntInt(InStr(DebugFrameData[i].GetGuardString(), Param), -1);
				break;
			case 'All':
				QualifiedFrame = true;
				break;
			default:
				assert(false);
				break;
		}
		if(QualifiedFrame)
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("    -> Frame #", string(i)), ": EndTime="), string(DebugFrameData[i].EndTimeSeconds)), ", DeltaTime="), string(DebugFrameData[i].DeltaTime)), " ("), string(Divide_FloatFloat(1.0000000, DebugFrameData[i].DeltaTime))), "fps, "), string(Divide_FloatFloat(Abs(Subtract_FloatFloat(DebugFrameData[i].DeltaTime, Mean)), StandardDeviation))), " s.d.(s) from mean), GuardString="), DebugFrameData[i].GetGuardString()));
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x2DD;
	}
	return;
}

function AddDebugFrameData()
{
	if(NotEqual_ObjectObject(CurrentDebugFrameData, none))
	{
		CurrentDebugFrameData.EndTimeSeconds = Level.TimeSeconds;
	}
	CurrentDebugFrameData = Class'SwatGame.DebugFrameData'.static.Allocate(self).;
	Construct_Void();
	DebugFrameData[DebugFrameData.Length] = CurrentDebugFrameData;
	return;
}

function GuardSlow(string GuardString)
{
	CurrentDebugFrameData.AddGuardString(GuardString);
	return;
}

function AddDefaultInventory(Pawn inPlayerPawn)
{
	local OfficerLoadOut LoadOut;
	local SwatPlayer PlayerPawn;
	local SwatRepoPlayerItem RepoPlayerItem;
	local NetPlayer theNetPlayer;
	local int i;
	local DynamicLoadOutSpec LoadOutSpec;

	Log(Concat_StrStr("In SwatGameInfo::AddDefaultInventory(). Pawn=", string(inPlayerPawn)));
	PlayerPawn = SwatPlayer(inPlayerPawn);
	assert(NotEqual_ObjectObject(PlayerPawn, none));
	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
	{
		if(Level.IsTraining)
		{
			LoadOut = Spawn(Class'SwatGame.OfficerLoadOut', PlayerPawn, 'TrainingLoadOut');
			LoadOutSpec = none;
		}
		else
		{
			LoadOut = Spawn(Class'SwatGame.OfficerLoadOut', PlayerPawn, 'DefaultPlayerLoadOut');
			LoadOutSpec = Spawn(Class'SwatGame.DynamicLoadOutSpec', PlayerPawn, 'CurrentPlayerLoadOut');
		}
		assert(NotEqual_ObjectObject(LoadOut, none));
	}
	else
	{
		assert(OrOr_BoolBool(EqualEqual_IntInt(int(Level.NetMode), int(NM_DedicatedServer)), EqualEqual_IntInt(int(Level.NetMode), int(NM_ListenServer))));
		theNetPlayer = NetPlayer(inPlayerPawn);
		if(theNetPlayer.IsTheVIP())
		{
			MPLog("...this player is the VIP.");
			assert(EqualEqual_IntInt(NetPlayer(PlayerPawn).GetTeamNumber(), 0));
			LoadOut = Spawn(Class'SwatGame.OfficerLoadOut', PlayerPawn, 'VIPLoadOut');
			LoadOutSpec = Spawn(Class'SwatGame.DynamicLoadOutSpec', none, 'DefaultVIPLoadOut');
			assert(NotEqual_ObjectObject(LoadOutSpec, none));
			i = 0;
			J0x1B0:

			if(Less_IntInt(i, int(25)))
			{
				theNetPlayer.SetPocketItemClass(byte(i), LoadOutSpec.LoadOutSpec[int(byte(i))]);
				AddAdd_PreInt(i);
				// [Loop Continue]
				goto J0x1B0;
			}
			theNetPlayer.SwitchToMesh(theNetPlayer.VIPMesh);
		}
		else
		{
			MPLog("...this player is NOT the VIP.");
			if(EqualEqual_IntInt(NetPlayer(PlayerPawn).GetTeamNumber(), 0))
			{
				LoadOut = Spawn(Class'SwatGame.OfficerLoadOut', PlayerPawn, 'EmptyMultiplayerOfficerLoadOut');
			}
			else
			{
				LoadOut = Spawn(Class'SwatGame.OfficerLoadOut', PlayerPawn, 'EmptyMultiplayerSuspectLoadOut');
			}
			Log(Concat_StrStr("...In AddDefaultInventory(): loadout's owner=", string(LoadOut.Owner)));
			assert(NotEqual_ObjectObject(LoadOut, none));
			RepoPlayerItem = SwatGamePlayerController(PlayerPawn.Controller).SwatRepoPlayerItem;
			i = 0;
			J0x300:

			if(Less_IntInt(i, int(25)))
			{
				theNetPlayer.SetPocketItemClass(byte(i), RepoPlayerItem.RepoLoadOutSpec[int(byte(i))]);
				AddAdd_PreInt(i);
				// [Loop Continue]
				goto J0x300;
			}
			LoadOutSpec = theNetPlayer.GetLoadoutSpec();
		}
	}
	LoadOut.Initialize(LoadOutSpec);
	PlayerPawn.ReceiveLoadOut(LoadOut);
	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
	{
		theNetPlayer.InitializeReplicatedCounts();
	}
	SetPlayerDefaults(PlayerPawn);
	return;
}

exec function MissionStatus()
{
	local int i;
	local Objective CurrentObjective;

	Log("[MISSION STATUS]");
	i = 0;
	J0x1B:

	if(Less_IntInt(i, Repo.MissionObjectives.Objectives.Length))
	{
		CurrentObjective = Repo.MissionObjectives.Objectives[i];
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("... Objective '", string(CurrentObjective.Name)), "': "), CurrentObjective.Description), ".  Status: "), CurrentObjective.GetStatusString()));
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x1B;
	}
	return;
}

exec function int LeadershipStatus()
{
	local int i, Score;
	local Procedure CurrentProcedure;

	Log("[LEADERSHIP STATUS]");
	i = 0;
	J0x1E:

	if(Less_IntInt(i, Repo.Procedures.Procedures.Length))
	{
		CurrentProcedure = Repo.Procedures.Procedures[i];
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("... Procedure '", string(CurrentProcedure.Name)), "': "), CurrentProcedure.Description), ".  Status: "), CurrentProcedure.Status()));
		AddEqual_IntInt(Score, CurrentProcedure.GetCurrentValue());
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x1E;
	}
	Score = Max(0, Score);
	Log(Concat_StrStr("-> Mission Score: ", string(Score)));
	return Score;
	return;
}

function NavigationPoint FindPlayerStart(Controller Player, optional byte InTeam, optional string incomingName)
{
	local PlayerStart PointToUse;
	local SwatStartPointBase.EEntryType DesiredEntryType;
	local int IndexOfFirstCheckedPoint;

	Log("SwatGameInfo.FindPlayerStart() ");
	if(Level.IsCOOPServer)
	{
		DesiredEntryType = 0;
	}
	else
	{
		DesiredEntryType = Repo.GetDesiredEntryPoint();
	}
	IndexOfFirstCheckedPoint = NextPlayerStartPoint;
	PointToUse = PlayerStartArray[IndexOfFirstCheckedPoint];
	J0x71:

	if(OrOr_BoolBool(OrOr_BoolBool(Greater_IntInt(PointToUse.Touching.Length, 0), Not_PreBool(PointToUse.IsA('SwatPlayerStart'))), AndAnd_BoolBool(OrOr_BoolBool(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)), Level.IsCOOPServer), NotEqual_IntInt(int(SwatPlayerStart(PointToUse).EntryType), int(DesiredEntryType)))))
	{
		if(Greater_IntInt(PointToUse.Touching.Length, 0))
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(" FindPlayerStart(): Skipping ", string(PointToUse)), " because it is touching "), string(PointToUse.Touching.Length)), " actors"));
		}
		else
		{
			if(Not_PreBool(PointToUse.IsA('SwatPlayerStart')))
			{
				Log(Concat_StrStr(Concat_StrStr(" FindPlayerStart(): Skipping ", string(PointToUse)), " because it is not of class SwatPlayerStart"));
			}
			else
			{
				if(AndAnd_BoolBool(OrOr_BoolBool(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)), Level.IsCOOPServer), NotEqual_IntInt(int(SwatPlayerStart(PointToUse).EntryType), int(DesiredEntryType))))
				{
					Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(" FindPlayerStart(): Skipping ", string(PointToUse)), " because we're in a single-player or coop game and its entry type ("), string(GetEnum(Enum'SwatGame.SwatStartPointBase.EEntryType', int(SwatPlayerStart(PointToUse).EntryType)))), ") does not match the desired entry type ("), string(GetEnum(Enum'SwatGame.SwatStartPointBase.EEntryType', int(DesiredEntryType)))), ")"));
				}
			}
		}
		NextPlayerStartPoint = Add_IntInt(NextPlayerStartPoint, 1);
		if(EqualEqual_IntInt(NextPlayerStartPoint, PlayerStartArray.Length))
		{
			NextPlayerStartPoint = 0;
		}
		if(EqualEqual_IntInt(NextPlayerStartPoint, IndexOfFirstCheckedPoint))
		{
			PointToUse = none;
			// [Explicit Break]
			goto J0x360;
		}
		else
		{
			PointToUse = PlayerStartArray[NextPlayerStartPoint];
		}
		// [Loop Continue]
		goto J0x71;
	}
	J0x360:

	NextPlayerStartPoint = Add_IntInt(NextPlayerStartPoint, 1);
	if(EqualEqual_IntInt(NextPlayerStartPoint, PlayerStartArray.Length))
	{
		NextPlayerStartPoint = 0;
	}
	AssertWithDescription(NotEqual_ObjectObject(PointToUse, none), "Failed to find any usable SwatPlayerStart points!");
	Log(Concat_StrStr(" FindPlayerStart(): returning  ", string(PointToUse)));
	return PointToUse;
	return;
}

function float RatePlayerStart(NavigationPoint n, byte Team, Controller Player)
{
	local PlayerStart P;
	local float Score;

	P = PlayerStart(n);
	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
	{
		Log(Concat_StrStr("SwatGameInfo.RatePlayerStart() rating NavigationPoint ", string(n)));
	}
	if(OrOr_BoolBool(OrOr_BoolBool(OrOr_BoolBool(EqualEqual_ObjectObject(P, none), Not_PreBool(P.bEnabled)), P.PhysicsVolume.bWaterVolume), AndAnd_BoolBool(OrOr_BoolBool(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)), Level.IsCOOPServer), Not_PreBool(P.bSinglePlayerStart))))
	{
		return -1000.0000000;
	}
	Log("   Base Rating is 1000");
	Score = 1000.0000000;
	if(GreaterEqual_FloatFloat(P.TimeOfLastSpawn, float(0)))
	{
		SubtractEqual_FloatFloat(Score, float(Max(int(Subtract_FloatFloat(Level.TimeSeconds, P.TimeOfLastSpawn)), 0)));
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("   Decreasing base to ", string(Score)), " because someone spawned here "), string(Subtract_FloatFloat(Level.TimeSeconds, P.TimeOfLastSpawn))), " seconds ago ("), string(Level.TimeSeconds)), "-"), string(P.TimeOfLastSpawn)), ")"));
	}
	Score = FMax(Score, 1.0000000);
	Log(Concat_StrStr(Concat_StrStr("   Final rating is ", string(Score)), " after clamping to minimum of 1"));
	return Score;
	return;
}

function SetStartClustersForRoundStart()
{
	assert(EqualEqual_IntInt(int(Role), int(ROLE_Authority)));
	GameMode.SetStartClustersForRoundStart();
	return;
}

function AssignPlayerRoles()
{
	assert(EqualEqual_IntInt(int(Role), int(ROLE_Authority)));
	GameMode.AssignPlayerRoles();
	return;
}

exec function RespawnAll()
{
	assert(EqualEqual_IntInt(int(Role), int(ROLE_Authority)));
	GameMode.RespawnAll();
	return;
}

function bool AtCapacity(bool bSpectator)
{
	local int MaxPlayerSetting, CurrentPlayers;

	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
	{
		return false;
	}
	MaxPlayerSetting = ServerSettings(Level.CurrentServerSettings).MaxPlayers;
	CurrentPlayers = SwatRepo(Level.GetRepo()).NumberOfRepoPlayerItems();
	return AndAnd_BoolBool(Greater_IntInt(MaxPlayerSetting, 0), GreaterEqual_IntInt(CurrentPlayers, MaxPlayerSetting));
	return;
}

event PlayerController Login(string Portal, string Options, out string Error)
{
	local NavigationPoint StartSpot;
	local PlayerController NewPlayer;
	local Pawn TestPawn;
	local string InName, InAdminName, InPassword, InChecksum, inClass, inCharacter;

	local byte InTeam;
	local Class<Security> MySecurityClass;
	local int InSwatPlayerID, NewSwatPlayerID;
	local SwatRepoPlayerItem theSwatRepoPlayerItem;

	BaseMutator.ModifyLogin(Portal, Options);
	InName = Left(ParseOption(Options, "Name"), 20);
	InTeam = byte(GetIntOption(Options, "Team", 255));
	InAdminName = ParseOption(Options, "AdminName");
	InPassword = ParseOption(Options, "Password");
	InChecksum = ParseOption(Options, "Checksum");
	InSwatPlayerID = GetIntOption(Options, "SwatPlayerID", 0);
	if(AndAnd_BoolBool(EqualEqual_IntInt(InSwatPlayerID, 0), AtCapacity(false)))
	{
		Error = GameMessageClass.default.MaxedOutMessage;
		return none;
	}
	Log(At_StrStr("Login:", InName));
	Log(Concat_StrStr("  SwatPlayerID: ", string(InSwatPlayerID)));
	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
	{
		if(EqualEqual_IntInt(InSwatPlayerID, 0))
		{
			NewSwatPlayerID = Repo.GetNewSwatPlayerID();
			theSwatRepoPlayerItem = Repo.GetRepoPlayerItem(NewSwatPlayerID);
			InTeam = byte(GetAutoJoinTeamID());
			theSwatRepoPlayerItem.SetTeamID(int(InTeam));
		}
		else
		{
			NewSwatPlayerID = InSwatPlayerID;
			theSwatRepoPlayerItem = Repo.GetRepoPlayerItem(NewSwatPlayerID);
			InTeam = byte(theSwatRepoPlayerItem.GetPreferredTeamID());
		}
		theSwatRepoPlayerItem.bConnected = true;
	}
	StartSpot = FindPlayerStart(none, InTeam, Portal);
	if(EqualEqual_ObjectObject(StartSpot, none))
	{
		Error = GameMessageClass.default.FailedPlaceMessage;
		return none;
	}
	if(EqualEqual_ObjectObject(PlayerControllerClass, none))
	{
		PlayerControllerClass = Class<PlayerController>(DynamicLoadObject(PlayerControllerClassName, Class'Core.Class'));
	}
	NewPlayer = Spawn(PlayerControllerClass,,, StartSpot.Location, StartSpot.Rotation);
	if(EqualEqual_ObjectObject(NewPlayer, none))
	{
		Log(Concat_StrStr("Couldn't spawn player controller of class ", string(PlayerControllerClass)));
		Error = GameMessageClass.default.FailedSpawnMessage;
		return none;
	}
	Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("Spawned player ", string(NewPlayer)), " at "), string(StartSpot)));
	NewPlayer.StartSpot = StartSpot;
	SwatGamePlayerController(NewPlayer).SwatPlayerID = NewSwatPlayerID;
	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
	{
		SwatGamePlayerController(NewPlayer).SwatRepoPlayerItem = theSwatRepoPlayerItem;
	}
	if(EqualEqual_ObjectObject(Level.GetLocalPlayerController(), NewPlayer))
	{
		theSwatRepoPlayerItem.LastAdminPassword = SwatRepo(Level.GetRepo()).GuiConfig.AdminPassword;
	}
	Admin.AdminLogin(NewPlayer, theSwatRepoPlayerItem.LastAdminPassword);
	NewPlayer.GameReplicationInfo = GameReplicationInfo;
	MySecurityClass = Class<Security>(DynamicLoadObject(SecurityClass, Class'Core.Class'));
	if(NotEqual_ObjectObject(MySecurityClass, none))
	{
		NewPlayer.PlayerSecurity = Spawn(MySecurityClass, NewPlayer);
		if(EqualEqual_ObjectObject(NewPlayer.PlayerSecurity, none))
		{
			Log(Concat_StrStr("Could not spawn security for player ", string(NewPlayer)), 'Security');
		}
	}
	else
	{
		Log(Concat_StrStr(Concat_StrStr("Unknown security class [", SecurityClass), "] -- System is no secure."), 'Security');
	}
	if(EqualEqual_StrStr(InName, ""))
	{
		InName = DefaultPlayerName;
	}
	if(OrOr_BoolBool(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)), EqualEqual_StrStr(NewPlayer.PlayerReplicationInfo.PlayerName, DefaultPlayerName)))
	{
		SwatGamePlayerController(NewPlayer).SetName(InName);
	}
	NewPlayer.StartSpot = StartSpot;
	NewPlayer.PlayerReplicationInfo.PlayerID = AddAdd_Int(CurrentID);
	SwatPlayerReplicationInfo(NewPlayer.PlayerReplicationInfo).SwatPlayerID = NewSwatPlayerID;
	SwatPlayerReplicationInfo(NewPlayer.PlayerReplicationInfo).COOPPlayerStatus = 0;
	inClass = ParseOption(Options, "Class");
	if(EqualEqual_StrStr(inClass, ""))
	{
		inClass = DefaultPlayerClassName;
	}
	inCharacter = ParseOption(Options, "Character");
	NewPlayer.SetPawnClass(inClass, inCharacter);
	AddAdd_Int(NumPlayers);
	bWelcomePending = true;
	SetPlayerTeam(SwatGamePlayerController(NewPlayer), int(InTeam));
	if(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
	{
		if(AndAnd_BoolBool(bDelayedStart, Not_PreBool(SwatGamePlayerController(NewPlayer).IsAReconnectingClient())))
		{
			NewPlayer.GotoState('NetPlayerLimbo');
			return NewPlayer;
		}
	}
	foreach DynamicActors(Class'Engine.Pawn', TestPawn)
	{
		if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(TestPawn, none), NotEqual_ObjectObject(PlayerController(TestPawn.Controller), none)), EqualEqual_ObjectObject(PlayerController(TestPawn.Controller).Player, none)), Greater_IntInt(TestPawn.Health, 0)), ComplementEqual_StrStr(TestPawn.OwnerName, InName)))
		{
			NewPlayer.Destroy();
			TestPawn.SetRotation(TestPawn.Controller.Rotation);
			TestPawn.bInitializeAnimation = false;
			TestPawn.PlayWaiting();
			return PlayerController(TestPawn.Controller);
		}
	}
	TestWaitingForPlayersToReconnect();
	return NewPlayer;
	return;
}

event PostLogin(PlayerController NewPlayer)
{
	local Class<HUD> HudClass;
	local Class<ScoreBoard> ScoreboardClass;
	local string SongName;

	if(NotEqual_ObjectObject(GameStats, none))
	{
		GameStats.ConnectEvent(NewPlayer.PlayerReplicationInfo);
		GameStats.GameEvent("NameChange", NewPlayer.PlayerReplicationInfo.PlayerName, NewPlayer.PlayerReplicationInfo);
	}
	if(Not_PreBool(bDelayedStart))
	{
		bRestartLevel = false;
		bKeepSamePlayerStart = true;
		if(bWaitingToStartMatch)
		{
			StartMatch();
		}
		else
		{
			RestartPlayer(NewPlayer);
		}
		bKeepSamePlayerStart = false;
		bRestartLevel = default.bRestartLevel;
	}
	SongName = Level.Song;
	if(AndAnd_BoolBool(NotEqual_StrStr(SongName, ""), NotEqual_StrStr(SongName, "None")))
	{
		NewPlayer.ClientSetMusic(SongName, 3);
	}
	if(NotEqual_StrStr(HUDType, ""))
	{
		HudClass = Class<HUD>(DynamicLoadObject(HUDType, Class'Core.Class'));
	}
	if(NotEqual_StrStr(ScoreBoardType, ""))
	{
		ScoreboardClass = Class<ScoreBoard>(DynamicLoadObject(ScoreBoardType, Class'Core.Class'));
	}
	NewPlayer.ClientSetHUD(HudClass, ScoreboardClass);
	if(NotEqual_ObjectObject(NewPlayer.Pawn, none))
	{
		NewPlayer.Pawn.ClientSetRotation(NewPlayer.Pawn.Rotation);
	}
	PlayerLoggedIn(NewPlayer);
	return;
}

function PlayerLoggedIn(PlayerController NewPlayer)
{
	local SwatGamePlayerController PC;

	Log(Concat_StrStr("[dkaplan] >>>  PlayerLoggedIn(), NewPlayer = ", string(NewPlayer)));
	Log(Concat_StrStr("[dkaplan]    ...  Level.GetLocalPlayerController() = ", string(Level.GetLocalPlayerController())));
	Log(Concat_StrStr("[dkaplan]    ...  Repo.GuiConfig.SwatGameState = ", string(Repo.GuiConfig.SwatGameState)));
	PC = SwatGamePlayerController(NewPlayer);
	if(NotEqual_ObjectObject(PC, none))
	{
		if(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
		{
			Log(Concat_StrStr("[dkaplan]    ...  SwatGamePlayerController(NewPlayer).IsAReconnectingClient() = ", string(PC.IsAReconnectingClient())));
		}
		if(Level.IsCOOPServer)
		{
			PrecacheOnClient(PC);
		}
		if(OrOr_BoolBool(OrOr_BoolBool(EqualEqual_ObjectObject(NewPlayer, Level.GetLocalPlayerController()), EqualEqual_IntInt(int(Repo.GuiConfig.SwatGameState), int(3))), AndAnd_BoolBool(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)), Not_PreBool(PC.IsAReconnectingClient()))))
		{
			PC.ClientOnLoggedIn();
			if(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
			{
				if(Not_PreBool(PC.IsAReconnectingClient()))
				{
					Broadcast(NewPlayer, NewPlayer.PlayerReplicationInfo.PlayerName, 'PlayerConnect');
				}
			}
		}
		else
		{
			if(EqualEqual_IntInt(int(Repo.GuiConfig.SwatGameState), int(4)))
			{
				PC.ClientOnLoggedIn();
				PlayerLateStart(PC);
			}
			else
			{
				if(EqualEqual_IntInt(int(Repo.GuiConfig.SwatGameState), int(5)))
				{
					PC.ClientOnLoggedIn();
					PC.ClientRoundStarted();
					PC.ClientGameEnded();
				}
			}
		}
	}
	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
	{
		SpawnOfficers();
	}
	Log(Concat_StrStr("[dkaplan] <<<  PlayerLoggedIn(), NewPlayer = ", string(NewPlayer)));
	return;
}

function Logout(Controller Exiting)
{
	local SwatGamePlayerController SGPC;

	MPLog(Concat_StrStr("---SwatGameInfo::Logout(). ControllerLeaving=", string(Exiting)));
	SGPC = SwatGamePlayerController(Exiting);
	if(AndAnd_BoolBool(NotEqual_ObjectObject(SGPC, none), NotEqual_ObjectObject(SGPC.SwatPlayer, none)))
	{
		Broadcast(SGPC, SGPC.PlayerReplicationInfo.PlayerName, 'PlayerDisconnect');
		Repo.Logout(SGPC);
		MPLog("......triggering game event.");
		GameEvents.PlayerDied.Triggered(SGPC, SGPC);
	}
	TestWaitingForPlayersToReconnect();
	super.Logout(Exiting);
	return;
}

private function bool ShouldSpawnOfficerRedOne()
{
	return OrOr_BoolBool(EqualEqual_ObjectObject(Repo.GuiConfig.CurrentMission.CustomScenario, none), Repo.GuiConfig.CurrentMission.CustomScenario.HasOfficerRedOne);
	return;
}

private function bool ShouldSpawnOfficerRedTwo()
{
	return OrOr_BoolBool(EqualEqual_ObjectObject(Repo.GuiConfig.CurrentMission.CustomScenario, none), Repo.GuiConfig.CurrentMission.CustomScenario.HasOfficerRedTwo);
	return;
}

private function bool ShouldSpawnOfficerBlueOne()
{
	return OrOr_BoolBool(EqualEqual_ObjectObject(Repo.GuiConfig.CurrentMission.CustomScenario, none), Repo.GuiConfig.CurrentMission.CustomScenario.HasOfficerBlueOne);
	return;
}

private function bool ShouldSpawnOfficerBlueTwo()
{
	return OrOr_BoolBool(EqualEqual_ObjectObject(Repo.GuiConfig.CurrentMission.CustomScenario, none), Repo.GuiConfig.CurrentMission.CustomScenario.HasOfficerBlueTwo);
	return;
}

private function bool ShouldSpawnOfficerAtStart(SwatOfficerStart OfficerStart, SwatStartPointBase.EEntryType DesiredEntryType)
{
	assert(NotEqual_ObjectObject(OfficerStart, none));
	if(EqualEqual_IntInt(int(OfficerStart.EntryType), int(DesiredEntryType)))
	{
		switch(OfficerStart.OfficerStartType)
		{
			case 0:
				return ShouldSpawnOfficerRedOne();
			case 1:
				return ShouldSpawnOfficerRedTwo();
			case 2:
				return ShouldSpawnOfficerBlueOne();
			case 3:
				return ShouldSpawnOfficerBlueTwo();
			default:
				break;
			}
	}
	else
	{
		return false;
		return;
	}
}

private function SpawnOfficers()
{
	local int i;
	local NavigationPoint Iter;
	local SwatStartPointBase.EEntryType DesiredEntryType;
	local SwatOfficerStart OfficerStart;
	local array<SwatOfficerStart> OfficerSpawnPoints;

	DesiredEntryType = Repo.GetDesiredEntryPoint();
	NumSpawnedOfficers = 0;
	Log("SPAWNING OFFICERS:");
	Iter = Level.NavigationPointList;
	J0x46:

	if(NotEqual_ObjectObject(Iter, none))
	{
		if(Iter.IsA('SwatStartPointBase'))
		{
			if(Iter.IsA('SwatOfficerStart'))
			{
				OfficerStart = SwatOfficerStart(Iter);
				if(ShouldSpawnOfficerAtStart(OfficerStart, DesiredEntryType))
				{
					Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("  Will *Spawn* officer at ", string(OfficerStart)), " with entry type "), string(GetEnum(Enum'SwatGame.SwatStartPointBase.EEntryType', int(DesiredEntryType)))));
					OfficerSpawnPoints[int(OfficerStart.OfficerStartType)] = OfficerStart;
					AddAdd_PreInt(NumSpawnedOfficers);
				}
				else
				{
					Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("  Not spawning officer at ", string(OfficerStart)), " because its entry type ("), string(GetEnum(Enum'SwatGame.SwatStartPointBase.EEntryType', int(OfficerStart.EntryType)))), ") doesn't match desired entry "), string(GetEnum(Enum'SwatGame.SwatStartPointBase.EEntryType', int(DesiredEntryType)))), ")"));
				}
			}
			else
			{
				Log(Concat_StrStr(Concat_StrStr("  Not spawning officer at ", string(Iter)), " because it is not a SwatOfficerStart"));
			}
		}
		Iter = Iter.nextNavigationPoint;
		// [Loop Continue]
		goto J0x46;
	}
	i = 0;
	J0x225:

	if(Less_IntInt(i, OfficerSpawnPoints.Length))
	{
		if(NotEqual_ObjectObject(OfficerSpawnPoints[i], none))
		{
			OfficerSpawnPoints[i].SpawnOfficer();
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x225;
	}
	Log(Concat_StrStr("  TOTAL OFFICERS SPAWNED: ", string(NumSpawnedOfficers)));
	return;
}

function int GetNumSpawnedOfficers()
{
	return NumSpawnedOfficers;
	return;
}

function RestartPlayer(Controller aPlayer)
{
	local NavigationPoint StartSpot;
	local SwatMPStartPoint MPStartSpot;
	local int TeamNum;

	MPLog(Concat_StrStr("---SwatGameInfo::RestartPlayer(). PlayerController=", string(aPlayer)));
	if(AndAnd_BoolBool(AndAnd_BoolBool(bRestartLevel, NotEqual_IntInt(int(Level.NetMode), int(NM_DedicatedServer))), NotEqual_IntInt(int(Level.NetMode), int(NM_ListenServer))))
	{
		MPLog("...1");
		return;
	}
	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
	{
		if(OrOr_BoolBool(EqualEqual_ObjectObject(aPlayer.PlayerReplicationInfo, none), EqualEqual_ObjectObject(aPlayer.PlayerReplicationInfo.Team, none)))
		{
			TeamNum = 255;
		}
		else
		{
			TeamNum = aPlayer.PlayerReplicationInfo.Team.TeamIndex;
		}
		StartSpot = SpawnPlayerPawn(aPlayer, TeamNum);
		if(EqualEqual_ObjectObject(StartSpot, none))
		{
			Log(" Player pawn start not found!!!");
			return;
		}
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("Setting TimeOfLastSpawn to ", string(Level.TimeSeconds)), " for "), string(StartSpot)));
		StartSpot.TimeOfLastSpawn = Level.TimeSeconds;
		aPlayer.Pawn.Anchor = StartSpot;
		aPlayer.Pawn.LastStartSpot = PlayerStart(StartSpot);
		aPlayer.Pawn.LastStartTime = Level.TimeSeconds;
		aPlayer.PreviousPawnClass = aPlayer.Pawn.Class;
		aPlayer.Possess(aPlayer.Pawn);
		aPlayer.PawnClass = aPlayer.Pawn.Class;
		aPlayer.Pawn.PlayTeleportEffect(true, true);
		aPlayer.ClientSetRotation(aPlayer.Pawn.Rotation);
		AddDefaultInventory(aPlayer.Pawn);
		TriggerEvent(StartSpot.Event, StartSpot, aPlayer.Pawn);
	}
	else
	{
		MPStartSpot = SpawnNetPlayerPawn(aPlayer);
		if(EqualEqual_ObjectObject(MPStartSpot, none))
		{
			Log("...Net player pawn start not found!!! returning from RestartPlayer()...");
			return;
		}
		NetPlayer(aPlayer.Pawn).SwatPlayerID = SwatGamePlayerController(aPlayer).SwatPlayerID;
		if(SwatGamePlayerController(aPlayer).ThisPlayerIsTheVIP)
		{
			MPLog("...setting that the player is the VIP");
			NetPlayer(aPlayer.Pawn).SetIsVIP();
		}
		aPlayer.Pawn.LastStartTime = Level.TimeSeconds;
		aPlayer.PreviousPawnClass = aPlayer.Pawn.Class;
		MPLog("...about to Possess the pawn.");
		MPLog(Concat_StrStr("......controller=", string(aPlayer)));
		MPLog(Concat_StrStr("......pawn=", string(aPlayer.Pawn)));
		aPlayer.Possess(aPlayer.Pawn);
		aPlayer.PawnClass = aPlayer.Pawn.Class;
		aPlayer.Pawn.PlayTeleportEffect(true, true);
		aPlayer.ClientSetRotation(aPlayer.Pawn.Rotation);
		AddDefaultInventory(aPlayer.Pawn);
		TriggerEvent(MPStartSpot.Event, MPStartSpot, aPlayer.Pawn);
		SwatPlayerReplicationInfo(aPlayer.PlayerReplicationInfo).COOPPlayerStatus = 2;
	}
	MPLog("...Leaving RestartPlayer().");
	return;
}

function SwatMPStartPoint SpawnNetPlayerPawn(Controller aPlayer)
{
	local Class<Pawn> DefaultPlayerClass;
	local SwatMPStartPoint StartSpot;
	local bool SuccessfullySpawned;

	MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("In SwatGameInfo::SpawnNetPlayerPawn(). Controller=", string(aPlayer)), ", aPlayer.PlayerReplicationInfo="), string(aPlayer.PlayerReplicationInfo)), ", aPlayer.PlayerReplicationInfo.Team="), string(aPlayer.PlayerReplicationInfo.Team)));
	if(AndAnd_BoolBool(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)), NotEqual_ObjectObject(aPlayer.PlayerReplicationInfo.Team, none)))
	{
		aPlayer.PawnClass = aPlayer.PlayerReplicationInfo.Team.DefaultPlayerClass;
	}
	if(AndAnd_BoolBool(NotEqual_ObjectObject(aPlayer.PreviousPawnClass, none), NotEqual_ObjectObject(aPlayer.PawnClass, aPlayer.PreviousPawnClass)))
	{
		BaseMutator.PlayerChangedClass(aPlayer);
	}
	SuccessfullySpawned = false;
	J0x177:

	if(Not_PreBool(SuccessfullySpawned))
	{
		StartSpot = GameMode.FindNetPlayerStart(aPlayer);
		MPLog(Concat_StrStr("...startSpot=", string(StartSpot)));
		if(EqualEqual_ObjectObject(StartSpot, none))
		{
			// [Explicit Break]
			goto J0x2EB;
		}
		if(NotEqual_ObjectObject(aPlayer.PawnClass, none))
		{
			MPLog("...1");
			aPlayer.Pawn = Spawn(aPlayer.PawnClass,, 'Player', StartSpot.Location, StartSpot.Rotation);
		}
		if(EqualEqual_ObjectObject(aPlayer.Pawn, none))
		{
			MPLog("...2");
			DefaultPlayerClass = GetDefaultPlayerClass(aPlayer);
			aPlayer.Pawn = Spawn(DefaultPlayerClass,, 'Player', StartSpot.Location, StartSpot.Rotation);
		}
		if(NotEqual_ObjectObject(aPlayer.Pawn, none))
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("Spawned *pawn* for player ", string(aPlayer)), " at "), string(StartSpot)));
			SuccessfullySpawned = true;
		}
		// [Loop Continue]
		goto J0x177;
	}
	J0x2EB:

	if(EqualEqual_ObjectObject(StartSpot, none))
	{
		Log(Concat_StrStr(Concat_StrStr("Couldn't spawn pawn of class for player ", string(aPlayer)), " because we ran out of start spots."));
		AssertWithDescription(false, Concat_StrStr(Concat_StrStr("Couldn't spawn pawn for player ", string(aPlayer)), " because we ran out of start spots."));
		Log("...sending controller to state Dead");
		aPlayer.GotoState('Dead');
	}
	return StartSpot;
	return;
}

function NetTeam GetTeamFromID(int TeamID)
{
	return NetTeam(GameReplicationInfo.Teams[TeamID]);
	return;
}

event Broadcast(Actor Sender, coerce string msg, optional name Type)
{
	BroadcastHandler.Broadcast(Sender, msg, Type);
	return;
}

function BroadcastTeam(Controller Sender, coerce string msg, optional name Type)
{
	if(OrOr_BoolBool(Sender.IsInState('ObserveTeam'), Sender.IsInState('Dead')))
	{
		BroadcastObservers(Sender, msg, Type);
	}
	BroadcastHandler.BroadcastTeam(Sender, msg, Type);
	return;
}

function BroadcastObservers(Controller Sender, coerce string msg, optional name Type)
{
	local Controller C;
	local PlayerController P;

	if(Not_PreBool(BroadcastHandler.AllowsBroadcast(Sender, Len(msg))))
	{
		return;
	}
	if(NotEqual_ObjectObject(Sender, none))
	{
		C = Level.ControllerList;
		J0x41:

		if(NotEqual_ObjectObject(C, none))
		{
			P = PlayerController(C);
			if(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(P, none), EqualEqual_ObjectObject(P.PlayerReplicationInfo.Team, Sender.PlayerReplicationInfo.Team)), OrOr_BoolBool(P.IsInState('ObserveTeam'), P.IsInState('Dead'))))
			{
				P.TeamMessage(Sender.PlayerReplicationInfo, msg, Type);
			}
			C = C.nextController;
			// [Loop Continue]
			goto J0x41;
		}
	}
	return;
}

function BroadcastDeathMessage(Controller Killer, Controller Other, Class<DamageType> DamageType)
{
	local string KillerName, VictimName, WeaponName;
	local int VictimTeam, KillerTeam;
	local SwatPlayer OtherPlayer;

	if(EqualEqual_ObjectObject(DamageType, Class'Engine.GenericDamageType'))
	{
		return;
	}
	KillerName = Killer.GetHumanReadableName();
	VictimName = Other.GetHumanReadableName();
	WeaponName = DamageType.static.GetFriendlyName();
	if(NotEqual_ObjectObject(NetPlayer(Killer.Pawn), none))
	{
		KillerTeam = NetPlayer(Killer.Pawn).GetTeamNumber();
	}
	if(NotEqual_ObjectObject(NetPlayer(Other.Pawn), none))
	{
		VictimTeam = NetPlayer(Other.Pawn).GetTeamNumber();
	}
	OtherPlayer = SwatPlayer(Other.Pawn);
	if(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(OtherPlayer, none), Not_PreBool(OtherPlayer.IsTheVIP())), OtherPlayer.IsArrested()))
	{
		return;
	}
	if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(Other.IsA('PlayerController'), NotEqual_ObjectObject(NetPlayer(Other.Pawn), none)), Killer.IsA('PlayerController')), NotEqual_ObjectObject(NetPlayer(Killer.Pawn), none)))
	{
		if(OrOr_BoolBool(EqualEqual_ObjectObject(Killer, Other), EqualEqual_ObjectObject(Killer, none)))
		{
			if(EqualEqual_IntInt(KillerTeam, 0))
			{
				Broadcast(Other, VictimName, 'SwatSuicide');
			}
			else
			{
				Broadcast(Other, VictimName, 'SuspectsSuicide');
			}
		}
		else
		{
			if(EqualEqual_IntInt(KillerTeam, VictimTeam))
			{
				if(EqualEqual_IntInt(KillerTeam, 0))
				{
					Broadcast(Other, Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(KillerName, "	"), VictimName), "	"), WeaponName), 'SwatTeamKill');
				}
				else
				{
					Broadcast(Other, Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(KillerName, "	"), VictimName), "	"), WeaponName), 'SuspectsTeamKill');
				}
			}
			else
			{
				if(EqualEqual_IntInt(KillerTeam, 0))
				{
					Broadcast(Other, Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(KillerName, "	"), VictimName), "	"), WeaponName), 'SwatKill');
				}
				else
				{
					Broadcast(Other, Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(KillerName, "	"), VictimName), "	"), WeaponName), 'SuspectsKill');
				}
			}
		}
	}
	else
	{
		Broadcast(Other, Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(KillerName, "	"), VictimName), "	"), WeaponName), 'AIDeath');
	}
	return;
}

function BroadcastArrestedMessage(Controller Killer, Controller Other)
{
	local string KillerName, VictimName;
	local int VictimTeam;

	KillerName = Killer.Pawn.GetHumanReadableName();
	VictimName = Other.Pawn.GetHumanReadableName();
	VictimTeam = NetPlayer(Other.Pawn).GetTeamNumber();
	AssertWithDescription(NotEqual_ObjectObject(Killer, Other), Concat_StrStr(KillerName, " somehow arrested himself.  That really shouldn't ever happen!"));
	if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(Other.IsA('PlayerController'), NotEqual_ObjectObject(NetPlayer(Other.Pawn), none)), Killer.IsA('PlayerController')), NotEqual_ObjectObject(NetPlayer(Killer.Pawn), none)))
	{
		if(EqualEqual_IntInt(VictimTeam, 1))
		{
			Broadcast(Other, Concat_StrStr(Concat_StrStr(KillerName, "	"), VictimName), 'SwatArrest');
		}
		else
		{
			Broadcast(Other, Concat_StrStr(Concat_StrStr(KillerName, "	"), VictimName), 'SuspectsArrest');
		}
	}
	return;
}

function Killed(Controller Killer, Controller Killed, Pawn KilledPawn, Class<DamageType> DamageType)
{
	super.Killed(Killer, Killed, KilledPawn, DamageType);
	SwatPlayerReplicationInfo(Killed.PlayerReplicationInfo).COOPPlayerStatus = 4;
	return;
}

function SetPlayerTeam(SwatGamePlayerController Player, int TeamID)
{
	local TeamInfo CurrentTeam, NewTeam;

	Player.SwatRepoPlayerItem.SetPreferredTeamID(TeamID);
	if(Level.IsCOOPServer)
	{
		TeamID = 0;
	}
	CurrentTeam = Player.PlayerReplicationInfo.Team;
	if(OrOr_BoolBool(EqualEqual_IntInt(TeamID, 0), EqualEqual_IntInt(TeamID, 1)))
	{
		NewTeam = GameReplicationInfo.Teams[TeamID];
	}
	Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self), "::SetPlayerTeam( "), string(Player)), ", "), string(TeamID)), " ) ... CurrentTeam = "), string(CurrentTeam)), ", NewTeam = "), string(NewTeam)));
	if(AndAnd_BoolBool(NotEqual_ObjectObject(NewTeam, none), NotEqual_ObjectObject(CurrentTeam, NewTeam)))
	{
		if(NotEqual_ObjectObject(CurrentTeam, none))
		{
			CurrentTeam.RemoveFromTeam(Player);
		}
		if(NotEqual_ObjectObject(Player.Pawn, none))
		{
			Player.Pawn.Died(none, Class'Engine.GenericDamageType', Player.Pawn.Location, vect(0.0000000, 0.0000000, 0.0000000));
		}
		NewTeam.AddToTeam(Player);
		Repo.GetRepoPlayerItem(Player.SwatPlayerID).SetTeamID(TeamID);
		GetGameMode().PlayerJoinedTeam(Player, TeamID);
	}
	return;
}

function AutoSetPlayerTeam(SwatGamePlayerController Player)
{
	return;
}

function int GetAutoJoinTeamID()
{
	local int i, lowestTeamID, lowestTeamSize;

	if(OrOr_BoolBool(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)), Level.IsCOOPServer))
	{
		return 0;
	}
	lowestTeamID = 0;
	lowestTeamSize = GameReplicationInfo.Teams[lowestTeamID].Size;
	i = 1;
	J0x60:

	if(Less_IntInt(i, 2))
	{
		if(Less_IntInt(GameReplicationInfo.Teams[i].Size, lowestTeamSize))
		{
			lowestTeamID = i;
			lowestTeamSize = GameReplicationInfo.Teams[i].Size;
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x60;
	}
	return lowestTeamID;
	return;
}

function ChangePlayerTeam(SwatGamePlayerController Player)
{
	local int CurrentTeam, NewTeam;
	local SwatRepoPlayerItem RepoItem;

	RepoItem = Repo.GetRepoPlayerItem(Player.SwatPlayerID);
	CurrentTeam = RepoItem.GetTeamID();
	if(EqualEqual_IntInt(CurrentTeam, 0))
	{
		NewTeam = 1;
	}
	else
	{
		NewTeam = 0;
	}
	SetPlayerTeam(Player, NewTeam);
	if(EqualEqual_IntInt(int(Repo.GuiConfig.SwatGameState), int(4)))
	{
		Broadcast(Player, Player.PlayerReplicationInfo.PlayerName, 'SwitchTeams');
	}
	return;
}

function SetPlayerReady(SwatGamePlayerController Player)
{
	Log("[dkaplan] >>> SetPlayerReady()");
	if(Not_PreBool(SwatPlayerReplicationInfo(Player.PlayerReplicationInfo).GetPlayerIsReady()))
	{
		TogglePlayerReady(Player);
	}
	return;
}

function SetPlayerNotReady(SwatGamePlayerController Player)
{
	Log("[dkaplan] >>> SetPlayerNotReady()");
	if(SwatPlayerReplicationInfo(Player.PlayerReplicationInfo).GetPlayerIsReady())
	{
		TogglePlayerReady(Player);
	}
	return;
}

function TogglePlayerReady(SwatGamePlayerController Player)
{
	Log(Concat_StrStr("[dkaplan] >>> TogglePlayerReady(): Player.HasEnteredFirstRoundOfNetworkGame() = ", string(Player.HasEnteredFirstRoundOfNetworkGame())));
	if(EqualEqual_IntInt(int(SwatPlayerReplicationInfo(Player.PlayerReplicationInfo).COOPPlayerStatus), int(0)))
	{
		SwatPlayerReplicationInfo(Player.PlayerReplicationInfo).COOPPlayerStatus = 1;
	}
	SwatPlayerReplicationInfo(Player.PlayerReplicationInfo).TogglePlayerIsReady();
	if(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(Player, Level.GetLocalPlayerController()), Not_PreBool(Player.HasEnteredFirstRoundOfNetworkGame())), Not_PreBool(bChangingLevels)))
	{
		if(EqualEqual_IntInt(int(Repo.GuiConfig.SwatGameState), int(4)))
		{
			PlayerLateStart(Player);
		}
		else
		{
			if(EqualEqual_IntInt(int(Repo.GuiConfig.SwatGameState), int(5)))
			{
				Player.ClientRoundStarted();
				Player.ClientGameEnded();
			}
		}
	}
	TestWaitingForPlayersToReconnect();
	return;
}

function logPlayerReadyValues()
{
	local SwatGameReplicationInfo SGRI;
	local int i;

	SGRI = SwatGameReplicationInfo(GameReplicationInfo);
	if(EqualEqual_ObjectObject(SGRI, none))
	{
		return;
	}
	Log("The SwatGameReplicationInfo's PRIStaticArray is:");
	i = 0;
	J0x58:

	if(Less_IntInt(i, 16))
	{
		if(EqualEqual_ObjectObject(SGRI.PRIStaticArray[i], none))
		{
			Log(Concat_StrStr(Concat_StrStr("  ...PRIStaticArray[", string(i)), "] = None "));
			// [Explicit Continue]
			goto J0x128;
		}
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("  ...PRIStaticArray[", string(i)), "] = "), string(SGRI.PRIStaticArray[i])), ", PlayerIsReady = "), string(SGRI.PRIStaticArray[i].GetPlayerIsReady())));
		J0x128:

		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x58;
	}
	return;
}

function PlayerLateStart(SwatGamePlayerController Player)
{
	Player.ClientRoundStarted();
	Player.SwatRepoPlayerItem.SetHasEnteredFirstRound();
	Player.ForceObserverCam();
	return;
}

function int NumberOfPlayersForServerBrowser()
{
	return Max(SwatRepo(Level.GetRepo()).NumberOfPlayersWhoShouldReturn(), GetNumPlayers());
	return;
}

function int MaxPlayersForServerBrowser()
{
	return ServerSettings(Level.CurrentServerSettings).MaxPlayers;
	return;
}

function bool GameIsPasswordProtected()
{
	local SwatRepo RepoObj;

	RepoObj = SwatRepo(Level.GetRepo());
	assert(NotEqual_ObjectObject(RepoObj, none));
	if(ServerSettings(Level.CurrentServerSettings).bPassworded)
	{
		return true;
	}
	else
	{
		return false;
	}
	return;
}

function string GetPlayerName(PlayerController PC)
{
	local SwatPlayerReplicationInfo SPRI;

	SPRI = SwatPlayerReplicationInfo(PC.PlayerReplicationInfo);
	if(EqualEqual_ObjectObject(SPRI, none))
	{
		return "";
	}
	return SPRI.PlayerName;
	return;
}

function int GetPlayerScore(PlayerController PC)
{
	local SwatPlayerReplicationInfo SPRI;

	SPRI = SwatPlayerReplicationInfo(PC.PlayerReplicationInfo);
	if(EqualEqual_ObjectObject(SPRI, none))
	{
		return 0;
	}
	return SPRI.NetScoreInfo.GetScore();
	return;
}

function int GetPlayerPing(PlayerController PC)
{
	local SwatPlayerReplicationInfo SPRI;

	SPRI = SwatPlayerReplicationInfo(PC.PlayerReplicationInfo);
	if(EqualEqual_ObjectObject(SPRI, none))
	{
		return 999;
	}
	return SPRI.Ping;
	return;
}

function int ReduceDamage(int Damage, Pawn injured, Pawn InstigatedBy, Vector HitLocation, out Vector Momentum, Class<DamageType> DamageType)
{
	local int ModifiedDamage;
	local float Modifier;

	Modifier = 1.0000000;
	if(AndAnd_BoolBool(Level.IsCOOPServer, ClassIsChildOf(injured.Class, Class'SwatGame.NetPlayer')))
	{
		Modifier = COOPDamageModifier;
	}
	else
	{
		if(AndAnd_BoolBool(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)), OrOr_BoolBool(ClassIsChildOf(injured.Class, Class'SwatGame.SwatPlayer'), ClassIsChildOf(injured.Class, Class'SwatGame.SwatOfficer'))))
		{
			switch(Repo.GuiConfig.CurrentDifficulty)
			{
				case 0:
					Modifier = SPDamageModifierEasy;
					break;
				case 1:
					Modifier = SPDamageModifierNormal;
					break;
				case 2:
					Modifier = SPDamageModifierHard;
					break;
				case 3:
					Modifier = SPDamageModifierElite;
					break;
				default:
					Modifier = 1.0000000;
					AssertWithDescription(false, Concat_StrStr(Concat_StrStr("Invalid setting (", string(Repo.GuiConfig.CurrentDifficulty)), ") for SwatGUIConfig.CurrentDifficulty"));
					break;
			}
		}
		else
		{
			if(ClassIsChildOf(injured.Class, Class'SwatGame.NetPlayer'))
			{
				Modifier = MPDamageModifier;
			}
		}
	}
	ModifiedDamage = int(Multiply_FloatFloat(float(Damage), Modifier));
	if(Level.AnalyzeBallistics)
	{
		if(OrOr_BoolBool(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)), Level.IsCOOPServer))
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[BALLISTICS]   ... SP Difficulty Damage Modifier = ", string(Modifier)), " (difficulty="), string(Repo.GuiConfig.CurrentDifficulty)), ")"));
		}
		else
		{
			Log(Concat_StrStr("[BALLISTICS]   ... MP Difficulty Damage Modifier = ", string(Modifier)));
		}
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[BALLISTICS]   ... Modified Damage = ", string(Damage)), " * "), string(Modifier)), " = "), string(ModifiedDamage)));
	}
	return super.ReduceDamage(ModifiedDamage, injured, InstigatedBy, HitLocation, Momentum, DamageType);
	return;
}

event DetailChange()
{
	local SwatOfficer Officer;

	super.DetailChange();
	foreach DynamicActors(Class'SwatGame.SwatOfficer', Officer)
	{
		Officer.UpdateOfficerLOD();
	}
	return;
}

function PreQuickRoundRestart()
{
	local Controller Controller;
	local SwatGamePlayerController SwatController;

	Controller = Level.ControllerList;
	J0x14:

	if(NotEqual_ObjectObject(Controller, none))
	{
		SwatController = SwatGamePlayerController(Controller);
		if(NotEqual_ObjectObject(SwatController, none))
		{
			SwatController.ClientPreQuickRoundRestart();
		}
		Controller = Controller.nextController;
		// [Loop Continue]
		goto J0x14;
	}
	Log("Server in PreQuickRoundRestart: Collecting garbage.");
	ConsoleCommand("obj garbage");
	return;
}

function OnServerSettingsUpdated(Controller Admin)
{
	Broadcast(Admin, Admin.GetHumanReadableName(), 'SettingsUpdated');
	return;
}

simulated event Destroyed()
{
	__MissionObjectiveTimeExpired__Delegate = None;
	super(Actor).Destroyed();
	return;
}

function SetLevelHasFemaleCharacters()
{
	LevelHasFemaleCharacters = true;
	return;
}

function AddMesh(Mesh inMesh)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, PrecacheMeshes.Length))
	{
		if(EqualEqual_ObjectObject(inMesh, PrecacheMeshes[i]))
		{
			return;
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	PrecacheMeshes[PrecacheMeshes.Length] = inMesh;
	return;
}

function AddMaterial(Material inMaterial)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, PrecacheMaterials.Length))
	{
		if(EqualEqual_ObjectObject(inMaterial, PrecacheMaterials[i]))
		{
			return;
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	PrecacheMaterials[PrecacheMaterials.Length] = inMaterial;
	return;
}

function AddStaticMesh(StaticMesh inStaticMesh)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, PrecacheStaticMeshes.Length))
	{
		if(EqualEqual_ObjectObject(inStaticMesh, PrecacheStaticMeshes[i]))
		{
			return;
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	PrecacheStaticMeshes[PrecacheStaticMeshes.Length] = inStaticMesh;
	return;
}

function PrecacheOnClient(SwatGamePlayerController SGPC)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, PrecacheMaterials.Length))
	{
		SGPC.ClientAddPrecacheableMaterial(Concat_StrStr(Concat_StrStr(string(PrecacheMaterials[i].Outer.Name), "."), string(PrecacheMaterials[i].Name)));
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	i = 0;
	J0x73:

	if(Less_IntInt(i, PrecacheMeshes.Length))
	{
		SGPC.ClientAddPrecacheableMesh(Concat_StrStr(Concat_StrStr(string(PrecacheMeshes[i].Outer.Name), "."), string(PrecacheMeshes[i].Name)));
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x73;
	}
	i = 0;
	J0xDF:

	if(Less_IntInt(i, PrecacheStaticMeshes.Length))
	{
		SGPC.ClientAddPrecacheableStaticMesh(Concat_StrStr(Concat_StrStr(string(PrecacheStaticMeshes[i].Outer.Name), "."), string(PrecacheStaticMeshes[i].Name)));
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0xDF;
	}
	SGPC.ClientPrecacheAll(LevelHasFemaleCharacters);
	return;
}

defaultproperties
{
	SPDamageModifierEasy=0.7500000
	SPDamageModifierNormal=1.0000000
	SPDamageModifierHard=1.2500000
	SPDamageModifierElite=1.5000000
	MPDamageModifier=1.0000000
	COOPDamageModifier=1.0000000
	ScoringUpdateInterval=1.0000000
	ReconnectionTime=60.0000000
	bDelayedStart=false
	HUDType="SwatGame.SwatHUD"
	MutatorClass="SwatGame.SwatMutator"
	PlayerControllerClassName="SwatGame.SwatGamePlayerController"
	GameReplicationInfoClass=Class'SwatGame.SwatGameReplicationInfo'
}