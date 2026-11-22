class UWindowBitmap extends UWindowWindow;

var Texture t;
var Region R;
var bool bStretch;
var bool bCenter;

function Paint(Canvas C, float X, float Y)
{
	if(bStretch)
	{
		DrawStretchedTextureSegment(C, 0.0000000, 0.0000000, WinWidth, WinHeight, float(R.X), float(R.Y), float(R.W), float(R.H), t);
	}
	else
	{
		if(bCenter)
		{
			DrawStretchedTextureSegment(C, Divide_FloatFloat(Subtract_FloatFloat(WinWidth, float(R.W)), float(2)), Divide_FloatFloat(Subtract_FloatFloat(WinHeight, float(R.H)), float(2)), float(R.W), float(R.H), float(R.X), float(R.Y), float(R.W), float(R.H), t);
		}
		else
		{
			DrawStretchedTextureSegment(C, 0.0000000, 0.0000000, float(R.W), float(R.H), float(R.X), float(R.Y), float(R.W), float(R.H), t);
		}
	}
	return;
}
