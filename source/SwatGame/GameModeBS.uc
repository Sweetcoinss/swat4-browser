class GameModeBS extends GameModeMPBase
	config(SwatGame)
	notplaceable
	hidecategories(Karma);

var private int DefaultNextRespawnTimerDuration;
var private int DefaultRespawnSecondsPenaltyIncrement;
var private int nextRespawnTimerDuration[2];
var private int respawnSecondsPenaltyIncrement[2];
var private Timer respawnTimer;
var private int ScoreLimitForRound;

function OnMissionEnded()
{
	super.OnMissionEnded();
	respawnTimer.StopTimer();
	return;
}

function Initialize()
{
	MPLog("Initialize() in GameModeBS.");
	super.Initialize();
	respawnTimer = Spawn(Class'Engine.Timer');
	assert(NotEqual_ObjectObject(respawnTimer, none));
	respawnTimer.__TimerDelegate__Delegate = DecrementRespawnTimers;
	ScoreLimitForRound = ServerSettings(Level.CurrentServerSettings).DeathLimit;
	return;
}

function OnMissionStarted()
{
	respawnTimer.StartTimer(1.0000000, true);
	return;
}

function bool ValidSpawnClusterForMode(SwatMPStartCluster theCluster)
{
	return theCluster.UseInBarricadedSuspects;
	return;
}

function bool ClusterPointValidForRoundStart(SwatMPStartCluster thePoint)
{
	return AndAnd_BoolBool(thePoint.UseInBarricadedSuspects, EqualEqual_BoolBool(thePoint.NeverFirstSpawnInBSRound, false));
	return;
}

function OnPawnArrested(Pawn Player, Pawn Arrester)
{
	local SwatGamePlayerController PC;
	local int SWATScore, SuspectsScore;

	MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self), "---GameModeBS::OnPawnArrested(). player="), string(Player)), ", Arrester="), string(Arrester)));
	super.OnPawnArrested(Player, Arrester);
	SWATScore = Teams[0].NetScoreInfo.GetScore();
	SuspectsScore = Teams[1].NetScoreInfo.GetScore();
	if(GreaterEqual_IntInt(SWATScore, ScoreLimitForRound))
	{
		NetRoundFinished(0);
	}
	else
	{
		if(GreaterEqual_IntInt(SuspectsScore, ScoreLimitForRound))
		{
			NetRoundFinished(1);
		}
		else
		{
			if(ServerSettings(Level.CurrentServerSettings).bNoRespawn)
			{
				PC = SwatGamePlayerController(Player.Controller);
				if(NotEqual_ObjectObject(PC, none))
				{
					CheckIfRespawnIsNecessary(PC);
				}
			}
		}
	}
	return;
}

function OnPlayerDied(PlayerController Player, Controller Killer)
{
	local SwatGamePlayerController PC;
	local int SWATScore, SuspectsScore;

	MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self), "---GameModeBS::OnPlayerDied(). player="), string(Player)), ", killer="), string(Killer)));
	super.OnPlayerDied(Player, Killer);
	SWATScore = Teams[0].NetScoreInfo.GetScore();
	SuspectsScore = Teams[1].NetScoreInfo.GetScore();
	if(GreaterEqual_IntInt(SWATScore, ScoreLimitForRound))
	{
		NetRoundFinished(0);
	}
	else
	{
		if(GreaterEqual_IntInt(SuspectsScore, ScoreLimitForRound))
		{
			NetRoundFinished(1);
		}
		else
		{
			if(ServerSettings(Level.CurrentServerSettings).bNoRespawn)
			{
				PC = SwatGamePlayerController(Player);
				if(NotEqual_ObjectObject(PC, none))
				{
					CheckIfRespawnIsNecessary(PC);
				}
			}
		}
	}
	return;
}

function CheckIfRespawnIsNecessary(SwatGamePlayerController Player)
{
	local int TeamNumber;

	MPLog(Concat_StrStr(string(self), "---GameModeBS::CheckIfRespawnIsNecessary()."));
	TeamNumber = Player.SwatRepoPlayerItem.TeamID;
	if(IsTeamAllDead(Player, TeamNumber))
	{
		MPLog("...team is dead.");
		if(EqualEqual_IntInt(TeamNumber, 0))
		{
			NetRoundFinished(1);
		}
		else
		{
			NetRoundFinished(0);
		}
	}
	return;
}

private function bool IsTeamAllDead(SwatGamePlayerController playerWhoDied, int i)
{
	local Controller Controller;
	local SwatGamePlayerController Player;

	MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self), "---GameModeBS::IsTeamAllDead(). playerWhoDied="), string(playerWhoDied)), ", team="), string(i)));
	Controller = Level.ControllerList;
	J0x6C:

	if(NotEqual_ObjectObject(Controller, none))
	{
		Player = SwatGamePlayerController(Controller);
		if(EqualEqual_ObjectObject(Player, none))
		{
		}
		else
		{
			if(EqualEqual_ObjectObject(Player, playerWhoDied))
			{
			}
			else
			{
				if(NotEqual_IntInt(Player.SwatRepoPlayerItem.TeamID, i))
				{
				}
				else
				{
					if(Not_PreBool(Player.HasEnteredFirstRoundOfNetworkGame()))
					{
					}
					else
					{
						if(AndAnd_BoolBool(Not_PreBool(Player.IsDead()), Not_PreBool(Player.IsCuffed())))
						{
							MPLog("...returning false.");
							return false;
						}
					}
				}
			}
		}
		Controller = Controller.nextController;
		// [Loop Continue]
		goto J0x6C;
	}
	MPLog("...returning true.");
	return true;
	return;
}

private function DecrementRespawnTimers()
{
	DecrementRespawnTimer(0);
	DecrementRespawnTimer(1);
	return;
}

function NetRoundTimerExpired()
{
	local int SWATScore, SuspectsScore;

	SWATScore = Teams[0].NetScoreInfo.GetScore();
	SuspectsScore = Teams[1].NetScoreInfo.GetScore();
	if(Greater_IntInt(SWATScore, SuspectsScore))
	{
		NetRoundFinished(0);
	}
	else
	{
		if(Greater_IntInt(SuspectsScore, SWATScore))
		{
			NetRoundFinished(1);
		}
		else
		{
			NetRoundFinished(4);
		}
	}
	return;
}

simulated event Destroyed()
{
	if(NotEqual_ObjectObject(respawnTimer, none))
	{
		respawnTimer.Destroy();
		respawnTimer = none;
	}
	super.Destroyed();
	return;
}

defaultproperties
{
	DefaultRespawnSecondsPenaltyIncrement=5
}