class MasterServerLink extends Info
	transient
	native
	config
	hidecategories(Karma,Movement,Collision,Lighting,LightColor,Karma,Force);

cpptext
{
	virtual UBOOL Poll( INT WaitTime ) { return 0; }

}

var native const int LinkPtr;
var globalconfig int LANPort;
var globalconfig int LANServerPort;
var globalconfig int CurrentMasterServer;
var globalconfig int MasterServerPort[5];
var globalconfig string MasterServerAddress[5];

// Export UMasterServerLink::execPoll(FFrame&, void* const)
native function bool Poll(int WaitTime);

event GetMasterServer(out string OutAddress, out int OutPort)
{
	if(OrOr_BoolBool(OrOr_BoolBool(OrOr_BoolBool(OrOr_BoolBool(Less_IntInt(CurrentMasterServer, 0), GreaterEqual_IntInt(CurrentMasterServer, 5)), GreaterEqual_IntInt(CurrentMasterServer, 5)), EqualEqual_StrStr(MasterServerAddress[CurrentMasterServer], "")), EqualEqual_IntInt(MasterServerPort[CurrentMasterServer], 0)))
	{
		CurrentMasterServer = 0;
	}
	if(OrOr_BoolBool(EqualEqual_StrStr(MasterServerAddress[0], ""), EqualEqual_IntInt(MasterServerPort[0], 0)))
	{
		Log("Warning: No master servers found in the INI file");
		OutAddress = "ut2003master1.epicgames.com";
		OutPort = 28902;
	}
	else
	{
		OutAddress = MasterServerAddress[CurrentMasterServer];
		OutPort = MasterServerPort[CurrentMasterServer];
	}
	return;
}

simulated function Tick(float Delta)
{
	Poll(0);
	return;
}

defaultproperties
{
	LANPort=10489
	LANServerPort=9999
	MasterServerPort[0]=28902
	MasterServerPort[1]=28902
	MasterServerAddress[0]="ut2003master1.epicgames.com"
	MasterServerAddress[1]="ut2003master1.epicgames.com"
	bAlwaysTick=true
}