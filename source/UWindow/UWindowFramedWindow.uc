class UWindowFramedWindow extends UWindowWindow;

var Class<UWindowWindow> ClientClass;
var UWindowWindow ClientArea;
var localized string WindowTitle;
var string StatusBarText;
var float MoveX;
var float MoveY;
var float MinWinWidth;
var float MinWinHeight;
var bool bTLSizing;
var bool bTSizing;
var bool bTRSizing;
var bool bLSizing;
var bool bRSizing;
var bool bBLSizing;
var bool bBSizing;
var bool bBRSizing;
var bool bMoving;
var bool bSizable;
var bool bStatusBar;
var UWindowFrameCloseBox CloseBox;

function Created()
{
	super.Created();
	MinWinWidth = 50.0000000;
	MinWinHeight = 50.0000000;
	ClientArea = CreateWindow(ClientClass, 4.0000000, 16.0000000, Subtract_FloatFloat(WinWidth, float(8)), Subtract_FloatFloat(WinHeight, float(20)), OwnerWindow);
	CloseBox = UWindowFrameCloseBox(CreateWindow(Class'UWindow.UWindowFrameCloseBox', Subtract_FloatFloat(WinWidth, float(20)), Subtract_FloatFloat(WinHeight, float(20)), 11.0000000, 10.0000000));
	return;
}

function Texture GetLookAndFeelTexture()
{
	return LookAndFeel.GetTexture(self);
	return;
}

function bool isActive()
{
	return EqualEqual_ObjectObject(ParentWindow.ActiveWindow, self);
	return;
}

function BeforePaint(Canvas C, float X, float Y)
{
	super.BeforePaint(C, X, Y);
	Resized();
	LookAndFeel.FW_SetupFrameButtons(self, C);
	return;
}

function Paint(Canvas C, float X, float Y)
{
	LookAndFeel.FW_DrawWindowFrame(self, C);
	return;
}

function LMouseDown(float X, float Y)
{
	local UWindowBase.FrameHitTest H;

	H = LookAndFeel.FW_HitTest(self, X, Y);
	super.LMouseDown(X, Y);
	if(EqualEqual_IntInt(int(H), int(8)))
	{
		MoveX = X;
		MoveY = Y;
		bMoving = true;
		Root.CaptureMouse();
		return;
	}
	if(bSizable)
	{
		switch(H)
		{
			case 0:
				bTLSizing = true;
				Root.CaptureMouse();
				return;
			case 2:
				bTRSizing = true;
				Root.CaptureMouse();
				return;
			case 5:
				bBLSizing = true;
				Root.CaptureMouse();
				return;
			case 7:
				bBRSizing = true;
				Root.CaptureMouse();
				return;
			case 1:
				bTSizing = true;
				Root.CaptureMouse();
				return;
			case 6:
				bBSizing = true;
				Root.CaptureMouse();
				return;
			case 3:
				bLSizing = true;
				Root.CaptureMouse();
				return;
			case 4:
				bRSizing = true;
				Root.CaptureMouse();
				return;
			default:
				break;
			}
	}
	else
	{
		return;
	}
}

function Resized()
{
	local Region R;

	if(EqualEqual_ObjectObject(ClientArea, none))
	{
		Log(Concat_StrStr("Client Area is None for ", string(self)));
		return;
	}
	R = LookAndFeel.FW_GetClientArea(self);
	ClientArea.WinLeft = float(R.X);
	ClientArea.WinTop = float(R.Y);
	if(OrOr_BoolBool(NotEqual_FloatFloat(float(R.W), ClientArea.WinWidth), NotEqual_FloatFloat(float(R.H), ClientArea.WinHeight)))
	{
		ClientArea.SetSize(float(R.W), float(R.H));
	}
	return;
}

function MouseMove(float X, float Y)
{
	local float OldW, OldH;
	local UWindowBase.FrameHitTest H;

	H = LookAndFeel.FW_HitTest(self, X, Y);
	if(AndAnd_BoolBool(bMoving, bMouseDown))
	{
		WinLeft = float(int(Subtract_FloatFloat(Add_FloatFloat(WinLeft, X), MoveX)));
		WinTop = float(int(Subtract_FloatFloat(Add_FloatFloat(WinTop, Y), MoveY)));
	}
	else
	{
		bMoving = false;
	}
	Cursor = Root.NormalCursor;
	if(AndAnd_BoolBool(bSizable, Not_PreBool(bMoving)))
	{
		switch(H)
		{
			case 0:
			case 7:
				Cursor = Root.DiagCursor1;
				break;
			case 2:
			case 5:
				Cursor = Root.DiagCursor2;
				break;
			case 3:
			case 4:
				Cursor = Root.WECursor;
				break;
			case 1:
			case 6:
				Cursor = Root.NSCursor;
				break;
			default:
				break;
		}
	}
	else
	{
		if(AndAnd_BoolBool(bTLSizing, bMouseDown))
		{
			Cursor = Root.DiagCursor1;
			OldW = WinWidth;
			OldH = WinHeight;
			SetSize(float(Max(int(MinWinWidth), int(Subtract_FloatFloat(WinWidth, X)))), float(Max(int(MinWinHeight), int(Subtract_FloatFloat(WinHeight, Y)))));
			WinLeft = float(int(Subtract_FloatFloat(Add_FloatFloat(WinLeft, OldW), WinWidth)));
			WinTop = float(int(Subtract_FloatFloat(Add_FloatFloat(WinTop, OldH), WinHeight)));
		}
		else
		{
			bTLSizing = false;
		}
		if(AndAnd_BoolBool(bTSizing, bMouseDown))
		{
			Cursor = Root.NSCursor;
			OldH = WinHeight;
			SetSize(WinWidth, float(Max(int(MinWinHeight), int(Subtract_FloatFloat(WinHeight, Y)))));
			WinTop = float(int(Subtract_FloatFloat(Add_FloatFloat(WinTop, OldH), WinHeight)));
		}
		else
		{
			bTSizing = false;
		}
		if(AndAnd_BoolBool(bTRSizing, bMouseDown))
		{
			Cursor = Root.DiagCursor2;
			OldH = WinHeight;
			SetSize(float(Max(int(MinWinWidth), int(X))), float(Max(int(MinWinHeight), int(Subtract_FloatFloat(WinHeight, Y)))));
			WinTop = float(int(Subtract_FloatFloat(Add_FloatFloat(WinTop, OldH), WinHeight)));
		}
		else
		{
			bTRSizing = false;
		}
		if(AndAnd_BoolBool(bLSizing, bMouseDown))
		{
			Cursor = Root.WECursor;
			OldW = WinWidth;
			SetSize(float(Max(int(MinWinWidth), int(Subtract_FloatFloat(WinWidth, X)))), WinHeight);
			WinLeft = float(int(Subtract_FloatFloat(Add_FloatFloat(WinLeft, OldW), WinWidth)));
		}
		else
		{
			bLSizing = false;
		}
		if(AndAnd_BoolBool(bRSizing, bMouseDown))
		{
			Cursor = Root.WECursor;
			SetSize(float(Max(int(MinWinWidth), int(X))), WinHeight);
		}
		else
		{
			bRSizing = false;
		}
		if(AndAnd_BoolBool(bBLSizing, bMouseDown))
		{
			Cursor = Root.DiagCursor2;
			OldW = WinWidth;
			SetSize(float(Max(int(MinWinWidth), int(Subtract_FloatFloat(WinWidth, X)))), float(Max(int(MinWinHeight), int(Y))));
			WinLeft = float(int(Subtract_FloatFloat(Add_FloatFloat(WinLeft, OldW), WinWidth)));
		}
		else
		{
			bBLSizing = false;
		}
		if(AndAnd_BoolBool(bBSizing, bMouseDown))
		{
			Cursor = Root.NSCursor;
			SetSize(WinWidth, float(Max(int(MinWinHeight), int(Y))));
		}
		else
		{
			bBSizing = false;
		}
		if(AndAnd_BoolBool(bBRSizing, bMouseDown))
		{
			Cursor = Root.DiagCursor1;
			SetSize(float(Max(int(MinWinWidth), int(X))), float(Max(int(MinWinHeight), int(Y))));
		}
		else
		{
			bBRSizing = false;
		}
		return;
	}
}

function ToolTip(string strTip)
{
	StatusBarText = strTip;
	return;
}

function WindowEvent(UWindowWindow.WinMessage msg, Canvas C, float X, float Y, int Key)
{
	if(OrOr_BoolBool(EqualEqual_IntInt(int(msg), int(9)), Not_PreBool(WaitModal())))
	{
		super.WindowEvent(msg, C, X, Y, Key);
	}
	return;
}

function WindowHidden()
{
	super.WindowHidden();
	LookAndFeel.PlayMenuSound(self, 4);
	return;
}

defaultproperties
{
	ClientClass=Class'UWindow.UWindowClientWindow'
}