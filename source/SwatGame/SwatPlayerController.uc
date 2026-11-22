class SwatPlayerController extends PlayerController
	native
	config(SwatGame)
	hidecategories(Karma);

var config float FlashScale;
var config Vector FlashFog;
var bool ShouldDisplayPRIIds;

replication
{
	// Pos:0x000
	reliable if(Less_IntInt(int(Role), int(ROLE_Authority)))
		ServerAddMap, ServerClearMaps,
		ServerQuickRestart, ServerSetAdminSettings,
		ServerSetDirty, ServerSetSettings;

	// Pos:0x00D
	reliable if(Less_IntInt(int(Role), int(ROLE_Authority)))
		AbortGame, Kick,
		KickBan, SAD,
		StartGame, Switch;
}

// Export USwatPlayerController::execShouldAutoJoinOnStartUp(FFrame&, void* const)
native function bool ShouldAutoJoinOnStartUp();

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	ShouldDisplayPRIIds = false;
	return;
}

function OnRoleChange(SwatGUIConfig.eSwatGameRole oldRole, SwatGUIConfig.eSwatGameRole newRole)
{
	Log(Concat_StrStr("[dkaplan] >>> OnRoleChange of (SwatPlayerController) ", string(self)));
	return;
}

function OnStateChange(SwatGUIConfig.eSwatGameState oldState, SwatGUIConfig.eSwatGameState NewState)
{
	Log(Concat_StrStr("[dkaplan] >>> OnStateChange of (SwatPlayerController) ", string(self)));
	return;
}

exec function OpenMenu(string theMenu)
{
	GUIController(Player.GUIController).OpenMenu(Left(theMenu, InStr(theMenu, " ")), Right(theMenu, Subtract_IntInt(Subtract_IntInt(Len(theMenu), InStr(theMenu, " ")), 1)));
	return;
}

exec function CloseMenu()
{
	GUIController(Player.GUIController).CloseMenu();
	return;
}

exec function SetGuiStyle(string Style)
{
	GUIController(Player.GUIController).ChangeActiveStyle(Style);
	return;
}

exec function SetGuiGridSize(int Size)
{
	GUIController(Player.GUIController).ChangeGridSize(Size);
	return;
}

exec function SetGuiRes(int xVal, int yVal)
{
	GUIController(Player.GUIController).ChangeResolutionX(xVal);
	GUIController(Player.GUIController).ChangeResolutionY(yVal);
	GUIController(Player.GUIController).SetGuiResolution();
	return;
}

function NotifyTakeHit(Pawn InstigatedBy, Vector HitLocation, int Damage, Class<DamageType> DamageType, Vector Momentum)
{
	if(AndAnd_BoolBool(NotEqual_ObjectObject(InstigatedBy, none), NotEqual_ObjectObject(InstigatedBy, self.Pawn)))
	{
		if(AndAnd_BoolBool(OrOr_BoolBool(Greater_IntInt(Damage, 0), bGodMode), Greater_IntInt(self.Pawn.Health, 0)))
		{
			ClientFlash(FlashScale, FlashFog);
		}
		DamageShake(Damage);
	}
	TriggerHitSpeech();
	return;
}

function DamageShake(int Damage)
{
	ShakeView(2.0000000, 750.0000000, Multiply_FloatVector(float(100000), vect(0.0000000, 1.0000000, 0.0000000)), 120000.0000000, vect(1.0000000, 1.0000000, 1.0000000), 5.0000000);
	return;
}

private function TriggerHitSpeech()
{
	if(AndAnd_BoolBool(NotEqual_ObjectObject(Pawn, none), Pawn.isAlive()))
	{
		if(SwatPawn(Pawn).IsIntenseInjury())
		{
			Pawn.BroadcastEffectEvent('ReactedInjuryIntense',,,,,,,, SwatPawn(Pawn).GetPlayerTag());
		}
		else
		{
			Pawn.BroadcastEffectEvent('ReactedInjuryNormal',,,,,,,, SwatPawn(Pawn).GetPlayerTag());
		}
	}
	return;
}

exec function Suicide()
{
	return;
	return;
}

exec function SetName(coerce string S)
{
	local SwatGUIConfig GC;
	local int Index;

	if(EqualEqual_StrStr(S, ""))
	{
		return;
	}
	GC = SwatRepo(Level.GetRepo()).GuiConfig;
	ReplaceText(S, "[b]", "{b}");
	ReplaceText(S, "[B]", "{B}");
	ReplaceText(S, "[i]", "{i}");
	ReplaceText(S, "[I]", "{I}");
	ReplaceText(S, "[u]", "{u}");
	ReplaceText(S, "[U]", "{U}");
	J0xAF:

	if(GreaterEqual_IntInt(InStr(GC.MPNameAllowableCharSet, Mid(S, Index, 1)), 0))
	{
		AddAdd_Int(Index);
		goto J0x108;
	}
	S = Concat_StrStr(Left(S, Index), Right(S, Subtract_IntInt(Len(S), Add_IntInt(Index, 1))));
	J0x108:

	if(!(GreaterEqual_IntInt(Index, Len(S))))
		goto J0xAF;
	if(Greater_IntInt(Len(S), GC.MPNameLength))
	{
		S = Left(S, GC.MPNameLength);
	}
	if(EqualEqual_StrStr(S, ""))
	{
		return;
	}
	if(EqualEqual_ObjectObject(Level.GetLocalPlayerController(), self))
	{
		GC.MPName = S;
		GC.SaveConfig();
	}
	ChangeName(S);
	if(EqualEqual_ObjectObject(Level.GetLocalPlayerController(), self))
	{
		UpdateURL("Name", GC.MPName, true);
	}
	return;
}

function ChangeName(coerce string S)
{
	Level.Game.ChangeName(self, S, true);
	return;
}

private simulated function LogPlayerIDs(GameReplicationInfo GRI)
{
	local int i;

	Log("-----------------");
	Log("ID	PLAYERNAME");
	i = 0;
	J0x2D:

	if(Less_IntInt(i, GRI.PRIArray.Length))
	{
		Log(Concat_StrStr(Concat_StrStr(string(i), "	"), GRI.PRIArray[i].PlayerName));
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x2D;
	}
	Log("-----------------");
	return;
}

exec function KBID(string S)
{
	KickBanID(S);
	return;
}

exec function KickBanID(string S)
{
	KickOrBanByID(S, true);
	return;
}

exec function KID(string S)
{
	KickID(S);
	return;
}

exec function KickID(string S)
{
	KickOrBanByID(S, false);
	return;
}

simulated function KickOrBanByID(string S, bool bKickBan)
{
	local int Id, i;
	local PlayerReplicationInfo PRI;

	i = 0;
	J0x07:

	if(Less_IntInt(i, Len(S)))
	{
		if(OrOr_BoolBool(Less_IntInt(Asc(Mid(S, i, 1)), 48), Greater_IntInt(Asc(Mid(S, i, 1)), 57)))
		{
			return;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	Id = int(S);
	if(OrOr_BoolBool(Less_IntInt(Id, 0), Greater_IntInt(Id, 15)))
	{
		return;
	}
	PRI = GameReplicationInfo.PRIArray[Id];
	if(EqualEqual_ObjectObject(PRI, none))
	{
		return;
	}
	if(bKickBan)
	{
		KickBan(PRI.PlayerName);
	}
	else
	{
		Kick(PRI.PlayerName);
	}
	return;
}

exec function KickBan(string S)
{
	SwatGameInfo(Level.Game).Admin.KickBan(self, S);
	return;
}

exec function Kick(string S)
{
	SwatGameInfo(Level.Game).Admin.Kick(self, S);
	return;
}

exec function SAD(string S)
{
	SwatGameInfo(Level.Game).Admin.AdminLogin(self, S);
	return;
}

exec function Switch(string S)
{
	SwatGameInfo(Level.Game).Admin.Switch(self, S);
	return;
}

exec function StartGame()
{
	SwatGameInfo(Level.Game).Admin.StartGame(self);
	return;
}

exec function AbortGame()
{
	SwatGameInfo(Level.Game).Admin.AbortGame(self);
	return;
}

exec function ShowIDs()
{
	ToggleIDs();
	return;
}

exec function ToggleIDs()
{
	if(SwatPlayerReplicationInfo(PlayerReplicationInfo).IsAdmin())
	{
		ShouldDisplayPRIIds = Not_PreBool(ShouldDisplayPRIIds);
	}
	return;
}

function ServerSetSettings(ServerSettings Settings, Repo.EMPMode newGameType, int newMapIndex, int newNumRounds, int newMaxPlayers, int newDeathLimit, int newPostGameTimeLimit, int newRoundTimeLimit, int newMPMissionReadyTime, bool newbShowTeammateNames, bool newbShowEnemyNames, bool newbNoRespawn, bool newbQuickRoundReset, float newFriendlyFireAmount, float newEnemyFireAmount, SwatStartPointBase.EEntryType newDesiredMPEntryPoint)
{
	Settings.SetServerSettings(self, newGameType, newMapIndex, newNumRounds, newMaxPlayers, newDeathLimit, newPostGameTimeLimit, newRoundTimeLimit, newMPMissionReadyTime, newbShowTeammateNames, newbShowEnemyNames, newbNoRespawn, newbQuickRoundReset, newFriendlyFireAmount, newEnemyFireAmount, newDesiredMPEntryPoint);
	return;
}

function ServerSetAdminSettings(ServerSettings Settings, string newServerName, string newPassword, bool newbPassworded, bool newbLAN)
{
	Settings.SetAdminServerSettings(self, newServerName, newPassword, newbPassworded, newbLAN);
	return;
}

function ServerAddMap(ServerSettings Settings, string MapName)
{
	Settings.AddMap(self, MapName);
	return;
}

function ServerClearMaps(ServerSettings Settings)
{
	Settings.ClearMaps(self);
	return;
}

function ServerSetDirty(ServerSettings Settings)
{
	Settings.SetDirty(self);
	return;
}

function ServerQuickRestart()
{
	SwatRepo(Level.GetRepo()).QuickServerRestart(self);
	return;
}

defaultproperties
{
	FlashScale=0.5000000
	FlashFog=(X=900.0000000,Y=0.0000000,Z=0.0000000)
	CheatClass=Class'SwatGame.SwatCheatManager'
}