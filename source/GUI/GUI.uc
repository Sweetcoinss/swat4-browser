class GUI extends Object
	abstract
	native
	instanced;

cpptext
{
        virtual void CopyConfig(UGUI* toOther);           // copy the config of this to another component
        static FString StripCodes( FString instr );
        static void MakeColorCode( const FColor& theColor, FString& outCode );

        static int CharToHex( char c );
        static char HexToChar( int i );

}

enum eProgressDirection
{
	DIRECTION_LeftToRight,          // 0
	DIRECTION_RightToLeft,          // 1
	DIRECTION_TopToBottom,          // 2
	DIRECTION_BottomToTop           // 3
};

enum eMenuState
{
	MSAT_Blurry,                    // 0
	MSAT_Watched,                   // 1
	MSAT_Focused,                   // 2
	MSAT_Pressed,                   // 3
	MSAT_Disabled                   // 4
};

enum eTextAlign
{
	TXTA_Left,                      // 0
	TXTA_Center,                    // 1
	TXTA_Right                      // 2
};

enum eTextCase
{
	TXTC_None,                      // 0
	TXTC_Upper,                     // 1
	TXTC_Lower                      // 2
};

enum eImgStyle
{
	ISTY_Normal,                    // 0
	ISTY_Stretched,                 // 1
	ISTY_Scaled,                    // 2
	ISTY_Bound,                     // 3
	ISTY_Justified                  // 4
};

enum eImgAlign
{
	IMGA_TopLeft,                   // 0
	IMGA_Center,                    // 1
	IMGA_BottomRight                // 2
};

enum eEditMask
{
	EDM_None,                       // 0
	EDM_Alpha,                      // 1
	EDM_Numeric                     // 2
};

enum EMenuRenderStyle
{
	MSTY_None,                      // 0
	MSTY_Normal,                    // 1
	MSTY_Masked,                    // 2
	MSTY_Translucent,               // 3
	MSTY_Modulated,                 // 4
	MSTY_Alpha,                     // 5
	MSTY_Additive,                  // 6
	MSTY_Subtractive,               // 7
	MSTY_Particle,                  // 8
	MSTY_AlphaZ                     // 9
};

enum eIconPosition
{
	ICP_Normal,                     // 0
	ICP_Center,                     // 1
	ICP_Scaled,                     // 2
	ICP_Stretched,                  // 3
	ICP_Bound                       // 4
};

enum eXControllerCodes
{
	XC_Up,                          // 0
	XC_Down,                        // 1
	XC_Left,                        // 2
	XC_Right,                       // 3
	XC_A,                           // 4
	XC_B,                           // 5
	XC_X,                           // 6
	XC_Y,                           // 7
	XC_Black,                       // 8
	XC_White,                       // 9
	XC_LeftTrigger,                 // 10
	XC_RightTrigger,                // 11
	XC_PadUp,                       // 12
	XC_PadDown,                     // 13
	XC_PadLeft,                     // 14
	XC_PadRight,                    // 15
	XC_Start,                       // 16
	XC_Back,                        // 17
	XC_LeftThumb,                   // 18
	XC_RightThumb                   // 19
};

enum eListElemDisplay
{
	LIST_ELEM_Item,                 // 0
	LIST_ELEM_ExtraData,            // 1
	LIST_ELEM_ExtraStrData,         // 2
	LIST_ELEM_ExtraIntData,         // 3
	LIST_ELEM_ExtraBoolData         // 4
};

struct native GUIListElem
{
	var() string Item;
	var() editinline Object ExtraData;
	var() string ExtraStrData;
	var() int ExtraIntData;
	var() bool ExtraBoolData;
};

struct native ControlSpec
{
	var() config string ClassName "Name of the class to create";
	var() config string ObjName "Name of the object to be created";
};

var(GUIState) editconst editinline GUIController Controller "Callback to the GUIController running the show";
var const int QBTN_Ok;
var const int QBTN_Cancel;
var const int QBTN_Retry;
var const int QBTN_Continue;
var const int QBTN_Yes;
var const int QBTN_No;
var const int QBTN_Abort;
var const int QBTN_Ignore;
var const int QBTN_OkCancel;
var const int QBTN_AbortRetry;
var const int QBTN_YesNo;
var const int QBTN_YesNoCancel;
var const int QBTN_TimeOut;

static function GUIListElem CreateElement(optional string NewItem, optional Object Obj, optional string Str, optional int intData, optional bool bData)
{
	local GUIListElem newElem;

	newElem.Item = NewItem;
	newElem.ExtraData = Obj;
	newElem.ExtraStrData = Str;
	newElem.ExtraIntData = intData;
	newElem.ExtraBoolData = bData;
	return newElem;
	return;
}

static function string FormatTextString(string Format, coerce optional string Param1, coerce optional string Param2, coerce optional string param3)
{
	Format = ReplaceExpression(Format, "%1", Param1);
	Format = ReplaceExpression(Format, "%2", Param2);
	Format = ReplaceExpression(Format, "%3", param3);
	return Format;
	return;
}

static function string GetFirstField(out string in, string seperator)
{
	local int Index;
	local string retStr;

	Index = InStr(in, seperator);
	if(GreaterEqual_IntInt(Index, 0))
	{
		retStr = Left(in, Index);
		in = Right(in, Subtract_IntInt(Len(in), Add_IntInt(Len(seperator), Index)));
	}
	else
	{
		retStr = in;
		in = "";
	}
	return retStr;
	return;
}

static function string ReplaceExpression(string in, string expression, string Replace)
{
	local int Index;

	Index = InStr(in, expression);
	if(GreaterEqual_IntInt(Index, 0))
	{
		return Concat_StrStr(Concat_StrStr(Left(in, Index), Replace), Right(in, Subtract_IntInt(Len(in), Add_IntInt(Index, Len(expression)))));
	}
	else
	{
		return in;
	}
	return;
}

// Export UGUI::execCopyConfig(FFrame&, void* const)
native function CopyConfig(GUIComponent Ctrl);

// Export UGUI::execStripCodes(FFrame&, void* const)
native function string StripCodes(string InStr);

// Export UGUI::execMakeColorCode(FFrame&, void* const)
native function string MakeColorCode(Color clr);

defaultproperties
{
	QBTN_Ok=1
	QBTN_Cancel=2
	QBTN_Retry=4
	QBTN_Continue=8
	QBTN_Yes=16
	QBTN_No=32
	QBTN_Abort=64
	QBTN_Ignore=128
	QBTN_OkCancel=3
	QBTN_AbortRetry=68
	QBTN_YesNo=48
	QBTN_YesNoCancel=50
	QBTN_TimeOut=256
}