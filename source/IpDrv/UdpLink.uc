class UdpLink extends InternetLink
	transient
	native
	config
	hidecategories(Karma,Movement,Collision,Lighting,LightColor,Karma,Force);

cpptext
{
	AUdpLink();
	void PostScriptDestroyed();
	UBOOL Tick( FLOAT DeltaTime, enum ELevelTick TickType );
	FSocketData GetSocketData();

}

var const int BroadcastAddr;

// Export UUdpLink::execBindPort(FFrame&, void* const)
native function int BindPort(optional int Port, optional bool bUseNextAvailable);

// Export UUdpLink::execSendText(FFrame&, void* const)
native function bool SendText(IpAddr Addr, coerce string Str);

// Export UUdpLink::execSendBinary(FFrame&, void* const)
native function bool SendBinary(IpAddr Addr, int Count, byte B[255]);

// Export UUdpLink::execReadText(FFrame&, void* const)
native function int ReadText(out IpAddr Addr, out string Str);

// Export UUdpLink::execReadBinary(FFrame&, void* const)
native function int ReadBinary(out IpAddr Addr, int Count, out byte B[255]);

event ReceivedText(IpAddr Addr, string Text)
{
	return;
}

event ReceivedLine(IpAddr Addr, string Line)
{
	return;
}

event ReceivedBinary(IpAddr Addr, int Count, byte B[255])
{
	return;
}

defaultproperties
{
	BroadcastAddr=-1
	bAlwaysTick=true
}