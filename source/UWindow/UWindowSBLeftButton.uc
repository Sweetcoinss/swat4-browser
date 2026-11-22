class UWindowSBLeftButton extends UWindowButton;

var float NextClickTime;

function Created()
{
	bNoKeyboard = true;
	super.Created();
	return;
}

function BeforePaint(Canvas C, float X, float Y)
{
	LookAndFeel.SB_SetupLeftButton(self);
	return;
}

function LMouseDown(float X, float Y)
{
	super(UWindowWindow).LMouseDown(X, Y);
	if(bDisabled)
	{
		return;
	}
	UWindowHScrollbar(ParentWindow).Scroll(Subtract_PreFloat(UWindowHScrollbar(ParentWindow).ScrollAmount));
	NextClickTime = Add_FloatFloat(GetLevel().TimeSeconds, 0.5000000);
	return;
}

function Tick(float Delta)
{
	if(AndAnd_BoolBool(AndAnd_BoolBool(bMouseDown, Greater_FloatFloat(NextClickTime, float(0))), Less_FloatFloat(NextClickTime, GetLevel().TimeSeconds)))
	{
		UWindowHScrollbar(ParentWindow).Scroll(Subtract_PreFloat(UWindowHScrollbar(ParentWindow).ScrollAmount));
		NextClickTime = Add_FloatFloat(GetLevel().TimeSeconds, 0.1000000);
	}
	if(Not_PreBool(bMouseDown))
	{
		NextClickTime = 0.0000000;
	}
	return;
}
