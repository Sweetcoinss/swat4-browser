class SwatMissionLoadingMenu extends SwatGUIPage
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

var(SwatGui) private export editinline config GUILabel LoadingText;
var(SwatGui) private export editinline config GUIImage LoadingImage;
var(SwatGui) config array<Material> DefaultImages;
var(SwatGui) config localized array<localized string> DefaultCaptions;
var(SwatGui) private export editinline config GUILabel MissionLoadingStatusText;
var(SwatGui) private export editinline config GUIProgressBar MissionLoadingProgressBar;
var private config localized string LoadSplashString;
var private config localized string WaitForConnectionString;
var private config localized string LoadMapString;
var private config localized string DownloadString;

event Show()
{
	local int i;

	super.Show();
	if(AndAnd_BoolBool(AndAnd_BoolBool(EqualEqual_IntInt(int(GC.SwatGameRole), int(1)), NotEqual_ObjectObject(GC.CurrentMission, none)), NotEqual_ObjectObject(GC.CurrentMission.LoadingImage, none)))
	{
		LoadingText.SetCaption(GC.CurrentMission.LoadingText);
		LoadingImage.Image = GC.CurrentMission.LoadingImage;
	}
	else
	{
		if(Greater_IntInt(DefaultImages.Length, 0))
		{
			i = Rand(DefaultImages.Length);
			LoadingText.SetCaption(DefaultCaptions[i]);
			LoadingImage.Image = DefaultImages[i];
		}
		else
		{
			LoadingText.Hide();
			LoadingImage.Hide();
		}
	}
	return;
}

function PerformClose()
{
	return;
}

function OnProgress(string PercentComplete, string ExtraInfo)
{
	Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("  SwatMissionLoadingMenu ONPROGRESS Received: [", PercentComplete), "] ["), ExtraInfo), "]"));
	MissionLoadingProgressBar.Value = float(PercentComplete);
	if(EqualEqual_StrStr(ExtraInfo, "LoadSplash"))
	{
		MissionLoadingStatusText.SetCaption(LoadSplashString);
	}
	else
	{
		if(EqualEqual_StrStr(ExtraInfo, "WaitForConnection"))
		{
			MissionLoadingStatusText.SetCaption(WaitForConnectionString);
		}
		else
		{
			if(EqualEqual_StrStr(ExtraInfo, "LoadMap"))
			{
				MissionLoadingStatusText.SetCaption(LoadMapString);
			}
			else
			{
				if(EqualEqual_StrStr(ExtraInfo, "Download"))
				{
					MissionLoadingStatusText.SetCaption(DownloadString);
				}
			}
		}
	}
	if(NotEqual_ObjectObject(Controller, none))
	{
		Controller.PaintProgress();
	}
	return;
}

defaultproperties
{
	LoadSplashString="Loading..."
	WaitForConnectionString="Connecting..."
	LoadMapString="Loading..."
	DownloadString="Downloading..."
}