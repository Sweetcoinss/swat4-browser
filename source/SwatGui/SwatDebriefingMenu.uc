class SwatDebriefingMenu extends SwatGUIPage
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

var(SwatGui) private export editinline config GUIButton MyQuitButton;
var(SwatGui) private export editinline config GUIButton MyContinueButton;
var(SwatGui) private export editinline config GUIButton MyRestartButton;
var(SwatGui) private export editinline config SwatObjectivesPanel MyObjectivesPanel;
var(SwatGui) private export editinline config SwatLeadershipPanel MyLeadershipPanel;
var(SwatGui) private export editinline config GUILabel MyMissionOutcome;
var(SwatGui) private export editinline config GUIButton MyDebriefingButton;
var(SwatGui) private export editinline config GUIButton MyLoadoutButton;
var(SwatGui) private export editinline config SwatSPLoadoutPanel MyLoadoutPanel;
var private config localized string MissionCompletedString;
var private config localized string MissionFailedString;
var private config localized string MissionCompletedDifficultyReqFailedString;
var private config localized string ContinueMissionCompletedString;
var private config localized string ContinueMissionFailedString;
var private config localized string MainMenuString;
var private config localized string ContinueString;
var bool bOpeningSubMenu;

function InitComponent(GUIComponent MyOwner)
{
	super.InitComponent(MyOwner);
	MyContinueButton.__OnClick__Delegate = InternalOnClick;
	MyRestartButton.__OnClick__Delegate = InternalOnClick;
	MyDebriefingButton.__OnClick__Delegate = InternalOnClick;
	MyLoadoutButton.__OnClick__Delegate = InternalOnClick;
	return;
}

function InternalOnActivate()
{
	MyQuitButton.__OnClick__Delegate = InternalOnClick;
	if(Not_PreBool(GC.CurrentMission.IsMissionFailed()))
	{
		if(GC.CurrentMission.HasMetDifficultyRequirement())
		{
			MyMissionOutcome.SetCaption(MissionCompletedString);
		}
		else
		{
			MyMissionOutcome.SetCaption(MissionCompletedDifficultyReqFailedString);
		}
		if(OrOr_BoolBool(NotEqual_ObjectObject(GC.CurrentMission.CustomScenario, none), Not_PreBool(GC.CurrentMission.HasMetDifficultyRequirement())))
		{
			MyContinueButton.SetCaption(ContinueMissionFailedString);
		}
		else
		{
			MyContinueButton.SetCaption(ContinueMissionCompletedString);
		}
	}
	else
	{
		MyMissionOutcome.SetCaption(MissionFailedString);
		MyContinueButton.SetCaption(ContinueMissionFailedString);
	}
	if(EqualEqual_IntInt(int(GC.SwatGameRole), int(3)))
	{
		MyContinueButton.SetCaption(MainMenuString);
	}
	if(bOpeningSubMenu)
	{
		OpenLoadout();
	}
	else
	{
		OpenDebriefing();
	}
	bOpeningSubMenu = false;
	return;
}

function OpenPopup(string ClassName, string ObjName)
{
	bOpeningSubMenu = true;
	super.OpenPopup(ClassName, ObjName);
	return;
}

function OpenDebriefing()
{
	MyObjectivesPanel.Show();
	MyObjectivesPanel.Activate();
	MyLeadershipPanel.Show();
	MyLeadershipPanel.Activate();
	MyLoadoutPanel.Hide();
	MyLoadoutPanel.DeActivate();
	MyMissionOutcome.Show();
	MyDebriefingButton.DisableComponent();
	MyLoadoutButton.EnableComponent();
	if(PlayerOwner().Level.IsTraining)
	{
		MyLoadoutButton.DisableComponent();
	}
	return;
}

function OpenLoadout()
{
	MyObjectivesPanel.Hide();
	MyObjectivesPanel.DeActivate();
	MyLeadershipPanel.Hide();
	MyLeadershipPanel.DeActivate();
	MyLoadoutPanel.Show();
	MyLoadoutPanel.Activate();
	MyMissionOutcome.Hide();
	MyDebriefingButton.EnableComponent();
	MyLoadoutButton.DisableComponent();
	return;
}

function InternalOnClick(GUIComponent Sender)
{
	switch(Sender)
	{
		case MyContinueButton:
			SwatGUIController(Controller).GameOver();
			break;
		case MyRestartButton:
			GameStart();
			break;
		case MyDebriefingButton:
			OpenDebriefing();
			break;
		case MyLoadoutButton:
			OpenLoadout();
			break;
		case MyQuitButton:
			Quit();
			break;
		default:
			break;
	}
	return;
}

function PerformClose()
{
	return;
}

protected function bool ShouldSetSplashCameraPosition()
{
	return Not_PreBool(SwatGamePlayerController(PlayerOwner()).SPBombExploded);
	return;
}

defaultproperties
{
	MissionCompletedString="[c=ffffff]Mission [c=00ff00]Completed[c=ffffff]!"
	MissionFailedString="[c=ffffff]Mission [c=ff0000]Failed[c=ffffff]!"
	MissionCompletedDifficultyReqFailedString="[c=ffffff]Mission [c=ff0000]Completed[c=ffffff]!"
	ContinueMissionCompletedString="NEXT MISSION"
	ContinueMissionFailedString="SELECT MISSION"
	MainMenuString="MAIN MENU"
	OnActivate=SwatDebriefingMenu.InternalOnActivate
}