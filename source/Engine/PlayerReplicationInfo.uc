class PlayerReplicationInfo extends ReplicationInfo
	native
	nativereplication
	config
	notplaceable
	hidecategories(Karma,Movement,Collision,Lighting,LightColor,Karma,Force);

var float Score;
var float Deaths;
var int Ping;
var Volume PlayerVolume;
var ZoneInfo PlayerZone;
var int NumLives;
var string PlayerName;
var string CharacterName;
var string OldCharacterName;
var string OldName;
var string PreviousName;
var int PlayerID;
var TeamInfo Team;
var int TeamID;
var Class<VoicePack> VoiceType;
var bool bAdmin;
var bool bIsFemale;
var bool bIsSpectator;
var bool bOnlySpectator;
var bool bWaitingPlayer;
var bool bReadyToPlay;
var bool bOutOfLives;
var bool bBot;
var bool bWelcomed;
var bool bReceivedPing;
var bool bHasFlag;
var int StartTime;
var localized string StringDead;
var localized string StringSpectating;
var localized string StringUnknown;
var int GoalsScored;
var int Kills;

replication
{
	// Pos:0x000
	reliable if(AndAnd_BoolBool(bNetDirty, EqualEqual_IntInt(int(Role), int(ROLE_Authority))))
		CharacterName, Deaths,
		PlayerName, PlayerVolume,
		PlayerZone, Score,
		Team, TeamID,
		VoiceType, bAdmin,
		bHasFlag, bIsFemale,
		bIsSpectator, bOnlySpectator,
		bOutOfLives, bReadyToPlay,
		bWaitingPlayer;

	// Pos:0x018
	reliable if(AndAnd_BoolBool(AndAnd_BoolBool(bNetDirty, OrOr_BoolBool(Not_PreBool(bNetOwner), bDemoRecording)), EqualEqual_IntInt(int(Role), int(ROLE_Authority))))
		Ping;

	// Pos:0x048
	reliable if(AndAnd_BoolBool(bNetInitial, EqualEqual_IntInt(int(Role), int(ROLE_Authority))))
		StartTime, bBot;
}

function PostBeginPlay()
{
	if(Less_IntInt(int(Role), int(ROLE_Authority)))
	{
		return;
	}
	StartTime = Level.Game.GameReplicationInfo.ElapsedTime;
	Timer();
	SetTimer(Add_FloatFloat(1.5000000, FRand()), true);
	return;
}

simulated function PostNetBeginPlay()
{
	local GameReplicationInfo GRI;

	foreach DynamicActors(Class'Engine.GameReplicationInfo', GRI)
	{
		GRI.AddPRI(self);
		break;
	}
	return;
}

simulated function Destroyed()
{
	local GameReplicationInfo GRI;

	foreach DynamicActors(Class'Engine.GameReplicationInfo', GRI)
	{
		GRI.RemovePRI(self);
	}
	super(Actor).Destroyed();
	return;
}

function SetCharacterName(string S)
{
	CharacterName = S;
	return;
}

function Reset()
{
	super(Actor).Reset();
	Score = 0.0000000;
	Deaths = 0.0000000;
	bReadyToPlay = false;
	NumLives = 0;
	bOutOfLives = false;
	return;
}

simulated function string GetHumanReadableName()
{
	return PlayerName;
	return;
}

simulated function string GetLocationName()
{
	if(AndAnd_BoolBool(EqualEqual_ObjectObject(PlayerVolume, none), EqualEqual_ObjectObject(PlayerZone, none)))
	{
		if(AndAnd_BoolBool(NotEqual_ObjectObject(Owner, none), Controller(Owner).IsInState('Dead')))
		{
			return StringDead;
		}
		else
		{
			return StringSpectating;
		}
	}
	if(AndAnd_BoolBool(NotEqual_ObjectObject(PlayerVolume, none), NotEqual_StrStr(PlayerVolume.LocationName, Class'Engine.Volume'.default.LocationName)))
	{
		return PlayerVolume.LocationName;
	}
	else
	{
		if(AndAnd_BoolBool(NotEqual_ObjectObject(PlayerZone, none), NotEqual_StrStr(PlayerZone.LocationName, "")))
		{
			return PlayerZone.LocationName;
		}
		else
		{
			if(NotEqual_StrStr(Level.Title, Level.default.Title))
			{
				return Level.Title;
			}
			else
			{
				return StringUnknown;
			}
		}
	}
	return;
}

simulated function Material GetPortrait()
{
	return;
}

event UpdateCharacter()
{
	return;
}

function UpdatePlayerLocation()
{
	local Volume V, Best;
	local Pawn P;
	local Controller C;

	C = Controller(Owner);
	if(NotEqual_ObjectObject(C, none))
	{
		P = C.Pawn;
	}
	if(EqualEqual_ObjectObject(P, none))
	{
		PlayerVolume = none;
		PlayerZone = none;
		return;
	}
	if(NotEqual_ObjectObject(PlayerZone, P.Region.Zone))
	{
		PlayerZone = P.Region.Zone;
	}
	foreach P.TouchingActors(Class'Engine.Volume', V)
	{
		if(EqualEqual_StrStr(V.LocationName, ""))
		{
			continue;
		}
		if(AndAnd_BoolBool(NotEqual_ObjectObject(Best, none), LessEqual_IntInt(V.LocationPriority, Best.LocationPriority)))
		{
			continue;
		}
		if(V.Encompasses(P))
		{
			Best = V;
		}
	}
	if(NotEqual_ObjectObject(PlayerVolume, Best))
	{
		PlayerVolume = Best;
	}
	return;
}

simulated function DisplayDebug(Canvas Canvas, out float YL, out float YPos)
{
	if(NotEqual_ObjectObject(Team, none))
	{
		Canvas.DrawText(Concat_StrStr(Concat_StrStr(Concat_StrStr("     PlayerName ", PlayerName), " Team "), Team.GetHumanReadableName()));
	}
	else
	{
		Canvas.DrawText(Concat_StrStr(Concat_StrStr("     PlayerName ", PlayerName), " NO Team"));
	}
	return;
}

event ClientNameChange()
{
	local PlayerController PC;

	foreach DynamicActors(Class'Engine.PlayerController', PC)
	{
		PC.ReceiveLocalizedMessage(Class'Engine.GameMessage', 2, self);
	}
	return;
}

function Timer()
{
	local Controller C;

	UpdatePlayerLocation();
	SetTimer(Add_FloatFloat(1.5000000, FRand()), true);
	if(Less_FloatFloat(FRand(), 0.6500000))
	{
		return;
	}
	if(Not_PreBool(bBot))
	{
		C = Controller(Owner);
		if(Not_PreBool(bReceivedPing))
		{
			Ping = int(C.ConsoleCommand("GETPING"));
		}
	}
	return;
}

function SetPlayerName(string S)
{
	OldName = PlayerName;
	PlayerName = S;
	return;
}

function SetWaitingPlayer(bool B)
{
	bIsSpectator = B;
	bWaitingPlayer = B;
	return;
}

defaultproperties
{
	StringDead="Dead"
	StringSpectating="Spectating"
	StringUnknown="Unknown"
	NetUpdateFrequency=5.0000000
}