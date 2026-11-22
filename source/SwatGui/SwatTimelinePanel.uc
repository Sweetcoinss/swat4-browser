class SwatTimelinePanel extends SwatGUIPanel
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

var(SwatGui) private export editinline config GUITimeline Timeline;
var(SwatGui) private export editinline config GUIListBox MyTimeline;
var(SwatGui) private export editinline config GUIScrollTextBox MyExtendedTimeline;
var(SwatGui) private export editinline config GUIImage MyInvalidImage;
var private bool bloading;

function InitComponent(GUIComponent MyOwner)
{
	super.InitComponent(MyOwner);
	MyTimeline.__OnChange__Delegate = TimeSelected;
	return;
}

function InternalOnShow()
{
	local int i;

	bloading = true;
	MyTimeline.Clear();
	Timeline.ClearPlot();
	i = 0;
	J0x2D:

	if(Less_IntInt(i, GC.CurrentMission.TimeLineTime.Length))
	{
		MyTimeline.List.Add(At_StrStr(GC.CurrentMission.TimeLineTime[i], GC.CurrentMission.TimeLineShortDescription[i]),, At_StrStr(GC.CurrentMission.TimeLineTime[i], GC.CurrentMission.TimeLineLongDescription[i]), i);
		Timeline.AddTimePlot(GC.CurrentMission.TimeLinePlot[i]);
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x2D;
	}
	bloading = false;
	MyTimeline.List.setIndex(0);
	return;
}

event Show()
{
	super.Show();
	MyInvalidImage.SetVisibility(NotEqual_ObjectObject(GC.CurrentMission.CustomScenario, none));
	return;
}

function TimeSelected(GUIComponent Sender)
{
	if(bloading)
	{
		return;
	}
	MyExtendedTimeline.SetContent(MyTimeline.List.GetExtra());
	Timeline.SelectPlot(MyTimeline.List.GetExtraIntData());
	return;
}

defaultproperties
{
	WinTop=0.2133300
	WinLeft=0.0500000
	WinWidth=0.8750000
	WinHeight=0.6666600
	OnShow=SwatTimelinePanel.InternalOnShow
}