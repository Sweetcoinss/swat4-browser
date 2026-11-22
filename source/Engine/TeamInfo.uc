class TeamInfo extends ReplicationInfo
	native
	nativereplication
	config
	notplaceable
	hidecategories(Karma,Movement,Collision,Lighting,LightColor,Karma,Force);

var localized string TeamName;
var int Size;
var float Score;
var int TeamIndex;
var Color TeamColor;
var Color AltTeamColor;
var Actor HomeBase;
var Class<Pawn> DefaultPlayerClass;
var localized string ColorNames[4];
var Material TeamIcon;

replication
{
	// Pos:0x000
	reliable if(AndAnd_BoolBool(bNetDirty, EqualEqual_IntInt(int(Role), int(ROLE_Authority))))
		HomeBase, Score;

	// Pos:0x018
	reliable if(AndAnd_BoolBool(bNetInitial, EqualEqual_IntInt(int(Role), int(ROLE_Authority))))
		AltTeamColor, TeamColor,
		TeamIcon, TeamIndex,
		TeamName;
}

function bool BelongsOnTeam(Class<Pawn> PawnClass)
{
	return true;
	return;
}

simulated function UpdatePrecacheMaterials()
{
	Level.AddPrecacheMaterial(TeamIcon);
	return;
}

simulated function string GetHumanReadableName()
{
	if(EqualEqual_StrStr(TeamName, default.TeamName))
	{
		if(Less_IntInt(TeamIndex, 4))
		{
			return ColorNames[TeamIndex];
		}
		return At_StrStr(TeamName, string(TeamIndex));
	}
	return TeamName;
	return;
}

function bool AddToTeam(Controller Other)
{
	local Controller P;
	local bool bSuccess;

	if(EqualEqual_ObjectObject(Other, none))
	{
		Log("Added none to team!!!");
		return false;
	}
	if(NotEqual_ObjectObject(MessagingSpectator(Other), none))
	{
		return false;
	}
	AddAdd_Int(Size);
	Other.PlayerReplicationInfo.Team = self;
	bSuccess = false;
	if(Other.IsA('PlayerController'))
	{
		Other.PlayerReplicationInfo.TeamID = 0;
	}
	else
	{
		Other.PlayerReplicationInfo.TeamID = 1;
	}
	J0xA9:

	if(Not_PreBool(bSuccess))
	{
		bSuccess = true;
		P = Level.ControllerList;
		J0xD0:

		if(NotEqual_ObjectObject(P, none))
		{
			if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(P.bIsPlayer, NotEqual_ObjectObject(P, Other)), EqualEqual_ObjectObject(P.PlayerReplicationInfo.Team, Other.PlayerReplicationInfo.Team)), EqualEqual_IntInt(P.PlayerReplicationInfo.TeamID, Other.PlayerReplicationInfo.TeamID)))
			{
				bSuccess = false;
			}
			P = P.nextController;
			// [Loop Continue]
			goto J0xD0;
		}
		if(Not_PreBool(bSuccess))
		{
			Other.PlayerReplicationInfo.TeamID = Add_IntInt(Other.PlayerReplicationInfo.TeamID, 1);
		}
		// [Loop Continue]
		goto J0xA9;
	}
	return true;
	return;
}

function RemoveFromTeam(Controller Other)
{
	SubtractSubtract_Int(Size);
	Other.PlayerReplicationInfo.Team = none;
	Other.PlayerReplicationInfo.TeamID = 0;
	return;
}

defaultproperties
{
	TeamName="Team"
	TeamColor=(R=255,G=0,B=0,A=255)
	AltTeamColor=(R=200,G=0,B=0,A=255)
	ColorNames[0]="Red"
	ColorNames[1]="Blue"
	ColorNames[2]="Green"
	ColorNames[3]="Gold"
}