class UWindowBase extends Interaction;

const F_Normal = 0;
const F_Bold = 1;
const F_Large = 2;
const F_LargeBold = 3;

enum TextAlign
{
	TA_Left,                        // 0
	TA_Right,                       // 1
	TA_Center                       // 2
};

enum FrameHitTest
{
	HT_NW,                          // 0
	HT_N,                           // 1
	HT_NE,                          // 2
	HT_W,                           // 3
	HT_E,                           // 4
	HT_SW,                          // 5
	HT_S,                           // 6
	HT_SE,                          // 7
	HT_TitleBar,                    // 8
	HT_DragHandle,                  // 9
	HT_None                         // 10
};

enum MenuSound
{
	MS_MenuPullDown,                // 0
	MS_MenuCloseUp,                 // 1
	MS_MenuItem,                    // 2
	MS_WindowOpen,                  // 3
	MS_WindowClose,                 // 4
	MS_ChangeTab                    // 5
};

enum MessageBoxButtons
{
	MB_YesNo,                       // 0
	MB_OKCancel,                    // 1
	MB_OK,                          // 2
	MB_YesNoCancel                  // 3
};

enum MessageBoxResult
{
	MR_None,                        // 0
	MR_Yes,                         // 1
	MR_No,                          // 2
	MR_OK,                          // 3
	MR_Cancel                       // 4
};

enum PropertyCondition
{
	PC_None,                        // 0
	PC_LessThan,                    // 1
	PC_Equal,                       // 2
	PC_GreaterThan,                 // 3
	PC_NotEqual,                    // 4
	PC_Contains,                    // 5
	PC_NotContains                  // 6
};

struct Region
{
	var() int X;
	var() int Y;
	var() int W;
	var() int H;
};

struct TexRegion
{
	var() int X;
	var() int Y;
	var() int W;
	var() int H;
	var() Texture t;
};

struct HTMLStyle
{
	var int BulletLevel;
	var string LinkDestination;
	var Color TextColor;
	var Color BGColor;
	var bool bCenter;
	var bool bLink;
	var bool bUnderline;
	var bool bNoBR;
	var bool bHeading;
	var bool bBold;
	var bool bBlink;
};

function Region NewRegion(float X, float Y, float W, float H)
{
	local Region R;

	R.X = int(X);
	R.Y = int(Y);
	R.W = int(W);
	R.H = int(H);
	return R;
	return;
}

function TexRegion NewTexRegion(float X, float Y, float W, float H, Texture t)
{
	local TexRegion R;

	R.X = int(X);
	R.Y = int(Y);
	R.W = int(W);
	R.H = int(H);
	R.t = t;
	return R;
	return;
}

function Region GetRegion(TexRegion t)
{
	local Region R;

	R.X = t.X;
	R.Y = t.Y;
	R.W = t.W;
	R.H = t.H;
	return R;
	return;
}

static function int InStrAfter(string Text, string Match, int pos)
{
	local int i;

	i = InStr(Mid(Text, pos), Match);
	if(NotEqual_IntInt(i, -1))
	{
		return Add_IntInt(i, pos);
	}
	return -1;
	return;
}

static function Object BuildObjectWithProperties(string Text)
{
	local int i;
	local string ObjectClass, PropertyName, PropertyValue, temp;
	local Class C;
	local Object O;

	i = InStr(Text, ",");
	if(EqualEqual_IntInt(i, -1))
	{
		ObjectClass = Text;
		Text = "";
	}
	else
	{
		ObjectClass = Left(Text, i);
		Text = Mid(Text, Add_IntInt(i, 1));
	}
	C = Class<Object>(DynamicLoadObject(ObjectClass, Class'Core.Class'));
	O = C.static.Allocate(self).;
	Construct_Void();
	J0x98:

	if(NotEqual_StrStr(Text, ""))
	{
		i = InStr(Text, "=");
		if(EqualEqual_IntInt(i, -1))
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("Missing value for property ", ObjectClass), "."), Text));
			PropertyName = Text;
			PropertyValue = "";
		}
		else
		{
			PropertyName = Left(Text, i);
			Text = Mid(Text, Add_IntInt(i, 1));
		}
		if(EqualEqual_StrStr(Left(Text, 1), "\""))
		{
			i = InStrAfter(Text, "\"", 1);
			if(EqualEqual_IntInt(i, -1))
			{
				Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("Missing quote for ", ObjectClass), "."), PropertyName));
				return O;
			}
			PropertyValue = Mid(Text, 1, Subtract_IntInt(i, 1));
			temp = Mid(Text, Add_IntInt(i, 1), 1);
			if(AndAnd_BoolBool(NotEqual_StrStr(temp, ""), NotEqual_StrStr(temp, ",")))
			{
				Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("Missing comma after close quote for ", ObjectClass), "."), PropertyName));
			}
			Text = Mid(Text, Add_IntInt(i, 2));
		}
		else
		{
			i = InStr(Text, ",");
			if(EqualEqual_IntInt(i, -1))
			{
				PropertyValue = Text;
				Text = "";
			}
			else
			{
				PropertyValue = Left(Text, i);
				Text = Mid(Text, Add_IntInt(i, 1));
			}
		}
		O.SetPropertyText(PropertyName, PropertyValue);
		// [Loop Continue]
		goto J0x98;
	}
	return O;
	return;
}
