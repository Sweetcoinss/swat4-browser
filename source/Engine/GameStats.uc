class GameStats extends Info
	native
	config
	notplaceable
	hidecategories(Karma,Movement,Collision,Lighting,LightColor,Karma,Force);

var FileLog TempLog;
var GameReplicationInfo GRI;
var bool bShowBots;

// Export UGameStats::execGetStatsIdentifier(FFrame&, void* const)
native final function string GetStatsIdentifier(Controller C);

// Export UGameStats::execGetMapFileName(FFrame&, void* const)
native final function string GetMapFileName();

function Init()
{
	TempLog = Spawn(Class'Engine.FileLog');
	if(NotEqual_ObjectObject(TempLog, none))
	{
		TempLog.OpenLog("Stats");
		Log("Output Game stats to: STATS.TXT");
	}
	else
	{
		Log("Could not spawn Temporary Stats log");
		Destroy();
	}
	return;
}

function Shutdown()
{
	if(NotEqual_ObjectObject(TempLog, none))
	{
		TempLog.Destroy();
	}
	return;
}

function Logf(string LogString)
{
	if(NotEqual_ObjectObject(TempLog, none))
	{
		TempLog.super(GameStats).Logf(LogString);
	}
	return;
}

event PostBeginPlay()
{
	super(Actor).PostBeginPlay();
	Init();
	return;
}

event Destroyed()
{
	Shutdown();
	super(Actor).Destroyed();
	return;
}

function string TimeStamp()
{
	local string Seconds;

	Seconds = Concat_StrStr("", string(Level.TimeSeconds));
	if(NotEqual_IntInt(InStr(Seconds, "."), -1))
	{
		Seconds = Left(Seconds, InStr(Seconds, "."));
	}
	return Seconds;
	return;
}

function string Header()
{
	return Concat_StrStr(Concat_StrStr("", TimeStamp()), Chr(9));
	return;
}

function string FullTimeDate()
{
	return Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("", string(Level.Year)), "-"), string(Level.Month)), "-"), string(Level.Day)), " "), string(Level.Hour)), ":"), string(Level.Minute)), ":"), string(Level.Second));
	return;
}

function string TimeZone()
{
	return "0";
	return;
}

function string MapName()
{
	local string MapName, tab;

	tab = Concat_StrStr("", Chr(9));
	MapName = Concat_StrStr("", GetMapFileName());
	if(NotEqual_IntInt(InStr(MapName, ".s4m"), -1))
	{
		MapName = Left(MapName, InStr(MapName, ".s4m"));
	}
	ReplaceText(MapName, tab, "_");
	return MapName;
	return;
}

function NewGame()
{
	local string Out, tmp, tab, ngTitle, ngAuthor, ngGameGameName;

	local int i;
	local Mutator MyMutie;
	local GameRules MyRules;

	tab = Concat_StrStr("", Chr(9));
	ngTitle = Level.Title;
	ngAuthor = Level.Author;
	ngGameGameName = Level.Game.GameName;
	ReplaceText(ngTitle, tab, "_");
	ReplaceText(ngAuthor, tab, "_");
	ReplaceText(ngGameGameName, tab, "_");
	GRI = Level.Game.GameReplicationInfo;
	Out = Concat_StrStr(Concat_StrStr(Header(), "NG"), Chr(9));
	Out = Concat_StrStr(Concat_StrStr(Out, FullTimeDate()), Chr(9));
	Out = Concat_StrStr(Concat_StrStr(Out, TimeZone()), Chr(9));
	Out = Concat_StrStr(Concat_StrStr(Out, MapName()), Chr(9));
	Out = Concat_StrStr(Concat_StrStr(Out, ngTitle), Chr(9));
	Out = Concat_StrStr(Concat_StrStr(Out, ngAuthor), Chr(9));
	Out = Concat_StrStr(Concat_StrStr(Out, string(Level.Game.Class)), Chr(9));
	Out = Concat_StrStr(Out, ngGameGameName);
	tmp = "";
	i = 0;
	foreach AllActors(Class'Engine.Mutator', MyMutie)
	{
		if(NotEqual_StrStr(tmp, ""))
		{
			tmp = Concat_StrStr(Concat_StrStr(tmp, "|"), string(MyMutie.Class));
		}
		else
		{
			tmp = Concat_StrStr("", string(MyMutie.Class));
		}
		AddAdd_Int(i);
	}
	foreach AllActors(Class'Engine.GameRules', MyRules)
	{
		if(NotEqual_StrStr(tmp, ""))
		{
			tmp = Concat_StrStr(Concat_StrStr(tmp, "|"), string(MyRules.Class));
		}
		else
		{
			tmp = Concat_StrStr("", string(MyRules.Class));
		}
		AddAdd_Int(i);
	}
	if(Greater_IntInt(i, 0))
	{
		ReplaceText(tmp, tab, "_");
		Out = Concat_StrStr(Concat_StrStr(Concat_StrStr(Out, Chr(9)), "Mutators="), tmp);
	}
	Logf(Out);
	return;
}

function ServerInfo()
{
	local string Out, flags, tab, siServerName, siAdminName, siAdminEmail;

	local ServerResponseLine ServerState;
	local int i;

	tab = Concat_StrStr("", Chr(9));
	siServerName = GRI.ServerName;
	siAdminName = GRI.AdminName;
	siAdminEmail = GRI.AdminEmail;
	ReplaceText(siServerName, tab, "_");
	ReplaceText(siAdminName, tab, "_");
	ReplaceText(siAdminEmail, tab, "_");
	Out = Concat_StrStr(Concat_StrStr(Header(), "SI"), Chr(9));
	Out = Concat_StrStr(Concat_StrStr(Out, siServerName), Chr(9));
	Out = Concat_StrStr(Concat_StrStr(Out, TimeZone()), Chr(9));
	Out = Concat_StrStr(Concat_StrStr(Out, siAdminName), Chr(9));
	Out = Concat_StrStr(Concat_StrStr(Out, siAdminEmail), Chr(9));
	Out = Concat_StrStr(Out, Chr(9));
	flags = "";
	Level.Game.GetServerDetails(ServerState);
	i = 0;
	J0x139:

	if(Less_IntInt(i, ServerState.ServerInfo.Length))
	{
		flags = Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(flags, "\\"), ServerState.ServerInfo[i].Key), "\\"), ServerState.ServerInfo[i].Value);
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x139;
	}
	ReplaceText(flags, tab, "_");
	Out = Concat_StrStr(Out, flags);
	Logf(Out);
	return;
}

function StartGame()
{
	Logf(Concat_StrStr(Concat_StrStr("", Header()), "SG"));
	return;
}

function EndGame(string Reason)
{
	local string Out;
	local int i, j;
	local GameReplicationInfo GRI;
	local array<PlayerReplicationInfo> pris;
	local PlayerReplicationInfo PRI, t;

	Out = Concat_StrStr(Concat_StrStr(Concat_StrStr(Header(), "EG"), Chr(9)), Reason);
	GRI = Level.Game.GameReplicationInfo;
	i = 0;
	J0x43:

	if(Less_IntInt(i, GRI.PRIArray.Length))
	{
		PRI = GRI.PRIArray[i];
		if(AndAnd_BoolBool(Not_PreBool(PRI.bOnlySpectator), Not_PreBool(PRI.bBot)))
		{
			pris.Length = Add_IntInt(pris.Length, 1);
			j = 0;
			J0xB7:

			if(Less_IntInt(j, Subtract_IntInt(pris.Length, 1)))
			{
				if(OrOr_BoolBool(Less_FloatFloat(pris[j].Score, PRI.Score), AndAnd_BoolBool(EqualEqual_FloatFloat(pris[j].Score, PRI.Score), Greater_FloatFloat(pris[j].Deaths, PRI.Deaths))))
				{
					t = pris[j];
					pris[j] = PRI;
					PRI = t;
				}
				AddAdd_Int(j);
				// [Loop Continue]
				goto J0xB7;
			}
			pris[j] = PRI;
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x43;
	}
	i = 0;
	J0x19C:

	if(Less_IntInt(i, pris.Length))
	{
		Out = Concat_StrStr(Concat_StrStr(Out, Chr(9)), string(Controller(pris[i].Owner).PlayerNum));
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x19C;
	}
	Logf(Out);
	return;
}

function ConnectEvent(PlayerReplicationInfo Who)
{
	local string Out;

	if(OrOr_BoolBool(Who.bBot, Who.bOnlySpectator))
	{
		return;
	}
	Out = Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("", Header()), "C"), Chr(9)), string(Controller(Who.Owner).PlayerNum)), Chr(9));
	Out = Concat_StrStr(Out, GetStatsIdentifier(Controller(Who.Owner)));
	Logf(Out);
	return;
}

function DisconnectEvent(PlayerReplicationInfo Who)
{
	local string Out;

	if(OrOr_BoolBool(Who.bBot, Who.bOnlySpectator))
	{
		return;
	}
	Out = Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("", Header()), "D"), Chr(9)), string(Controller(Who.Owner).PlayerNum));
	Logf(Out);
	return;
}

function ScoreEvent(PlayerReplicationInfo Who, float Points, string Desc)
{
	if(OrOr_BoolBool(Who.bBot, Who.bOnlySpectator))
	{
		return;
	}
	Logf(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("", Header()), "S"), Chr(9)), string(Controller(Who.Owner).PlayerNum)), Chr(9)), string(Points)), Chr(9)), Desc));
	return;
}

function TeamScoreEvent(int Team, float Points, string Desc)
{
	Logf(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("", Header()), "T"), Chr(9)), string(Team)), Chr(9)), string(Points)), Chr(9)), Desc));
	return;
}

function KillEvent(string KillType, PlayerReplicationInfo Killer, PlayerReplicationInfo Victim, Class<DamageType> Damage)
{
	local string Out;

	if(OrOr_BoolBool(OrOr_BoolBool(Victim.bBot, Victim.bOnlySpectator), AndAnd_BoolBool(NotEqual_ObjectObject(Killer, none), Killer.bBot)))
	{
		return;
	}
	Out = Concat_StrStr(Concat_StrStr(Concat_StrStr("", Header()), KillType), Chr(9));
	if(NotEqual_ObjectObject(Killer, none))
	{
		Out = Concat_StrStr(Concat_StrStr(Out, string(Controller(Killer.Owner).PlayerNum)), Chr(9));
		Out = Concat_StrStr(Concat_StrStr(Out, GetItemName(string(Damage))), Chr(9));
	}
	else
	{
		Out = Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Out, "-1"), Chr(9)), GetItemName(string(Damage))), Chr(9));
	}
	Out = Concat_StrStr(Concat_StrStr(Out, string(Controller(Victim.Owner).PlayerNum)), Chr(9));
	if(AndAnd_BoolBool(NotEqual_ObjectObject(PlayerController(Victim.Owner), none), PlayerController(Victim.Owner).bIsTyping))
	{
		if(NotEqual_ObjectObject(PlayerController(Killer.Owner), PlayerController(Victim.Owner)))
		{
			SpecialEvent(Killer, "type_kill");
		}
	}
	Logf(Out);
	return;
}

function SpecialEvent(PlayerReplicationInfo Who, string Desc)
{
	local string Out;

	if(NotEqual_ObjectObject(Who, none))
	{
		if(OrOr_BoolBool(Who.bBot, Who.bOnlySpectator))
		{
			return;
		}
		Out = Concat_StrStr("", string(Controller(Who.Owner).PlayerNum));
	}
	else
	{
		Out = "-1";
	}
	Logf(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("", Header()), "P"), Chr(9)), Out), Chr(9)), Desc));
	return;
}

function GameEvent(string GEvent, string Desc, PlayerReplicationInfo Who)
{
	local string Out, tab, geDesc;

	if(NotEqual_ObjectObject(Who, none))
	{
		if(OrOr_BoolBool(Who.bBot, Who.bOnlySpectator))
		{
			return;
		}
		Out = Concat_StrStr("", string(Controller(Who.Owner).PlayerNum));
	}
	else
	{
		Out = "-1";
	}
	geDesc = Desc;
	tab = Concat_StrStr("", Chr(9));
	ReplaceText(geDesc, tab, "_");
	Logf(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("", Header()), "G"), Chr(9)), GEvent), Chr(9)), Out), Chr(9)), geDesc));
	return;
}
