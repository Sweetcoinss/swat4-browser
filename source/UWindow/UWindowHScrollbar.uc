class UWindowHScrollbar extends UWindowWindow;

var UWindowSBLeftButton LeftButton;
var UWindowSBRightButton RightButton;
var bool bDisabled;
var float MinPos;
var float MaxPos;
var float MaxVisible;
var float pos;
var float ThumbStart;
var float ThumbWidth;
var float NextClickTime;
var float DragX;
var bool bDragging;
var float ScrollAmount;

function Show(float P)
{
	if(Less_FloatFloat(P, float(0)))
	{
		return;
	}
	if(Greater_FloatFloat(P, Add_FloatFloat(MaxPos, MaxVisible)))
	{
		return;
	}
	J0x27:

	if(Less_FloatFloat(P, pos))
	{
		if(Not_PreBool(Scroll(-1.0000000)))
		{
			// [Explicit Break]
			goto J0x4C;
		}
		// [Loop Continue]
		goto J0x27;
	}
	J0x4C:

	if(Greater_FloatFloat(Subtract_FloatFloat(P, pos), Subtract_FloatFloat(MaxVisible, float(1))))
	{
		if(Not_PreBool(Scroll(1.0000000)))
		{
			// [Explicit Break]
			goto J0x7D;
		}
		// [Loop Continue]
		goto J0x4C;
	}
	J0x7D:

	return;
}

function bool Scroll(float Delta)
{
	local float OldPos;

	OldPos = pos;
	pos = Add_FloatFloat(pos, Delta);
	CheckRange();
	return EqualEqual_FloatFloat(pos, Add_FloatFloat(OldPos, Delta));
	return;
}

function SetRange(float NewMinPos, float NewMaxPos, float NewMaxVisible, optional float NewScrollAmount)
{
	if(EqualEqual_FloatFloat(NewScrollAmount, float(0)))
	{
		NewScrollAmount = 1.0000000;
	}
	ScrollAmount = NewScrollAmount;
	MinPos = NewMinPos;
	MaxPos = Subtract_FloatFloat(NewMaxPos, NewMaxVisible);
	MaxVisible = NewMaxVisible;
	CheckRange();
	return;
}

function CheckRange()
{
	if(Less_FloatFloat(pos, MinPos))
	{
		pos = MinPos;
	}
	else
	{
		if(Greater_FloatFloat(pos, MaxPos))
		{
			pos = MaxPos;
		}
	}
	bDisabled = LessEqual_FloatFloat(MaxPos, MinPos);
	LeftButton.bDisabled = bDisabled;
	RightButton.bDisabled = bDisabled;
	if(bDisabled)
	{
		pos = 0.0000000;
	}
	else
	{
		ThumbStart = Divide_FloatFloat(Multiply_FloatFloat(Subtract_FloatFloat(pos, MinPos), Subtract_FloatFloat(WinWidth, Multiply_FloatFloat(float(2), LookAndFeel.Size_ScrollbarButtonHeight))), Subtract_FloatFloat(Add_FloatFloat(MaxPos, MaxVisible), MinPos));
		ThumbWidth = Divide_FloatFloat(Multiply_FloatFloat(MaxVisible, Subtract_FloatFloat(WinWidth, Multiply_FloatFloat(float(2), LookAndFeel.Size_ScrollbarButtonHeight))), Subtract_FloatFloat(Add_FloatFloat(MaxPos, MaxVisible), MinPos));
		if(Less_FloatFloat(ThumbWidth, LookAndFeel.Size_MinScrollbarHeight))
		{
			ThumbWidth = LookAndFeel.Size_MinScrollbarHeight;
		}
		if(Greater_FloatFloat(Add_FloatFloat(ThumbWidth, ThumbStart), Subtract_FloatFloat(WinWidth, Multiply_FloatFloat(float(2), LookAndFeel.Size_ScrollbarButtonHeight))))
		{
			ThumbStart = Subtract_FloatFloat(Subtract_FloatFloat(WinWidth, Multiply_FloatFloat(float(2), LookAndFeel.Size_ScrollbarButtonHeight)), ThumbWidth);
		}
		ThumbStart = Add_FloatFloat(ThumbStart, LookAndFeel.Size_ScrollbarButtonHeight);
	}
	return;
}

function Created()
{
	super.Created();
	LeftButton = UWindowSBLeftButton(CreateWindow(Class'UWindow.UWindowSBLeftButton', 0.0000000, 0.0000000, 10.0000000, 12.0000000));
	RightButton = UWindowSBRightButton(CreateWindow(Class'UWindow.UWindowSBRightButton', Subtract_FloatFloat(WinWidth, float(10)), 0.0000000, 10.0000000, 12.0000000));
	return;
}

function BeforePaint(Canvas C, float X, float Y)
{
	LeftButton.WinTop = 0.0000000;
	LeftButton.WinLeft = 0.0000000;
	LeftButton.WinWidth = LookAndFeel.Size_ScrollbarButtonHeight;
	LeftButton.WinHeight = LookAndFeel.Size_ScrollbarWidth;
	RightButton.WinTop = 0.0000000;
	RightButton.WinLeft = Subtract_FloatFloat(WinWidth, LookAndFeel.Size_ScrollbarButtonHeight);
	RightButton.WinWidth = LookAndFeel.Size_ScrollbarButtonHeight;
	RightButton.WinHeight = LookAndFeel.Size_ScrollbarWidth;
	CheckRange();
	return;
}

function Paint(Canvas C, float X, float Y)
{
	LookAndFeel.SB_HDraw(self, C);
	return;
}

function LMouseDown(float X, float Y)
{
	super.LMouseDown(X, Y);
	if(bDisabled)
	{
		return;
	}
	if(Less_FloatFloat(X, ThumbStart))
	{
		Scroll(Subtract_PreFloat(Subtract_FloatFloat(MaxVisible, float(1))));
		NextClickTime = Add_FloatFloat(GetLevel().TimeSeconds, 0.5000000);
		return;
	}
	if(Greater_FloatFloat(X, Add_FloatFloat(ThumbStart, ThumbWidth)))
	{
		Scroll(Subtract_FloatFloat(MaxVisible, float(1)));
		NextClickTime = Add_FloatFloat(GetLevel().TimeSeconds, 0.5000000);
		return;
	}
	if(AndAnd_BoolBool(GreaterEqual_FloatFloat(X, ThumbStart), LessEqual_FloatFloat(X, Add_FloatFloat(ThumbStart, ThumbWidth))))
	{
		DragX = Subtract_FloatFloat(X, ThumbStart);
		bDragging = true;
		Root.CaptureMouse();
		return;
	}
	return;
}

function Tick(float Delta)
{
	local bool bLeft, bRight;
	local float X, Y;

	if(bDragging)
	{
		return;
	}
	bLeft = false;
	bRight = false;
	if(bMouseDown)
	{
		GetMouseXY(X, Y);
		bLeft = Less_FloatFloat(X, ThumbStart);
		bRight = Greater_FloatFloat(X, Add_FloatFloat(ThumbStart, ThumbWidth));
	}
	if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(bMouseDown, Greater_FloatFloat(NextClickTime, float(0))), Less_FloatFloat(NextClickTime, GetLevel().TimeSeconds)), bLeft))
	{
		Scroll(Subtract_PreFloat(Subtract_FloatFloat(MaxVisible, float(1))));
		NextClickTime = Add_FloatFloat(GetLevel().TimeSeconds, 0.1000000);
	}
	if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(bMouseDown, Greater_FloatFloat(NextClickTime, float(0))), Less_FloatFloat(NextClickTime, GetLevel().TimeSeconds)), bRight))
	{
		Scroll(Subtract_FloatFloat(MaxVisible, float(1)));
		NextClickTime = Add_FloatFloat(GetLevel().TimeSeconds, 0.1000000);
	}
	if(OrOr_BoolBool(Not_PreBool(bMouseDown), AndAnd_BoolBool(Not_PreBool(bLeft), Not_PreBool(bRight))))
	{
		NextClickTime = 0.0000000;
	}
	return;
}

function MouseMove(float X, float Y)
{
	if(AndAnd_BoolBool(AndAnd_BoolBool(bDragging, bMouseDown), Not_PreBool(bDisabled)))
	{
		J0x21:

		if(AndAnd_BoolBool(Less_FloatFloat(X, Add_FloatFloat(ThumbStart, DragX)), Greater_FloatFloat(pos, MinPos)))
		{
			Scroll(-1.0000000);
			// [Loop Continue]
			goto J0x21;
		}
		J0x56:

		if(AndAnd_BoolBool(Greater_FloatFloat(X, Add_FloatFloat(ThumbStart, DragX)), Less_FloatFloat(pos, MaxPos)))
		{
			Scroll(1.0000000);
			// [Loop Continue]
			goto J0x56;
		}
	}
	else
	{
		bDragging = false;
	}
	return;
}
