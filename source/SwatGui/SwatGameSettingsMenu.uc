class SwatGameSettingsMenu extends SwatGUIPage
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

var(SwatGui) private export editinline config GUIButton MyMainMenuButton;
var(SwatGui) private export editinline config GUITabControl MyTabControl;
var config localized string MainMenuString;
var config localized string BackString;

function InitComponent(GUIComponent MyOwner)
{
	super.InitComponent(MyOwner);
	return;
}

function InternalOnActivate()
{
	MyMainMenuButton.__OnClick__Delegate = InternalOnClick;
	if(EqualEqual_IntInt(int(GC.SwatGameState), int(0)))
	{
		MyMainMenuButton.SetCaption(MainMenuString);
	}
	else
	{
		MyMainMenuButton.SetCaption(BackString);
	}
	Controller.SetCaptureScriptExec(true);
	return;
}

function InternalOnDeActivate()
{
	Controller.SetCaptureScriptExec(false);
	return;
}

function InternalOnClick(GUIComponent Sender)
{
	switch(Sender)
	{
		case MyMainMenuButton:
			Controller.CloseMenu();
			break;
		default:
			break;
	}
	return;
}

defaultproperties
{
	MainMenuString="MAIN MENU"
	BackString="BACK"
	StyleName="STY_SettingsMenu"
	OnActivate=SwatGameSettingsMenu.InternalOnActivate
	OnDeActivate=SwatGameSettingsMenu.InternalOnDeActivate
}