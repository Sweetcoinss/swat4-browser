class GUIController extends BaseGUIController
	native
	config(GuiBase)
	hidecategories(Menu,Object);

cpptext
{
        UBOOL ScriptConsoleExec( const TCHAR* Str, FOutputDevice& Ar, UObject* Executor );
		void  NativeMessage(const FString Msg, FLOAT MsgLife);
		UBOOL NativeKeyType(BYTE& iKey, TCHAR Unicode );
		UBOOL NativeKeyEvent(BYTE& iKey, BYTE& State, FLOAT Delta );
		void  NativeTick(FLOAT DeltaTime);
		void  NativePreRender(UCanvas* Canvas);
		void  NativePostRender(UCanvas* Canvas);

		virtual void LookUnderCursor(FLOAT dX, FLOAT dY);
		UGUIComponent* UnderCursor(FLOAT MouseX, FLOAT MouseY);

		UBOOL virtual MousePressed(UBOOL IsRepeat);
		UBOOL virtual MouseReleased();

		UBOOL HasMouseMoved();

		void PlayInterfaceSound(USound* sound);
		void PlayClickSound(BYTE SoundNum);

        virtual void Modify(); //callback from the object browser

        void GroupAllControlsInBounds( UGUIMultiComponent* Ctrl, FLOAT top, FLOAT bottom, FLOAT left, FLOAT right );

        void PreChangeActiveMenu();

}

enum eComponentAlign
{
	cALIGN_Left,                    // 0
	cALIGN_Right,                   // 1
	cALIGN_Top,                     // 2
	cALIGN_Bottom                   // 3
};

enum eComponentSize
{
	cSIZE_Width,                    // 0
	cSIZE_Height                    // 1
};

struct native sMoveGroup
{
	var() editconst editinline array<export editinline GUIComponent> CtrlGroup "Group of controls that can be moved/sized together";
};

var(MiscState) config bool bDontDisplayHelpText "If true, help text will never be displayed for this page";
var(EditorState) editconst editinline array<editinline sMoveGroup> MoveGroups "Array of groups of controls";
var(Grid) config int GridSize "Size of grid";
var(Grid) config bool bSnapToGrid "If set will snap to grid in edit mode";
var(Grid) editconst config int ResolutionX "Screen width in pixels.  Set using console command \"SetGuiRes X Y\"";
var(Grid) editconst config int ResolutionY "Screen height in pixels.  Set using console command \"SetGuiRes X Y\"";
var(EditorState) editconst bool bMousePositioning "the mouse is being used to position a component";
var(ActorAdjustments) config float GUI_TO_WORLD_X "minor adjustment to all actors in the X direction";
var(ActorAdjustments) config float GUI_TO_WORLD_Y "minor adjustment to all actors in the Y direction";
var(EditorState) editconst bool bLastScaled "used for pagewide scale toggling";
var() config array<string> PackageNames "FileNames of packages to autoload when running the gui editor";
var(EditorState) editconst bool bHasLoadedPackages "will only load packages the first time (when this is false)";
var(GUIPages) editconst editinline array<export editinline GUIComponent> PersistentStack "Holds the set of Components which are persistent across close/open/reopen; only instanciated once";
var(EditorState) editconst export editinline array<export editinline GUIPage> MenuStack "Holds the stack of menus";
var(EditorState) editconst export editinline GUIPage ActivePage "Points to the currently active page";
var() editinline config array<editinline string> FontNames "Holds all the possible font names";
var(EditorState) editconst editinline array<export editinline GUIFont> FontStack "Holds all the possible fonts";
var(EditorState) editconst editinline array<export editinline GUIStyles> StyleStack "Holds all of the possible styles";
var() editinline config array<editinline string> StyleNames "Holds the name of all styles to use";
var(Cursors) editinline config array<editinline Material> MouseCursors "Holds a list of all possible mouse";
var(Cursors) editinline config array<editinline Vector> MouseCursorOffset "Only X,Y used, between 0 and 1. 'Hot Spot' of cursor material.";
var(MiscState) editconst byte ControllerMask "Used to mask input for various Controllers";
var(MiscState) editconst byte ControllerId "The current Controller ID #";
var(MiscState) editconst float MouseX;
var(MiscState) editconst float MouseY "Where is the mouse currently located";
var(MiscState) editconst float LastMouseX;
var(MiscState) editconst float LastMouseY;
var(MiscState) editconst bool ShiftPressed "Shift key is being held";
var(MiscState) editconst bool AltPressed "Alt key is being held";
var(MiscState) editconst bool CtrlPressed "Ctrl key is being held";
var(MiscState) config float DblClickWindow "How long do you have for a double click";
var(MiscState) editconst float LastClickTime "When did the last click occur";
var(MiscState) editconst int LastClickX;
var(MiscState) editconst int LastClickY "Who was the active component";
var(MiscState) editconst float ButtonRepeatDelay "The amount of delay for faking button repeats";
var(MiscState) editconst byte RepeatKey[4] "Used to determine what should repeat";
var(MiscState) editconst float RepeatDelta[4] "Data var";
var(MiscState) editconst float RepeatTime[4] "How long until the next repeat;";
var(MiscState) editconst float CursorFade "How visible is the cursor";
var(MiscState) editconst int CursorStep "Are we fading in or out";
var(MiscState) editconst float FastCursorFade "How visible is the cursor";
var(MiscState) editconst int FastCursorStep "Are we fading in or out";
var(MiscState) editconst export editinline GUIComponent FocusedControl "Top most Focused control";
var(MiscState) editconst export editinline GUIComponent ActiveControl "Which control is currently active";
var(MiscState) editconst export editinline GUIComponent SkipControl "This control should be skipped over and drawn at the end";
var(MiscState) editconst export editinline GUIComponent MoveControl "Used for visual design";
var(MiscState) config bool bModAuthor "Allows bDesign Mode";
var(MiscState) editconst bool bDesignMode "Are we in design mode";
var(MiscState) editconst bool bHighlightCurrent "Highlight the current control being edited";
var(EditorState) editconst bool bStyleCreate "Are we creating a new style";
var(EditorState) editconst bool bStylesDisplay "Are we displaying available styles/fonts";
var(EditorState) editconst bool bMemberDisplay "Are we displaying member properties";
var(EditorState) editconst bool bMemberEdit "Are we editing member properties";
var(EditorState) editconst bool bEditing "Are we currently editing a member's properties";
var(EditorState) editconst bool bHelpDisplay "Are we showing the help menu";
var(EditorState) editconst bool bShowConfigMembers "Are we showing the Config members?";
var(EditorState) editconst bool bShowGUIMembers "Are we showing the GUI members?";
var(EditorState) editconst bool bShowPageList "Are we showing the page list?";
var(EditorState) editconst bool bComponentMenu "Are we showing the available components?";
var(Clipboard) editconst export editinline GUIComponent SaveControl "The Clipboard component for storing component's config members";
var(Clipboard) editconst export editinline GUIStyles SaveStyle "The Clipboard style for storing style's config members";
var(EditorState) editconst string CurrentMemberObjName "currently active (for edit) member";
var(EditorState) editconst array<string> CurrentMemberObjValue "current text entry for current member";
var(EditorState) editconst int CurrentMember "current position in member list";
var(EditorState) editconst int MemberEditLevel "current position in edit history";
var(EditorState) editconst int MemberEditPosition "current position in edit string";
var() editinline config localized array<editinline localized string> HelpStack "List of GUI editor commands";
var() editinline config array<editinline string> ComponentClassList "List of available GUI components";
var(Misc) config float MenuMouseSens "Mouse Sensitivity in the gui";
var(Sounds) config Sound MouseOverSound "Sound played when the mouse moves over something";
var(Sounds) config Sound ClickSound "Sound played when the mouse clicks something";
var(Sounds) config Sound EditSound "Sound played when a change is made";
var(Sounds) config Sound UpSound "Sound played on an up-click";
var(Sounds) config Sound DownSound "Sound played on a down-click";
var(MiscState) editconst bool bForceMouseCheck "Forces the gui to check the mouse immediately following the open/close of a page to get what is underneath";
var(MiscState) editconst bool bForceUpdate "While true, components should perform updates, regardless of their bDirty flags";
var(MiscState) editconst bool bSwallowNextKeyType "Forces the gui to drop and swallow the next key type";
var() editinline config array<editinline ControlSpec> AutoLoad "Any components specified in here will be automatically loaded on startup, usefull for pages, panels, and other intensively functional components";
var array<export editinline GUIComponent> InterestedResolutionChanged;
var(Misc) config bool bEmulatedJoypad "Have the cursor keys emulate a XBox controller";
var(Misc) config bool bJoyMouse "When true, right control stick acts as a 1 button mouse";
var(Misc) config bool bHideMouseCursor "When true, the mouse cursor will be hidden";
var(Misc) config float JoyDeadZone "The DeadZone for joysticks";
var float JoyLeftXAxis[4];
var float JoyLeftYAxis[4];
var float JoyRightXAxis[4];
var float JoyRightYAxis[4];
var byte JoyButtons[64];
var float JoyControlsDelta[16];
var Material WhiteBorder;
var(DEBUG) private bool CaptureScriptExec "When non-zero, does not allow other interactions to process script exec functions";
var config localized string DLG_OK;
var config localized string DLG_Yes;
var config localized string DLG_Continue;
var config localized string DLG_Retry;
var config localized string DLG_Ignore;
var config localized string DLG_No;
var config localized string DLG_Abort;
var config localized string DLG_Cancel;
var localized string PleaseWaitString;
//var delegate<OnNeedRawKeyPress> __OnNeedRawKeyPress__Delegate;

// Export UGUIController::execGetMenuFont(FFrame&, void* const)
native event GUIFont GetMenuFont(string FontName);

// Export UGUIController::execGetStyle(FFrame&, void* const)
native event GUIStyles GetStyle(string StyleName);

// Export UGUIController::execGetCurrentRes(FFrame&, void* const)
native function string GetCurrentRes();

// Export UGUIController::execGetMapList(FFrame&, void* const)
native function GetMapList(string Prefix, GUIList List);

// Export UGUIController::execLoadLevelSummary(FFrame&, void* const)
native function LevelSummary LoadLevelSummary(string LevelSummaryName);

// Export UGUIController::execResetKeyboard(FFrame&, void* const)
native function ResetKeyboard();

// Export UGUIController::execMouseEmulation(FFrame&, void* const)
native function MouseEmulation(bool On);

delegate bool OnNeedRawKeyPress(byte NewKey)
{
	return;
}

event OnTick(float DeltaSeconds)
{
	return;
}

event InitializeController()
{
	local int i;

	GetGuiResolution();
	FontStack.Remove(0, FontStack.Length);
	StyleStack.Remove(0, StyleStack.Length);
	i = 0;
	J0x27:

	if(Less_IntInt(i, FontNames.Length))
	{
		if(Not_PreBool(RegisterFont(FontNames[i])))
		{
			Log(At_StrStr("Could not create requested font", FontNames[i]));
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x27;
	}
	i = 0;
	J0x8E:

	if(Less_IntInt(i, StyleNames.Length))
	{
		if(Not_PreBool(RegisterStyle(StyleNames[i])))
		{
			Log(At_StrStr("Could not create requested style", StyleNames[i]));
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x8E;
	}
	if(bModAuthor)
	{
		SaveStyle = Class'GUI.GUIStyles'.static.Allocate(self, none).;
		Construct_Void();
		i = 0;
		J0x121:

		if(Less_IntInt(i, 10))
		{
			MakeMoveGroup();
			AddAdd_Int(i);
			// [Loop Continue]
			goto J0x121;
		}
	}
	bActive = true;
	AutoLoadMenus();
	return;
}

event bool RegisterFont(string FontClass)
{
	local export editinline GUIFont NewFont;

	NewFont = Class'GUI.GUIFont'.static.Allocate(self, none, FontClass).;
	Construct_Void();
	if(NotEqual_ObjectObject(NewFont, none))
	{
		NewFont.Controller = self;
		FontStack[FontStack.Length] = NewFont;
		return true;
	}
	return false;
	return;
}

event bool RegisterStyle(string StyleClass)
{
	local export editinline GUIStyles NewStyle;

	NewStyle = Class'GUI.GUIStyles'.static.Allocate(self, none, StyleClass).;
	Construct_Void();
	if(NotEqual_ObjectObject(NewStyle, none))
	{
		StyleStack[StyleStack.Length] = NewStyle;
		NewStyle.KeyName = StyleClass;
		NewStyle.Controller = self;
		NewStyle.Initialize();
		return true;
	}
	return false;
	return;
}

function SetControllerStatus(bool On)
{
	bVisible = On;
	bRequiresTick = On;
	ViewportOwner.bShowWindowsMouse = AndAnd_BoolBool(On, Not_PreBool(ActivePage.bIsHUD));
	if(Not_PreBool(On))
	{
		ViewportOwner.Actor.ConsoleCommand("toggleime 0");
	}
	return;
}

event AutoLoadMenus()
{
	local export editinline GUIComponent NewMenu;
	local int i;

	Log("GUIController: Autoloading Components...");
	super.AutoLoadMenus();
	i = 0;
	J0x39:

	if(Less_IntInt(i, AutoLoad.Length))
	{
		NewMenu = CreateComponent(AutoLoad[i].ClassName, AutoLoad[i].ObjName);
		if(EqualEqual_ObjectObject(NewMenu, none))
		{
			Log(At_StrStr("  Could not Autoload", AutoLoad[i].ObjName));
			// [Explicit Continue]
			goto J0xF7;
		}
		if(Not_PreBool(NewMenu.bInited))
		{
			NewMenu.InitComponent(none);
		}
		Log(Concat_StrStr("AutoLoaded Menu ", AutoLoad[i].ObjName));
		J0xF7:

		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x39;
	}
	return;
}

function string FixGUIComponentName(string ComponentName)
{
	if(Greater_IntInt(Len(ComponentName), 64))
	{
		ComponentName = Concat_StrStr(Concat_StrStr(Left(ComponentName, 45), "X"), Right(ComponentName, 17));
	}
	return ComponentName;
	return;
}

event GUIComponent CreateComponent(string ComponentClass, optional string ComponentName)
{
	local Class<GUIComponent> NewComponentClass;
	local export editinline GUIComponent NewComponent;

	if(EqualEqual_StrStr(ComponentName, ""))
	{
		ComponentName = Right(ComponentClass, Subtract_IntInt(Subtract_IntInt(Len(ComponentClass), InStr(ComponentClass, ".")), 1));
	}
	ComponentName = FixGUIComponentName(ComponentName);
	NewComponent = FindPersistentComponent(ComponentName, true);
	if(NotEqual_ObjectObject(NewComponent, none))
	{
		return NewComponent;
	}
	NewComponentClass = Class<GUIComponent>(DynamicLoadObject(ComponentClass, Class'Core.Class'));
	if(NotEqual_ObjectObject(NewComponentClass, none))
	{
		NewComponent = NewComponentClass.static.Allocate(self, none, ComponentName).;
		Construct_GUIController(self);
		if(EqualEqual_ObjectObject(NewComponent, none))
		{
			Log(At_StrStr("Could not create requested component", ComponentClass));
			return none;
		}
		if(NewComponent.bPersistent)
		{
			PersistentStack[PersistentStack.Length] = NewComponent;
		}
		NewComponent.Controller = self;
		return NewComponent;
	}
	else
	{
		Log(Concat_StrStr(Concat_StrStr("Could not DLO component '", ComponentClass), "'"));
		return none;
	}
	return;
}

event ReloadGUI()
{
	PersistentStack.Remove(0, PersistentStack.Length);
	AutoLoadMenus();
	return;
}

event GUIPage CreateMenu(string NewMenuName, optional string MenuNameOverride)
{
	return GUIPage(CreateComponent(NewMenuName, MenuNameOverride));
	return;
}

event GUIComponent FindPersistentComponent(string theName, optional bool bExact)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, PersistentStack.Length))
	{
		if(OrOr_BoolBool(ComplementEqual_StrStr(theName, string(PersistentStack[i].Name)), AndAnd_BoolBool(Not_PreBool(bExact), GreaterEqual_IntInt(InStr(Caps(string(PersistentStack[i].Name)), Caps(theName)), 0))))
		{
			return PersistentStack[i];
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	return none;
	return;
}

function RemovePersistentComponent(GUIComponent Ctrl)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, PersistentStack.Length))
	{
		if(EqualEqual_ObjectObject(Ctrl, PersistentStack[i]))
		{
			PersistentStack[i] = none;
			PersistentStack.Remove(i, 1);
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

// Export UGUIController::execPreChangeActiveMenu(FFrame&, void* const)
native final function PreChangeActiveMenu();

function OpenWaitDialog(optional string WaitString)
{
	if(EqualEqual_ObjectObject(ActivePage, none))
	{
		return;
	}
	if(EqualEqual_StrStr(WaitString, ""))
	{
		WaitString = PleaseWaitString;
	}
	ActivePage.__OnDlgReturned__Delegate = None;
	ActivePage.OpenDlg(WaitString, 0, "WaitDialogueDoNotUse", int(0.0500000));
	PaintProgress();
	return;
}

function CloseWaitDialog()
{
	if(EqualEqual_ObjectObject(ActivePage, none))
	{
		return;
	}
	ActivePage.DlgReturned();
	return;
}

event bool OpenMenu(string NewMenuName, optional string MenuNameOverride, optional string Param1, optional string Param2, optional int param3)
{
	if(AndAnd_BoolBool(EqualEqual_ObjectObject(FindPersistentComponent(NewMenuName), none), EqualEqual_ObjectObject(FindPersistentComponent(MenuNameOverride), none)))
	{
		OpenWaitDialog();
	}
	return InternalOpenMenu(CreateMenu(NewMenuName, MenuNameOverride), Param1, Param2, param3);
	return;
}

event bool InternalOpenMenu(GUIPage NewMenu, optional string Param1, optional string Param2, optional int param3)
{
	Log(Concat_StrStr(Concat_StrStr(string(self), " >>> Opening menu "), string(NewMenu)));
	PreChangeActiveMenu();
	if(NotEqual_ObjectObject(NewMenu, none))
	{
		if(Not_PreBool(NewMenu.bInited))
		{
			NewMenu.InitComponent(none);
		}
		ResetFocus();
		if(NotEqual_ObjectObject(ActivePage, none))
		{
			ActivePage.CleanupDialogs();
			ActivePage.DeActivate();
			if(Not_PreBool(NewMenu.bIsOverlay))
			{
				ActivePage.Hide();
			}
		}
		ActivePage = NewMenu;
		MenuStack[MenuStack.Length] = ActivePage;
		ActivePage.Show();
		if(Not_PreBool(ActivePage.bIsHUD))
		{
			ActivePage.Activate();
		}
		ActivePage.HandleParameters(Param1, Param2, param3);
		ActivePage.PostActivate();
		SetControllerStatus(true);
		bForceMouseCheck = true;
		return true;
	}
	else
	{
		return false;
	}
	return;
}

event bool ReplaceMenu(string NewMenuName, optional string MenuNameOverride, optional string Param1, optional string Param2, optional int param3)
{
	local export editinline GUIPage NewMenu;

	Log(Concat_StrStr(Concat_StrStr(string(self), " >>> Replacing menu "), NewMenuName));
	PreChangeActiveMenu();
	NewMenu = CreateMenu(NewMenuName, MenuNameOverride);
	if(NotEqual_ObjectObject(NewMenu, none))
	{
		if(Not_PreBool(NewMenu.bInited))
		{
			NewMenu.InitComponent(none);
		}
		ResetFocus();
		if(NotEqual_ObjectObject(ActivePage, none))
		{
			ActivePage.CleanupDialogs();
			ActivePage.DeActivate();
			if(Not_PreBool(NewMenu.bIsOverlay))
			{
				ActivePage.Hide();
			}
			MenuStack.Remove(Subtract_IntInt(MenuStack.Length, 1), 1);
		}
		ActivePage = NewMenu;
		MenuStack[MenuStack.Length] = ActivePage;
		ActivePage.Show();
		if(Not_PreBool(ActivePage.bIsHUD))
		{
			ActivePage.Activate();
		}
		ActivePage.HandleParameters(Param1, Param2, param3);
		ActivePage.PostActivate();
		SetControllerStatus(true);
		bForceMouseCheck = true;
		return true;
	}
	else
	{
		return false;
	}
	return;
}

event bool CloseMenu()
{
	local export editinline GUIPage oldPage;

	Log(Concat_StrStr(Concat_StrStr(string(self), " >>> Closing menu "), string(ActivePage)));
	PreChangeActiveMenu();
	if(LessEqual_IntInt(MenuStack.Length, 0))
	{
		Log("Attempting to close a non-existing menu page");
		return false;
	}
	ActivePage.CleanupDialogs();
	ActivePage.DeActivate();
	ActivePage.Hide();
	oldPage = ActivePage;
	MenuStack.Remove(Subtract_IntInt(MenuStack.Length, 1), 1);
	MoveControl = none;
	SkipControl = none;
	ActiveControl = none;
	ActivePage = none;
	if(Greater_IntInt(MenuStack.Length, 0))
	{
		ActivePage = MenuStack[Subtract_IntInt(MenuStack.Length, 1)];
		if(Not_PreBool(oldPage.bIsOverlay))
		{
			ActivePage.Show();
		}
		if(Not_PreBool(ActivePage.bIsHUD))
		{
			ActivePage.Activate();
		}
		ActivePage.PostActivate();
		SetControllerStatus(true);
	}
	else
	{
		SetControllerStatus(false);
	}
	bForceMouseCheck = true;
	return true;
	return;
}

event CloseAll()
{
	local int i;

	if(LessEqual_IntInt(MenuStack.Length, 0))
	{
		return;
	}
	i = 0;
	J0x15:

	if(Less_IntInt(i, Subtract_IntInt(MenuStack.Length, 1)))
	{
		if(MenuStack[i].bActiveInput)
		{
			MenuStack[i].DeActivate();
		}
		if(MenuStack[i].bVisible)
		{
			MenuStack[i].Hide();
		}
		if(Not_PreBool(MenuStack[i].bPersistent))
		{
			MenuStack[i].Free();
		}
		MenuStack[i] = none;
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x15;
	}
	MenuStack.Remove(0, Subtract_IntInt(MenuStack.Length, 1));
	CloseMenu();
	return;
}

function GUIPage TopPage()
{
	return ActivePage;
	return;
}

function GUIPage ParentPage()
{
	if(Greater_IntInt(MenuStack.Length, 1))
	{
		return MenuStack[Subtract_IntInt(MenuStack.Length, 2)];
	}
	return none;
	return;
}

event PreLevelChange()
{
	super.PreLevelChange();
	return;
}

event PostLevelChange()
{
	super.PostLevelChange();
	return;
}

event ChangeFocus(GUIComponent NewFocus)
{
	if(AndAnd_BoolBool(NotEqual_ObjectObject(FocusedControl, none), NotEqual_ObjectObject(FocusedControl, NewFocus)))
	{
		FocusedControl.LoseFocus();
	}
	FocusedControl = NewFocus;
	FocusedControl.SetFocusInstead(none, true);
	return;
}

function ResetFocus()
{
	local int i;

	if(NotEqual_ObjectObject(ActiveControl, none))
	{
		ActiveControl.EnableComponent();
		ActiveControl = none;
	}
	i = 0;
	J0x28:

	if(Less_IntInt(i, 4))
	{
		RepeatKey[i] = 0;
		RepeatTime[i] = 0.0000000;
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x28;
	}
	return;
}

function SetCaptureScriptExec(bool bCapture)
{
	CaptureScriptExec = bCapture;
	return;
}

function MakeMoveGroup()
{
	local sMoveGroup mtGroup;

	MoveGroups[MoveGroups.Length] = mtGroup;
	return;
}

event GroupControl(GUIComponent Ctrl, int Group)
{
	local int i;

	if(GreaterEqual_IntInt(Ctrl.MoveGroup, 0))
	{
		i = 0;
		J0x1B:

		if(Less_IntInt(i, MoveGroups[Ctrl.MoveGroup].CtrlGroup.Length))
		{
			if(EqualEqual_ObjectObject(MoveGroups[Ctrl.MoveGroup].CtrlGroup[i], Ctrl))
			{
				MoveGroups[Ctrl.MoveGroup].CtrlGroup.Remove(i, 1);
				// [Explicit Break]
				goto J0x95;
			}
			AddAdd_Int(i);
			// [Loop Continue]
			goto J0x1B;
		}
		J0x95:

		if(EqualEqual_IntInt(Ctrl.MoveGroup, Group))
		{
			Ctrl.MoveGroup = -1;
			return;
		}
	}
	MoveGroups[Group].CtrlGroup[MoveGroups[Group].CtrlGroup.Length] = Ctrl;
	Ctrl.MoveGroup = Group;
	return;
}

event KillControlGroup(int Group)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, MoveGroups[Group].CtrlGroup.Length))
	{
		MoveGroups[Group].CtrlGroup[i].MoveGroup = -1;
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	MoveGroups[Group].CtrlGroup.Remove(0, MoveGroups[Group].CtrlGroup.Length);
	return;
}

event MoveControlGroup(int fromGroup, int toGroup)
{
	J0x00:
	if(Greater_IntInt(MoveGroups[fromGroup].CtrlGroup.Length, 0))
	{
		GroupControl(MoveGroups[fromGroup].CtrlGroup[0], toGroup);
		// [Loop Continue]
		goto J0x00;
	}
	return;
}

event AlignControlsInGroup(GUIComponent Ctrl, GUIController.eComponentAlign Align)
{
	local int i;
	local export editinline GUIComponent ChangeCtrl;

	if(OrOr_BoolBool(EqualEqual_ObjectObject(Ctrl, none), Less_IntInt(Ctrl.MoveGroup, 0)))
	{
		return;
	}
	i = 0;
	J0x2A:

	if(Less_IntInt(i, MoveGroups[Ctrl.MoveGroup].CtrlGroup.Length))
	{
		ChangeCtrl = MoveGroups[Ctrl.MoveGroup].CtrlGroup[i];
		switch(Align)
		{
			case 0:
				ChangeCtrl.WinLeft = Ctrl.WinLeft;
				break;
			case 2:
				ChangeCtrl.WinTop = Ctrl.WinTop;
				break;
			case 1:
				ChangeCtrl.WinLeft = Subtract_FloatFloat(Add_FloatFloat(Ctrl.WinLeft, Ctrl.WinWidth), ChangeCtrl.WinWidth);
				break;
			case 3:
				ChangeCtrl.WinTop = Subtract_FloatFloat(Add_FloatFloat(Ctrl.WinTop, Ctrl.WinHeight), ChangeCtrl.WinHeight);
				break;
			default:
				break;
		}
		UpdateControl(ChangeCtrl, false);
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x2A;
	}
	return;
}

event SizeControlsInGroup(GUIComponent Ctrl, GUIController.eComponentSize Size)
{
	local int i;
	local export editinline GUIComponent ChangeCtrl;

	if(OrOr_BoolBool(EqualEqual_ObjectObject(Ctrl, none), Less_IntInt(Ctrl.MoveGroup, 0)))
	{
		return;
	}
	i = 0;
	J0x2A:

	if(Less_IntInt(i, MoveGroups[Ctrl.MoveGroup].CtrlGroup.Length))
	{
		ChangeCtrl = MoveGroups[Ctrl.MoveGroup].CtrlGroup[i];
		switch(Size)
		{
			case 0:
				ChangeCtrl.WinWidth = Ctrl.WinWidth;
				break;
			case 1:
				ChangeCtrl.WinHeight = Ctrl.WinHeight;
				break;
			default:
				break;
		}
		UpdateControl(ChangeCtrl, true);
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x2A;
	}
	return;
}

event SpaceControlsInGroup(GUIComponent Ctrl, bool bVertical)
{
	local int i, j;
	local export editinline GUIComponent ChangeCtrl;
	local array<export editinline GUIComponent> OrderedCtrls;

	if(OrOr_BoolBool(OrOr_BoolBool(EqualEqual_ObjectObject(Ctrl, none), Less_IntInt(Ctrl.MoveGroup, 0)), LessEqual_IntInt(MoveGroups[Ctrl.MoveGroup].CtrlGroup.Length, 2)))
	{
		return;
	}
	i = 0;
	J0x4D:

	if(Less_IntInt(i, MoveGroups[Ctrl.MoveGroup].CtrlGroup.Length))
	{
		ChangeCtrl = MoveGroups[Ctrl.MoveGroup].CtrlGroup[i];
		if(NotEqual_BoolBool(ChangeCtrl.bScaled, Ctrl.bScaled))
		{
			// [Explicit Continue]
			goto J0x165;
		}
		j = 0;
		J0xC3:

		if(Less_IntInt(j, OrderedCtrls.Length))
		{
			if(OrOr_BoolBool(AndAnd_BoolBool(bVertical, Less_FloatFloat(ChangeCtrl.WinTop, OrderedCtrls[j].WinTop)), AndAnd_BoolBool(Not_PreBool(bVertical), Less_FloatFloat(ChangeCtrl.WinLeft, OrderedCtrls[j].WinLeft))))
			{
				// [Explicit Break]
				goto J0x148;
			}
			AddAdd_Int(j);
			// [Loop Continue]
			goto J0xC3;
		}
		J0x148:

		OrderedCtrls.Insert(j, 1);
		OrderedCtrls[j] = ChangeCtrl;
		J0x165:

		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x4D;
	}
	if(LessEqual_IntInt(OrderedCtrls.Length, 2))
	{
		return;
	}
	i = 0;
	J0x185:

	if(Less_IntInt(i, OrderedCtrls.Length))
	{
		ChangeCtrl = OrderedCtrls[i];
		if(bVertical)
		{
			ChangeCtrl.WinTop = Add_FloatFloat(Multiply_FloatFloat(Divide_FloatFloat(float(i), float(Subtract_IntInt(OrderedCtrls.Length, 1))), Subtract_FloatFloat(OrderedCtrls[Subtract_IntInt(OrderedCtrls.Length, 1)].WinTop, OrderedCtrls[0].WinTop)), OrderedCtrls[0].WinTop);
		}
		else
		{
			ChangeCtrl.WinLeft = Add_FloatFloat(Multiply_FloatFloat(Divide_FloatFloat(float(i), float(Subtract_IntInt(OrderedCtrls.Length, 1))), Subtract_FloatFloat(OrderedCtrls[Subtract_IntInt(OrderedCtrls.Length, 1)].WinLeft, OrderedCtrls[0].WinLeft)), OrderedCtrls[0].WinLeft);
		}
		UpdateControl(ChangeCtrl, true);
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x185;
	}
	return;
}

event SelectNextControlInMoveGroup()
{
	local int i;

	if(OrOr_BoolBool(EqualEqual_ObjectObject(MoveControl, none), Less_IntInt(MoveControl.MoveGroup, 0)))
	{
		return;
	}
	i = 0;
	J0x2A:

	if(Less_IntInt(i, MoveGroups[MoveControl.MoveGroup].CtrlGroup.Length))
	{
		if(EqualEqual_ObjectObject(MoveControl, MoveGroups[MoveControl.MoveGroup].CtrlGroup[i]))
		{
			if(GreaterEqual_IntInt(Add_IntInt(i, 1), MoveGroups[MoveControl.MoveGroup].CtrlGroup.Length))
			{
				MoveControl = MoveGroups[MoveControl.MoveGroup].CtrlGroup[0];
			}
			else
			{
				MoveControl = MoveGroups[MoveControl.MoveGroup].CtrlGroup[Add_IntInt(i, 1)];
			}
			return;
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x2A;
	}
	return;
}

event MoveFocused(GUIComponent Ctrl, int bmLeft, int bmTop, int bmWidth, int bmHeight, float ClipX, float ClipY, optional bool bMoveGroup)
{
	local float val;
	local bool bResized;
	local int i;

	if(AndAnd_BoolBool(bMoveGroup, GreaterEqual_IntInt(Ctrl.MoveGroup, 0)))
	{
		i = 0;
		J0x26:

		if(Less_IntInt(i, MoveGroups[Ctrl.MoveGroup].CtrlGroup.Length))
		{
			MoveFocused(MoveGroups[Ctrl.MoveGroup].CtrlGroup[i], bmLeft, bmTop, bmWidth, bmHeight, ClipX, ClipY, false);
			AddAdd_Int(i);
			// [Loop Continue]
			goto J0x26;
		}
		return;
	}
	val = 1.0000000;
	if(NotEqual_IntInt(bmLeft, 0))
	{
		if(Ctrl.bScaled)
		{
			Ctrl.WinLeft = Add_FloatFloat(Ctrl.WinLeft, Multiply_FloatFloat(Divide_FloatFloat(val, ClipX), float(bmLeft)));
		}
		else
		{
			AddEqual_FloatFloat(Ctrl.WinLeft, Multiply_FloatFloat(val, float(bmLeft)));
		}
	}
	if(NotEqual_IntInt(bmTop, 0))
	{
		if(Ctrl.bScaled)
		{
			Ctrl.WinTop = Add_FloatFloat(Ctrl.WinTop, Multiply_FloatFloat(Divide_FloatFloat(val, ClipY), float(bmTop)));
		}
		else
		{
			AddEqual_FloatFloat(Ctrl.WinTop, Multiply_FloatFloat(val, float(bmTop)));
		}
	}
	if(NotEqual_IntInt(bmWidth, 0))
	{
		if(Ctrl.bScaled)
		{
			Ctrl.WinWidth = Add_FloatFloat(Ctrl.WinWidth, Multiply_FloatFloat(Divide_FloatFloat(val, ClipX), float(bmWidth)));
		}
		else
		{
			AddEqual_FloatFloat(Ctrl.WinWidth, Multiply_FloatFloat(val, float(bmWidth)));
		}
		bResized = true;
	}
	if(NotEqual_IntInt(bmHeight, 0))
	{
		if(Ctrl.bScaled)
		{
			Ctrl.WinHeight = Add_FloatFloat(Ctrl.WinHeight, Multiply_FloatFloat(Divide_FloatFloat(val, ClipX), float(bmHeight)));
		}
		else
		{
			AddEqual_FloatFloat(Ctrl.WinHeight, Multiply_FloatFloat(val, float(bmHeight)));
		}
		bResized = true;
	}
	if(Not_PreBool(bMousePositioning))
	{
		UpdateControl(Ctrl, bResized);
	}
	return;
}

event UpdateControl(GUIComponent Ctrl, bool bResized)
{
	if(bSnapToGrid)
	{
		SnapToGrid(Ctrl, bResized);
	}
	Ctrl.OnChangeLayout();
	return;
}

event GetGuiResolution()
{
	local string CurrentRes;
	local int i;

	CurrentRes = ViewportOwner.Actor.ConsoleCommand("GETCURRENTRES");
	i = InStr(CurrentRes, "x");
	if(Greater_IntInt(i, 0))
	{
		ResolutionX = int(Left(CurrentRes, i));
		ResolutionY = int(Mid(CurrentRes, Add_IntInt(i, 1)));
	}
	Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[dkaplan] GetGuiResolution, CurrentRes = ", CurrentRes), ", ResolutionX = "), string(ResolutionX)), ", ResolutionY = "), string(ResolutionY)));
	return;
}

event OnResolutionChanged(int OldResolutionX, int OldResolutionY, int NewResolutionX, int NewResolutionY)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, InterestedResolutionChanged.Length))
	{
		InterestedResolutionChanged[i].OnResolutionChanged(OldResolutionX, OldResolutionY, ResolutionX, ResolutionY);
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	bForceUpdate = true;
	return;
}

function RegisterNotifyResolutionChanged(GUIComponent Component)
{
	AssertWithDescription(Not_PreBool(ComponentIsRegisteredForResolutionChanged(Component)), Concat_StrStr(Concat_StrStr("[tcohen] ", string(Component)), " is registering for notification that the resolution changed.  But it is already registered for that notification."));
	InterestedResolutionChanged[InterestedResolutionChanged.Length] = Component;
	return;
}

function bool ComponentIsRegisteredForResolutionChanged(GUIComponent Component)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, InterestedResolutionChanged.Length))
	{
		if(EqualEqual_ObjectObject(InterestedResolutionChanged[i], Component))
		{
			return true;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return false;
	return;
}

function UnRegisterNotifyResolutionChanged(GUIComponent Component)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, InterestedResolutionChanged.Length))
	{
		if(EqualEqual_ObjectObject(InterestedResolutionChanged[i], Component))
		{
			InterestedResolutionChanged.Remove(i, 1);
			return;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

function SetGuiResolution()
{
	ViewportOwner.Actor.ConsoleCommand(Concat_StrStr(Concat_StrStr(At_StrStr("SETRES", string(ResolutionX)), "x"), string(ResolutionY)));
	return;
}

function ScaleToResolution(GUIComponent Ctrl, optional bool bPropagate)
{
	DoScalingOnComponent(Ctrl, false, bPropagate);
	return;
}

function ResolutionToScale(GUIComponent Ctrl, optional bool bPropagate)
{
	DoScalingOnComponent(Ctrl, true, bPropagate);
	return;
}

private function DoScalingOnComponent(GUIComponent Ctrl, bool bScaleIt, optional bool bPropagate)
{
	local int i;

	if(AndAnd_BoolBool(Not_PreBool(bScaleIt), Ctrl.bScaled))
	{
		MultiplyEqual_FloatFloat(Ctrl.WinLeft, float(ResolutionX));
		MultiplyEqual_FloatFloat(Ctrl.WinWidth, float(ResolutionX));
		MultiplyEqual_FloatFloat(Ctrl.WinTop, float(ResolutionY));
		MultiplyEqual_FloatFloat(Ctrl.WinHeight, float(ResolutionY));
	}
	else
	{
		if(AndAnd_BoolBool(bScaleIt, Not_PreBool(Ctrl.bScaled)))
		{
			DivideEqual_FloatFloat(Ctrl.WinLeft, float(ResolutionX));
			DivideEqual_FloatFloat(Ctrl.WinWidth, float(ResolutionX));
			DivideEqual_FloatFloat(Ctrl.WinTop, float(ResolutionY));
			DivideEqual_FloatFloat(Ctrl.WinHeight, float(ResolutionY));
		}
	}
	Ctrl.bScaled = bScaleIt;
	if(AndAnd_BoolBool(bPropagate, NotEqual_ObjectObject(GUIMultiComponent(Ctrl), none)))
	{
		i = 0;
		J0x131:

		if(Less_IntInt(i, GUIMultiComponent(Ctrl).Controls.Length))
		{
			DoScalingOnComponent(GUIMultiComponent(Ctrl).Controls[i], bScaleIt, true);
			AddAdd_Int(i);
			// [Loop Continue]
			goto J0x131;
		}
	}
	return;
}

event ToggleSnapToGrid()
{
	bSnapToGrid = Not_PreBool(bSnapToGrid);
	return;
}

function SnapToGrid(GUIComponent Ctrl, bool bResized)
{
	local int i;
	local bool bWasScaled;

	bWasScaled = Ctrl.bScaled;
	if(bWasScaled)
	{
		ScaleToResolution(Ctrl);
	}
	if(Not_PreBool(bResized))
	{
		i = Multiply_IntInt(int(Divide_FloatFloat(Ctrl.WinTop, float(GridSize))), GridSize);
		if(Greater_FloatFloat(Subtract_FloatFloat(Ctrl.WinTop, float(i)), Divide_FloatFloat(float(GridSize), 2.0000000)))
		{
			Ctrl.WinTop = float(Add_IntInt(i, GridSize));
		}
		else
		{
			Ctrl.WinTop = float(i);
		}
		i = Multiply_IntInt(int(Divide_FloatFloat(Ctrl.WinLeft, float(GridSize))), GridSize);
		if(Greater_FloatFloat(Subtract_FloatFloat(Ctrl.WinLeft, float(i)), Divide_FloatFloat(float(GridSize), 2.0000000)))
		{
			Ctrl.WinLeft = float(Add_IntInt(i, GridSize));
		}
		else
		{
			Ctrl.WinLeft = float(i);
		}
	}
	else
	{
		i = Multiply_IntInt(int(Divide_FloatFloat(Ctrl.WinHeight, float(GridSize))), GridSize);
		if(GreaterEqual_FloatFloat(Subtract_FloatFloat(Ctrl.WinHeight, float(i)), Divide_FloatFloat(float(GridSize), 2.0000000)))
		{
			Ctrl.WinHeight = float(Add_IntInt(i, GridSize));
		}
		else
		{
			Ctrl.WinHeight = float(i);
		}
		i = Multiply_IntInt(int(Divide_FloatFloat(Ctrl.WinWidth, float(GridSize))), GridSize);
		if(GreaterEqual_FloatFloat(Subtract_FloatFloat(Ctrl.WinWidth, float(i)), Divide_FloatFloat(float(GridSize), 2.0000000)))
		{
			Ctrl.WinWidth = float(Add_IntInt(i, GridSize));
		}
		else
		{
			Ctrl.WinWidth = float(i);
		}
	}
	if(bWasScaled)
	{
		ResolutionToScale(Ctrl);
	}
	return;
}

event ToggleActiveComponentSizing(GUIComponent Ctrl, optional bool bPropagate, optional bool bMoveGroup)
{
	local int i;

	if(AndAnd_BoolBool(bMoveGroup, GreaterEqual_IntInt(Ctrl.MoveGroup, 0)))
	{
		i = 0;
		J0x26:

		if(Less_IntInt(i, MoveGroups[Ctrl.MoveGroup].CtrlGroup.Length))
		{
			ToggleActiveComponentSizing(MoveGroups[Ctrl.MoveGroup].CtrlGroup[i], bPropagate);
			AddAdd_Int(i);
			// [Loop Continue]
			goto J0x26;
		}
		return;
	}
	if(NotEqual_ObjectObject(Ctrl, none))
	{
		if(Ctrl.bScaled)
		{
			ScaleToResolution(Ctrl, bPropagate);
		}
		else
		{
			ResolutionToScale(Ctrl, bPropagate);
		}
	}
	return;
}

event SaveActiveComponent(GUIComponent Ctrl, optional bool bMoveGroup)
{
	local int i;

	if(AndAnd_BoolBool(bMoveGroup, GreaterEqual_IntInt(Ctrl.MoveGroup, 0)))
	{
		i = 0;
		J0x26:

		if(Less_IntInt(i, MoveGroups[Ctrl.MoveGroup].CtrlGroup.Length))
		{
			SaveActiveComponent(MoveGroups[Ctrl.MoveGroup].CtrlGroup[i]);
			AddAdd_Int(i);
			// [Loop Continue]
			goto J0x26;
		}
		return;
	}
	if(NotEqual_ObjectObject(Ctrl, none))
	{
		SaveComponent(Ctrl);
	}
	return;
}

function SaveComponent(GUIComponent Ctrl)
{
	Ctrl.SaveLayout(true);
	return;
}

function ChangeActiveStyle(string NewStyle)
{
	if(NotEqual_ObjectObject(MoveControl, none))
	{
		MoveControl.ChangeStyle(NewStyle);
	}
	return;
}

function ChangeGridSize(int newSize)
{
	GridSize = newSize;
	return;
}

function ChangeResolutionX(int newSize)
{
	ResolutionX = newSize;
	return;
}

function ChangeResolutionY(int newSize)
{
	ResolutionY = newSize;
	return;
}

event UndoActiveComponent(GUIComponent Ctrl, optional bool bMoveGroup)
{
	local int i;

	if(AndAnd_BoolBool(bMoveGroup, GreaterEqual_IntInt(Ctrl.MoveGroup, 0)))
	{
		i = 0;
		J0x26:

		if(Less_IntInt(i, MoveGroups[Ctrl.MoveGroup].CtrlGroup.Length))
		{
			UndoActiveComponent(MoveGroups[Ctrl.MoveGroup].CtrlGroup[i]);
			AddAdd_Int(i);
			// [Loop Continue]
			goto J0x26;
		}
		return;
	}
	if(NotEqual_ObjectObject(Ctrl, none))
	{
		Ctrl.UndoLayout();
	}
	return;
}

event RedoActiveComponent(GUIComponent Ctrl, optional bool bMoveGroup)
{
	local int i;

	if(AndAnd_BoolBool(bMoveGroup, GreaterEqual_IntInt(Ctrl.MoveGroup, 0)))
	{
		i = 0;
		J0x26:

		if(Less_IntInt(i, MoveGroups[Ctrl.MoveGroup].CtrlGroup.Length))
		{
			RedoActiveComponent(MoveGroups[Ctrl.MoveGroup].CtrlGroup[i]);
			AddAdd_Int(i);
			// [Loop Continue]
			goto J0x26;
		}
		return;
	}
	if(NotEqual_ObjectObject(Ctrl, none))
	{
		Ctrl.RedoLayout();
	}
	return;
}

function CenterOfControl(GUIComponent Ctrl, out float Left, out float Top)
{
	Left = Add_FloatFloat(Ctrl.WinLeft, Divide_FloatFloat(Ctrl.WinWidth, float(2)));
	Top = Add_FloatFloat(Ctrl.WinTop, Divide_FloatFloat(Ctrl.WinHeight, float(2)));
	if(Ctrl.bScaled)
	{
		MultiplyEqual_FloatFloat(Left, float(ResolutionX));
		MultiplyEqual_FloatFloat(Top, float(ResolutionY));
	}
	return;
}

function SizeOfControl(GUIComponent Ctrl, out float Size)
{
	local float sizedW, sizedH;

	if(Ctrl.bScaled)
	{
		sizedW = Ctrl.WinWidth;
		sizedH = Ctrl.WinHeight;
	}
	else
	{
		sizedW = Divide_FloatFloat(Ctrl.WinWidth, float(ResolutionX));
		sizedH = Divide_FloatFloat(Ctrl.WinHeight, float(ResolutionY));
	}
	Size = Sqrt(Multiply_FloatFloat(sizedW, sizedH));
	return;
}

function bool HasMouseMoved()
{
	if(AndAnd_BoolBool(EqualEqual_FloatFloat(MouseX, LastMouseX), EqualEqual_FloatFloat(MouseY, LastMouseY)))
	{
		return false;
	}
	else
	{
		return true;
	}
	return;
}

event NotifyLevelChange()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, MenuStack.Length))
	{
		MenuStack[i].NotifyLevelChange();
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

// Export UGUIController::execRemoveMenu(FFrame&, void* const)
native function RemoveMenu(string MenuName);

event LogGUI()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, PersistentStack.Length))
	{
		if(NotEqual_ObjectObject(GUIPage(PersistentStack[i]), none))
		{
			LogGUIPage(GUIPage(PersistentStack[i]));
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

event LogGUIPage(GUIPage Page)
{
	Log("LogGui: ***************************************************************");
	Log(At_StrStr("LogGui: Logging GUI for", string(Page.Name)));
	Log("LogGui: ");
	LogGUIComponent(Page);
	return;
}

event LogGUIComponent(GUIComponent Ctrl, optional int Level)
{
	local int i;
	local export editinline GUIMultiComponent MC;
	local string msg;

	msg = "LogGui: ";
	i = 0;
	J0x17:

	if(Less_IntInt(i, Level))
	{
		msg = Concat_StrStr(msg, "    ");
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x17;
	}
	msg = Concat_StrStr(Concat_StrStr(msg, " -> "), string(Ctrl.Name));
	Log(msg);
	MC = GUIMultiComponent(Ctrl);
	if(NotEqual_ObjectObject(MC, none))
	{
		i = 0;
		J0x91:

		if(Less_IntInt(i, MC.Controls.Length))
		{
			LogGUIComponent(MC.Controls[i], Add_IntInt(Level, 1));
			AddAdd_Int(i);
			// [Loop Continue]
			goto J0x91;
		}
	}
	return;
}

exec function LoadLocalizedPerObjectConfig()
{
	local Object NewObj;
	local int i;
	local Class<ContentDumper> dumper;
	local Class NewClass;

	Log("[carlos] LoadLocalizedPerObjectConfig()");
	dumper = Class<ContentDumper>(DynamicLoadObject("SwatGui.ContentDumper", Class'Core.Class'));
	Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("[carlos] Dumping Content... dumper = ", string(dumper)), ", dumper.default.ClassName.Length= "), string(dumper.default.ClassName.Length)));
	i = 0;
	J0xCB:

	if(Less_IntInt(i, dumper.default.ClassName.Length))
	{
		NewClass = Class<Object>(DynamicLoadObject(dumper.default.ClassName[i], Class'Core.Class'));
		NewObj = NewClass.static.Allocate(self, none, dumper.default.ObjName[i]).;
		Construct_Void();
		if(EqualEqual_ObjectObject(NewObj, none))
		{
			Log(At_StrStr("  Could not load", dumper.default.ObjName[i]));
			// [Explicit Continue]
			goto J0x1BF;
		}
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("Loaded object ", dumper.default.ClassName[i]), "."), dumper.default.ObjName[i]));
		J0x1BF:

		AddAdd_Int(i);
		// [Loop Continue]
		goto J0xCB;
	}
	LoadLocalizedPerObjectConfigGUI();
	return;
}

exec function LoadLocalizedPerObjectConfigGUI()
{
	local export editinline GUIComponent NewMenu;
	local int i;
	local Class<GUIDumper> loader;

	Log("[dkaplan] Loading GUI");
	loader = Class<GUIDumper>(DynamicLoadObject("SwatGui.GUIDumper", Class'Core.Class'));
	Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("[dkaplan] Loading GUI... loader = ", string(loader)), ", loader.default.ClassName.Length= "), string(loader.default.ClassName.Length)));
	i = 0;
	J0xB2:

	if(Less_IntInt(i, loader.default.ClassName.Length))
	{
		NewMenu = CreateComponent(loader.default.ClassName[i], loader.default.ObjName[i]);
		if(EqualEqual_ObjectObject(NewMenu, none))
		{
			Log(At_StrStr("  Could not load", loader.default.ObjName[i]));
			// [Explicit Continue]
			goto J0x181;
		}
		if(Not_PreBool(NewMenu.bInited))
		{
			NewMenu.InitComponent(none);
		}
		Log(Concat_StrStr("Loaded Menu ", loader.default.ObjName[i]));
		J0x181:

		AddAdd_Int(i);
		// [Loop Continue]
		goto J0xB2;
	}
	return;
}

// Export UGUIController::execPaintProgress(FFrame&, void* const)
native function PaintProgress();

// Export UGUIController::execCanLaunchDedicatedServer(FFrame&, void* const)
native function bool CanLaunchDedicatedServer();

// Export UGUIController::execLaunchDedicatedServer(FFrame&, void* const)
native function LaunchDedicatedServer();

// Export UGUIController::execStaticExec(FFrame&, void* const)
native function StaticExec(string ExecCmd);

defaultproperties
{
	bDontDisplayHelpText=true
	GridSize=2
	ResolutionX=720
	ResolutionY=540
	GUI_TO_WORLD_X=160.0000000
	GUI_TO_WORLD_Y=125.0000000
	ControllerMask=255
	DblClickWindow=0.5000000
	ButtonRepeatDelay=0.2500000
	CursorStep=1
	FastCursorStep=1
	bHighlightCurrent=true
	bShowGUIMembers=true
	MenuMouseSens=1.0000000
	JoyDeadZone=0.3000000
	WhiteBorder=Texture'gui_tex.Border'
	PleaseWaitString="Please Wait ..."
}