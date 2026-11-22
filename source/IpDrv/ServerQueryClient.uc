class ServerQueryClient extends MasterServerLink
	transient
	native
	config
	hidecategories(Karma,Movement,Collision,Lighting,LightColor,Karma,Force);

cpptext
{
	// AActor interface
	void Destroy();
	void PostScriptDestroyed();
	// MasterServerLink interface
	UBOOL Poll( INT WaitTime );
	// ServerQueryClient interface
	void Init();

}

enum EQueryInterfaceCommand
{
	QI_Ping,                        // 0
	QI_Rules,                       // 1
	QI_Players,                     // 2
	QI_RulesAndPlayers,             // 3
	QI_SmallPing                    // 4
};

enum EPingCause
{
	PC_Unknown,                     // 0
	PC_Clicked,                     // 1
	PC_AutoPing,                    // 2
	PC_LANBroadcast                 // 3
};

var bool bLANQuery;
//var delegate<OnReceivedPingInfo> __OnReceivedPingInfo__Delegate;
//var delegate<OnPingTimeout> __OnPingTimeout__Delegate;
//var delegate<OnAllServersReturned> __OnAllServersReturned__Delegate;

delegate OnReceivedPingInfo(int ListID, ServerQueryClient.EPingCause PingCause, ServerResponseLine S)
{
	return;
}

delegate OnPingTimeout(int ListID, ServerQueryClient.EPingCause PingCause)
{
	return;
}

delegate OnAllServersReturned()
{
	return;
}

// Export UServerQueryClient::execPingServer(FFrame&, void* const)
native function PingServer(int ListID, ServerQueryClient.EPingCause PingCause, string IP, int Port, ServerQueryClient.EQueryInterfaceCommand Command, ServerResponseLine CurrentState);

// Export UServerQueryClient::execCancelPings(FFrame&, void* const)
native function CancelPings();

function BroadcastPingRequest()
{
	local ServerResponseLine temp;

	if(GreaterEqual_IntInt(Class'IpDrv.MasterServerUplink'.default.LANServerPort, 0))
	{
		PingServer(-1, 3, "BROADCAST", Class'IpDrv.MasterServerUplink'.default.LANServerPort, 0, temp);
	}
	return;
}
