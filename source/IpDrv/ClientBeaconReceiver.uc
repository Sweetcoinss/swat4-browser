class ClientBeaconReceiver extends UdpBeacon
	transient
	config
	hidecategories(Karma,Movement,Collision,Lighting,LightColor,Karma,Force);

struct BeaconInfo
{
	var() IpAddr Addr;
	var() float Time;
	var() string Text;
};

var editinline BeaconInfo Beacons[32];

function int GetBeaconCount()
{
	return 32;
	return;
}

function string GetBeaconAddress(int i)
{
	return IpAddrToString(Beacons[i].Addr);
	return;
}

function string GetBeaconText(int i)
{
	return Beacons[i].Text;
	return;
}

function BeginPlay()
{
	if(Greater_IntInt(BindPort(BeaconPort, true), 0))
	{
		SetTimer(1.0000000, true);
	}
	else
	{
		Warn("ClientBeaconReceiver failed: Beacon port in use.");
	}
	return;
}

function Timer()
{
	local int i, j;

	j = 0;
	i = 0;
	J0x0E:

	if(Less_IntInt(i, 32))
	{
		if(EqualEqual_IntInt(Beacons[i].Addr.Addr, 0))
		{
			// [Explicit Continue]
			goto J0x92;
		}
		if(GreaterEqual_FloatFloat(Subtract_FloatFloat(Level.TimeSeconds, Beacons[i].Time), BeaconTimeout))
		{
			// [Explicit Continue]
			goto J0x92;
		}
		if(NotEqual_IntInt(i, j))
		{
			Beacons[j] = Beacons[i];
		}
		AddAdd_Int(j);
		J0x92:

		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x0E;
	}
	J0x9C:

	if(Less_IntInt(j, 32))
	{
		Beacons[j].Addr.Addr = 0;
		Beacons[j].Addr.Port = 0;
		Beacons[j].Text = "";
		AddAdd_Int(j);
		// [Loop Continue]
		goto J0x9C;
	}
	BroadcastQuery();
	return;
}

function BroadcastQuery()
{
	local IpAddr Addr;

	Addr.Addr = BroadcastAddr;
	Addr.Port = ServerBeaconPort;
	SendText(Addr, "REPORT");
	return;
}

event ReceivedText(IpAddr Addr, string Text)
{
	local int i, n;
	local string Product;

	n = Len(BeaconProduct);
	Product = Left(Text, Add_IntInt(n, 1));
	if(Not_PreBool(ComplementEqual_StrStr(Product, Concat_StrStr(BeaconProduct, " "))))
	{
		return;
	}
	Text = Mid(Text, Add_IntInt(n, 1));
	Addr.Port = int(Text);
	i = 0;
	J0x68:

	if(Less_IntInt(i, 32))
	{
		if(Beacons[i].Addr == Addr)
		{
			// [Explicit Break]
			goto J0x9E;
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x68;
	}
	J0x9E:

	if(EqualEqual_IntInt(i, 32))
	{
		i = 0;
		J0xB1:

		if(Less_IntInt(i, 32))
		{
			if(EqualEqual_IntInt(Beacons[i].Addr.Addr, 0))
			{
				// [Explicit Break]
				goto J0xE5;
			}
			AddAdd_Int(i);
			// [Loop Continue]
			goto J0xB1;
		}
	}
	J0xE5:

	if(EqualEqual_IntInt(i, 32))
	{
		return;
	}
	Beacons[i].Addr = Addr;
	Beacons[i].Time = Level.TimeSeconds;
	Beacons[i].Text = Mid(Text, Add_IntInt(InStr(Text, " "), 1));
	return;
}
