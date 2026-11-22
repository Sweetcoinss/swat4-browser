class GameModeRD extends GameModeMPBase implements IInterested_GameEvent_BombDisabled
	config(SwatGame)
	notplaceable
	hidecategories(Karma);

var private Timer respawnTimer;
var private int BombsInLevel;
var private int BombsDisabled;

function OnMissionEnded()
{
	super.OnMissionEnded();
	respawnTimer.StopTimer();
	SGI.GameEvents.BombDisabled.UnRegister(self);
	return;
}

function Initialize()
{
	local BombBase Bomb;
	local SwatGameReplicationInfo SGRI;

	MPLog("Initialize() in GameModeRD.");
	super.Initialize();
	SGI.GameEvents.BombDisabled.Register(self);
	respawnTimer = Spawn(Class'Engine.Timer');
	assert(NotEqual_ObjectObject(respawnTimer, none));
	respawnTimer.__TimerDelegate__Delegate = DecrementRespawnTimers;
	Level.SpawningManager.DoMPSpawning(SwatGameInfo(Level.Game), 'BombRoster');
	BombsDisabled = 0;
	BombsInLevel = 0;
	foreach AllActors(Class'SwatGame.BombBase', Bomb)
	{
		AddAdd_PreInt(BombsInLevel);
	}
	MPLog(Concat_StrStr("BombsInLevel=", string(BombsInLevel)));
	AssertWithDescription(Greater_IntInt(BombsInLevel, 0), "There are no bombs in the level!");
	SGRI = SwatGameReplicationInfo(Level.Game.GameReplicationInfo);
	SGRI.DiffusedBombs = 0;
	SGRI.TotalNumberOfBombs = BombsInLevel;
	return;
}

function OnMissionStarted()
{
	respawnTimer.StartTimer(1.0000000, true);
	return;
}

function bool ValidSpawnClusterForMode(SwatMPStartCluster theCluster)
{
	return theCluster.UseInRapidDeployment;
	return;
}

function bool ClusterPointValidForRoundStart(SwatMPStartCluster thePoint)
{
	return AndAnd_BoolBool(thePoint.UseInRapidDeployment, EqualEqual_BoolBool(thePoint.NeverFirstSpawnInRDRound, false));
	return;
}

function OnPawnArrested(Pawn Arrestee, Pawn Arrester)
{
	MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self), "---GameModeRD::OnPlayerArrested(). Arrestee="), string(Arrestee)), ", Arrester="), string(Arrestee)));
	super.OnPawnArrested(Arrestee, Arrester);
	return;
}

function OnPlayerDied(PlayerController Player, Controller Killer)
{
	MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self), "---GameModeBS::OnPlayerDied(). player="), string(Player)), ", killer="), string(Killer)));
	super.OnPlayerDied(Player, Killer);
	return;
}

private function DecrementRespawnTimers()
{
	DecrementRespawnTimer(0);
	DecrementRespawnTimer(1);
	return;
}

function OnBombDisabled(BombBase TheBomb, Pawn Disarmer)
{
	local Controller Controller;
	local SwatGamePlayerController Player, DisarmerController;
	local SwatPlayerReplicationInfo DisarmerInfo;
	local NetTeam DisarmerTeam;

	DisarmerController = SwatGamePlayerController(Disarmer.Controller);
	DisarmerInfo = SwatPlayerReplicationInfo(DisarmerController.PlayerReplicationInfo);
	DisarmerTeam = NetTeam(DisarmerController.PlayerReplicationInfo.Team);
	MPLog(Concat_StrStr(Concat_StrStr(string(self), "---GameModeBS::OnBombDisabled(). TheBomb="), string(TheBomb)));
	Level.Game.dispatchMessage(Class'SwatGame.MessageBombDisarmed'.static.Allocate(self)., construct_NameName(TheBomb.Spawner.GetSpawnerGroup(), TheBomb.Spawner.Name));
	Controller = Level.ControllerList;
	J0x109:

	if(NotEqual_ObjectObject(Controller, none))
	{
		Player = SwatGamePlayerController(Controller);
		if(NotEqual_ObjectObject(Player, none))
		{
			Player.ClientMessage("", 'DisarmBomb');
		}
		Controller = Controller.nextController;
		// [Loop Continue]
		goto J0x109;
	}
	DisarmerInfo.NetScoreInfo.IncrementBombsDiffused();
	DisarmerTeam.NetScoreInfo.IncrementBombsDiffused();
	AddAdd_PreInt(BombsDisabled);
	MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr("...BombsDisabled=", string(BombsDisabled)), ", BombsInLevel="), string(BombsInLevel)));
	AddAdd_Int(SwatGameReplicationInfo(Level.Game.GameReplicationInfo).DiffusedBombs);
	if(EqualEqual_IntInt(BombsDisabled, BombsInLevel))
	{
		MPLog("...Round ended.");
		InterestingViewTarget = Disarmer;
		NetRoundFinished(2);
	}
	return;
}

function NetRoundTimeRemaining(int TimeRemaining)
{
	super.NetRoundTimeRemaining(TimeRemaining);
	if(NotEqual_IntInt(int(SwatRepo(Level.GetRepo()).GuiConfig.SwatGameState), int(4)))
	{
		return;
	}
	SwatGameReplicationInfo(SGI.GameReplicationInfo).SpecialTime = TimeRemaining;
	return;
}

function NetRoundTimerExpired()
{
	local Controller Controller;
	local SwatGamePlayerController PlayerController;
	local SwatPlayerReplicationInfo SPRI;
	local NetTeam TheirTeam;

	MPLog(Concat_StrStr(string(self), "...The Suspects won the round."));
	Controller = Level.ControllerList;
	J0x3F:

	if(NotEqual_ObjectObject(Controller, none))
	{
		PlayerController = SwatGamePlayerController(Controller);
		if(AndAnd_BoolBool(NotEqual_ObjectObject(PlayerController, none), EqualEqual_IntInt(PlayerController.SwatRepoPlayerItem.TeamID, 1)))
		{
			SPRI = SwatPlayerReplicationInfo(PlayerController.PlayerReplicationInfo);
			TheirTeam = NetTeam(SPRI.Team);
			SPRI.NetScoreInfo.IncrementRDCrybaby();
			TheirTeam.NetScoreInfo.IncrementRDCrybaby();
		}
		Controller = Controller.nextController;
		// [Loop Continue]
		goto J0x3F;
	}
	InterestingViewTarget = findStaticByLabel(Class'Engine.Actor', 'BombExplodedMarker');
	NetRoundFinished(3);
	return;
}

simulated event Destroyed()
{
	local BombBase Bomb;

	SGI.GameEvents.BombDisabled.UnRegister(self);
	foreach AllActors(Class'SwatGame.BombBase', Bomb)
	{
		Bomb.Destroy();
	}
	if(NotEqual_ObjectObject(respawnTimer, none))
	{
		respawnTimer.Destroy();
		respawnTimer = none;
	}
	super.Destroyed();
	return;
}
