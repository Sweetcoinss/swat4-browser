class ServerSettings extends ReplicationInfo
	config(SwatGuiState)
	hidecategories(Karma,Movement,Collision,Lighting,LightColor,Karma,Force);

const MAX_MAPS = 40;

var() config string Maps[40];
var() config int NumMaps;
var() config Repo.EMPMode GameType "What game type the server is running";
var() config int MapIndex "What map is currently being used";
var() config int NumRounds "How many rounds to play per map";
var() config int MaxPlayers "Maximum number of players allowed on this server";
var() config int RoundNumber "What is the current round number";
var() config int DeathLimit "How many deaths are required to lose a round (0 = No Death Limit)";
var() config int PostGameTimeLimit "Time between the end of the round and server loading the next level";
var() config int RoundTimeLimit "Time limit for each round (in seconds) (0 = No Time Limit)";
var() config int MPMissionReadyTime "Time (in seconds) for players to ready themselves in between rounds in a MP game";
var() config bool bShowTeammateNames "If true, will display teammates names";
var() config bool bShowEnemyNames "If true, will display enemy names";
var() config bool bNoRespawn "If true, the server will not respawn players";
var() config bool bQuickRoundReset "If true, the server will perform a quick reset in between rounds on the same map; if false, the server will do a full SwitchLevel between rounds";
var() config float FriendlyFireAmount "The damage modifier for friendly fire [0...1]";
var() config float EnemyFireAmount "The damage modifier for enemy fire [0...1]";
var() config SwatStartPointBase.EEntryType DesiredMPEntryPoint "Desired entry point for MP-coop games";
var() config localized string ServerName "Name of the server for display purposes";
var config string Password "Password for the server for authenticating users";
var() config bool bPassworded "If true, the server is passworded";
var() config bool bLAN "If true, the server is hosted only over the LAN (not internet)";
var() bool bDirty;

replication
{
	// Pos:0x000
	reliable if(AndAnd_BoolBool(bNetDirty, EqualEqual_IntInt(int(Role), int(ROLE_Authority))))
		DeathLimit, DesiredMPEntryPoint,
		EnemyFireAmount, FriendlyFireAmount,
		GameType, MPMissionReadyTime,
		MapIndex, Maps,
		MaxPlayers, NumMaps,
		NumRounds, Password,
		PostGameTimeLimit, RoundNumber,
		RoundTimeLimit, ServerName,
		bLAN, bNoRespawn,
		bPassworded, bQuickRoundReset,
		bShowEnemyNames, bShowTeammateNames;
}

function PreBeginPlay()
{
	super(Actor).PreBeginPlay();
	LoadMapListForGameType();
	return;
}

function SetAdminServerSettings(PlayerController PC, string newServerName, string newPassword, bool newbPassworded, bool newbLAN)
{
	Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self), "::SetAdminServerSettings( "), string(PC)), ", ServerName="), newServerName), ", Password="), newPassword), ", bPassworded="), string(newbPassworded)), ", bLAN="), string(newbLAN)), " )"));
	if(AndAnd_BoolBool(Level.Game.IsA('SwatGameInfo'), Not_PreBool(SwatGameInfo(Level.Game).Admin.IsAdmin(PC))))
	{
		return;
	}
	ServerName = newServerName;
	Password = newPassword;
	bPassworded = newbPassworded;
	bLAN = newbLAN;
	return;
}

function SetServerSettings(PlayerController PC, Repo.EMPMode newGameType, int newMapIndex, int newNumRounds, int newMaxPlayers, int newDeathLimit, int newPostGameTimeLimit, int newRoundTimeLimit, int newMPMissionReadyTime, bool newbShowTeammateNames, bool newbShowEnemyNames, bool newbNoRespawn, bool newbQuickRoundReset, float newFriendlyFireAmount, float newEnemyFireAmount, SwatStartPointBase.EEntryType newDesiredMPEntryPoint)
{
	Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self), "::SetServerSettings( "), string(PC)), ", newGameType="), string(GetEnum(Enum'Engine.Repo.EMPMode', int(newGameType)))), ", newMapIndex="), string(newMapIndex)), ", newNumRounds="), string(newNumRounds)), ", newMaxPlayers="), string(newMaxPlayers)), ", newDeathLimit="), string(newDeathLimit)), ", newPostGameTimeLimit="), string(newPostGameTimeLimit)), ", newRoundTimeLimit="), string(newRoundTimeLimit)), ", newMPMissionReadyTime="), string(newMPMissionReadyTime)), ", newbShowTeammateNames="), string(newbShowTeammateNames)), ", newbShowEnemyNames="), string(newbShowEnemyNames)), ", newbNoRespawn="), string(newbNoRespawn)), ", newbQuickRoundReset="), string(newbQuickRoundReset)), ", newFriendlyFireAmount="), string(newFriendlyFireAmount)), ", newEnemyFireAmount="), string(newEnemyFireAmount)), ", newDesiredMPEntryPoint="), string(GetEnum(Enum'SwatGame.SwatStartPointBase.EEntryType', int(newDesiredMPEntryPoint)))), " )"));
	if(AndAnd_BoolBool(Level.Game.IsA('SwatGameInfo'), Not_PreBool(SwatGameInfo(Level.Game).Admin.IsAdmin(PC))))
	{
		return;
	}
	GameType = newGameType;
	MapIndex = newMapIndex;
	NumRounds = newNumRounds;
	MaxPlayers = newMaxPlayers;
	DeathLimit = newDeathLimit;
	PostGameTimeLimit = newPostGameTimeLimit;
	RoundTimeLimit = newRoundTimeLimit;
	MPMissionReadyTime = newMPMissionReadyTime;
	bShowTeammateNames = newbShowTeammateNames;
	bShowEnemyNames = newbShowEnemyNames;
	bNoRespawn = newbNoRespawn;
	bQuickRoundReset = newbQuickRoundReset;
	FriendlyFireAmount = newFriendlyFireAmount;
	EnemyFireAmount = newEnemyFireAmount;
	DesiredMPEntryPoint = newDesiredMPEntryPoint;
	RoundNumber = 0;
	Log(Concat_StrStr(string(self), "::SetServerSettings(...) ... saving config"));
	SaveMapListForGameType();
	SaveConfig();
	SwatGameInfo(Level.Game).OnServerSettingsUpdated(PC);
	return;
}

function AddMap(PlayerController PC, string MapName)
{
	if(AndAnd_BoolBool(Level.Game.IsA('SwatGameInfo'), Not_PreBool(SwatGameInfo(Level.Game).Admin.IsAdmin(PC))))
	{
		return;
	}
	if(GreaterEqual_IntInt(NumMaps, 40))
	{
		return;
	}
	Maps[NumMaps] = MapName;
	AddAdd_Int(NumMaps);
	return;
}

function ClearMaps(PlayerController PC)
{
	local int i;

	if(AndAnd_BoolBool(Level.Game.IsA('SwatGameInfo'), Not_PreBool(SwatGameInfo(Level.Game).Admin.IsAdmin(PC))))
	{
		return;
	}
	i = 0;
	J0x58:

	if(Less_IntInt(i, 40))
	{
		Maps[i] = "";
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x58;
	}
	NumMaps = 0;
	return;
}

function SetDirty(PlayerController PC)
{
	if(AndAnd_BoolBool(Level.Game.IsA('SwatGameInfo'), Not_PreBool(SwatGameInfo(Level.Game).Admin.IsAdmin(PC))))
	{
		return;
	}
	bDirty = true;
	return;
}

private function SaveMapListForGameType()
{
	local MapRotation MapRotation;
	local int i;

	MapRotation = SwatRepo(Level.GetRepo()).GuiConfig.MapList[int(GameType)];
	i = 0;
	J0x3B:

	if(Less_IntInt(i, 40))
	{
		MapRotation.Maps[i] = Maps[i];
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x3B;
	}
	MapRotation.SaveConfig();
	return;
}

private function LoadMapListForGameType()
{
	local MapRotation MapRotation;
	local int i;

	MapRotation = SwatRepo(Level.GetRepo()).GuiConfig.MapList[int(GameType)];
	i = 0;
	J0x3B:

	if(Less_IntInt(i, 40))
	{
		Maps[i] = MapRotation.Maps[i];
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x3B;
	}
	return;
}

defaultproperties
{
	EnemyFireAmount=1.0000000
	bShouldReplicateDefaultProperties=true
}