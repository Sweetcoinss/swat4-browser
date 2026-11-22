class UWindowHSplitter extends UWindowWindow;

var UWindowWindow LeftClientWindow;
var UWindowWindow RightClientWindow;
var bool bSizing;
var float SplitPos;
var float MinWinWidth;
var float OldWinWidth;
var float MaxSplitPos;
var bool bRightGrow;
var bool bSizable;

function Created()
{
	super.Created();
	bAlwaysBehind = true;
	SplitPos = Divide_FloatFloat(WinWidth, float(2));
	MinWinWidth = 24.0000000;
	OldWinWidth = WinWidth;
	return;
}

function Paint(Canvas C, float X, float Y)
{
	local Texture t;

	t = GetLookAndFeelTexture();
	DrawUpBevel(C, SplitPos, 0.0000000, 7.0000000, WinHeight, t);
	return;
}

function BeforePaint(Canvas C, float X, float Y)
{
	local float NewW, NewH;

	if(AndAnd_BoolBool(NotEqual_FloatFloat(OldWinWidth, WinWidth), Not_PreBool(bRightGrow)))
	{
		SplitPos = Subtract_FloatFloat(Add_FloatFloat(SplitPos, WinWidth), OldWinWidth);
	}
	SplitPos = FClamp(SplitPos, MinWinWidth, Subtract_FloatFloat(Subtract_FloatFloat(WinWidth, float(7)), MinWinWidth));
	if(NotEqual_FloatFloat(MaxSplitPos, float(0)))
	{
		SplitPos = FClamp(SplitPos, 0.0000000, MaxSplitPos);
	}
	NewW = SplitPos;
	NewH = WinHeight;
	if(OrOr_BoolBool(NotEqual_FloatFloat(NewH, LeftClientWindow.WinHeight), NotEqual_FloatFloat(NewW, LeftClientWindow.WinWidth)))
	{
		LeftClientWindow.SetSize(NewW, NewH);
	}
	LeftClientWindow.WinTop = 0.0000000;
	LeftClientWindow.WinLeft = 0.0000000;
	NewW = Subtract_FloatFloat(Subtract_FloatFloat(WinWidth, SplitPos), float(7));
	if(OrOr_BoolBool(NotEqual_FloatFloat(NewH, RightClientWindow.WinHeight), NotEqual_FloatFloat(NewW, RightClientWindow.WinWidth)))
	{
		RightClientWindow.SetSize(NewW, NewH);
	}
	RightClientWindow.WinTop = 0.0000000;
	RightClientWindow.WinLeft = Add_FloatFloat(SplitPos, float(7));
	OldWinWidth = WinWidth;
	return;
}

function LMouseDown(float X, float Y)
{
	super.LMouseDown(X, Y);
	if(AndAnd_BoolBool(AndAnd_BoolBool(bSizable, GreaterEqual_FloatFloat(X, SplitPos)), LessEqual_FloatFloat(X, Add_FloatFloat(SplitPos, float(7)))))
	{
		bSizing = true;
		Root.CaptureMouse();
	}
	return;
}

function MouseMove(float X, float Y)
{
	if(AndAnd_BoolBool(AndAnd_BoolBool(bSizable, GreaterEqual_FloatFloat(X, SplitPos)), LessEqual_FloatFloat(X, Add_FloatFloat(SplitPos, float(7)))))
	{
		Cursor = Root.HSplitCursor;
	}
	else
	{
		Cursor = Root.NormalCursor;
	}
	if(AndAnd_BoolBool(bSizing, bMouseDown))
	{
		SplitPos = X;
	}
	else
	{
		bSizing = false;
	}
	return;
}

defaultproperties
{
	bSizable=true
}