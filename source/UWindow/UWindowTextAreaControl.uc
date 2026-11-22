class UWindowTextAreaControl extends UWindowDialogControl;

var string TextArea[750];
var string Prompt;
var int Font;
var Font AbsoluteFont;
var int BufSize;
var int Head;
var int Tail;
var int Lines;
var int VisibleRows;
var bool bCursor;
var bool bScrollable;
var bool bShowCaret;
var bool bScrollOnResize;
var UWindowVScrollbar VertSB;
var float LastDrawTime;

function Created()
{
	super.Created();
	LastDrawTime = GetLevel().TimeSeconds;
	return;
}

function SetScrollable(bool newScrollable)
{
	bScrollable = newScrollable;
	if(newScrollable)
	{
		VertSB = UWindowVScrollbar(CreateWindow(Class'UWindow.UWindowVScrollbar', Subtract_FloatFloat(WinWidth, float(12)), 0.0000000, 12.0000000, WinHeight));
		VertSB.bAlwaysOnTop = true;
	}
	else
	{
		if(NotEqual_ObjectObject(VertSB, none))
		{
			VertSB.Close();
			VertSB = none;
		}
	}
	return;
}

function BeforePaint(Canvas C, float X, float Y)
{
	super.BeforePaint(C, X, Y);
	if(NotEqual_ObjectObject(VertSB, none))
	{
		VertSB.WinTop = 0.0000000;
		VertSB.WinHeight = WinHeight;
		VertSB.WinWidth = LookAndFeel.Size_ScrollbarWidth;
		VertSB.WinLeft = Subtract_FloatFloat(WinWidth, LookAndFeel.Size_ScrollbarWidth);
	}
	return;
}

function SetAbsoluteFont(Font F)
{
	AbsoluteFont = F;
	return;
}

function Paint(Canvas C, float X, float Y)
{
	local int i, Line, TempHead, TempTail;
	local float XL, YL, W, H;

	if(NotEqual_ObjectObject(AbsoluteFont, none))
	{
		C.Font = AbsoluteFont;
	}
	else
	{
		C.Font = Root.Fonts[Font];
	}
	C.SetDrawColor(byte(255), byte(255), byte(255));
	TextSize(C, "TEST", XL, YL);
	VisibleRows = int(Divide_FloatFloat(WinHeight, YL));
	TempHead = Head;
	TempTail = Tail;
	Line = TempHead;
	TextArea[Line] = Prompt;
	if(EqualEqual_StrStr(Prompt, ""))
	{
		SubtractSubtract_Int(Line);
		if(Less_IntInt(Line, 0))
		{
			AddEqual_IntInt(Line, BufSize);
		}
	}
	if(bScrollable)
	{
		if(GreaterEqual_FloatFloat(Subtract_FloatFloat(VertSB.MaxPos, VertSB.pos), float(0)))
		{
			SubtractEqual_IntInt(Line, int(Subtract_FloatFloat(VertSB.MaxPos, VertSB.pos)));
			SubtractEqual_IntInt(TempTail, int(Subtract_FloatFloat(VertSB.MaxPos, VertSB.pos)));
			if(Less_IntInt(Line, 0))
			{
				AddEqual_IntInt(Line, BufSize);
			}
			if(Less_IntInt(TempTail, 0))
			{
				AddEqual_IntInt(TempTail, BufSize);
			}
		}
	}
	if(Not_PreBool(bCursor))
	{
		bShowCaret = false;
	}
	else
	{
		if(OrOr_BoolBool(Greater_FloatFloat(GetLevel().TimeSeconds, Add_FloatFloat(LastDrawTime, 0.3000000)), Less_FloatFloat(GetLevel().TimeSeconds, LastDrawTime)))
		{
			LastDrawTime = GetLevel().TimeSeconds;
			bShowCaret = Not_PreBool(bShowCaret);
		}
	}
	i = 0;
	J0x212:

	if(Less_IntInt(i, Add_IntInt(VisibleRows, 1)))
	{
		ClipText(C, 2.0000000, Subtract_FloatFloat(WinHeight, Multiply_FloatFloat(YL, float(Add_IntInt(i, 1)))), TextArea[Line]);
		if(AndAnd_BoolBool(EqualEqual_IntInt(Line, Head), bShowCaret))
		{
			TextSize(C, TextArea[Line], W, H);
			ClipText(C, W, Subtract_FloatFloat(WinHeight, Multiply_FloatFloat(YL, float(Add_IntInt(i, 1)))), "|");
		}
		if(EqualEqual_IntInt(TempTail, Line))
		{
			// [Explicit Break]
			goto J0x2F6;
		}
		SubtractSubtract_Int(Line);
		if(Less_IntInt(Line, 0))
		{
			AddEqual_IntInt(Line, BufSize);
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x212;
	}
	J0x2F6:

	return;
}

function AddText(string NewLine)
{
	TextArea[Head] = NewLine;
	Head = int(Percent_FloatFloat(float(Add_IntInt(Head, 1)), float(BufSize)));
	if(EqualEqual_IntInt(Head, Tail))
	{
		Tail = int(Percent_FloatFloat(float(Add_IntInt(Tail, 1)), float(BufSize)));
	}
	Lines = Subtract_IntInt(Head, Tail);
	if(Less_IntInt(Lines, 0))
	{
		AddEqual_IntInt(Lines, BufSize);
	}
	if(bScrollable)
	{
		VertSB.SetRange(0.0000000, float(Lines), float(VisibleRows));
		VertSB.pos = VertSB.MaxPos;
	}
	return;
}

function Resized()
{
	if(bScrollable)
	{
		VertSB.SetRange(0.0000000, float(Lines), float(VisibleRows));
		if(bScrollOnResize)
		{
			VertSB.pos = VertSB.MaxPos;
		}
	}
	return;
}

function SetPrompt(string NewPrompt)
{
	Prompt = NewPrompt;
	return;
}

function Clear()
{
	TextArea[0] = "";
	Head = 0;
	Tail = 0;
	return;
}

defaultproperties
{
	BufSize=750
	bScrollOnResize=true
}