class GameInfo extends Info
	native
	config
	notplaceable
	hidecategories(Karma,Movement,Collision,Lighting,LightColor,Karma,Force);

struct VoiceChatterInfo
{
	var Controller Controller;
	var int IpAddr;
	var int Handle;
};

var bool bChangingLevels;
var bool bRestartLevel;
var bool bPauseable;
var bool bCanChangeSkin;
var bool bTeamGame;
var bool bGameEnded;
var bool bOverTime;
var localized bool bAlternateMode;
var bool bCanViewOthers;
var bool bDelayedStart;
var bool bWaitingToStartMatch;
var globalconfig bool bChangeLevels;
var bool bAlreadyChanged;
var bool bLoggingGame;
var globalconfig bool bEnableStatLogging;
var config bool bAllowWeaponThrowing;
var config bool bAllowBehindView;
var globalconfig bool bAdminCanPause;
var bool bGameRestarted;
var bool bKeepSamePlayerStart;
var bool bPostGameStarted;
var globalconfig float GameDifficulty;
var globalconfig int GoreLevel;
var globalconfig float AutoAim;
var globalconfig float GameSpeed;
var float StartTime;
var string DefaultPlayerClassName;
var string ScoreBoardType;
var string BotMenuType;
var string RulesMenuType;
var string SettingsMenuType;
var string GameUMenuType;
var string MultiplayerUMenuType;
var string GameOptionsMenuType;
var string HUDType;
var string MapListType;
var string MapPrefix;
var string BeaconName;
var globalconfig int MaxSpectators;
var int NumSpectators;
var globalconfig int MaxPlayers;
var int NumPlayers;
var int NumBots;
var int CurrentID;
var localized string DefaultPlayerName;
var localized string GameName;
var string GameModeString;
var float FearCostFallOff;
var config int GoalScore;
var config int MaxLives;
var config int TimeLimit;
var Class<LocalMessage> DeathMessageClass;
var Class<GameMessage> GameMessageClass;
var name OtherMesgGroup;
var string MutatorClass;
var Mutator BaseMutator;
var globalconfig string AccessControlClass;
var AccessControl AccessControl;
var GameRules GameRulesModifiers;
var string BroadcastHandlerClass;
var BroadcastHandler BroadcastHandler;
var Class<PlayerController> PlayerControllerClass;
var string PlayerControllerClassName;
var Class<GameReplicationInfo> GameReplicationInfoClass;
var GameReplicationInfo GameReplicationInfo;
var bool bWelcomePending;
var GameStats GameStats;
var globalconfig string GameStatsClass;
var array<VoiceChatterInfo> VoiceChatters;
var globalconfig string SecurityClass;
var string ScreenShotName;
var string DecoTextName;
var string Acronym;
var private localized string GIPropsDisplayText[11];
var private localized string GIPropsExtras[2];
var private transient bool bGameStarted;

private function NotifyGameStarted()
{
	Log(" [ ********************************** ] ");
	Log(" [ *** -> THE GAME HAS STARTED <- *** ] ");
	Log(" [ ********************************** ] ");
	Log(" [   ( GameInfo got its first Tick )  ] ");
	Level.NotifyGameStarted();
	return;
}

// Export UGameInfo::execFindOpenSpot(FFrame&, void* const)
native function bool FindOpenSpot(Vector Extent, out Vector Location);

function PreBeginPlay()
{
	StartTime = 0.0000000;
	SetGameSpeed(GameSpeed);
	GameReplicationInfo = Spawn(GameReplicationInfoClass);
	InitGameReplicationInfo();
	InitLogging();
	return;
}

function bool GameInfoShouldTick()
{
	return;
}

function Tick(float DeltaTime)
{
	if(Not_PreBool(bGameStarted))
	{
		NotifyGameStarted();
		bGameStarted = true;
	}
	if(Not_PreBool(GameInfoShouldTick()))
	{
		Disable('Tick');
	}
	return;
}

simulated function UpdatePrecacheRenderData()
{
	PrecacheGameRenderData(Level);
	return;
}

static simulated function PrecacheGameRenderData(LevelInfo myLevel)
{
	return;
}

function string FindPlayerByID(int PlayerID)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, GameReplicationInfo.PRIArray.Length))
	{
		if(EqualEqual_IntInt(GameReplicationInfo.PRIArray[i].PlayerID, PlayerID))
		{
			return GameReplicationInfo.PRIArray[i].PlayerName;
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	return "";
	return;
}

static function bool UseLowGore()
{
	return OrOr_BoolBool(default.bAlternateMode, Greater_IntInt(default.GoreLevel, 0));
	return;
}

function PostBeginPlay()
{
	if(NotEqual_ObjectObject(GameStats, none))
	{
		GameStats.NewGame();
		GameStats.ServerInfo();
	}
	return;
}

function Reset()
{
	super(Actor).Reset();
	bGameEnded = false;
	bOverTime = false;
	bWaitingToStartMatch = true;
	InitGameReplicationInfo();
	return;
}

function InitLogging()
{
	local Class<GameStats> MyGameStatsClass;

	if(OrOr_BoolBool(OrOr_BoolBool(OrOr_BoolBool(Not_PreBool(bEnableStatLogging), Not_PreBool(bLoggingGame)), EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone))), EqualEqual_IntInt(int(Level.NetMode), int(NM_ListenServer))))
	{
		return;
	}
	MyGameStatsClass = Class<GameStats>(DynamicLoadObject(GameStatsClass, Class'Core.Class'));
	if(NotEqual_ObjectObject(MyGameStatsClass, none))
	{
		GameStats = Spawn(MyGameStatsClass);
		if(EqualEqual_ObjectObject(GameStats, none))
		{
			Log("Could to create Stats Object");
		}
	}
	else
	{
		Log(Concat_StrStr(Concat_StrStr("Error loading GameStats [", GameStatsClass), "]"));
	}
	return;
}

function Timer()
{
	local int i;

	if(bWelcomePending)
	{
		bWelcomePending = false;
		if(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
		{
			i = 0;
			J0x31:

			if(Less_IntInt(i, GameReplicationInfo.PRIArray.Length))
			{
				if(AndAnd_BoolBool(NotEqual_ObjectObject(GameReplicationInfo.PRIArray[i], none), Not_PreBool(GameReplicationInfo.PRIArray[i].bWelcomed)))
				{
					GameReplicationInfo.PRIArray[i].bWelcomed = true;
					if(Not_PreBool(GameReplicationInfo.PRIArray[i].bOnlySpectator))
					{
						BroadcastLocalizedMessage(GameMessageClass, 1, GameReplicationInfo.PRIArray[i]);
					}
				}
				AddAdd_Int(i);
				// [Loop Continue]
				goto J0x31;
			}
		}
	}
	BroadcastHandler.UpdateSentText();
	return;
}

event GameEnding()
{
	EndLogging("serverquit");
	return;
}

function InitGameReplicationInfo()
{
	GameReplicationInfo.bTeamGame = bTeamGame;
	GameReplicationInfo.GameName = GameName;
	GameReplicationInfo.GameClass = string(Class);
	GameReplicationInfo.MaxLives = MaxLives;
	return;
}

// Export UGameInfo::execGetNetworkNumber(FFrame&, void* const)
native function string GetNetworkNumber();

function GetServerInfo(out ServerResponseLine ServerState)
{
	ServerState.ServerName = GameReplicationInfo.ServerName;
	ServerState.MapName = Left(string(Level), InStr(string(Level), "."));
	ServerState.GameType = Mid(string(Class), Add_IntInt(InStr(string(Class), "."), 1));
	ServerState.CurrentPlayers = GetNumPlayers();
	ServerState.MaxPlayers = MaxPlayers;
	ServerState.IP = "";
	ServerState.Port = GetServerPort();
	ServerState.ServerInfo.Length = 0;
	ServerState.PlayerInfo.Length = 0;
	return;
}

function int GetNumPlayers()
{
	return NumPlayers;
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
	ServerState.ServerInfo[i].Key = "adminname";
	ServerState.ServerInfo[AddAdd_Int(i)].Value = GameReplicationInfo.AdminName;
	ServerState.ServerInfo.Length = Add_IntInt(i, 1);
	ServerState.ServerInfo[i].Key = "adminemail";
	ServerState.ServerInfo[AddAdd_Int(i)].Value = GameReplicationInfo.AdminEmail;
	ServerState.ServerInfo.Length = Add_IntInt(i, 1);
	ServerState.ServerInfo[i].Key = "ServerVersion";
	ServerState.ServerInfo[AddAdd_Int(i)].Value = Level.EngineVersion;
	if(AccessControl.RequiresPassword())
	{
		ServerState.ServerInfo.Length = Add_IntInt(i, 1);
		ServerState.ServerInfo[i].Key = "password";
		ServerState.ServerInfo[AddAdd_Int(i)].Value = "true";
	}
	ServerState.ServerInfo.Length = Add_IntInt(i, 1);
	ServerState.ServerInfo[i].Key = "gamestats";
	if(NotEqual_ObjectObject(GameStats, none))
	{
		ServerState.ServerInfo[AddAdd_Int(i)].Value = "true";
	}
	else
	{
		ServerState.ServerInfo[AddAdd_Int(i)].Value = "false";
	}
	if(NotEqual_FloatFloat(GameSpeed, 1.0000000))
	{
		ServerState.ServerInfo.Length = Add_IntInt(i, 1);
		ServerState.ServerInfo[i].Key = "gamespeed";
		ServerState.ServerInfo[AddAdd_Int(i)].Value = string(Divide_FloatFloat(float(int(Multiply_FloatFloat(GameSpeed, float(100)))), 100.0000000));
	}
	M = BaseMutator.NextMutator;
	J0x32F:

	if(NotEqual_ObjectObject(M, none))
	{
		M.GetServerDetails(ServerState);
		M = M.NextMutator;
		// [Loop Continue]
		goto J0x32F;
	}
	G = GameRulesModifiers;
	J0x370:

	if(NotEqual_ObjectObject(G, none))
	{
		G.GetServerDetails(ServerState);
		G = G.NextGameRules;
		// [Loop Continue]
		goto J0x370;
	}
	return;
}

function GetServerPlayers(out ServerResponseLine ServerState)
{
	local Mutator M;
	local Controller C;
	local PlayerReplicationInfo PRI;
	local int i;

	i = ServerState.PlayerInfo.Length;
	C = Level.ControllerList;
	J0x25:

	if(NotEqual_ObjectObject(C, none))
	{
		PRI = C.PlayerReplicationInfo;
		if(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(PRI, none), Not_PreBool(PRI.bBot)), EqualEqual_ObjectObject(MessagingSpectator(C), none)))
		{
			ServerState.PlayerInfo.Length = Add_IntInt(i, 1);
			ServerState.PlayerInfo[i].PlayerNum = C.PlayerNum;
			ServerState.PlayerInfo[i].PlayerName = PRI.PlayerName;
			ServerState.PlayerInfo[i].Score = int(PRI.Score);
			ServerState.PlayerInfo[i].Ping = PRI.Ping;
			AddAdd_Int(i);
		}
		C = C.nextController;
		// [Loop Continue]
		goto J0x25;
	}
	M = BaseMutator.NextMutator;
	J0x14F:

	if(NotEqual_ObjectObject(M, none))
	{
		M.GetServerPlayers(ServerState);
		M = M.NextMutator;
		// [Loop Continue]
		goto J0x14F;
	}
	return;
}

function int GetServerPort()
{
	local string S;
	local int i;

	S = Level.GetAddressURL();
	i = InStr(S, ":");
	assert(GreaterEqual_IntInt(i, 0));
	return int(Mid(S, Add_IntInt(i, 1)));
	return;
}

function bool SetPause(bool bPause, PlayerController P)
{
	if(OrOr_BoolBool(OrOr_BoolBool(bPauseable, AndAnd_BoolBool(bAdminCanPause, OrOr_BoolBool(P.IsA('Admin'), P.PlayerReplicationInfo.bAdmin))), EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone))))
	{
		if(bPause)
		{
			Level.Pauser = P.PlayerReplicationInfo;
			ConsoleCommand("PauseSounds");
		}
		else
		{
			Level.Pauser = none;
			ConsoleCommand("UnPauseSounds");
		}
		return true;
	}
	else
	{
		return false;
	}
	return;
}

function ChangeVoiceChatter(Controller Client, int IpAddr, int Handle, bool Add)
{
	local int Index;
	local PlayerController P;

	if(Add)
	{
		Index = VoiceChatters.Length;
		VoiceChatters.Insert(Index, 1);
		VoiceChatters[Index].Controller = Client;
		VoiceChatters[Index].IpAddr = IpAddr;
		VoiceChatters[Index].Handle = Handle;
	}
	else
	{
		Index = 0;
		J0x6D:

		if(Less_IntInt(Index, VoiceChatters.Length))
		{
			if(AndAnd_BoolBool(EqualEqual_IntInt(VoiceChatters[Index].IpAddr, IpAddr), EqualEqual_IntInt(VoiceChatters[Index].Handle, Handle)))
			{
				VoiceChatters.Remove(Index, 1);
			}
			AddAdd_Int(Index);
			// [Loop Continue]
			goto J0x6D;
		}
	}
	foreach DynamicActors(Class'Engine.PlayerController', P)
	{
		if(NotEqual_ObjectObject(P, Client))
		{
			P.ClientChangeVoiceChatter(IpAddr, Handle, Add);
		}
	}
	return;
}

function SetGameSpeed(float t)
{
	local float OldSpeed;

	OldSpeed = GameSpeed;
	GameSpeed = FMax(t, 0.1000000);
	Level.TimeDilation = GameSpeed;
	SetTimer(Level.TimeDilation, true);
	return;
}

event DetailChange()
{
	local Actor A;
	local ZoneInfo Z;

	if(EqualEqual_IntInt(int(Level.DetailMode), int(0)))
	{
		foreach DynamicActors(Class'Engine.Actor', A)
		{
			if(AndAnd_BoolBool(OrOr_BoolBool(A.bHighDetail, A.bSuperHighDetail), Not_PreBool(A.bGameRelevant)))
			{
				A.Destroy();
			}
		}
	}
	else
	{
		if(EqualEqual_IntInt(int(Level.DetailMode), int(1)))
		{
			foreach DynamicActors(Class'Engine.Actor', A)
			{
				if(AndAnd_BoolBool(A.bSuperHighDetail, Not_PreBool(A.bGameRelevant)))
				{
					A.Destroy();
				}
			}
		}
	}
	foreach AllActors(Class'Engine.ZoneInfo', Z)
	{
		Z.LinkToSkybox();
	}
	return;
}

function bool GrabOption(out string Options, out string Result)
{
	if(EqualEqual_StrStr(Left(Options, 1), "?"))
	{
		Result = Mid(Options, 1);
		if(GreaterEqual_IntInt(InStr(Result, "?"), 0))
		{
			Result = Left(Result, InStr(Result, "?"));
		}
		Options = Mid(Options, 1);
		if(GreaterEqual_IntInt(InStr(Options, "?"), 0))
		{
			Options = Mid(Options, InStr(Options, "?"));
		}
		else
		{
			Options = "";
		}
		return true;
	}
	else
	{
		return false;
	}
	return;
}

function GetKeyValue(string Pair, out string Key, out string Value)
{
	if(GreaterEqual_IntInt(InStr(Pair, "="), 0))
	{
		Key = Left(Pair, InStr(Pair, "="));
		Value = Mid(Pair, Add_IntInt(InStr(Pair, "="), 1));
	}
	else
	{
		Key = Pair;
		Value = "";
	}
	return;
}

function string ParseOption(string Options, string InKey)
{
	local string Pair, Key, Value;

	J0x00:
	if(GrabOption(Options, Pair))
	{
		GetKeyValue(Pair, Key, Value);
		if(ComplementEqual_StrStr(Key, InKey))
		{
			return Value;
		}
		// [Loop Continue]
		goto J0x00;
	}
	return "";
	return;
}

function bool HasOption(string Options, string InKey)
{
	local string Pair, Key, Value;

	J0x00:
	if(GrabOption(Options, Pair))
	{
		GetKeyValue(Pair, Key, Value);
		if(ComplementEqual_StrStr(Key, InKey))
		{
			return true;
		}
		// [Loop Continue]
		goto J0x00;
	}
	return false;
	return;
}

event InitGame(string Options, out string Error)
{
	local string InOpt, LeftOpt;
	local int pos;
	local Class<AccessControl> ACClass;
	local Class<GameRules> GRClass;
	local Class<BroadcastHandler> BHClass;

	Log(At_StrStr("InitGame:", Options));
	MaxPlayers = Clamp(GetIntOption(Options, "MaxPlayers", MaxPlayers), 0, 32);
	MaxSpectators = Clamp(GetIntOption(Options, "MaxSpectators", MaxSpectators), 0, 32);
	GameDifficulty = FMax(0.0000000, float(GetIntOption(Options, "Difficulty", int(GameDifficulty))));
	InOpt = ParseOption(Options, "GameSpeed");
	if(NotEqual_StrStr(InOpt, ""))
	{
		Log(At_StrStr("GameSpeed", InOpt));
		SetGameSpeed(float(InOpt));
	}
	AddMutator(MutatorClass);
	BHClass = Class<BroadcastHandler>(DynamicLoadObject(BroadcastHandlerClass, Class'Core.Class'));
	BroadcastHandler = Spawn(BHClass);
	InOpt = ParseOption(Options, "AccessControl");
	if(NotEqual_StrStr(InOpt, ""))
	{
		ACClass = Class<AccessControl>(DynamicLoadObject(InOpt, Class'Core.Class'));
	}
	if(EqualEqual_ObjectObject(ACClass, none))
	{
		ACClass = Class<AccessControl>(DynamicLoadObject(AccessControlClass, Class'Core.Class'));
		if(EqualEqual_ObjectObject(ACClass, none))
		{
			ACClass = Class'Engine.AccessControl';
		}
	}
	LeftOpt = ParseOption(Options, "AdminName");
	InOpt = ParseOption(Options, "AdminPassword");
	if(AndAnd_BoolBool(NotEqual_StrStr(LeftOpt, ""), NotEqual_StrStr(InOpt, "")))
	{
		ACClass.default.bDontAddDefaultAdmin = true;
	}
	AccessControl = Spawn(ACClass);
	InOpt = ParseOption(Options, "GameRules");
	if(NotEqual_StrStr(InOpt, ""))
	{
		Log(At_StrStr("Game Rules", InOpt));
		J0x244:

		if(NotEqual_StrStr(InOpt, ""))
		{
			pos = InStr(InOpt, ",");
			if(Greater_IntInt(pos, 0))
			{
				LeftOpt = Left(InOpt, pos);
				InOpt = Right(InOpt, Subtract_IntInt(Subtract_IntInt(Len(InOpt), pos), 1));
			}
			else
			{
				LeftOpt = InOpt;
				InOpt = "";
			}
			Log(Concat_StrStr("Add game rules ", LeftOpt));
			GRClass = Class<GameRules>(DynamicLoadObject(LeftOpt, Class'Core.Class'));
			if(NotEqual_ObjectObject(GRClass, none))
			{
				if(EqualEqual_ObjectObject(GameRulesModifiers, none))
				{
					GameRulesModifiers = Spawn(GRClass);
				}
				else
				{
					GameRulesModifiers.AddGameRules(Spawn(GRClass));
				}
			}
			// [Loop Continue]
			goto J0x244;
		}
	}
	Log(Concat_StrStr("Base Mutator is ", string(BaseMutator)));
	InOpt = ParseOption(Options, "Mutator");
	if(NotEqual_StrStr(InOpt, ""))
	{
		Log(At_StrStr("Mutators", InOpt));
		J0x37D:

		if(NotEqual_StrStr(InOpt, ""))
		{
			pos = InStr(InOpt, ",");
			if(Greater_IntInt(pos, 0))
			{
				LeftOpt = Left(InOpt, pos);
				InOpt = Right(InOpt, Subtract_IntInt(Subtract_IntInt(Len(InOpt), pos), 1));
			}
			else
			{
				LeftOpt = InOpt;
				InOpt = "";
			}
			Log(Concat_StrStr("Add mutator ", LeftOpt));
			AddMutator(LeftOpt, true);
			// [Loop Continue]
			goto J0x37D;
		}
	}
	InOpt = ParseOption(Options, "GamePassword");
	if(NotEqual_StrStr(InOpt, ""))
	{
		AccessControl.SetGamePassword(InOpt);
		Log(At_StrStr("GamePassword", InOpt));
	}
	InOpt = ParseOption(Options, "AllowThrowing");
	if(NotEqual_StrStr(InOpt, ""))
	{
		bAllowWeaponThrowing = bool(InOpt);
	}
	InOpt = ParseOption(Options, "AllowBehindview");
	if(NotEqual_StrStr(InOpt, ""))
	{
		bAllowBehindView = bool(InOpt);
	}
	InOpt = ParseOption(Options, "GameStats");
	if(NotEqual_StrStr(InOpt, ""))
	{
		bEnableStatLogging = bool(InOpt);
	}
	else
	{
		bEnableStatLogging = false;
	}
	Log(At_StrStr("GameInfo::InitGame : bEnableStatLogging", string(bEnableStatLogging)));
	if(HasOption(Options, "DemoRec"))
	{
		Log(Level.ConsoleCommand(At_StrStr("demorec", ParseOption(Options, "DemoRec"))));
	}
	return;
}

function AddMutator(string mutname, optional bool bUserAdded)
{
	local Class<Mutator> mutClass;
	local Mutator mut;

	mutClass = Class<Mutator>(DynamicLoadObject(mutname, Class'Core.Class'));
	if(EqualEqual_ObjectObject(mutClass, none))
	{
		return;
	}
	if(AndAnd_BoolBool(NotEqual_StrStr(mutClass.default.GroupName, ""), NotEqual_ObjectObject(BaseMutator, none)))
	{
		mut = BaseMutator;
		J0x55:

		if(NotEqual_ObjectObject(mut, none))
		{
			if(EqualEqual_StrStr(mut.GroupName, mutClass.default.GroupName))
			{
				return;
			}
			mut = mut.NextMutator;
			// [Loop Continue]
			goto J0x55;
		}
	}
	mut = Spawn(mutClass);
	if(EqualEqual_ObjectObject(mut, none))
	{
		return;
	}
	mut.bUserAdded = bUserAdded;
	if(EqualEqual_ObjectObject(BaseMutator, none))
	{
		BaseMutator = mut;
	}
	else
	{
		BaseMutator.AddMutator(mut);
	}
	return;
}

event string GetBeaconText()
{
	return Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Level.ComputerName, " "), Left(Level.Title, 24)), "\\t"), BeaconName), "\\t"), string(GetNumPlayers())), "/"), string(MaxPlayers));
	return;
}

function ProcessServerTravel(string URL, bool bItems)
{
	local PlayerController P, LocalPlayer;

	bChangingLevels = true;
	BaseMutator.ServerTraveling(URL, bItems);
	EndLogging("mapchange");
	Log(At_StrStr("ProcessServerTravel:", URL));
	foreach DynamicActors(Class'Engine.PlayerController', P)
	{
		if(NotEqual_ObjectObject(NetConnection(P.Player), none))
		{
			P.ClientTravel(Concat_StrStr(Concat_StrStr(URL, "?SwatPlayerID="), string(P.GetSwatPlayerID())), 2, bItems);
			continue;
		}
		LocalPlayer = P;
		P.PreClientTravel();
	}
	if(AndAnd_BoolBool(EqualEqual_IntInt(int(Level.NetMode), int(NM_ListenServer)), NotEqual_ObjectObject(LocalPlayer, none)))
	{
		Level.NextURL = Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Level.NextURL, "?Team="), LocalPlayer.GetDefaultURL("Team")), "?Name="), LocalPlayer.GetDefaultURL("Name")), "?Class="), LocalPlayer.GetDefaultURL("Class")), "?Character="), LocalPlayer.GetDefaultURL("Character")), "?SwatPlayerID="), string(LocalPlayer.GetSwatPlayerID()));
	}
	if(AndAnd_BoolBool(NotEqual_IntInt(int(Level.NetMode), int(NM_DedicatedServer)), NotEqual_IntInt(int(Level.NetMode), int(NM_ListenServer))))
	{
		Level.NextSwitchCountdown = 0.0000000;
	}
	return;
}

event PreLogin(string Options, string Address, out string Error, out string FailCode)
{
	local bool bSpectator;

	bSpectator = ComplementEqual_StrStr(ParseOption(Options, "SpectatorOnly"), "true");
	AccessControl.PreLogin(Options, Address, Error, FailCode, bSpectator);
	return;
}

function int GetIntOption(string Options, string ParseString, int CurrentValue)
{
	local string InOpt;

	InOpt = ParseOption(Options, ParseString);
	if(NotEqual_StrStr(InOpt, ""))
	{
		Log(At_StrStr(ParseString, InOpt));
		return int(InOpt);
	}
	return CurrentValue;
	return;
}

function bool AtCapacity(bool bSpectator)
{
	if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
	{
		return false;
	}
	if(bSpectator)
	{
		return AndAnd_BoolBool(GreaterEqual_IntInt(NumSpectators, MaxSpectators), OrOr_BoolBool(NotEqual_IntInt(int(Level.NetMode), int(NM_ListenServer)), Greater_IntInt(NumPlayers, 0)));
	}
	else
	{
		return AndAnd_BoolBool(Greater_IntInt(MaxPlayers, 0), GreaterEqual_IntInt(NumPlayers, MaxPlayers));
	}
	return;
}

event PlayerController Login(string Portal, string Options, out string Error)
{
	local NavigationPoint StartSpot;
	local PlayerController NewPlayer;
	local Pawn TestPawn;
	local string InName, InAdminName, InPassword, InChecksum, inClass, inCharacter;

	local byte InTeam;
	local bool bSpectator, bAdmin;
	local Class<Security> MySecurityClass;

	bSpectator = ComplementEqual_StrStr(ParseOption(Options, "SpectatorOnly"), "true");
	if(AndAnd_BoolBool(Not_PreBool(bAdmin), AtCapacity(bSpectator)))
	{
		Error = GameMessageClass.default.MaxedOutMessage;
		return none;
	}
	if(AndAnd_BoolBool(bAdmin, AtCapacity(false)))
	{
		bSpectator = true;
	}
	BaseMutator.ModifyLogin(Portal, Options);
	InName = Left(ParseOption(Options, "Name"), 20);
	InTeam = byte(GetIntOption(Options, "Team", 255));
	InAdminName = ParseOption(Options, "AdminName");
	InPassword = ParseOption(Options, "Password");
	InChecksum = ParseOption(Options, "Checksum");
	Log(At_StrStr("Login:", InName));
	InTeam = PickTeam(InTeam, none);
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
	NewPlayer.GameReplicationInfo = GameReplicationInfo;
	NewPlayer.GotoState('Spectating');
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
		ChangeName(NewPlayer, InName, false);
	}
	if(OrOr_BoolBool(bSpectator, NewPlayer.PlayerReplicationInfo.bOnlySpectator))
	{
		NewPlayer.PlayerReplicationInfo.bOnlySpectator = true;
		NewPlayer.PlayerReplicationInfo.bIsSpectator = true;
		NewPlayer.PlayerReplicationInfo.bOutOfLives = true;
		AddAdd_Int(NumSpectators);
		return NewPlayer;
	}
	if(Not_PreBool(ChangeTeam(NewPlayer, int(InTeam), false)))
	{
		Error = GameMessageClass.default.FailedTeamMessage;
		return none;
	}
	NewPlayer.StartSpot = StartSpot;
	NewPlayer.PlayerReplicationInfo.PlayerID = AddAdd_Int(CurrentID);
	if(EqualEqual_StrStr(inClass, ""))
	{
		inClass = ParseOption(Options, "Class");
	}
	if(EqualEqual_StrStr(inClass, ""))
	{
		inClass = DefaultPlayerClassName;
	}
	inCharacter = ParseOption(Options, "Character");
	NewPlayer.SetPawnClass(inClass, inCharacter);
	AddAdd_Int(NumPlayers);
	bWelcomePending = true;
	if(bDelayedStart)
	{
		NewPlayer.GotoState('PlayerWaiting');
		return NewPlayer;
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
	return NewPlayer;
	return;
}

function StartMatch()
{
	local Controller P;
	local Actor A;

	if(NotEqual_ObjectObject(GameStats, none))
	{
		GameStats.StartGame();
	}
	foreach AllActors(Class'Engine.Actor', A)
	{
		A.MatchStarting();
	}
	P = Level.ControllerList;
	J0x4F:

	if(NotEqual_ObjectObject(P, none))
	{
		if(AndAnd_BoolBool(P.IsA('PlayerController'), EqualEqual_ObjectObject(P.Pawn, none)))
		{
			if(bGameEnded)
			{
				return;
			}
			else
			{
				if(PlayerController(P).CanRestartPlayer())
				{
					RestartPlayer(P);
				}
			}
		}
		P = P.nextController;
		// [Loop Continue]
		goto J0x4F;
	}
	P = Level.ControllerList;
	J0xDF:

	if(NotEqual_ObjectObject(P, none))
	{
		if(AndAnd_BoolBool(P.bIsPlayer, Not_PreBool(P.IsA('PlayerController'))))
		{
			if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
			{
				RestartPlayer(P);
			}
			else
			{
				P.GotoState('Dead', 'MPStart');
			}
		}
		P = P.nextController;
		// [Loop Continue]
		goto J0xDF;
	}
	bWaitingToStartMatch = false;
	GameReplicationInfo.bMatchHasBegun = true;
	return;
}

function RestartPlayer(Controller aPlayer)
{
	local NavigationPoint StartSpot;
	local int TeamNum;

	if(AndAnd_BoolBool(AndAnd_BoolBool(bRestartLevel, NotEqual_IntInt(int(Level.NetMode), int(NM_DedicatedServer))), NotEqual_IntInt(int(Level.NetMode), int(NM_ListenServer))))
	{
		return;
	}
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
	return;
}

function NavigationPoint SpawnPlayerPawn(Controller aPlayer, int TeamNum)
{
	local Class<Pawn> DefaultPlayerClass;
	local NavigationPoint StartSpot;

	StartSpot = FindPlayerStart(aPlayer, byte(TeamNum));
	if(EqualEqual_ObjectObject(StartSpot, none))
	{
		return none;
	}
	if(AndAnd_BoolBool(NotEqual_ObjectObject(aPlayer.PreviousPawnClass, none), NotEqual_ObjectObject(aPlayer.PawnClass, aPlayer.PreviousPawnClass)))
	{
		BaseMutator.PlayerChangedClass(aPlayer);
	}
	if(NotEqual_ObjectObject(aPlayer.PawnClass, none))
	{
		aPlayer.Pawn = Spawn(aPlayer.PawnClass,, 'Player', StartSpot.Location, StartSpot.Rotation);
	}
	if(EqualEqual_ObjectObject(aPlayer.Pawn, none))
	{
		DefaultPlayerClass = GetDefaultPlayerClass(aPlayer);
		aPlayer.Pawn = Spawn(DefaultPlayerClass,, 'Player', StartSpot.Location, StartSpot.Rotation);
	}
	if(EqualEqual_ObjectObject(aPlayer.Pawn, none))
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("Couldn't spawn pawn of class for player ", string(aPlayer)), " at "), string(StartSpot)));
		AssertWithDescription(false, Concat_StrStr(Concat_StrStr(Concat_StrStr("Couldn't spawn pawn for player ", string(aPlayer)), " at start point "), string(StartSpot)));
		aPlayer.GotoState('Dead');
		return none;
	}
	Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("Spawned *pawn* for player ", string(aPlayer)), " at "), string(StartSpot)));
	return StartSpot;
	return;
}

function Class<Pawn> GetDefaultPlayerClass(Controller C)
{
	local PlayerController PC;
	local string PawnClassName;
	local Class<Pawn> PawnClass;

	PC = PlayerController(C);
	if(NotEqual_ObjectObject(PC, none))
	{
		PawnClassName = PC.GetDefaultURL("Class");
		PawnClass = Class<Pawn>(DynamicLoadObject(PawnClassName, Class'Core.Class'));
		if(NotEqual_ObjectObject(PawnClass, none))
		{
			return PawnClass;
		}
	}
	return Class<Pawn>(DynamicLoadObject(DefaultPlayerClassName, Class'Core.Class'));
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
	return;
}

function Logout(Controller Exiting)
{
	local bool bMessage;
	local int Index;

	bMessage = true;
	if(NotEqual_ObjectObject(PlayerController(Exiting), none))
	{
		if(PlayerController(Exiting).PlayerReplicationInfo.bOnlySpectator)
		{
			bMessage = false;
			SubtractSubtract_Int(NumSpectators);
		}
		else
		{
			SubtractSubtract_Int(NumPlayers);
		}
		if(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)))
		{
			Index = 0;
			J0x71:

			if(Less_IntInt(Index, VoiceChatters.Length))
			{
				if(EqualEqual_ObjectObject(VoiceChatters[Index].Controller, Exiting))
				{
					ChangeVoiceChatter(PlayerController(Exiting), VoiceChatters[Index].IpAddr, VoiceChatters[Index].Handle, false);
				}
				AddAdd_Int(Index);
				// [Loop Continue]
				goto J0x71;
			}
		}
		if(EqualEqual_IntInt(int(Level.NetMode), int(NM_Client)))
		{
			PlayerController(Exiting).ClientLeaveVoiceChat();
		}
	}
	if(AndAnd_BoolBool(bMessage, OrOr_BoolBool(EqualEqual_IntInt(int(Level.NetMode), int(NM_DedicatedServer)), EqualEqual_IntInt(int(Level.NetMode), int(NM_ListenServer)))))
	{
		BroadcastLocalizedMessage(GameMessageClass, 4, Exiting.PlayerReplicationInfo);
	}
	if(NotEqual_ObjectObject(GameStats, none))
	{
		GameStats.DisconnectEvent(Exiting.PlayerReplicationInfo);
	}
	return;
}

event AcceptInventory(Pawn PlayerPawn)
{
	return;
}

function AddGameSpecificInventory(Pawn P)
{
	return;
}

function AddDefaultInventory(Pawn PlayerPawn)
{
	SetPlayerDefaults(PlayerPawn);
	return;
}

function SetPlayerDefaults(Pawn PlayerPawn)
{
	PlayerPawn.AirControl = PlayerPawn.default.AirControl;
	PlayerPawn.GroundSpeed = PlayerPawn.default.GroundSpeed;
	PlayerPawn.WaterSpeed = PlayerPawn.default.WaterSpeed;
	PlayerPawn.AirSpeed = PlayerPawn.default.AirSpeed;
	PlayerPawn.Acceleration = PlayerPawn.default.Acceleration;
	PlayerPawn.JumpZ = PlayerPawn.default.JumpZ;
	BaseMutator.ModifyPlayer(PlayerPawn);
	return;
}

function NotifyKilled(Controller Killer, Controller Killed, Pawn KilledPawn)
{
	local Pawn P;

	P = Level.PawnList;
	J0x14:

	if(NotEqual_ObjectObject(P, none))
	{
		if(Class'Engine.Pawn'.static.checkAlive(P))
		{
			P.super(GameInfo).NotifyKilled(Killer, Killed, KilledPawn);
		}
		P = P.nextPawn;
		// [Loop Continue]
		goto J0x14;
	}
	return;
}

function KillEvent(string KillType, PlayerReplicationInfo Killer, PlayerReplicationInfo Victim, Class<DamageType> Damage)
{
	if(NotEqual_ObjectObject(GameStats, none))
	{
		GameStats.KillEvent(KillType, Killer, Victim, Damage);
	}
	return;
}

function Killed(Controller Killer, Controller Killed, Pawn KilledPawn, Class<DamageType> DamageType)
{
	if(AndAnd_BoolBool(NotEqual_ObjectObject(Killed, none), Killed.bIsPlayer))
	{
		AddEqual_FloatFloat(Killed.PlayerReplicationInfo.Deaths, float(1));
		BroadcastDeathMessage(Killer, Killed, DamageType);
		if(OrOr_BoolBool(EqualEqual_ObjectObject(Killer, Killed), EqualEqual_ObjectObject(Killer, none)))
		{
			if(EqualEqual_ObjectObject(Killer, none))
			{
				KillEvent("K", none, Killed.PlayerReplicationInfo, DamageType);
			}
			else
			{
				KillEvent("K", Killer.PlayerReplicationInfo, Killed.PlayerReplicationInfo, DamageType);
			}
		}
		else
		{
			if(AndAnd_BoolBool(AndAnd_BoolBool(bTeamGame, NotEqual_ObjectObject(Killer.PlayerReplicationInfo, none)), EqualEqual_ObjectObject(Killer.PlayerReplicationInfo.Team, Killed.PlayerReplicationInfo.Team)))
			{
				KillEvent("TK", Killer.PlayerReplicationInfo, Killed.PlayerReplicationInfo, DamageType);
			}
			else
			{
				KillEvent("K", Killer.PlayerReplicationInfo, Killed.PlayerReplicationInfo, DamageType);
			}
		}
	}
	if(NotEqual_ObjectObject(Killed, none))
	{
		ScoreKill(Killer, Killed);
	}
	DiscardInventory(KilledPawn);
	NotifyKilled(Killer, Killed, KilledPawn);
	return;
}

function bool PreventDeath(Pawn Killed, Controller Killer, Class<DamageType> DamageType, Vector HitLocation)
{
	if(EqualEqual_ObjectObject(GameRulesModifiers, none))
	{
		return false;
	}
	return GameRulesModifiers.PreventDeath(Killed, Killer, DamageType, HitLocation);
	return;
}

function bool PreventSever(Pawn Killed, name BoneName, int Damage, Class<DamageType> DamageType)
{
	if(EqualEqual_ObjectObject(GameRulesModifiers, none))
	{
		return false;
	}
	return GameRulesModifiers.PreventSever(Killed, BoneName, Damage, DamageType);
	return;
}

function BroadcastDeathMessage(Controller Killer, Controller Other, Class<DamageType> DamageType)
{
	if(OrOr_BoolBool(EqualEqual_ObjectObject(Killer, Other), EqualEqual_ObjectObject(Killer, none)))
	{
		BroadcastLocalized(self, DeathMessageClass, 1, none, Other.PlayerReplicationInfo, DamageType);
	}
	else
	{
		BroadcastLocalized(self, DeathMessageClass, 0, Killer.PlayerReplicationInfo, Other.PlayerReplicationInfo, DamageType);
	}
	return;
}

// Export UGameInfo::execParseKillMessage(FFrame&, void* const)
native static function string ParseKillMessage(string KillerName, string VictimName, string DeathMessage);

function Kick(Controller Kicker, string Kickee)
{
	if(AccessControl.Kick(Kickee))
	{
		Broadcast(Kicker, Concat_StrStr(Concat_StrStr(Kicker.PlayerReplicationInfo.PlayerName, "	"), Kickee), 'Kick');
	}
	return;
}

function KickBan(Controller Kicker, string Kickee)
{
	if(AccessControl.KickBan(Kickee))
	{
		Broadcast(Kicker, Concat_StrStr(Concat_StrStr(Kicker.PlayerReplicationInfo.PlayerName, "	"), Kickee), 'KickBan');
	}
	return;
}

function bool IsOnTeam(Controller Other, int TeamNum)
{
	if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(bTeamGame, NotEqual_ObjectObject(Other, none)), Other.bIsPlayer), NotEqual_ObjectObject(Other.PlayerReplicationInfo.Team, none)), EqualEqual_IntInt(Other.PlayerReplicationInfo.Team.TeamIndex, TeamNum)))
	{
		return true;
	}
	return false;
	return;
}

function bool CanSpectate(PlayerController Viewer, bool bOnlySpectator, Actor ViewTarget)
{
	return true;
	return;
}

function int ReduceDamage(int Damage, Pawn injured, Pawn InstigatedBy, Vector HitLocation, out Vector Momentum, Class<DamageType> DamageType)
{
	local int OriginalDamage;

	OriginalDamage = Damage;
	if(injured.PhysicsVolume.bNeutralZone)
	{
		Damage = 0;
	}
	else
	{
		if(injured.InGodMode())
		{
			return 0;
		}
		else
		{
			if(AndAnd_BoolBool(NotEqual_ObjectObject(injured.Inventory, none), Greater_IntInt(Damage, 0)))
			{
			}
		}
	}
	if(NotEqual_ObjectObject(GameRulesModifiers, none))
	{
		return GameRulesModifiers.NetDamage(OriginalDamage, Damage, injured, InstigatedBy, HitLocation, Momentum, DamageType);
	}
	return Damage;
	return;
}

function DiscardInventory(Pawn Other)
{
	return;
}

function ChangeName(Controller Other, coerce string S, bool bNameChange)
{
	if(EqualEqual_StrStr(S, ""))
	{
		return;
	}
	Other.PlayerReplicationInfo.SetPlayerName(S);
	if(bNameChange)
	{
		if(AndAnd_BoolBool(NotEqual_StrStr(Other.PlayerReplicationInfo.OldName, DefaultPlayerName), NotEqual_StrStr(Other.PlayerReplicationInfo.OldName, Other.PlayerReplicationInfo.PlayerName)))
		{
			Broadcast(Other, Concat_StrStr(Concat_StrStr(Other.PlayerReplicationInfo.OldName, "	"), Other.PlayerReplicationInfo.PlayerName), 'NameChange');
		}
	}
	return;
}

function bool ChangeTeam(Controller Other, int n, bool bNewTeam)
{
	return true;
	return;
}

function byte PickTeam(byte Current, Controller C)
{
	return Current;
	return;
}

function SendPlayer(PlayerController aPlayer, string URL)
{
	aPlayer.ClientTravel(URL, 2, true);
	return;
}

function RestartGame()
{
	local string NextMap;
	local MapList MyList;

	if(AndAnd_BoolBool(NotEqual_ObjectObject(GameRulesModifiers, none), GameRulesModifiers.HandleRestartGame()))
	{
		return;
	}
	if(bGameRestarted)
	{
		return;
	}
	bGameRestarted = true;
	if(AndAnd_BoolBool(AndAnd_BoolBool(bChangeLevels, Not_PreBool(bAlreadyChanged)), NotEqual_StrStr(MapListType, "")))
	{
		bAlreadyChanged = true;
		MyList = GetMapList(MapListType);
		if(NotEqual_ObjectObject(MyList, none))
		{
			NextMap = MyList.GetNextMap();
			MyList.Destroy();
		}
		if(EqualEqual_StrStr(NextMap, ""))
		{
			NextMap = GetMapName(MapPrefix, NextMap, 1);
		}
		if(NotEqual_StrStr(NextMap, ""))
		{
			Level.ServerTravel(NextMap, false);
			return;
		}
	}
	Level.ServerTravel("?Restart", false);
	return;
}

function MapList GetMapList(string MapListType)
{
	local Class<MapList> MapListClass;

	if(NotEqual_StrStr(MapListType, ""))
	{
		MapListClass = Class<MapList>(DynamicLoadObject(MapListType, Class'Core.Class'));
		if(NotEqual_ObjectObject(MapListClass, none))
		{
			return Spawn(MapListClass);
		}
	}
	return none;
	return;
}

event Broadcast(Actor Sender, coerce string msg, optional name Type)
{
	BroadcastHandler.Broadcast(Sender, msg, Type);
	return;
}

function BroadcastTeam(Controller Sender, coerce string msg, optional name Type)
{
	BroadcastHandler.BroadcastTeam(Sender, msg, Type);
	return;
}

event BroadcastLocalized(Actor Sender, Class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	BroadcastHandler.AllowBroadcastLocalized(Sender, Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
	return;
}

function bool CheckEndGame(PlayerReplicationInfo Winner, string Reason)
{
	local Controller P;

	if(AndAnd_BoolBool(NotEqual_ObjectObject(GameRulesModifiers, none), Not_PreBool(GameRulesModifiers.CheckEndGame(Winner, Reason))))
	{
		return false;
	}
	P = Level.ControllerList;
	J0x41:

	if(NotEqual_ObjectObject(P, none))
	{
		P.ClientGameEnded();
		P.GameHasEnded();
		P = P.nextController;
		// [Loop Continue]
		goto J0x41;
	}
	return true;
	return;
}

function EndGame(PlayerReplicationInfo Winner, string Reason)
{
	if(Not_PreBool(CheckEndGame(Winner, Reason)))
	{
		bOverTime = true;
		return;
	}
	bGameEnded = true;
	TriggerEvent('EndGame', self, none);
	EndLogging(Reason);
	return;
}

function EndLogging(string Reason)
{
	if(EqualEqual_ObjectObject(GameStats, none))
	{
		return;
	}
	GameStats.EndGame(Reason);
	GameStats.Destroy();
	GameStats = none;
	return;
}

function NavigationPoint FindPlayerStart(Controller Player, optional byte InTeam, optional string incomingName)
{
	local NavigationPoint n, BestStart;
	local Teleporter Tel;
	local float BestRating, NewRating;
	local byte Team;

	if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(Player, none), NotEqual_ObjectObject(Player.StartSpot, none)), EqualEqual_IntInt(int(Level.NetMode), int(NM_Standalone))), OrOr_BoolBool(OrOr_BoolBool(bKeepSamePlayerStart, bWaitingToStartMatch), AndAnd_BoolBool(NotEqual_ObjectObject(Player.PlayerReplicationInfo, none), Player.PlayerReplicationInfo.bWaitingPlayer))))
	{
		Log(Concat_StrStr(Concat_StrStr("Found player start [", string(Player.StartSpot)), "] by using Player.StartSpot"));
		return Player.StartSpot;
	}
	if(NotEqual_ObjectObject(GameRulesModifiers, none))
	{
		n = GameRulesModifiers.FindPlayerStart(Player, InTeam, incomingName);
		if(NotEqual_ObjectObject(n, none))
		{
			Log(Concat_StrStr(Concat_StrStr("Found player start [", string(n)), "] based on GameRulesModifiers"));
			return n;
		}
	}
	if(NotEqual_StrStr(incomingName, ""))
	{
		foreach AllActors(Class'Engine.Teleporter', Tel)
		{
			if(ComplementEqual_StrStr(string(Tel.Tag), incomingName))
			{
				return Tel;
			}
		}
	}
	if(AndAnd_BoolBool(NotEqual_ObjectObject(Player, none), NotEqual_ObjectObject(Player.PlayerReplicationInfo, none)))
	{
		if(NotEqual_ObjectObject(Player.PlayerReplicationInfo.Team, none))
		{
			Team = byte(Player.PlayerReplicationInfo.Team.TeamIndex);
		}
		else
		{
			Team = 0;
		}
	}
	else
	{
		Team = InTeam;
	}
	n = Level.NavigationPointList;
	J0x231:

	if(NotEqual_ObjectObject(n, none))
	{
		NewRating = RatePlayerStart(n, InTeam, Player);
		if(Greater_FloatFloat(NewRating, BestRating))
		{
			BestRating = NewRating;
			BestStart = n;
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(" Searching NavigationPoints to find player start; new best point is [", string(BestStart)), "] with rating ["), string(NewRating)), "]"));
		}
		n = n.nextNavigationPoint;
		// [Loop Continue]
		goto J0x231;
	}
	if(EqualEqual_ObjectObject(BestStart, none))
	{
		Log("Warning - PATHS NOT DEFINED or NO PLAYERSTART");
		foreach AllActors(Class'Engine.NavigationPoint', n)
		{
			NewRating = RatePlayerStart(n, 0, Player);
			if(Greater_FloatFloat(NewRating, BestRating))
			{
				BestRating = NewRating;
				BestStart = n;
				Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(" Iterating all NavigationPoints to find player start; new best point is [", string(BestStart)), "] with rating ["), string(NewRating)), "]"));
			}
		}
	}
	Log(Concat_StrStr(Concat_StrStr("Found player start [", string(BestStart)), "]"));
	return BestStart;
	return;
}

function float RatePlayerStart(NavigationPoint n, byte Team, Controller Player)
{
	local PlayerStart P;

	P = PlayerStart(n);
	if(Greater_IntInt(P.Touching.Length, 0))
	{
		return 0.0000000;
	}
	if(NotEqual_ObjectObject(P, none))
	{
		if(P.bSinglePlayerStart)
		{
			if(P.bEnabled)
			{
				return 1000.0000000;
			}
			return 20.0000000;
		}
		return 10.0000000;
	}
	return 0.0000000;
	return;
}

function ScoreObjective(PlayerReplicationInfo Scorer, int Score)
{
	if(NotEqual_ObjectObject(Scorer, none))
	{
		AddEqual_FloatFloat(Scorer.Score, float(Score));
	}
	if(NotEqual_ObjectObject(GameRulesModifiers, none))
	{
		GameRulesModifiers.ScoreObjective(Scorer, Score);
	}
	CheckScore(Scorer);
	return;
}

function CheckScore(PlayerReplicationInfo Scorer)
{
	if(AndAnd_BoolBool(NotEqual_ObjectObject(GameRulesModifiers, none), GameRulesModifiers.CheckScore(Scorer)))
	{
		return;
	}
	return;
}

function ScoreEvent(PlayerReplicationInfo Who, float Points, string Desc)
{
	if(NotEqual_ObjectObject(GameStats, none))
	{
		GameStats.ScoreEvent(Who, Points, Desc);
	}
	return;
}

function TeamScoreEvent(int Team, float Points, string Desc)
{
	if(NotEqual_ObjectObject(GameStats, none))
	{
		GameStats.TeamScoreEvent(Team, Points, Desc);
	}
	return;
}

function ScoreKill(Controller Killer, Controller Other)
{
	if(OrOr_BoolBool(EqualEqual_ObjectObject(Killer, Other), EqualEqual_ObjectObject(Killer, none)))
	{
		if(AndAnd_BoolBool(NotEqual_ObjectObject(Other, none), NotEqual_ObjectObject(Other.PlayerReplicationInfo, none)))
		{
			SubtractEqual_FloatFloat(Other.PlayerReplicationInfo.Score, float(1));
			ScoreEvent(Other.PlayerReplicationInfo, -1.0000000, "self_frag");
		}
	}
	else
	{
		if(NotEqual_ObjectObject(Killer.PlayerReplicationInfo, none))
		{
			AddEqual_FloatFloat(Killer.PlayerReplicationInfo.Score, float(1));
			AddAdd_Int(Killer.PlayerReplicationInfo.Kills);
			ScoreEvent(Killer.PlayerReplicationInfo, 1.0000000, "frag");
		}
	}
	if(NotEqual_ObjectObject(GameRulesModifiers, none))
	{
		GameRulesModifiers.ScoreKill(Killer, Other);
	}
	if(OrOr_BoolBool(NotEqual_ObjectObject(Killer, none), Greater_IntInt(MaxLives, 0)))
	{
		CheckScore(Killer.PlayerReplicationInfo);
	}
	return;
}

function bool TooManyBots(Controller botToRemove)
{
	return false;
	return;
}

static function string FindTeamDesignation(GameReplicationInfo GRI, Actor A)
{
	return "";
	return;
}

static function string ParseMessageString(Mutator BaseMutator, Controller Who, string Message)
{
	return Message;
	return;
}

function ReviewJumpSpots(name TestLabel)
{
	return;
}

function TeamInfo OtherTeam(TeamInfo Requester)
{
	return none;
	return;
}

exec function KillBots(int Num)
{
	return;
}

exec function AdminSay(string msg)
{
	local Controller C;

	C = Level.ControllerList;
	J0x14:

	if(NotEqual_ObjectObject(C, none))
	{
		if(C.IsA('PlayerController'))
		{
			PlayerController(C).ClearProgressMessages();
			PlayerController(C).SetProgressTime(6.0000000);
			PlayerController(C).SetProgressMessage(0, msg, Class'Engine.Canvas'.static.MakeColor(byte(255), byte(255), byte(255)));
		}
		C = C.nextController;
		// [Loop Continue]
		goto J0x14;
	}
	return;
}

function int GetNumSpawnedOfficers()
{
	return 0;
	return;
}

function bool CampaignObjectivesAreInEffect()
{
	return false;
	return;
}

function int NumberOfPlayersForServerBrowser()
{
	return;
}

function int MaxPlayersForServerBrowser()
{
	return;
}

function string GetGameModeName()
{
	return;
}

function bool GameIsPasswordProtected()
{
	return;
}

function string GetPlayerName(PlayerController PC)
{
	return;
}

function int GetPlayerScore(PlayerController PC)
{
	return;
}

function int GetPlayerPing(PlayerController PC)
{
	return;
}

function bool UsingCustomScenario()
{
	return;
}

defaultproperties
{
	bRestartLevel=true
	bPauseable=true
	bCanChangeSkin=true
	bCanViewOthers=true
	bDelayedStart=true
	bChangeLevels=true
	bAllowWeaponThrowing=true
	bAdminCanPause=true
	GameDifficulty=1.0000000
	AutoAim=0.9300000
	GameSpeed=1.0000000
	HUDType="Engine.HUD"
	MaxSpectators=2
	MaxPlayers=16
	DefaultPlayerName="Player"
	GameName="Game"
	FearCostFallOff=0.9500000
	DeathMessageClass=Class'Engine.LocalMessage'
	GameMessageClass=Class'Engine.GameMessage'
	MutatorClass="Engine.Mutator"
	AccessControlClass="Engine.AccessControl"
	BroadcastHandlerClass="Engine.BroadcastHandler"
	PlayerControllerClassName="SwatGame.SwatEntryPlayerController"
	GameReplicationInfoClass=Class'Engine.GameReplicationInfo'
	GameStatsClass="Engine.GameStats"
	SecurityClass="Engine.Security"
	Acronym="???"
}