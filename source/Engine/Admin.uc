class Admin extends PlayerController
	config(User)
	notplaceable
	hidecategories(Karma);

replication
{
	// Pos:0x000
	reliable if(Less_IntInt(int(Role), int(ROLE_Authority)))
		Admin, Kick,
		KickBan, RestartMap,
		Switch;
}

event PostBeginPlay()
{
	super.PostBeginPlay();
	AddCheats();
	return;
}

exec function Admin(string CommandLine)
{
	local string Result;

	Result = ConsoleCommand(CommandLine);
	if(NotEqual_StrStr(Result, ""))
	{
		ClientMessage(Result);
	}
	return;
}

exec function KickBan(string S)
{
	return;
}

exec function Say(string msg)
{
	local Controller C;

	if(EqualEqual_StrStr(Left(msg, 1), "#"))
	{
		msg = Right(msg, Subtract_IntInt(Len(msg), 1));
		C = Level.ControllerList;
		J0x3B:

		if(NotEqual_ObjectObject(C, none))
		{
			if(C.IsA('PlayerController'))
			{
				PlayerController(C).ClearProgressMessages();
				PlayerController(C).SetProgressTime(6.0000000);
				PlayerController(C).SetProgressMessage(0, msg, Class'Engine.Canvas'.static.MakeColor(byte(255), byte(255), byte(255)));
			}
			C = C.nextController;
			// [Loop Continue]
			goto J0x3B;
		}
		return;
	}
	super.Say(msg);
	return;
}

exec function Kick(string S)
{
	return;
}

exec function PlayerList()
{
	local PlayerReplicationInfo PRI;

	Log("Player List:");
	foreach DynamicActors(Class'Engine.PlayerReplicationInfo', PRI)
	{
		Log(Concat_StrStr(At_StrStr(At_StrStr(PRI.PlayerName, "( ping"), string(PRI.Ping)), ")"));
	}
	return;
}

exec function RestartMap()
{
	ClientTravel("?restart", 2, false);
	return;
}

exec function Switch(string URL)
{
	Level.ServerTravel(URL, false);
	return;
}
