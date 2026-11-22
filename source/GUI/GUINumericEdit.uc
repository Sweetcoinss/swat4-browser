class GUINumericEdit extends GUIMultiComponent
	native
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object);

cpptext
{
		void UpdateComponent(UCanvas* Canvas);

}

var export editinline GUIEditBox MyEditBox;
var export editinline GUISpinnerButton MyPlus;
var export editinline GUISpinnerButton MyMinus;
var() config int Value "Value of this edit box";
var() config bool bLeftJustified "Is the text left justified";
var() config int MinValue "Minimum value allowed";
var() config int MaxValue "Maximum value allowed";
var() config int Step "Step to use for additive/subtractive increments";
var() config bool bDisplayAsTime "If true, will convert the display string to a time display (assumes time entered in seconds)";
var() config bool bReadOnly "If true, will not allow the user to edit this box";
var() config bool bAlwaysShowMins "If true, will always display times less than a minute in the format 0:SS";
var() config bool bAlwaysShowHours "If true, will always display times less than an hour in the format 0:MM:SS";

function OnConstruct(GUIController MyController)
{
	super.OnConstruct(MyController);
	MyEditBox = GUIEditBox(AddComponent("GUI.GUIEditBox", Concat_StrStr(string(self.Name), "_EditBox")));
	if(Not_PreBool(bReadOnly))
	{
		MyPlus = GUISpinnerButton(AddComponent("GUI.GUISpinnerButton", Concat_StrStr(string(self.Name), "_Plus")));
		MyMinus = GUISpinnerButton(AddComponent("GUI.GUISpinnerButton", Concat_StrStr(string(self.Name), "_Minus")));
	}
	return;
}

function InitComponent(GUIComponent MyOwner)
{
	super.InitComponent(MyOwner);
	MyEditBox.SetText("");
	MyEditBox.bIntOnly = true;
	if(Not_PreBool(bReadOnly))
	{
		MyPlus.PlusButton = true;
		MyMinus.PlusButton = false;
	}
	MyEditBox.__OnChange__Delegate = EditOnChange;
	if(OrOr_BoolBool(bDisplayAsTime, bReadOnly))
	{
		MyEditBox.bReadOnly = true;
	}
	SetValue(Value);
	MyEditBox.__OnKeyEvent__Delegate = EditKeyEvent;
	CalcMaxLen();
	if(Not_PreBool(bReadOnly))
	{
		MyPlus.__OnClick__Delegate = SpinnerPlusClick;
		MyPlus.SetFocusInstead(MyEditBox);
		MyMinus.__OnClick__Delegate = SpinnerMinusClick;
		MyMinus.SetFocusInstead(MyEditBox);
	}
	return;
}

function CalcMaxLen()
{
	local int digitcount, X;

	digitcount = 1;
	X = 10;
	J0x0F:

	if(Less_IntInt(X, MaxValue))
	{
		AddAdd_Int(digitcount);
		MultiplyEqual_IntFloat(X, float(10));
		// [Loop Continue]
		goto J0x0F;
	}
	MyEditBox.MaxWidth = digitcount;
	return;
}

function SetMinValue(int inMin)
{
	MinValue = inMin;
	SetValue(Value);
	return;
}

function SetMaxValue(int inMax)
{
	MaxValue = inMax;
	CalcMaxLen();
	SetValue(Value);
	return;
}

function SetValue(int V, optional bool bForceCallbacks)
{
	local string TimeStr;
	local int Hours, mins, secs;

	if(Less_IntInt(V, MinValue))
	{
		V = MinValue;
	}
	if(Greater_IntInt(V, MaxValue))
	{
		V = MaxValue;
	}
	if(AndAnd_BoolBool(Not_PreBool(bForceCallbacks), EqualEqual_IntInt(Value, V)))
	{
		return;
	}
	Value = V;
	if(bDisplayAsTime)
	{
		Hours = Divide_IntInt(V, 3600);
		mins = Divide_IntInt(int(Percent_FloatFloat(float(V), float(3600))), 60);
		secs = int(Percent_FloatFloat(float(V), float(60)));
		TimeStr = Concat_StrStr("", string(secs));
		if(OrOr_BoolBool(OrOr_BoolBool(OrOr_BoolBool(bAlwaysShowMins, bAlwaysShowHours), Greater_IntInt(mins, 0)), Greater_IntInt(Hours, 0)))
		{
			if(Less_IntInt(secs, 10))
			{
				TimeStr = Concat_StrStr("0", TimeStr);
			}
			TimeStr = Concat_StrStr(Concat_StrStr(string(mins), ":"), TimeStr);
		}
		if(OrOr_BoolBool(bAlwaysShowHours, Greater_IntInt(Hours, 0)))
		{
			if(Less_IntInt(mins, 10))
			{
				TimeStr = Concat_StrStr("0", TimeStr);
			}
			TimeStr = Concat_StrStr(Concat_StrStr(string(Hours), ":"), TimeStr);
		}
		MyEditBox.MaxWidth = Len(TimeStr);
		MyEditBox.SetText(TimeStr);
	}
	else
	{
		MyEditBox.SetText(Concat_StrStr("", string(V)));
	}
	SetDirty();
	OnChange(self);
	return;
}

function SpinnerPlusClick(GUIComponent Sender)
{
	SetValue(Add_IntInt(Value, Step));
	return;
}

function SpinnerMinusClick(GUIComponent Sender)
{
	SetValue(Subtract_IntInt(Value, Step));
	return;
}

function bool EditKeyEvent(out byte Key, out byte State, float Delta)
{
	if(AndAnd_BoolBool(EqualEqual_IntInt(int(Key), 236), EqualEqual_IntInt(int(State), 3)))
	{
		SpinnerPlusClick(none);
		return true;
	}
	if(AndAnd_BoolBool(EqualEqual_IntInt(int(Key), 237), EqualEqual_IntInt(int(State), 3)))
	{
		SpinnerMinusClick(none);
		return true;
	}
	return MyEditBox.InternalOnKeyEvent(Key, State, Delta);
	return;
}

function EditOnChange(GUIComponent Sender)
{
	if(Not_PreBool(bDisplayAsTime))
	{
		SetValue(int(MyEditBox.GetText()));
	}
	return;
}

defaultproperties
{
	MaxValue=9999
	Step=1
	bAlwaysShowMins=true
	WinHeight=0.0273440
}