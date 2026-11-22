class UWindowWrappedTextArea extends UWindowTextAreaControl;

function Paint(Canvas C, float X, float Y)
{
	local int i, Line, TempHead, TempTail;
	local float XL, YL;

	C.Font = Root.Fonts[Font];
	C.SetDrawColor(byte(255), byte(255), byte(255));
	TextSize(C, "TEST", XL, YL);
	VisibleRows = int(Divide_FloatFloat(WinHeight, YL));
	if(bScrollable)
	{
		VertSB.SetRange(0.0000000, float(Lines), float(VisibleRows));
	}
	TempHead = Head;
	TempTail = Tail;
	Line = TempHead;
	TextArea[Line] = Prompt;
	if(bScrollable)
	{
		if(Greater_FloatFloat(Subtract_FloatFloat(VertSB.MaxPos, VertSB.pos), float(0)))
		{
			SubtractEqual_IntInt(Line, int(Subtract_FloatFloat(VertSB.MaxPos, VertSB.pos)));
			SubtractEqual_IntInt(TempTail, int(Subtract_FloatFloat(VertSB.MaxPos, VertSB.pos)));
		}
	}
	i = 0;
	J0x14E:

	if(Less_IntInt(i, VisibleRows))
	{
		WrapClipText(C, 2.0000000, Multiply_FloatFloat(YL, float(Subtract_IntInt(Subtract_IntInt(VisibleRows, i), 1))), TextArea[Subtract_IntInt(Line, 1)]);
		SubtractSubtract_Int(Line);
		if(EqualEqual_IntInt(TempTail, Line))
		{
			// [Explicit Break]
			goto J0x1CF;
		}
		if(Less_IntInt(Line, 0))
		{
			Line = Subtract_IntInt(BufSize, 1);
		}
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x14E;
	}
	J0x1CF:

	return;
}
