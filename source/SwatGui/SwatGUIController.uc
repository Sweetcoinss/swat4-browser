class SwatGUIController extends SwatGUIControllerBase
	config(GuiBase)
	hidecategories(Menu,Object);

enum eTimeType
{
	TIMER_Special,                  // 0
	TIMER_Mission,                  // 1
	TIMER_MetaMission,              // 2
	TIMER_Respawn                   // 3
};

enum eIMDType
{
	IMD_GameMessages,               // 0
	IMD_RespawnMessages             // 1
};

var() editconst editinline array<export editinline GUIPage> StorageStack "Holds an out-of-game set of page names for recreating the stack";
var() private editconst export editinline SwatMPLoadoutPanel MPLoadoutPanel "The loadout panel that should be used to display messages";
var() editconst editinline array<export editinline SwatChatPanel> ChatPanel "The chat panel that should be used to display messages";
var() private editconst export editinline SwatImportantMessageDisplay ImportantMessageDisplays[2] "The important message display";
var() private editconst export editinline SwatTimeDisplay TimeDisplays[4] "The important message display";
var(DEBUG) editconst export editinline SwatMPPage MPPopupMenu;
var(DEBUG) editconst export editinline SwatObjectivesPopupMenu SPPopupMenu;
var(DEBUG) editconst export editinline SwatMissionLoadingMenu MissionLoadingMenu;
var(DEBUG) editconst export editinline SwatServerSetupMenu ServerSetupMenu;
var private config localized string WaitingString;
var private config localized string VIPTimerText;
var private config localized string RDTimerText;
var private config localized string ViewingFrom;
var private config localized string ViewingFromNone;
var private config localized string ViewingFromVIP;
var private config localized string MissionCompleted;
var private config localized string MissionFailed;
var private config localized string ObjectiveShown;
var private config localized string SwatWin;
var private config localized string SuspectsWin;
var private config localized string GameTied;
var private config localized string OneMinWarning;
var private config localized string TenSecWarning;
var private config localized string DisarmBomb;
var private config localized string SwatWinRD;
var private config localized string SuspectsWinRD;
var private config localized string SwatRespawnEvent;
var private config localized string SuspectsRespawnEvent;
var private config localized string BothTeamsRespawnEvent;
var private config localized string VIPSafe;
var private config localized string VIPRescued;
var private config localized string VIPCaptured;
var private config localized string YouAreVIP;
var private config localized string WinSuspectsGoodKill;
var private config localized string WinSuspectsBadKill;
var private config localized string WinSwatBadKill;
var private config localized string PreGameText;
var private config localized string MidGameText;
var private config localized string PostGameText;
var bool bNetPlayerLoaded;
var string EnteredChatText;
var bool EnteredChatGlobal;

function InitializeController()
{
	Log(Concat_StrStr("[dkaplan] >>> InitializeController of (SwatGUIController) ", string(self)));
	super.InitializeController();
	GetMissionLoadingMenu();
	if(OrOr_BoolBool(Repo.InitAsListenServer, Repo.InitAsDedicatedServer))
	{
		return;
	}
	else
	{
		if(EqualEqual_IntInt(int(GuiConfig.SwatGameState), int(0)))
		{
			OpenMenu("SwatGui.SwatMainMenu", "SwatMainMenu");
			if(Not_PreBool(Repo.InitWithoutIntroMenu))
			{
				OpenMenu("SwatGui.SwatIntroMenu", "SwatIntroMenu");
			}
		}
		else
		{
			InternalOpenMenu(GetHUDPage());
		}
	}
	return;
}

function PollGUI()
{
	UpdateTimers();
	return;
}

function OnRoleChange(SwatGUIConfig.eSwatGameRole oldRole, SwatGUIConfig.eSwatGameRole newRole)
{
	local GameSpyManager GSM;

	Log(Concat_StrStr("[dkaplan] >>> OnRoleChange of (SwatGUIController) ", string(self)));
	switch(newRole)
	{
		case 0:
			GSM = ViewportOwner.Actor.Level.GetGameSpyManager();
			if(NotEqual_ObjectObject(GSM, none))
			{
				GSM.CleanUpGameSpy();
			}
			break;
		default:
			break;
	}
	ClearChatHistory();
	return;
}

function OnStateChange(SwatGUIConfig.eSwatGameState oldState, SwatGUIConfig.eSwatGameState NewState)
{
	local string CustomMissionLabel;

	Log(Concat_StrStr("[dkaplan] >>> OnStateChange of (SwatGUIController) ", string(self)));
	if(EqualEqual_IntInt(int(oldState), int(0)))
	{
		SaveEntryStack();
	}
	switch(NewState)
	{
		case 0:
			ConsoleCommand("CLEARURL");
			ClearChatHistory();
			if(EqualEqual_IntInt(StorageStack.Length, 0))
			{
				OpenMenu("SwatGui.SwatMainMenu", "SwatMainMenu");
			}
			else
			{
				OpenEntryStack();
			}
			break;
		case 6:
			if(AndAnd_BoolBool(NotEqual_IntInt(int(oldState), int(0)), OrOr_BoolBool(EqualEqual_IntInt(int(GuiConfig.SwatGameRole), int(4)), EqualEqual_IntInt(int(GuiConfig.SwatGameRole), int(5)))))
			{
				CloseAll();
				InternalOpenMenu(MPPopupMenu);
				break;
			}
		case 2:
		case 1:
			if(NotEqual_IntInt(int(oldState), int(0)))
			{
				HUDPage(GetHUDPage()).OnGameOver();
			}
			CloseAll();
			InternalOpenMenu(MissionLoadingMenu);
			break;
		case 3:
			GetCurrentPopupMenu();
			if(EqualEqual_IntInt(int(GuiConfig.SwatGameRole), int(4)))
			{
				GetServerSetupMenu();
			}
			RemoveNonChatMessagesFromHistory();
			CloseAll();
			InternalOpenMenu(GetHUDPage());
			HUDPage(GetHUDPage()).OnGameInit();
			Log(Concat_StrStr("      FirstTimeThrough=", string(GuiConfig.FirstTimeThrough)));
			Log(Concat_StrStr("      SwatGameRole=", string(GuiConfig.SwatGameRole)));
			if(OrOr_BoolBool(EqualEqual_IntInt(int(GuiConfig.SwatGameRole), int(4)), EqualEqual_IntInt(int(GuiConfig.SwatGameRole), int(5))))
			{
				SetPlayerNotReady();
				OnMessageRecieved("", 'PreGameWait');
				InternalOpenMenu(MPPopupMenu);
			}
			break;
		case 4:
			J0x260:

			if(NotEqual_ObjectObject(TopPage(), GetHUDPage()))
			{
				if(EqualEqual_ObjectObject(TopPage(), none))
				{
					InternalOpenMenu(GetHUDPage());
					// [Explicit Break]
					goto J0x2BE;
				}
				if(NotEqual_ObjectObject(SwatGUIPage(TopPage()), none))
				{
					SwatGUIPage(TopPage()).PerformClose();
				}
				else
				{
					CloseMenu();
				}
				// [Loop Continue]
				goto J0x260;
			}
			J0x2BE:

			ImportantMessageDisplays[int(0)].ClearDisplay();
			HUDPage(GetHUDPage()).OnGameStarted();
			break;
		case 5:
			HUDPage(GetHUDPage()).OnGameOver();
			if(OrOr_BoolBool(EqualEqual_IntInt(int(GuiConfig.SwatGameRole), int(4)), EqualEqual_IntInt(int(GuiConfig.SwatGameRole), int(5))))
			{
				InternalOpenMenu(MPPopupMenu);
			}
			else
			{
				GuiConfig.CurrentMission.SetHasMetDifficultyRequirement(GreaterEqual_IntInt(GetSwatGameInfo().LeadershipStatus(), GuiConfig.DifficultyScoreRequirement[int(GuiConfig.CurrentDifficulty)]));
				if(AndAnd_BoolBool(EqualEqual_IntInt(int(GuiConfig.SwatGameRole), int(1)), NotEqual_ObjectObject(Campaign, none)))
				{
					Campaign.MissionEnded(GetLevelInfo().Label, GuiConfig.CurrentDifficulty, Not_PreBool(GuiConfig.CurrentMission.IsMissionFailed()), GetSwatGameInfo().LeadershipStatus(), GuiConfig.CurrentMission.HasMetDifficultyRequirement());
				}
				else
				{
					if(EqualEqual_IntInt(int(GuiConfig.SwatGameRole), int(2)))
					{
						CustomMissionLabel = Concat_StrStr(Concat_StrStr(GuiConfig.GetPakFriendlyName(), "_"), GuiConfig.GetScenarioName());
						AssertWithDescription(NotEqual_StrStr(CustomMissionLabel, ""), "Attempted to save results for a custom mission with no name. This should never happen. Contact a programmer.");
						GuiConfig.MissionEnded(string(CustomMissionLabel), GuiConfig.CurrentDifficulty, Not_PreBool(GuiConfig.CurrentMission.IsMissionFailed()), GetSwatGameInfo().LeadershipStatus());
					}
				}
				OpenMenu("SwatGui.SwatDebriefingMenu", "SwatDebriefingMenu");
			}
			break;
		case 7:
			CloseAll();
			OpenMenu("SwatGui.SwatConnectionFailureMenu", "SwatConnectionFailureMenu", CurrentFailureMessage1, CurrentFailureMessage2);
			break;
		default:
			break;
	}
	return;
}

function SaveEntryStack()
{
	local int i;

	StorageStack.Remove(0, StorageStack.Length);
	i = 0;
	J0x14:

	if(Less_IntInt(i, MenuStack.Length))
	{
		if(NotEqual_ObjectObject(MenuStack[i], MissionLoadingMenu))
		{
			StorageStack[StorageStack.Length] = MenuStack[i];
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x14;
	}
	return;
}

function OpenEntryStack()
{
	local int i;

	CloseAll();
	i = 0;
	J0x0D:

	if(Less_IntInt(i, Subtract_IntInt(StorageStack.Length, 1)))
	{
		MenuStack[MenuStack.Length] = StorageStack[i];
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x0D;
	}
	InternalOpenMenu(StorageStack[Subtract_IntInt(StorageStack.Length, 1)]);
	return;
}

function LogMenuStack()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, Subtract_IntInt(MenuStack.Length, 1)))
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self), "::LogMenuStack() ... MenuStack["), string(i)), "] = "), string(MenuStack[i])));
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

function LogStorageStack()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, Subtract_IntInt(StorageStack.Length, 1)))
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self), "::LogStorageStack() ... StorageStack["), string(i)), "] = "), string(StorageStack[i])));
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

private function SendMessageToChat(string msg, name Type, optional bool bStopScrolling)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, ChatPanel.Length))
	{
		ChatPanel[i].MessageRecieved(msg, Type, bStopScrolling);
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

private function RemoveNonChatMessagesFromHistory()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, ChatPanel.Length))
	{
		ChatPanel[i].RemoveNonChatMessagesFromHistory();
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

private function ClearChatHistory()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, ChatPanel.Length))
	{
		ChatPanel[i].ClearChatHistory();
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

function bool OnMessageRecieved(string msg, name Type)
{
	switch(Type)
	{
		case 'Connected':
			if(NotEqual_ObjectObject(MPLoadoutPanel, none))
			{
				MPLoadoutPanel.LoadMultiPlayerLoadout();
			}
			break;
		case 'SwitchTeams':
		case 'NameChange':
		case 'Kick':
		case 'KickBan':
		case 'Say':
		case 'TeamSay':
		case 'CommandGiven':
		case 'SwatKill':
		case 'SuspectsKill':
		case 'SwatSuicide':
		case 'SuspectsSuicide':
		case 'SwatTeamKill':
		case 'SuspectsTeamKill':
		case 'SwatArrest':
		case 'SuspectsArrest':
		case 'PlayerConnect':
		case 'PlayerDisconnect':
		case 'SettingsUpdated':
		case 'NameChange':
		case 'Kick':
		case 'KickBan':
			if(OrOr_BoolBool(EqualEqual_IntInt(int(GuiConfig.SwatGameRole), int(4)), EqualEqual_IntInt(int(GuiConfig.SwatGameRole), int(5))))
			{
				SendMessageToChat(msg, Type);
			}
			break;
		case 'MissionEnded':
			break;
		case 'MissionCompleted':
			SendMessageToChat(msg, Type, true);
			ImportantMessageDisplays[int(0)].MessageRecieved(MissionCompleted);
			break;
		case 'MissionFailed':
			SendMessageToChat(msg, Type, true);
			ImportantMessageDisplays[int(0)].MessageRecieved(MissionFailed);
			break;
		case 'ObjectiveShown':
			SendMessageToChat(msg, Type);
			ImportantMessageDisplays[int(0)].MessageRecieved(ObjectiveShown);
			break;
		case 'SniperAlerted':
			SendMessageToChat(msg, Type);
			break;
		case 'EquipNotAvailable':
			SendMessageToChat(msg, Type);
			break;
		case 'Caption':
			SendMessageToChat(msg, Type);
			break;
		case 'PreGameWait':
			ImportantMessageDisplays[int(0)].MessageRecieved(WaitingString, -1.0000000);
			break;
		case 'SwatWin':
			ImportantMessageDisplays[int(0)].MessageRecieved(SwatWin, -1.0000000);
			break;
		case 'SuspectsWin':
			ImportantMessageDisplays[int(0)].MessageRecieved(SuspectsWin, -1.0000000);
			break;
		case 'AllBombsDisarmed':
			ImportantMessageDisplays[int(0)].MessageRecieved(SwatWinRD, -1.0000000);
			break;
		case 'BombExploded':
			ImportantMessageDisplays[int(0)].MessageRecieved(SuspectsWinRD, -1.0000000);
			break;
		case 'GameTied':
			ImportantMessageDisplays[int(0)].MessageRecieved(GameTied, -1.0000000);
			break;
		case 'OneMinWarning':
			ImportantMessageDisplays[int(0)].MessageRecieved(OneMinWarning);
			break;
		case 'TenSecWarning':
			ImportantMessageDisplays[int(0)].MessageRecieved(TenSecWarning);
			break;
		case 'DisarmBomb':
			ImportantMessageDisplays[int(0)].MessageRecieved(DisarmBomb);
			break;
		case 'SwatRespawnEvent':
			ImportantMessageDisplays[int(0)].MessageRecieved(SwatRespawnEvent);
			break;
		case 'SuspectsRespawnEvent':
			ImportantMessageDisplays[int(0)].MessageRecieved(SuspectsRespawnEvent);
			break;
		case 'VIPSafe':
			ImportantMessageDisplays[int(0)].MessageRecieved(VIPSafe, -1.0000000);
			break;
		case 'VIPRescued':
			ImportantMessageDisplays[int(0)].MessageRecieved(VIPRescued);
			SetTimer(0, 0);
			break;
		case 'VIPCaptured':
			ImportantMessageDisplays[int(0)].MessageRecieved(VIPCaptured);
			break;
		case 'YouAreVIP':
			MPLog("In SwatGUIController::OnMessageRecieved(). Should show VIP message.");
			ImportantMessageDisplays[int(0)].MessageRecieved(YouAreVIP);
			break;
		case 'WinSuspectsGoodKill':
			ImportantMessageDisplays[int(0)].MessageRecieved(WinSuspectsGoodKill, -1.0000000);
			break;
		case 'WinSuspectsBadKill':
			ImportantMessageDisplays[int(0)].MessageRecieved(WinSuspectsBadKill, -1.0000000);
			break;
		case 'WinSwatBadKill':
			MPLog(Concat_StrStr("...winswatbadkill. string=", WinSwatBadKill));
			ImportantMessageDisplays[int(0)].MessageRecieved(WinSwatBadKill, -1.0000000);
			break;
		case 'ViewingFromEvent':
			if(NotEqual_StrStr(msg, ""))
			{
				ImportantMessageDisplays[int(1)].MessageRecieved(Concat_StrStr(ViewingFrom, msg));
			}
			else
			{
				ImportantMessageDisplays[int(1)].ClearDisplay();
				SetTimer(3, 0);
			}
			break;
		case 'ViewingFromNoneEvent':
			ImportantMessageDisplays[int(1)].MessageRecieved(ViewingFromNone);
			break;
		case 'ViewingFromVIPEvent':
			ImportantMessageDisplays[int(1)].MessageRecieved(Concat_StrStr(ViewingFromVIP, msg));
			break;
		case 'DebugMessage':
			SendMessageToChat(msg, Type);
		default:
			return true;
			break;
	}
	// Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
	// 1 & Type:Switch Position:0x612
	return true;
	// Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
	// 1 & Type:Switch Position:0x612
	return;
	// Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
	// 1 & Type:Switch Position:0x612
	// Failed to format remaining nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
	// 1 & Type:Switch Position:0x612
}

function UpdateTimers()
{
	local SwatGameReplicationInfo SGRI;
	local SwatPlayerReplicationInfo SPRI;

	SGRI = SwatGameReplicationInfo(SwatGamePlayerController(ViewportOwner.Actor).GameReplicationInfo);
	SPRI = SwatPlayerReplicationInfo(SwatGamePlayerController(ViewportOwner.Actor).PlayerReplicationInfo);
	SetTimer(0, SGRI.SpecialTime);
	UpdateSpecialTimerLabel();
	SetTimer(1, SGRI.RoundTime);
	UpdateMissionTimerLabel();
	SetTimer(3, SPRI.RespawnTime);
	return;
}

final function SetMPLoadoutPanel(SwatMPLoadoutPanel Panel)
{
	MPLoadoutPanel = Panel;
	return;
}

final function SetChatPanel(SwatChatPanel Panel)
{
	ChatPanel[ChatPanel.Length] = Panel;
	return;
}

final function SetTimeDisplay(SwatTimeDisplay Display, SwatGUIController.eTimeType Type)
{
	assert(EqualEqual_ObjectObject(TimeDisplays[int(Type)], none));
	TimeDisplays[int(Type)] = Display;
	return;
}

final function SetIMD(SwatImportantMessageDisplay Display, SwatGUIController.eIMDType Type)
{
	assert(EqualEqual_ObjectObject(ImportantMessageDisplays[int(Type)], none));
	ImportantMessageDisplays[int(Type)] = Display;
	return;
}

private final function SetTimer(SwatGUIController.eTimeType Type, int Value)
{
	if(EqualEqual_ObjectObject(TimeDisplays[int(Type)], none))
	{
		return;
	}
	if(LessEqual_IntInt(Value, 0))
	{
		TimeDisplays[int(Type)].StopTimer();
	}
	else
	{
		TimeDisplays[int(Type)].StartTimer(Value,, true);
	}
	return;
}

private final function UpdateSpecialTimerLabel()
{
	local SwatGameReplicationInfo SGRI;
	local int BombsRemainingCount;
	local ServerSettings Settings;

	Settings = ServerSettings(ViewportOwner.Actor.Level.CurrentServerSettings);
	SGRI = SwatGameReplicationInfo(SwatGamePlayerController(ViewportOwner.Actor).GameReplicationInfo);
	if(EqualEqual_ObjectObject(SGRI, none))
	{
		return;
	}
	if(OrOr_BoolBool(EqualEqual_IntInt(int(GuiConfig.SwatGameRole), int(4)), EqualEqual_IntInt(int(GuiConfig.SwatGameRole), int(5))))
	{
		switch(Settings.GameType)
		{
			case 0:
				TimeDisplays[int(0)].TimerLabel.SetCaption("Shazbot");
				return;
				break;
			case 1:
				TimeDisplays[int(0)].TimerLabel.SetCaption(VIPTimerText);
				return;
				break;
			case 2:
				BombsRemainingCount = Subtract_IntInt(SGRI.TotalNumberOfBombs, SGRI.DiffusedBombs);
				TimeDisplays[int(0)].TimerLabel.SetCaption(Class'GUI.GUI'.static.FormatTextString(RDTimerText, string(BombsRemainingCount), string(SGRI.TotalNumberOfBombs)));
				return;
				break;
			default:
				break;
		}
	}
	else
	{
		if(AndAnd_BoolBool(GreaterEqual_IntInt(SGRI.TimedObjectiveIndex, 0), NotEqual_ObjectObject(Repo.MissionObjectives, none)))
		{
			TimeDisplays[int(0)].TimerLabel.SetCaption(Repo.MissionObjectives.Objectives[SGRI.TimedObjectiveIndex].TimerCaption);
		}
		return;
	}
}

private final function UpdateMissionTimerLabel()
{
	if(OrOr_BoolBool(EqualEqual_IntInt(int(GuiConfig.SwatGameRole), int(4)), EqualEqual_IntInt(int(GuiConfig.SwatGameRole), int(5))))
	{
		switch(GuiConfig.SwatGameState)
		{
			case 3:
				TimeDisplays[int(1)].TimerLabel.SetCaption(PreGameText);
				break;
			case 4:
				TimeDisplays[int(1)].TimerLabel.SetCaption(MidGameText);
				break;
			case 5:
				TimeDisplays[int(1)].TimerLabel.SetCaption(PostGameText);
				break;
			default:
				TimeDisplays[int(1)].TimerLabel.Hide();
				break;
		}
	}
	return;
}

exec function LoadLocalizedPerObjectConfig()
{
	local Object NewObj;
	local int i;
	local Class<SwatContentDumper> dumper;
	local Class NewClass;

	Log("[carlos] LoadLocalizedPerObjectConfig()");
	dumper = Class<SwatContentDumper>(DynamicLoadObject("SwatGui.SwatContentDumper", Class'Core.Class'));
	Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("[carlos] Dumping Content... dumper = ", string(dumper)), ", dumper.default.ClassName.Length= "), string(dumper.default.ClassName.Length)));
	i = 0;
	J0xCF:

	if(Less_IntInt(i, dumper.default.ClassName.Length))
	{
		NewClass = Class<Object>(DynamicLoadObject(dumper.default.ClassName[i], Class'Core.Class'));
		NewObj = NewClass.static.Allocate(self, none, dumper.default.ObjName[i]).;
		Construct_Void();
		if(EqualEqual_ObjectObject(NewObj, none))
		{
			Log(At_StrStr("  Could not load", dumper.default.ObjName[i]));
			// [Explicit Continue]
			goto J0x1A7;
		}
		Log(Concat_StrStr("Loaded object", dumper.default.ObjName[i]));
		J0x1A7:

		AddAdd_Int(i);
		// [Loop Continue]
		goto J0xCF;
	}
	LoadLocalizedPerObjectConfigGUI();
	return;
}

exec function LoadLocalizedPerObjectConfigGUI()
{
	local export editinline GUIComponent NewMenu;
	local int i;
	local Class<SwatGUIDumper> loader;

	Log("[dkaplan] Loading GUI");
	loader = Class<SwatGUIDumper>(DynamicLoadObject("SwatGui.SwatGUIDumper", Class'Core.Class'));
	Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("[dkaplan] Loading GUI... loader = ", string(loader)), ", loader.default.ClassName.Length= "), string(loader.default.ClassName.Length)));
	i = 0;
	J0xB6:

	if(Less_IntInt(i, loader.default.ClassName.Length))
	{
		NewMenu = CreateComponent(loader.default.ClassName[i], loader.default.ObjName[i]);
		if(EqualEqual_ObjectObject(NewMenu, none))
		{
			Log(At_StrStr("  Could not load", loader.default.ObjName[i]));
			// [Explicit Continue]
			goto J0x185;
		}
		if(Not_PreBool(NewMenu.bInited))
		{
			NewMenu.InitComponent(none);
		}
		Log(Concat_StrStr("Loaded Menu ", loader.default.ObjName[i]));
		J0x185:

		AddAdd_Int(i);
		// [Loop Continue]
		goto J0xB6;
	}
	return;
}

function bool CanChat()
{
	return AndAnd_BoolBool(OrOr_BoolBool(EqualEqual_IntInt(int(Repo.GuiConfig.SwatGameRole), int(4)), EqualEqual_IntInt(int(Repo.GuiConfig.SwatGameRole), int(5))), OrOr_BoolBool(OrOr_BoolBool(EqualEqual_IntInt(int(Repo.GuiConfig.SwatGameState), int(3)), EqualEqual_IntInt(int(Repo.GuiConfig.SwatGameState), int(4))), EqualEqual_IntInt(int(Repo.GuiConfig.SwatGameState), int(5))));
	return;
}

function OpenChat(bool bGlobal)
{
	local int i;

	Log(Concat_StrStr("[dkaplan] OpenChat bGlobal = ", string(bGlobal)));
	if(CanChat())
	{
		i = 0;
		J0x3B:

		if(Less_IntInt(i, ChatPanel.Length))
		{
			if(AndAnd_BoolBool(AndAnd_BoolBool(ChatPanel[i].bVisible, EqualEqual_ObjectObject(ChatPanel[i].MenuOwner, TopPage())), OrOr_BoolBool(EqualEqual_ObjectObject(SwatMPPage(TopPage()), none), Not_PreBool(SwatMPPage(TopPage()).bPopup))))
			{
				ChatPanel[i].OpenChatEntry(bGlobal);
			}
			AddAdd_Int(i);
			// [Loop Continue]
			goto J0x3B;
		}
	}
	return;
}

function ShowGamePopup(bool bSticky)
{
	local export editinline SwatPopupMenuBase PopupPage;

	if(OrOr_BoolBool(AndAnd_BoolBool(NotEqual_IntInt(int(Repo.GuiConfig.SwatGameState), int(3)), NotEqual_IntInt(int(Repo.GuiConfig.SwatGameState), int(4))), NotEqual_ObjectObject(GetHUDPage(), TopPage())))
	{
		return;
	}
	PopupPage = GetCurrentPopupMenu();
	if(bSticky)
	{
		InternalOpenMenu(PopupPage);
	}
	else
	{
		InternalOpenMenu(PopupPage, "Popup");
	}
	return;
}

function SwatPopupMenuBase GetCurrentPopupMenu()
{
	if(OrOr_BoolBool(EqualEqual_IntInt(int(Repo.GuiConfig.SwatGameRole), int(4)), EqualEqual_IntInt(int(Repo.GuiConfig.SwatGameRole), int(5))))
	{
		return GetMPPopupMenu();
	}
	else
	{
		return GetSPPopupMenu();
	}
	return;
}

function SwatMPPage GetMPPopupMenu()
{
	if(EqualEqual_ObjectObject(MPPopupMenu, none))
	{
		MPPopupMenu = SwatMPPage(CreateComponent("SwatGui.SwatMPPage", "SwatMPPage"));
		if(Not_PreBool(MPPopupMenu.bInited))
		{
			MPPopupMenu.InitComponent(none);
		}
	}
	assert(NotEqual_ObjectObject(MPPopupMenu, none));
	return MPPopupMenu;
	return;
}

function SwatObjectivesPopupMenu GetSPPopupMenu()
{
	if(EqualEqual_ObjectObject(SPPopupMenu, none))
	{
		SPPopupMenu = SwatObjectivesPopupMenu(CreateComponent("SwatGui.SwatObjectivesPopupMenu", "SwatObjectivesPopupMenu"));
		if(Not_PreBool(SPPopupMenu.bInited))
		{
			SPPopupMenu.InitComponent(none);
		}
	}
	assert(NotEqual_ObjectObject(SPPopupMenu, none));
	return SPPopupMenu;
	return;
}

function SwatMissionLoadingMenu GetMissionLoadingMenu()
{
	if(EqualEqual_ObjectObject(MissionLoadingMenu, none))
	{
		MissionLoadingMenu = SwatMissionLoadingMenu(CreateComponent("SwatGui.SwatMissionLoadingMenu", "SwatMissionLoadingMenu"));
		if(Not_PreBool(MissionLoadingMenu.bInited))
		{
			MissionLoadingMenu.InitComponent(none);
		}
	}
	assert(NotEqual_ObjectObject(MissionLoadingMenu, none));
	return MissionLoadingMenu;
	return;
}

function SwatServerSetupMenu GetServerSetupMenu()
{
	if(EqualEqual_ObjectObject(ServerSetupMenu, none))
	{
		ServerSetupMenu = SwatServerSetupMenu(CreateComponent("SwatGui.SwatServerSetupMenu", "SwatServerSetupMenu"));
		if(Not_PreBool(ServerSetupMenu.bInited))
		{
			ServerSetupMenu.InitComponent(none);
		}
	}
	assert(NotEqual_ObjectObject(ServerSetupMenu, none));
	return ServerSetupMenu;
	return;
}

function DebugServerList(int Num)
{
	SwatServerBrowserMenu(TopPage()).DebugServerList(Num);
	return;
}

function OnNetworkPlayerLoading()
{
	if(Not_PreBool(bNetPlayerLoaded))
	{
		InternalOpenMenu(GetMissionLoadingMenu());
		bNetPlayerLoaded = true;
	}
	return;
}

function ScrollChatPageUp()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, ChatPanel.Length))
	{
		if(ChatPanel[i].bVisible)
		{
			ChatPanel[i].ScrollChatPageUp();
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

function ScrollChatPageDown()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, ChatPanel.Length))
	{
		if(ChatPanel[i].bVisible)
		{
			ChatPanel[i].ScrollChatPageDown();
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

function ScrollChatUp()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, ChatPanel.Length))
	{
		if(ChatPanel[i].bVisible)
		{
			ChatPanel[i].ScrollChatUp();
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

function ScrollChatDown()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, ChatPanel.Length))
	{
		if(ChatPanel[i].bVisible)
		{
			ChatPanel[i].ScrollChatDown();
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

function ScrollChatToHome()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, ChatPanel.Length))
	{
		if(ChatPanel[i].bVisible)
		{
			ChatPanel[i].ScrollChatToHome();
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

function ScrollChatToEnd()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, ChatPanel.Length))
	{
		if(ChatPanel[i].bVisible)
		{
			ChatPanel[i].ScrollChatToEnd();
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

defaultproperties
{
	WaitingString="Waiting for other players..."
	VIPTimerText="VIP Time Remaining:"
	RDTimerText="Bombs Remaining: %1/%2"
	ViewingFrom="Now viewing from: "
	ViewingFromVIP="Now viewing from the VIP: "
	MissionCompleted="You have [c=00ff00]COMPLETED[\\c] the mission!"
	MissionFailed="You have [c=ff0000]FAILED[\\c] the mission!"
	ObjectiveShown="You have received a new objective!"
	SwatWin="SWAT has won the round!"
	SuspectsWin="The Suspects have won the round!"
	GameTied="The round has ended in a tie!"
	OneMinWarning="1 Minute left!"
	TenSecWarning="10 Seconds!"
	DisarmBomb="SWAT has disarmed a bomb!"
	SwatWinRD="SWAT has disarmed all the bombs!"
	SuspectsWinRD="[c=ff0000]The Suspects have won the round!"
	SwatRespawnEvent="SWAT reinforcements have arrived."
	SuspectsRespawnEvent="Suspect reinforcements have arrived."
	BothTeamsRespawnEvent="Reinforcements have arrived."
	VIPSafe="The VIP has escaped!  SWAT wins!"
	VIPRescued="SWAT has freed the VIP!"
	VIPCaptured="Suspects have captured the VIP!"
	YouAreVIP="You are the VIP! You must now avoid capture and escape."
	WinSuspectsGoodKill="SWAT accidentally killed the VIP! The suspects win the round."
	WinSuspectsBadKill="The Suspects have killed the VIP! The suspects win the round."
	WinSwatBadKill="The Suspects have killed the VIP too soon! SWAT wins the round."
	PreGameText="Time before round begins:"
	MidGameText="Round time remaining:"
	PostGameText="Time before next round:"
	bDontDisplayHelpText=false
	GridSize=5
	ResolutionX=1024
	ResolutionY=768
	FontNames=/* Array type was not detected. */
	StyleNames=/* Array type was not detected. */
	MouseCursors=/* Array type was not detected. */
	MouseCursorOffset=/* Array type was not detected. */
	DblClickWindow=0.3000000
	HelpStack=/* Array type was not detected. */
	ComponentClassList=/* Array type was not detected. */
	AutoLoad=/* Array type was not detected. */
	CaptureScriptExec=true
	DLG_OK="OK"
	DLG_Yes="YES"
	DLG_Continue="CONTINUE"
	DLG_Retry="RETRY"
	DLG_Ignore="IGNORE"
	DLG_No="NO"
	DLG_Abort="ABORT"
	DLG_Cancel="CANCEL"
}