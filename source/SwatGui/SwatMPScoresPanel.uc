class SwatMPScoresPanel extends SwatGUIPanel
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

var(SwatGui) export editinline config SwatObjectivesPanel MyObjectivesPanel;
var(SwatGui) export editinline config SwatLeadershipPanel MyLeadershipPanel;
var(SwatGui) export editinline config SwatLeadershipPanel MyDebriefingLeadershipPanel;
var(SwatGui) export editinline config SwatMapPanel MyMapPanel;
var(SwatGui) export editinline config SwatCOOPOfficerStatusPanel MyOfficerStatusPanel;
var(SwatGui) export editinline config GUIButton MyChangeTeamButton;
var(SwatGui) export editinline config GUILabel MyTitleLabel;
var(SwatGui) editinline config array<export editinline GUIMultiColumnListBox> MyTeamBoxes;
var(SwatGui) editinline config array<export editinline GUILabel> MyTeamHeaders;
var(SwatGui) private export editinline config GUIImage MyBorderImageSWATLeft;
var(SwatGui) private export editinline config GUIImage MyBorderImageSWATRight;
var(SwatGui) private export editinline config GUIImage MyBorderImageSuspectLeft;
var(SwatGui) private export editinline config GUIImage MyBorderImageSuspectRight;
var(SwatGui) export editinline config GUIButton MyAbortGameButton;
var(SwatGui) private export editinline GUIImage ReadyIcon;
var(SwatGui) private config Color VIPColor;
var(SwatGui) private config Color WaitingForRespawnColor;
var(SwatGui) private config localized string VIPString;
var(SwatGui) private config localized string TeamScoreFormatString;
var(SwatGui) private config localized string StartGameString;
var(SwatGui) private config localized string AbortGameString;
var(SwatGui) private config localized string NextGameString;
var(SwatGui) private config localized string AdminLoginString;
var(SwatGui) private config localized string AdminPasswordQueryString;
var private bool bSelectThisPlayer;
var private int SelectPlayerCount;

function InitComponent(GUIComponent MyOwner)
{
	super.InitComponent(MyOwner);
	MyChangeTeamButton.__OnClick__Delegate = InternalOnClick;
	MyAbortGameButton.__OnClick__Delegate = InternalOnClick;
	ReadyIcon = GUIImage(Controller.CreateComponent("GUI.GUIImage", "Canvas_ReadyIcon"));
	return;
}

function InternalOnActivate()
{
	local int i;
	local bool bPlayingCOOP;

	bPlayingCOOP = SwatGUIController(Controller).Repo.Level.IsPlayingCOOP;
	bSelectThisPlayer = true;
	SetTimer(GC.MPPollingDelay, true);
	MyObjectivesPanel.SetVisibility(bPlayingCOOP);
	MyObjectivesPanel.SetActive(bPlayingCOOP);
	MyLeadershipPanel.SetVisibility(AndAnd_BoolBool(bPlayingCOOP, NotEqual_IntInt(int(GC.SwatGameState), int(5))));
	MyLeadershipPanel.SetActive(AndAnd_BoolBool(bPlayingCOOP, NotEqual_IntInt(int(GC.SwatGameState), int(5))));
	MyDebriefingLeadershipPanel.SetVisibility(AndAnd_BoolBool(bPlayingCOOP, EqualEqual_IntInt(int(GC.SwatGameState), int(5))));
	MyDebriefingLeadershipPanel.SetActive(AndAnd_BoolBool(bPlayingCOOP, EqualEqual_IntInt(int(GC.SwatGameState), int(5))));
	MyMapPanel.SetVisibility(AndAnd_BoolBool(bPlayingCOOP, NotEqual_IntInt(int(GC.SwatGameState), int(5))));
	MyMapPanel.SetActive(AndAnd_BoolBool(bPlayingCOOP, NotEqual_IntInt(int(GC.SwatGameState), int(5))));
	MyOfficerStatusPanel.SetVisibility(bPlayingCOOP);
	MyOfficerStatusPanel.SetActive(bPlayingCOOP);
	if(NotEqual_ObjectObject(MyTitleLabel, none))
	{
		MyTitleLabel.SetVisibility(Not_PreBool(bPlayingCOOP));
	}
	MyChangeTeamButton.SetVisibility(Not_PreBool(bPlayingCOOP));
	MyChangeTeamButton.SetActive(Not_PreBool(bPlayingCOOP));
	UpdateChangeTeamsButton();
	UpdateAdminButton();
	MyAbortGameButton.EnableComponent();
	i = 0;
	J0x230:

	if(Less_IntInt(i, 2))
	{
		MyTeamBoxes[i].SetVisibility(Not_PreBool(bPlayingCOOP));
		MyTeamHeaders[i].SetVisibility(Not_PreBool(bPlayingCOOP));
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x230;
	}
	MyBorderImageSWATLeft.SetVisibility(Not_PreBool(bPlayingCOOP));
	MyBorderImageSWATRight.SetVisibility(Not_PreBool(bPlayingCOOP));
	MyBorderImageSuspectLeft.SetVisibility(Not_PreBool(bPlayingCOOP));
	MyBorderImageSuspectRight.SetVisibility(Not_PreBool(bPlayingCOOP));
	return;
}

function InternalOnDeActivate()
{
	KillTimer();
	return;
}

event Timer()
{
	UpdateChangeTeamsButton();
	UpdateAdminButton();
	if(Not_PreBool(PlayerOwner().Level.IsPlayingCOOP))
	{
		if(Greater_IntInt(AddAdd_Int(SelectPlayerCount), 10))
		{
			bSelectThisPlayer = true;
		}
		DisplayScores();
	}
	return;
}

private function UpdateChangeTeamsButton()
{
	local bool Enabled;

	Enabled = false;
	if(NotEqual_IntInt(int(GC.SwatGameState), int(4)))
	{
		Enabled = true;
	}
	else
	{
		if(SwatPlayerReplicationInfo(PlayerOwner().PlayerReplicationInfo).bIsTheVIP)
		{
			Enabled = false;
		}
		else
		{
			assert(NotEqual_ObjectObject(SwatGamePlayerController(PlayerOwner()), none));
			if(EqualEqual_ObjectObject(SwatGamePlayerController(PlayerOwner()).SwatPlayer, none))
			{
				Enabled = true;
			}
			else
			{
				if(OrOr_BoolBool(SwatGamePlayerController(PlayerOwner()).SwatPlayer.IsNonlethaled(), SwatGamePlayerController(PlayerOwner()).SwatPlayer.IsBeingArrestedNow()))
				{
					Enabled = false;
				}
				else
				{
					Enabled = true;
				}
			}
		}
	}
	if(OrOr_BoolBool(Not_PreBool(Enabled), NotEqual_IntInt(int(MyChangeTeamButton.MenuState), int(3))))
	{
		MyChangeTeamButton.SetEnabled(Enabled);
	}
	return;
}

private function UpdateAdminButton()
{
	if(Not_PreBool(SwatPlayerReplicationInfo(PlayerOwner().PlayerReplicationInfo).IsAdmin()))
	{
		MyAbortGameButton.SetCaption(AdminLoginString);
	}
	else
	{
		if(EqualEqual_IntInt(int(GC.SwatGameState), int(3)))
		{
			MyAbortGameButton.SetCaption(StartGameString);
		}
		else
		{
			if(EqualEqual_IntInt(int(GC.SwatGameState), int(4)))
			{
				MyAbortGameButton.SetCaption(AbortGameString);
			}
			else
			{
				if(EqualEqual_IntInt(int(GC.SwatGameState), int(5)))
				{
					MyAbortGameButton.SetCaption(NextGameString);
				}
			}
		}
	}
	return;
}

private function int ObjScore(NetScoreInfo A)
{
	return Add_IntInt(Add_IntInt(Add_IntInt(A.GetVIPPlayerEscaped(), A.GetArrestedVIP()), A.GetBombsDiffused()), A.GetRDCrybaby());
	return;
}

private function bool GreaterScoreThan(NetScoreInfo A, NetScoreInfo B)
{
	return OrOr_BoolBool(Greater_IntInt(A.GetScore(), B.GetScore()), AndAnd_BoolBool(EqualEqual_IntInt(A.GetScore(), B.GetScore()), OrOr_BoolBool(Greater_IntInt(ObjScore(A), ObjScore(B)), AndAnd_BoolBool(EqualEqual_IntInt(ObjScore(A), ObjScore(B)), OrOr_BoolBool(Greater_IntInt(A.GetArrests(), B.GetArrests()), AndAnd_BoolBool(EqualEqual_IntInt(A.GetArrests(), B.GetArrests()), OrOr_BoolBool(Less_IntInt(A.GetTimesDied(), B.GetTimesDied()), AndAnd_BoolBool(EqualEqual_IntInt(A.GetTimesDied(), B.GetTimesDied()), OrOr_BoolBool(Greater_IntInt(A.GetEnemyKills(), B.GetEnemyKills()), AndAnd_BoolBool(EqualEqual_IntInt(A.GetEnemyKills(), B.GetEnemyKills()), Less_IntInt(A.GetTimesArrested(), B.GetTimesArrested())))))))))));
	return;
}

function DisplayScores()
{
	local SwatGameReplicationInfo SGRI;
	local SwatPlayerReplicationInfo PlayerInfo, otherPlayerInfo;
	local int i, j, Row;
	local array<int> lastTop, lastSelected;
	local string PlayerName;

	SGRI = SwatGameReplicationInfo(PlayerOwner().GameReplicationInfo);
	if(EqualEqual_ObjectObject(SGRI, none))
	{
		return;
	}
	i = 0;
	J0x2E:

	if(Less_IntInt(i, 2))
	{
		MyTeamHeaders[i].SetCaption(FormatTextString(TeamScoreFormatString, SGRI.Teams[i].TeamName, string(NetTeam(SGRI.Teams[i]).NetScoreInfo.GetScore()), string(NetTeam(SGRI.Teams[i]).NetScoreInfo.GetRoundsWon())));
		lastTop[i] = MyTeamBoxes[i].MyActiveList.Top;
		lastSelected[i] = MyTeamBoxes[i].GetIndex();
		MyTeamBoxes[i].Clear();
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x2E;
	}
	i = 0;
	J0x143:

	if(Less_IntInt(i, 16))
	{
		PlayerInfo = SGRI.PRIStaticArray[i];
		if(NotEqual_ObjectObject(PlayerInfo, none))
		{
			PlayerInfo.NetScoreInfo.Ranking = 1;
			j = 0;
			J0x194:

			if(Less_IntInt(j, i))
			{
				otherPlayerInfo = SGRI.PRIStaticArray[j];
				if(NotEqual_ObjectObject(otherPlayerInfo, none))
				{
					if(GreaterScoreThan(PlayerInfo.NetScoreInfo, otherPlayerInfo.NetScoreInfo))
					{
						AddAdd_Int(otherPlayerInfo.NetScoreInfo.Ranking);
						// [Explicit Continue]
						goto J0x222;
					}
					AddAdd_Int(PlayerInfo.NetScoreInfo.Ranking);
				}
				J0x222:

				AddAdd_Int(j);
				// [Loop Continue]
				goto J0x194;
			}
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x143;
	}
	i = 0;
	J0x23D:

	if(Less_IntInt(i, 16))
	{
		PlayerInfo = SGRI.PRIStaticArray[i];
		if(NotEqual_ObjectObject(PlayerInfo, none))
		{
			PlayerName = PlayerInfo.PlayerName;
			if(PlayerInfo.bIsTheVIP)
			{
				PlayerName = Concat_StrStr(Concat_StrStr(MakeColorCode(VIPColor), PlayerName), VIPString);
			}
			else
			{
				if(PlayerInfo.bIsDead)
				{
					PlayerName = Concat_StrStr(MakeColorCode(WaitingForRespawnColor), PlayerName);
				}
			}
			if(SwatPlayerController(PlayerOwner()).ShouldDisplayPRIIds)
			{
				PlayerName = Concat_StrStr(Concat_StrStr(Concat_StrStr("[b][", string(i)), "][\\b]"), PlayerName);
			}
			MyTeamBoxes[NetTeam(PlayerInfo.Team).GetTeamNumber()].AddNewRowElement("Teamnames",, PlayerName, PlayerInfo.SwatPlayerID);
			MyTeamBoxes[NetTeam(PlayerInfo.Team).GetTeamNumber()].AddNewRowElement("Ping",,, Min(999, PlayerInfo.Ping));
			MyTeamBoxes[NetTeam(PlayerInfo.Team).GetTeamNumber()].AddNewRowElement("Rank",,, PlayerInfo.NetScoreInfo.Ranking);
			MyTeamBoxes[NetTeam(PlayerInfo.Team).GetTeamNumber()].AddNewRowElement("Score",,, PlayerInfo.NetScoreInfo.GetScore());
			MyTeamBoxes[NetTeam(PlayerInfo.Team).GetTeamNumber()].AddNewRowElement("Kills",,, PlayerInfo.NetScoreInfo.GetEnemyKills());
			MyTeamBoxes[NetTeam(PlayerInfo.Team).GetTeamNumber()].AddNewRowElement("Deaths",,, PlayerInfo.NetScoreInfo.GetTimesDied());
			MyTeamBoxes[NetTeam(PlayerInfo.Team).GetTeamNumber()].AddNewRowElement("Arrested",,, PlayerInfo.NetScoreInfo.GetTimesArrested());
			MyTeamBoxes[NetTeam(PlayerInfo.Team).GetTeamNumber()].AddNewRowElement("Obj",,, ObjScore(PlayerInfo.NetScoreInfo));
			MyTeamBoxes[NetTeam(PlayerInfo.Team).GetTeamNumber()].AddNewRowElement("Arrests",,, PlayerInfo.NetScoreInfo.GetArrests());
			if(PlayerInfo.GetPlayerIsReady())
			{
				MyTeamBoxes[NetTeam(PlayerInfo.Team).GetTeamNumber()].AddNewRowElement("Ready", ReadyIcon,,, true);
			}
			Row = MyTeamBoxes[NetTeam(PlayerInfo.Team).GetTeamNumber()].PopulateRow();
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x23D;
	}
	i = 0;
	J0x665:

	if(Less_IntInt(i, 2))
	{
		MyTeamBoxes[i].Sort("Rank");
		if(bSelectThisPlayer)
		{
			if(EqualEqual_IntInt(MyTeamBoxes[i].GetColumn("Teamnames").FindExtraIntData(SwatPlayerReplicationInfo(PlayerOwner().PlayerReplicationInfo).SwatPlayerID,, true), -1))
			{
				MyTeamBoxes[i].MyActiveList.setIndex(-1,, true);
			}
			// [Explicit Continue]
			goto J0x73B;
		}
		MyTeamBoxes[i].MyActiveList.setIndex(lastSelected[i],, true);
		J0x73B:

		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x665;
	}
	if(bSelectThisPlayer)
	{
		bSelectThisPlayer = false;
		SelectPlayerCount = 0;
	}
	return;
}

function InternalOnClick(GUIComponent Sender)
{
	switch(Sender)
	{
		case MyChangeTeamButton:
			SwatGUIController(Controller).ChangeTeams();
			bSelectThisPlayer = true;
			break;
		case MyAbortGameButton:
			MyAbortGameButton.DisableComponent();
			if(Not_PreBool(SwatPlayerReplicationInfo(PlayerOwner().PlayerReplicationInfo).IsAdmin()))
			{
				Controller.TopPage().__OnPopupReturned__Delegate = InternalOnPasswordPopupReturned;
				Controller.OpenMenu("SwatGui.SwatPasswordPopup", "SwatPasswordPopup", AdminPasswordQueryString);
			}
			else
			{
				if(EqualEqual_IntInt(int(GC.SwatGameState), int(4)))
				{
					SwatPlayerController(PlayerOwner()).AbortGame();
					Controller.CloseMenu();
				}
				else
				{
					SwatPlayerController(PlayerOwner()).StartGame();
				}
			}
			break;
		default:
			break;
	}
	return;
}

function InternalOnPasswordPopupReturned(GUIListElem returnObj, optional string Passback)
{
	Log("...InternalOnPasswordPopupReturned().");
	SwatPlayerController(PlayerOwner()).SAD(returnObj.Item);
	MyAbortGameButton.EnableComponent();
	return;
}

defaultproperties
{
	VIPColor=(R=0,G=255,B=0,A=255)
	WaitingForRespawnColor=(R=255,G=0,B=0,A=255)
	VIPString=" (VIP)"
	TeamScoreFormatString="%1: %2   Rounds won: %3"
	StartGameString="START GAME"
	AbortGameString="END GAME"
	NextGameString="NEXT GAME"
	AdminLoginString="ADMIN LOGIN"
	AdminPasswordQueryString="Please enter the admin password to login:"
	OnActivate=SwatMPScoresPanel.InternalOnActivate
	OnDeActivate=SwatMPScoresPanel.InternalOnDeActivate
}