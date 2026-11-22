class UWindowRootWindow extends UWindowWindow
	config;

var UWindowWindow MouseWindow;
var bool bMouseCapture;
var float OldMouseX;
var float OldMouseY;
var UWindowWindow FocusedWindow;
var UWindowWindow KeyFocusWindow;
var MouseCursor NormalCursor;
var MouseCursor MoveCursor;
var MouseCursor DiagCursor1;
var MouseCursor HandCursor;
var MouseCursor HSplitCursor;
var MouseCursor VSplitCursor;
var MouseCursor DiagCursor2;
var MouseCursor NSCursor;
var MouseCursor WECursor;
var MouseCursor WaitCursor;
var bool bQuickKeyEnable;
var UWindowHotkeyWindowList HotkeyWindows;
var config float GUIScale;
var float RealWidth;
var float RealHeight;
var Font Fonts[10];
var UWindowLookAndFeel LooksAndFeels[20];
var config string LookAndFeelClass;
var bool bRequestQuit;
var float QuitTime;
var bool bAllowConsole;
var config float MouseScale;
var float MouseX;
var float MouseY;
var float OldClipX;
var float OldClipY;
var Class<UWindowConsoleWindow> ConsoleClass;
var UWindowConsoleWindow ConsoleWindow;

function BeginPlay()
{
	Root = self;
	MouseWindow = self;
	KeyFocusWindow = self;
	return;
}

function UWindowLookAndFeel GetLookAndFeel(string LFClassName)
{
	local int i;
	local Class<UWindowLookAndFeel> LFClass;

	LFClass = Class<UWindowLookAndFeel>(DynamicLoadObject(LFClassName, Class'Core.Class'));
	i = 0;
	J0x22:

	if(Less_IntInt(i, 20))
	{
		if(EqualEqual_ObjectObject(LooksAndFeels[i], none))
		{
			LooksAndFeels[i] = LFClass.static.Allocate(self).;
			Construct_Void();
			LooksAndFeels[i].Setup();
			return LooksAndFeels[i];
		}
		if(EqualEqual_ObjectObject(LooksAndFeels[i].Class, LFClass))
		{
			return LooksAndFeels[i];
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x22;
	}
	Log("Out of LookAndFeel array space!!");
	return none;
	return;
}

function Created()
{
	LookAndFeel = GetLookAndFeel(LookAndFeelClass);
	SetupFonts();
	NormalCursor.Tex = Texture'UWindow_res.Icons.MouseCursor';
	NormalCursor.HotX = 0;
	NormalCursor.HotY = 0;
	NormalCursor.WindowsCursor = ViewportOwner.0;
	MoveCursor.Tex = Texture'UWindow_res.Icons.MouseMove';
	MoveCursor.HotX = 8;
	MoveCursor.HotY = 8;
	MoveCursor.WindowsCursor = ViewportOwner.1;
	DiagCursor1.Tex = Texture'UWindow_res.Icons.MouseDiag1';
	DiagCursor1.HotX = 8;
	DiagCursor1.HotY = 8;
	DiagCursor1.WindowsCursor = ViewportOwner.4;
	HandCursor.Tex = Texture'UWindow_res.Icons.MouseHand';
	HandCursor.HotX = 11;
	HandCursor.HotY = 1;
	HandCursor.WindowsCursor = ViewportOwner.0;
	HSplitCursor.Tex = Texture'UWindow_res.Icons.MouseHSplit';
	HSplitCursor.HotX = 9;
	HSplitCursor.HotY = 9;
	HSplitCursor.WindowsCursor = ViewportOwner.5;
	VSplitCursor.Tex = Texture'UWindow_res.Icons.MouseVSplit';
	VSplitCursor.HotX = 9;
	VSplitCursor.HotY = 9;
	VSplitCursor.WindowsCursor = ViewportOwner.3;
	DiagCursor2.Tex = Texture'UWindow_res.Icons.MouseDiag2';
	DiagCursor2.HotX = 7;
	DiagCursor2.HotY = 7;
	DiagCursor2.WindowsCursor = ViewportOwner.2;
	NSCursor.Tex = Texture'UWindow_res.Icons.MouseNS';
	NSCursor.HotX = 3;
	NSCursor.HotY = 7;
	NSCursor.WindowsCursor = ViewportOwner.3;
	WECursor.Tex = Texture'UWindow_res.Icons.MouseWE';
	WECursor.HotX = 7;
	WECursor.HotY = 3;
	WECursor.WindowsCursor = ViewportOwner.5;
	WaitCursor.Tex = Texture'UWindow_res.Icons.MouseWait';
	WECursor.HotX = 6;
	WECursor.HotY = 9;
	WECursor.WindowsCursor = ViewportOwner.6;
	HotkeyWindows = Class'UWindow.UWindowHotkeyWindowList'.static.Allocate(self).;
	Construct_Void();
	HotkeyWindows.Last = HotkeyWindows;
	HotkeyWindows.Next = none;
	HotkeyWindows.Sentinel = HotkeyWindows;
	Cursor = NormalCursor;
	if(NotEqual_ObjectObject(ConsoleClass, none))
	{
		ConsoleWindow = UWindowConsoleWindow(CreateWindow(ConsoleClass, 100.0000000, 100.0000000, 200.0000000, 200.0000000));
		ConsoleWindow.HideWindow();
	}
	return;
}

function MoveMouse(float X, float Y)
{
	local UWindowWindow NewMouseWindow;
	local float tX, tY;

	MouseX = X;
	MouseY = Y;
	if(Not_PreBool(bMouseCapture))
	{
		NewMouseWindow = FindWindowUnder(X, Y);
	}
	else
	{
		NewMouseWindow = MouseWindow;
	}
	if(NotEqual_ObjectObject(NewMouseWindow, MouseWindow))
	{
		MouseWindow.MouseLeave();
		NewMouseWindow.MouseEnter();
		MouseWindow = NewMouseWindow;
	}
	if(OrOr_BoolBool(NotEqual_FloatFloat(MouseX, OldMouseX), NotEqual_FloatFloat(MouseY, OldMouseY)))
	{
		OldMouseX = MouseX;
		OldMouseY = MouseY;
		MouseWindow.GetMouseXY(tX, tY);
		MouseWindow.MouseMove(tX, tY);
	}
	return;
}

function DrawMouse(Canvas C)
{
	if(ViewportOwner.bWindowsMouseAvailable)
	{
		ViewportOwner.SelectedCursor = MouseWindow.Cursor.WindowsCursor;
	}
	else
	{
		C.DrawColor.R = byte(255);
		C.DrawColor.G = byte(255);
		C.DrawColor.B = byte(255);
		C.bNoSmooth = true;
		C.Style = 2;
		C.SetPos(Subtract_FloatFloat(Multiply_FloatFloat(MouseX, GUIScale), float(MouseWindow.Cursor.HotX)), Subtract_FloatFloat(Multiply_FloatFloat(MouseY, GUIScale), float(MouseWindow.Cursor.HotY)));
		C.DrawIcon(MouseWindow.Cursor.Tex, 1.0000000);
		C.Style = 1;
	}
	return;
}

function bool CheckCaptureMouseUp()
{
	local float X, Y;

	if(bMouseCapture)
	{
		MouseWindow.GetMouseXY(X, Y);
		MouseWindow.LMouseUp(X, Y);
		bMouseCapture = false;
		return true;
	}
	return false;
	return;
}

function bool CheckCaptureMouseDown()
{
	local float X, Y;

	if(bMouseCapture)
	{
		MouseWindow.GetMouseXY(X, Y);
		MouseWindow.LMouseDown(X, Y);
		bMouseCapture = false;
		return true;
	}
	return false;
	return;
}

function CancelCapture()
{
	bMouseCapture = false;
	return;
}

function CaptureMouse(optional UWindowWindow W)
{
	bMouseCapture = true;
	if(NotEqual_ObjectObject(W, none))
	{
		MouseWindow = W;
	}
	return;
}

function Texture GetLookAndFeelTexture()
{
	return LookAndFeel.Active;
	return;
}

function bool isActive()
{
	return true;
	return;
}

function AddHotkeyWindow(UWindowWindow W)
{
	UWindowHotkeyWindowList(HotkeyWindows.Insert(Class'UWindow.UWindowHotkeyWindowList')).Window = W;
	return;
}

function RemoveHotkeyWindow(UWindowWindow W)
{
	local UWindowHotkeyWindowList L;

	L = HotkeyWindows.FindWindow(W);
	if(NotEqual_ObjectObject(L, none))
	{
		L.Remove();
	}
	return;
}

function WindowEvent(UWindowWindow.WinMessage msg, Canvas C, float X, float Y, int Key)
{
	switch(msg)
	{
		case 7:
			if(HotKeyDown(Key, X, Y))
			{
				return;
			}
			break;
		case 6:
			if(HotKeyUp(Key, X, Y))
			{
				return;
			}
			break;
		default:
			break;
	}
	super.WindowEvent(msg, C, X, Y, Key);
	return;
}

function bool HotKeyDown(int Key, float X, float Y)
{
	local UWindowHotkeyWindowList L;

	L = UWindowHotkeyWindowList(HotkeyWindows.Next);
	J0x19:

	if(NotEqual_ObjectObject(L, none))
	{
		if(AndAnd_BoolBool(NotEqual_ObjectObject(L.Window, self), L.Window.HotKeyDown(Key, X, Y)))
		{
			return true;
		}
		L = UWindowHotkeyWindowList(L.Next);
		// [Loop Continue]
		goto J0x19;
	}
	return false;
	return;
}

function bool HotKeyUp(int Key, float X, float Y)
{
	local UWindowHotkeyWindowList L;

	L = UWindowHotkeyWindowList(HotkeyWindows.Next);
	J0x19:

	if(NotEqual_ObjectObject(L, none))
	{
		if(AndAnd_BoolBool(NotEqual_ObjectObject(L.Window, self), L.Window.HotKeyUp(Key, X, Y)))
		{
			return true;
		}
		L = UWindowHotkeyWindowList(L.Next);
		// [Loop Continue]
		goto J0x19;
	}
	return false;
	return;
}

function CloseActiveWindow()
{
	if(NotEqual_ObjectObject(ActiveWindow, none))
	{
		ActiveWindow.EscClose();
	}
	return;
}

function Resized()
{
	ResolutionChanged(WinWidth, WinHeight);
	return;
}

function SetScale(float NewScale)
{
	WinWidth = Divide_FloatFloat(RealWidth, NewScale);
	WinHeight = Divide_FloatFloat(RealHeight, NewScale);
	GUIScale = NewScale;
	ClippingRegion.X = 0;
	ClippingRegion.Y = 0;
	ClippingRegion.W = int(WinWidth);
	ClippingRegion.H = int(WinHeight);
	SetupFonts();
	Resized();
	return;
}

function SetupFonts()
{
	if(EqualEqual_FloatFloat(GUIScale, float(2)))
	{
		Fonts[0] = Font(DynamicLoadObject("UWindowFonts.Tahoma20", Class'Engine.Font'));
		Fonts[1] = Font(DynamicLoadObject("UWindowFonts.TahomaB20", Class'Engine.Font'));
		Fonts[2] = Font(DynamicLoadObject("UWindowFonts.Tahoma30", Class'Engine.Font'));
		Fonts[3] = Font(DynamicLoadObject("UWindowFonts.TahomaB30", Class'Engine.Font'));
	}
	else
	{
		Fonts[0] = Font(DynamicLoadObject("UWindowFonts.Tahoma10", Class'Engine.Font'));
		Fonts[1] = Font(DynamicLoadObject("UWindowFonts.TahomaB10", Class'Engine.Font'));
		Fonts[2] = Font(DynamicLoadObject("UWindowFonts.Tahoma20", Class'Engine.Font'));
		Fonts[3] = Font(DynamicLoadObject("UWindowFonts.TahomaB20", Class'Engine.Font'));
	}
	return;
}

function ChangeLookAndFeel(string NewLookAndFeel)
{
	LookAndFeelClass = NewLookAndFeel;
	SaveConfig();
	return;
}

function HideWindow()
{
	return;
}

function SetMousePos(float X, float Y)
{
	MouseX = X;
	MouseY = Y;
	return;
}

function QuitGame()
{
	bRequestQuit = true;
	QuitTime = 0.0000000;
	NotifyQuitUnreal();
	return;
}

function DoQuitGame()
{
	SaveConfig();
	ViewportOwner.Actor.ConsoleCommand("exit");
	return;
}

function Tick(float Delta)
{
	if(bRequestQuit)
	{
		if(Greater_FloatFloat(QuitTime, 0.2500000))
		{
			DoQuitGame();
		}
		AddEqual_FloatFloat(QuitTime, Delta);
	}
	super.Tick(Delta);
	return;
}

event Initialized()
{
	Root = self;
	MouseWindow = self;
	KeyFocusWindow = self;
	Created();
	return;
}

function bool KeyEvent(out Interactions.EInputKey Key, out Interactions.EInputAction Action, float Delta)
{
	if(AndAnd_BoolBool(EqualEqual_IntInt(int(Action), int(1)), EqualEqual_IntInt(int(Key), int(192))))
	{
		bAllowConsole = true;
		GotoState('UWindows');
		return true;
	}
	return super(Interaction).KeyEvent(Key, Action, Delta);
	return;
}

function PostRender(Canvas Canvas)
{
	local UWindowWindow NewFocusWindow;

	Canvas.bNoSmooth = true;
	Canvas.Z = 1.0000000;
	Canvas.Style = 1;
	Canvas.DrawColor.R = byte(255);
	Canvas.DrawColor.G = byte(255);
	Canvas.DrawColor.B = byte(255);
	if(AndAnd_BoolBool(ViewportOwner.bWindowsMouseAvailable, NotEqual_ObjectObject(Root, none)))
	{
		MouseX = Divide_FloatFloat(ViewportOwner.WindowsMouseX, Root.GUIScale);
		MouseY = Divide_FloatFloat(ViewportOwner.WindowsMouseY, Root.GUIScale);
	}
	if(OrOr_BoolBool(NotEqual_FloatFloat(Canvas.ClipX, OldClipX), NotEqual_FloatFloat(Canvas.ClipY, OldClipY)))
	{
		OldClipX = Canvas.ClipX;
		OldClipY = Canvas.ClipY;
		WinTop = 0.0000000;
		WinLeft = 0.0000000;
		WinWidth = Divide_FloatFloat(Canvas.ClipX, Root.GUIScale);
		WinHeight = Divide_FloatFloat(Canvas.ClipY, Root.GUIScale);
		RealWidth = Canvas.ClipX;
		RealHeight = Canvas.ClipY;
		ClippingRegion.X = 0;
		ClippingRegion.Y = 0;
		ClippingRegion.W = int(Root.WinWidth);
		ClippingRegion.H = int(Root.WinHeight);
		Resized();
	}
	if(Greater_FloatFloat(MouseX, WinWidth))
	{
		MouseX = WinWidth;
	}
	if(Greater_FloatFloat(MouseY, WinHeight))
	{
		MouseY = WinHeight;
	}
	if(Less_FloatFloat(MouseX, float(0)))
	{
		MouseX = 0.0000000;
	}
	if(Less_FloatFloat(MouseY, float(0)))
	{
		MouseY = 0.0000000;
	}
	NewFocusWindow = CheckKeyFocusWindow();
	if(NotEqual_ObjectObject(NewFocusWindow, KeyFocusWindow))
	{
		KeyFocusWindow.KeyFocusExit();
		KeyFocusWindow = NewFocusWindow;
		KeyFocusWindow.KeyFocusEnter();
	}
	MoveMouse(MouseX, MouseY);
	WindowEvent(9, Canvas, MouseX, MouseY, 0);
	DrawMouse(Canvas);
	return;
}

function Message(coerce string msg, float MsgLife)
{
	PropagateMessage(msg, MsgLife);
	if(NotEqual_ObjectObject(ConsoleWindow, none))
	{
		ConsoleWindow.PropagateMessage(msg, MsgLife);
	}
	return;
}

state UWindows
{
	function BeginState()
	{
		bVisible = true;
		bRequiresTick = true;
		bWindowVisible = true;
		bUWindowActive = true;
		ViewportOwner.bShowWindowsMouse = true;
		ViewportOwner.bSuspendPrecaching = true;
		if(EqualEqual_IntInt(int(ViewportOwner.Actor.Level.NetMode), int(NM_Standalone)))
		{
			ViewportOwner.Actor.SetPause(true);
		}
		if(bAllowConsole)
		{
			ConsoleWindow.ShowWindow();
		}
		return;
	}

	function EndState()
	{
		bVisible = false;
		bRequiresTick = false;
		bUWindowActive = false;
		bWindowVisible = false;
		ViewportOwner.bShowWindowsMouse = false;
		ViewportOwner.bSuspendPrecaching = false;
		if(EqualEqual_IntInt(int(ViewportOwner.Actor.Level.NetMode), int(NM_Standalone)))
		{
			ViewportOwner.Actor.SetPause(false);
		}
		ConsoleWindow.HideWindow();
		return;
	}

	function bool KeyType(out Interactions.EInputKey Key, optional string Unicode)
	{
		WindowEvent(8, none, MouseX, MouseY, int(Key));
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
					case 27:
						CloseActiveWindow();
						break;
					case 1:
						WindowEvent(1, none, MouseX, MouseY, int(k));
						break;
					case 2:
						WindowEvent(5, none, MouseX, MouseY, int(k));
						break;
					case 4:
						WindowEvent(3, none, MouseX, MouseY, int(k));
						break;
					default:
						WindowEvent(6, none, MouseX, MouseY, int(k));
						break;
						break;
				}
				goto J0x1A1;
			case 1:
				switch(k)
				{
					case 1:
						WindowEvent(0, none, MouseX, MouseY, int(k));
						break;
					case 2:
						WindowEvent(4, none, MouseX, MouseY, int(k));
						break;
					case 4:
						WindowEvent(2, none, MouseX, MouseY, int(k));
						break;
					default:
						WindowEvent(7, none, MouseX, MouseY, int(k));
						break;
						break;
				}
				goto J0x1A1;
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
		J0x1A1:

		return true;
		return;
	}
	stop;
}

defaultproperties
{
	GUIScale=1.0000000
	bAllowConsole=true
	MouseScale=0.6000000
	ConsoleClass=Class'UWindow.UWindowConsoleWindow'
}