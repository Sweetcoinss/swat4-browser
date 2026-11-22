class SwatObjBriefingPanel extends SwatGUIPanel
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

var(SwatGui) private export editinline config GUIScrollTextBox MyObjectivesBox;
var(SwatGui) private export editinline config GUIScrollTextBox MyBriefingBox;
var(SwatGui) private export editinline config GUIImage MyInvalidImage;

function InitComponent(GUIComponent MyOwner)
{
	super.InitComponent(MyOwner);
	return;
}

function InternalOnShow()
{
	local MissionObjectives theObjectives;
	local int i;
	local string DisplayString;

	theObjectives = GC.CurrentMission.Objectives;
	DisplayString = "";
	i = 0;
	J0x2C:

	if(Less_IntInt(i, theObjectives.Objectives.Length))
	{
		if(theObjectives.Objectives[i].IsHidden)
		{
			// [Explicit Continue]
			goto J0x9E;
		}
		DisplayString = Concat_StrStr(Concat_StrStr(Concat_StrStr(DisplayString, ">"), theObjectives.Objectives[i].Description), "||");
		J0x9E:

		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x2C;
	}
	MyObjectivesBox.SetContent(DisplayString);
	DisplayString = "";
	i = 0;
	J0xCB:

	if(Less_IntInt(i, GC.CurrentMission.BriefingText.Length))
	{
		DisplayString = Concat_StrStr(Concat_StrStr(DisplayString, GC.CurrentMission.BriefingText[i]), "|");
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0xCB;
	}
	MyBriefingBox.SetContent(DisplayString);
	return;
}

event Show()
{
	super.Show();
	MyInvalidImage.SetVisibility(NotEqual_ObjectObject(GC.CurrentMission.CustomScenario, none));
	return;
}

defaultproperties
{
	WinTop=0.2133300
	WinLeft=0.0500000
	WinWidth=0.8750000
	WinHeight=0.6666600
	OnShow=SwatObjBriefingPanel.InternalOnShow
}