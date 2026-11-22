class SwatGameSpyManager extends GameSpyManager;

const MAX_REGISTERED_KEYS = 254;
const NUM_RESERVED_KEYS = 50;
const HOSTNAME_KEY = 1;
const GAMENAME_KEY = 2;
const GAMEVER_KEY = 3;
const HOSTPORT_KEY = 4;
const MAPNAME_KEY = 5;
const GAMETYPE_KEY = 6;
const GAMEVARIANT_KEY = 7;
const NUMPLAYERS_KEY = 8;
const NUMTEAMS_KEY = 9;
const MAXPLAYERS_KEY = 10;
const GAMEMODE_KEY = 11;
const TEAMPLAY_KEY = 12;
const FRAGLIMIT_KEY = 13;
const TEAMFRAGLIMIT_KEY = 14;
const TIMEELAPSED_KEY = 15;
const TIMELIMIT_KEY = 16;
const ROUNDTIME_KEY = 17;
const ROUNDELAPSED_KEY = 18;
const PASSWORD_KEY = 19;
const GROUPID_KEY = 20;
const PLAYER__KEY = 21;
const SCORE__KEY = 22;
const SKILL__KEY = 23;
const PING__KEY = 24;
const TEAM__KEY = 25;
const DEATHS__KEY = 26;
const PID__KEY = 27;
const TEAM_T_KEY = 28;
const SCORE_T_KEY = 29;

var private bool bShouldCheckClientCDKeys;
//var delegate<OnUpdatedServer> __OnUpdatedServer__Delegate;
//var delegate<OnGameSpyInitialised> __OnGameSpyInitialised__Delegate;

delegate OnUpdatedServer(ServerResponseLine Server)
{
	return;
}

delegate OnGameSpyInitialised()
{
	return;
}

event GameSpyInitialised()
{
	OnGameSpyInitialised();
	return;
}

function InitGameSpyData()
{
	MPLog("SwatGameSpyManager::InitGameSpyData().");
	ServerKeyIds[ServerKeyIds.Length] = 1;
	ServerKeyNames[ServerKeyNames.Length] = "hostname";
	ServerKeyIds[ServerKeyIds.Length] = 8;
	ServerKeyNames[ServerKeyNames.Length] = "numplayers";
	ServerKeyIds[ServerKeyIds.Length] = 10;
	ServerKeyNames[ServerKeyNames.Length] = "maxplayers";
	ServerKeyIds[ServerKeyIds.Length] = 6;
	ServerKeyNames[ServerKeyNames.Length] = "gametype";
	ServerKeyIds[ServerKeyIds.Length] = 7;
	ServerKeyNames[ServerKeyNames.Length] = "gamevariant";
	ServerKeyIds[ServerKeyIds.Length] = 5;
	ServerKeyNames[ServerKeyNames.Length] = "mapname";
	ServerKeyIds[ServerKeyIds.Length] = 4;
	ServerKeyNames[ServerKeyNames.Length] = "hostport";
	ServerKeyIds[ServerKeyIds.Length] = 19;
	ServerKeyNames[ServerKeyNames.Length] = "password";
	ServerKeyIds[ServerKeyIds.Length] = 3;
	ServerKeyNames[ServerKeyNames.Length] = "gamever";
	PlayerKeyIds[PlayerKeyIds.Length] = 21;
	PlayerKeyNames[PlayerKeyNames.Length] = "player_";
	PlayerKeyIds[PlayerKeyIds.Length] = 22;
	PlayerKeyNames[PlayerKeyNames.Length] = "score_";
	PlayerKeyIds[PlayerKeyIds.Length] = 24;
	PlayerKeyNames[PlayerKeyNames.Length] = "ping_";
	checkKeyIds();
	checkKeyNames();
	return;
}

function checkKeyIds()
{
	local int i;

	MPLog("SwatGameSpyManager::checkKeyIds().");
	assert(LessEqual_IntInt(Add_IntInt(Add_IntInt(Add_IntInt(Add_IntInt(Add_IntInt(ServerKeyIds.Length, PlayerKeyIds.Length), TeamKeyIds.Length), CustomServerKeyIds.Length), CustomPlayerKeyIds.Length), CustomTeamKeyIds.Length), 254));
	i = 0;
	J0x66:

	if(Less_IntInt(i, ServerKeyIds.Length))
	{
		assert(AndAnd_BoolBool(Greater_IntInt(int(ServerKeyIds[i]), 0), LessEqual_IntInt(int(ServerKeyIds[i]), 50)));
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x66;
	}
	i = 0;
	J0xB0:

	if(Less_IntInt(i, PlayerKeyIds.Length))
	{
		assert(AndAnd_BoolBool(Greater_IntInt(int(PlayerKeyIds[i]), 0), LessEqual_IntInt(int(PlayerKeyIds[i]), 50)));
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0xB0;
	}
	i = 0;
	J0xFA:

	if(Less_IntInt(i, TeamKeyIds.Length))
	{
		assert(AndAnd_BoolBool(Greater_IntInt(int(TeamKeyIds[i]), 0), LessEqual_IntInt(int(TeamKeyIds[i]), 50)));
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0xFA;
	}
	i = 0;
	J0x144:

	if(Less_IntInt(i, CustomServerKeyIds.Length))
	{
		assert(AndAnd_BoolBool(Greater_IntInt(int(CustomServerKeyIds[i]), 50), LessEqual_IntInt(int(CustomServerKeyIds[i]), 254)));
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x144;
	}
	i = 0;
	J0x18F:

	if(Less_IntInt(i, CustomPlayerKeyIds.Length))
	{
		assert(AndAnd_BoolBool(Greater_IntInt(int(CustomPlayerKeyIds[i]), 50), LessEqual_IntInt(int(CustomPlayerKeyIds[i]), 254)));
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x18F;
	}
	i = 0;
	J0x1DA:

	if(Less_IntInt(i, CustomTeamKeyIds.Length))
	{
		assert(AndAnd_BoolBool(Greater_IntInt(int(CustomTeamKeyIds[i]), 50), LessEqual_IntInt(int(CustomTeamKeyIds[i]), 254)));
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x1DA;
	}
	return;
}

function checkKeyNames()
{
	local int i;

	MPLog("SwatGameSpyManager::checkKeyNames().");
	i = 0;
	J0x33:

	if(Less_IntInt(i, ServerKeyNames.Length))
	{
		assert(AndAnd_BoolBool(NotEqual_StrStr(Right(ServerKeyNames[i], 1), "_"), NotEqual_StrStr(Right(ServerKeyNames[i], 2), "_t")));
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x33;
	}
	i = 0;
	J0x84:

	if(Less_IntInt(i, CustomServerKeyNames.Length))
	{
		assert(AndAnd_BoolBool(NotEqual_StrStr(Right(CustomServerKeyNames[i], 1), "_"), NotEqual_StrStr(Right(CustomServerKeyNames[i], 2), "_t")));
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x84;
	}
	i = 0;
	J0xD5:

	if(Less_IntInt(i, PlayerKeyNames.Length))
	{
		assert(EqualEqual_StrStr(Right(PlayerKeyNames[i], 1), "_"));
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0xD5;
	}
	i = 0;
	J0x10C:

	if(Less_IntInt(i, CustomPlayerKeyNames.Length))
	{
		assert(EqualEqual_StrStr(Right(CustomPlayerKeyNames[i], 1), "_"));
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x10C;
	}
	i = 0;
	J0x143:

	if(Less_IntInt(i, TeamKeyNames.Length))
	{
		assert(EqualEqual_StrStr(Right(TeamKeyNames[i], 2), "_t"));
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x143;
	}
	i = 0;
	J0x17C:

	if(Less_IntInt(i, CustomTeamKeyNames.Length))
	{
		assert(EqualEqual_StrStr(Right(CustomTeamKeyNames[i], 2), "_t"));
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x17C;
	}
	return;
}

function bool SwatGetNextServer(out ServerResponseLine Server)
{
	local array<string> serverData;
	local bool notDone;
	local KeyValuePair kvp;

	notDone = GetNextServer(Server.ServerID, Server.IP, serverData);
	if(NotEqual_IntInt(Server.ServerID, 0))
	{
		Server.ServerName = serverData[0];
		Server.CurrentPlayers = int(serverData[1]);
		Server.MaxPlayers = int(serverData[2]);
		Server.GameType = serverData[3];
		Server.ModName = serverData[4];
		Server.MapName = serverData[5];
		Server.Port = int(serverData[6]);
		kvp.Key = "password";
		kvp.Value = serverData[7];
		Server.ServerInfo[0] = kvp;
		Server.GameVersion = serverData[8];
	}
	return notDone;
	return;
}

event UpdatedServerData(int ServerID, string ipAddress, int Ping, array<string> serverData, array<string> playerData, array<string> teamData)
{
	local ServerResponseLine Server;
	local KeyValuePair kvp;

	assert(NotEqual_IntInt(ServerID, 0));
	if(NotEqual_IntInt(ServerID, 0))
	{
		Server.ServerID = ServerID;
		Server.IP = ipAddress;
		Server.ServerName = serverData[0];
		Server.CurrentPlayers = int(serverData[1]);
		Server.MaxPlayers = int(serverData[2]);
		Server.GameType = serverData[3];
		Server.ModName = serverData[4];
		Server.MapName = serverData[5];
		Server.Port = int(serverData[6]);
		kvp.Key = "password";
		kvp.Value = serverData[7];
		Server.ServerInfo[0] = kvp;
		Server.GameVersion = serverData[8];
		if(AndAnd_BoolBool(NotEqual_StrStr(Server.ModName, "swat4d"), NotEqual_StrStr(Server.ModName, "swat4")))
		{
			OnUpdatedServer(Server);
		}
	}
	return;
}

function UpdateComplete()
{
	MPLog("SwatGameSpyManager::UpdateComplete().");
	return;
}

function string GetValueForKey(int Key)
{
	switch(Key)
	{
		case 1:
			return GetLevelInfo().Game.GameReplicationInfo.ServerName;
		case 8:
			return string(GetLevelInfo().Game.NumberOfPlayersForServerBrowser());
		case 10:
			return string(GetLevelInfo().Game.MaxPlayersForServerBrowser());
		case 6:
			return GetLevelInfo().Game.GetGameModeName();
		case 7:
			return GetLevelInfo().ModName;
		case 5:
			if(NotEqual_ObjectObject(GetLevelInfo(), none))
			{
				return GetLevelInfo().Title;
			}
			break;
		case 4:
			return string(GetLevelInfo().Game.GetServerPort());
		case 19:
			if(GetLevelInfo().Game.GameIsPasswordProtected())
			{
				return "1";
			}
			else
			{
				return "0";
			}
		case 3:
			return GetLevelInfo().BuildVersion;
		default:
			break;
	}
	return "";
	return;
}

function string GetValueForPlayerKey(int Key, int Index)
{
	local PlayerController PC;

	PC = GetPlayerControllerFromIndex(Index);
	if(EqualEqual_ObjectObject(PC, none))
	{
		return "";
	}
	switch(Key)
	{
		case 21:
			return GetLevelInfo().Game.GetPlayerName(PC);
		case 22:
			return string(GetLevelInfo().Game.GetPlayerScore(PC));
		case 24:
			return string(Min(999, GetLevelInfo().Game.GetPlayerPing(PC)));
		default:
			return "";
			break;
	}
	return;
}

function PlayerController GetPlayerControllerFromIndex(int Index)
{
	local int i;
	local LevelInfo li;
	local Controller C;
	local PlayerController PC;

	li = GetLevelInfo();
	if(EqualEqual_ObjectObject(li, none))
	{
		return none;
	}
	i = 0;
	C = li.ControllerList;
	J0x34:

	if(NotEqual_ObjectObject(C, none))
	{
		PC = PlayerController(C);
		if(NotEqual_ObjectObject(PC, none))
		{
			if(EqualEqual_IntInt(i, Index))
			{
				return PC;
			}
			AddAdd_PreInt(i);
		}
		C = C.nextController;
		// [Loop Continue]
		goto J0x34;
	}
	return none;
	return;
}

event bool ShouldCheckClientCDKeys()
{
	return AndAnd_BoolBool(bInitAsServer, bShouldCheckClientCDKeys);
	return;
}

function SetShouldCheckClientCDKeys(bool NewValue)
{
	MPLog(Concat_StrStr("---SGSM::SetShouldCheckClientCDKeys(). Value=", string(NewValue)));
	bShouldCheckClientCDKeys = NewValue;
	return;
}

event int ShouldAdvertiseServerOnInternet()
{
	local Repo theRepo;

	theRepo = Engine.GetRepo();
	assert(NotEqual_ObjectObject(theRepo, none));
	if(theRepo.IsLANOnlyGame())
	{
		Log("ShouldAdvertiseServerOnInternet() returning 0");
		return 0;
	}
	else
	{
		Log("ShouldAdvertiseServerOnInternet() returning 1");
		return 1;
	}
	return;
}
