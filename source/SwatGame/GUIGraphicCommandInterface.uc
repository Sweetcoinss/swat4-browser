class GUIGraphicCommandInterface extends GUIMultiComponent
	native
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object);

const MAX_COMMANDS_PER_PAGE = 12;

struct native ScreenLocation
{
	var private float X;
	var private float Y;
};

var GUIGraphicCommandInterfaceMenu MenuPages[7];
var Command CurrentCommand;
var private GraphicCommandInterface Logic;
var(GraphicCommandInterface) config float OpenCloseTime;
var(GraphicCommandInterface) config float MouseGestureTime "A break in mouse movement longer than this time is considered a new mouse gesture.";
var private float MouseSensitivity;
var private float LastMouseMoveTime;
var private float GestureDistanceX;
var private float GestureDistanceY;
var(GraphicCommandInterface) config float ScrollTime;
var(GraphicCommandInterface) config float MouseDistanceBetweenMenus "How far the mouse needs to move (horizontally, within a gesture) to select the sub/parent menu.";
var(GraphicCommandInterface) config float MouseDistanceBetweenMenuPads "How far the mouse needs to move (vertically, within a gesture) to select the next/previous menu pad.";
var(GraphicCommandInterface) config string RedTeamStyleName "The Syle to use when displaying a command menu for the RED team.";
var(GraphicCommandInterface) config string BlueTeamStyleName "The Syle to use when displaying a command menu for the BLUE team.";
var(GraphicCommandInterface) config string AsAnElementStyleName "The Syle to use when displaying a command menu for the entire ELEMENT.";
var(GraphicCommandInterface) config ScreenLocation MainPageCenterOffset;
var(DEBUG) bool bUseExitPad;
//var delegate<OnCapturedMouseMove> __OnCapturedMouseMove__Delegate;
//var delegate<OnKeyEvent> __OnKeyEvent__Delegate;

function OnConstruct(GUIController MyController)
{
	local int i, j;

	super.OnConstruct(MyController);
	bUseExitPad = SwatGUIControllerBase(Controller).GuiConfig.bUseExitMenu;
	i = 0;
	J0x36:

	if(Less_IntInt(i, int(7)))
	{
		MenuPages[i] = Class'SwatGame.GUIGraphicCommandInterfaceMenu'.static.Allocate(self, self, string(GetEnum(Enum'SwatGame.CommandInterface.CommandInterfacePage', i))).;
		Construct_Void();
		assert(NotEqual_ObjectObject(MenuPages[i], none));
		MenuPages[i].GCI = self;
		MenuPages[i].Page = byte(i);
		j = 0;
		J0xC8:

		if(Less_IntInt(j, 12))
		{
			MenuPages[i].MenuPads[j] = GUIGraphicCommandInterfaceMenuPad(AddComponent("SwatGame.GUIGraphicCommandInterfaceMenuPad", Concat_StrStr(Concat_StrStr(string(MenuPages[i].Name), "_MenuPad"), string(j))));
			AddAdd_PreInt(j);
			// [Loop Continue]
			goto J0xC8;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x36;
	}
	return;
}

function InitComponent(GUIComponent Owner)
{
	local int i, j;
	local export editinline GUIStyles InitialStyle;

	super.InitComponent(Owner);
	InitialStyle = Controller.GetStyle(AsAnElementStyleName);
	i = 0;
	J0x2C:

	if(Less_IntInt(i, int(7)))
	{
		j = 0;
		J0x41:

		if(Less_IntInt(j, 12))
		{
			MenuPages[i].MenuPads[j].Style = InitialStyle;
			MenuPages[i].MenuPads[j].bBoundToParent = false;
			MenuPages[i].MenuPads[j].bScaleToParent = false;
			MenuPages[i].MenuPads[j].bScaled = false;
			MenuPages[i].MenuPads[j].TextAlign = 0;
			AddAdd_PreInt(j);
			// [Loop Continue]
			goto J0x41;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x2C;
	}
	return;
}

function SetLogic(GraphicCommandInterface inLogic)
{
	local int i;

	Logic = inLogic;
	if(EqualEqual_ObjectObject(Logic, none))
	{
		return;
	}
	i = 0;
	J0x1F:

	if(Less_IntInt(i, int(7)))
	{
		if(AndAnd_BoolBool(NotEqual_ObjectObject(MenuPages[i], none), NotEqual_ObjectObject(Logic.MenuInfo[i], none)))
		{
			MenuPages[i].IsAMainMenu = EqualEqual_IntInt(int(Logic.MenuInfo[i].AnchorCommand), int(0));
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x1F;
	}
	return;
}

function GraphicCommandInterface GetLogic()
{
	return Logic;
	return;
}

function float CenteredPadY(float RawPadY)
{
	return Subtract_FloatFloat(RawPadY, Divide_FloatFloat(ActualHeight(), float(2)));
	return;
}

simulated function ClearAllCommands()
{
	local int i;

	i = 1;
	J0x07:

	if(Less_IntInt(i, int(7)))
	{
		MenuPages[i].ClearAllCommands();
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

simulated function ClearCommands(bool PageChange)
{
	local int i;
	local bool IsMP;

	IsMP = NotEqual_IntInt(int(Logic.Level.NetMode), int(NM_Standalone));
	i = 1;
	J0x2D:

	if(Less_IntInt(i, int(7)))
	{
		MenuPages[i].ClearCommands(PageChange);
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x2D;
	}
	return;
}

function OnCurrentTeamChanged(OfficerTeamInfo NewTeam)
{
	local export editinline GUIStyles NewStyle;
	local int i, j;

	if(EqualEqual_ObjectObject(Logic.CurrentCommandTeam, Logic.Element))
	{
		NewStyle = Controller.GetStyle(AsAnElementStyleName);
	}
	else
	{
		if(EqualEqual_ObjectObject(Logic.CurrentCommandTeam, Logic.RedTeam))
		{
			NewStyle = Controller.GetStyle(RedTeamStyleName);
		}
		else
		{
			if(EqualEqual_ObjectObject(Logic.CurrentCommandTeam, Logic.BlueTeam))
			{
				NewStyle = Controller.GetStyle(BlueTeamStyleName);
			}
			else
			{
				AssertWithDescription(false, "[tcohen] GUIGraphicCommandInterface::OnCurrentTeamChanged() Logic.CurrentCommandTeam isn't Red, Blue, or Element.");
			}
		}
	}
	i = 0;
	J0x13B:

	if(Less_IntInt(i, int(7)))
	{
		j = 0;
		J0x150:

		if(Less_IntInt(j, 12))
		{
			MenuPages[i].MenuPads[j].Style = NewStyle;
			Logic.SetCommandStatus(MenuPages[i].MenuPads[j].Command, true);
			MenuPages[i].MenuPads[j].OnUnselected();
			AddAdd_PreInt(j);
			// [Loop Continue]
			goto J0x150;
		}
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x13B;
	}
	if(NotEqual_ObjectObject(CurrentCommand, none))
	{
		MenuPages[int(CurrentCommand.Page)].MenuPads[CurrentCommand.GCIMenuPad].OnSelected();
	}
	return;
}

// Export UGUIGraphicCommandInterface::execSetCommand(FFrame&, void* const)
native function SetCommand(Command Command, CommandInterface.MenuPadStatus Status);

function SelectCommand(Command NewSelection, optional bool LateralMove)
{
	local export editinline GUIGraphicCommandInterfaceMenuPad Pad;

	if(EqualEqual_ObjectObject(NewSelection, none))
	{
		return;
	}
	if(NotEqual_ObjectObject(CurrentCommand, none))
	{
		Pad = MenuPages[int(CurrentCommand.Page)].MenuPads[CurrentCommand.GCIMenuPad];
		Pad.OnUnselected();
		if(AndAnd_BoolBool(NotEqual_IntInt(int(CurrentCommand.SubPage), int(0)), Not_PreBool(LateralMove)))
		{
			MenuPages[int(CurrentCommand.SubPage)].Close();
		}
	}
	CurrentCommand = NewSelection;
	Pad = MenuPages[int(CurrentCommand.Page)].MenuPads[CurrentCommand.GCIMenuPad];
	Pad.OnSelected();
	if(AndAnd_BoolBool(NotEqual_IntInt(int(CurrentCommand.SubPage), int(0)), Not_PreBool(LateralMove)))
	{
		MenuPages[int(CurrentCommand.SubPage)].Open();
	}
	return;
}

final function Open()
{
	GotoState('None');
	Show();
	MenuOwner.Activate();
	Activate();
	Focus();
	Press();
	Controller.ActiveControl = self;
	MenuPages[int(Logic.GetCurrentMainPage())].Open();
	if(SwatGUIControllerBase(Controller).GuiConfig.bUseExitMenu)
	{
		SelectCommand(MenuPages[int(Logic.GetCurrentMainPage())].MenuPads[0].Command);
	}
	else
	{
		SelectCommand(Logic.GetDefaultCommand());
	}
	return;
}

final function Close()
{
	local int i;
	local export editinline GUIGraphicCommandInterfaceMenuPad Pad;

	if(NotEqual_ObjectObject(CurrentCommand, none))
	{
		Pad = MenuPages[int(CurrentCommand.Page)].MenuPads[CurrentCommand.GCIMenuPad];
		Pad.OnUnselected();
	}
	CurrentCommand = none;
	i = 0;
	J0x5C:

	if(Less_IntInt(i, int(7)))
	{
		MenuPages[i].Close();
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x5C;
	}
	GotoState('Closing');
	return;
}

final function CloseInstantly()
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, int(7)))
	{
		MenuPages[i].CloseInstantly();
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

delegate bool OnCapturedMouseMove(float dx, float dy)
{
	local float Now, dTime;

	Now = Logic.Level.TimeSeconds;
	dTime = Subtract_FloatFloat(Now, LastMouseMoveTime);
	LastMouseMoveTime = Now;
	if(Greater_FloatFloat(dTime, MouseGestureTime))
	{
		GestureDistanceX = 0.0000000;
		GestureDistanceY = 0.0000000;
	}
	AddEqual_FloatFloat(GestureDistanceX, dx);
	AddEqual_FloatFloat(GestureDistanceY, dy);
	J0x77:

	if(GreaterEqual_FloatFloat(GestureDistanceX, MouseDistanceBetweenMenus))
	{
		OnMouseMovedRight();
		SubtractEqual_FloatFloat(GestureDistanceX, MouseDistanceBetweenMenus);
		// [Loop Continue]
		goto J0x77;
	}
	J0x9B:

	if(LessEqual_FloatFloat(GestureDistanceX, Subtract_PreFloat(MouseDistanceBetweenMenus)))
	{
		OnMouseMovedLeft();
		AddEqual_FloatFloat(GestureDistanceX, MouseDistanceBetweenMenus);
		// [Loop Continue]
		goto J0x9B;
	}
	J0xC1:

	if(GreaterEqual_FloatFloat(GestureDistanceY, MouseDistanceBetweenMenuPads))
	{
		OnMouseMovedUp();
		SubtractEqual_FloatFloat(GestureDistanceY, MouseDistanceBetweenMenuPads);
		// [Loop Continue]
		goto J0xC1;
	}
	J0xE5:

	if(LessEqual_FloatFloat(GestureDistanceY, Subtract_PreFloat(MouseDistanceBetweenMenuPads)))
	{
		OnMouseMovedDown();
		AddEqual_FloatFloat(GestureDistanceY, MouseDistanceBetweenMenuPads);
		// [Loop Continue]
		goto J0xE5;
	}
	return true;
	return;
}

delegate bool OnKeyEvent(out byte Key, out byte State, float Delta)
{
	if(KeyMatchesBinding(Key, "OpenGraphicCommandInterface | RightMouseAlias"))
	{
		if(EqualEqual_IntInt(int(State), int(1)))
		{
			return OnRightMousePressed();
		}
		if(EqualEqual_IntInt(int(State), int(3)))
		{
			return OnRightMouseReleased();
		}
	}
	if(KeyMatchesBinding(Key, "Fire"))
	{
		if(EqualEqual_IntInt(int(State), int(1)))
		{
			return OnLeftMousePressed();
		}
	}
	if(KeyMatchesBinding(Key, "CommandInterfaceNextGroup"))
	{
		if(EqualEqual_IntInt(int(State), int(1)))
		{
			return false;
		}
	}
	if(AndAnd_BoolBool(KeyMatchesBinding(Key, "ScrollCommand Up"), EqualEqual_IntInt(int(State), int(1))))
	{
		Scroll('Up');
	}
	if(AndAnd_BoolBool(KeyMatchesBinding(Key, "ScrollCommand Down"), EqualEqual_IntInt(int(State), int(1))))
	{
		Scroll('Down');
	}
	if(EqualEqual_IntInt(int(State), int(3)))
	{
		return false;
	}
	return true;
	return;
}

function bool OnRightMousePressed()
{
	local int ButtonMode;

	ButtonMode = SwatGUIControllerBase(Controller).GuiConfig.GCIButtonMode;
	switch(ButtonMode)
	{
		case 1:
		case 2:
			return false;
		case 3:
			Logic.Close();
			return true;
		case 4:
			GiveCommand();
			Logic.Close();
			return true;
		default:
			assert(false);
			return;
			break;
	}
}

function bool OnRightMouseReleased()
{
	local int ButtonMode;

	ButtonMode = SwatGUIControllerBase(Controller).GuiConfig.GCIButtonMode;
	switch(ButtonMode)
	{
		case 1:
			Logic.Close();
			return false;
		case 2:
			GiveCommand();
			Logic.Close();
			return true;
		case 3:
		case 4:
			return true;
		default:
			assert(false);
			return;
			break;
	}
}

function bool OnLeftMousePressed()
{
	local int ButtonMode;

	ButtonMode = SwatGUIControllerBase(Controller).GuiConfig.GCIButtonMode;
	switch(ButtonMode)
	{
		case 1:
			GiveCommand();
			Logic.Close();
			return true;
		case 2:
			Logic.Close();
			return true;
		case 3:
			GiveCommand();
			Logic.Close();
			return true;
		case 4:
			Logic.Close();
			return true;
		default:
			assert(false);
			return;
			break;
	}
}

function bool SelectCommandTeam()
{
	Logic.NextTeam();
	return true;
	return;
}

protected function OnMouseMovedUp()
{
	local Command NewCommand;

	if(EqualEqual_ObjectObject(CurrentCommand, none))
	{
		return;
	}
	NewCommand = MenuPages[int(CurrentCommand.Page)].GetNextCommandUp(CurrentCommand);
	if(NotEqual_ObjectObject(NewCommand, CurrentCommand))
	{
		SelectCommand(NewCommand);
		TriggerEffectEvent('SelectionChanged');
	}
	return;
}

protected function OnMouseMovedDown()
{
	local Command NewCommand;

	if(EqualEqual_ObjectObject(CurrentCommand, none))
	{
		return;
	}
	NewCommand = MenuPages[int(CurrentCommand.Page)].GetNextCommandDown(CurrentCommand);
	if(NotEqual_ObjectObject(NewCommand, CurrentCommand))
	{
		SelectCommand(NewCommand);
		TriggerEffectEvent('SelectionChanged');
	}
	return;
}

protected function OnMouseMovedRight()
{
	if(EqualEqual_ObjectObject(CurrentCommand, none))
	{
		return;
	}
	if(NotEqual_IntInt(int(CurrentCommand.SubPage), int(0)))
	{
		SelectCommand(MenuPages[int(CurrentCommand.SubPage)].GetTopCommand(), true);
		TriggerEffectEvent('MenuChanged');
	}
	return;
}

protected function OnMouseMovedLeft()
{
	if(EqualEqual_ObjectObject(CurrentCommand, none))
	{
		return;
	}
	if(NotEqual_IntInt(int(Logic.MenuInfo[int(CurrentCommand.Page)].AnchorCommand), int(0)))
	{
		SelectCommand(Logic.Commands[int(Logic.MenuInfo[int(CurrentCommand.Page)].AnchorCommand)], true);
		TriggerEffectEvent('MenuChanged');
	}
	return;
}

function Scroll(name UpOrDown)
{
	if(Not_PreBool(MenuOwner.bActiveInput))
	{
		return;
	}
	LastMouseMoveTime = Logic.Level.TimeSeconds;
	GestureDistanceX = 0.0000000;
	GestureDistanceY = 0.0000000;
	switch(UpOrDown)
	{
		case 'Up':
			OnMouseMovedUp();
			break;
		case 'Down':
			OnMouseMovedDown();
			break;
		default:
			AssertWithDescription(false, "[tcohen] GUIGraphicCommandInterface::Scroll() UpOrDown is not 'Up' or 'Down'.  Check keybindings.");
			break;
			break;
	}
	return;
}

protected function GiveCommand()
{
	if(EqualEqual_ObjectObject(CurrentCommand, none))
	{
		return;
	}
	Logic.GiveCommand(CurrentCommand);
	TriggerEffectEvent('GaveCommand');
	return;
}

function Command GetCommandRef(CommandInterface.ECommand Command)
{
	return Logic.Commands[int(Command)];
	return;
}

function Command GetDefaultCommand()
{
	return Logic.super(GUIGraphicCommandInterface).GetDefaultCommand();
	return;
}

final function string Pad(int Length, coerce string S)
{
	J0x00:
	if(Less_IntInt(Len(S), Length))
	{
		S = Concat_StrStr(S, " ");
		// [Loop Continue]
		goto J0x00;
	}
	return S;
	return;
}

event MousePressed()
{
	return;
}

event MouseReleased()
{
	return;
}

function TriggerEffectEvent(name EffectEvent)
{
	Logic.TriggerEffectEvent(EffectEvent);
	return;
}

state Closing
{Begin:

	Sleep(OpenCloseTime);
	Hide();
	MenuOwner.DeActivate();
	DeActivate();
	stop;
}

defaultproperties
{
	OpenCloseTime=0.2000000
	MouseGestureTime=0.5000000
	MouseSensitivity=1.0000000
	MouseDistanceBetweenMenus=10.0000000
	MouseDistanceBetweenMenuPads=8.0000000
	MainPageCenterOffset=(X=0.0250000,Y=0.0000000)
	PropagateVisibility=false
	PropagateState=false
	bCaptureMouse=true
	bPersistent=true
}