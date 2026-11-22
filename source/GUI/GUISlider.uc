class GUISlider extends GUIComponent
	native
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object);

cpptext
{
		void Draw(UCanvas* Canvas);

}

var() config float MinValue;
var() config float MaxValue "Bounds for the slider";
var() config string CaptionStyleName "Name of the caption style";
var() config string LeftStyleName "Name of the left style";
var() config string RightStyleName "Name of the right style";
var() config string ButtonStyleName "Name of the button style";
var() config float Value "Slider's initial value";
var() config float Step "Step value for incrementing the slider";
var() export editinline GUIStyles CaptionStyle "The actual caption style";
var() config bool bIntSlider "Are the values bound to be ints";
var() config bool bDisplayAsPercentage "Should the value be displayed in text form as a percentage?";
var() export editinline GUIStyles LeftStyle "The style displayed left of the button";
var() export editinline GUIStyles RightStyle "The style displayed right of the button";
var() export editinline GUIStyles ButtonStyle "The style displayed for the button";
var() config float SliderHeightPercent "Sliders height as a percentage of the total component height";
var() config float ButtonWidthPixels "The buttons width in pixels (at 800x600)";
var() config GUI.eTextAlign CaptionJustification "How the caption is justified";
var() editconst float OldValue "The last value set";
//var delegate<OnDrawCaption> __OnDrawCaption__Delegate;

delegate string OnDrawCaption()
{
	local float ModifiedValue, Range;
	local string OptionalText;

	if(bDisplayAsPercentage)
	{
		Range = Subtract_FloatFloat(MaxValue, MinValue);
		ModifiedValue = Divide_FloatFloat(Subtract_FloatFloat(1.0000000, Subtract_FloatFloat(Range, Value)), Range);
		MultiplyEqual_FloatFloat(ModifiedValue, float(100));
	}
	else
	{
		ModifiedValue = Value;
	}
	if(bDisplayAsPercentage)
	{
		OptionalText = "%";
	}
	if(OrOr_BoolBool(bIntSlider, bDisplayAsPercentage))
	{
		return Concat_StrStr(Concat_StrStr(Concat_StrStr("(", string(int(ModifiedValue))), OptionalText), ")");
	}
	else
	{
		return Concat_StrStr(Concat_StrStr(Concat_StrStr("(", string(ModifiedValue)), OptionalText), ")");
	}
	return;
}

function SetMinValue(float inMin)
{
	MinValue = inMin;
	SetValue(Value);
	return;
}

function SetMaxValue(float inMax)
{
	MaxValue = inMax;
	SetValue(Value);
	return;
}

function SetValue(float NewValue)
{
	if(Less_FloatFloat(NewValue, MinValue))
	{
		NewValue = MinValue;
	}
	if(Greater_FloatFloat(NewValue, MaxValue))
	{
		NewValue = MaxValue;
	}
	if(EqualEqual_FloatFloat(NewValue, Value))
	{
		return;
	}
	if(bIntSlider)
	{
		Value = float(int(NewValue));
	}
	else
	{
		Value = NewValue;
	}
	OnChange(self);
	SetDirty();
	return;
}

function float GetValue()
{
	return Value;
	return;
}

function InitComponent(GUIComponent MyOwner)
{
	super.InitComponent(MyOwner);
	__OnCapturedMouseMove__Delegate = InternalCapturedMouseMove;
	__OnKeyEvent__Delegate = InternalOnKeyEvent;
	__OnMousePressed__Delegate = InternalOnMousePressed;
	__OnXControllerEvent__Delegate = InternalOnXControllerEvent;
	CaptionStyle = Controller.GetStyle(CaptionStyleName);
	LeftStyle = Controller.GetStyle(LeftStyleName);
	RightStyle = Controller.GetStyle(RightStyleName);
	ButtonStyle = Controller.GetStyle(ButtonStyleName);
	assert(NotEqual_ObjectObject(CaptionStyle, none));
	assert(NotEqual_ObjectObject(LeftStyle, none));
	assert(NotEqual_ObjectObject(RightStyle, none));
	assert(NotEqual_ObjectObject(ButtonStyle, none));
	return;
}

function bool InternalCapturedMouseMove(float deltaX, float deltaY)
{
	local float Perc;

	if(AndAnd_BoolBool(GreaterEqual_FloatFloat(Controller.MouseX, Bounds[0]), LessEqual_FloatFloat(Controller.MouseX, Bounds[2])))
	{
		Perc = Divide_FloatFloat(Subtract_FloatFloat(Controller.MouseX, ActualLeft()), ActualWidth());
		Perc = FClamp(Perc, 0.0000000, 1.0000000);
		Value = Add_FloatFloat(Multiply_FloatFloat(Subtract_FloatFloat(MaxValue, MinValue), Perc), MinValue);
		if(bIntSlider)
		{
			Value = float(int(Value));
		}
	}
	else
	{
		if(Less_FloatFloat(Controller.MouseX, Bounds[0]))
		{
			Value = MinValue;
		}
		else
		{
			if(Greater_FloatFloat(Controller.MouseX, Bounds[2]))
			{
				Value = MaxValue;
			}
		}
	}
	Value = FClamp(Value, MinValue, MaxValue);
	if(OrOr_BoolBool(GreaterEqual_FloatFloat(Abs(Subtract_FloatFloat(OldValue, Value)), Step), AndAnd_BoolBool(NotEqual_FloatFloat(OldValue, Value), OrOr_BoolBool(EqualEqual_FloatFloat(Value, MaxValue), EqualEqual_FloatFloat(Value, MinValue)))))
	{
		OldValue = Value;
		OnChange(self);
	}
	return true;
	return;
}

function bool InternalOnKeyEvent(out byte Key, out byte State, float Delta)
{
	if(AndAnd_BoolBool(OrOr_BoolBool(EqualEqual_IntInt(int(Key), 37), EqualEqual_IntInt(int(Key), 100)), EqualEqual_IntInt(int(State), 1)))
	{
		if(bIntSlider)
		{
			Adjust(-1.0000000);
		}
		else
		{
			Adjust(-0.0100000);
		}
		return true;
	}
	if(AndAnd_BoolBool(OrOr_BoolBool(EqualEqual_IntInt(int(Key), 39), EqualEqual_IntInt(int(Key), 102)), EqualEqual_IntInt(int(State), 1)))
	{
		if(bIntSlider)
		{
			Adjust(1.0000000);
		}
		else
		{
			Adjust(0.0100000);
		}
		return true;
	}
	return false;
	return;
}

function bool InternalOnXControllerEvent(byte Id, GUI.eXControllerCodes iCode)
{
	if(OrOr_BoolBool(OrOr_BoolBool(EqualEqual_IntInt(int(iCode), int(2)), EqualEqual_IntInt(int(iCode), int(14))), EqualEqual_IntInt(int(iCode), int(6))))
	{
		Adjust(Multiply_FloatFloat(Step, float(-1)));
		return true;
	}
	else
	{
		if(OrOr_BoolBool(OrOr_BoolBool(EqualEqual_IntInt(int(iCode), int(3)), EqualEqual_IntInt(int(iCode), int(15))), EqualEqual_IntInt(int(iCode), int(7))))
		{
			Adjust(Step);
			return true;
		}
	}
	return false;
	return;
}

function Adjust(float amount)
{
	local float Perc;

	Perc = Divide_FloatFloat(Subtract_FloatFloat(Value, MinValue), Subtract_FloatFloat(MaxValue, MinValue));
	AddEqual_FloatFloat(Perc, amount);
	Perc = FClamp(Perc, 0.0000000, 1.0000000);
	Value = Add_FloatFloat(Multiply_FloatFloat(Subtract_FloatFloat(MaxValue, MinValue), Perc), MinValue);
	FClamp(Value, MinValue, MaxValue);
	OnChange(self);
	return;
}

event Click()
{
	super.Click();
	OnChange(self);
	return;
}

function InternalOnMousePressed(GUIComponent Sender)
{
	OldValue = Value;
	InternalCapturedMouseMove(0.0000000, 0.0000000);
	return;
}

defaultproperties
{
	CaptionStyleName="STY_SliderCaption"
	LeftStyleName="STY_SliderLeft"
	RightStyleName="STY_SliderRight"
	ButtonStyleName="STY_SliderButton"
	Step=1.0000000
	SliderHeightPercent=1.0000000
	ButtonWidthPixels=16.0000000
	StyleName="sty_sliderstyle"
	WinHeight=0.0300000
	bCaptureMouse=true
	bNeverFocus=true
	bRequireReleaseClick=true
	bTabStop=true
	OnClickSound=1
}