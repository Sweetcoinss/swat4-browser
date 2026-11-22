class UWindowMessageBoxArea extends UWindowWindow;

var string Message;

function float GetHeight(Canvas C)
{
	local float tW, tH, H;
	local int L;
	local float OldWinHeight;

	OldWinHeight = WinHeight;
	WinHeight = 1000.0000000;
	C.Font = Root.Fonts[0];
	TextSize(C, "A", tW, tH);
	L = WrapClipText(C, 0.0000000, 0.0000000, Message,,,, true);
	H = Multiply_FloatFloat(tH, float(L));
	WinHeight = OldWinHeight;
	return H;
	return;
}

function Paint(Canvas C, float X, float Y)
{
	C.Font = Root.Fonts[0];
	C.SetDrawColor(0, 0, 0);
	WrapClipText(C, 0.0000000, 0.0000000, Message);
	C.SetDrawColor(byte(255), byte(255), byte(255));
	return;
}
