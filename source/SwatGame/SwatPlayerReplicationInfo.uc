class SwatPlayerReplicationInfo extends PlayerReplicationInfo
	config
	hidecategories(Karma,Movement,Collision,Lighting,LightColor,Karma,Force);

enum COOPStatus
{
	STATUS_NotReady,                // 0
	STATUS_Ready,                   // 1
	STATUS_Healthy,                 // 2
	STATUS_Injured,                 // 3
	STATUS_Incapacitated            // 4
};

var NetScoreInfo NetScoreInfo;
var private bool PlayerIsReady;
var bool bIsTheVIP;
var int SwatPlayerID;
var int RespawnTime;
var bool bIsDead;
var private bool bIsAdmin;
var SwatPlayerReplicationInfo.COOPStatus COOPPlayerStatus;

replication
{
	// Pos:0x000
	reliable if(AndAnd_BoolBool(bNetDirty, EqualEqual_IntInt(int(Role), int(ROLE_Authority))))
		COOPPlayerStatus, NetScoreInfo,
		PlayerIsReady, RespawnTime,
		SwatPlayerID, bIsAdmin,
		bIsDead, bIsTheVIP;
}

function SetAdmin(bool bAdmin)
{
	bIsAdmin = bAdmin;
	return;
}

simulated function bool IsAdmin()
{
	return bIsAdmin;
	return;
}

function TogglePlayerIsReady()
{
	assert(OrOr_BoolBool(EqualEqual_IntInt(int(Level.NetMode), int(NM_DedicatedServer)), EqualEqual_IntInt(int(Level.NetMode), int(NM_ListenServer))));
	PlayerIsReady = Not_PreBool(PlayerIsReady);
	return;
}

simulated function bool GetPlayerIsReady()
{
	return PlayerIsReady;
	return;
}

function ResetPlayerIsReady()
{
	PlayerIsReady = false;
	return;
}

function OnMissionEnded()
{
	RespawnTime = 0;
	return;
}
