class SwatMissionAbortMenu extends SwatGUIPage
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

var private config localized string EndTheMissionConfirmation;

function InternalOnActivate()
{
	__OnDlgReturned__Delegate = InternalOnDlgReturned;
	OpenDlg(EndTheMissionConfirmation, QBTN_YesNo, "MissionAbort");
	return;
}

function InternalOnDlgReturned(int returnButton, optional string Passback)
{
	switch(Passback)
	{
		case "MissionAbort":
			if(EqualEqual_IntInt(returnButton, QBTN_Yes))
			{
				GameAbort();
			}
			else
			{
				Controller.CloseMenu();
			}
			break;
		default:
			break;
	}
	return;
}

protected function bool HandleKeyEvent(out byte Key, out byte State, float Delta)
{
	if(EqualEqual_IntInt(int(State), int(3)))
	{
		return false;
	}
	if(OrOr_BoolBool(EqualEqual_IntInt(int(Key), int(228)), EqualEqual_IntInt(int(Key), int(229))))
	{
		return true;
	}
	if(super.HandleKeyEvent(Key, State, Delta))
	{
		return true;
	}
	return true;
	return;
}

defaultproperties
{
	EndTheMissionConfirmation="Are you sure you wish to end the mission?"
	StyleName="STY_MissionAbortMenu"
	bSwallowAllKeyEvents=false
	OnActivate=SwatMissionAbortMenu.InternalOnActivate
}