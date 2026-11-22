class GameSpyManager extends Object
	native;

enum EGSProfileResult
{
	CPR_VALID,                      // 0
	CPR_BAD_EMAIL,                  // 1
	CPR_BAD_PASSWORD,               // 2
	CPR_BAD_NICK                    // 3
};

var GameEngine Engine;
var const bool bAvailable;
var const bool bFailedAvailabilityCheck;
var const bool bInitAsServer;
var const bool bInitAsClient;
var const bool bInitialised;
var const bool bFailedInitialisation;
var bool bServer;
var const bool bTrackingStats;
var const bool bStatsInitalised;
var const bool bUsingPresence;
var const bool bPresenceInitalised;
var const bool bServerUpdateFinished;
var const int currentServerIndex;
var array<byte> ServerKeyIds;
var array<string> ServerKeyNames;
var array<byte> PlayerKeyIds;
var array<string> PlayerKeyNames;
var array<byte> TeamKeyIds;
var array<string> TeamKeyNames;
var array<byte> CustomServerKeyIds;
var array<string> CustomServerKeyNames;
var array<byte> CustomPlayerKeyIds;
var array<string> CustomPlayerKeyNames;
var array<byte> CustomTeamKeyIds;
var array<string> CustomTeamKeyNames;

// Export UGameSpyManager::execInitGameSpyClient(FFrame&, void* const)
native final function InitGameSpyClient();

event GameSpyInitialised()
{
	return;
}

event InitGameSpyData()
{
	return;
}

// Export UGameSpyManager::execGetLevelInfo(FFrame&, void* const)
native final function LevelInfo GetLevelInfo();

// Export UGameSpyManager::execGetPlayerObject(FFrame&, void* const)
native final function Player GetPlayerObject();

// Export UGameSpyManager::execUpdateServerList(FFrame&, void* const)
native final function UpdateServerList(optional string filter);

// Export UGameSpyManager::execLANUpdateServerList(FFrame&, void* const)
native final function LANUpdateServerList();

// Export UGameSpyManager::execUpdateServer(FFrame&, void* const)
native final function UpdateServer(int ServerID, bool Refresh);

// Export UGameSpyManager::execCancelUpdate(FFrame&, void* const)
native final function CancelUpdate();

// Export UGameSpyManager::execGetServerIpAddress(FFrame&, void* const)
native final function string GetServerIpAddress(int ServerID);

// Export UGameSpyManager::execGetServerPort(FFrame&, void* const)
native final function string GetServerPort(int ServerID);

// Export UGameSpyManager::execGetNextServer(FFrame&, void* const)
native final function bool GetNextServer(out int ServerID, out string ipAddress, out array<string> serverData);

// Export UGameSpyManager::execStatsNewGameStarted(FFrame&, void* const)
native final function StatsNewGameStarted();

// Export UGameSpyManager::execStatsHasPIDAndResponse(FFrame&, void* const)
native final function bool StatsHasPIDAndResponse(PlayerController PC);

// Export UGameSpyManager::execStatsGetPID(FFrame&, void* const)
native final function string StatsGetPID(PlayerController PC);

// Export UGameSpyManager::execStatsGetStatResponse(FFrame&, void* const)
native final function string StatsGetStatResponse(PlayerController PC);

// Export UGameSpyManager::execStatsNewPlayer(FFrame&, void* const)
native final function StatsNewPlayer(int PlayerID, string PlayerName);

// Export UGameSpyManager::execStatsNewTeam(FFrame&, void* const)
native final function StatsNewTeam(int TeamID, string TeamName);

// Export UGameSpyManager::execStatsRemovePlayer(FFrame&, void* const)
native final function StatsRemovePlayer(int PlayerID);

// Export UGameSpyManager::execStatsRemoveTeam(FFrame&, void* const)
native final function StatsRemoveTeam(int TeamID);

// Export UGameSpyManager::execSetServerStat(FFrame&, void* const)
native final function SetServerStat(coerce string statName, coerce string statValue);

// Export UGameSpyManager::execSetPlayerStat(FFrame&, void* const)
native final function SetPlayerStat(coerce string statName, coerce string statValue, int PlayerID);

// Export UGameSpyManager::execSetTeamStat(FFrame&, void* const)
native final function SetTeamStat(coerce string statName, coerce string statValue, int TeamID);

// Export UGameSpyManager::execSendStatSnapshot(FFrame&, void* const)
native final function SendStatSnapshot(optional bool finalSnapshot);

event UpdatedServerData(int ServerID, string ipAddress, int Ping, array<string> serverData, array<string> playerData, array<string> teamData)
{
	return;
}

event UpdateComplete()
{
	return;
}

event string GetValueForKey(int Key)
{
	return;
}

event string GetValueForPlayerKey(int Key, int Index)
{
	return;
}

event string GetValueForTeamKey(int Key, int Index)
{
	return;
}

event int GetNumTeams()
{
	return 0;
	return;
}

event string GetGameSpyProfileId()
{
	return;
}

event string GetGameSpyPassword()
{
	return;
}

event EmailAlreadyTaken()
{
	return;
}

event ProfileCreateResult(GameSpyManager.EGSProfileResult Result, int profileId)
{
	return;
}

event ProfileCheckResult(GameSpyManager.EGSProfileResult Result, int profileId)
{
	return;
}

event bool ShouldCheckClientCDKeys()
{
	assert(false);
	return false;
	return;
}

// Export UGameSpyManager::execCleanUpGameSpy(FFrame&, void* const)
native final function CleanUpGameSpy();

event int ShouldAdvertiseServerOnInternet()
{
	return;
}

// Export UGameSpyManager::execSendServerStateChanged(FFrame&, void* const)
native final function SendServerStateChanged();

// Export UGameSpyManager::execIsHostCDKeyValid(FFrame&, void* const)
native final function bool IsHostCDKeyValid();
