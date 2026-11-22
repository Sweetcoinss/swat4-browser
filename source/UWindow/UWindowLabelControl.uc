class UWindowLabelControl extends UWindowDialogControl;

function Created()
{
	TextX = 0.0000000;
	TextY = 0.0000000;
	return;
}

function BeforePaint(Canvas C, float X, float Y)
{
	local float W, H;

	super.BeforePaint(C, X, Y);
	TextSize(C, Text, W, H);
	WinHeight = Add_FloatFloat(H, float(1));
	TextY = Divide_FloatFloat(Subtract_FloatFloat(WinHeight, H), float(2));
	switch(Align)
	{
		case 0:
			break;
		case 2:
			TextX = Divide_FloatFloat(Subtract_FloatFloat(WinWidth, W), float(2));
			break;
		case 1:
			TextX = Subtract_FloatFloat(WinWidth, W);
			break;
		default:
			break;
	}
	return;
}

function Paint(Canvas C, float X, float Y)
{
	if(NotEqual_StrStr(Text, ""))
	{
		C.SetDrawColor(TextColor.R, TextColor.G, TextColor.B);
		C.Font = Root.Fonts[Font];
		ClipText(C, TextX, TextY, Text);
		C.SetDrawColor(byte(255), byte(255), byte(255));
	}
	return;
}
