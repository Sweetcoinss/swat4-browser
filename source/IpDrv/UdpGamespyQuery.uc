class UdpGamespyQuery extends UdpLink
	transient
	config
	hidecategories(Karma,Movement,Collision,Lighting,LightColor,Karma,Force);

var name QueryName;
var int CurrentQueryNum;
var string ReplyData;
var globalconfig int MinNetVer;
var globalconfig int OldQueryPortNumber;
var globalconfig bool bRestartServerOnPortSwap;

function PreBeginPlay()
{
	local int boundport;

	Tag = QueryName;
	boundport = BindPort(Add_IntInt(Level.Game.GetServerPort(), 10), true);
	if(EqualEqual_IntInt(boundport, 0))
	{
		Log("UdpServerQuery: Port failed to bind.");
		return;
	}
	Log(Concat_StrStr(Concat_StrStr("UdpServerQuery(crt): Port ", string(boundport)), " successfully bound."));
	if(bRestartServerOnPortSwap)
	{
		if(NotEqual_IntInt(OldQueryPortNumber, 0))
		{
			assert(EqualEqual_IntInt(OldQueryPortNumber, boundport));
		}
		OldQueryPortNumber = boundport;
		SaveConfig();
	}
	return;
}

function PostBeginPlay()
{
	local UdpBeacon Beacon;

	foreach AllActors(Class'IpDrv.UdpBeacon', Beacon)
	{
		Beacon.UdpServerQueryPort = Port;
	}
	super(Actor).PostBeginPlay();
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
	PacketNum = 0;
	ReplyData = "";
	J0x5E:

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
		goto J0x5E;
	}
	return;
}

function bool ParseNextQuery(string Query, out string QueryType, out string QueryValue, out string QueryRest, out int bFinalPacket)
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
			bFinalPacket = 1;
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
			bFinalPacket = 1;
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

function string ParseQuery(IpAddr Addr, coerce string Query, int QueryNum, out int PacketNum)
{
	local string QueryType, QueryValue, QueryRest, ValidationString;
	local bool Result;
	local int bFinalPacket;

	bFinalPacket = 0;
	Result = ParseNextQuery(Query, QueryType, QueryValue, QueryRest, bFinalPacket);
	if(Not_PreBool(Result))
	{
		return "";
	}
	if(EqualEqual_StrStr(QueryType, "basic"))
	{
		Result = SendQueryPacket(Addr, GetBasic(), QueryNum, PacketNum, bFinalPacket);
	}
	else
	{
		if(EqualEqual_StrStr(QueryType, "info"))
		{
			Result = SendQueryPacket(Addr, GetInfo(), QueryNum, PacketNum, bFinalPacket);
		}
		else
		{
			if(EqualEqual_StrStr(QueryType, "rules"))
			{
				Result = SendQueryPacket(Addr, GetRules(), QueryNum, PacketNum, bFinalPacket);
			}
			else
			{
				if(EqualEqual_StrStr(QueryType, "players"))
				{
					if(Greater_IntInt(Level.Game.NumPlayers, 0))
					{
						Result = SendPlayers(Addr, QueryNum, PacketNum, bFinalPacket);
					}
					else
					{
						Result = SendQueryPacket(Addr, "", QueryNum, PacketNum, bFinalPacket);
					}
				}
				else
				{
					if(EqualEqual_StrStr(QueryType, "status"))
					{
						Result = SendQueryPacket(Addr, GetBasic(), QueryNum, PacketNum, 0);
						Result = SendQueryPacket(Addr, GetInfo(), QueryNum, PacketNum, 0);
						if(EqualEqual_IntInt(Level.Game.NumPlayers, 0))
						{
							Result = SendQueryPacket(Addr, GetRules(), QueryNum, PacketNum, bFinalPacket);
						}
						else
						{
							Result = SendQueryPacket(Addr, GetRules(), QueryNum, PacketNum, 0);
							Result = SendPlayers(Addr, QueryNum, PacketNum, bFinalPacket);
						}
					}
					else
					{
						if(EqualEqual_StrStr(QueryType, "echo"))
						{
							Result = SendQueryPacket(Addr, Concat_StrStr("\\ignoring\\", QueryValue), QueryNum, PacketNum, bFinalPacket);
						}
						else
						{
							if(EqualEqual_StrStr(QueryType, "secure"))
							{
								ValidationString = Concat_StrStr("\\validate\\", GameSpyValidate(QueryValue));
								Result = SendQueryPacket(Addr, ValidationString, QueryNum, PacketNum, bFinalPacket);
							}
							else
							{
								if(EqualEqual_StrStr(QueryType, "level_property"))
								{
									Result = SendQueryPacket(Addr, GetLevelProperty(QueryValue), QueryNum, PacketNum, bFinalPacket);
								}
								else
								{
									if(EqualEqual_StrStr(QueryType, "game_property"))
									{
										Result = SendQueryPacket(Addr, GetGameProperty(QueryValue), QueryNum, PacketNum, bFinalPacket);
									}
									else
									{
										if(EqualEqual_StrStr(QueryType, "player_property"))
										{
											Result = SendQueryPacket(Addr, GetPlayerProperty(QueryValue), QueryNum, PacketNum, bFinalPacket);
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}
	return QueryRest;
	return;
}

function bool SendAPacket(IpAddr Addr, int QueryNum, out int PacketNum, int bFinalPacket)
{
	local bool Result;

	ReplyData = Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(ReplyData, "\\queryid\\"), string(QueryNum)), "."), string(AddAdd_PreInt(PacketNum)));
	if(EqualEqual_IntInt(bFinalPacket, 1))
	{
		ReplyData = Concat_StrStr(ReplyData, "\\final\\");
	}
	Result = SendText(Addr, ReplyData);
	ReplyData = "";
	return Result;
	return;
}

function bool SendQueryPacket(IpAddr Addr, coerce string SendString, int QueryNum, out int PacketNum, int bFinalPacket)
{
	local bool Result;

	Result = true;
	if(Greater_IntInt(Add_IntInt(Len(ReplyData), Len(SendString)), 1000))
	{
		Result = SendAPacket(Addr, QueryNum, PacketNum, 0);
	}
	ReplyData = Concat_StrStr(ReplyData, SendString);
	if(EqualEqual_IntInt(bFinalPacket, 1))
	{
		Result = SendAPacket(Addr, QueryNum, PacketNum, bFinalPacket);
	}
	return Result;
	return;
}

function string GetBasic()
{
	local string ResultSet;

	ResultSet = Concat_StrStr("\\gamename\\", GameSpyGameName());
	ResultSet = Concat_StrStr(Concat_StrStr(ResultSet, "\\gamever\\"), Level.EngineVersion);
	if(AndAnd_BoolBool(GreaterEqual_IntInt(MinNetVer, int(Level.MinNetVersion)), LessEqual_IntInt(MinNetVer, int(Level.EngineVersion))))
	{
		ResultSet = Concat_StrStr(Concat_StrStr(ResultSet, "\\minnetver\\"), string(MinNetVer));
	}
	else
	{
		ResultSet = Concat_StrStr(Concat_StrStr(ResultSet, "\\minnetver\\"), Level.MinNetVersion);
	}
	ResultSet = Concat_StrStr(Concat_StrStr(ResultSet, "\\location\\"), string(Class'IpDrv.UdpGamespyUplink'.default.ServerRegion));
	return ResultSet;
	return;
}

function string GetInfo()
{
	local string ResultSet, ServerName;

	ServerName = Level.Game.GameReplicationInfo.ServerName;
	ReplaceText(ServerName, "\\", "");
	ResultSet = Concat_StrStr("\\hostname\\", ServerName);
	ResultSet = Concat_StrStr(Concat_StrStr(ResultSet, "\\hostport\\"), string(Level.Game.GetServerPort()));
	ResultSet = Concat_StrStr(Concat_StrStr(ResultSet, "\\maptitle\\"), Level.Title);
	ResultSet = Concat_StrStr(Concat_StrStr(ResultSet, "\\mapname\\"), Left(string(Level), InStr(string(Level), ".")));
	ResultSet = Concat_StrStr(Concat_StrStr(ResultSet, "\\gametype\\"), GetItemName(string(Level.Game.Class)));
	ResultSet = Concat_StrStr(Concat_StrStr(ResultSet, "\\numplayers\\"), string(Level.Game.GetNumPlayers()));
	ResultSet = Concat_StrStr(Concat_StrStr(ResultSet, "\\maxplayers\\"), string(Level.Game.MaxPlayers));
	ResultSet = Concat_StrStr(ResultSet, "\\gamemode\\openplaying");
	ResultSet = Concat_StrStr(Concat_StrStr(ResultSet, "\\gamever\\"), Level.EngineVersion);
	if(AndAnd_BoolBool(GreaterEqual_IntInt(MinNetVer, int(Level.MinNetVersion)), LessEqual_IntInt(MinNetVer, int(Level.EngineVersion))))
	{
		ResultSet = Concat_StrStr(Concat_StrStr(ResultSet, "\\minnetver\\"), string(MinNetVer));
	}
	else
	{
		ResultSet = Concat_StrStr(Concat_StrStr(ResultSet, "\\minnetver\\"), Level.MinNetVersion);
	}
	return ResultSet;
	return;
}

function string GetRules()
{
	local string ResultSet;

	if(NotEqual_StrStr(Level.Game.GameReplicationInfo.AdminName, ""))
	{
		ResultSet = Concat_StrStr(Concat_StrStr(ResultSet, "\\AdminName\\"), Level.Game.GameReplicationInfo.AdminName);
	}
	if(NotEqual_StrStr(Level.Game.GameReplicationInfo.AdminEmail, ""))
	{
		ResultSet = Concat_StrStr(Concat_StrStr(ResultSet, "\\AdminEMail\\"), Level.Game.GameReplicationInfo.AdminEmail);
	}
	if(AndAnd_BoolBool(NotEqual_ObjectObject(Level.Game.AccessControl, none), Level.Game.AccessControl.RequiresPassword()))
	{
		ResultSet = Concat_StrStr(ResultSet, "\\password\\1");
	}
	else
	{
		ResultSet = Concat_StrStr(ResultSet, "\\password\\0");
	}
	return ResultSet;
	return;
}

function string GetPlayer(PlayerController P, int PlayerNum)
{
	local string ResultSet, PlayerName;

	PlayerName = P.PlayerReplicationInfo.PlayerName;
	ReplaceText(PlayerName, "\\", "");
	ResultSet = Concat_StrStr(Concat_StrStr(Concat_StrStr("\\player_", string(PlayerNum)), "\\"), PlayerName);
	ResultSet = Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(ResultSet, "\\frags_"), string(PlayerNum)), "\\"), string(int(P.PlayerReplicationInfo.Score)));
	ResultSet = Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(ResultSet, "\\ping_"), string(PlayerNum)), "\\"), P.ConsoleCommand("GETPING"));
	if(NotEqual_ObjectObject(P.PlayerReplicationInfo.Team, none))
	{
		ResultSet = Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(ResultSet, "\\team_"), string(PlayerNum)), "\\"), string(P.PlayerReplicationInfo.Team.TeamIndex));
	}
	else
	{
		ResultSet = Concat_StrStr(Concat_StrStr(Concat_StrStr(ResultSet, "\\team_"), string(PlayerNum)), "\\0");
	}
	return ResultSet;
	return;
}

function bool SendPlayers(IpAddr Addr, int QueryNum, out int PacketNum, int bFinalPacket)
{
	local Controller C;
	local int i;
	local bool Result, SendResult;

	Result = false;
	C = Level.ControllerList;
	J0x1C:

	if(Less_IntInt(i, Level.Game.NumPlayers))
	{
		if(EqualEqual_ObjectObject(C, none))
		{
			if(EqualEqual_IntInt(bFinalPacket, 1))
			{
				SendResult = SendAPacket(Addr, QueryNum, PacketNum, bFinalPacket);
			}
			Result = OrOr_BoolBool(SendResult, Result);
			// [Explicit Break]
			goto J0x1A9;
		}
		else
		{
			if(AndAnd_BoolBool(AndAnd_BoolBool(C.IsA('PlayerController'), NotEqual_ObjectObject(C.PlayerReplicationInfo, none)), Not_PreBool(C.PlayerReplicationInfo.bOnlySpectator)))
			{
				if(AndAnd_BoolBool(EqualEqual_IntInt(i, Subtract_IntInt(Level.Game.NumPlayers, 1)), EqualEqual_IntInt(bFinalPacket, 1)))
				{
					SendResult = SendQueryPacket(Addr, GetPlayer(PlayerController(C), i), QueryNum, PacketNum, 1);
				}
				else
				{
					SendResult = SendQueryPacket(Addr, GetPlayer(PlayerController(C), i), QueryNum, PacketNum, 0);
				}
				Result = OrOr_BoolBool(SendResult, Result);
				AddAdd_Int(i);
			}
		}
		C = C.nextController;
		// [Loop Continue]
		goto J0x1C;
	}
	J0x1A9:

	return Result;
	return;
}

function string GetLevelProperty(string Prop)
{
	local string ResultSet;

	ResultSet = Concat_StrStr(Concat_StrStr(Concat_StrStr("\\", Prop), "\\"), Level.GetPropertyText(Prop));
	return ResultSet;
	return;
}

function string GetGameProperty(string Prop)
{
	local string ResultSet;

	ResultSet = Concat_StrStr(Concat_StrStr(Concat_StrStr("\\", Prop), "\\"), Level.Game.GetPropertyText(Prop));
	return ResultSet;
	return;
}

function string GetPlayerProperty(string Prop)
{
	local string ResultSet;
	local int i;
	local Controller C;

	foreach AllActors(Class'Engine.Controller', C)
	{
		if(AndAnd_BoolBool(NotEqual_ObjectObject(C.PlayerReplicationInfo, none), Not_PreBool(C.PlayerReplicationInfo.bBot)))
		{
			AddAdd_Int(i);
			ResultSet = Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(ResultSet, "\\"), Prop), "_"), string(i)), "\\"), C.GetPropertyText(Prop));
		}
	}
	return ResultSet;
	return;
}

defaultproperties
{
	QueryName="MasterUplink"
}