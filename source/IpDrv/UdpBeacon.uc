class UdpBeacon extends UdpLink
	transient
	config
	hidecategories(Karma,Movement,Collision,Lighting,LightColor,Karma,Force);

var globalconfig bool DoBeacon;
var globalconfig int ServerBeaconPort;
var globalconfig int BeaconPort;
var globalconfig float BeaconTimeout;
var globalconfig string BeaconProduct;
var int UdpServerQueryPort;
var int boundport;

function BeginPlay()
{
	local IpAddr Addr;

	boundport = BindPort(ServerBeaconPort, true);
	if(EqualEqual_IntInt(boundport, 0))
	{
		Log("UdpBeacon failed to bind a port.");
		return;
	}
	Addr.Addr = BroadcastAddr;
	Addr.Port = BeaconPort;
	BroadcastBeacon(Addr);
	return;
}

function BroadcastBeacon(IpAddr Addr)
{
	SendText(Addr, At_StrStr(At_StrStr(BeaconProduct, Mid(Level.GetAddressURL(), Add_IntInt(InStr(Level.GetAddressURL(), ":"), 1))), Level.Game.GetBeaconText()));
	return;
}

function BroadcastBeaconQuery(IpAddr Addr)
{
	SendText(Addr, At_StrStr(BeaconProduct, string(UdpServerQueryPort)));
	return;
}

event ReceivedText(IpAddr Addr, string Text)
{
	if(EqualEqual_StrStr(Text, "REPORT"))
	{
		BroadcastBeacon(Addr);
	}
	if(EqualEqual_StrStr(Text, "REPORTQUERY"))
	{
		BroadcastBeaconQuery(Addr);
	}
	return;
}

function Destroyed()
{
	super(Actor).Destroyed();
	return;
}

defaultproperties
{
	DoBeacon=true
	ServerBeaconPort=10487
	BeaconPort=10488
	BeaconTimeout=5.0000000
	BeaconProduct="unreal"
}