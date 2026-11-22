class GameModeCOOP extends GameModeMPBase implements IInterested_GameEvent_MissionCompleted, IInterested_GameEvent_MissionFailed
	config(SwatGame)
	notplaceable
	hidecategories(Karma);

var private bool bMissionCompleted;

function OnMissionEnded()
{
	super.OnMissionEnded();
	SGI.GameEvents.MissionFailed.UnRegister(self);
	SGI.GameEvents.MissionCompleted.UnRegister(self);
	return;
}

function OnMissionCompleted()
{
	bMissionCompleted = true;
	return;
}

function OnMissionFailed()
{
	bMissionCompleted = false;
	return;
}

function EndGame()
{
	if(bMissionCompleted)
	{
		NetRoundFinished(9);
	}
	else
	{
		NetRoundFinished(10);
	}
	return;
}

function Initialize()
{
	MPLog("Initialize() in GameModeCOOP.");
	super.Initialize();
	return;
}

function AssignPlayerRoles()
{
	return;
}

function SwatMPStartPoint FindNetPlayerStart(Controller Player)
{
	return super.FindNetPlayerStart(Player);
	return;
}

function NetRoundTimeRemaining(int TimeRemaining)
{
	if(EqualEqual_IntInt(int(SwatRepo(Level.GetRepo()).GuiConfig.SwatGameState), int(4)))
	{
		TimeRemaining = 0;
	}
	super.NetRoundTimeRemaining(TimeRemaining);
	return;
}

function NetRoundTimerExpired()
{
	return;
}

function SetSuspectsSpawnCluster(name NewSuspectsSpawnCluster)
{
	return;
}

function RespawnAll()
{
	return;
}

function PlayerJoinedTeam(SwatGamePlayerController Player, int Team)
{
	return;
}

function bool ValidSpawnClusterForMode(SwatMPStartCluster theCluster)
{
	return EqualEqual_IntInt(int(theCluster.ClusterTeam), int(0));
	return;
}

function bool ClusterPointValidForRoundStart(SwatMPStartCluster thePoint)
{
	if(EqualEqual_IntInt(int(ServerSettings(Level.CurrentServerSettings).DesiredMPEntryPoint), int(0)))
	{
		return thePoint.IsPrimaryEntryPoint;
	}
	else
	{
		return thePoint.IsSecondaryEntryPoint;
	}
	return;
}
