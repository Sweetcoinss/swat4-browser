class UWindowHSliderControl extends UWindowDialogControl;

var float MinValue;
var float MaxValue;
var float Value;
var int Step;
var float SliderWidth;
var float SliderDrawX;
var float SliderDrawY;
var float TrackStart;
var float TrackWidth;
var bool bSliding;
var bool bNoSlidingNotify;

function Created()
{
	super.Created();
	SliderWidth = Divide_FloatFloat(WinWidth, float(2));
	TrackWidth = 4.0000000;
	return;
}

function SetRange(float Min, float Max, int NewStep)
{
	MinValue = Min;
	MaxValue = Max;
	Step = NewStep;
	Value = CheckValue(Value);
	return;
}

function float GetValue()
{
	return Value;
	return;
}

function SetValue(float NewValue, optional bool bNoNotify)
{
	local float OldValue;

	OldValue = Value;
	Value = CheckValue(NewValue);
	if(AndAnd_BoolBool(NotEqual_FloatFloat(Value, OldValue), Not_PreBool(bNoNotify)))
	{
		Notify(1);
	}
	return;
}

function float CheckValue(float test)
{
	local float TempF, NewValue;

	NewValue = test;
	if(NotEqual_IntInt(Step, 0))
	{
		TempF = Divide_FloatFloat(NewValue, float(Step));
		NewValue = float(Multiply_IntInt(int(Add_FloatFloat(TempF, 0.5000000)), Step));
	}
	if(Less_FloatFloat(NewValue, MinValue))
	{
		NewValue = MinValue;
	}
	if(Greater_FloatFloat(NewValue, MaxValue))
	{
		NewValue = MaxValue;
	}
	return NewValue;
	return;
}

function BeforePaint(Canvas C, float X, float Y)
{
	local float W, H;

	super.BeforePaint(C, X, Y);
	TextSize(C, Text, W, H);
	WinHeight = Add_FloatFloat(H, float(1));
	switch(Align)
	{
		case 0:
			SliderDrawX = Subtract_FloatFloat(WinWidth, SliderWidth);
			TextX = 0.0000000;
			break;
		case 1:
			SliderDrawX = 0.0000000;
			TextX = Subtract_FloatFloat(WinWidth, W);
			break;
		case 2:
			SliderDrawX = Divide_FloatFloat(Subtract_FloatFloat(WinWidth, SliderWidth), float(2));
			TextX = Divide_FloatFloat(Subtract_FloatFloat(WinWidth, W), float(2));
			break;
		default:
			break;
	}
	SliderDrawY = Divide_FloatFloat(Subtract_FloatFloat(WinHeight, float(2)), float(2));
	TextY = Divide_FloatFloat(Subtract_FloatFloat(WinHeight, H), float(2));
	TrackStart = Add_FloatFloat(SliderDrawX, Multiply_FloatFloat(Subtract_FloatFloat(SliderWidth, TrackWidth), Divide_FloatFloat(Subtract_FloatFloat(Value, MinValue), Subtract_FloatFloat(MaxValue, MinValue))));
	return;
}

function Paint(Canvas C, float X, float Y)
{
	local Texture t;
	local Region R;

	t = GetLookAndFeelTexture();
	if(NotEqual_StrStr(Text, ""))
	{
		C.DrawColor = TextColor;
		ClipText(C, TextX, TextY, Text);
		C.SetDrawColor(byte(255), byte(255), byte(255));
	}
	R = LookAndFeel.HLine;
	DrawStretchedTextureSegment(C, SliderDrawX, SliderDrawY, SliderWidth, float(R.H), float(R.X), float(R.Y), float(R.W), float(R.H), t);
	DrawUpBevel(C, TrackStart, Subtract_FloatFloat(SliderDrawY, float(4)), TrackWidth, 10.0000000, t);
	return;
}

function LMouseUp(float X, float Y)
{
	super(UWindowWindow).LMouseUp(X, Y);
	if(bNoSlidingNotify)
	{
		Notify(1);
	}
	return;
}

function LMouseDown(float X, float Y)
{
	super(UWindowWindow).LMouseDown(X, Y);
	if(AndAnd_BoolBool(GreaterEqual_FloatFloat(X, TrackStart), LessEqual_FloatFloat(X, Add_FloatFloat(TrackStart, TrackWidth))))
	{
		bSliding = true;
		Root.CaptureMouse();
	}
	if(AndAnd_BoolBool(Less_FloatFloat(X, TrackStart), Greater_FloatFloat(X, SliderDrawX)))
	{
		if(NotEqual_IntInt(Step, 0))
		{
			SetValue(Subtract_FloatFloat(Value, float(Step)));
		}
		else
		{
			SetValue(Subtract_FloatFloat(Value, float(1)));
		}
	}
	if(AndAnd_BoolBool(Greater_FloatFloat(X, Add_FloatFloat(TrackStart, TrackWidth)), Less_FloatFloat(X, Add_FloatFloat(SliderDrawX, SliderWidth))))
	{
		if(NotEqual_IntInt(Step, 0))
		{
			SetValue(Add_FloatFloat(Value, float(Step)));
		}
		else
		{
			SetValue(Add_FloatFloat(Value, float(1)));
		}
	}
	return;
}

function MouseMove(float X, float Y)
{
	super.MouseMove(X, Y);
	if(AndAnd_BoolBool(bSliding, bMouseDown))
	{
		SetValue(Add_FloatFloat(Multiply_FloatFloat(Divide_FloatFloat(Subtract_FloatFloat(X, SliderDrawX), Subtract_FloatFloat(SliderWidth, TrackWidth)), Subtract_FloatFloat(MaxValue, MinValue)), MinValue), bNoSlidingNotify);
	}
	else
	{
		bSliding = false;
	}
	return;
}

function KeyDown(int Key, float X, float Y)
{
	local Interaction C;

	C = GetPlayerOwner().Player.Console;
	switch(Key)
	{
		case int(C.37):
			if(NotEqual_IntInt(Step, 0))
			{
				SetValue(Subtract_FloatFloat(Value, float(Step)));
			}
			else
			{
				SetValue(Subtract_FloatFloat(Value, float(1)));
			}
			break;
		case int(C.39):
			if(NotEqual_IntInt(Step, 0))
			{
				SetValue(Add_FloatFloat(Value, float(Step)));
			}
			else
			{
				SetValue(Add_FloatFloat(Value, float(1)));
			}
			break;
		case int(C.36):
			SetValue(MinValue);
			break;
		case int(C.35):
			SetValue(MaxValue);
			break;
		default:
			super.KeyDown(Key, X, Y);
			break;
			break;
	}
	return;
}
