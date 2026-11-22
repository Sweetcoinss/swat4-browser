class UdpGamespyUplink extends UdpLink
	transient
	config
	hidecategories(Karma,Movement,Collision,Lighting,LightColor,Karma,Force);

var config int UpdateMinutes;
var string MasterServerAddress;
var config int MasterServerPort;
var config int ServerRegion;
var name TargetQueryName;
var IpAddr MasterServerIpAddr;
var string HeartbeatMessage;
var UdpGamespyQuery Query;
var int CurrentQueryNum;

function PreBeginPlay()
{
	foreach AllActors(Class'IpDrv.UdpGamespyQuery', Query, TargetQueryName)
	{
		break;
	}
	if(EqualEqual_ObjectObject(Query, none))
	{
		Log("UdpGameSpyUplink: Could not find a UdpGameSpyQuery object, aborting.");
		return;
	}
	HeartbeatMessage = Concat_StrStr(Concat_StrStr(Concat_StrStr("\\heartbeat\\", string(Query.Port)), "\\gamename\\"), GameSpyGameName());
	MasterServerIpAddr.Port = MasterServerPort;
	if(EqualEqual_StrStr(MasterServerAddress, ""))
	{
		MasterServerAddress = Concat_StrStr(Concat_StrStr("master", string(ServerRegion)), ".gamespy.com");
	}
	Resolve(MasterServerAddress);
	return;
}

function Resolved(IpAddr Addr)
{
	local int UplinkPort;

	MasterServerIpAddr.Addr = Addr.Addr;
	if(EqualEqual_IntInt(MasterServerIpAddr.Addr, 0))
	{
		Log("UdpGameSpyUplink: Invalid master server address, aborting.");
		return;
	}
	Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("UdpGameSpyUplink: Master Server is ", MasterServerAddress), ":"), string(MasterServerIpAddr.Port)));
	UplinkPort = Add_IntInt(Query.Port, 1);
	if(EqualEqual_IntInt(BindPort(UplinkPort, true), 0))
	{
		Log("UdpGameSpyUplink: Error binding port, aborting.");
		return;
	}
	Log(Concat_StrStr(Concat_StrStr("UdpGameSpyUplink: Port ", string(UplinkPort)), " successfully bound."));
	Resume();
	return;
}

function ResolveFailed()
{
	Log("UdpGameSpyUplink: Failed to resolve master server address, aborting.");
	return;
}

function Timer()
{
	local bool Result;

	Result = SendText(MasterServerIpAddr, HeartbeatMessage);
	if(Not_PreBool(Result))
	{
		Log("Failed to send heartbeat to master server.");
	}
	return;
}

function Halt()
{
	SetTimer(0.0000000, false);
	return;
}

function Resume()
{
	SetTimer(float(Multiply_IntInt(UpdateMinutes, 60)), true);
	Timer();
	return;
}

event ReceivedText(IpAddr Addr, string Text)
{
	local string Query;
	local bool QueryRemaining;
	local int QueryNum, PacketNum;

	AddAdd_Int(CurrentQueryNum);
	if(Greater_IntInt(CurrentQueryNum, 100))
	{
		CurrentQueryNum = 1;
	}
	QueryNum = CurrentQueryNum;
	Query = Text;
	if(EqualEqual_StrStr(Query, ""))
	{
		QueryRemaining = false;
	}
	else
	{
		QueryRemaining = true;
	}
	J0x4F:

	if(QueryRemaining)
	{
		Query = ParseQuery(Addr, Query, QueryNum, PacketNum);
		if(EqualEqual_StrStr(Query, ""))
		{
			QueryRemaining = false;
		}
		else
		{
			QueryRemaining = true;
		}
		// [Loop Continue]
		goto J0x4F;
	}
	return;
}

function bool ParseNextQuery(string Query, out string QueryType, out string QueryValue, out string QueryRest, out string FinalPacket)
{
	local string TempQuery;
	local int ClosingSlash;

	if(EqualEqual_StrStr(Query, ""))
	{
		return false;
	}
	if(EqualEqual_StrStr(Left(Query, 1), "\\"))
	{
		ClosingSlash = InStr(Right(Query, Subtract_IntInt(Len(Query), 1)), "\\");
		if(EqualEqual_IntInt(ClosingSlash, 0))
		{
			return false;
		}
		TempQuery = Query;
		QueryType = Right(Query, Subtract_IntInt(Len(Query), 1));
		QueryType = Left(QueryType, ClosingSlash);
		QueryRest = Right(Query, Subtract_IntInt(Len(Query), Add_IntInt(Len(QueryType), 2)));
		if(OrOr_BoolBool(EqualEqual_StrStr(QueryRest, ""), EqualEqual_IntInt(Len(QueryRest), 1)))
		{
			FinalPacket = "final";
			return true;
		}
		else
		{
			if(EqualEqual_StrStr(Left(QueryRest, 1), "\\"))
			{
				return true;
			}
		}
		ClosingSlash = InStr(QueryRest, "\\");
		if(GreaterEqual_IntInt(ClosingSlash, 0))
		{
			QueryValue = Left(QueryRest, ClosingSlash);
		}
		else
		{
			QueryValue = QueryRest;
		}
		QueryRest = Right(Query, Subtract_IntInt(Len(Query), Add_IntInt(Add_IntInt(Len(QueryType), Len(QueryValue)), 3)));
		if(EqualEqual_StrStr(QueryRest, ""))
		{
			FinalPacket = "final";
			return true;
		}
		else
		{
			return true;
		}
	}
	else
	{
		return false;
	}
	return;
}

function string ParseQuery(IpAddr Addr, coerce string QueryStr, int QueryNum, out int PacketNum)
{
	local string QueryType, QueryValue, QueryRest, ValidationString;
	local bool Result;
	local string FinalPacket;

	Result = ParseNextQuery(QueryStr, QueryType, QueryValue, QueryRest, FinalPacket);
	if(Not_PreBool(Result))
	{
		return "";
	}
	if(EqualEqual_StrStr(QueryType, "basic"))
	{
		Result = true;
	}
	else
	{
		if(EqualEqual_StrStr(QueryType, "secure"))
		{
			ValidationString = Concat_StrStr("\\validate\\", GameSpyValidate(QueryValue));
			Result = SendQueryPacket(Addr, ValidationString, QueryNum, AddAdd_PreInt(PacketNum), FinalPacket);
		}
	}
	return QueryRest;
	return;
}

function bool SendQueryPacket(IpAddr Addr, coerce string SendString, int QueryNum, int PacketNum, string FinalPacket)
{
	local bool Result;

	if(EqualEqual_StrStr(FinalPacket, "final"))
	{
		SendString = Concat_StrStr(SendString, "\\final\\");
	}
	SendString = Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(SendString, "\\queryid\\"), string(QueryNum)), "."), string(PacketNum));
	Result = SendText(Addr, SendString);
	return Result;
	return;
}

defaultproperties
{
	UpdateMinutes=1
	MasterServerPort=27900
	TargetQueryName="MasterUplink"
}