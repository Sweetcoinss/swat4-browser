class UWindowSmallButton extends UWindowButton;

function Created()
{
	bNoKeyboard = true;
	super.Created();
	ToolTipString = "";
	SetText("");
	SetFont(0);
	WinHeight = 16.0000000;
	return;
}

function AutoWidth(Canvas C)
{
	local float W, H;

	C.Font = Root.Fonts[Font];
	TextSize(C, RemoveAmpersand(Text), W, H);
	if(Less_FloatFloat(WinWidth, Add_FloatFloat(W, float(10))))
	{
		WinWidth = Add_FloatFloat(W, float(10));
	}
	return;
}

function BeforePaint(Canvas C, float X, float Y)
{
	local float W, H;

	C.Font = Root.Fonts[Font];
	TextSize(C, RemoveAmpersand(Text), W, H);
	TextX = Divide_FloatFloat(Subtract_FloatFloat(WinWidth, W), float(2));
	TextY = Divide_FloatFloat(Subtract_FloatFloat(WinHeight, H), float(2));
	if(bMouseDown)
	{
		AddEqual_FloatFloat(TextX, float(1));
		AddEqual_FloatFloat(TextY, float(1));
	}
	return;
}

function Paint(Canvas C, float X, float Y)
{
	LookAndFeel.Button_DrawSmallButton(self, C);
	super.Paint(C, X, Y);
	return;
}
