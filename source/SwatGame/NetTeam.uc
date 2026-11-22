class NetTeam extends TeamInfo
	config
	hidecategories(Karma,Movement,Collision,Lighting,LightColor,Karma,Force);

var NetScoreInfo NetScoreInfo;
var private int respawnSecondsRemaining;
var array<NetPlayer> PawnsToDestroy;

replication
{
	// Pos:0x000
	reliable if(AndAnd_BoolBool(bNetDirty, EqualEqual_IntInt(int(Role), int(ROLE_Authority))))
		NetScoreInfo, respawnSecondsRemaining;
}

event PreBeginPlay()
{
	super(Actor).PreBeginPlay();
	NetScoreInfo = Spawn(Class'SwatGame.NetScoreInfo');
	return;
}

simulated function int GetTeamNumber()
{
	return -1;
	return;
}

simulated function string GetHumanReadableName()
{
	return TeamName;
	return;
}

simulated function int GetRespawnSecondsRemaining()
{
	return respawnSecondsRemaining;
	return;
}

function SetRespawnSecondsRemaining(int Seconds)
{
	assert(OrOr_BoolBool(EqualEqual_IntInt(int(Level.NetMode), int(NM_ListenServer)), EqualEqual_IntInt(int(Level.NetMode), int(NM_DedicatedServer))));
	respawnSecondsRemaining = Seconds;
	return;
}

simulated function AddNetPlayerToDestroy(NetPlayer PawnToDestroy)
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(string(self), "---NetTeam::AddNetPlayerToDestroy(). PawnToDestroy="), string(PawnToDestroy)));
	}
	PawnsToDestroy[PawnsToDestroy.Length] = PawnToDestroy;
	return;
}

simulated function DestroyPawnsForRespawn()
{
	local int i;

	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---NetTeam::DestroyPawnsForRespawn()."));
		MPLog(Concat_StrStr("...Number to destroy=", string(PawnsToDestroy.Length)));
	}
	i = 0;
	J0x7C:

	if(Less_IntInt(i, PawnsToDestroy.Length))
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog(Concat_StrStr("......destroying: ", string(PawnsToDestroy[i])));
		}
		PawnsToDestroy[i].Destroy();
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x7C;
	}
	PawnsToDestroy.Remove(0, PawnsToDestroy.Length);
	return;
}
