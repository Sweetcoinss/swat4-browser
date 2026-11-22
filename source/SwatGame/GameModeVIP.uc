class GameModeVIP extends GameModeMPBase implements IInterested_GameEvent_PawnUnarrestBegan, IInterested_GameEvent_PawnUnarrested, IInterested_GameEvent_VIPReachedGoal
	config(SwatGame)
	notplaceable
	hidecategories(Karma);

var private Timer respawnTimer;
var private Material VIPVestMaterial;
var private int DefaultVIPArrestedCountdown;
var private int VIPArrestedCountdown;
var private Timer VIPArrestedTimer;
var private bool VIPArrestedTimerExpired;
var array<VIPGoalBase> VIPGoals;
var private bool bHasRoundEnded;
var array<SwatGamePlayerController> PlayersOnSWATTeam;
var array<SwatGamePlayerController> PlayersOnSuspectsTeam;

function OnMissionEnded()
{
	super.OnMissionEnded();
	VIPArrestedTimer.StopTimer();
	respawnTimer.StopTimer();
	SGI.GameEvents.PawnUnarrested.UnRegister(self);
	SGI.GameEvents.PawnUnarrestBegan.UnRegister(self);
	SGI.GameEvents.VIPReachedGoal.UnRegister(self);
	return;
}

function Initialize()
{
	local VIPGoalBase VIPGoal;
	local int NumberOfVIPGoals;

	MPLog("Initialize() in GameModeVIP.");
	super.Initialize();
	SGI.GameEvents.PawnUnarrested.Register(self);
	SGI.GameEvents.PawnUnarrestBegan.Register(self);
	SGI.GameEvents.VIPReachedGoal.Register(self);
	respawnTimer = Spawn(Class'Engine.Timer');
	assert(NotEqual_ObjectObject(respawnTimer, none));
	respawnTimer.__TimerDelegate__Delegate = DecrementRespawnTimers;
	VIPArrestedTimer = Spawn(Class'Engine.Timer');
	assert(NotEqual_ObjectObject(VIPArrestedTimer, none));
	VIPArrestedTimer.__TimerDelegate__Delegate = DecrementVIPArrestedTimer;
	Level.SpawningManager.DoMPSpawning(SwatGameInfo(Level.Game), 'VIPGoalRoster');
	NumberOfVIPGoals = 0;
	foreach AllActors(Class'SwatGame.VIPGoalBase', VIPGoal)
	{
		MPLog(Concat_StrStr("...found a VIPGoal=", string(VIPGoal)));
		VIPGoals[VIPGoals.Length] = VIPGoal;
		AddAdd_PreInt(NumberOfVIPGoals);
	}
	AssertWithDescription(Greater_IntInt(NumberOfVIPGoals, 0), "There are no VIP goals in the level!");
	return;
}

function OnMissionStarted()
{
	respawnTimer.StartTimer(1.0000000, true);
	return;
}

function AssignPlayerRoles()
{
	local Controller Controller;
	local SwatGamePlayerController Player;
	local int RandomIndex;

	super.AssignPlayerRoles();
	MPLog(Concat_StrStr(string(self), "---GameModeVIP::AssignPlayerRoles()."));
	PlayersOnSWATTeam.Remove(0, PlayersOnSWATTeam.Length);
	PlayersOnSuspectsTeam.Remove(0, PlayersOnSuspectsTeam.Length);
	Controller = Level.ControllerList;
	J0x65:

	if(NotEqual_ObjectObject(Controller, none))
	{
		Player = SwatGamePlayerController(Controller);
		if(AndAnd_BoolBool(NotEqual_ObjectObject(Player, none), EqualEqual_IntInt(Player.SwatRepoPlayerItem.TeamID, 0)))
		{
			MPLog(Concat_StrStr("...adding SGPC to SWAT array: player=", string(Player)));
			PlayersOnSWATTeam[PlayersOnSWATTeam.Length] = Player;
		}
		Controller = Controller.nextController;
		// [Loop Continue]
		goto J0x65;
	}
	if(EqualEqual_IntInt(PlayersOnSWATTeam.Length, 0))
	{
		Controller = Level.ControllerList;
		J0x129:

		if(NotEqual_ObjectObject(Controller, none))
		{
			Player = SwatGamePlayerController(Controller);
			if(AndAnd_BoolBool(NotEqual_ObjectObject(Player, none), EqualEqual_IntInt(Player.SwatRepoPlayerItem.TeamID, 1)))
			{
				MPLog(Concat_StrStr("...adding SGPC to Suspects array: player=", string(Player)));
				PlayersOnSuspectsTeam[PlayersOnSuspectsTeam.Length] = Player;
			}
			Controller = Controller.nextController;
			// [Loop Continue]
			goto J0x129;
		}
		assert(Greater_IntInt(PlayersOnSuspectsTeam.Length, 0));
		RandomIndex = Rand(PlayersOnSuspectsTeam.Length);
		SGI.ChangePlayerTeam(PlayersOnSuspectsTeam[RandomIndex]);
		PlayersOnSWATTeam[0] = PlayersOnSuspectsTeam[RandomIndex];
	}
	RandomIndex = Rand(PlayersOnSWATTeam.Length);
	MPLog(Concat_StrStr("...length of array=", string(PlayersOnSWATTeam.Length)));
	MPLog(Concat_StrStr("...RandomIndex=", string(RandomIndex)));
	MPLog(Concat_StrStr("......setting to true, player=", string(PlayersOnSWATTeam[RandomIndex])));
	PlayersOnSWATTeam[RandomIndex].ThisPlayerIsTheVIP = true;
	SwatPlayerReplicationInfo(PlayersOnSWATTeam[RandomIndex].PlayerReplicationInfo).bIsTheVIP = true;
	PlayersOnSWATTeam.Remove(0, PlayersOnSWATTeam.Length);
	PlayersOnSuspectsTeam.Remove(0, PlayersOnSuspectsTeam.Length);
	return;
}

function bool ValidSpawnClusterForMode(SwatMPStartCluster theCluster)
{
	return theCluster.UseInVIPEscort;
	return;
}

function bool ClusterPointValidForRoundStart(SwatMPStartCluster thePoint)
{
	return AndAnd_BoolBool(thePoint.UseInVIPEscort, EqualEqual_BoolBool(thePoint.NeverFirstSpawnInVIPRound, false));
	return;
}

function OnPawnArrested(Pawn Arrestee, Pawn Arrester)
{
	local SwatGamePlayerController SGPC;

	MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self), "---GameModeVIP::OnPawnArrested(). Arrestee="), string(Arrestee)), ", Arrester="), string(Arrester)));
	super.OnPawnArrested(Arrestee, Arrester);
	SGPC = SwatGamePlayerController(Arrestee.Controller);
	if(AndAnd_BoolBool(NotEqual_ObjectObject(SGPC, none), SGPC.SwatPlayer.IsTheVIP()))
	{
		VIPArrestedCountdown = DefaultVIPArrestedCountdown;
		VIPArrestedTimer.StartTimer(1.0000000, true);
		DisplayBroadcastMessage("", 'VIPCaptured');
	}
	return;
}

function OnPlayerDied(PlayerController Player, Controller Killer)
{
	local SwatGamePlayerController SGPC_Killed, SGPC_Killer;
	local NetTeam swatKillerTeam;
	local SwatPlayerReplicationInfo swatKillerInfo;
	local int TeamOfKiller;

	MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self), "---GameModeVIP::OnPlayerDied(). player="), string(Player)), ", killer="), string(Killer)));
	super.OnPlayerDied(Player, Killer);
	SGPC_Killed = SwatGamePlayerController(Player);
	if(NotEqual_ObjectObject(SGPC_Killed, none))
	{
		if(SGPC_Killed.SwatPlayer.IsTheVIP())
		{
			SGPC_Killer = SwatGamePlayerController(Killer);
			if(EqualEqual_ObjectObject(SGPC_Killed, SGPC_Killer))
			{
				NetRoundFinished(4);
				return;
			}
			TeamOfKiller = SGPC_Killer.SwatRepoPlayerItem.TeamID;
			swatKillerInfo = SwatPlayerReplicationInfo(SGPC_Killer.PlayerReplicationInfo);
			swatKillerTeam = NetTeam(SGPC_Killer.PlayerReplicationInfo.Team);
			if(EqualEqual_IntInt(TeamOfKiller, 0))
			{
				swatKillerInfo.NetScoreInfo.IncrementKilledVIPInvalid();
				swatKillerTeam.NetScoreInfo.IncrementKilledVIPInvalid();
				NetRoundFinished(8);
			}
			else
			{
				if(VIPArrestedTimerExpired)
				{
					swatKillerInfo.NetScoreInfo.IncrementKilledVIPValid();
					swatKillerTeam.NetScoreInfo.IncrementKilledVIPValid();
					NetRoundFinished(6);
				}
				else
				{
					swatKillerInfo.NetScoreInfo.IncrementKilledVIPInvalid();
					swatKillerTeam.NetScoreInfo.IncrementKilledVIPInvalid();
					NetRoundFinished(7);
				}
			}
		}
	}
	return;
}

function OnPawnUnarrestBegan(Pawn Arrester, Pawn Arrestee)
{
	MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self), "---GameModeVIP::OnPawnUnarrestBegan(). Arrester="), string(Arrester)), ", Arrestee="), string(Arrestee)));
	return;
}

function OnPawnUnarrested(Pawn Arrester, Pawn Arrestee)
{
	local SwatGamePlayerController ArresterController;
	local SwatPlayerReplicationInfo ArresterInfo;
	local NetTeam ArresterTeam;
	local int i;
	local VIPGoalBase CurrentGoal;

	MPLog(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self), "---GameModeVIP::OnPawnUnarrested(). Arrester="), string(Arrester)), ", Arrestee="), string(Arrestee)));
	if(SwatPlayer(Arrestee).IsTheVIP())
	{
		VIPArrestedCountdown = 0;
		SwatGameReplicationInfo(SGI.GameReplicationInfo).SpecialTime = VIPArrestedCountdown;
		VIPArrestedTimer.StopTimer();
		VIPArrestedTimerExpired = false;
		DisplayBroadcastMessage("", 'VIPRescued');
		ArresterController = SwatGamePlayerController(Arrester.Controller);
		ArresterInfo = SwatPlayerReplicationInfo(ArresterController.PlayerReplicationInfo);
		ArresterTeam = NetTeam(ArresterController.PlayerReplicationInfo.Team);
		ArresterInfo.NetScoreInfo.IncrementUnarrestedVIP();
		ArresterTeam.NetScoreInfo.IncrementUnarrestedVIP();
		i = 0;
		J0x14A:

		if(Less_IntInt(i, VIPGoals.Length))
		{
			CurrentGoal = VIPGoals[i];
			MPLog(Concat_StrStr("...VIPGoal=", string(CurrentGoal)));
			if(VIPIsInGoal(Arrestee, CurrentGoal))
			{
				HandleSWATWonRound(SwatPlayer(Arrestee));
			}
			AddAdd_PreInt(i);
			// [Loop Continue]
			goto J0x14A;
		}
	}
	return;
}

private function bool VIPIsInGoal(Pawn VIPPawn, VIPGoalBase TheGoal)
{
	local float Distance2D, CriticalDistance2D, HeightDifference, CriticalHeightDifference;

	Distance2D = VSize2D(Subtract_VectorVector(VIPPawn.Location, TheGoal.Location));
	CriticalDistance2D = Add_FloatFloat(VIPPawn.CollisionRadius, TheGoal.CollisionRadius);
	HeightDifference = Abs(Subtract_FloatFloat(VIPPawn.Location.Z, TheGoal.Location.Z));
	CriticalHeightDifference = Add_FloatFloat(VIPPawn.CollisionHeight, TheGoal.CollisionHeight);
	return AndAnd_BoolBool(Less_FloatFloat(Distance2D, CriticalDistance2D), Less_FloatFloat(HeightDifference, CriticalHeightDifference));
	return;
}

function OnVIPReachedGoal(SwatPlayer triggerer)
{
	MPLog(Concat_StrStr(string(self), "---GameModeVIP::OnVIPReachedGoal()."));
	if(Not_PreBool(bHasRoundEnded))
	{
		if(Not_PreBool(triggerer.IsArrested()))
		{
			HandleSWATWonRound(triggerer);
		}
		else
		{
			MPLog("...The VIP reached the goal but was arrested.");
		}
	}
	return;
}

private function HandleSWATWonRound(SwatPlayer VIPPlayer)
{
	local SwatGamePlayerController VIPController;
	local SwatPlayerReplicationInfo VIPInfo;
	local NetTeam VIPTeam;

	MPLog("---GameModeVIP::HandleSWATWonRound().");
	bHasRoundEnded = true;
	VIPController = SwatGamePlayerController(VIPPlayer.Controller);
	VIPInfo = SwatPlayerReplicationInfo(VIPController.PlayerReplicationInfo);
	VIPTeam = NetTeam(VIPController.PlayerReplicationInfo.Team);
	VIPInfo.NetScoreInfo.IncrementVIPPlayerEscaped();
	VIPTeam.NetScoreInfo.IncrementVIPPlayerEscaped();
	DisplayBroadcastMessage("", 'VIPSafe');
	InterestingViewTarget = VIPPlayer;
	NetRoundFinished(5);
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
	respawnTimer.StopTimer();
	NetRoundFinished(4);
	return;
}

private function DecrementVIPArrestedTimer()
{
	SubtractSubtract_PreInt(VIPArrestedCountdown);
	SwatGameReplicationInfo(SGI.GameReplicationInfo).SpecialTime = VIPArrestedCountdown;
	if(EqualEqual_IntInt(VIPArrestedCountdown, 0))
	{
		VIPArrestedTimerExpired = true;
		VIPArrestedTimer.StopTimer();
	}
	return;
}

private function DisplayBroadcastMessage(coerce string Message, name Event)
{
	local Controller Controller;
	local SwatGamePlayerController Player;

	Controller = Level.ControllerList;
	J0x14:

	if(NotEqual_ObjectObject(Controller, none))
	{
		Player = SwatGamePlayerController(Controller);
		if(NotEqual_ObjectObject(Player, none))
		{
			Player.ClientMessage(Message, Event);
		}
		Controller = Controller.nextController;
		// [Loop Continue]
		goto J0x14;
	}
	return;
}

simulated event Destroyed()
{
	local VIPGoalBase VIPGoal;

	SGI.GameEvents.PawnUnarrested.UnRegister(self);
	SGI.GameEvents.PawnUnarrestBegan.UnRegister(self);
	SGI.GameEvents.VIPReachedGoal.UnRegister(self);
	foreach AllActors(Class'SwatGame.VIPGoalBase', VIPGoal)
	{
		VIPGoal.Destroy();
	}
	VIPGoals.Remove(0, VIPGoals.Length);
	if(NotEqual_ObjectObject(respawnTimer, none))
	{
		respawnTimer.Destroy();
		respawnTimer = none;
	}
	if(NotEqual_ObjectObject(VIPArrestedTimer, none))
	{
		VIPArrestedTimer.Destroy();
		VIPArrestedTimer = none;
	}
	super.Destroyed();
	return;
}

defaultproperties
{
	VIPVestMaterial=Texture'mp_OfficerTex.VIPvest'
	DefaultVIPArrestedCountdown=120
}