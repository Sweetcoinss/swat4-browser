class SwatMapPanel extends SwatGUIPanel
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

var(SwatGui) private export editinline config GUIImage MyLocationImage;
var(SwatGui) private export editinline config GUIImage MyBackgroundImage;
var private float MapWatchedDelayTime;

function InitComponent(GUIComponent MyOwner)
{
	super.InitComponent(MyOwner);
	MyBackgroundImage.bAcceptsInput = true;
	MyBackgroundImage.__OnMenuStateChanged__Delegate = OnLocationImagedStateChanged;
	return;
}

function InternalOnShow()
{
	if(EqualEqual_ObjectObject(GC.CurrentMission, none))
	{
		return;
	}
	Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[ckline]: SwatMapPanel --> GC.CurrentMission = ", string(GC.CurrentMission)), "; floorplans="), string(GC.CurrentMission.Floorplans)), "; LocationInfoText="), GC.CurrentMission.LocationInfoText[0]), "..."));
	MyLocationImage.Image = GC.CurrentMission.Floorplans;
	if(NotEqual_ObjectObject(SwatMPPage(Controller.TopPage()), none))
	{
		SwatMPPage(Controller.TopPage()).BringServerInfoToFront();
	}
	MyLocationImage.RePosition('UnWatched');
	return;
}

function OnLocationImagedStateChanged(GUIComponent Sender, GUI.eMenuState NewState)
{
	local export editinline SwatMPPage MPPage;

	Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(self), "::OnLocationImagedStateChanged( "), string(Sender)), ", "), string(NewState)), " ) "));
	MPPage = SwatMPPage(Controller.TopPage());
	if(EqualEqual_IntInt(int(NewState), int(1)))
	{
		SetTimer(MapWatchedDelayTime);
	}
	else
	{
		KillTimer();
		if(NotEqual_ObjectObject(MPPage, none))
		{
			MPPage.BringServerInfoToFront();
		}
		MyLocationImage.RePosition('UnWatched');
	}
	return;
}

event Timer()
{
	local export editinline SwatMPPage MPPage;

	MPPage = SwatMPPage(Controller.TopPage());
	if(NotEqual_ObjectObject(MPPage, none))
	{
		MPPage.SendServerInfoToBack();
	}
	MyLocationImage.RePosition('Watched');
	return;
}

defaultproperties
{
	MapWatchedDelayTime=0.5000000
	OnShow=SwatMapPanel.InternalOnShow
}