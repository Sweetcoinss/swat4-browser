class UWindowWindow extends UWindowBase;

const DE_Created = 0;
const DE_Change = 1;
const DE_Click = 2;
const DE_Enter = 3;
const DE_Exit = 4;
const DE_MClick = 5;
const DE_RClick = 6;
const DE_EnterPressed = 7;
const DE_MouseMove = 8;
const DE_MouseLeave = 9;
const DE_LMouseDown = 10;
const DE_DoubleClick = 11;
const DE_MouseEnter = 12;
const DE_HelpChanged = 13;
const DE_WheelUpPressed = 14;
const DE_WheelDownPressed = 15;

enum WinMessage
{
	WM_LMouseDown,                  // 0
	WM_LMouseUp,                    // 1
	WM_MMouseDown,                  // 2
	WM_MMouseUp,                    // 3
	WM_RMouseDown,                  // 4
	WM_RMouseUp,                    // 5
	WM_KeyUp,                       // 6
	WM_KeyDown,                     // 7
	WM_KeyType,                     // 8
	WM_Paint                        // 9
};

struct MouseCursor
{
	var Texture Tex;
	var int HotX;
	var int HotY;
	var byte WindowsCursor;
};

var float WinLeft;
var float WinTop;
var float WinWidth;
var float WinHeight;
var UWindowWindow ParentWindow;
var UWindowWindow FirstChildWindow;
var UWindowWindow LastChildWindow;
var UWindowWindow NextSiblingWindow;
var UWindowWindow PrevSiblingWindow;
var UWindowWindow ActiveWindow;
var UWindowRootWindow Root;
var UWindowWindow OwnerWindow;
var UWindowWindow ModalWindow;
var bool bWindowVisible;
var bool bNoClip;
var bool bMouseDown;
var bool bRMouseDown;
var bool bMMouseDown;
var bool bAlwaysBehind;
var bool bAcceptsFocus;
var bool bAlwaysOnTop;
var bool bLeaveOnscreen;
var bool bUWindowActive;
var bool bTransient;
var bool bAcceptsHotKeys;
var bool bIgnoreLDoubleClick;
var bool bIgnoreMDoubleClick;
var bool bIgnoreRDoubleClick;
var float ClickTime;
var float MClickTime;
var float RClickTime;
var float ClickX;
var float ClickY;
var float MClickX;
var float MClickY;
var float RClickX;
var float RClickY;
var UWindowLookAndFeel LookAndFeel;
var Region ClippingRegion;
var MouseCursor Cursor;

function WindowEvent(UWindowWindow.WinMessage msg, Canvas C, float X, float Y, int Key)
{
	switch(msg)
	{
		case 9:
			Paint(C, X, Y);
			PaintClients(C, X, Y);
			break;
		case 0:
			if(Not_PreBool(Root.CheckCaptureMouseDown()))
			{
				if(Not_PreBool(MessageClients(msg, C, X, Y, Key)))
				{
					LMouseDown(X, Y);
				}
			}
			break;
		case 1:
			if(Not_PreBool(Root.CheckCaptureMouseUp()))
			{
				if(Not_PreBool(MessageClients(msg, C, X, Y, Key)))
				{
					LMouseUp(X, Y);
				}
			}
			break;
		case 4:
			if(Not_PreBool(MessageClients(msg, C, X, Y, Key)))
			{
				RMouseDown(X, Y);
			}
			break;
		case 5:
			if(Not_PreBool(MessageClients(msg, C, X, Y, Key)))
			{
				RMouseUp(X, Y);
			}
			break;
		case 2:
			if(Not_PreBool(MessageClients(msg, C, X, Y, Key)))
			{
				MMouseDown(X, Y);
			}
			break;
		case 3:
			if(Not_PreBool(MessageClients(msg, C, X, Y, Key)))
			{
				MMouseUp(X, Y);
			}
			break;
		case 7:
			if(Not_PreBool(PropagateKey(msg, C, X, Y, Key)))
			{
				KeyDown(Key, X, Y);
			}
			break;
		case 6:
			if(Not_PreBool(PropagateKey(msg, C, X, Y, Key)))
			{
				KeyUp(Key, X, Y);
			}
			break;
		case 8:
			if(Not_PreBool(PropagateKey(msg, C, X, Y, Key)))
			{
				KeyPressed(Key, X, Y);
			}
			break;
		default:
			break;
			break;
	}
	return;
}

function SaveConfigs()
{
	return;
}

final function PlayerController GetPlayerOwner()
{
	return Root.ViewportOwner.Actor;
	return;
}

final function LevelInfo GetLevel()
{
	return Root.ViewportOwner.Actor.Level;
	return;
}

final function LevelInfo GetEntryLevel()
{
	return Root.ViewportOwner.Actor.super(UWindowWindow).GetEntryLevel();
	return;
}

function Resized()
{
	return;
}

function BeforePaint(Canvas C, float X, float Y)
{
	return;
}

function AfterPaint(Canvas C, float X, float Y)
{
	return;
}

function Paint(Canvas C, float X, float Y)
{
	return;
}

function Click(float X, float Y)
{
	return;
}

function MClick(float X, float Y)
{
	return;
}

function RClick(float X, float Y)
{
	return;
}

function DoubleClick(float X, float Y)
{
	return;
}

function MDoubleClick(float X, float Y)
{
	return;
}

function RDoubleClick(float X, float Y)
{
	return;
}

function BeginPlay()
{
	return;
}

function BeforeCreate()
{
	return;
}

function Created()
{
	return;
}

function AfterCreate()
{
	return;
}

function MouseEnter()
{
	return;
}

function Activated()
{
	return;
}

function Deactivated()
{
	return;
}

function MouseLeave()
{
	bMouseDown = false;
	bMMouseDown = false;
	bRMouseDown = false;
	return;
}

function MouseMove(float X, float Y)
{
	return;
}

function KeyUp(int Key, float X, float Y)
{
	return;
}

function KeyDown(int Key, float X, float Y)
{
	return;
}

function bool HotKeyDown(int Key, float X, float Y)
{
	return false;
	return;
}

function bool HotKeyUp(int Key, float X, float Y)
{
	return false;
	return;
}

function KeyPressed(int Key, float X, float Y)
{
	return;
}

function ProcessMenuKey(int Key, string KeyName)
{
	return;
}

function KeyFocusEnter()
{
	return;
}

function KeyFocusExit()
{
	return;
}

function RMouseDown(float X, float Y)
{
	ActivateWindow(0, false);
	bRMouseDown = true;
	return;
}

function RMouseUp(float X, float Y)
{
	if(bRMouseDown)
	{
		if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(Not_PreBool(bIgnoreRDoubleClick), LessEqual_FloatFloat(Abs(Subtract_FloatFloat(X, RClickX)), float(1))), LessEqual_FloatFloat(Abs(Subtract_FloatFloat(Y, RClickY)), float(1))), Less_FloatFloat(GetLevel().TimeSeconds, Add_FloatFloat(RClickTime, 0.6000000))))
		{
			RDoubleClick(X, Y);
			RClickTime = 0.0000000;
		}
		else
		{
			RClickTime = GetLevel().TimeSeconds;
			RClickX = X;
			RClickY = Y;
			RClick(X, Y);
		}
	}
	bRMouseDown = false;
	return;
}

function MMouseDown(float X, float Y)
{
	ActivateWindow(0, false);
	bMMouseDown = true;
	return;
}

function MMouseUp(float X, float Y)
{
	if(bMMouseDown)
	{
		if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(Not_PreBool(bIgnoreMDoubleClick), LessEqual_FloatFloat(Abs(Subtract_FloatFloat(X, MClickX)), float(1))), LessEqual_FloatFloat(Subtract_FloatFloat(Y, MClickY), float(1))), Less_FloatFloat(GetLevel().TimeSeconds, Add_FloatFloat(MClickTime, 0.6000000))))
		{
			MDoubleClick(X, Y);
			MClickTime = 0.0000000;
		}
		else
		{
			MClickTime = GetLevel().TimeSeconds;
			MClickX = X;
			MClickY = Y;
			MClick(X, Y);
		}
	}
	bMMouseDown = false;
	return;
}

function LMouseDown(float X, float Y)
{
	ActivateWindow(0, false);
	bMouseDown = true;
	return;
}

function LMouseUp(float X, float Y)
{
	if(bMouseDown)
	{
		if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(Not_PreBool(bIgnoreLDoubleClick), LessEqual_FloatFloat(Abs(Subtract_FloatFloat(X, ClickX)), float(1))), LessEqual_FloatFloat(Subtract_FloatFloat(Y, ClickY), float(1))), Less_FloatFloat(GetLevel().TimeSeconds, Add_FloatFloat(ClickTime, 0.6000000))))
		{
			DoubleClick(X, Y);
			ClickTime = 0.0000000;
		}
		else
		{
			ClickTime = GetLevel().TimeSeconds;
			ClickX = X;
			ClickY = Y;
			Click(X, Y);
		}
	}
	bMouseDown = false;
	return;
}

function FocusWindow()
{
	if(AndAnd_BoolBool(NotEqual_ObjectObject(Root.FocusedWindow, none), NotEqual_ObjectObject(Root.FocusedWindow, self)))
	{
		Root.FocusedWindow.FocusOtherWindow(self);
	}
	Root.FocusedWindow = self;
	return;
}

function FocusOtherWindow(UWindowWindow W)
{
	return;
}

function EscClose()
{
	Close();
	return;
}

function Close(optional bool bByParent)
{
	local UWindowWindow Prev, Child;

	Child = LastChildWindow;
	J0x0B:

	if(NotEqual_ObjectObject(Child, none))
	{
		Prev = Child.PrevSiblingWindow;
		Child.Close(true);
		Child = Prev;
		// [Loop Continue]
		goto J0x0B;
	}
	SaveConfigs();
	if(Not_PreBool(bByParent))
	{
		HideWindow();
	}
	return;
}

final function SetSize(float W, float H)
{
	if(OrOr_BoolBool(NotEqual_FloatFloat(WinWidth, W), NotEqual_FloatFloat(WinHeight, H)))
	{
		WinWidth = W;
		WinHeight = H;
		Resized();
	}
	return;
}

function Tick(float Delta)
{
	return;
}

final function DoTick(float Delta)
{
	local UWindowWindow Child;

	Tick(Delta);
	Child = FirstChildWindow;
	J0x16:

	if(NotEqual_ObjectObject(Child, none))
	{
		Child.bUWindowActive = bUWindowActive;
		if(bLeaveOnscreen)
		{
			Child.bLeaveOnscreen = true;
		}
		if(OrOr_BoolBool(bUWindowActive, Child.bLeaveOnscreen))
		{
			Child.super(UWindowWindow).DoTick(Delta);
		}
		Child = Child.NextSiblingWindow;
		// [Loop Continue]
		goto J0x16;
	}
	return;
}

final function PaintClients(Canvas C, float X, float Y)
{
	local float OrgX, OrgY, ClipX, ClipY;
	local UWindowWindow Child;

	OrgX = C.OrgX;
	OrgY = C.OrgY;
	ClipX = C.ClipX;
	ClipY = C.ClipY;
	Child = FirstChildWindow;
	J0x5B:

	if(NotEqual_ObjectObject(Child, none))
	{
		Child.bUWindowActive = bUWindowActive;
		C.SetPos(0.0000000, 0.0000000);
		C.Style = GetPlayerOwner().1;
		C.SetDrawColor(byte(255), byte(255), byte(255));
		C.SpaceX = 0.0000000;
		C.SpaceY = 0.0000000;
		Child.BeforePaint(C, Subtract_FloatFloat(X, Child.WinLeft), Subtract_FloatFloat(Y, Child.WinTop));
		if(bLeaveOnscreen)
		{
			Child.bLeaveOnscreen = true;
		}
		if(OrOr_BoolBool(bUWindowActive, Child.bLeaveOnscreen))
		{
			C.OrgX = Add_FloatFloat(C.OrgX, Multiply_FloatFloat(Child.WinLeft, Root.GUIScale));
			C.OrgY = Add_FloatFloat(C.OrgY, Multiply_FloatFloat(Child.WinTop, Root.GUIScale));
			if(Not_PreBool(Child.bNoClip))
			{
				C.ClipX = Multiply_FloatFloat(FMin(Subtract_FloatFloat(WinWidth, Child.WinLeft), Child.WinWidth), Root.GUIScale);
				C.ClipY = Multiply_FloatFloat(FMin(Subtract_FloatFloat(WinHeight, Child.WinTop), Child.WinHeight), Root.GUIScale);
				Child.ClippingRegion.X = int(Subtract_FloatFloat(float(ClippingRegion.X), Child.WinLeft));
				Child.ClippingRegion.Y = int(Subtract_FloatFloat(float(ClippingRegion.Y), Child.WinTop));
				Child.ClippingRegion.W = ClippingRegion.W;
				Child.ClippingRegion.H = ClippingRegion.H;
				if(Less_IntInt(Child.ClippingRegion.X, 0))
				{
					AddEqual_IntInt(Child.ClippingRegion.W, Child.ClippingRegion.X);
					Child.ClippingRegion.X = 0;
				}
				if(Less_IntInt(Child.ClippingRegion.Y, 0))
				{
					AddEqual_IntInt(Child.ClippingRegion.H, Child.ClippingRegion.Y);
					Child.ClippingRegion.Y = 0;
				}
				if(Greater_FloatFloat(float(Child.ClippingRegion.W), Subtract_FloatFloat(Child.WinWidth, float(Child.ClippingRegion.X))))
				{
					Child.ClippingRegion.W = int(Subtract_FloatFloat(Child.WinWidth, float(Child.ClippingRegion.X)));
				}
				if(Greater_FloatFloat(float(Child.ClippingRegion.H), Subtract_FloatFloat(Child.WinHeight, float(Child.ClippingRegion.Y))))
				{
					Child.ClippingRegion.H = int(Subtract_FloatFloat(Child.WinHeight, float(Child.ClippingRegion.Y)));
				}
			}
			if(AndAnd_BoolBool(Greater_IntInt(Child.ClippingRegion.W, 0), Greater_IntInt(Child.ClippingRegion.H, 0)))
			{
				Child.WindowEvent(9, C, Subtract_FloatFloat(X, Child.WinLeft), Subtract_FloatFloat(Y, Child.WinTop), 0);
				Child.AfterPaint(C, Subtract_FloatFloat(X, Child.WinLeft), Subtract_FloatFloat(Y, Child.WinTop));
			}
			C.OrgX = OrgX;
			C.OrgY = OrgY;
		}
		Child = Child.NextSiblingWindow;
		// [Loop Continue]
		goto J0x5B;
	}
	C.ClipX = ClipX;
	C.ClipY = ClipY;
	return;
}

final function UWindowWindow FindWindowUnder(float X, float Y)
{
	local UWindowWindow Child;

	Child = LastChildWindow;
	J0x0B:

	if(NotEqual_ObjectObject(Child, none))
	{
		Child.bUWindowActive = bUWindowActive;
		if(bLeaveOnscreen)
		{
			Child.bLeaveOnscreen = true;
		}
		if(OrOr_BoolBool(bUWindowActive, Child.bLeaveOnscreen))
		{
			if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(GreaterEqual_FloatFloat(X, Child.WinLeft), LessEqual_FloatFloat(X, Add_FloatFloat(Child.WinLeft, Child.WinWidth))), GreaterEqual_FloatFloat(Y, Child.WinTop)), LessEqual_FloatFloat(Y, Add_FloatFloat(Child.WinTop, Child.WinHeight))), Not_PreBool(Child.CheckMousePassThrough(Subtract_FloatFloat(X, Child.WinLeft), Subtract_FloatFloat(Y, Child.WinTop)))))
			{
				return Child.super(UWindowWindow).FindWindowUnder(Subtract_FloatFloat(X, Child.WinLeft), Subtract_FloatFloat(Y, Child.WinTop));
			}
		}
		Child = Child.PrevSiblingWindow;
		// [Loop Continue]
		goto J0x0B;
	}
	return self;
	return;
}

final function bool PropagateKey(UWindowWindow.WinMessage msg, Canvas C, float X, float Y, int Key)
{
	local UWindowWindow Child;

	Child = LastChildWindow;
	if(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(ActiveWindow, none), NotEqual_ObjectObject(Child, ActiveWindow)), Not_PreBool(Child.bTransient)))
	{
		Child = ActiveWindow;
	}
	J0x48:

	if(NotEqual_ObjectObject(Child, none))
	{
		Child.bUWindowActive = bUWindowActive;
		if(bLeaveOnscreen)
		{
			Child.bLeaveOnscreen = true;
		}
		if(AndAnd_BoolBool(OrOr_BoolBool(bUWindowActive, Child.bLeaveOnscreen), Child.bAcceptsFocus))
		{
			Child.WindowEvent(msg, C, Subtract_FloatFloat(X, Child.WinLeft), Subtract_FloatFloat(Y, Child.WinTop), Key);
			return true;
		}
		Child = Child.PrevSiblingWindow;
		// [Loop Continue]
		goto J0x48;
	}
	return false;
	return;
}

final function bool PropagateMessage(coerce string msg, float MsgLife)
{
	local UWindowWindow Child;

	Child = LastChildWindow;
	if(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(ActiveWindow, none), NotEqual_ObjectObject(Child, ActiveWindow)), Not_PreBool(Child.bTransient)))
	{
		Child = ActiveWindow;
	}
	J0x48:

	if(NotEqual_ObjectObject(Child, none))
	{
		Child.bUWindowActive = bUWindowActive;
		if(bLeaveOnscreen)
		{
			Child.bLeaveOnscreen = true;
		}
		if(AndAnd_BoolBool(OrOr_BoolBool(bUWindowActive, Child.bLeaveOnscreen), Child.bAcceptsFocus))
		{
			Child.Message(msg, MsgLife);
			Child.super(UWindowWindow).PropagateMessage(msg, MsgLife);
			return true;
		}
		Child = Child.PrevSiblingWindow;
		// [Loop Continue]
		goto J0x48;
	}
	return false;
	return;
}

final function UWindowWindow CheckKeyFocusWindow()
{
	local UWindowWindow Child;

	Child = LastChildWindow;
	if(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(ActiveWindow, none), NotEqual_ObjectObject(Child, ActiveWindow)), Not_PreBool(Child.bTransient)))
	{
		Child = ActiveWindow;
	}
	J0x48:

	if(NotEqual_ObjectObject(Child, none))
	{
		Child.bUWindowActive = bUWindowActive;
		if(bLeaveOnscreen)
		{
			Child.bLeaveOnscreen = true;
		}
		if(OrOr_BoolBool(bUWindowActive, Child.bLeaveOnscreen))
		{
			if(Child.bAcceptsFocus)
			{
				return Child.super(UWindowWindow).CheckKeyFocusWindow();
			}
		}
		Child = Child.PrevSiblingWindow;
		// [Loop Continue]
		goto J0x48;
	}
	return self;
	return;
}

final function bool MessageClients(UWindowWindow.WinMessage msg, Canvas C, float X, float Y, int Key)
{
	local UWindowWindow Child;

	Child = LastChildWindow;
	J0x0B:

	if(NotEqual_ObjectObject(Child, none))
	{
		Child.bUWindowActive = bUWindowActive;
		if(bLeaveOnscreen)
		{
			Child.bLeaveOnscreen = true;
		}
		if(OrOr_BoolBool(bUWindowActive, Child.bLeaveOnscreen))
		{
			if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(GreaterEqual_FloatFloat(X, Child.WinLeft), LessEqual_FloatFloat(X, Add_FloatFloat(Child.WinLeft, Child.WinWidth))), GreaterEqual_FloatFloat(Y, Child.WinTop)), LessEqual_FloatFloat(Y, Add_FloatFloat(Child.WinTop, Child.WinHeight))), Not_PreBool(Child.CheckMousePassThrough(Subtract_FloatFloat(X, Child.WinLeft), Subtract_FloatFloat(Y, Child.WinTop)))))
			{
				Child.WindowEvent(msg, C, Subtract_FloatFloat(X, Child.WinLeft), Subtract_FloatFloat(Y, Child.WinTop), Key);
				return true;
			}
		}
		Child = Child.PrevSiblingWindow;
		// [Loop Continue]
		goto J0x0B;
	}
	return false;
	return;
}

final function ActivateWindow(int depth, bool bTransientNoDeactivate)
{
	if(EqualEqual_ObjectObject(self, Root))
	{
		if(EqualEqual_IntInt(depth, 0))
		{
			FocusWindow();
		}
		return;
	}
	if(WaitModal())
	{
		return;
	}
	if(Not_PreBool(bAlwaysBehind))
	{
		ParentWindow.HideChildWindow(self);
		ParentWindow.ShowChildWindow(self);
	}
	if(Not_PreBool(OrOr_BoolBool(bTransient, bTransientNoDeactivate)))
	{
		if(AndAnd_BoolBool(NotEqual_ObjectObject(ParentWindow.ActiveWindow, none), NotEqual_ObjectObject(ParentWindow.ActiveWindow, self)))
		{
			ParentWindow.ActiveWindow.Deactivated();
		}
		ParentWindow.ActiveWindow = self;
		ParentWindow.super(UWindowWindow).ActivateWindow(Add_IntInt(depth, 1), false);
		Activated();
	}
	else
	{
		ParentWindow.super(UWindowWindow).ActivateWindow(Add_IntInt(depth, 1), true);
	}
	if(EqualEqual_IntInt(depth, 0))
	{
		FocusWindow();
	}
	return;
}

final function BringToFront()
{
	if(EqualEqual_ObjectObject(self, Root))
	{
		return;
	}
	if(AndAnd_BoolBool(Not_PreBool(bAlwaysBehind), Not_PreBool(WaitModal())))
	{
		ParentWindow.HideChildWindow(self);
		ParentWindow.ShowChildWindow(self);
	}
	ParentWindow.super(UWindowWindow).BringToFront();
	return;
}

final function SendToBack()
{
	ParentWindow.HideChildWindow(self);
	ParentWindow.ShowChildWindow(self, true);
	return;
}

final function HideChildWindow(UWindowWindow Child)
{
	local UWindowWindow Window;

	if(Not_PreBool(Child.bWindowVisible))
	{
		return;
	}
	Child.bWindowVisible = false;
	if(Child.bAcceptsHotKeys)
	{
		Root.RemoveHotkeyWindow(Child);
	}
	if(EqualEqual_ObjectObject(LastChildWindow, Child))
	{
		LastChildWindow = Child.PrevSiblingWindow;
		if(NotEqual_ObjectObject(LastChildWindow, none))
		{
			LastChildWindow.NextSiblingWindow = none;
		}
		else
		{
			FirstChildWindow = none;
		}
	}
	else
	{
		if(EqualEqual_ObjectObject(FirstChildWindow, Child))
		{
			FirstChildWindow = Child.NextSiblingWindow;
			if(NotEqual_ObjectObject(FirstChildWindow, none))
			{
				FirstChildWindow.PrevSiblingWindow = none;
			}
			else
			{
				LastChildWindow = none;
			}
		}
		else
		{
			Window = FirstChildWindow;
			J0xEE:

			if(NotEqual_ObjectObject(Window, none))
			{
				if(EqualEqual_ObjectObject(Window.NextSiblingWindow, Child))
				{
					Window.NextSiblingWindow = Child.NextSiblingWindow;
					Window.NextSiblingWindow.PrevSiblingWindow = Window;
					// [Explicit Break]
					goto J0x165;
				}
				Window = Window.NextSiblingWindow;
				// [Loop Continue]
				goto J0xEE;
			}
		}
	}
	J0x165:

	ActiveWindow = none;
	Window = LastChildWindow;
	J0x177:

	if(NotEqual_ObjectObject(Window, none))
	{
		if(Not_PreBool(Window.bAlwaysOnTop))
		{
			ActiveWindow = Window;
			// [Explicit Break]
			goto J0x1BB;
		}
		Window = Window.PrevSiblingWindow;
		// [Loop Continue]
		goto J0x177;
	}
	J0x1BB:

	if(EqualEqual_ObjectObject(ActiveWindow, none))
	{
		ActiveWindow = LastChildWindow;
	}
	return;
}

final function SetAcceptsFocus()
{
	if(bAcceptsFocus)
	{
		return;
	}
	bAcceptsFocus = true;
	if(NotEqual_ObjectObject(self, Root))
	{
		ParentWindow.super(UWindowWindow).SetAcceptsFocus();
	}
	return;
}

final function CancelAcceptsFocus()
{
	local UWindowWindow Child;

	Child = LastChildWindow;
	J0x0B:

	if(NotEqual_ObjectObject(Child, none))
	{
		Child.super(UWindowWindow).CancelAcceptsFocus();
		Child = Child.PrevSiblingWindow;
		// [Loop Continue]
		goto J0x0B;
	}
	bAcceptsFocus = false;
	return;
}

final function GetMouseXY(out float X, out float Y)
{
	local UWindowWindow P;

	X = float(int(Root.MouseX));
	Y = float(int(Root.MouseY));
	P = self;
	J0x37:

	if(NotEqual_ObjectObject(P, Root))
	{
		X = Subtract_FloatFloat(X, P.WinLeft);
		Y = Subtract_FloatFloat(Y, P.WinTop);
		P = P.ParentWindow;
		// [Loop Continue]
		goto J0x37;
	}
	return;
}

final function GlobalToWindow(float GlobalX, float GlobalY, out float WinX, out float WinY)
{
	local UWindowWindow P;

	WinX = GlobalX;
	WinY = GlobalY;
	P = self;
	J0x1D:

	if(NotEqual_ObjectObject(P, Root))
	{
		SubtractEqual_FloatFloat(WinX, P.WinLeft);
		SubtractEqual_FloatFloat(WinY, P.WinTop);
		P = P.ParentWindow;
		// [Loop Continue]
		goto J0x1D;
	}
	return;
}

final function WindowToGlobal(float WinX, float WinY, out float GlobalX, out float GlobalY)
{
	local UWindowWindow P;

	GlobalX = WinX;
	GlobalY = WinY;
	P = self;
	J0x1D:

	if(NotEqual_ObjectObject(P, Root))
	{
		AddEqual_FloatFloat(GlobalX, P.WinLeft);
		AddEqual_FloatFloat(GlobalY, P.WinTop);
		P = P.ParentWindow;
		// [Loop Continue]
		goto J0x1D;
	}
	return;
}

final function ShowChildWindow(UWindowWindow Child, optional bool bAtBack)
{
	local UWindowWindow W;

	if(Not_PreBool(Child.bTransient))
	{
		ActiveWindow = Child;
	}
	if(Child.bWindowVisible)
	{
		return;
	}
	Child.bWindowVisible = true;
	if(Child.bAcceptsHotKeys)
	{
		Root.AddHotkeyWindow(Child);
	}
	if(bAtBack)
	{
		if(EqualEqual_ObjectObject(FirstChildWindow, none))
		{
			Child.NextSiblingWindow = none;
			Child.PrevSiblingWindow = none;
			LastChildWindow = Child;
			FirstChildWindow = Child;
		}
		else
		{
			FirstChildWindow.PrevSiblingWindow = Child;
			Child.NextSiblingWindow = FirstChildWindow;
			Child.PrevSiblingWindow = none;
			FirstChildWindow = Child;
		}
	}
	else
	{
		W = LastChildWindow;
		J0x108:

		if(true)
		{
			if(OrOr_BoolBool(OrOr_BoolBool(Child.bAlwaysOnTop, EqualEqual_ObjectObject(W, none)), Not_PreBool(W.bAlwaysOnTop)))
			{
				if(EqualEqual_ObjectObject(W, none))
				{
					if(EqualEqual_ObjectObject(LastChildWindow, none))
					{
						Child.NextSiblingWindow = none;
						Child.PrevSiblingWindow = none;
						LastChildWindow = Child;
						FirstChildWindow = Child;
					}
					else
					{
						Child.NextSiblingWindow = FirstChildWindow;
						Child.PrevSiblingWindow = none;
						FirstChildWindow.PrevSiblingWindow = Child;
						FirstChildWindow = Child;
					}
				}
				else
				{
					Child.NextSiblingWindow = W.NextSiblingWindow;
					Child.PrevSiblingWindow = W;
					if(NotEqual_ObjectObject(W.NextSiblingWindow, none))
					{
						W.NextSiblingWindow.PrevSiblingWindow = Child;
					}
					else
					{
						LastChildWindow = Child;
					}
					W.NextSiblingWindow = Child;
				}
				// [Explicit Break]
				goto J0x274;
			}
			W = W.PrevSiblingWindow;
			// [Loop Continue]
			goto J0x108;
		}
	}
	J0x274:

	return;
}

function ShowWindow()
{
	ParentWindow.ShowChildWindow(self);
	WindowShown();
	return;
}

function HideWindow()
{
	WindowHidden();
	ParentWindow.HideChildWindow(self);
	return;
}

final function UWindowWindow CreateWindow(Class<UWindowWindow> WndClass, float X, float Y, float W, float H, optional UWindowWindow OwnerW, optional bool bUnique, optional name ObjectName)
{
	local UWindowWindow Child;

	if(bUnique)
	{
		Child = Root.FindChildWindow(WndClass, true);
		if(NotEqual_ObjectObject(Child, none))
		{
			Child.ShowWindow();
			Child.BringToFront();
			return Child;
		}
	}
	if(NotEqual_NameName(ObjectName, 'None'))
	{
		Child = WndClass.static.Allocate(self, none, string(ObjectName)).;
		Construct_Void();
	}
	else
	{
		Child = WndClass.static.Allocate(self, none).;
		Construct_Void();
	}
	Child.BeginPlay();
	Child.WinTop = Y;
	Child.WinLeft = X;
	Child.WinWidth = W;
	Child.WinHeight = H;
	Child.Root = Root;
	Child.ParentWindow = self;
	Child.OwnerWindow = OwnerW;
	if(EqualEqual_ObjectObject(Child.OwnerWindow, none))
	{
		Child.OwnerWindow = self;
	}
	Child.Cursor = Cursor;
	Child.bAlwaysBehind = false;
	Child.LookAndFeel = LookAndFeel;
	Child.BeforeCreate();
	Child.Created();
	ShowChildWindow(Child);
	Child.AfterCreate();
	return Child;
	return;
}

final function Tile(Canvas C, Texture t)
{
	local int X, Y;

	X = 0;
	Y = 0;
	J0x0E:

	if(Less_FloatFloat(float(X), WinWidth))
	{
		J0x1F:

		if(Less_FloatFloat(float(Y), WinHeight))
		{
			DrawClippedTexture(C, float(X), float(Y), t);
			AddEqual_IntInt(Y, t.VSize);
			// [Loop Continue]
			goto J0x1F;
		}
		AddEqual_IntInt(X, t.USize);
		Y = 0;
		// [Loop Continue]
		goto J0x0E;
	}
	return;
}

final function DrawHorizTiledPieces(Canvas C, float DestX, float DestY, float DestW, float DestH, TexRegion T1, TexRegion T2, TexRegion T3, TexRegion T4, TexRegion T5, float Scale)
{
	local TexRegion Pieces[5], R;
	local int PieceCount, j;
	local float X, L;

	Pieces[0] = T1;
	if(NotEqual_ObjectObject(T1.t, none))
	{
		PieceCount = 1;
	}
	Pieces[1] = T2;
	if(NotEqual_ObjectObject(T2.t, none))
	{
		PieceCount = 2;
	}
	Pieces[2] = T3;
	if(NotEqual_ObjectObject(T3.t, none))
	{
		PieceCount = 3;
	}
	Pieces[3] = T4;
	if(NotEqual_ObjectObject(T4.t, none))
	{
		PieceCount = 4;
	}
	Pieces[4] = T5;
	if(NotEqual_ObjectObject(T5.t, none))
	{
		PieceCount = 5;
	}
	j = 0;
	X = DestX;
	J0xCD:

	if(Less_FloatFloat(X, Add_FloatFloat(DestX, DestW)))
	{
		L = Subtract_FloatFloat(DestW, Subtract_FloatFloat(X, DestX));
		R = Pieces[j];
		DrawStretchedTextureSegment(C, X, DestY, FMin(Multiply_FloatFloat(float(R.W), Scale), L), Multiply_FloatFloat(float(R.H), Scale), float(R.X), float(R.Y), FMin(float(R.W), Divide_FloatFloat(L, Scale)), float(R.H), R.t);
		AddEqual_FloatFloat(X, FMin(Multiply_FloatFloat(float(R.W), Scale), L));
		j = int(Percent_FloatFloat(float(Add_IntInt(j, 1)), float(PieceCount)));
		// [Loop Continue]
		goto J0xCD;
	}
	return;
}

final function DrawVertTiledPieces(Canvas C, float DestX, float DestY, float DestW, float DestH, TexRegion T1, TexRegion T2, TexRegion T3, TexRegion T4, TexRegion T5, float Scale)
{
	local TexRegion Pieces[5], R;
	local int PieceCount, j;
	local float Y, L;

	Pieces[0] = T1;
	if(NotEqual_ObjectObject(T1.t, none))
	{
		PieceCount = 1;
	}
	Pieces[1] = T2;
	if(NotEqual_ObjectObject(T2.t, none))
	{
		PieceCount = 2;
	}
	Pieces[2] = T3;
	if(NotEqual_ObjectObject(T3.t, none))
	{
		PieceCount = 3;
	}
	Pieces[3] = T4;
	if(NotEqual_ObjectObject(T4.t, none))
	{
		PieceCount = 4;
	}
	Pieces[4] = T5;
	if(NotEqual_ObjectObject(T5.t, none))
	{
		PieceCount = 5;
	}
	j = 0;
	Y = DestY;
	J0xCD:

	if(Less_FloatFloat(Y, Add_FloatFloat(DestY, DestH)))
	{
		L = Subtract_FloatFloat(DestH, Subtract_FloatFloat(Y, DestY));
		R = Pieces[j];
		DrawStretchedTextureSegment(C, DestX, Y, Multiply_FloatFloat(float(R.W), Scale), FMin(Multiply_FloatFloat(float(R.H), Scale), L), float(R.X), float(R.Y), float(R.W), FMin(float(R.H), Divide_FloatFloat(L, Scale)), R.t);
		AddEqual_FloatFloat(Y, FMin(Multiply_FloatFloat(float(R.H), Scale), L));
		j = int(Percent_FloatFloat(float(Add_IntInt(j, 1)), float(PieceCount)));
		// [Loop Continue]
		goto J0xCD;
	}
	return;
}

final function DrawClippedTexture(Canvas C, float X, float Y, Texture Tex)
{
	DrawStretchedTextureSegment(C, X, Y, float(Tex.USize), float(Tex.VSize), 0.0000000, 0.0000000, float(Tex.USize), float(Tex.VSize), Tex);
	return;
}

final function DrawStretchedTexture(Canvas C, float X, float Y, float W, float H, Texture Tex)
{
	DrawStretchedTextureSegment(C, X, Y, W, H, 0.0000000, 0.0000000, float(Tex.USize), float(Tex.VSize), Tex);
	return;
}

final function DrawStretchedTextureSegment(Canvas C, float X, float Y, float W, float H, float tX, float tY, float tW, float tH, Texture Tex)
{
	local float OrgX, OrgY, ClipX, ClipY;

	OrgX = C.OrgX;
	OrgY = C.OrgY;
	ClipX = C.ClipX;
	ClipY = C.ClipY;
	C.SetOrigin(Add_FloatFloat(OrgX, Multiply_FloatFloat(float(ClippingRegion.X), Root.GUIScale)), Add_FloatFloat(OrgY, Multiply_FloatFloat(float(ClippingRegion.Y), Root.GUIScale)));
	C.SetClip(Multiply_FloatFloat(float(ClippingRegion.W), Root.GUIScale), Multiply_FloatFloat(float(ClippingRegion.H), Root.GUIScale));
	C.SetPos(Multiply_FloatFloat(Subtract_FloatFloat(X, float(ClippingRegion.X)), Root.GUIScale), Multiply_FloatFloat(Subtract_FloatFloat(Y, float(ClippingRegion.Y)), Root.GUIScale));
	C.DrawTileClipped(Tex, Multiply_FloatFloat(W, Root.GUIScale), Multiply_FloatFloat(H, Root.GUIScale), tX, tY, tW, tH);
	C.SetClip(ClipX, ClipY);
	C.SetOrigin(OrgX, OrgY);
	return;
}

final function ClipText(Canvas C, float X, float Y, coerce string S, optional bool bCheckHotKey)
{
	local float OrgX, OrgY, ClipX, ClipY;

	OrgX = C.OrgX;
	OrgY = C.OrgY;
	ClipX = C.ClipX;
	ClipY = C.ClipY;
	C.SetOrigin(Add_FloatFloat(OrgX, Multiply_FloatFloat(float(ClippingRegion.X), Root.GUIScale)), Add_FloatFloat(OrgY, Multiply_FloatFloat(float(ClippingRegion.Y), Root.GUIScale)));
	C.SetClip(Multiply_FloatFloat(float(ClippingRegion.W), Root.GUIScale), Multiply_FloatFloat(float(ClippingRegion.H), Root.GUIScale));
	C.SetPos(Multiply_FloatFloat(Subtract_FloatFloat(X, float(ClippingRegion.X)), Root.GUIScale), Multiply_FloatFloat(Subtract_FloatFloat(Y, float(ClippingRegion.Y)), Root.GUIScale));
	C.DrawTextClipped(S, bCheckHotKey);
	C.SetClip(ClipX, ClipY);
	C.SetOrigin(OrgX, OrgY);
	return;
}

final function int WrapClipText(Canvas C, float X, float Y, coerce string S, optional bool bCheckHotKey, optional int Length, optional int PaddingLength, optional bool bNoDraw)
{
	local float W, H;
	local int SpacePos, CRPos, WordPos, TotalPos;
	local string Out, temp, Padding;
	local bool bCR, bSentry;
	local int i, numLines;
	local float pW, pH;

	i = InStr(S, "\\n");
	J0x11:

	if(NotEqual_IntInt(i, -1))
	{
		S = Concat_StrStr(Concat_StrStr(Left(S, i), Chr(13)), Mid(S, Add_IntInt(i, 2)));
		i = InStr(S, "\\n");
		// [Loop Continue]
		goto J0x11;
	}
	i = 0;
	bSentry = true;
	Out = "";
	numLines = 1;
	J0x7C:

	if(AndAnd_BoolBool(bSentry, Less_FloatFloat(Y, WinHeight)))
	{
		if(EqualEqual_StrStr(Out, ""))
		{
			AddAdd_Int(i);
			if(Greater_IntInt(Length, 0))
			{
				Out = Left(S, Length);
			}
			else
			{
				Out = S;
			}
		}
		SpacePos = InStr(Out, " ");
		CRPos = InStr(Out, Chr(13));
		bCR = false;
		if(AndAnd_BoolBool(NotEqual_IntInt(CRPos, -1), OrOr_BoolBool(Less_IntInt(CRPos, SpacePos), EqualEqual_IntInt(SpacePos, -1))))
		{
			WordPos = CRPos;
			bCR = true;
		}
		else
		{
			WordPos = SpacePos;
		}
		C.SetPos(0.0000000, 0.0000000);
		if(EqualEqual_IntInt(WordPos, -1))
		{
			temp = Out;
		}
		else
		{
			temp = Concat_StrStr(Left(Out, WordPos), " ");
		}
		AddEqual_IntInt(TotalPos, WordPos);
		TextSize(C, temp, W, H);
		if(AndAnd_BoolBool(EqualEqual_StrStr(Mid(Out, Len(temp)), ""), Greater_IntInt(PaddingLength, 0)))
		{
			Padding = Mid(S, Length, PaddingLength);
			TextSize(C, Padding, pW, pH);
			if(AndAnd_BoolBool(Greater_FloatFloat(Add_FloatFloat(Add_FloatFloat(W, X), pW), WinWidth), Greater_FloatFloat(X, float(0))))
			{
				X = 0.0000000;
				AddEqual_FloatFloat(Y, H);
				AddAdd_Int(numLines);
			}
		}
		else
		{
			if(AndAnd_BoolBool(Greater_FloatFloat(Add_FloatFloat(W, X), WinWidth), Greater_FloatFloat(X, float(0))))
			{
				X = 0.0000000;
				AddEqual_FloatFloat(Y, H);
				AddAdd_Int(numLines);
			}
		}
		if(Not_PreBool(bNoDraw))
		{
			ClipText(C, X, Y, temp, bCheckHotKey);
		}
		AddEqual_FloatFloat(X, W);
		if(bCR)
		{
			X = 0.0000000;
			AddEqual_FloatFloat(Y, H);
			AddAdd_Int(numLines);
		}
		Out = Mid(Out, Len(temp));
		if(AndAnd_BoolBool(EqualEqual_StrStr(Out, ""), Greater_IntInt(i, 0)))
		{
			bSentry = false;
		}
		// [Loop Continue]
		goto J0x7C;
	}
	return numLines;
	return;
}

final function ClipTextWidth(Canvas C, float X, float Y, coerce string S, float W)
{
	ClipText(C, X, Y, S);
	return;
}

final function DrawClippedActor(Canvas C, float X, float Y, Actor A, bool Wireframe, Rotator RotOffset, Vector LocOffset)
{
	local Vector MeshLoc;
	local float FOV;

	FOV = Divide_FloatFloat(Multiply_FloatFloat(GetPlayerOwner().FovAngle, 3.1415930), float(180));
	MeshLoc.X = Divide_FloatFloat(4.0000000, Tan(Divide_FloatFloat(FOV, float(2))));
	MeshLoc.Y = 0.0000000;
	MeshLoc.Z = 0.0000000;
	A.SetRotation(RotOffset);
	A.SetLocation(Add_VectorVector(MeshLoc, LocOffset));
	return;
}

final function DrawUpBevel(Canvas C, float X, float Y, float W, float H, Texture t)
{
	local Region R;

	R = LookAndFeel.BevelUpTL;
	DrawStretchedTextureSegment(C, X, Y, float(R.W), float(R.H), float(R.X), float(R.Y), float(R.W), float(R.H), t);
	R = LookAndFeel.BevelUpT;
	DrawStretchedTextureSegment(C, Add_FloatFloat(X, float(LookAndFeel.BevelUpTL.W)), Y, Subtract_FloatFloat(Subtract_FloatFloat(W, float(LookAndFeel.BevelUpTL.W)), float(LookAndFeel.BevelUpTR.W)), float(R.H), float(R.X), float(R.Y), float(R.W), float(R.H), t);
	R = LookAndFeel.BevelUpTR;
	DrawStretchedTextureSegment(C, Subtract_FloatFloat(Add_FloatFloat(X, W), float(R.W)), Y, float(R.W), float(R.H), float(R.X), float(R.Y), float(R.W), float(R.H), t);
	R = LookAndFeel.BevelUpL;
	DrawStretchedTextureSegment(C, X, Add_FloatFloat(Y, float(LookAndFeel.BevelUpTL.H)), float(R.W), Subtract_FloatFloat(Subtract_FloatFloat(H, float(LookAndFeel.BevelUpTL.H)), float(LookAndFeel.BevelUpBL.H)), float(R.X), float(R.Y), float(R.W), float(R.H), t);
	R = LookAndFeel.BevelUpR;
	DrawStretchedTextureSegment(C, Subtract_FloatFloat(Add_FloatFloat(X, W), float(R.W)), Add_FloatFloat(Y, float(LookAndFeel.BevelUpTL.H)), float(R.W), Subtract_FloatFloat(Subtract_FloatFloat(H, float(LookAndFeel.BevelUpTL.H)), float(LookAndFeel.BevelUpBL.H)), float(R.X), float(R.Y), float(R.W), float(R.H), t);
	R = LookAndFeel.BevelUpBL;
	DrawStretchedTextureSegment(C, X, Subtract_FloatFloat(Add_FloatFloat(Y, H), float(R.H)), float(R.W), float(R.H), float(R.X), float(R.Y), float(R.W), float(R.H), t);
	R = LookAndFeel.BevelUpB;
	DrawStretchedTextureSegment(C, Add_FloatFloat(X, float(LookAndFeel.BevelUpBL.W)), Subtract_FloatFloat(Add_FloatFloat(Y, H), float(R.H)), Subtract_FloatFloat(Subtract_FloatFloat(W, float(LookAndFeel.BevelUpBL.W)), float(LookAndFeel.BevelUpBR.W)), float(R.H), float(R.X), float(R.Y), float(R.W), float(R.H), t);
	R = LookAndFeel.BevelUpBR;
	DrawStretchedTextureSegment(C, Subtract_FloatFloat(Add_FloatFloat(X, W), float(R.W)), Subtract_FloatFloat(Add_FloatFloat(Y, H), float(R.H)), float(R.W), float(R.H), float(R.X), float(R.Y), float(R.W), float(R.H), t);
	R = LookAndFeel.BevelUpArea;
	DrawStretchedTextureSegment(C, Add_FloatFloat(X, float(LookAndFeel.BevelUpTL.W)), Add_FloatFloat(Y, float(LookAndFeel.BevelUpTL.H)), Subtract_FloatFloat(Subtract_FloatFloat(W, float(LookAndFeel.BevelUpBL.W)), float(LookAndFeel.BevelUpBR.W)), Subtract_FloatFloat(Subtract_FloatFloat(H, float(LookAndFeel.BevelUpTL.H)), float(LookAndFeel.BevelUpBL.H)), float(R.X), float(R.Y), float(R.W), float(R.H), t);
	return;
}

final function DrawMiscBevel(Canvas C, float X, float Y, float W, float H, Texture t, int BevelType)
{
	local Region R;

	R = LookAndFeel.MiscBevelTL[BevelType];
	DrawStretchedTextureSegment(C, X, Y, float(R.W), float(R.H), float(R.X), float(R.Y), float(R.W), float(R.H), t);
	R = LookAndFeel.MiscBevelT[BevelType];
	DrawStretchedTextureSegment(C, Add_FloatFloat(X, float(LookAndFeel.MiscBevelTL[BevelType].W)), Y, Subtract_FloatFloat(Subtract_FloatFloat(W, float(LookAndFeel.MiscBevelTL[BevelType].W)), float(LookAndFeel.MiscBevelTR[BevelType].W)), float(R.H), float(R.X), float(R.Y), float(R.W), float(R.H), t);
	R = LookAndFeel.MiscBevelTR[BevelType];
	DrawStretchedTextureSegment(C, Subtract_FloatFloat(Add_FloatFloat(X, W), float(R.W)), Y, float(R.W), float(R.H), float(R.X), float(R.Y), float(R.W), float(R.H), t);
	R = LookAndFeel.MiscBevelL[BevelType];
	DrawStretchedTextureSegment(C, X, Add_FloatFloat(Y, float(LookAndFeel.MiscBevelTL[BevelType].H)), float(R.W), Subtract_FloatFloat(Subtract_FloatFloat(H, float(LookAndFeel.MiscBevelTL[BevelType].H)), float(LookAndFeel.MiscBevelBL[BevelType].H)), float(R.X), float(R.Y), float(R.W), float(R.H), t);
	R = LookAndFeel.MiscBevelR[BevelType];
	DrawStretchedTextureSegment(C, Subtract_FloatFloat(Add_FloatFloat(X, W), float(R.W)), Add_FloatFloat(Y, float(LookAndFeel.MiscBevelTL[BevelType].H)), float(R.W), Subtract_FloatFloat(Subtract_FloatFloat(H, float(LookAndFeel.MiscBevelTL[BevelType].H)), float(LookAndFeel.MiscBevelBL[BevelType].H)), float(R.X), float(R.Y), float(R.W), float(R.H), t);
	R = LookAndFeel.MiscBevelBL[BevelType];
	DrawStretchedTextureSegment(C, X, Subtract_FloatFloat(Add_FloatFloat(Y, H), float(R.H)), float(R.W), float(R.H), float(R.X), float(R.Y), float(R.W), float(R.H), t);
	R = LookAndFeel.MiscBevelB[BevelType];
	DrawStretchedTextureSegment(C, Add_FloatFloat(X, float(LookAndFeel.MiscBevelBL[BevelType].W)), Subtract_FloatFloat(Add_FloatFloat(Y, H), float(R.H)), Subtract_FloatFloat(Subtract_FloatFloat(W, float(LookAndFeel.MiscBevelBL[BevelType].W)), float(LookAndFeel.MiscBevelBR[BevelType].W)), float(R.H), float(R.X), float(R.Y), float(R.W), float(R.H), t);
	R = LookAndFeel.MiscBevelBR[BevelType];
	DrawStretchedTextureSegment(C, Subtract_FloatFloat(Add_FloatFloat(X, W), float(R.W)), Subtract_FloatFloat(Add_FloatFloat(Y, H), float(R.H)), float(R.W), float(R.H), float(R.X), float(R.Y), float(R.W), float(R.H), t);
	R = LookAndFeel.MiscBevelArea[BevelType];
	DrawStretchedTextureSegment(C, Add_FloatFloat(X, float(LookAndFeel.MiscBevelTL[BevelType].W)), Add_FloatFloat(Y, float(LookAndFeel.MiscBevelTL[BevelType].H)), Subtract_FloatFloat(Subtract_FloatFloat(W, float(LookAndFeel.MiscBevelBL[BevelType].W)), float(LookAndFeel.MiscBevelBR[BevelType].W)), Subtract_FloatFloat(Subtract_FloatFloat(H, float(LookAndFeel.MiscBevelTL[BevelType].H)), float(LookAndFeel.MiscBevelBL[BevelType].H)), float(R.X), float(R.Y), float(R.W), float(R.H), t);
	return;
}

final function string RemoveAmpersand(string S)
{
	local string Result, Underline;

	ParseAmpersand(S, Result, Underline, false);
	return Result;
	return;
}

final function byte ParseAmpersand(string S, out string Result, out string Underline, bool bCalcUnderline)
{
	local string temp;
	local int pos, NewPos, i;
	local byte HotKey;

	HotKey = 0;
	pos = 0;
	Result = "";
	Underline = "";
	J0x1F:

	if(true)
	{
		temp = Mid(S, pos);
		NewPos = InStr(temp, "&");
		if(EqualEqual_IntInt(NewPos, -1))
		{
			// [Explicit Break]
			goto J0x154;
		}
		AddEqual_IntInt(pos, NewPos);
		if(EqualEqual_StrStr(Mid(temp, Add_IntInt(NewPos, 1), 1), "&"))
		{
			Result = Concat_StrStr(Concat_StrStr(Result, Left(temp, NewPos)), "&");
			if(bCalcUnderline)
			{
				Underline = Concat_StrStr(Underline, " ");
			}
			AddAdd_Int(pos);
			// [Explicit Continue]
			goto J0x14A;
		}
		if(EqualEqual_IntInt(int(HotKey), 0))
		{
			HotKey = byte(Asc(Caps(Mid(temp, Add_IntInt(NewPos, 1), 1))));
		}
		Result = Concat_StrStr(Result, Left(temp, NewPos));
		if(bCalcUnderline)
		{
			i = 0;
			J0x10E:

			if(Less_IntInt(i, Subtract_IntInt(NewPos, 1)))
			{
				Underline = Concat_StrStr(Underline, " ");
				AddAdd_Int(i);
				// [Loop Continue]
				goto J0x10E;
			}
			Underline = Concat_StrStr(Underline, "_");
		}
		J0x14A:

		AddAdd_Int(pos);
		// [Loop Continue]
		goto J0x1F;
	}
	J0x154:

	Result = Concat_StrStr(Result, temp);
	return HotKey;
	return;
}

final function bool MouseIsOver()
{
	return EqualEqual_ObjectObject(Root.MouseWindow, self);
	return;
}

function ToolTip(string strTip)
{
	if(NotEqual_ObjectObject(ParentWindow, Root))
	{
		ParentWindow.ToolTip(strTip);
	}
	return;
}

final function SetMouseWindow()
{
	Root.MouseWindow = self;
	return;
}

function Texture GetLookAndFeelTexture()
{
	return ParentWindow.GetLookAndFeelTexture();
	return;
}

function bool isActive()
{
	return ParentWindow.isActive();
	return;
}

function SetAcceptsHotKeys(bool bNewAccpetsHotKeys)
{
	if(AndAnd_BoolBool(AndAnd_BoolBool(bNewAccpetsHotKeys, Not_PreBool(bAcceptsHotKeys)), bWindowVisible))
	{
		Root.AddHotkeyWindow(self);
	}
	if(AndAnd_BoolBool(AndAnd_BoolBool(Not_PreBool(bNewAccpetsHotKeys), bAcceptsHotKeys), bWindowVisible))
	{
		Root.RemoveHotkeyWindow(self);
	}
	bAcceptsHotKeys = bNewAccpetsHotKeys;
	return;
}

final function UWindowWindow GetParent(Class<UWindowWindow> ParentClass, optional bool bExactClass)
{
	local UWindowWindow P;

	P = ParentWindow;
	J0x0B:

	if(NotEqual_ObjectObject(P, Root))
	{
		if(bExactClass)
		{
			if(EqualEqual_ObjectObject(P.Class, ParentClass))
			{
				return P;
			}
		}
		else
		{
			if(ClassIsChildOf(P.Class, ParentClass))
			{
				return P;
			}
		}
		P = P.ParentWindow;
		// [Loop Continue]
		goto J0x0B;
	}
	return none;
	return;
}

final function UWindowWindow FindChildWindow(Class<UWindowWindow> ChildClass, optional bool bExactClass)
{
	local UWindowWindow Child, Found;

	Child = LastChildWindow;
	J0x0B:

	if(NotEqual_ObjectObject(Child, none))
	{
		if(bExactClass)
		{
			if(EqualEqual_ObjectObject(Child.Class, ChildClass))
			{
				return Child;
			}
		}
		else
		{
			if(ClassIsChildOf(Child.Class, ChildClass))
			{
				return Child;
			}
		}
		Found = Child.super(UWindowWindow).FindChildWindow(ChildClass);
		if(NotEqual_ObjectObject(Found, none))
		{
			return Found;
		}
		Child = Child.PrevSiblingWindow;
		// [Loop Continue]
		goto J0x0B;
	}
	return none;
	return;
}

function GetDesiredDimensions(out float W, out float H)
{
	local float MaxW, MaxH, tW, tH;
	local UWindowWindow Child;

	MaxW = 0.0000000;
	MaxH = 0.0000000;
	Child = LastChildWindow;
	J0x21:

	if(NotEqual_ObjectObject(Child, none))
	{
		Child.GetDesiredDimensions(tW, tH);
		if(Greater_FloatFloat(tW, MaxW))
		{
			MaxW = tW;
		}
		if(Greater_FloatFloat(tH, MaxH))
		{
			MaxH = tH;
		}
		Child = Child.PrevSiblingWindow;
		// [Loop Continue]
		goto J0x21;
	}
	W = MaxW;
	H = MaxH;
	return;
}

final function TextSize(Canvas C, string Text, out float W, out float H)
{
	C.SetPos(0.0000000, 0.0000000);
	C.TextSize(Text, W, H);
	W = Divide_FloatFloat(W, Root.GUIScale);
	H = Divide_FloatFloat(H, Root.GUIScale);
	return;
}

function ResolutionChanged(float W, float H)
{
	local UWindowWindow Child;

	Child = LastChildWindow;
	J0x0B:

	if(NotEqual_ObjectObject(Child, none))
	{
		Child.ResolutionChanged(W, H);
		Child = Child.PrevSiblingWindow;
		// [Loop Continue]
		goto J0x0B;
	}
	return;
}

function ShowModal(UWindowWindow W)
{
	ModalWindow = W;
	W.ShowWindow();
	W.BringToFront();
	return;
}

function bool WaitModal()
{
	if(AndAnd_BoolBool(NotEqual_ObjectObject(ModalWindow, none), ModalWindow.bWindowVisible))
	{
		return true;
	}
	ModalWindow = none;
	return false;
	return;
}

function WindowHidden()
{
	local UWindowWindow Child;

	Child = LastChildWindow;
	J0x0B:

	if(NotEqual_ObjectObject(Child, none))
	{
		Child.WindowHidden();
		Child = Child.PrevSiblingWindow;
		// [Loop Continue]
		goto J0x0B;
	}
	return;
}

function WindowShown()
{
	local UWindowWindow Child;

	Child = LastChildWindow;
	J0x0B:

	if(NotEqual_ObjectObject(Child, none))
	{
		Child.WindowShown();
		Child = Child.PrevSiblingWindow;
		// [Loop Continue]
		goto J0x0B;
	}
	return;
}

function bool CheckMousePassThrough(float X, float Y)
{
	return false;
	return;
}

final function bool WindowIsVisible()
{
	if(EqualEqual_ObjectObject(self, Root))
	{
		return true;
	}
	if(Not_PreBool(bWindowVisible))
	{
		return false;
	}
	return ParentWindow.super(UWindowWindow).WindowIsVisible();
	return;
}

function SetParent(UWindowWindow NewParent)
{
	HideWindow();
	ParentWindow = NewParent;
	ShowWindow();
	return;
}

function UWindowMessageBox MessageBox(string Title, string Message, UWindowBase.MessageBoxButtons Buttons, UWindowBase.MessageBoxResult ESCResult, optional UWindowBase.MessageBoxResult EnterResult, optional int TimeOut)
{
	local UWindowMessageBox W;
	local UWindowFramedWindow F;

	W = UWindowMessageBox(Root.CreateWindow(Class'UWindow.UWindowMessageBox', 100.0000000, 100.0000000, 100.0000000, 100.0000000, self));
	W.SetupMessageBox(Title, Message, Buttons, ESCResult, EnterResult, TimeOut);
	F = UWindowFramedWindow(GetParent(Class'UWindow.UWindowFramedWindow'));
	if(NotEqual_ObjectObject(F, none))
	{
		F.ShowModal(W);
	}
	else
	{
		Root.ShowModal(W);
	}
	return W;
	return;
}

function MessageBoxDone(UWindowMessageBox W, UWindowBase.MessageBoxResult Result)
{
	return;
}

function NotifyQuitUnreal()
{
	local UWindowWindow Child;

	Child = LastChildWindow;
	J0x0B:

	if(NotEqual_ObjectObject(Child, none))
	{
		Child.NotifyQuitUnreal();
		Child = Child.PrevSiblingWindow;
		// [Loop Continue]
		goto J0x0B;
	}
	return;
}

function NotifyBeforeLevelChange()
{
	local UWindowWindow Child;

	Child = LastChildWindow;
	J0x0B:

	if(NotEqual_ObjectObject(Child, none))
	{
		Child.NotifyBeforeLevelChange();
		Child = Child.PrevSiblingWindow;
		// [Loop Continue]
		goto J0x0B;
	}
	return;
}

function SetCursor(MouseCursor C)
{
	local UWindowWindow Child;

	Cursor = C;
	Child = LastChildWindow;
	J0x16:

	if(NotEqual_ObjectObject(Child, none))
	{
		Child.SetCursor(C);
		Child = Child.PrevSiblingWindow;
		// [Loop Continue]
		goto J0x16;
	}
	return;
}

function NotifyAfterLevelChange()
{
	local UWindowWindow Child;

	Child = LastChildWindow;
	J0x0B:

	if(NotEqual_ObjectObject(Child, none))
	{
		Child.NotifyAfterLevelChange();
		Child = Child.PrevSiblingWindow;
		// [Loop Continue]
		goto J0x0B;
	}
	return;
}

final function ReplaceText(out string Text, string Replace, string With)
{
	local int i;
	local string Input;

	Input = Text;
	Text = "";
	i = InStr(Input, Replace);
	J0x25:

	if(NotEqual_IntInt(i, -1))
	{
		Text = Concat_StrStr(Concat_StrStr(Text, Left(Input, i)), With);
		Input = Mid(Input, Add_IntInt(i, Len(Replace)));
		i = InStr(Input, Replace);
		// [Loop Continue]
		goto J0x25;
	}
	Text = Concat_StrStr(Text, Input);
	return;
}

function StripCRLF(out string Text)
{
	ReplaceText(Text, Concat_StrStr(Chr(13), Chr(10)), "");
	ReplaceText(Text, Chr(13), "");
	ReplaceText(Text, Chr(10), "");
	return;
}
