class SwatMissionSetupMenu extends SwatGUIPage
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

var(SwatGui) private export editinline config GUIButton MyQuitButton;
var(SwatGui) private export editinline config GUIButton MyStartButton;
var(SwatGui) private export editinline config GUIButton MyBackButton;
var(SwatGui) private export editinline config GUIButton MyMainMenuButton;
var(SwatGui) private export editinline config GUITabControl MyTabControl;
var private config localized string CampaignString;
var private config localized string CustomString;
var bool bOpeningSubMenu;

function InitComponent(GUIComponent MyOwner)
{
	super.InitComponent(MyOwner);
	return;
}

function InternalOnShow()
{
	MyQuitButton.__OnClick__Delegate = InternalOnClick;
	MyStartButton.__OnClick__Delegate = InternalOnClick;
	MyBackButton.__OnClick__Delegate = InternalOnClick;
	MyMainMenuButton.__OnClick__Delegate = InternalOnClick;
	if(EqualEqual_IntInt(int(GC.SwatGameRole), int(2)))
	{
		MyBackButton.SetCaption(CustomString);
	}
	else
	{
		MyBackButton.SetCaption(CampaignString);
	}
	return;
}

function InternalOnActivate()
{
	if(Not_PreBool(bOpeningSubMenu))
	{
		GC.ClearCurrentMission();
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

function InternalOnClick(GUIComponent Sender)
{
	switch(Sender)
	{
		case MyQuitButton:
			Quit();
			break;
		case MyStartButton:
			GameStart();
			break;
		case MyBackButton:
			Controller.CloseMenu();
			break;
		case MyMainMenuButton:
			DisplayMainMenu();
			break;
		default:
			break;
	}
	return;
}

defaultproperties
{
	CampaignString="CAMPAIGN"
	CustomString="CUSTOM"
	OnShow=SwatMissionSetupMenu.InternalOnShow
	OnActivate=SwatMissionSetupMenu.InternalOnActivate
}