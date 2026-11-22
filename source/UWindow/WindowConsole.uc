class WindowConsole extends Console
	config;

const MaxLines = 64;
const TextMsgSize = 128;

var Viewport Viewport;
var int Scrollback;
var int numLines;
var int TopLine;
var int TextLines;
var float MsgTime;
var float MsgTickTime;
var string MsgText[64];
var float MsgTick[64];
var int ConsoleLines;
var float ConsolePos;
var float ConsoleDest;
var bool bNoStuff;
var bool bTyping;
var bool bNoDrawWorld;
var UWindowRootWindow Root;
var config string RootWindow;
var float OldClipX;
var float OldClipY;
var bool bCreatedRoot;
var float MouseX;
var float MouseY;
var Class<UWindowConsoleWindow> ConsoleClass;
var config float MouseScale;
var config bool ShowDesktop;
var config bool bShowConsole;
var bool bBlackout;
var bool bUWindowType;
var bool bUWindowActive;
var bool bQuickKeyEnable;
var bool bLocked;
var bool bLevelChange;
var string OldLevel;
var config Interactions.EInputKey UWindowKey;
var UWindowConsoleWindow ConsoleWindow;

function ResetUWindow()
{
	if(NotEqual_ObjectObject(Root, none))
	{
		Root.Close();
	}
	Root = none;
	bCreatedRoot = false;
	ConsoleWindow = none;
	bShowConsole = false;
	CloseUWindow();
	return;
}

function bool KeyEvent(Interactions.EInputKey Key, Interactions.EInputAction Action, float Delta)
{
	local byte k;

	k = Key;
	switch(Action)
	{
		case 1:
			switch(k)
			{
				case 19:
					if(bLocked)
					{
						return true;
					}
					bQuickKeyEnable = false;
					LaunchUWindow();
					return true;
				case ConsoleKey:
					if(bLocked)
					{
						return true;
					}
					bQuickKeyEnable = true;
					LaunchUWindow();
					if(Not_PreBool(bShowConsole))
					{
						ShowConsole();
					}
					return true;
				default:
					break;
					break;
			}
		default:
			return false;
			break;
	}
	return;
}

function ShowConsole()
{
	bShowConsole = true;
	if(bCreatedRoot)
	{
		ConsoleWindow.ShowWindow();
	}
	return;
}

function HideConsole()
{
	ConsoleLines = 0;
	bShowConsole = false;
	if(NotEqual_ObjectObject(ConsoleWindow, none))
	{
		ConsoleWindow.HideWindow();
	}
	return;
}

event Tick(float Delta)
{
	super(Interaction).Tick(Delta);
	if(AndAnd_BoolBool(AndAnd_BoolBool(bLevelChange, NotEqual_ObjectObject(Root, none)), NotEqual_StrStr(string(Viewport.Actor.Level), OldLevel)))
	{
		OldLevel = string(Viewport.Actor.Level);
		if(NotEqual_ObjectObject(Viewport.Actor.Level, Viewport.Actor.GetEntryLevel()))
		{
			bLevelChange = false;
		}
		Root.NotifyAfterLevelChange();
	}
	return;
}

function ToggleUWindow()
{
	return;
}

function LaunchUWindow()
{
	Viewport.bSuspendPrecaching = true;
	bUWindowActive = Not_PreBool(bQuickKeyEnable);
	Viewport.bShowWindowsMouse = true;
	if(bQuickKeyEnable)
	{
		bNoDrawWorld = false;
	}
	else
	{
		if(EqualEqual_IntInt(int(Viewport.Actor.Level.NetMode), int(NM_Standalone)))
		{
			Viewport.Actor.SetPause(true);
		}
		bNoDrawWorld = ShowDesktop;
	}
	if(NotEqual_ObjectObject(Root, none))
	{
		Root.bWindowVisible = true;
	}
	GotoState('UWindow');
	return;
}

function CloseUWindow()
{
	if(Not_PreBool(bQuickKeyEnable))
	{
		Viewport.Actor.SetPause(false);
	}
	bNoDrawWorld = false;
	bQuickKeyEnable = false;
	bUWindowActive = false;
	Viewport.bShowWindowsMouse = false;
	if(NotEqual_ObjectObject(Root, none))
	{
		Root.bWindowVisible = false;
	}
	GotoState('None');
	Viewport.bSuspendPrecaching = false;
	return;
}

function CreateRootWindow(Canvas Canvas)
{
	local int i;

	if(NotEqual_ObjectObject(Canvas, none))
	{
		OldClipX = Canvas.ClipX;
		OldClipY = Canvas.ClipY;
	}
	else
	{
		OldClipX = 0.0000000;
		OldClipY = 0.0000000;
	}
	Log(Concat_StrStr("Creating root window: ", RootWindow));
	Root = Class<UWindowRootWindow>(static.DynamicLoadObject(RootWindow, Class'Core.Class')).Allocate(self, none).;
	Construct_Void();
	Root.BeginPlay();
	Root.WinTop = 0.0000000;
	Root.WinLeft = 0.0000000;
	if(NotEqual_ObjectObject(Canvas, none))
	{
		Root.WinWidth = Divide_FloatFloat(Canvas.ClipX, Root.GUIScale);
		Root.WinHeight = Divide_FloatFloat(Canvas.ClipY, Root.GUIScale);
		Root.RealWidth = Canvas.ClipX;
		Root.RealHeight = Canvas.ClipY;
	}
	else
	{
		Root.WinWidth = 0.0000000;
		Root.WinHeight = 0.0000000;
		Root.RealWidth = 0.0000000;
		Root.RealHeight = 0.0000000;
	}
	Root.ClippingRegion.X = 0;
	Root.ClippingRegion.Y = 0;
	Root.ClippingRegion.W = int(Root.WinWidth);
	Root.ClippingRegion.H = int(Root.WinHeight);
	Root.bUWindowActive = bUWindowActive;
	Root.Created();
	bCreatedRoot = true;
	ConsoleWindow = UWindowConsoleWindow(Root.CreateWindow(ConsoleClass, 100.0000000, 100.0000000, 200.0000000, 200.0000000));
	if(Not_PreBool(bShowConsole))
	{
		HideConsole();
	}
	UWindowConsoleClientWindow(ConsoleWindow.ClientArea).TextArea.AddText(" ");
	i = 0;
	J0x2DB:

	if(Less_IntInt(i, 4))
	{
		UWindowConsoleClientWindow(ConsoleWindow.ClientArea).TextArea.AddText(MsgText[i]);
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x2DB;
	}
	return;
}

function RenderUWindow(Canvas Canvas)
{
	local UWindowWindow NewFocusWindow;

	Canvas.bNoSmooth = true;
	Canvas.Z = 1.0000000;
	Canvas.Style = 1;
	Canvas.DrawColor.R = byte(255);
	Canvas.DrawColor.G = byte(255);
	Canvas.DrawColor.B = byte(255);
	if(AndAnd_BoolBool(Viewport.bWindowsMouseAvailable, NotEqual_ObjectObject(Root, none)))
	{
		MouseX = Divide_FloatFloat(Viewport.WindowsMouseX, Root.GUIScale);
		MouseY = Divide_FloatFloat(Viewport.WindowsMouseY, Root.GUIScale);
	}
	if(Not_PreBool(bCreatedRoot))
	{
		CreateRootWindow(Canvas);
	}
	Root.bWindowVisible = true;
	Root.bUWindowActive = bUWindowActive;
	Root.bQuickKeyEnable = bQuickKeyEnable;
	if(OrOr_BoolBool(NotEqual_FloatFloat(Canvas.ClipX, OldClipX), NotEqual_FloatFloat(Canvas.ClipY, OldClipY)))
	{
		OldClipX = Canvas.ClipX;
		OldClipY = Canvas.ClipY;
		Root.WinTop = 0.0000000;
		Root.WinLeft = 0.0000000;
		Root.WinWidth = Divide_FloatFloat(Canvas.ClipX, Root.GUIScale);
		Root.WinHeight = Divide_FloatFloat(Canvas.ClipY, Root.GUIScale);
		Root.RealWidth = Canvas.ClipX;
		Root.RealHeight = Canvas.ClipY;
		Root.ClippingRegion.X = 0;
		Root.ClippingRegion.Y = 0;
		Root.ClippingRegion.W = int(Root.WinWidth);
		Root.ClippingRegion.H = int(Root.WinHeight);
		Root.Resized();
	}
	if(Greater_FloatFloat(MouseX, Root.WinWidth))
	{
		MouseX = Root.WinWidth;
	}
	if(Greater_FloatFloat(MouseY, Root.WinHeight))
	{
		MouseY = Root.WinHeight;
	}
	if(Less_FloatFloat(MouseX, float(0)))
	{
		MouseX = 0.0000000;
	}
	if(Less_FloatFloat(MouseY, float(0)))
	{
		MouseY = 0.0000000;
	}
	NewFocusWindow = Root.CheckKeyFocusWindow();
	if(NotEqual_ObjectObject(NewFocusWindow, Root.KeyFocusWindow))
	{
		Root.KeyFocusWindow.KeyFocusExit();
		Root.KeyFocusWindow = NewFocusWindow;
		Root.KeyFocusWindow.KeyFocusEnter();
	}
	Root.MoveMouse(MouseX, MouseY);
	Root.WindowEvent(9, Canvas, MouseX, MouseY, 0);
	if(OrOr_BoolBool(bUWindowActive, bQuickKeyEnable))
	{
		Root.DrawMouse(Canvas);
	}
	return;
}

event Message(coerce string msg, float MsgLife)
{
	super.Message(msg, MsgLife);
	if(EqualEqual_ObjectObject(Viewport.Actor, none))
	{
		return;
	}
	if(AndAnd_BoolBool(NotEqual_StrStr(msg, ""), NotEqual_ObjectObject(ConsoleWindow, none)))
	{
		UWindowConsoleClientWindow(ConsoleWindow.ClientArea).TextArea.AddText(MsgText[TopLine]);
	}
	return;
}

function UpdateHistory()
{
	History[int(Percent_FloatFloat(float(AddAdd_Int(HistoryCur)), float(16)))] = TypedStr;
	if(Greater_IntInt(HistoryCur, HistoryBot))
	{
		AddAdd_Int(HistoryBot);
	}
	if(GreaterEqual_IntInt(Subtract_IntInt(HistoryCur, HistoryTop), 16))
	{
		HistoryTop = Add_IntInt(Subtract_IntInt(HistoryCur, 16), 1);
	}
	return;
}

function HistoryUp()
{
	if(Greater_IntInt(HistoryCur, HistoryTop))
	{
		History[int(Percent_FloatFloat(float(HistoryCur), float(16)))] = TypedStr;
		TypedStr = History[int(Percent_FloatFloat(float(SubtractSubtract_PreInt(HistoryCur)), float(16)))];
	}
	return;
}

function HistoryDown()
{
	History[int(Percent_FloatFloat(float(HistoryCur), float(16)))] = TypedStr;
	if(Less_IntInt(HistoryCur, HistoryBot))
	{
		TypedStr = History[int(Percent_FloatFloat(float(AddAdd_PreInt(HistoryCur)), float(16)))];
	}
	else
	{
		TypedStr = "";
	}
	return;
}

function NotifyLevelChange()
{
	bLevelChange = true;
	if(NotEqual_ObjectObject(Root, none))
	{
		Root.NotifyBeforeLevelChange();
	}
	return;
}

state UWindow
{
	event Tick(float Delta)
	{
		global.Tick(Delta);
		if(NotEqual_ObjectObject(Root, none))
		{
			Root.DoTick(Delta);
		}
		return;
	}

	function PostRender(Canvas Canvas)
	{
		if(NotEqual_ObjectObject(Root, none))
		{
			Root.bUWindowActive = true;
		}
		RenderUWindow(Canvas);
		return;
	}

	function bool KeyType(Interactions.EInputKey Key, optional string Unicode)
	{
		if(NotEqual_ObjectObject(Root, none))
		{
			Root.WindowEvent(8, none, MouseX, MouseY, int(Key));
		}
		return true;
		return;
	}

	function bool KeyEvent(Interactions.EInputKey Key, Interactions.EInputAction Action, float Delta)
	{
		local byte k;

		k = Key;
		switch(Action)
		{
			case 3:
				switch(k)
				{
					case 1:
						if(NotEqual_ObjectObject(Root, none))
						{
							Root.WindowEvent(1, none, MouseX, MouseY, int(k));
						}
						break;
					case 2:
						if(NotEqual_ObjectObject(Root, none))
						{
							Root.WindowEvent(5, none, MouseX, MouseY, int(k));
						}
						break;
					case 4:
						if(NotEqual_ObjectObject(Root, none))
						{
							Root.WindowEvent(3, none, MouseX, MouseY, int(k));
						}
						break;
					default:
						if(NotEqual_ObjectObject(Root, none))
						{
							Root.WindowEvent(6, none, MouseX, MouseY, int(k));
						}
						break;
						break;
				}
				goto J0x2DD;
			case 1:
				switch(k)
				{
					case 120:
						return global.KeyEvent(Key, Action, Delta);
						break;
					case ConsoleKey:
						if(bShowConsole)
						{
							HideConsole();
							if(bQuickKeyEnable)
							{
								CloseUWindow();
							}
						}
						else
						{
							if(Root.bAllowConsole)
							{
								ShowConsole();
							}
							else
							{
								Root.WindowEvent(7, none, MouseX, MouseY, int(k));
							}
						}
						break;
					case 27:
						if(NotEqual_ObjectObject(Root, none))
						{
							Root.CloseActiveWindow();
						}
						break;
					case 1:
						if(NotEqual_ObjectObject(Root, none))
						{
							Root.WindowEvent(0, none, MouseX, MouseY, int(k));
						}
						break;
					case 2:
						if(NotEqual_ObjectObject(Root, none))
						{
							Root.WindowEvent(4, none, MouseX, MouseY, int(k));
						}
						break;
					case 4:
						if(NotEqual_ObjectObject(Root, none))
						{
							Root.WindowEvent(2, none, MouseX, MouseY, int(k));
						}
						break;
					default:
						if(NotEqual_ObjectObject(Root, none))
						{
							Root.WindowEvent(7, none, MouseX, MouseY, int(k));
						}
						break;
						break;
				}
				goto J0x2DD;
			case 4:
				switch(Key)
				{
					case 228:
						MouseX = Add_FloatFloat(MouseX, Multiply_FloatFloat(MouseScale, Delta));
						break;
					case 229:
						MouseY = Subtract_FloatFloat(MouseY, Multiply_FloatFloat(MouseScale, Delta));
						break;
					default:
						break;
				}
			default:
				break;
				break;
		}
		J0x2DD:

		return true;
		return;
	}
Begin:

	stop;
}

defaultproperties
{
	RootWindow="UWindow.UWindowRootWindow"
	ConsoleClass=Class'UWindow.UWindowConsoleWindow'
	MouseScale=0.6000000
	ConsoleKey=192
}