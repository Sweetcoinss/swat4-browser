class SwatMPPage extends SwatPopupMenuBase
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

var(SwatGui) private export editinline config GUILabel MyServerNameLabel;
var(SwatGui) private export editinline config GUILabel MyWaitingForPlayersLabel;
var(SwatGui) private export editinline config GUIImage MyLoadingGraphic;
var(SwatGui) private export editinline config GUIImage MyLoadingBlackGraphic;
var(SwatGui) private export editinline config GUILabel MyLoadingTextLabel;
var(SwatGui) private export editinline config GUILabel MyBombsRemainingLabel;
var(SwatGui) private export editinline config GUILabel MyRoundsLabel;
var(SwatGui) private export editinline config GUIButton MyStartButton;
var(SwatGui) private export editinline config GUIButton MyBackButton;
var(SwatGui) private export editinline config GUIButton MyLoadoutButton;
var(SwatGui) private export editinline config GUIButton MyScoresButton;
var(SwatGui) private export editinline config SwatMPLoadoutPanel MyMPLoadoutPanel;
var(SwatGui) private export editinline config SwatMPScoresPanel MyMPScoresPanel;
var(SwatGui) private export editinline config GUIButton MyGameSettingsButton;
var(SwatGui) private export editinline config GUIButton MyServerSettingsButton;
var(SwatGui) private export editinline config GUILabel MyGameInfoLabel;
var(SwatGui) private export editinline config GUIScrollTextBox MyServerInfoBox;
var(SwatGui) private export editinline config SwatChatPanel MyChatPanel;
var(SwatGui) private config localized string BombsRemaining;
var(SwatGui) private config localized string RoundsRemainingString;
var(SwatGui) private config localized string ReadyString;
var(SwatGui) private config localized string ContinueString;
var(SwatGui) private config localized string GameModeAndLevelString;
var(SwatGui) private export editinline config GUILabel MissionLoadingStatusText;
var(SwatGui) private export editinline config GUIProgressBar MissionLoadingProgressBar;
var private config localized string LoadSplashString;
var private config localized string WaitForConnectionString;
var private config localized string LoadMapString;
var private config localized string DownloadString;
var(SwatGui) private export editinline config GUIImage LoadingImage;
var(SwatGui) config array<Material> DefaultImages;
var private config localized string ConfirmAbortString;
var private config localized string WaitingForPlayersString;
var private Repo.EMPMode CachedGameMode;
var private string CachedTitle;

function InitComponent(GUIComponent MyOwner)
{
	super.InitComponent(MyOwner);
	MyStartButton.__OnClick__Delegate = CommonOnClick;
	MyBackButton.__OnClick__Delegate = CommonOnClick;
	MyLoadoutButton.__OnClick__Delegate = CommonOnClick;
	MyScoresButton.__OnClick__Delegate = CommonOnClick;
	MyGameSettingsButton.__OnClick__Delegate = CommonOnClick;
	MyServerSettingsButton.__OnClick__Delegate = CommonOnClick;
	CachedGameMode = 0;
	MyGameInfoLabel.SetCaption(GC.GetGameModeName(0));
	MyServerInfoBox.SetContent(GC.GetGameDescription(0));
	return;
}

event HandleParameters(string Param1, string Param2, optional int param3)
{
	super.HandleParameters(Param1, Param2, param3);
	SwatGUIController(Controller).SetPlayerNotReady();
	MyStartButton.EnableComponent();
	return;
}

event PostActivate()
{
	super(GUIPage).PostActivate();
	SetupPopup();
	return;
}

private function bool IsAdminable()
{
	return AndAnd_BoolBool(EqualEqual_IntInt(int(GC.SwatGameRole), int(4)), OrOr_BoolBool(OrOr_BoolBool(EqualEqual_IntInt(int(GC.SwatGameState), int(3)), EqualEqual_IntInt(int(GC.SwatGameState), int(4))), EqualEqual_IntInt(int(GC.SwatGameState), int(5))));
	return;
}

private function SetupPopup()
{
	local bool bAdminable;

	OpenScores();
	bAdminable = IsAdminable();
	if(EqualEqual_IntInt(int(GC.SwatGameState), int(3)))
	{
		MyLoadingGraphic.Hide();
		MyLoadingBlackGraphic.Hide();
		MyLoadingTextLabel.Hide();
		LoadingImage.Hide();
		MyStartButton.SetCaption(ReadyString);
		MissionLoadingProgressBar.Hide();
		MissionLoadingStatusText.Hide();
	}
	else
	{
		if(AndAnd_BoolBool(EqualEqual_IntInt(int(GC.SwatGameState), int(4)), bPopup))
		{
			MyLoadingGraphic.Hide();
			MyLoadingBlackGraphic.Hide();
			MyLoadingTextLabel.Hide();
			LoadingImage.Hide();
			MyStartButton.Hide();
			MyStartButton.DeActivate();
			MyServerSettingsButton.Hide();
			MyServerSettingsButton.DeActivate();
			MyScoresButton.Hide();
			MyScoresButton.DeActivate();
			MyLoadoutButton.Hide();
			MyLoadoutButton.DeActivate();
			MyBackButton.Hide();
			MyBackButton.DeActivate();
			MyGameSettingsButton.Hide();
			MyGameSettingsButton.DeActivate();
			MyMPScoresPanel.MyChangeTeamButton.Hide();
			MyMPScoresPanel.MyChangeTeamButton.DeActivate();
			MissionLoadingProgressBar.Hide();
			MissionLoadingStatusText.Hide();
		}
		else
		{
			if(AndAnd_BoolBool(EqualEqual_IntInt(int(GC.SwatGameState), int(4)), Not_PreBool(bPopup)))
			{
				MyLoadingGraphic.Hide();
				MyLoadingBlackGraphic.Hide();
				MyLoadingTextLabel.Hide();
				LoadingImage.Hide();
				MyStartButton.SetCaption(ContinueString);
				MissionLoadingProgressBar.Hide();
				MissionLoadingStatusText.Hide();
			}
			else
			{
				if(EqualEqual_IntInt(int(GC.SwatGameState), int(5)))
				{
					MyLoadingGraphic.Hide();
					MyLoadingBlackGraphic.Hide();
					MyLoadingTextLabel.Hide();
					LoadingImage.Hide();
					MyStartButton.SetCaption(ReadyString);
					MissionLoadingProgressBar.Hide();
					MissionLoadingStatusText.Hide();
				}
				else
				{
					if(EqualEqual_IntInt(int(GC.SwatGameState), int(6)))
					{
						if(AndAnd_BoolBool(SwatGUIController(Controller).Repo.Level.IsPlayingCOOP, Greater_IntInt(DefaultImages.Length, 0)))
						{
							LoadingImage.Image = DefaultImages[Rand(DefaultImages.Length)];
						}
						else
						{
							LoadingImage.Hide();
						}
						MyStartButton.Hide();
						MyStartButton.DeActivate();
						MyServerSettingsButton.Hide();
						MyServerSettingsButton.DeActivate();
						MyScoresButton.Hide();
						MyScoresButton.DeActivate();
						MyLoadoutButton.Hide();
						MyLoadoutButton.DeActivate();
						MyBackButton.Hide();
						MyBackButton.DeActivate();
						MyGameSettingsButton.Hide();
						MyGameSettingsButton.DeActivate();
						MyMPScoresPanel.MyTitleLabel.Hide();
						MyMPScoresPanel.MyChangeTeamButton.Hide();
						MyMPScoresPanel.MyChangeTeamButton.DeActivate();
						MyMPScoresPanel.MyAbortGameButton.Hide();
						MyMPScoresPanel.MyAbortGameButton.DeActivate();
						MyMPScoresPanel.MyObjectivesPanel.Hide();
						MyMPScoresPanel.MyLeadershipPanel.Hide();
						MyMPScoresPanel.MyDebriefingLeadershipPanel.Hide();
						MyMPScoresPanel.MyMapPanel.Hide();
						MyMPScoresPanel.MyOfficerStatusPanel.Hide();
						MyChatPanel.Hide();
						MyServerInfoBox.Hide();
						MyBombsRemainingLabel.Hide();
						MyRoundsLabel.Hide();
						MyGameInfoLabel.Hide();
						MyServerNameLabel.Hide();
						MissionLoadingProgressBar.Show();
						MissionLoadingStatusText.Show();
					}
					else
					{
						assert(false);
					}
				}
			}
		}
	}
	return;
}

function InternalOnActivate()
{
	SetFocusInstead(MyServerInfoBox);
	DisplayGameInfo();
	MyMPLoadoutPanel.LoadMultiPlayerLoadout();
	SetTimer(1.0000000, true);
	return;
}

function InternalOnDeActivate()
{
	KillTimer();
	return;
}

function DisplayGameInfo()
{
	local SwatGameReplicationInfo SGRI;
	local int BombsRemainingCount;
	local string DisplayString;
	local int i;
	local ServerSettings Settings;

	SGRI = SwatGameReplicationInfo(PlayerOwner().GameReplicationInfo);
	Settings = ServerSettings(PlayerOwner().Level.CurrentServerSettings);
	if(OrOr_BoolBool(EqualEqual_ObjectObject(SGRI, none), EqualEqual_ObjectObject(Settings, none)))
	{
		return;
	}
	MyServerNameLabel.SetCaption(Settings.ServerName);
	if(SGRI.bWaitingForPlayers)
	{
		MyWaitingForPlayersLabel.SetCaption(WaitingForPlayersString);
	}
	else
	{
		MyWaitingForPlayersLabel.SetCaption("");
	}
	if(OrOr_BoolBool(NotEqual_IntInt(int(CachedGameMode), int(Settings.GameType)), NotEqual_StrStr(CachedTitle, PlayerOwner().Level.Title)))
	{
		CachedTitle = PlayerOwner().Level.Title;
		CachedGameMode = Settings.GameType;
		MyGameInfoLabel.SetCaption(FormatTextString(GameModeAndLevelString, GC.GetGameModeName(Settings.GameType), CachedTitle));
		MyServerInfoBox.SetContent(GC.GetGameDescription(Settings.GameType));
	}
	if(AndAnd_BoolBool(AndAnd_BoolBool(EqualEqual_IntInt(int(Settings.GameType), int(3)), NotEqual_ObjectObject(GC.CurrentMission, none)), NotEqual_StrStr(MyGameInfoLabel.GetCaption(), GC.CurrentMission.FriendlyName)))
	{
		MyGameInfoLabel.SetCaption(GC.CurrentMission.FriendlyName);
		DisplayString = "";
		i = 0;
		J0x219:

		if(Less_IntInt(i, GC.CurrentMission.BriefingText.Length))
		{
			DisplayString = Concat_StrStr(Concat_StrStr(DisplayString, GC.CurrentMission.BriefingText[i]), "|");
			AddAdd_Int(i);
			// [Loop Continue]
			goto J0x219;
		}
		MyServerInfoBox.SetContent(DisplayString);
		MyRoundsLabel.Hide();
	}
	if(EqualEqual_IntInt(int(Settings.GameType), int(2)))
	{
		BombsRemainingCount = Subtract_IntInt(SGRI.TotalNumberOfBombs, SGRI.DiffusedBombs);
		MyBombsRemainingLabel.SetCaption(FormatTextString(BombsRemaining, string(BombsRemainingCount), string(SGRI.TotalNumberOfBombs)));
		MyBombsRemainingLabel.Show();
	}
	else
	{
		MyBombsRemainingLabel.Hide();
	}
	MyRoundsLabel.SetCaption(FormatTextString(RoundsRemainingString, string(Add_IntInt(Settings.RoundNumber, 1)), string(Settings.NumRounds)));
	return;
}

event Timer()
{
	DisplayGameInfo();
	return;
}

function CommonOnClick(GUIComponent Sender)
{
	switch(Sender)
	{
		case MyStartButton:
			SwatGUIController(Controller).SetPlayerReady();
			MyStartButton.DisableComponent();
			ResumeGame();
			break;
		case MyBackButton:
			__OnDlgReturned__Delegate = InternalOnDlgReturned;
			OpenDlg(ConfirmAbortString, QBTN_YesNo, "Abort");
			break;
		case MyLoadoutButton:
			OpenLoadout();
			break;
		case MyScoresButton:
			OpenScores();
			break;
		case MyGameSettingsButton:
			OpenGameSettings();
			break;
		case MyServerSettingsButton:
			Controller.OpenMenu("SwatGui.SwatServerSetupMenu", "SwatServerSetupMenu", "InGame");
			break;
		default:
			break;
	}
	return;
}

private function InternalOnDlgReturned(int Selection, string Passback)
{
	switch(Passback)
	{
		case "Abort":
			if(EqualEqual_IntInt(Selection, QBTN_Yes))
			{
				AbortGame();
			}
			break;
		default:
			break;
	}
	return;
}

protected function AbortGame()
{
	SwatGUIController(Controller).PlayerDisconnect();
	return;
}

protected function ResumeGame()
{
	if(EqualEqual_IntInt(int(GC.SwatGameState), int(6)))
	{
		return;
	}
	if(NotEqual_IntInt(int(GC.SwatGameState), int(4)))
	{
		return;
	}
	Controller.CloseMenu();
	return;
}

private function OpenScores()
{
	local bool bPlayingCOOP;

	bPlayingCOOP = SwatGUIController(Controller).Repo.Level.IsPlayingCOOP;
	MyServerInfoBox.SetVisibility(OrOr_BoolBool(Not_PreBool(bPlayingCOOP), NotEqual_IntInt(int(GC.SwatGameState), int(5))));
	MyServerInfoBox.SetActive(OrOr_BoolBool(Not_PreBool(bPlayingCOOP), NotEqual_IntInt(int(GC.SwatGameState), int(5))));
	MyGameInfoLabel.SetVisibility(OrOr_BoolBool(Not_PreBool(bPlayingCOOP), NotEqual_IntInt(int(GC.SwatGameState), int(5))));
	MyMPScoresPanel.Show();
	MyMPScoresPanel.Activate();
	MyMPLoadoutPanel.Hide();
	MyMPLoadoutPanel.DeActivate();
	MyScoresButton.Focus();
	MyLoadoutButton.EnableComponent();
	return;
}

private function OpenLoadout()
{
	MyChatPanel.Show();
	MyChatPanel.Activate();
	MyServerInfoBox.Show();
	MyServerInfoBox.Activate();
	MyGameInfoLabel.Show();
	MyMPScoresPanel.Hide();
	MyMPScoresPanel.DeActivate();
	MyMPLoadoutPanel.Show();
	MyMPLoadoutPanel.Activate();
	MyScoresButton.EnableComponent();
	MyLoadoutButton.Focus();
	return;
}

protected function bool HandleKeyEventFirstCrack(out byte Key, out byte State, float Delta)
{
	if(EqualEqual_IntInt(int(State), int(1)))
	{
		if(Not_PreBool(MyChatPanel.MyChatEntry.bActiveInput))
		{
			if(KeyMatchesBinding(Key, "ScrollChatUp"))
			{
				SwatGUIController(Controller).ScrollChatUp();
				return true;
			}
			if(KeyMatchesBinding(Key, "ScrollChatDown"))
			{
				SwatGUIController(Controller).ScrollChatDown();
				return true;
			}
		}
		if(KeyMatchesBinding(Key, "ScrollChatPageUp"))
		{
			SwatGUIController(Controller).ScrollChatPageUp();
			return true;
		}
		if(KeyMatchesBinding(Key, "ScrollChatPageDown"))
		{
			SwatGUIController(Controller).ScrollChatPageDown();
			return true;
		}
		if(KeyMatchesBinding(Key, "ScrollChatToEnd"))
		{
			SwatGUIController(Controller).ScrollChatToEnd();
			return true;
		}
		if(KeyMatchesBinding(Key, "ScrollChatToHome"))
		{
			SwatGUIController(Controller).ScrollChatToHome();
			return true;
		}
	}
	return false;
	return;
}

protected function bool HandleKeyEvent(out byte Key, out byte State, float Delta)
{
	if(EqualEqual_IntInt(int(State), int(1)))
	{
		if(KeyMatchesBinding(Key, "OpenHudChat 1"))
		{
			SwatGUIController(Controller).OpenChat(true);
			return true;
		}
		if(KeyMatchesBinding(Key, "OpenHudChat 0"))
		{
			SwatGUIController(Controller).OpenChat(false);
			return true;
		}
	}
	return super.HandleKeyEvent(Key, State, Delta);
	return;
}

function OnProgress(string PercentComplete, string ExtraInfo)
{
	Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("  SwatMissionLoadingMenu ONPROGRESS Received: [", PercentComplete), "] ["), ExtraInfo), "]"));
	MissionLoadingProgressBar.Value = float(PercentComplete);
	if(EqualEqual_StrStr(ExtraInfo, "LoadSplash"))
	{
		MissionLoadingStatusText.SetCaption(LoadSplashString);
	}
	else
	{
		if(EqualEqual_StrStr(ExtraInfo, "WaitForConnection"))
		{
			MissionLoadingStatusText.SetCaption(WaitForConnectionString);
		}
		else
		{
			if(EqualEqual_StrStr(ExtraInfo, "LoadMap"))
			{
				MissionLoadingStatusText.SetCaption(LoadMapString);
			}
			else
			{
				if(EqualEqual_StrStr(ExtraInfo, "Download"))
				{
					MissionLoadingStatusText.SetCaption(DownloadString);
				}
			}
		}
	}
	if(NotEqual_ObjectObject(Controller, none))
	{
		Controller.PaintProgress();
	}
	return;
}

function BringServerInfoToFront()
{
	BringToFront(MyServerInfoBox);
	return;
}

function SendServerInfoToBack()
{
	BringToBack(MyServerInfoBox);
	return;
}

defaultproperties
{
	BombsRemaining="Bombs Remaining: %1/%2"
	RoundsRemainingString="Round: %1/%2"
	GameModeAndLevelString="Level: %2    Mode: %1"
	LoadSplashString="Loading..."
	WaitForConnectionString="Connecting..."
	LoadMapString="Loading..."
	DownloadString="Downloading..."
	ConfirmAbortString="Disconnect from the current game?"
	WaitingForPlayersString="Waiting for players to reconnect..."
	OnKeyEventFirstCrack=SwatMPPage.HandleKeyEventFirstCrack
	OnActivate=SwatMPPage.InternalOnActivate
	OnDeActivate=SwatMPPage.InternalOnDeActivate
}