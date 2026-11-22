class SwatMainMenu extends SwatGUIPage
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

var(SwatGui) private export editinline config GUIButton MyInstantActionButton;
var(SwatGui) private export editinline config GUIButton MyTrainingButton;
var(SwatGui) private export editinline config GUIButton MyCampaignButton;
var(SwatGui) private export editinline config GUIButton MyPlayCustomButton;
var(SwatGui) private export editinline config GUIButton MyCustomMissionButton;
var(SwatGui) private export editinline config GUIButton MyHostButton;
var(SwatGui) private export editinline config GUIButton MyJoinButton;
var(SwatGui) private export editinline config GUIButton MyGameSettingsButton;
var(SwatGui) private export editinline config GUIButton MyCreditsButton;
var(SwatGui) private export editinline config GUIButton MyQuitButton;
var private config localized string TrainingFriendlyString;
var private config localized string PromptToGotoTrainingFirstString;
var private config localized string ConfirmNoTrainingString;

function InitComponent(GUIComponent MyOwner)
{
	local int i;

	super.InitComponent(MyOwner);
	MyInstantActionButton.__OnClick__Delegate = InternalOnClick;
	MyTrainingButton.__OnClick__Delegate = InternalOnClick;
	MyCampaignButton.__OnClick__Delegate = InternalOnClick;
	MyPlayCustomButton.__OnClick__Delegate = InternalOnClick;
	MyCustomMissionButton.__OnClick__Delegate = InternalOnClick;
	MyHostButton.__OnClick__Delegate = InternalOnClick;
	MyJoinButton.__OnClick__Delegate = InternalOnClick;
	MyGameSettingsButton.__OnClick__Delegate = InternalOnClick;
	MyCreditsButton.__OnClick__Delegate = InternalOnClick;
	i = 0;
	J0xC6:

	if(Less_IntInt(i, Controls.Length))
	{
		Controls[i].ShowPositionDelay = -1.0000000;
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0xC6;
	}
	return;
}

function InternalOnActivate()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, Controls.Length))
	{
		Controls[i].ShowPositionDelay = -1.0000000;
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	MyQuitButton.__OnClick__Delegate = InternalOnClick;
	Controller.bDontDisplayHelpText = Not_PreBool(GC.bShowHelp);
	if(EqualEqual_IntInt(int(GC.SwatGameState), int(0)))
	{
		SwatGUIController(Controller).Repo.RoleChange(0);
	}
	return;
}

function InternalOnDlgReturned(int Selection, optional string Passback)
{
	switch(Passback)
	{
		case "FirstTrainingPrompt":
			if(EqualEqual_IntInt(Selection, QBTN_Yes))
			{
				OpenDlg(ConfirmNoTrainingString, QBTN_YesNo, "LastTrainingPrompt");
			}
			break;
		case "LastTrainingPrompt":
			if(EqualEqual_IntInt(Selection, QBTN_Yes))
			{
				GC.bEverRanTraining = true;
				GC.SaveConfig();
				SwatGUIController(Controller).Repo.RoleChange(1);
				Controller.OpenMenu("SwatGui.SwatCampaignMenu", "SwatCampaignMenu");
			}
			break;
		default:
			break;
	}
	return;
}

function InternalOnClick(GUIComponent Sender)
{
	switch(Sender)
	{
		case MyInstantActionButton:
			if(Not_PreBool(GC.bEverRanTraining))
			{
				GC.bEverRanTraining = true;
				GC.SaveConfig();
				GC.SetCurrentMission('SP-Training', TrainingFriendlyString);
			}
			else
			{
				GC.LoadLastMissionPlayed();
			}
			SwatGUIController(Controller).Repo.RoleChange(3);
			GameStart();
			break;
		case MyTrainingButton:
			GC.bEverRanTraining = true;
			GC.SaveConfig();
			SwatGUIController(Controller).Repo.RoleChange(3);
			GC.SetCurrentMission('SP-Training', TrainingFriendlyString);
			GameStart();
			break;
		case MyCampaignButton:
			if(Not_PreBool(GC.bEverRanTraining))
			{
				__OnDlgReturned__Delegate = InternalOnDlgReturned;
				OpenDlg(PromptToGotoTrainingFirstString, QBTN_YesNo, "FirstTrainingPrompt");
			}
			else
			{
				SwatGUIController(Controller).Repo.RoleChange(1);
				Controller.OpenMenu("SwatGui.SwatCampaignMenu", "SwatCampaignMenu");
			}
			break;
		case MyPlayCustomButton:
			SwatGUIController(Controller).Repo.RoleChange(2);
			Controller.OpenMenu("SwatGui.SwatCustomMenu", "SwatCustomMenu");
			break;
		case MyCustomMissionButton:
			Controller.OpenMenu("SwatGui.CustomScenarioPage", "CustomScenarioPage");
			break;
		case MyHostButton:
			SwatGUIController(Controller).Repo.RoleChange(4);
			Controller.OpenMenu("SwatGui.SwatServerSetupMenu", "SwatServerSetupMenu");
			break;
		case MyJoinButton:
			SwatGUIController(Controller).Repo.RoleChange(5);
			Controller.OpenMenu("SwatGui.SwatServerBrowserMenu", "SwatServerBrowserMenu");
			break;
		case MyGameSettingsButton:
			Controller.OpenMenu("SwatGui.SwatGameSettingsMenu", "SwatGameSettingsMenu");
			break;
		case MyCreditsButton:
			Controller.OpenMenu("SwatGui.SwatCreditsMenu", "SwatCreditsMenu");
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
	Quit();
	return;
}

defaultproperties
{
	TrainingFriendlyString="Training"
	PromptToGotoTrainingFirstString="SWAT (R) 4 requires challenging squad-based tactics and compliance with law-enforcement procedures. It is [b]strongly[\\b] recommended that you play the training mission before attempting other SWAT engagements. Continue anyway?"
	ConfirmNoTrainingString="Are you sure that you do not want to play the training mission?"
	StyleName="STY_MainMenu"
	OnActivate=SwatMainMenu.InternalOnActivate
}