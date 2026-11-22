class MasterServerUplink extends MasterServerLink
	transient
	native
	config
	hidecategories(Karma,Movement,Collision,Lighting,LightColor,Karma,Force);

cpptext
{
	// AActor interface
	void Destroy();
	void PostScriptDestroyed();
	// AServerQueryLink interface
	UBOOL Poll( INT WaitTime );

}

enum EServerToMaster
{
	STM_ClientResponse,             // 0
	STM_GameState,                  // 1
	STM_Stats,                      // 2
	STM_ClientDisconnectFailed,     // 3
	STM_MD5Version                  // 4
};

enum EMasterToServer
{
	MTS_ClientChallenge,            // 0
	MTS_ClientAuthFailed,           // 1
	MTS_Shutdown,                   // 2
	MTS_MatchID,                    // 3
	MTS_MD5Update                   // 4
};

enum EHeartbeatType
{
	HB_QueryInterface,              // 0
	HB_GamePort,                    // 1
	HB_GamespyQueryPort             // 2
};

struct native export MD5UpdateData
{
	var string Guid;
	var string MD5;
	var int Revision;
};

var ServerResponseLine ServerState;
var MasterServerGameStats GameStats;
var UdpLink GamespyQueryLink;
var const int MatchID;
var float ReconnectTime;
var bool bReconnectPending;
var globalconfig bool DoUplink;
var globalconfig bool UplinkToGamespy;
var globalconfig bool SendStats;
var globalconfig bool ServerBehindNAT;
var globalconfig bool DoLANBroadcast;

// Export UMasterServerUplink::execReconnect(FFrame&, void* const)
native function Reconnect();

event BeginPlay()
{
	local UdpGamespyQuery GamespyQuery;
	local UdpGamespyUplink GamespyUplink;

	if(DoUplink)
	{
		if(UplinkToGamespy)
		{
			GamespyQuery = Spawn(Class'IpDrv.UdpGamespyQuery');
			GamespyUplink = Spawn(Class'IpDrv.UdpGamespyUplink');
			GamespyQueryLink = GamespyQuery;
		}
		if(SendStats)
		{
			foreach AllActors(Class'IpDrv.MasterServerGameStats', GameStats)
			{
				if(EqualEqual_ObjectObject(GameStats.Uplink, none))
				{
					GameStats.Uplink = self;
				}
				else
				{
					GameStats = none;
				}
				break;
			}
			if(EqualEqual_ObjectObject(GameStats, none))
			{
				Log("MasterServerUplink: MasterServerGameStats not found - stats uploading disabled.");
			}
		}
	}
	Reconnect();
	return;
}

event ConnectionFailed(bool bShouldReconnect)
{
	Log("Master server connection failed");
	bReconnectPending = bShouldReconnect;
	ReconnectTime = 0.0000000;
	return;
}

event Refresh()
{
	Level.Game.GetServerInfo(ServerState);
	Level.Game.GetServerDetails(ServerState);
	Level.Game.GetServerPlayers(ServerState);
	return;
}

// Export UMasterServerUplink::execLogStatLine(FFrame&, void* const)
native event bool LogStatLine(string StatLine);

simulated function Tick(float Delta)
{
	super.Tick(Delta);
	ReconnectTime = Add_FloatFloat(ReconnectTime, Delta);
	if(bReconnectPending)
	{
		if(Greater_FloatFloat(ReconnectTime, 10.0000000))
		{
			Log("Attempting to reconnect to master server");
			bReconnectPending = false;
			Reconnect();
		}
	}
	return;
}

defaultproperties
{
	SendStats=true
}