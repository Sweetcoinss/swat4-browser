class SwatAdmin extends Actor
	config
	notplaceable
	hidecategories(Karma);

var array<PlayerController> AdminList;
var private string AdminPassword;

function SetAdminPassword(string Password)
{
	AdminPassword = Password;
	return;
}

function AdminLogin(PlayerController PC, string Password)
{
	if(NotEqual_StrStr(Password, AdminPassword))
	{
		return;
	}
	if(AndAnd_BoolBool(EqualEqual_StrStr(AdminPassword, ""), NotEqual_ObjectObject(PC, Level.GetLocalPlayerController())))
	{
		return;
	}
	AdminList[AdminList.Length] = PC;
	if(NotEqual_ObjectObject(SwatPlayerReplicationInfo(PC.PlayerReplicationInfo), none))
	{
		SwatPlayerReplicationInfo(PC.PlayerReplicationInfo).SetAdmin(true);
	}
	if(NotEqual_ObjectObject(SwatGamePlayerController(PC), none))
	{
		SwatGamePlayerController(PC).SwatRepoPlayerItem.LastAdminPassword = Password;
	}
	return;
}

function bool IsAdmin(PlayerController PC)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, AdminList.Length))
	{
		if(EqualEqual_ObjectObject(AdminList[i], PC))
		{
			return true;
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	return false;
	return;
}

function Kick(PlayerController PC, string PlayerName)
{
	if(Not_PreBool(IsAdmin(PC)))
	{
		return;
	}
	Level.Game.Kick(PC, PlayerName);
	return;
}

function KickBan(PlayerController PC, string PlayerName)
{
	if(Not_PreBool(IsAdmin(PC)))
	{
		return;
	}
	Level.Game.KickBan(PC, PlayerName);
	return;
}

function Switch(PlayerController PC, string URL)
{
	if(Not_PreBool(IsAdmin(PC)))
	{
		return;
	}
	Level.ServerTravel(URL, false);
	return;
}

function StartGame(PlayerController PC)
{
	if(Not_PreBool(IsAdmin(PC)))
	{
		return;
	}
	SwatRepo(Level.GetRepo()).AllPlayersReady();
	return;
}

function AbortGame(PlayerController PC)
{
	if(Not_PreBool(IsAdmin(PC)))
	{
		return;
	}
	SwatGameInfo(Level.Game).GameAbort();
	return;
}

defaultproperties
{
	bHidden=true
	bStasis=true
}