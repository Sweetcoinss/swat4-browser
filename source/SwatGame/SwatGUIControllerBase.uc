class SwatGUIControllerBase extends GUIController
	abstract
	config(GuiBase)
	hidecategories(Menu,Object);

var(DEBUG) SwatRepo Repo;
var(DEBUG) SwatGUIConfig GuiConfig;
var(DEBUG) private Campaigns Campaigns;
var(DEBUG) Campaign Campaign;
var(DEBUG) private string ConnectingURL;
var(DEBUG) string CurrentFailureMessage1;
var(DEBUG) string CurrentFailureMessage2;
var(DEBUG) editconst export editinline HUDPageBase HUDPage;
var private float CumulativeDelta;

function InitializeController()
{
	Log(Concat_StrStr("[dkaplan] >>> InitializeController of (SwatGUIControllerBase) ", string(self)));
	Campaigns = Class'SwatGame.Campaigns'.static.Allocate(self, none).;
	Construct_Void();
	AssertWithDescription(NotEqual_ObjectObject(Campaigns, none), "Campaigns could not be loaded!");
	UseCampaign(Campaigns.CurCampaignName);
	Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[dkaplan] ... ViewportOwner=", string(ViewportOwner)), ", ViewportOwner.Actor="), string(ViewportOwner.Actor)), ", ViewportOwner.Actor.GetEntryLevel()="), string(ViewportOwner.Actor.GetEntryLevel())), ", ViewportOwner.Actor.GetEntryLevel().GetRepo()="), string(ViewportOwner.Actor.GetEntryLevel().GetRepo())));
	Repo = SwatRepo(ViewportOwner.Actor.GetEntryLevel().GetRepo());
	AssertWithDescription(NotEqual_ObjectObject(Repo, none), Concat_StrStr(Concat_StrStr("[dkaplan]: The repo could not be retrieved by ", string(self)), " in InitializeController()"));
	GuiConfig = Repo.GuiConfig;
	AssertWithDescription(NotEqual_ObjectObject(GuiConfig, none), Concat_StrStr(Concat_StrStr("[dkaplan]: The GuiConfig could not be retrieved by ", string(self)), " in InitializeController()"));
	super.InitializeController();
	if(Repo.bInitAsNetPlayer)
	{
		OnNetworkPlayerLoading();
	}
	else
	{
		if(AndAnd_BoolBool(EqualEqual_NameName(ViewportOwner.Actor.Level.Label, 'Entry'), NotEqual_IntInt(int(Repo.GuiConfig.SwatGameRole), int(5))))
		{
			LoadSplash();
		}
	}
	return;
}

event OnTick(float Delta)
{
	if(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_IntInt(int(GuiConfig.SwatGameState), int(3)), NotEqual_IntInt(int(GuiConfig.SwatGameState), int(4))), NotEqual_IntInt(int(GuiConfig.SwatGameState), int(5))))
	{
		return;
	}
	AddEqual_FloatFloat(CumulativeDelta, Delta);
	if(Greater_FloatFloat(CumulativeDelta, GuiConfig.MPPollingDelay))
	{
		CumulativeDelta = 0.0000000;
		PollGUI();
	}
	return;
}

function PollGUI()
{
	return;
}

function OnRoleChange(SwatGUIConfig.eSwatGameRole oldRole, SwatGUIConfig.eSwatGameRole newRole)
{
	return;
}

function OnStateChange(SwatGUIConfig.eSwatGameState oldState, SwatGUIConfig.eSwatGameState NewState)
{
	return;
}

final function SwatGameInfo GetSwatGameInfo()
{
	return SwatGameInfo(GetLevelInfo().Game);
	return;
}

final function LevelInfo GetLevelInfo()
{
	return ViewportOwner.Actor.Level;
	return;
}

function StartEndRoundSequence()
{
	HUDPage.StartEndRoundSequence();
	return;
}

function FinishEndRoundSequence()
{
	HUDPage.FinishEndRoundSequence();
	return;
}

function OnNetworkPlayerLoading()
{
	return;
}

function UseCampaign(string inCampaign)
{
	Campaign = GetCampaign(inCampaign);
	if(NotEqual_ObjectObject(Campaign, none))
	{
		Campaigns.CurCampaignName = inCampaign;
		Campaigns.SaveConfig();
	}
	return;
}

final function Campaigns GetCampaigns()
{
	return Campaigns;
	return;
}

final function Campaign GetCampaign(optional string inCampaign)
{
	if(NotEqual_StrStr(inCampaign, ""))
	{
		return Campaigns.super(SwatGUIControllerBase).GetCampaign(inCampaign);
	}
	return Campaign;
	return;
}

final function bool CampaignExists(string inCampaign)
{
	return Campaigns.super(SwatGUIControllerBase).CampaignExists(inCampaign);
	return;
}

final function Campaign AddCampaign(string inCampaign)
{
	return Campaigns.super(SwatGUIControllerBase).AddCampaign(inCampaign);
	return;
}

final function DeleteCampaign(string inCampaign)
{
	Campaigns.super(SwatGUIControllerBase).DeleteCampaign(inCampaign);
	return;
}

final function MissionResults GetMissionResults(name Mission)
{
	return Campaign.super(SwatGUIControllerBase).GetMissionResults(Mission);
	return;
}

function bool OnMessageRecieved(string msg, name Type)
{
	return;
}

final function AddChatMessage(string msg, optional bool bIsGlobal)
{
	if(bIsGlobal)
	{
		ViewportOwner.Actor.Say(msg);
	}
	else
	{
		ViewportOwner.Actor.TeamSay(msg);
	}
	return;
}

final function ChangeTeams()
{
	if(NotEqual_ObjectObject(SwatGamePlayerController(ViewportOwner.Actor), none))
	{
		SwatGamePlayerController(ViewportOwner.Actor).ServerChangePlayerTeam();
	}
	return;
}

final function SetPlayerReady()
{
	MPLog("SwatGUIControllerBase::SetPlayerReady().");
	if(NotEqual_ObjectObject(SwatGamePlayerController(ViewportOwner.Actor), none))
	{
		MPLog("...sent RPC to server.");
		SwatGamePlayerController(ViewportOwner.Actor).ServerSetPlayerReady();
	}
	return;
}

final function SetPlayerNotReady()
{
	MPLog("SwatGUIControllerBase::SetPlayerNotReady().");
	if(NotEqual_ObjectObject(SwatGamePlayerController(ViewportOwner.Actor), none))
	{
		MPLog("...sent RPC to server.");
		SwatGamePlayerController(ViewportOwner.Actor).ServerSetPlayerNotReady();
	}
	return;
}

final function FailedConnectionAccepted()
{
	Repo.FailedConnectionAccepted();
	ConsoleCommand("Cancel");
	LoadSplash();
	return;
}

final function PlayerDisconnect()
{
	ConsoleCommand("Disconnect");
	return;
}

final function OnDisconnected()
{
	LoadSplash();
	return;
}

function Quit()
{
	ConsoleCommand("quit");
	return;
}

function GameStart()
{
	GuiConfig.SaveLastMissionPlayed();
	LoadLevel(GuiConfig.CurrentMission.MapName);
	return;
}

function GameAbort()
{
	GetSwatGameInfo().GameAbort();
	return;
}

function GameOver()
{
	LoadSplash();
	return;
}

function LoadLevel(string MapName)
{
	Repo.LoadLevel(MapName);
	return;
}

function SetMPLoadOut(DynamicLoadOutSpec LoadOut)
{
	Log(" in SwatGUIControllerBase::SetMPLoadOut()");
	if(NotEqual_ObjectObject(SwatGamePlayerController(ViewportOwner.Actor), none))
	{
		MPLog("...SGPC is valid");
		SwatGamePlayerController(ViewportOwner.Actor).SetMPLoadOut(LoadOut);
	}
	return;
}

function SetMPLoadOutPocketWeapon(HandheldEquipment.Pocket Pocket, Class<Actor> WeaponItem, Class<Actor> AmmoItem)
{
	Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(" in SetMPLoadOutPocketWeapon(): Pocket=", string(Pocket)), ", WeaponItem="), string(WeaponItem)), ", AmmoItem="), string(AmmoItem)));
	if(NotEqual_ObjectObject(SwatGamePlayerController(ViewportOwner.Actor), none))
	{
		MPLog("...SGPC is valid");
		SwatGamePlayerController(ViewportOwner.Actor).ServerSetMPLoadOutPocketWeapon(Pocket, WeaponItem, AmmoItem);
	}
	return;
}

function SetMPLoadOutPocketItem(HandheldEquipment.Pocket Pocket, Class<Actor> Item)
{
	Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(" in SetMPLoadOutPocketItem(): Pocket=", string(Pocket)), ", Item="), string(Item)));
	assert(NotEqual_IntInt(int(Pocket), int(0)));
	assert(NotEqual_IntInt(int(Pocket), int(1)));
	assert(NotEqual_IntInt(int(Pocket), int(2)));
	assert(NotEqual_IntInt(int(Pocket), int(3)));
	if(NotEqual_ObjectObject(SwatGamePlayerController(ViewportOwner.Actor), none))
	{
		MPLog("...SGPC is valid");
		SwatGamePlayerController(ViewportOwner.Actor).ServerSetMPLoadOutPocketItem(Pocket, Item);
	}
	return;
}

protected function LoadSplash()
{
	ConsoleCommand(At_StrStr("Start", Repo.SplashSceneMapName));
	return;
}

function HUDPageBase GetHUDPage()
{
	if(EqualEqual_ObjectObject(HUDPage, none))
	{
		HUDPage = HUDPageBase(CreateComponent("SwatGui.HUDPage"));
		if(Not_PreBool(HUDPage.bInited))
		{
			HUDPage.InitComponent(none);
		}
	}
	return HUDPage;
	return;
}

event SetProgress(string Message1, string Message2)
{
	local int i;

	Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self), "::SetProgress("), Message1), ", "), Message2), ")"));
	if(OrOr_BoolBool(OrOr_BoolBool(OrOr_BoolBool(EqualEqual_StrStr(Message1, "LoadSplash"), EqualEqual_StrStr(Message1, "WaitForConnection")), EqualEqual_StrStr(Message1, "LoadMap")), EqualEqual_StrStr(Message1, "Download")))
	{
		i = 0;
		J0x97:

		if(Less_IntInt(i, MenuStack.Length))
		{
			MenuStack[i].OnProgress(Message2, Message1);
			AddAdd_Int(i);
			// [Loop Continue]
			goto J0x97;
		}
	}
	else
	{
		if(OrOr_BoolBool(OrOr_BoolBool(OrOr_BoolBool(OrOr_BoolBool(OrOr_BoolBool(OrOr_BoolBool(OrOr_BoolBool(OrOr_BoolBool(OrOr_BoolBool(OrOr_BoolBool(EqualEqual_StrStr(Message1, "ConnectionFailed"), EqualEqual_StrStr(Message1, "Networking Failed")), EqualEqual_StrStr(Message1, "DemoLoadFailed")), EqualEqual_StrStr(Message1, "UrlFailed")), EqualEqual_StrStr(Message1, "Rejected By Server")), EqualEqual_StrStr(Message1, "ConfigMD5ChecksumFailed")), EqualEqual_StrStr(Message1, "ConfigMD5ChecksumCountFailed")), EqualEqual_StrStr(Message1, "PackageMD5ChecksumFailed")), EqualEqual_StrStr(Message1, "GenericFailure")), AndAnd_BoolBool(EqualEqual_StrStr(Message1, "ConnectingText"), EqualEqual_StrStr(Message2, ConnectingURL))), AndAnd_BoolBool(EqualEqual_StrStr(Message1, ""), EqualEqual_StrStr(Message2, ""))))
		{
			ConnectingURL = "";
			CurrentFailureMessage1 = Message1;
			CurrentFailureMessage2 = Message2;
			Repo.FailedServerConnection();
		}
		else
		{
			if(EqualEqual_StrStr(Message1, "ConnectingText"))
			{
				ConnectingURL = Message2;
				return;
			}
		}
	}
	ConnectingURL = "";
	return;
}

function StartMissionObjectiveTimer(Objective Objective)
{
	return;
}

function StopMissionObjectiveTimer()
{
	return;
}

function PreLevelChangeCleanup()
{
	GetHUDPage().PreLevelChangeCleanup();
	return;
}

function DebugServerList(int Num)
{
	return;
}

function ShowGamePopup(bool bSticky)
{
	return;
}

function bool CanChat()
{
	return;
}

function OpenChat(bool bGlobal)
{
	return;
}

function ScrollChatPageUp()
{
	return;
}

function ScrollChatPageDown()
{
	return;
}

function ScrollChatUp()
{
	return;
}

function ScrollChatDown()
{
	return;
}

function ScrollChatToHome()
{
	return;
}

function ScrollChatToEnd()
{
	return;
}
