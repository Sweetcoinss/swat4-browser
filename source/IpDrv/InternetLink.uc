class InternetLink extends InternetInfo
	transient
	native
	config
	hidecategories(Karma,Movement,Collision,Lighting,LightColor,Karma,Force);

cpptext
{
	AInternetLink();
	void Destroy();
	UBOOL Tick( FLOAT DeltaTime, enum ELevelTick TickType );
	SOCKET& GetSocket()
	{
		return *(SOCKET*)&Socket;
	}
	FResolveInfo*& GetResolveInfo()
	{
		return *(FResolveInfo**)&PrivateResolveInfo;
	}

}

enum ELinkMode
{
	MODE_Text,                      // 0
	MODE_Line,                      // 1
	MODE_Binary                     // 2
};

enum EReceiveMode
{
	RMODE_Manual,                   // 0
	RMODE_Event                     // 1
};

struct IpAddr
{
	var int Addr;
	var int Port;
};

var InternetLink.ELinkMode LinkMode;
var const int Socket;
var const int Port;
var const int RemoteSocket;
var private native const int PrivateResolveInfo;
var const int DataPending;
var InternetLink.EReceiveMode ReceiveMode;

// Export UInternetLink::execIsDataPending(FFrame&, void* const)
native function bool IsDataPending();

// Export UInternetLink::execParseURL(FFrame&, void* const)
native function bool ParseURL(coerce string URL, out string Addr, out int Port, out string LevelName, out string EntryName);

// Export UInternetLink::execResolve(FFrame&, void* const)
native function Resolve(coerce string Domain);

// Export UInternetLink::execGetLastError(FFrame&, void* const)
native function int GetLastError();

// Export UInternetLink::execIpAddrToString(FFrame&, void* const)
native function string IpAddrToString(IpAddr Arg);

// Export UInternetLink::execStringToIpAddr(FFrame&, void* const)
native function bool StringToIpAddr(string Str, out IpAddr Addr);

// Export UInternetLink::execGameSpyValidate(FFrame&, void* const)
native function string GameSpyValidate(string ValidationString);

// Export UInternetLink::execGameSpyGameName(FFrame&, void* const)
native function string GameSpyGameName();

// Export UInternetLink::execGetLocalIP(FFrame&, void* const)
native function GetLocalIP(out IpAddr Arg);

event Resolved(IpAddr Addr)
{
	return;
}

event ResolveFailed()
{
	return;
}
