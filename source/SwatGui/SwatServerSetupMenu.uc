class SwatServerSetupMenu extends SwatGUIPage
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

const MAX_MAPS = 40;

var(SwatGui) private export editinline config GUIButton MyMainMenuButton;
var(SwatGui) private export editinline config GUIButton StartButton;
var(SwatGui) private export editinline config GUIButton MyQuitButton;
var(SwatGui) private export editinline config GUINumericEdit MyMaxPlayersBox;
var(SwatGui) private export editinline config GUINumericEdit MyRoundsBox;
var(SwatGui) private export editinline config GUINumericEdit MyDeathLimitBox;
var(SwatGui) private export editinline config GUINumericEdit MyPreGameTimeLimitBox;
var(SwatGui) private export editinline config GUINumericEdit MyTimeLimitBox;
var(SwatGui) private export editinline config GUINumericEdit MyPostGameTimeLimitBox;
var(SwatGui) private export editinline config GUIEditBox MyNameBox;
var(SwatGui) private export editinline config GUIEditBox MyServerNameBox;
var(SwatGui) private export editinline config GUIEditBox MyPasswordBox;
var(SwatGui) private export editinline config GUIEditBox MyAdminPasswordBox;
var(SwatGui) private export editinline config GUISlider MyFriendlyFireSlider;
var(SwatGui) private export editinline config GUICheckBoxButton MyEnemyFireButton;
var(SwatGui) private export editinline config GUICheckBoxButton MyPasswordedButton;
var(SwatGui) private export editinline config GUICheckBoxButton MyShowEnemyButton;
var(SwatGui) private export editinline config GUICheckBoxButton MyShowTeammatesButton;
var(SwatGui) private export editinline config GUICheckBoxButton MyNoRespawnButton;
var(SwatGui) private export editinline config GUICheckBoxButton MyQuickResetBox;
var(SwatGui) private export editinline config GUICheckBoxButton MyDesirePrimaryCOOPEntryPoint;
var(SwatGui) private export editinline config GUICheckBoxButton MyDedicatedServerCheck;
var(SwatGui) private export editinline config GUILabel MyDedicatedServerLabel;
var(SwatGui) private export editinline config GUIComboBox MyGameTypeBox;
var(SwatGui) private export editinline config GUIComboBox MyUseGameSpyBox;
var(SwatGui) private export editinline config GUIListBox DisplayOnlyMaps;
var(SwatGui) private export editinline config GUIListBox SelectedMaps;
var(SwatGui) private export editinline config GUIListBox AvailableMaps;
var(SwatGui) private export editinline config GUIButton MyRemoveButton;
var(SwatGui) private export editinline config GUIButton MyAddButton;
var(SwatGui) private export editinline config GUIButton MyUpButton;
var(SwatGui) private export editinline config GUIButton MyDownButton;
var(SwatGui) private export editinline config GUIImage MyLevelScreenshot;
var(SwatGui) private export editinline config GUILabel MyIdealPlayerCount;
var(SwatGui) private export editinline config GUILabel MyLevelAuthor;
var(SwatGui) private export editinline config GUILabel MyLevelTitle;
var(DEBUG) private int SelectedIndex;
var private config localized string SelectedIndexColorString;
var private config int COOPMaxPlayers;
var(SwatGui) private Repo.EMPMode CurGameType;
var private config localized string BackButtonHelpString;
var private config localized string CancelButtonHelpString;
var private config localized string QuitButtonHelpString;
var private config localized string AcceptButtonHelpString;
var private config localized string StartButtonHelpString;
var private config localized string ReStartButtonHelpString;
var private config localized string BackButtonString;
var private config localized string CancelButtonString;
var private config localized string QuitButtonString;
var private config localized string AcceptButtonString;
var private config localized string StartButtonString;
var private config localized string ReStartButtonString;
var private config localized string CannotUndercutCurrentPlayersFormatString;
var private config localized string LoadingMaplistString;
var private config localized string HostCDKeyInvalidString;
var private config localized string StartDedicatedServerQueryString;
var private config localized string CannotStartDedicatedServerString;
var private config localized string StartServerQueryString;
var private config localized string ReStartServerQueryString;
var private config localized string LANString;
var private config localized string GAMESPYString;
var(DEBUG) SwatGameSpyManager SGSM;
var(DEBUG) private bool bUseGameSpy;
var(DEBUG) private bool bInGame;
var(DEBUG) private string PreviousMap;
var(DEBUG) private Material NoScreenshotAvailableImage;
var(DEBUG) private config localized string IdealPlayerCountString;
var(DEBUG) private config localized string LevelAuthorString;
var(DEBUG) private config localized string LevelTitleString;
var(DEBUG) private bool bUpdatingMapLists;
var(DEBUG) private export editinline GUIList FullMapList;
var(DEBUG) bool bIsAdmin;

function InitComponent(GUIComponent MyOwner)
{
	local int i;

	super.InitComponent(MyOwner);
	FullMapList = GUIList(AddComponent("GUI.GUIList", Concat_StrStr(string(self.Name), "_FullMapList"), true));
	LoadFullMapList();
	MyUseGameSpyBox.AddItem(LANString);
	MyUseGameSpyBox.AddItem(GAMESPYString);
	i = 0;
	J0x7B:

	if(Less_IntInt(i, int(4)))
	{
		MyGameTypeBox.AddItem(GC.GetGameModeName(byte(i)));
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x7B;
	}
	MyGameTypeBox.setIndex(0);
	SelectedMaps.List.__OnDblClick__Delegate = OnSelectedMapsDblClicked;
	SelectedMaps.__OnChange__Delegate = OnSelectedMapsChanged;
	AvailableMaps.__OnChange__Delegate = OnAvailableMapsChanged;
	DisplayOnlyMaps.__OnChange__Delegate = OnAvailableMapsChanged;
	MyRemoveButton.__OnClick__Delegate = OnRemoveButtonClicked;
	MyAddButton.__OnClick__Delegate = OnAddButtonClicked;
	MyUpButton.__OnClick__Delegate = OnUpButtonClicked;
	MyDownButton.__OnClick__Delegate = OnDownButtonClicked;
	MyGameTypeBox.__OnChange__Delegate = InternalOnChange;
	MyUseGameSpyBox.__OnChange__Delegate = InternalOnChange;
	MyPasswordedButton.__OnChange__Delegate = InternalOnChange;
	MyNameBox.__OnChange__Delegate = OnNameSelectionChanged;
	MyNameBox.MaxWidth = GC.MPNameLength;
	MyNameBox.AllowedCharSet = GC.MPNameAllowableCharSet;
	MyServerNameBox.__OnChange__Delegate = OnNameSelectionChanged;
	MyPasswordBox.__OnChange__Delegate = OnNameSelectionChanged;
	return;
}

event HandleParameters(string Param1, string Param2, optional int param3)
{
	super(GUIPage).HandleParameters(Param1, Param2, param3);
	bInGame = EqualEqual_StrStr(Param1, "InGame");
	StartButton.Hint = StartButtonHelpString;
	MyQuitButton.Hint = QuitButtonHelpString;
	MyMainMenuButton.Hint = BackButtonHelpString;
	StartButton.SetCaption(StartButtonString);
	MyQuitButton.SetCaption(QuitButtonString);
	MyMainMenuButton.SetCaption(BackButtonString);
	bIsAdmin = OrOr_BoolBool(EqualEqual_IntInt(int(GC.SwatGameRole), int(4)), SwatPlayerReplicationInfo(PlayerOwner().PlayerReplicationInfo).IsAdmin());
	LoadServerSettings(Not_PreBool(bIsAdmin));
	MyDedicatedServerCheck.SetChecked(false);
	MyDedicatedServerCheck.SetVisibility(Not_PreBool(bInGame));
	MyDedicatedServerCheck.SetActive(Not_PreBool(bInGame));
	MyDedicatedServerLabel.SetVisibility(Not_PreBool(bInGame));
	MyAdminPasswordBox.SetVisibility(EqualEqual_IntInt(int(GC.SwatGameRole), int(4)));
	MyAdminPasswordBox.SetActive(EqualEqual_IntInt(int(GC.SwatGameRole), int(4)));
	if(bInGame)
	{
		StartButton.Hint = ReStartButtonHelpString;
		MyQuitButton.Hint = AcceptButtonHelpString;
		MyMainMenuButton.Hint = CancelButtonHelpString;
		StartButton.SetCaption(ReStartButtonString);
		MyQuitButton.SetCaption(AcceptButtonString);
		MyMainMenuButton.SetCaption(CancelButtonString);
	}
	return;
}

function InternalOnActivate()
{
	MyQuitButton.__OnClick__Delegate = InternalOnClick;
	MyMainMenuButton.__OnClick__Delegate = InternalOnClick;
	StartButton.__OnClick__Delegate = InternalOnClick;
	SGSM = SwatGameSpyManager(PlayerOwner().Level.GetGameSpyManager());
	if(EqualEqual_ObjectObject(SGSM, none))
	{
		Log("Error:  no GameSpy manager found");
		return;
	}
	return;
}

private final function LaunchDedicatedServer()
{
	FlushConfig();
	Controller.LaunchDedicatedServer();
	return;
}

function InternalOnDlgReturned(int Selection, string Passback)
{
	switch(Passback)
	{
		case "StartDedicatedServer":
			if(EqualEqual_IntInt(Selection, QBTN_Ok))
			{
				SaveServerSettings();
				LaunchDedicatedServer();
			}
			break;
		case "StartServer":
			if(EqualEqual_IntInt(Selection, QBTN_Ok))
			{
				GC.FirstTimeThrough = true;
				if(bUseGameSpy)
				{
					SGSM.SetShouldCheckClientCDKeys(true);
				}
				else
				{
					SGSM.SetShouldCheckClientCDKeys(false);
				}
				SaveServerSettings();
				LoadSelectedMap();
			}
			break;
		case "RestartServer":
			if(EqualEqual_IntInt(Selection, QBTN_Ok))
			{
				if(bUseGameSpy)
				{
					SGSM.SetShouldCheckClientCDKeys(true);
				}
				else
				{
					SGSM.SetShouldCheckClientCDKeys(false);
				}
				SaveServerSettings();
				SwatPlayerController(PlayerOwner()).ServerQuickRestart();
			}
			break;
		default:
			break;
	}
	return;
}

function InternalOnChange(GUIComponent Sender)
{
	switch(Sender)
	{
		case MyPasswordedButton:
			MyPasswordBox.SetEnabled(MyPasswordedButton.bChecked);
			RefreshEnabled();
			break;
		case MyUseGameSpyBox:
			bUseGameSpy = EqualEqual_StrStr(MyUseGameSpyBox.List.Get(), GAMESPYString);
			break;
		case MyGameTypeBox:
			OnGameModeChanged(byte(MyGameTypeBox.GetIndex()));
			break;
		default:
			break;
	}
	return;
}

function InternalOnClick(GUIComponent Sender)
{
	local int MaxPlayers, CurrentPlayers;

	MaxPlayers = MyMaxPlayersBox.Value;
	CurrentPlayers = SwatGameReplicationInfo(PlayerOwner().GameReplicationInfo).NumPlayers();
	switch(Sender)
	{
		case MyQuitButton:
			if(AndAnd_BoolBool(bInGame, Less_IntInt(MaxPlayers, CurrentPlayers)))
			{
				OpenDlg(FormatTextString(CannotUndercutCurrentPlayersFormatString, string(MaxPlayers), string(CurrentPlayers)), QBTN_Ok, "IncreaseMaxPlayers");
				// [Explicit Continue]
				goto J0x2B1;
			}
			SaveServerSettings();
			if(bInGame)
			{
				Controller.CloseMenu();
			}
			else
			{
				Quit();
			}
			break;
		case StartButton:
			if(AndAnd_BoolBool(bInGame, Less_IntInt(MaxPlayers, CurrentPlayers)))
			{
				OpenDlg(FormatTextString(CannotUndercutCurrentPlayersFormatString, string(MaxPlayers), string(CurrentPlayers)), QBTN_Ok, "IncreaseMaxPlayers");
				// [Explicit Continue]
				goto J0x2B1;
			}
			__OnDlgReturned__Delegate = InternalOnDlgReturned;
			if(bInGame)
			{
				OpenDlg(ReStartServerQueryString, QBTN_OkCancel, "RestartServer");
			}
			else
			{
				if(OrOr_BoolBool(Not_PreBool(bUseGameSpy), SGSM.IsHostCDKeyValid()))
				{
					if(MyDedicatedServerCheck.bChecked)
					{
						Log(Concat_StrStr("mcj CanLaunchDedicatedServer=", string(Controller.CanLaunchDedicatedServer())));
						if(Controller.CanLaunchDedicatedServer())
						{
							OpenDlg(StartDedicatedServerQueryString, QBTN_OkCancel, "StartDedicatedServer");
						}
						else
						{
							OpenDlg(CannotStartDedicatedServerString, QBTN_Ok, "CannotStartDedicatedServer");
						}
					}
					else
					{
						OpenDlg(StartServerQueryString, QBTN_OkCancel, "StartServer");
					}
				}
				else
				{
					OpenDlg(HostCDKeyInvalidString, QBTN_Cancel, "HostCDKeyInvalid");
				}
			}
			break;
		case MyMainMenuButton:
			if(AndAnd_BoolBool(Not_PreBool(bInGame), Not_PreBool(SelectedMaps.IsEmpty())))
			{
				SaveServerSettings();
			}
			Controller.CloseMenu();
			break;
		default:
			break;
	}
	J0x2B1:

	return;
}

private function OnNameSelectionChanged(GUIComponent Sender)
{
	RefreshEnabled();
	return;
}

private function LoadSelectedMap()
{
	local string URL;

	URL = Concat_StrStr(Concat_StrStr(Concat_StrStr(SelectedMaps.List.GetItemAtIndex(SelectedIndex), "?Name="), MyNameBox.GetText()), "?listen");
	if(MyPasswordedButton.bChecked)
	{
		URL = Concat_StrStr(Concat_StrStr(URL, "?GamePassword="), MyPasswordBox.GetText());
	}
	SwatGUIController(Controller).LoadLevel(URL);
	return;
}

function SetSubComponentsEnabled(bool bSetEnabled)
{
	StartButton.SetEnabled(bSetEnabled);
	MyQuitButton.SetEnabled(bSetEnabled);
	MyRemoveButton.SetEnabled(bSetEnabled);
	MyAddButton.SetEnabled(bSetEnabled);
	MyUpButton.SetEnabled(bSetEnabled);
	MyDownButton.SetEnabled(bSetEnabled);
	AvailableMaps.SetEnabled(bSetEnabled);
	SelectedMaps.SetEnabled(bSetEnabled);
	DisplayOnlyMaps.SetEnabled(bSetEnabled);
	MyMaxPlayersBox.SetEnabled(bSetEnabled);
	MyRoundsBox.SetEnabled(bSetEnabled);
	MyDeathLimitBox.SetEnabled(bSetEnabled);
	MyPreGameTimeLimitBox.SetEnabled(bSetEnabled);
	MyPostGameTimeLimitBox.SetEnabled(bSetEnabled);
	MyTimeLimitBox.SetEnabled(bSetEnabled);
	MyServerNameBox.SetEnabled(AndAnd_BoolBool(bSetEnabled, Not_PreBool(bInGame)));
	MyPasswordBox.SetEnabled(AndAnd_BoolBool(bSetEnabled, Not_PreBool(bInGame)));
	MyShowTeammatesButton.SetEnabled(bSetEnabled);
	MyEnemyFireButton.SetEnabled(bSetEnabled);
	MyFriendlyFireSlider.SetEnabled(bSetEnabled);
	MyShowEnemyButton.SetEnabled(bSetEnabled);
	MyPasswordedButton.SetEnabled(AndAnd_BoolBool(bSetEnabled, Not_PreBool(bInGame)));
	MyNoRespawnButton.SetEnabled(bSetEnabled);
	MyQuickResetBox.SetEnabled(bSetEnabled);
	MyUseGameSpyBox.SetEnabled(AndAnd_BoolBool(bSetEnabled, Not_PreBool(bInGame)));
	MyGameTypeBox.SetEnabled(bSetEnabled);
	MyNameBox.SetEnabled(AndAnd_BoolBool(bSetEnabled, Not_PreBool(bInGame)));
	MyDesirePrimaryCOOPEntryPoint.SetEnabled(bSetEnabled);
	MyRemoveButton.SetVisibility(bSetEnabled);
	MyAddButton.SetVisibility(bSetEnabled);
	MyUpButton.SetVisibility(bSetEnabled);
	MyDownButton.SetVisibility(bSetEnabled);
	AvailableMaps.SetVisibility(bSetEnabled);
	SelectedMaps.SetVisibility(bSetEnabled);
	DisplayOnlyMaps.SetVisibility(Not_PreBool(bSetEnabled));
	return;
}

private function RefreshEnabled()
{
	local bool bEnableStart;

	bEnableStart = AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(bIsAdmin, Not_PreBool(SelectedMaps.IsEmpty())), NotEqual_StrStr(MyNameBox.GetText(), "")), NotEqual_StrStr(MyServerNameBox.GetText(), "")), OrOr_BoolBool(NotEqual_StrStr(MyPasswordBox.GetText(), ""), Not_PreBool(MyPasswordedButton.bChecked)));
	StartButton.SetEnabled(bEnableStart);
	if(bInGame)
	{
		MyQuitButton.SetEnabled(bEnableStart);
	}
	MyPasswordBox.SetEnabled(MyPasswordedButton.bChecked);
	MyRemoveButton.SetEnabled(GreaterEqual_IntInt(SelectedMaps.GetIndex(), 0));
	MyUpButton.SetEnabled(Greater_IntInt(SelectedMaps.GetIndex(), 0));
	MyDownButton.SetEnabled(AndAnd_BoolBool(GreaterEqual_IntInt(SelectedMaps.GetIndex(), 0), Less_IntInt(SelectedMaps.GetIndex(), Subtract_IntInt(SelectedMaps.Num(), 1))));
	MyAddButton.SetEnabled(AndAnd_BoolBool(GreaterEqual_IntInt(AvailableMaps.GetIndex(), 0), LessEqual_IntInt(SelectedMaps.Num(), 40)));
	return;
}

function ResetDefaultsForGameMode(Repo.EMPMode NewMode)
{
	if(EqualEqual_IntInt(int(NewMode), int(3)))
	{
		MyQuickResetBox.SetChecked(false);
		MyMaxPlayersBox.SetMaxValue(Clamp(COOPMaxPlayers, 0, 16));
		MyMaxPlayersBox.SetValue(5);
		MyQuickResetBox.DisableComponent();
		MyTimeLimitBox.DisableComponent();
		MyShowEnemyButton.DisableComponent();
		MyEnemyFireButton.DisableComponent();
		MyFriendlyFireSlider.DisableComponent();
		MyFriendlyFireSlider.SetValue(1.0000000);
		MyPreGameTimeLimitBox.SetValue(480);
		MyPostGameTimeLimitBox.SetValue(120);
		MyRoundsBox.SetValue(1);
	}
	else
	{
		MyDesirePrimaryCOOPEntryPoint.DisableComponent();
		MyQuickResetBox.SetChecked(true);
		MyMaxPlayersBox.SetMaxValue(16);
		MyMaxPlayersBox.SetValue(16);
		MyPreGameTimeLimitBox.SetValue(90);
		MyPostGameTimeLimitBox.SetValue(15);
		MyRoundsBox.SetValue(5);
	}
	if(EqualEqual_IntInt(int(NewMode), int(0)))
	{
		MyTimeLimitBox.SetValue(900, true);
		MyDeathLimitBox.SetValue(50);
	}
	else
	{
		MyDeathLimitBox.DisableComponent();
		MyNoRespawnButton.DisableComponent();
	}
	if(EqualEqual_IntInt(int(NewMode), int(2)))
	{
		MyTimeLimitBox.SetValue(600, true);
	}
	if(EqualEqual_IntInt(int(NewMode), int(1)))
	{
		MyEnemyFireButton.DisableComponent();
		MyTimeLimitBox.SetValue(720, true);
		MyFriendlyFireSlider.DisableComponent();
		MyFriendlyFireSlider.SetValue(1.0000000);
	}
	MyNoRespawnButton.SetChecked(false);
	MyEnemyFireButton.SetChecked(false);
	return;
}

function LoadServerSettings(optional bool ReadOnly)
{
	local ServerSettings Settings;

	if(ReadOnly)
	{
		Settings = ServerSettings(PlayerOwner().Level.CurrentServerSettings);
	}
	else
	{
		Settings = ServerSettings(PlayerOwner().Level.PendingServerSettings);
	}
	MyGameTypeBox.setIndex(int(Settings.GameType));
	LoadServerMapList(SelectedMaps, Settings);
	SetSelectedMapsIndex(Settings.MapIndex);
	PreviousMap = SelectedMaps.List.GetItemAtIndex(SelectedIndex);
	if(ReadOnly)
	{
		LoadServerMapList(DisplayOnlyMaps, Settings);
		DisplayOnlyMaps.setIndex(Settings.MapIndex);
		UpdateSelectedIndexColoring(DisplayOnlyMaps);
		DisplayLevelSummary(LevelSummary(DisplayOnlyMaps.List.GetObject()));
	}
	MyMaxPlayersBox.SetValue(Settings.MaxPlayers, true);
	MyRoundsBox.SetValue(Settings.NumRounds, true);
	MyDeathLimitBox.SetValue(Settings.DeathLimit, true);
	MyPreGameTimeLimitBox.SetValue(Settings.MPMissionReadyTime, true);
	MyPostGameTimeLimitBox.SetValue(Settings.PostGameTimeLimit, true);
	MyTimeLimitBox.SetValue(Settings.RoundTimeLimit, true);
	MyShowTeammatesButton.SetChecked(Settings.bShowTeammateNames);
	MyEnemyFireButton.SetChecked(EqualEqual_FloatFloat(Settings.EnemyFireAmount, 0.0000000));
	MyFriendlyFireSlider.SetValue(Settings.FriendlyFireAmount);
	MyShowEnemyButton.SetChecked(Settings.bShowEnemyNames);
	MyPasswordedButton.bForceUpdate = true;
	MyNoRespawnButton.SetChecked(Settings.bNoRespawn);
	MyQuickResetBox.SetChecked(Settings.bQuickRoundReset);
	MyDesirePrimaryCOOPEntryPoint.SetChecked(EqualEqual_IntInt(int(Settings.DesiredMPEntryPoint), int(0)));
	MyServerNameBox.SetText(Settings.ServerName);
	MyPasswordBox.SetText(Settings.Password);
	MyPasswordedButton.SetChecked(Settings.bPassworded);
	bUseGameSpy = Not_PreBool(Settings.bLAN);
	if(bUseGameSpy)
	{
		MyUseGameSpyBox.find(GAMESPYString);
	}
	else
	{
		MyUseGameSpyBox.find(LANString);
	}
	MyNameBox.SetText(GC.MPName);
	MyAdminPasswordBox.SetText(GC.AdminPassword);
	return;
}

function SaveServerSettings()
{
	local int i;
	local float EnemyFireAmount;
	local SwatStartPointBase.EEntryType DesiredMPEntryPoint;
	local ServerSettings Settings;

	Settings = ServerSettings(PlayerOwner().Level.PendingServerSettings);
	SwatPlayerController(PlayerOwner()).ServerClearMaps(Settings);
	i = 0;
	J0x44:

	if(Less_IntInt(i, SelectedMaps.Num()))
	{
		SwatPlayerController(PlayerOwner()).ServerAddMap(Settings, SelectedMaps.List.GetItemAtIndex(i));
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x44;
	}
	if(OrOr_BoolBool(OrOr_BoolBool(NotEqual_IntInt(int(Settings.GameType), int(CurGameType)), NotEqual_BoolBool(Settings.bLAN, Not_PreBool(bUseGameSpy))), NotEqual_StrStr(PreviousMap, SelectedMaps.List.GetItemAtIndex(SelectedIndex))))
	{
		SwatPlayerController(PlayerOwner()).ServerSetDirty(Settings);
	}
	SwatPlayerController(PlayerOwner()).ServerSetAdminSettings(Settings, MyServerNameBox.GetText(), MyPasswordBox.GetText(), MyPasswordedButton.bChecked, Not_PreBool(bUseGameSpy));
	if(MyEnemyFireButton.bChecked)
	{
		EnemyFireAmount = 0.0000000;
	}
	else
	{
		EnemyFireAmount = 1.0000000;
	}
	if(MyDesirePrimaryCOOPEntryPoint.bChecked)
	{
		DesiredMPEntryPoint = 0;
	}
	else
	{
		DesiredMPEntryPoint = 1;
	}
	SwatPlayerController(PlayerOwner()).ServerSetSettings(Settings, CurGameType, SelectedIndex, MyRoundsBox.Value, MyMaxPlayersBox.Value, MyDeathLimitBox.Value, MyPostGameTimeLimitBox.Value, MyTimeLimitBox.Value, MyPreGameTimeLimitBox.Value, MyShowTeammatesButton.bChecked, MyShowEnemyButton.bChecked, MyNoRespawnButton.bChecked, MyQuickResetBox.bChecked, MyFriendlyFireSlider.GetValue(), EnemyFireAmount, DesiredMPEntryPoint);
	SwatPlayerController(PlayerOwner()).SetName(MyNameBox.GetText());
	GC.AdminPassword = MyAdminPasswordBox.GetText();
	GC.SaveConfig();
	return;
}

function OnGameModeChanged(Repo.EMPMode NewMode)
{
	Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self), "::OnGameModeChanged( "), string(GetEnum(Enum'Engine.Repo.EMPMode', int(NewMode)))), " )"));
	CurGameType = NewMode;
	LoadAvailableMaps(NewMode);
	LoadMapList(NewMode);
	SetSubComponentsEnabled(bIsAdmin);
	ResetDefaultsForGameMode(NewMode);
	RefreshEnabled();
	DisplayLevelSummary(LevelSummary(AvailableMaps.List.GetObject()));
	return;
}

function LoadAvailableMaps(Repo.EMPMode NewMode)
{
	local int i, j;
	local LevelSummary Summary;

	bUpdatingMapLists = true;
	AvailableMaps.Clear();
	i = 0;
	J0x1E:

	if(Less_IntInt(i, FullMapList.ItemCount))
	{
		Summary = LevelSummary(FullMapList.GetObjectAtIndex(i));
		j = 0;
		J0x5C:

		if(Less_IntInt(j, Summary.SupportedModes.Length))
		{
			if(EqualEqual_IntInt(int(Summary.SupportedModes[j]), int(NewMode)))
			{
				AvailableMaps.List.AddElement(FullMapList.GetAtIndex(i));
				// [Explicit Break]
				goto J0xD0;
			}
			AddAdd_Int(j);
			// [Loop Continue]
			goto J0x5C;
		}
		J0xD0:

		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x1E;
	}
	AvailableMaps.List.Sort();
	bUpdatingMapLists = false;
	return;
}

function LoadMapList(Repo.EMPMode NewMode)
{
	local int i, j;

	bUpdatingMapLists = true;
	SelectedMaps.Clear();
	i = 0;
	J0x1E:

	if(Less_IntInt(i, GC.MapList[int(NewMode)].NumMaps))
	{
		AvailableMaps.List.find(GC.MapList[int(NewMode)].Maps[i]);
		j = AvailableMaps.GetIndex();
		if(Less_IntInt(j, 0))
		{
			// [Explicit Continue]
			goto J0xDD;
		}
		SelectedMaps.List.AddElement(AvailableMaps.List.GetAtIndex(j));
		J0xDD:

		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x1E;
	}
	SetSelectedMapsIndex(0);
	bUpdatingMapLists = false;
	return;
}

function LoadServerMapList(GUIListBox MapListBox, ServerSettings Settings)
{
	local int i, j;

	bUpdatingMapLists = true;
	MapListBox.Clear();
	i = 0;
	J0x1E:

	if(Less_IntInt(i, Settings.NumMaps))
	{
		AvailableMaps.List.find(Settings.Maps[i]);
		j = AvailableMaps.GetIndex();
		if(Less_IntInt(j, 0))
		{
			// [Explicit Continue]
			goto J0xBB;
		}
		MapListBox.List.AddElement(AvailableMaps.List.GetAtIndex(j));
		J0xBB:

		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x1E;
	}
	bUpdatingMapLists = false;
	return;
}

function LoadFullMapList()
{
	local LevelSummary Summary;
	local string FileName;

	Controller.OpenWaitDialog(LoadingMaplistString);
	FullMapList.Clear();
	foreach FileMatchingPattern("*.s4m", FileName)
	{
		if(NotEqual_IntInt(InStr(FileName, "autosave"), -1))
		{
			continue;
		}
		if(ComplementEqual_StrStr(Right(FileName, 4), ".s4m"))
		{
			FileName = Left(FileName, Subtract_IntInt(Len(FileName), 4));
		}
		Summary = Controller.LoadLevelSummary(Concat_StrStr(FileName, ".LevelSummary"));
		if(EqualEqual_ObjectObject(Summary, none))
		{
			Log(Concat_StrStr(Concat_StrStr("WARNING: Could not load a level summary for map '", FileName), ".s4m'"));
			continue;
		}
		FullMapList.Add(FileName, Summary, Summary.Title);
	}
	Controller.CloseWaitDialog();
	return;
}

function OnAddButtonClicked(GUIComponent Sender)
{
	if(Less_IntInt(AvailableMaps.GetIndex(), 0))
	{
		return;
	}
	SelectedMaps.List.AddElement(AvailableMaps.List.GetElement());
	return;
}

function OnRemoveButtonClicked(GUIComponent Sender)
{
	local int Index;

	Index = SelectedMaps.GetIndex();
	if(Less_IntInt(Index, 0))
	{
		return;
	}
	SelectedMaps.List.Remove(Index);
	if(Greater_IntInt(SelectedIndex, Index))
	{
		SubtractSubtract_Int(SelectedIndex);
	}
	else
	{
		if(EqualEqual_IntInt(SelectedIndex, Index))
		{
			SetSelectedMapsIndex(0);
		}
	}
	return;
}

function OnUpButtonClicked(GUIComponent Sender)
{
	local int Index;

	Index = SelectedMaps.GetIndex();
	if(LessEqual_IntInt(Index, 0))
	{
		return;
	}
	SelectedMaps.List.SwapIndices(Index, Subtract_IntInt(Index, 1));
	SelectedMaps.setIndex(Subtract_IntInt(Index, 1));
	if(EqualEqual_IntInt(SelectedIndex, Index))
	{
		SubtractSubtract_Int(SelectedIndex);
	}
	else
	{
		if(EqualEqual_IntInt(SelectedIndex, Subtract_IntInt(Index, 1)))
		{
			AddAdd_Int(SelectedIndex);
		}
	}
	return;
}

function OnDownButtonClicked(GUIComponent Sender)
{
	local int Index;

	Index = SelectedMaps.GetIndex();
	if(OrOr_BoolBool(Less_IntInt(Index, 0), GreaterEqual_IntInt(Index, Subtract_IntInt(SelectedMaps.Num(), 1))))
	{
		return;
	}
	SelectedMaps.List.SwapIndices(Index, Add_IntInt(Index, 1));
	SelectedMaps.setIndex(Add_IntInt(Index, 1));
	if(EqualEqual_IntInt(SelectedIndex, Index))
	{
		AddAdd_Int(SelectedIndex);
	}
	else
	{
		if(EqualEqual_IntInt(SelectedIndex, Add_IntInt(Index, 1)))
		{
			SubtractSubtract_Int(SelectedIndex);
		}
	}
	return;
}

function OnAvailableMapsChanged(GUIComponent Sender)
{
	if(bUpdatingMapLists)
	{
		return;
	}
	DisplayLevelSummary(LevelSummary(AvailableMaps.List.GetObject()));
	RefreshEnabled();
	return;
}

function OnSelectedMapsChanged(GUIComponent Sender)
{
	if(bUpdatingMapLists)
	{
		return;
	}
	MapListOnChange(CurGameType);
	if(LessEqual_IntInt(SelectedMaps.Num(), 1))
	{
		SetSelectedMapsIndex(0);
	}
	DisplayLevelSummary(LevelSummary(SelectedMaps.List.GetObject()));
	RefreshEnabled();
	return;
}

function MapListOnChange(Repo.EMPMode NewMode)
{
	local int i;

	GC.MapList[int(NewMode)].ClearMaps();
	i = 0;
	J0x27:

	if(Less_IntInt(i, SelectedMaps.Num()))
	{
		GC.MapList[int(NewMode)].AddMap(SelectedMaps.List.GetItemAtIndex(i));
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x27;
	}
	GC.MapList[int(NewMode)].SaveConfig();
	return;
}

function OnSelectedMapsDblClicked(GUIComponent Sender)
{
	SetSelectedMapsIndex(SelectedMaps.GetIndex());
	return;
}

function SetSelectedMapsIndex(int newSelectedIndex)
{
	SelectedIndex = newSelectedIndex;
	UpdateSelectedIndexColoring(SelectedMaps);
	return;
}

function UpdateSelectedIndexColoring(GUIListBox MapListBox)
{
	local int i;
	local string CurrentDisplayString;

	i = 0;
	J0x07:

	if(Less_IntInt(i, MapListBox.Num()))
	{
		CurrentDisplayString = MapListBox.List.GetExtraAtIndex(i);
		if(EqualEqual_StrStr(Left(CurrentDisplayString, 10), SelectedIndexColorString))
		{
			MapListBox.List.SetExtraAtIndex(i, Mid(CurrentDisplayString, 10));
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	if(LessEqual_IntInt(MapListBox.Num(), SelectedIndex))
	{
		return;
	}
	CurrentDisplayString = MapListBox.List.GetExtraAtIndex(SelectedIndex);
	if(EqualEqual_IntInt(InStr(CurrentDisplayString, SelectedIndexColorString), -1))
	{
		MapListBox.List.SetExtraAtIndex(SelectedIndex, Concat_StrStr(SelectedIndexColorString, CurrentDisplayString));
	}
	return;
}

function DisplayLevelSummary(LevelSummary Summary)
{
	if(EqualEqual_ObjectObject(Summary, none))
	{
		return;
	}
	if(EqualEqual_ObjectObject(Summary.Screenshot, none))
	{
		MyLevelScreenshot.Image = NoScreenshotAvailableImage;
	}
	else
	{
		MyLevelScreenshot.Image = Summary.Screenshot;
	}
	MyIdealPlayerCount.SetCaption(FormatTextString(IdealPlayerCountString, string(Summary.IdealPlayerCountMin), string(Summary.IdealPlayerCountMax)));
	MyLevelAuthor.SetCaption(FormatTextString(LevelAuthorString, Summary.Author));
	MyLevelTitle.SetCaption(FormatTextString(LevelTitleString, Summary.Title));
	return;
}

defaultproperties
{
	SelectedIndexColorString="[c=00ff00]"
	COOPMaxPlayers=5
	BackButtonHelpString="Return to the Main Menu."
	CancelButtonHelpString="Discard changes and return to the previous menu."
	QuitButtonHelpString="Exit the game and return to Windows."
	AcceptButtonHelpString="Apply the current settings and return to the previous menu."
	StartButtonHelpString="Start the server with the current settings."
	ReStartButtonHelpString="Restart the server with the current settings."
	BackButtonString="MAIN"
	CancelButtonString="CANCEL"
	QuitButtonString="QUIT"
	AcceptButtonString="APPLY"
	StartButtonString="START SERVER"
	ReStartButtonString="RESTART SERVER"
	CannotUndercutCurrentPlayersFormatString="Cannot proceed.  The maximum number of players (%1) cannot be less than the current number of players (%2).  Please increase the Max Players value and try again."
	LoadingMaplistString="Searching for available maps..."
	HostCDKeyInvalidString="Invalid CD Key!"
	StartDedicatedServerQueryString="Quit the game and launch a dedicated server with the current settings?"
	CannotStartDedicatedServerString="Cannot start dedicated server. A SWAT4 dedicated server is already running on this machine."
	StartServerQueryString="Start the server?"
	ReStartServerQueryString="Restart the server with the current settings?"
	LANString="LAN"
	GAMESPYString="Internet"
	IdealPlayerCountString="Recommended Players: %1 - %2"
	LevelAuthorString="Author: %1"
	LevelTitleString="Map: %1"
	OnActivate=SwatServerSetupMenu.InternalOnActivate
}