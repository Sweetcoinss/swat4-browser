class UWindowProgressBar extends UWindowWindow;

const BlockWidth = 7;

var float Percent;

function SetPercent(float NewPercent)
{
	Percent = NewPercent;
	return;
}

function Paint(Canvas C, float X, float Y)
{
	local float BlockX, BlockW;

	DrawMiscBevel(C, 0.0000000, 0.0000000, WinWidth, WinHeight, LookAndFeel.Misc, 2);
	C.SetDrawColor(192, 192, 192);
	DrawStretchedTextureSegment(C, float(LookAndFeel.MiscBevelL[2].W), float(LookAndFeel.MiscBevelT[2].H), Subtract_FloatFloat(Subtract_FloatFloat(WinWidth, float(LookAndFeel.MiscBevelL[2].W)), float(LookAndFeel.MiscBevelR[2].W)), Subtract_FloatFloat(Subtract_FloatFloat(WinHeight, float(LookAndFeel.MiscBevelT[2].H)), float(LookAndFeel.MiscBevelB[2].H)), 0.0000000, 0.0000000, 1.0000000, 1.0000000, Texture'UWindow_res.WhiteTexture');
	C.SetDrawColor(0, 0, byte(255));
	BlockX = float(Add_IntInt(LookAndFeel.MiscBevelL[2].W, 1));
	J0x142:

	if(Less_FloatFloat(BlockX, Add_FloatFloat(float(Add_IntInt(1, LookAndFeel.MiscBevelL[2].W)), Divide_FloatFloat(Multiply_FloatFloat(Percent, Subtract_FloatFloat(Subtract_FloatFloat(Subtract_FloatFloat(WinWidth, float(LookAndFeel.MiscBevelL[2].W)), float(LookAndFeel.MiscBevelR[2].W)), float(2))), float(100)))))
	{
		BlockW = float(Min(7, int(Subtract_FloatFloat(Subtract_FloatFloat(Subtract_FloatFloat(WinWidth, float(LookAndFeel.MiscBevelR[2].W)), BlockX), float(1)))));
		DrawStretchedTextureSegment(C, BlockX, float(Add_IntInt(LookAndFeel.MiscBevelT[2].H, 1)), BlockW, Subtract_FloatFloat(Subtract_FloatFloat(Subtract_FloatFloat(WinHeight, float(LookAndFeel.MiscBevelT[2].H)), float(LookAndFeel.MiscBevelB[2].H)), float(1)), 0.0000000, 0.0000000, 1.0000000, 1.0000000, Texture'UWindow_res.WhiteTexture');
		AddEqual_FloatFloat(BlockX, float(Add_IntInt(7, 1)));
		// [Loop Continue]
		goto J0x142;
	}
	C.SetDrawColor(byte(255), byte(255), byte(255));
	return;
}
