class SwatObjectivesPanel extends SwatGUIPanel
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

var(SwatGui) private export editinline config GUIMultiColumnListBox MyObjectivesBox;
var(SwatGui) private config localized string InProgressString;
var(SwatGui) private config localized string CompletedString;
var(SwatGui) private config localized string FailedString;
var(SwatGui) private config Color InProgressColor;
var(SwatGui) private config Color CompletedColor;
var(SwatGui) private config Color FailedColor;

function InitComponent(GUIComponent MyOwner)
{
	super.InitComponent(MyOwner);
	return;
}

function InternalOnShow()
{
	UpdateObjectives();
	if(NotEqual_IntInt(int(PlayerOwner().Level.NetMode), int(NM_Standalone)))
	{
		SetTimer(GC.MPPollingDelay, true);
	}
	return;
}

event Timer()
{
	UpdateObjectives();
	return;
}

function UpdateObjectives()
{
	local MissionObjectives theObjectives;
	local int i;
	local SwatGameReplicationInfo SGRI;

	if(EqualEqual_ObjectObject(GC.CurrentMission, none))
	{
		return;
	}
	SGRI = SwatGameReplicationInfo(PlayerOwner().GameReplicationInfo);
	theObjectives = GC.CurrentMission.Objectives;
	MyObjectivesBox.Clear();
	if(EqualEqual_ObjectObject(SGRI, none))
	{
		return;
	}
	i = 0;
	J0x70:

	if(Less_IntInt(i, theObjectives.Objectives.Length))
	{
		if(theObjectives.Objectives[i].IsHidden)
		{
			// [Explicit Continue]
			goto J0x126;
		}
		MyObjectivesBox.AddNewRowElement("Objective",, theObjectives.Objectives[i].Description);
		MyObjectivesBox.AddNewRowElement("Status",, ObjectiveStatusToString(SGRI.ObjectiveStatus[i]));
		MyObjectivesBox.PopulateRow();
		J0x126:

		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x70;
	}
	return;
}

private function string ObjectiveStatusToString(Objective.ObjectiveStatus Status)
{
	switch(Status)
	{
		case 0:
			return Concat_StrStr(MakeColorCode(InProgressColor), InProgressString);
		case 1:
			return Concat_StrStr(MakeColorCode(CompletedColor), CompletedString);
		case 2:
			return Concat_StrStr(MakeColorCode(FailedColor), FailedString);
		default:
			assert(false);
			return;
			break;
	}
}

defaultproperties
{
	InProgressString="In Progress"
	CompletedString="Completed"
	FailedString="Failed"
	InProgressColor=(R=151,G=151,B=151,A=255)
	CompletedColor=(R=0,G=255,B=0,A=255)
	FailedColor=(R=255,G=0,B=0,A=255)
	WinTop=0.2133300
	WinLeft=0.0500000
	WinWidth=0.8750000
	WinHeight=0.6666600
	OnShow=SwatObjectivesPanel.InternalOnShow
}