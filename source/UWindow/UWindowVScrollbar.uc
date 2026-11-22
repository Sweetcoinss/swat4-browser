class UWindowVScrollbar extends UWindowWindow;

var UWindowSBUpButton UpButton;
var UWindowSBDownButton DownButton;
var bool bDisabled;
var float MinPos;
var float MaxPos;
var float MaxVisible;
var float pos;
var float ThumbStart;
var float ThumbHeight;
var float NextClickTime;
var float DragY;
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
	DownButton.bDisabled = bDisabled;
	UpButton.bDisabled = bDisabled;
	if(bDisabled)
	{
		pos = 0.0000000;
	}
	else
	{
		ThumbStart = Divide_FloatFloat(Multiply_FloatFloat(Subtract_FloatFloat(pos, MinPos), Subtract_FloatFloat(WinHeight, Multiply_FloatFloat(float(2), LookAndFeel.Size_ScrollbarButtonHeight))), Subtract_FloatFloat(Add_FloatFloat(MaxPos, MaxVisible), MinPos));
		ThumbHeight = Divide_FloatFloat(Multiply_FloatFloat(MaxVisible, Subtract_FloatFloat(WinHeight, Multiply_FloatFloat(float(2), LookAndFeel.Size_ScrollbarButtonHeight))), Subtract_FloatFloat(Add_FloatFloat(MaxPos, MaxVisible), MinPos));
		if(Less_FloatFloat(ThumbHeight, LookAndFeel.Size_MinScrollbarHeight))
		{
			ThumbHeight = LookAndFeel.Size_MinScrollbarHeight;
		}
		if(Greater_FloatFloat(Add_FloatFloat(ThumbHeight, ThumbStart), Subtract_FloatFloat(WinHeight, Multiply_FloatFloat(float(2), LookAndFeel.Size_ScrollbarButtonHeight))))
		{
			ThumbStart = Subtract_FloatFloat(Subtract_FloatFloat(WinHeight, Multiply_FloatFloat(float(2), LookAndFeel.Size_ScrollbarButtonHeight)), ThumbHeight);
		}
		ThumbStart = Add_FloatFloat(ThumbStart, LookAndFeel.Size_ScrollbarButtonHeight);
	}
	return;
}

function Created()
{
	super.Created();
	UpButton = UWindowSBUpButton(CreateWindow(Class'UWindow.UWindowSBUpButton', 0.0000000, 0.0000000, 12.0000000, 10.0000000));
	DownButton = UWindowSBDownButton(CreateWindow(Class'UWindow.UWindowSBDownButton', 0.0000000, Subtract_FloatFloat(WinHeight, float(10)), 12.0000000, 10.0000000));
	return;
}

function BeforePaint(Canvas C, float X, float Y)
{
	UpButton.WinTop = 0.0000000;
	UpButton.WinLeft = 0.0000000;
	UpButton.WinWidth = LookAndFeel.Size_ScrollbarWidth;
	UpButton.WinHeight = LookAndFeel.Size_ScrollbarButtonHeight;
	DownButton.WinTop = Subtract_FloatFloat(WinHeight, LookAndFeel.Size_ScrollbarButtonHeight);
	DownButton.WinLeft = 0.0000000;
	DownButton.WinWidth = LookAndFeel.Size_ScrollbarWidth;
	DownButton.WinHeight = LookAndFeel.Size_ScrollbarButtonHeight;
	CheckRange();
	return;
}

function Paint(Canvas C, float X, float Y)
{
	LookAndFeel.SB_VDraw(self, C);
	return;
}

function LMouseDown(float X, float Y)
{
	super.LMouseDown(X, Y);
	if(bDisabled)
	{
		return;
	}
	if(Less_FloatFloat(Y, ThumbStart))
	{
		Scroll(Subtract_PreFloat(Subtract_FloatFloat(MaxVisible, float(1))));
		NextClickTime = Add_FloatFloat(GetLevel().TimeSeconds, 0.5000000);
		return;
	}
	if(Greater_FloatFloat(Y, Add_FloatFloat(ThumbStart, ThumbHeight)))
	{
		Scroll(Subtract_FloatFloat(MaxVisible, float(1)));
		NextClickTime = Add_FloatFloat(GetLevel().TimeSeconds, 0.5000000);
		return;
	}
	if(AndAnd_BoolBool(GreaterEqual_FloatFloat(Y, ThumbStart), LessEqual_FloatFloat(Y, Add_FloatFloat(ThumbStart, ThumbHeight))))
	{
		DragY = Subtract_FloatFloat(Y, ThumbStart);
		bDragging = true;
		Root.CaptureMouse();
		return;
	}
	return;
}

function Tick(float Delta)
{
	local bool bUp, bDown;
	local float X, Y;

	if(bDragging)
	{
		return;
	}
	bUp = false;
	bDown = false;
	if(bMouseDown)
	{
		GetMouseXY(X, Y);
		bUp = Less_FloatFloat(Y, ThumbStart);
		bDown = Greater_FloatFloat(Y, Add_FloatFloat(ThumbStart, ThumbHeight));
	}
	if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(bMouseDown, Greater_FloatFloat(NextClickTime, float(0))), Less_FloatFloat(NextClickTime, GetLevel().TimeSeconds)), bUp))
	{
		Scroll(Subtract_PreFloat(Subtract_FloatFloat(MaxVisible, float(1))));
		NextClickTime = Add_FloatFloat(GetLevel().TimeSeconds, 0.1000000);
	}
	if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(bMouseDown, Greater_FloatFloat(NextClickTime, float(0))), Less_FloatFloat(NextClickTime, GetLevel().TimeSeconds)), bDown))
	{
		Scroll(Subtract_FloatFloat(MaxVisible, float(1)));
		NextClickTime = Add_FloatFloat(GetLevel().TimeSeconds, 0.1000000);
	}
	if(OrOr_BoolBool(Not_PreBool(bMouseDown), AndAnd_BoolBool(Not_PreBool(bUp), Not_PreBool(bDown))))
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

		if(AndAnd_BoolBool(Less_FloatFloat(Y, Add_FloatFloat(ThumbStart, DragY)), Greater_FloatFloat(pos, MinPos)))
		{
			Scroll(-1.0000000);
			// [Loop Continue]
			goto J0x21;
		}
		J0x56:

		if(AndAnd_BoolBool(Greater_FloatFloat(Y, Add_FloatFloat(ThumbStart, DragY)), Less_FloatFloat(pos, MaxPos)))
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
