class SwatServerBrowserMenu extends SwatGUIPage
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

var(SwatGui) private export editinline config GUIButton MyQuitButton;
var(SwatGui) private export editinline config GUIButton MyMainMenuButton;
var(SwatGui) private export editinline config GUIButton StartButton;
var(SwatGui) private export editinline config GUIButton MyUpdateButton;
var(SwatGui) private export editinline config GUIButton MyRefreshButton;
var(SwatGui) private export editinline config GUIButton MyFiltersButton;
var(SwatGui) private export editinline config GUIButton MyJoinIPButton;
var(SwatGui) private export editinline config GUIRadioButton MyUseLanButton;
var(SwatGui) private export editinline config GUIRadioButton MyUseGameSpyButton;
var(SwatGui) private export editinline config GUIEditBox MyNameBox;
var(SwatGui) private export editinline config GUIMultiColumnListBox MyServerListBox;
var(SwatGui) private export editinline config GUILabel VersionLabel;
var(SwatGui) private export editinline config GUILabel ModLabel;
var(SwatGui) private export editinline GUIImage LockedIcon;
var(SwatGui) private config int MaxResults;
var private config localized string VersionFormatString;
var private config localized string ModFormatString;
var SwatGameSpyManager SGSM;
var bool bUseGameSpy;
var ServerQueryClient InternetPingClient;
var array<ServerResponseLine> ServerArray;
var private config localized string ConnectPasswordQueryString;
var string BuildVersion;
var string ModName;
var private config string CompatibleColorString;
var private config string InCompatibleColorString;
var bool bDebugging;
var int debugID;

function InitComponent(GUIComponent MyOwner)
{
	super.InitComponent(MyOwner);
	MyUpdateButton.__OnClick__Delegate = InternalOnClick;
	MyRefreshButton.__OnClick__Delegate = InternalOnClick;
	MyFiltersButton.__OnClick__Delegate = InternalOnClick;
	MyJoinIPButton.__OnClick__Delegate = InternalOnClick;
	MyServerListBox.__OnDblClick__Delegate = InternalOnClick;
	MyServerListBox.__OnChange__Delegate = UpdateJoinableState;
	MyUseGameSpyButton.__OnChange__Delegate = NetworkModeSelected;
	MyNameBox.__OnChange__Delegate = UpdateJoinableState;
	MyNameBox.MaxWidth = GC.MPNameLength;
	MyNameBox.AllowedCharSet = GC.MPNameAllowableCharSet;
	LockedIcon = GUIImage(Controller.CreateComponent("GUI.GUIImage", "Canvas_LockedIcon"));
	return;
}

function InternalOnActivate()
{
	BuildVersion = PlayerOwner().Level.BuildVersion;
	ModName = PlayerOwner().Level.ModName;
	VersionLabel.SetCaption(FormatTextString(VersionFormatString, BuildVersion));
	if(ComplementEqual_StrStr(ModName, "SWAT 4"))
	{
		ModLabel.SetCaption("");
	}
	else
	{
		ModLabel.SetCaption(FormatTextString(ModFormatString, ModName));
	}
	MyQuitButton.__OnClick__Delegate = InternalOnClick;
	MyMainMenuButton.__OnClick__Delegate = InternalOnClick;
	StartButton.__OnClick__Delegate = InternalOnClick;
	SGSM = SwatGameSpyManager(PlayerOwner().Level.GetGameSpyManager());
	if(EqualEqual_ObjectObject(SGSM, none))
	{
		Log("Error:  no GameSpy manager found");
		return;
	}
	CreatePingClient();
	if(Not_PreBool(SGSM.bInitialised))
	{
		SGSM.InitGameSpyClient();
	}
	SGSM.__OnUpdatedServer__Delegate = OnUpdatedGameSpyServer;
	bUseGameSpy = GC.bViewingGameSpy;
	MyFiltersButton.SetEnabled(bUseGameSpy);
	MyRefreshButton.EnableComponent();
	if(bUseGameSpy)
	{
		MyUseGameSpyButton.SelectRadioButton();
	}
	else
	{
		MyUseLanButton.SelectRadioButton();
	}
	MyNameBox.SetText(GC.MPName);
	UpdateServerList();
	SetTimer(3.0000000);
	RefreshEnabled();
	return;
}

function InternalOnDeActivate()
{
	DestroyPingClient();
	SwatPlayerController(PlayerOwner()).SetName(MyNameBox.GetText());
	GC.bViewingGameSpy = bUseGameSpy;
	GC.SaveConfig();
	return;
}

function DebugServerList(int Num)
{
	Log("[dkaplan] >>>>>>>>>>>>>>>>>>>> Debugging Server List <<<<<<<<<<<<<<<<<<<<<<<<<");
	debugID = 0;
	MaxResults = Num;
	bDebugging = true;
	MyServerListBox.Clear();
	SetTimer(0.0500000, true);
	return;
}

event Timer()
{
	if(bDebugging)
	{
		DebugAddServer();
		return;
	}
	if(OrOr_BoolBool(Not_PreBool(MyServerListBox.IsEmpty()), Not_PreBool(bVisible)))
	{
		return;
	}
	UpdateServerList();
	SetTimer(3.0000000);
	return;
}

private function CreatePingClient()
{
	Log("...CreatePingClient().");
	if(EqualEqual_ObjectObject(InternetPingClient, none))
	{
		InternetPingClient = PlayerOwner().Level.Spawn(Class'IpDrv.ServerQueryClient');
	}
	return;
}

private function DestroyPingClient()
{
	Log("...DestroyPingClient().");
	if(AndAnd_BoolBool(NotEqual_ObjectObject(InternetPingClient, none), Not_PreBool(InternetPingClient.bDeleteMe)))
	{
		InternetPingClient.CancelPings();
		InternetPingClient.Destroy();
		InternetPingClient = none;
	}
	return;
}

private function NetworkModeSelected(GUIComponent Sender)
{
	Log("...NetworkModeSelected().");
	bUseGameSpy = MyUseGameSpyButton.bChecked;
	MyFiltersButton.SetEnabled(bUseGameSpy);
	UpdateServerList();
	return;
}

private function UpdateServerList()
{
	Log("...UpdateServerList().");
	ClearServerData();
	InternetPingClient.__OnReceivedPingInfo__Delegate = OnReceivedPingInfoForUpdate;
	if(Not_PreBool(SGSM.bInitialised))
	{
		return;
	}
	if(bUseGameSpy)
	{
		Log("...from GameSpy");
		SGSM.super(SwatServerBrowserMenu).UpdateServerList(GetGameSpyFilterString());
	}
	else
	{
		Log("...from LAN.");
		SGSM.LANUpdateServerList();
	}
	return;
}

private function ClearServerData()
{
	Log("...ClearServerList().");
	MyServerListBox.Clear();
	ServerArray.Remove(0, ServerArray.Length);
	RefreshEnabled();
	return;
}

private function RefreshServerPings()
{
	local int i;

	Log("---SwatServerBrowserMenu::RefreshServerPings().");
	MyRefreshButton.DisableComponent();
	InternetPingClient.__OnReceivedPingInfo__Delegate = OnReceivedPingInfoForRefresh;
	InternetPingClient.__OnPingTimeout__Delegate = OnPingTimeout;
	InternetPingClient.__OnAllServersReturned__Delegate = OnAllServersReturned;
	Log(Concat_StrStr("...ServerArray.Length=", string(ServerArray.Length)));
	i = 0;
	J0xA9:

	if(Less_IntInt(i, ServerArray.Length))
	{
		PingServer(ServerArray[i]);
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0xA9;
	}
	return;
}

function InternalOnPopupReturned(GUIListElem returnObj, optional string Passback)
{
	local string URL;

	Log("...InternalOnPopupReturned().");
	switch(Passback)
	{
		case "Password":
			URL = Concat_StrStr(Concat_StrStr(returnObj.ExtraStrData, "?Password="), returnObj.Item);
			AttemptURL(URL);
			break;
		case "JoinIP":
			URL = returnObj.Item;
			AttemptURL(URL);
			break;
		case "Filters":
			break;
		default:
			break;
	}
	return;
}

function string URLPlusSWATPrefix(string URL)
{
	local string Prefix;

	Prefix = "swat4://";
	if(EqualEqual_StrStr(Left(URL, Len(Prefix)), Prefix))
	{
		return URL;
	}
	else
	{
		return Concat_StrStr(Prefix, URL);
	}
	return;
}

function AttemptURL(string URL)
{
	Log("...AttemptURL().");
	URL = URLPlusSWATPrefix(URL);
	GC.FirstTimeThrough = true;
	if(NotEqual_StrStr(MyNameBox.GetText(), ""))
	{
		URL = Concat_StrStr(Concat_StrStr(URL, "?Name="), MyNameBox.GetText());
	}
	Log(Concat_StrStr("Trying to join to: ", URL));
	SwatGUIController(Controller).LoadLevel(URL);
	return;
}

function InternalOnClick(GUIComponent Sender)
{
	local string URL;

	Log("...InternalOnClick().");
	switch(Sender)
	{
		case MyQuitButton:
			Quit();
			break;
		case StartButton:
			URL = MyServerListBox.GetColumn("IPAddress").GetExtra();
			if(MyServerListBox.GetColumn("Locked").GetExtraBoolData())
			{
				Controller.OpenMenu("SwatGui.SwatPasswordPopup", "SwatPasswordPopup", ConnectPasswordQueryString, URL);
			}
			else
			{
				AttemptURL(URL);
			}
			break;
		case MyMainMenuButton:
			Controller.CloseMenu();
			break;
		case MyUpdateButton:
			UpdateServerList();
			break;
		case MyRefreshButton:
			RefreshServerPings();
			break;
		case MyFiltersButton:
			Controller.OpenMenu("SwatGui.SwatServerFiltersPopup", "SwatServerFiltersPopup");
			break;
		case MyJoinIPButton:
			Controller.OpenMenu("SwatGui.SwatJoinIPPopup", "SwatJoinIPPopup");
			break;
		default:
			break;
	}
	return;
}

private function OnUpdatedGameSpyServer(ServerResponseLine Server)
{
	ServerArray[ServerArray.Length] = Server;
	PingServer(Server);
	return;
}

private function DebugAddServer()
{
	local ServerResponseLine S;
	local KeyValuePair kvp;

	AddAdd_Int(debugID);
	if(GreaterEqual_IntInt(debugID, 5000))
	{
		KillTimer();
		bDebugging = false;
		return;
	}
	S.MaxPlayers = Add_IntInt(Rand(16), 1);
	S.CurrentPlayers = Rand(Add_IntInt(S.MaxPlayers, 1));
	S.GameType = string(Rand(3));
	switch(Rand(3))
	{
		case 0:
			S.MapName = "MP-VIPTower";
			break;
		case 1:
			S.MapName = "MP-Bullseye";
			break;
		case 2:
			S.MapName = "MP-Powerplant";
			break;
		default:
			break;
	}
	switch(Rand(4))
	{
		case 0:
			S.ServerName = "Crombies Crazyhouse";
			break;
		case 1:
			S.ServerName = "Mikes Mayhem";
			break;
		case 2:
			S.ServerName = "Korkys Killground";
			break;
		case 3:
			S.ServerName = "Terrys Torture Chamber";
			break;
		default:
			break;
	}
	S.IP = Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(Rand(256)), "."), string(Rand(256))), "."), string(Rand(256))), "."), string(Rand(256)));
	S.Port = Rand(32768);
	S.Ping = Rand(Add_IntInt(debugID, 10));
	kvp.Key = "password";
	kvp.Value = string(Rand(2));
	S.ServerInfo[0] = kvp;
	OnReceivedPingInfoForUpdate(debugID, 2, S);
	return;
}

private function PingServer(ServerResponseLine Server)
{
	Log("---PingServer().");
	InternetPingClient.PingServer(Server.ServerID, 2, Server.IP, Add_IntInt(Server.Port, 2), 0, Server);
	return;
}

private function OnReceivedPingInfoForUpdate(int ServerID, ServerQueryClient.EPingCause PingCause, ServerResponseLine S)
{
	local string PreviouslySelectedIP, GameTypeEntry;
	local int i;
	local string Key, Value;

	if(Greater_IntInt(MyServerListBox.Num(), MaxResults))
	{
		return;
	}
	Log("---OnReceivedPingInfoForUpdate().");
	Log(Concat_StrStr("...ServerID=", string(ServerID)));
	Log(Concat_StrStr("...PingCause=", string(PingCause)));
	Log("...ServerResponseLine:");
	Log(Concat_StrStr("......servername=", S.ServerName));
	Log(Concat_StrStr("......CurrentPlayers=", string(S.CurrentPlayers)));
	Log(Concat_StrStr("......MaxPlayers=", string(S.MaxPlayers)));
	PreviouslySelectedIP = MyServerListBox.GetColumn("IPAddress").GetExtra();
	MyServerListBox.AddNewRowElement("IPAddress",, Concat_StrStr(Concat_StrStr(S.IP, ":"), string(S.Port)));
	MyServerListBox.AddNewRowElement("ServerName",, S.ServerName);
	MyServerListBox.AddNewRowElement("MapName",, S.MapName);
	GameTypeEntry = GC.GetGameModeNameFromNonlocalizedString(S.GameType);
	MyServerListBox.AddNewRowElement("GameType",, GameTypeEntry);
	MyServerListBox.AddNewRowElement("numPlayers",, Concat_StrStr(Concat_StrStr(string(S.CurrentPlayers), "/"), string(S.MaxPlayers)));
	if(OrOr_BoolBool(Less_IntInt(GC.theServerFilters.MaxPing, 0), Less_IntInt(S.Ping, GC.theServerFilters.MaxPing)))
	{
		MyServerListBox.AddNewRowElement("Ping",,, S.Ping);
	}
	Log(Concat_StrStr("...s.ServerInfo.Length=", string(S.ServerInfo.Length)));
	i = 0;
	J0x2AB:

	if(Less_IntInt(i, S.ServerInfo.Length))
	{
		Key = S.ServerInfo[i].Key;
		Value = S.ServerInfo[i].Value;
		if(AndAnd_BoolBool(EqualEqual_StrStr(Key, "password"), EqualEqual_StrStr(Value, "1")))
		{
			Log("...passworded.");
			MyServerListBox.AddNewRowElement("Locked", LockedIcon,,, true);
			// [Explicit Continue]
			goto J0x363;
		}
		Log("...not passworded.");
		J0x363:

		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x2AB;
	}
	if(EqualEqual_StrStr(S.ModName, ModName))
	{
		MyServerListBox.AddNewRowElement("ModName",, Concat_StrStr(CompatibleColorString, S.ModName));
	}
	else
	{
		MyServerListBox.AddNewRowElement("ModName",, Concat_StrStr(InCompatibleColorString, S.ModName));
	}
	if(EqualEqual_StrStr(S.GameVersion, BuildVersion))
	{
		MyServerListBox.AddNewRowElement("Version",, Concat_StrStr(CompatibleColorString, S.GameVersion));
	}
	else
	{
		MyServerListBox.AddNewRowElement("Version",, Concat_StrStr(InCompatibleColorString, S.GameVersion));
	}
	MyServerListBox.PopulateRow();
	MyServerListBox.GetColumn("IPAddress").FindExtra(PreviouslySelectedIP,, true);
	RefreshEnabled();
	return;
}

private function OnReceivedPingInfoForRefresh(int ServerID, ServerQueryClient.EPingCause PingCause, ServerResponseLine S)
{
	local export editinline GUIList IpAndPortColumn, PingColumn;
	local string IpAddressAndPort;
	local int i;

	Log("...OnReceivedPingInfoForRefresh().");
	IpAddressAndPort = Concat_StrStr(Concat_StrStr(S.IP, ":"), string(S.Port));
	IpAndPortColumn = MyServerListBox.GetColumn("IPAddress");
	PingColumn = MyServerListBox.GetColumn("Ping");
	i = 0;
	J0x8B:

	if(Less_IntInt(i, IpAndPortColumn.ItemCount))
	{
		if(EqualEqual_StrStr(IpAndPortColumn.GetExtraAtIndex(i), IpAddressAndPort))
		{
			PingColumn.SetExtraIntAtIndex(i, S.Ping);
			// [Explicit Break]
			goto J0xEC;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x8B;
	}
	J0xEC:

	return;
}

private function OnPingTimeout(int ServerID, ServerQueryClient.EPingCause PingCause)
{
	Log("...OnPingTimeout().");
	return;
}

private function OnAllServersReturned()
{
	Log("...OnAllServersReturned().");
	MyRefreshButton.EnableComponent();
	return;
}

private function string GetGameSpyFilterString()
{
	local string Result;
	local int GameTypeNumber;

	Log("...GetGameSpyFilterString().");
	if(GC.theServerFilters.bFull)
	{
		Result = AppendFilterString(Result, "numplayers!=maxplayers");
	}
	if(GC.theServerFilters.bPassworded)
	{
		Result = AppendFilterString(Result, "password=0");
	}
	if(GC.theServerFilters.bFilterGametype)
	{
		GameTypeNumber = int(GC.theServerFilters.GameType);
		if(EqualEqual_IntInt(GameTypeNumber, 0))
		{
			Result = AppendFilterString(Result, "gametype='Barricaded Suspects'");
		}
		else
		{
			if(EqualEqual_IntInt(GameTypeNumber, 1))
			{
				Result = AppendFilterString(Result, "gametype='VIP Escort'");
			}
			else
			{
				Result = AppendFilterString(Result, "gametype='Rapid Deployment'");
			}
		}
	}
	if(GC.theServerFilters.bHideIncompatibleVersions)
	{
		Result = AppendFilterString(Result, Concat_StrStr(Concat_StrStr("gamever='", BuildVersion), "'"));
	}
	if(GC.theServerFilters.bHideIncompatibleMods)
	{
		Result = AppendFilterString(Result, Concat_StrStr(Concat_StrStr("gamevariant='", ModName), "'"));
	}
	Log(Concat_StrStr("[dkaplan] >>> GetGameSpyFilterString, returning ", Result));
	return Result;
	return;
}

private function string AppendFilterString(string Current, string newexpression)
{
	Log("...AppendFilterString().");
	if(NotEqual_StrStr(Current, ""))
	{
		return Concat_StrStr(Concat_StrStr(Current, " and "), newexpression);
	}
	else
	{
		return newexpression;
	}
	return;
}

private function UpdateJoinableState(GUIComponent Sender)
{
	RefreshEnabled();
	return;
}

private function RefreshEnabled()
{
	local bool bEnableStart;
	local string MaxPlayers, NumPlayers;

	MaxPlayers = MyServerListBox.GetColumn("numPlayers").GetExtra();
	NumPlayers = GetFirstField(MaxPlayers, "/");
	bEnableStart = AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_StrStr(MyNameBox.GetText(), ""), GreaterEqual_IntInt(MyServerListBox.GetIndex(), 0)), NotEqual_StrStr(NumPlayers, MaxPlayers));
	StartButton.SetEnabled(bEnableStart);
	return;
}

defaultproperties
{
	MaxResults=500
	VersionFormatString="Version: %1"
	ModFormatString="Mod: %1"
	bUseGameSpy=true
	ConnectPasswordQueryString="Please enter the Password for the selected server:"
	CompatibleColorString="[c=00ff00]"
	InCompatibleColorString="[c=ff0000]"
	OnPopupReturned=SwatServerBrowserMenu.InternalOnPopupReturned
	OnActivate=SwatServerBrowserMenu.InternalOnActivate
	OnDeActivate=SwatServerBrowserMenu.InternalOnDeActivate
}