class GameModeMPBase extends GameMode implements IInterested_GameEvent_PlayerDied, IInterested_GameEvent_PawnDied, IInterested_GameEvent_PawnArrested, IInterested_GameEvent_MissionStarted
	abstract
	native
	config(SwatGame)
	notplaceable
	hidecategories(Karma);

var private bool bIsRespawningEnabled;
var NetTeam Teams[2];
var private SwatMPStartCluster CurrentStartCluster[2];
var private int HighestPointUsed[2];
var array<SwatMPStartCluster> Team0StartClusters;
var array<SwatMPStartCluster> Team1StartClusters;
var config int DefaultRespawnSecondsRemaining;
var private int respawnSecondsRemaining[2];
var private Actor InterestingViewTarget;
var private Timer EndRoundSequenceTimer;
var private bool NotifiedOneMinuteWarning;
var private bool NotifiedTenSecondsWarning;

function OnMissionStarted()
{
	return;
}

function OnMissionEnded()
{
	SGI.GameEvents.PlayerDied.UnRegister(self);
	SGI.GameEvents.PawnDied.UnRegister(self);
	SGI.GameEvents.PawnArrested.UnRegister(self);
	SGI.GameEvents.MissionStarted.UnRegister(self);
	return;
}

function EndGame()
{
	NetRoundTimerExpired();
	return;
}

function Initialize()
{
	local int i;
	local SwatMPStartCluster ClusterPoint;

	if(Level.GetEngine().EnableDevTools)
	{
		MPLog("Initialize() in GameModeMPBase.");
	}
	super.Initialize();
	SGI.GameEvents.PlayerDied.Register(self);
	SGI.GameEvents.PawnDied.Register(self);
	SGI.GameEvents.PawnArrested.Register(self);
	SGI.GameEvents.MissionStarted.Register(self);
	assert(NotEqual_ObjectObject(Level, none));
	assert(NotEqual_ObjectObject(Level.CurrentServerSettings, none));
	assert(NotEqual_ObjectObject(ServerSettings(Level.CurrentServerSettings), none));
	bIsRespawningEnabled = Not_PreBool(ServerSettings(Level.CurrentServerSettings).bNoRespawn);
	if(Not_PreBool(Level.IsCOOPServer))
	{
		i = 0;
		J0x14A:

		if(Less_IntInt(i, 2))
		{
			Teams[i] = SGI.GetTeamFromID(i);
			assert(NotEqual_ObjectObject(Teams[i], none));
			respawnSecondsRemaining[i] = DefaultRespawnSecondsRemaining;
			AddAdd_PreInt(i);
			// [Loop Continue]
			goto J0x14A;
		}
	}
	foreach AllActors(Class'SwatGame.SwatMPStartCluster', ClusterPoint)
	{
		if(ValidSpawnClusterForMode(ClusterPoint))
		{
			ClusterPoint.IsEnabled = true;
			if(EqualEqual_IntInt(int(ClusterPoint.ClusterTeam), int(0)))
			{
				Team0StartClusters[Team0StartClusters.Length] = ClusterPoint;
				continue;
			}
			Team1StartClusters[Team1StartClusters.Length] = ClusterPoint;
		}
	}
	if(Not_PreBool(Level.IsCOOPServer))
	{
		AssertWithDescription(Greater_IntInt(Team0StartClusters.Length, 0), "Team 0 has no SwatMPStartClusters.");
		AssertWithDescription(Greater_IntInt(Team1StartClusters.Length, 0), "Team 1 has no SwatMPStartClusters.");
	}
	return;
}

function bool ValidSpawnClusterForMode(SwatMPStartCluster theCluster)
{
	assert(false);
	return true;
	return;
}

function AssignPlayerRoles()
{
	local Controller Controller;
	local SwatGamePlayerController PlayerController;

	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---GameModeMPBase::AssignPlayerRoles()."));
	}
	Controller = Level.ControllerList;
	J0x64:

	if(NotEqual_ObjectObject(Controller, none))
	{
		PlayerController = SwatGamePlayerController(Controller);
		if(NotEqual_ObjectObject(PlayerController, none))
		{
			PlayerController.ThisPlayerIsTheVIP = false;
			SwatPlayerReplicationInfo(PlayerController.PlayerReplicationInfo).bIsTheVIP = false;
		}
		Controller = Controller.nextController;
		// [Loop Continue]
		goto J0x64;
	}
	return;
}

function SetStartClustersForRoundStart()
{
	local int i;
	local SwatMPStartCluster ClusterPoint;

	if(Level.GetEngine().EnableDevTools)
	{
		Log(Concat_StrStr(string(self), "---GameModeMPBase::SetStartClustersForRoundStart()."));
	}
	i = 0;
	J0x5F:

	if(Less_IntInt(i, 2))
	{
		HighestPointUsed[i] = -1;
		foreach AllActors(Class'SwatGame.SwatMPStartCluster', ClusterPoint)
		{
			if(Level.GetEngine().EnableDevTools)
			{
				MPLog(Concat_StrStr("...Examining cluster: ", string(ClusterPoint)));
			}
			if(OrOr_BoolBool(AndAnd_BoolBool(EqualEqual_IntInt(int(ClusterPoint.ClusterTeam), int(0)), EqualEqual_IntInt(i, 0)), AndAnd_BoolBool(EqualEqual_IntInt(int(ClusterPoint.ClusterTeam), int(1)), EqualEqual_IntInt(i, 1))))
			{
				if(ClusterPointValidForRoundStart(ClusterPoint))
				{
					if(Level.GetEngine().EnableDevTools)
					{
						Log(Concat_StrStr("......setting CurrentStartCluster to ", string(ClusterPoint)));
					}
					CurrentStartCluster[i] = ClusterPoint;
					break;
				}
			}
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x5F;
	}
	return;
}

function bool ClusterPointValidForRoundStart(SwatMPStartCluster thePoint)
{
	assert(false);
	return true;
	return;
}

function SetSpawnClusterEnabled(name ClusterName, bool SetEnabled)
{
	SetSpawnClusterEnabledForArray(Team0StartClusters, ClusterName, SetEnabled);
	SetSpawnClusterEnabledForArray(Team1StartClusters, ClusterName, SetEnabled);
	return;
}

private function SetSpawnClusterEnabledForArray(array<SwatMPStartCluster> TeamStartClusters, name ClusterName, bool SetEnabled)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, TeamStartClusters.Length))
	{
		if(EqualEqual_NameName(TeamStartClusters[i].Label, ClusterName))
		{
			TeamStartClusters[i].IsEnabled = SetEnabled;
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

function SetStartClusterForRespawn(int TeamID)
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(string(self), "---GameModeMPBase::SetStartClusterForRespawn(). TeamID="), string(TeamID)));
	}
	HighestPointUsed[TeamID] = -1;
	if(EqualEqual_IntInt(TeamID, 0))
	{
		CalculateBestRespawnCluster(CurrentStartCluster[0], Team0StartClusters, 1);
	}
	else
	{
		CalculateBestRespawnCluster(CurrentStartCluster[1], Team1StartClusters, 0);
	}
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr("CurrentStartCluster for TeamID ", string(TeamID)), " is now "), string(CurrentStartCluster[TeamID])));
	}
	return;
}

private function CalculateBestRespawnCluster(out SwatMPStartCluster outCluster, array<SwatMPStartCluster> TeamStartClusters, int EnemyTeamID)
{
	local bool bFoundFirstDistance;
	local float BestClusterDistanceFromEnemy, ThisClusterDistanceFromEnemy;
	local int i;

	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(string(self), "---GameModeMPBase::CalculateBestRespawnCluster(). EnemyTeamID="), string(EnemyTeamID)));
	}
	outCluster = none;
	i = 0;
	J0x7E:

	if(Less_IntInt(i, TeamStartClusters.Length))
	{
		if(Not_PreBool(TeamStartClusters[i].IsEnabled))
		{
			// [Explicit Continue]
			goto J0x107;
		}
		ThisClusterDistanceFromEnemy = CalculateClusterDistanceFromEnemyPawns(TeamStartClusters[i], EnemyTeamID);
		if(OrOr_BoolBool(Not_PreBool(bFoundFirstDistance), Greater_FloatFloat(ThisClusterDistanceFromEnemy, BestClusterDistanceFromEnemy)))
		{
			bFoundFirstDistance = true;
			outCluster = TeamStartClusters[i];
			BestClusterDistanceFromEnemy = ThisClusterDistanceFromEnemy;
		}
		J0x107:

		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x7E;
	}
	AssertWithDescription(NotEqual_ObjectObject(outCluster, none), "There are no valid spawn clusters enabled for the current mode.  At least one spawn cluster must be made available for spawning!");
	return;
}

private function float CalculateClusterDistanceFromEnemyPawns(SwatMPStartCluster TeamStartCluster, int EnemyTeamID)
{
	local Controller Controller;
	local SwatGamePlayerController PlayerController;
	local bool bFoundFirstDistance;
	local float ClosestDistanceFromClusterToEnemyPawn, ThisDistanceFromClusterToEnemyPawn;

	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---GameModeMPBase::CalculateClusterDistanceFromEnemyPawns()."));
	}
	Controller = Level.ControllerList;
	J0x79:

	if(NotEqual_ObjectObject(Controller, none))
	{
		PlayerController = SwatGamePlayerController(Controller);
		if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(PlayerController, none), NotEqual_ObjectObject(PlayerController.SwatPlayer, none)), Not_PreBool(PlayerController.IsDead())), Not_PreBool(PlayerController.IsCuffed())), EqualEqual_IntInt(PlayerController.SwatRepoPlayerItem.TeamID, EnemyTeamID)))
		{
			ThisDistanceFromClusterToEnemyPawn = CalculateClusterDistanceFromPawn(TeamStartCluster, PlayerController.SwatPlayer);
			if(OrOr_BoolBool(Not_PreBool(bFoundFirstDistance), Less_FloatFloat(ThisDistanceFromClusterToEnemyPawn, ClosestDistanceFromClusterToEnemyPawn)))
			{
				bFoundFirstDistance = true;
				ClosestDistanceFromClusterToEnemyPawn = ThisDistanceFromClusterToEnemyPawn;
			}
		}
		Controller = Controller.nextController;
		// [Loop Continue]
		goto J0x79;
	}
	return ClosestDistanceFromClusterToEnemyPawn;
	return;
}

// Export UGameModeMPBase::execCalculateClusterDistanceFromPawn(FFrame&, void* const)
private native function float CalculateClusterDistanceFromPawn(SwatMPStartCluster FromTeamStartCluster, Pawn ToPawn);

function SwatMPStartPoint FindNetPlayerStart(Controller Player)
{
	local SwatMPStartPoint thePoint;
	local NetTeam TheNetTeam;
	local SwatGamePlayerController thePlayerController;
	local SwatMPStartCluster TheStartCluster;
	local int TeamID, i;

	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr("---GameModeMPBase::FindNetPlayerStart(). Player=", string(Player)));
	}
	thePlayerController = SwatGamePlayerController(Player);
	assert(NotEqual_ObjectObject(thePlayerController, none));
	TeamID = thePlayerController.SwatRepoPlayerItem.TeamID;
	TheNetTeam = SGI.GetTeamFromID(TeamID);
	TheStartCluster = CurrentStartCluster[TeamID];
	assert(NotEqual_ObjectObject(TheStartCluster, none));
	i = Add_IntInt(HighestPointUsed[TeamID], 1);
	J0xDF:

	if(Less_IntInt(i, TheStartCluster.NumberOfStartPoints))
	{
		if(Level.GetEngine().EnableDevTools)
		{
			Log(Concat_StrStr("   testing point: ", string(i)));
		}
		thePoint = TheStartCluster.StartPoints[i];
		assert(NotEqual_ObjectObject(thePoint, none));
		if(SpawnPointCanBeUsed(thePoint))
		{
			if(Level.GetEngine().EnableDevTools)
			{
				MPLog(Concat_StrStr("  using point: ", string(i)));
			}
			HighestPointUsed[TeamID] = i;
			// [Explicit Break]
			goto J0x1BF;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0xDF;
	}
	J0x1BF:

	if(EqualEqual_IntInt(i, TheStartCluster.NumberOfStartPoints))
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog(" returning none.");
		}
		return none;
	}
	else
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog(Concat_StrStr(" returning thePoint. thePoint=", string(thePoint)));
		}
		return thePoint;
	}
	return;
}

private function bool SpawnPointCanBeUsed(Actor thePoint)
{
	local int j;

	j = 0;
	J0x07:

	if(Less_IntInt(j, thePoint.Touching.Length))
	{
		if(Level.GetEngine().EnableDevTools)
		{
			MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr(".......Touching[", string(j)), "]="), string(thePoint.Touching[j])));
		}
		if(thePoint.Touching[j].bBlockActors)
		{
			if(Level.GetEngine().EnableDevTools)
			{
				MPLog("*** Spawn point failed!!! ***");
				MPLog(Concat_StrStr("...spawn point=", string(thePoint)));
			}
			return false;
		}
		AddAdd_PreInt(j);
		// [Loop Continue]
		goto J0x07;
	}
	return true;
	return;
}

function RespawnReinforcements(int TeamID)
{
	local Controller i, Controller;
	local SwatGamePlayerController Current, SGPC, theLocalPlayerController;
	local NetPlayer theNetPlayer;
	local int NumberOfRespawningPlayers;

	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr("---GameModeMPBase::RespawnReinforcements(). TeamID=", string(TeamID)));
	}
	assert(EqualEqual_IntInt(int(Role), int(ROLE_Authority)));
	SetStartClusterForRespawn(TeamID);
	Teams[TeamID].DestroyPawnsForRespawn();
	theLocalPlayerController = SwatGamePlayerController(Level.GetLocalPlayerController());
	i = Level.ControllerList;
	J0xBE:

	if(NotEqual_ObjectObject(i, none))
	{
		Current = SwatGamePlayerController(i);
		if(AndAnd_BoolBool(NotEqual_ObjectObject(Current, none), NotEqual_ObjectObject(Current, theLocalPlayerController)))
		{
			Current.ClientDestroyPawnsForRespawn(TeamID);
		}
		i = i.nextController;
		// [Loop Continue]
		goto J0xBE;
	}
	NumberOfRespawningPlayers = 0;
	Controller = Level.ControllerList;
	J0x13B:

	if(NotEqual_ObjectObject(Controller, none))
	{
		SGPC = SwatGamePlayerController(Controller);
		theNetPlayer = NetPlayer(SGPC.SwatPlayer);
		if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(SGPC, none), SGPC.HasEnteredFirstRoundOfNetworkGame()), EqualEqual_IntInt(SGPC.SwatRepoPlayerItem.TeamID, TeamID)), OrOr_BoolBool(SGPC.IsDead(), AndAnd_BoolBool(SGPC.IsCuffed(), Not_PreBool(theNetPlayer.IsTheVIP())))))
		{
			Level.Game.RestartPlayer(SGPC);
			AddAdd_Int(NumberOfRespawningPlayers);
		}
		if(AndAnd_BoolBool(NotEqual_ObjectObject(SGPC, none), EqualEqual_ObjectObject(InterestingViewTarget, none)))
		{
			InterestingViewTarget = SGPC.Pawn;
		}
		Controller = Controller.nextController;
		// [Loop Continue]
		goto J0x13B;
	}
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog("*** DONE RESPAWNING ***");
	}
	if(Greater_IntInt(NumberOfRespawningPlayers, 0))
	{
		if(EqualEqual_IntInt(TeamID, 0))
		{
			SGI.Broadcast(none, "", 'SwatRespawnEvent');
		}
		else
		{
			SGI.Broadcast(none, "", 'SuspectsRespawnEvent');
		}
	}
	return;
}

function NetRoundTimeRemaining(int TimeRemaining)
{
	SwatGameReplicationInfo(SGI.GameReplicationInfo).RoundTime = TimeRemaining;
	if(NotEqual_IntInt(int(SwatRepo(Level.GetRepo()).GuiConfig.SwatGameState), int(4)))
	{
		return;
	}
	if(LessEqual_IntInt(TimeRemaining, 0))
	{
		return;
	}
	if(AndAnd_BoolBool(LessEqual_IntInt(TimeRemaining, 60), Not_PreBool(NotifiedOneMinuteWarning)))
	{
		NotifiedOneMinuteWarning = true;
		SGI.Broadcast(none, "", 'OneMinWarning');
	}
	if(AndAnd_BoolBool(LessEqual_IntInt(TimeRemaining, 10), Not_PreBool(NotifiedTenSecondsWarning)))
	{
		NotifiedTenSecondsWarning = true;
		SGI.Broadcast(none, "", 'TenSecWarning');
	}
	return;
}

function OnPawnArrested(Pawn Player, Pawn Arrester)
{
	local SwatGamePlayerController swatVictim, swatArrester;
	local SwatPlayerReplicationInfo swatVictimInfo, swatArresterInfo;
	local NetTeam swatVictimTeam, swatArresterTeam;

	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self), "---GameModeMPBase::OnPawnArrested(). player="), string(Player)), ", Arrester="), string(Arrester)));
	}
	swatVictim = SwatGamePlayerController(Player.Controller);
	if(NotEqual_ObjectObject(swatVictim, none))
	{
		swatArrester = SwatGamePlayerController(Arrester.Controller);
		swatVictimInfo = SwatPlayerReplicationInfo(swatVictim.PlayerReplicationInfo);
		swatVictimTeam = NetTeam(swatVictim.PlayerReplicationInfo.Team);
		swatArresterInfo = SwatPlayerReplicationInfo(swatArrester.PlayerReplicationInfo);
		swatArresterTeam = NetTeam(swatArrester.PlayerReplicationInfo.Team);
		swatVictimInfo.NetScoreInfo.IncrementTimesArrested();
		swatVictimTeam.NetScoreInfo.IncrementTimesArrested();
		if(NetPlayer(Player).IsTheVIP())
		{
			swatArresterInfo.NetScoreInfo.IncrementArrestedVIP();
			swatArresterTeam.NetScoreInfo.IncrementArrestedVIP();
		}
		else
		{
			swatArresterInfo.NetScoreInfo.IncrementArrests();
			swatArresterTeam.NetScoreInfo.IncrementArrests();
		}
		SGI.BroadcastArrestedMessage(swatArrester, swatVictim);
	}
	InterestingViewTarget = Arrester;
	return;
}

function OnPlayerDied(PlayerController Player, Controller Killer)
{
	local SwatGamePlayerController swatVictim, swatKiller;
	local SwatPlayerReplicationInfo swatVictimInfo, swatKillerInfo;
	local NetTeam swatVictimTeam, swatKillerTeam;
	local SwatPlayer thePlayer;

	swatVictim = SwatGamePlayerController(Player);
	swatKiller = SwatGamePlayerController(Killer);
	thePlayer = swatVictim.SwatPlayer;
	assert(NotEqual_ObjectObject(thePlayer, none));
	if(AndAnd_BoolBool(thePlayer.IsArrested(), Not_PreBool(thePlayer.IsTheVIP())))
	{
		return;
	}
	swatVictimInfo = SwatPlayerReplicationInfo(swatVictim.PlayerReplicationInfo);
	swatVictimTeam = NetTeam(swatVictim.PlayerReplicationInfo.Team);
	if(NotEqual_ObjectObject(swatKiller, none))
	{
		swatKillerInfo = SwatPlayerReplicationInfo(swatKiller.PlayerReplicationInfo);
		swatKillerTeam = NetTeam(swatKiller.PlayerReplicationInfo.Team);
	}
	swatVictimInfo.NetScoreInfo.IncrementTimesDied();
	swatVictimTeam.NetScoreInfo.IncrementTimesDied();
	if(AndAnd_BoolBool(NotEqual_ObjectObject(swatKiller, none), NotEqual_ObjectObject(swatKiller, swatVictim)))
	{
		if(NotEqual_ObjectObject(swatVictimTeam, swatKillerTeam))
		{
			swatKillerInfo.NetScoreInfo.IncrementEnemyKills();
			swatKillerTeam.NetScoreInfo.IncrementEnemyKills();
		}
		else
		{
			swatKillerInfo.NetScoreInfo.IncrementFriendlyKills();
			swatKillerTeam.NetScoreInfo.IncrementFriendlyKills();
		}
	}
	InterestingViewTarget = swatKiller.Pawn;
	return;
}

function OnPawnDied(Pawn Pawn, Actor Killer, bool WasAThreat)
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(string(self), "::OnPawnDied() ... setting InterestingViewTarget to "), string(Killer)));
	}
	InterestingViewTarget = Killer;
	return;
}

function PlayerJoinedTeam(SwatGamePlayerController Player, int Team)
{
	return;
}

function RespawnAll()
{
	return;
}

protected function bool IsRespawningEnabled()
{
	return bIsRespawningEnabled;
	return;
}

protected function DecrementRespawnTimer(int Team)
{
	assert(EqualEqual_IntInt(int(Role), int(ROLE_Authority)));
	if(IsRespawningEnabled())
	{
		assert(Greater_IntInt(respawnSecondsRemaining[Team], 0));
		SubtractSubtract_Int(respawnSecondsRemaining[Team]);
		Teams[Team].SetRespawnSecondsRemaining(respawnSecondsRemaining[Team]);
		DisplayRespawnTimer(Team);
		if(LessEqual_IntInt(respawnSecondsRemaining[Team], 0))
		{
			OnRespawnTimerAtZero(Team);
		}
	}
	UpdatePlayerDeathFlags(Team);
	return;
}

protected function UpdatePlayerDeathFlags(int Team)
{
	local Controller Controller;
	local SwatGamePlayerController Player;

	Controller = Level.ControllerList;
	J0x14:

	if(NotEqual_ObjectObject(Controller, none))
	{
		Player = SwatGamePlayerController(Controller);
		if(AndAnd_BoolBool(NotEqual_ObjectObject(Player, none), EqualEqual_IntInt(Player.SwatRepoPlayerItem.TeamID, Team)))
		{
			SwatPlayerReplicationInfo(Player.PlayerReplicationInfo).bIsDead = Player.IsDead();
		}
		Controller = Controller.nextController;
		// [Loop Continue]
		goto J0x14;
	}
	return;
}

protected function OnRespawnTimerAtZero(int Team)
{
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr("---GameModeMPBase::OnRespawnTimerAtZero(). TeamID=", string(Team)));
	}
	RespawnReinforcements(Team);
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr("...setting respawn timer for team ", string(Team)), " to: "), string(DefaultRespawnSecondsRemaining)));
	}
	respawnSecondsRemaining[Team] = DefaultRespawnSecondsRemaining;
	return;
}

protected function DisplayRespawnTimer(int Team)
{
	local Controller Controller;
	local SwatGamePlayerController Player;

	Controller = Level.ControllerList;
	J0x14:

	if(NotEqual_ObjectObject(Controller, none))
	{
		Player = SwatGamePlayerController(Controller);
		if(AndAnd_BoolBool(NotEqual_ObjectObject(Player, none), EqualEqual_IntInt(Player.SwatRepoPlayerItem.TeamID, Team)))
		{
			if(Greater_IntInt(respawnSecondsRemaining[Team], 0))
			{
				if(Player.IsDead())
				{
					SwatPlayerReplicationInfo(Player.PlayerReplicationInfo).RespawnTime = respawnSecondsRemaining[Team];
				}
				else
				{
					SwatPlayerReplicationInfo(Player.PlayerReplicationInfo).RespawnTime = 0;
				}
			}
		}
		Controller = Controller.nextController;
		// [Loop Continue]
		goto J0x14;
	}
	return;
}

protected final function NetRoundFinished(SwatGameInfo.ESwatRoundOutcome RoundOutcome)
{
	switch(RoundOutcome)
	{
		case 0:
		case 2:
		case 5:
		case 7:
			SwatRepo(Level.GetRepo()).IncrementRoundsWon(0);
			break;
		case 1:
		case 3:
		case 6:
		case 8:
			SwatRepo(Level.GetRepo()).IncrementRoundsWon(1);
			break;
		default:
			break;
	}
	OnMissionEnded();
	SetAllPawnsRelevent();
	StartEndRoundSequence();
	EndRoundSequenceTimer = Spawn(Class'Engine.Timer');
	assert(NotEqual_ObjectObject(EndRoundSequenceTimer, none));
	EndRoundSequenceTimer.__TimerDelegate__Delegate = SetEndRoundTarget;
	EndRoundSequenceTimer.StartTimer(Divide_FloatFloat(SwatRepo(Level.GetRepo()).GuiConfig.MPPostMissionTime, 3.0000000));
	SwatRepo(Level.GetRepo()).OnNetRoundFinished(RoundOutcome);
	SwatGameReplicationInfo(SGI.GameReplicationInfo).OnMissionEnded();
	return;
}

protected function SetAllPawnsRelevent()
{
	local Controller Controller;
	local SwatGamePlayerController PlayerController;

	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---GameModeMPBase::SetAllPawnsRelevent()."));
	}
	Controller = Level.ControllerList;
	J0x66:

	if(NotEqual_ObjectObject(Controller, none))
	{
		PlayerController = SwatGamePlayerController(Controller);
		if(AndAnd_BoolBool(NotEqual_ObjectObject(PlayerController, none), NotEqual_ObjectObject(PlayerController.Pawn, none)))
		{
			PlayerController.Pawn.bAlwaysRelevant = true;
		}
		Controller = Controller.nextController;
		// [Loop Continue]
		goto J0x66;
	}
	return;
}

protected function StartEndRoundSequence()
{
	local Controller Controller;
	local SwatGamePlayerController PlayerController;

	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---GameModeMPBase::StartEndRoundSequence()."));
	}
	Controller = Level.ControllerList;
	J0x68:

	if(NotEqual_ObjectObject(Controller, none))
	{
		PlayerController = SwatGamePlayerController(Controller);
		if(NotEqual_ObjectObject(PlayerController, none))
		{
			PlayerController.DoStartEndRoundSequence();
			if(NotEqual_ObjectObject(PlayerController.SwatPlayer, none))
			{
				PlayerController.SwatPlayer.ServerEndFiringWeapon();
			}
		}
		Controller = Controller.nextController;
		// [Loop Continue]
		goto J0x68;
	}
	return;
}

protected function SetEndRoundTarget()
{
	local Controller Controller;
	local SwatGamePlayerController PlayerController;
	local string TargetName;
	local bool TargetOnSWAT;

	if(NotEqual_ObjectObject(NetPlayer(InterestingViewTarget), none))
	{
		TargetName = InterestingViewTarget.GetHumanReadableName();
		TargetOnSWAT = EqualEqual_IntInt(NetPlayer(InterestingViewTarget).GetTeamNumber(), 0);
	}
	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(Concat_StrStr(string(self), "---GameModeMPBase::SetEndRoundTarget(). InterestingViewTarget = "), string(InterestingViewTarget)));
	}
	Controller = Level.ControllerList;
	J0xC9:

	if(NotEqual_ObjectObject(Controller, none))
	{
		PlayerController = SwatGamePlayerController(Controller);
		if(NotEqual_ObjectObject(PlayerController, none))
		{
			PlayerController.DoSetEndRoundTarget(InterestingViewTarget, TargetName, TargetOnSWAT);
		}
		Controller = Controller.nextController;
		// [Loop Continue]
		goto J0xC9;
	}
	return;
}

simulated event Destroyed()
{
	local int i;
	local TriggerVolume TV;

	SGI.GameEvents.PlayerDied.UnRegister(self);
	SGI.GameEvents.PawnDied.UnRegister(self);
	SGI.GameEvents.PawnArrested.UnRegister(self);
	DestroyAllPawns();
	Level.SpawningManager.ResetForMPQuickRestart(Level);
	i = 0;
	J0x90:

	if(Less_IntInt(i, 2))
	{
		Teams[i].NetScoreInfo.ResetForMPQuickRestart();
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x90;
	}
	SwatGameReplicationInfo(Level.Game.GameReplicationInfo).ResetPlayerScoresForMPQuickRestart();
	foreach AllActors(Class'Gameplay.TriggerVolume', TV)
	{
		TV.ResetForMPQuickRestart();
	}
	if(NotEqual_ObjectObject(EndRoundSequenceTimer, none))
	{
		EndRoundSequenceTimer.Destroy();
		EndRoundSequenceTimer = none;
	}
	super(Actor).Destroyed();
	return;
}

protected final function DestroyAllPawns()
{
	local Pawn P;
	local Controller Controller;
	local SwatGamePlayerController PlayerController;

	if(Level.GetEngine().EnableDevTools)
	{
		MPLog(Concat_StrStr(string(self), "---GameModeMPBase::DestroyAllPawns()."));
	}
	Controller = Level.ControllerList;
	J0x62:

	if(NotEqual_ObjectObject(Controller, none))
	{
		PlayerController = SwatGamePlayerController(Controller);
		if(NotEqual_ObjectObject(PlayerController, none))
		{
			PlayerController.ClientDestroyAllPawns();
		}
		Controller = Controller.nextController;
		// [Loop Continue]
		goto J0x62;
	}
	foreach AllActors(Class'Engine.Pawn', P)
	{
		P.Destroy();
	}
	return;
}

defaultproperties
{
	DefaultRespawnSecondsRemaining=30
}