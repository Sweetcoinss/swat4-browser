class SwatGUIPage extends GUIPage
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

var(DynamicConfig) private editconst editinline SwatGUIConfig GC "Config class for the GUI";
var(SwatGui) private config name CameraPositionLabel "When specified, will move the camera to the location specified by the given camera position when the page is shown.";
var private config localized string QuitPrompt;

function InitComponent(GUIComponent MyOwner)
{
	GC = SwatGUIController(Controller).GuiConfig;
	super.InitComponent(MyOwner);
	HelpText = GUILabel(AddComponent("GUI.GUILabel", Concat_StrStr(string(self.Name), "_SwatHelpText"), true));
	__OnKeyEvent__Delegate = InternalOnKeyEvent;
	return;
}

event Show()
{
	if(OrOr_BoolBool(EqualEqual_IntInt(int(GC.SwatGameState), int(0)), AndAnd_BoolBool(NotEqual_IntInt(int(GC.SwatGameRole), int(4)), NotEqual_IntInt(int(GC.SwatGameRole), int(5)))))
	{
		PlayerOwner().TriggerEffectEvent('UIMenuLoop',,,,,,,, Style.EffectCategory);
	}
	if(ShouldSetSplashCameraPosition())
	{
		SetSplashCameraPosition();
	}
	super.Show();
	return;
}

function DisplayMainMenu()
{
	if(NotEqual_ObjectObject(CurrentDialog, none))
	{
		return;
	}
	Controller.CloseAll();
	Controller.OpenMenu("SwatGui.SwatMainMenu", "SwatMainMenu");
	return;
}

function Quit()
{
	Log("Quit: Confirming");
	__OnDlgReturned__Delegate = OnQuitDialogReturned;
	OpenDlg(QuitPrompt, QBTN_YesNo, "Quit");
	return;
}

final function OnQuitDialogReturned(int Selection, string Passback)
{
	if(EqualEqual_IntInt(Selection, QBTN_Yes))
	{
		Log("Quit: Confirmed");
		PerformQuitToWindows();
	}
	return;
}

final function PerformQuitToWindows()
{
	SwatGUIController(Controller).Quit();
	return;
}

function PerformClose()
{
	assert(EqualEqual_ObjectObject(self, Controller.TopPage()));
	Controller.CloseMenu();
	return;
}

function GameStart()
{
	SwatGUIController(Controller).GameStart();
	return;
}

function GameAbort()
{
	SwatGUIController(Controller).GameAbort();
	return;
}

function GameRestart()
{
	SwatGUIController(Controller).GameAbort();
	SwatGUIController(Controller).GameStart();
	return;
}

protected function bool ShouldSetSplashCameraPosition()
{
	return true;
	return;
}

private final function SetSplashCameraPosition()
{
	local CameraPositionMarker Marker;

	if(EqualEqual_NameName(CameraPositionLabel, 'None'))
	{
		return;
	}
	Marker = CameraPositionMarker(PlayerOwner().findStaticByLabel(Class'Engine.CameraPositionMarker', CameraPositionLabel));
	if(NotEqual_ObjectObject(Marker, none))
	{
		PlayerOwner().SetViewTarget(PlayerOwner());
		PlayerOwner().SetLocation(Marker.Location);
		PlayerOwner().SetRotation(Marker.Rotation);
	}
	return;
}

function bool InternalOnKeyEvent(out byte Key, out byte State, float Delta)
{
	return HandleKeyEvent(Key, State, Delta);
	return;
}

protected function bool HandleKeyEvent(out byte Key, out byte State, float Delta)
{
	if(AndAnd_BoolBool(AndAnd_BoolBool(EqualEqual_IntInt(int(State), int(1)), KeyMatchesBinding(Key, "GUICloseMenu")), EqualEqual_ObjectObject(Controller.TopPage(), self)))
	{
		PerformClose();
		return true;
	}
	return false;
	return;
}

function OpenPopup(string ClassName, string ObjName)
{
	Controller.OpenMenu(ClassName, ObjName);
	return;
}

event Free(optional bool bForce)
{
	GC = none;
	super.Free(bForce);
	return;
}

defaultproperties
{
	QuitPrompt="Quit to Windows?"
	bIsOverlay=false
	StyleName="STY_DefaultMenu"
	bNeverTriggerEffectEvents=true
}