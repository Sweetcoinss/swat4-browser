class AccessControl extends Info
	config
	notplaceable
	hidecategories(Karma,Movement,Collision,Lighting,LightColor,Karma,Force);

var globalconfig string IPPolicies[50];
var localized string IPBanned;
var localized string WrongPassword;
var localized string NeedPassword;
var localized string InvalidOptions;
var Class<Admin> AdminClass;
var private globalconfig string AdminPassword;
var private globalconfig string GamePassword;
var bool bDontAddDefaultAdmin;

function SetAdminPassword(string P)
{
	AdminPassword = P;
	return;
}

function SetGamePassword(string P)
{
	GamePassword = P;
	return;
}

function bool RequiresPassword()
{
	return NotEqual_StrStr(GamePassword, "");
	return;
}

function bool Kick(string S)
{
	local PlayerController P;

	foreach DynamicActors(Class'Engine.PlayerController', P)
	{
		if(AndAnd_BoolBool(ComplementEqual_StrStr(P.PlayerReplicationInfo.PlayerName, S), NotEqual_ObjectObject(NetConnection(P.Player), none)))
		{
			P.Destroy();
			return true;
		}
	}
	return false;
	return;
}

function bool KickBan(string S)
{
	local PlayerController P;
	local string IP;
	local int j;

	foreach DynamicActors(Class'Engine.PlayerController', P)
	{
		if(AndAnd_BoolBool(ComplementEqual_StrStr(P.PlayerReplicationInfo.PlayerName, S), NotEqual_ObjectObject(NetConnection(P.Player), none)))
		{
			IP = P.GetPlayerNetworkAddress();
			if(CheckIPPolicy(IP))
			{
				IP = Left(IP, InStr(IP, ":"));
				Log(Concat_StrStr("Adding IP Ban for: ", IP));
				j = 0;
				J0xAB:

				if(Less_IntInt(j, 50))
				{
					if(EqualEqual_StrStr(IPPolicies[j], ""))
					{
						// [Explicit Break]
						goto J0xD6;
					}
					AddAdd_Int(j);
					// [Loop Continue]
					goto J0xAB;
				}
				J0xD6:

				if(Less_IntInt(j, 50))
				{
					IPPolicies[j] = Concat_StrStr("DENY,", IP);
				}
				SaveConfig();
			}
			P.Destroy();
			return true;
		}
	}
	return false;
	return;
}

function bool AdminLogin(PlayerController P, string Password)
{
	if(EqualEqual_StrStr(AdminPassword, ""))
	{
		return false;
	}
	if(EqualEqual_StrStr(Password, AdminPassword))
	{
		Log("Administrator logged in.");
		Level.Game.Broadcast(P, Concat_StrStr(P.PlayerReplicationInfo.PlayerName, "logged in as a server administrator."));
		return true;
	}
	return false;
	return;
}

event PreLogin(string Options, string Address, out string Error, out string FailCode, bool bSpectator)
{
	local string InPassword;
	local int InSwatPlayerID;

	if(GreaterEqual_IntInt(InStr(Options, "%"), 0))
	{
		Error = InvalidOptions;
		return;
	}
	Error = "";
	InPassword = Level.Game.ParseOption(Options, "Password");
	InSwatPlayerID = Level.Game.GetIntOption(Options, "SwatPlayerID", 0);
	if(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_IntInt(int(Level.NetMode), int(NM_Standalone)), EqualEqual_IntInt(InSwatPlayerID, 0)), Level.Game.AtCapacity(bSpectator)))
	{
		Error = Level.Game.GameMessageClass.default.MaxedOutMessage;
	}
	else
	{
		if(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_StrStr(GamePassword, ""), NotEqual_StrStr(Caps(InPassword), Caps(GamePassword))), OrOr_BoolBool(EqualEqual_StrStr(AdminPassword, ""), NotEqual_StrStr(Caps(InPassword), Caps(AdminPassword)))))
		{
			if(EqualEqual_StrStr(InPassword, ""))
			{
				Error = NeedPassword;
				FailCode = "NEEDPW";
			}
			else
			{
				Error = WrongPassword;
				FailCode = "WRONGPW";
			}
		}
	}
	if(Not_PreBool(CheckIPPolicy(Address)))
	{
		Error = IPBanned;
	}
	return;
}

function bool CheckIPPolicy(string Address)
{
	local int i, j, LastMatchingPolicy;
	local string Policy, Mask;
	local bool bAcceptAddress, bAcceptPolicy;

	j = InStr(Address, ":");
	if(NotEqual_IntInt(j, -1))
	{
		Address = Left(Address, j);
	}
	bAcceptAddress = true;
	i = 0;
	J0x40:

	if(AndAnd_BoolBool(Less_IntInt(i, 50), NotEqual_StrStr(IPPolicies[i], "")))
	{
		j = InStr(IPPolicies[i], ",");
		if(EqualEqual_IntInt(j, -1))
		{
			// [Explicit Continue]
			goto J0x174;
		}
		Policy = Left(IPPolicies[i], j);
		Mask = Mid(IPPolicies[i], Add_IntInt(j, 1));
		if(ComplementEqual_StrStr(Policy, "ACCEPT"))
		{
			bAcceptPolicy = true;
		}
		else
		{
			if(ComplementEqual_StrStr(Policy, "DENY"))
			{
				bAcceptPolicy = false;
			}
			else
			{
				// [Explicit Continue]
				goto J0x174;
			}
		}
		j = InStr(Mask, "*");
		if(NotEqual_IntInt(j, -1))
		{
			if(EqualEqual_StrStr(Left(Mask, j), Left(Address, j)))
			{
				bAcceptAddress = bAcceptPolicy;
				LastMatchingPolicy = i;
			}
			// [Explicit Continue]
			goto J0x174;
		}
		if(EqualEqual_StrStr(Mask, Address))
		{
			bAcceptAddress = bAcceptPolicy;
			LastMatchingPolicy = i;
		}
		J0x174:

		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x40;
	}
	if(Not_PreBool(bAcceptAddress))
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("Denied connection for ", Address), " with IP policy "), IPPolicies[LastMatchingPolicy]));
	}
	return bAcceptAddress;
	return;
}

defaultproperties
{
	IPPolicies="ACCEPT,*"
	IPBanned="You have been banned from this server."
	WrongPassword="The password you entered is incorrect."
	NeedPassword="You need to enter a password to join this game."
	InvalidOptions="The options you specified are invalid"
	AdminClass=Class'Engine.Admin'
}