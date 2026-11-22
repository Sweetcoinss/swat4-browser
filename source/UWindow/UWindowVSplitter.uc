class UWindowVSplitter extends UWindowWindow;

var UWindowWindow TopClientWindow;
var UWindowWindow BottomClientWindow;
var bool bSizing;
var float SplitPos;
var float MinWinHeight;
var float MaxSplitPos;
var float OldWinHeight;
var bool bBottomGrow;
var bool bSizable;

function Created()
{
	super.Created();
	bAlwaysBehind = true;
	SplitPos = Divide_FloatFloat(WinHeight, float(2));
	MinWinHeight = 24.0000000;
	OldWinHeight = WinHeight;
	return;
}

function Paint(Canvas C, float X, float Y)
{
	local Texture t;

	t = GetLookAndFeelTexture();
	DrawUpBevel(C, 0.0000000, SplitPos, WinWidth, 7.0000000, t);
	return;
}

function BeforePaint(Canvas C, float X, float Y)
{
	local float NewW, NewH;

	if(AndAnd_BoolBool(NotEqual_FloatFloat(OldWinHeight, WinHeight), Not_PreBool(bBottomGrow)))
	{
		SplitPos = Subtract_FloatFloat(Add_FloatFloat(SplitPos, WinHeight), OldWinHeight);
	}
	SplitPos = FClamp(SplitPos, MinWinHeight, Subtract_FloatFloat(Subtract_FloatFloat(WinHeight, float(7)), MinWinHeight));
	if(NotEqual_FloatFloat(MaxSplitPos, float(0)))
	{
		SplitPos = FClamp(SplitPos, 0.0000000, MaxSplitPos);
	}
	NewW = WinWidth;
	NewH = SplitPos;
	if(OrOr_BoolBool(NotEqual_FloatFloat(NewW, TopClientWindow.WinWidth), NotEqual_FloatFloat(NewH, TopClientWindow.WinHeight)))
	{
		TopClientWindow.SetSize(NewW, NewH);
	}
	NewH = Subtract_FloatFloat(Subtract_FloatFloat(WinHeight, SplitPos), float(7));
	if(OrOr_BoolBool(NotEqual_FloatFloat(NewW, BottomClientWindow.WinWidth), NotEqual_FloatFloat(NewH, BottomClientWindow.WinHeight)))
	{
		BottomClientWindow.SetSize(NewW, NewH);
	}
	BottomClientWindow.WinTop = Add_FloatFloat(SplitPos, float(7));
	BottomClientWindow.WinLeft = 0.0000000;
	OldWinHeight = WinHeight;
	return;
}

function LMouseDown(float X, float Y)
{
	super.LMouseDown(X, Y);
	if(AndAnd_BoolBool(AndAnd_BoolBool(bSizable, GreaterEqual_FloatFloat(Y, SplitPos)), LessEqual_FloatFloat(Y, Add_FloatFloat(SplitPos, float(7)))))
	{
		bSizing = true;
		Root.CaptureMouse();
	}
	return;
}

function MouseMove(float X, float Y)
{
	if(AndAnd_BoolBool(AndAnd_BoolBool(bSizable, GreaterEqual_FloatFloat(Y, SplitPos)), LessEqual_FloatFloat(Y, Add_FloatFloat(SplitPos, float(7)))))
	{
		Cursor = Root.VSplitCursor;
	}
	else
	{
		Cursor = Root.NormalCursor;
	}
	if(AndAnd_BoolBool(bSizing, bMouseDown))
	{
		SplitPos = Y;
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