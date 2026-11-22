class SwatObjectivesPopupMenu extends SwatPopupMenuBase
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

var(SwatGui) private export editinline config SwatObjectivesPanel MyObjectivesPanel;
var(SwatGui) private export editinline config SwatLeadershipPanel MyLeadershipPanel;
var(SwatGui) private export editinline config SwatMapPanel MyMapPanel;
var(SwatGui) private export editinline config SwatOfficerStatusPanel MyOfficerStatusPanel;
var(SwatGui) private export editinline config GUIButton MyResumeGameButton;
var(SwatGui) private export editinline config GUIButton MyAbortGameButton;
var(SwatGui) private export editinline config GUIButton MyGameSettingsButton;
var private config localized string ContinueString;
var private config localized string ResumeString;
var private config localized string AbortString;
var private config localized string DebriefString;
var private config localized string AbortQueryString;
var private bool bOpeningSubPage;

function InitComponent(GUIComponent MyOwner)
{
	super.InitComponent(MyOwner);
	MyResumeGameButton.__OnClick__Delegate = InternalOnClick;
	MyAbortGameButton.__OnClick__Delegate = InternalOnClick;
	MyGameSettingsButton.__OnClick__Delegate = InternalOnClick;
	return;
}

event HandleParameters(string Param1, string Param2, optional int param3)
{
	super.HandleParameters(Param1, Param2, param3);
	MyResumeGameButton.SetVisibility(Not_PreBool(bPopup));
	MyResumeGameButton.SetActive(Not_PreBool(bPopup));
	MyAbortGameButton.SetVisibility(Not_PreBool(bPopup));
	MyAbortGameButton.SetActive(Not_PreBool(bPopup));
	MyGameSettingsButton.SetVisibility(Not_PreBool(bPopup));
	MyGameSettingsButton.SetActive(Not_PreBool(bPopup));
	return;
}

function InternalOnActivate()
{
	MyResumeGameButton.SetEnabled(Not_PreBool(GC.CurrentMission.IsMissionTerminal()));
	if(OrOr_BoolBool(GC.CurrentMission.IsMissionCompleted(), GC.CurrentMission.IsMissionFailed()))
	{
		MyResumeGameButton.SetCaption(ContinueString);
		MyAbortGameButton.SetCaption(DebriefString);
	}
	else
	{
		MyResumeGameButton.SetCaption(ResumeString);
		MyAbortGameButton.SetCaption(AbortString);
	}
	bOpeningSubPage = false;
	PlayerOwner().SetPause(true);
	return;
}

function InternalOnDeActivate()
{
	if(Not_PreBool(bOpeningSubPage))
	{
		PlayerOwner().UnTriggerEffectEvent('UIMenuLoop', Style.EffectCategory);
		PlayerOwner().SetPause(false);
	}
	return;
}

protected function AbortGame()
{
	if(OrOr_BoolBool(GC.CurrentMission.IsMissionCompleted(), GC.CurrentMission.IsMissionFailed()))
	{
		GameAbort();
	}
	else
	{
		__OnDlgReturned__Delegate = InternalOnDlgReturned;
		OpenDlg(AbortQueryString, QBTN_YesNo, "Abort");
	}
	return;
}

protected function ResumeGame()
{
	Controller.CloseMenu();
	return;
}

function InternalOnClick(GUIComponent Sender)
{
	switch(Sender)
	{
		case MyResumeGameButton:
			ResumeGame();
			break;
		case MyAbortGameButton:
			AbortGame();
			break;
		case MyGameSettingsButton:
			bOpeningSubPage = true;
			OpenGameSettings();
			break;
		default:
			break;
	}
	return;
}

function InternalOnDlgReturned(int Selection, string Passback)
{
	switch(Passback)
	{
		case "Abort":
			if(EqualEqual_IntInt(Selection, QBTN_Yes))
			{
				GameAbort();
			}
			break;
		default:
			break;
	}
	return;
}

defaultproperties
{
	ContinueString="CONTINUE"
	ResumeString="RESUME"
	AbortString="ABORT"
	DebriefString="DEBRIEF"
	AbortQueryString="Are you sure you wish to end the mission?"
	OnActivate=SwatObjectivesPopupMenu.InternalOnActivate
	OnDeActivate=SwatObjectivesPopupMenu.InternalOnDeActivate
}