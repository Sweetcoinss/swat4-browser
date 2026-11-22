class GUIEditBox extends GUIButton
	native
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object,Menu,Object);

cpptext
{
		void Draw(UCanvas* Canvas);

}

var() config Color CursorColor "Color to draw the cursor in (alpha disregarded)";
var() config Material CursorImage "The Material to Render for the cursor";
var() config Color HighlightColor "Color to draw the highlight in (alpha disregarded)";
var() config Material HighlightImage "The Material to Render for the highlight";
var() private config string TextStr "Holds the current string";
var() config string AllowedCharSet "Only Allow these characters";
var() config bool bMaskText "Displays the text as a string of masked chars";
var() config string MaskedChar "Char to display instead of the actual chars if bMaskText";
var() config bool bIntOnly "Only Allow Interger Numeric entry";
var() config bool bFloatOnly "Only Allow Float Numeric entry";
var() config bool bIncludeSign "Do we need to allow a -/+ sign";
var() config bool bConvertSpaces "Do we want to convert Spaces to _";
var() config int MaxWidth "Holds the maximum width (in chars) of the string - 0 = No Max";
var() config GUI.eTextCase TextCase "Controls forcing case, etc";
var() editinline config int BorderOffsets[4] "How far in from the edit is the edit area";
var() config bool bReadOnly "Can't actually edit this box";
var() editconst string VisibleText "Holds the current visible string";
var() editconst int HighlightStart;
var() editconst int HighlightEnd;
var() editconst int CaretPos;
var() editconst int FirstVis;
var() editconst int LastLength;
var() editconst int LastCaret;
var bool bMouseDownTrapped;
var bool bMouseUpTrapped;
var byte LastKey;
var float DelayTime;
//var delegate<OnEntryCompleted> __OnEntryCompleted__Delegate;
//var delegate<OnEntryCancelled> __OnEntryCancelled__Delegate;

delegate OnEntryCompleted(GUIComponent Sender)
{
	return;
}

delegate OnEntryCancelled(GUIComponent Sender)
{
	return;
}

function InitComponent(GUIComponent MyOwner)
{
	super.InitComponent(MyOwner);
	AssertWithDescription(LessEqual_IntInt(Len(MaskedChar), 1), Concat_StrStr("A maximum of one character should be specified for MaskedChar for ", string(self)));
	bCaptureMouse = true;
	__OnKeyType__Delegate = InternalOnKeyType;
	__OnKeyEvent__Delegate = InternalOnKeyEvent;
	if(OrOr_BoolBool(bIntOnly, bFloatOnly))
	{
		AllowedCharSet = "0123456789";
		if(bFloatOnly)
		{
			AllowedCharSet = Concat_StrStr(AllowedCharSet, ".");
		}
	}
	CaretPos = Len(TextStr);
	Change();
	HighlightStart = 0;
	return;
}

event Show()
{
	SetVisibleText();
	super(GUIComponent).Show();
	return;
}

event DblClick()
{
	super(GUIComponent).DblClick();
	CaretPos = Len(TextStr);
	HighlightStart = 0;
	HighlightEnd = CaretPos;
	return;
}

event MousePressed()
{
	bMouseDownTrapped = true;
	bMouseUpTrapped = true;
	super(GUIComponent).MousePressed();
	return;
}

event MouseReleased()
{
	super(GUIComponent).MouseReleased();
	bMouseUpTrapped = false;
	return;
}

event SetText(string NewText, optional bool bForceUpdate)
{
	if(AndAnd_BoolBool(EqualEqual_StrStr(NewText, TextStr), Not_PreBool(bForceUpdate)))
	{
		return;
	}
	TextStr = NewText;
	if(Greater_IntInt(MaxWidth, 0))
	{
		TextStr = Left(TextStr, MaxWidth);
	}
	CaretPos = Len(TextStr);
	Change();
	HighlightStart = 0;
	return;
}

function string GetText()
{
	return TextStr;
	return;
}

function Change()
{
	HighlightEnd = CaretPos;
	HighlightStart = CaretPos;
	SetVisibleText();
	SetDirty();
	OnChange(self);
	return;
}

private function SetVisibleText()
{
	local int i;

	if(bMaskText)
	{
		VisibleText = "";
		i = Len(TextStr);
		J0x1E:

		if(Greater_IntInt(i, 0))
		{
			VisibleText = Concat_StrStr(VisibleText, MaskedChar);
			SubtractSubtract_Int(i);
			// [Loop Continue]
			goto J0x1E;
		}
	}
	else
	{
		VisibleText = TextStr;
	}
	SetDirty();
	return;
}

function DeleteChar()
{
	if(Greater_IntInt(Subtract_IntInt(HighlightEnd, HighlightStart), 0))
	{
		CaretPos = HighlightStart;
		TextStr = Concat_StrStr(Left(TextStr, HighlightStart), Mid(TextStr, HighlightEnd));
		HighlightEnd = CaretPos;
	}
	else
	{
		if(Less_IntInt(CaretPos, Len(TextStr)))
		{
			TextStr = Concat_StrStr(Left(TextStr, CaretPos), Mid(TextStr, Add_IntInt(CaretPos, 1)));
		}
	}
	return;
}

function bool InternalOnKeyType(out byte Key, optional string Unicode)
{
	local string temp, ST, PrevText;

	if(bReadOnly)
	{
		return false;
	}
	PrevText = TextStr;
	if(Less_IntInt(int(Key), 32))
	{
		if(AndAnd_BoolBool(Controller.CtrlPressed, OrOr_BoolBool(EqualEqual_IntInt(int(Key), 3), EqualEqual_IntInt(int(Key), 24))))
		{
			PlayerOwner().CopyToClipboard(Mid(TextStr, HighlightStart, Subtract_IntInt(HighlightEnd, HighlightStart)));
			if(AndAnd_BoolBool(EqualEqual_IntInt(int(Key), 24), Greater_IntInt(Subtract_IntInt(HighlightEnd, HighlightStart), 0)))
			{
				DeleteChar();
				Change();
			}
			return true;
		}
		if(AndAnd_BoolBool(Controller.CtrlPressed, EqualEqual_IntInt(int(Key), 22)))
		{
			if(Greater_IntInt(Subtract_IntInt(HighlightEnd, HighlightStart), 0))
			{
				DeleteChar();
			}
			temp = ConvertIllegal(PlayerOwner().PasteFromClipboard());
			TextStr = Concat_StrStr(Concat_StrStr(Left(TextStr, CaretPos), temp), Mid(TextStr, CaretPos));
			if(Greater_IntInt(MaxWidth, 0))
			{
				TextStr = Left(TextStr, MaxWidth);
			}
			CaretPos = Add_IntInt(CaretPos, Len(temp));
			Change();
			return true;
		}
		return false;
	}
	if(Greater_IntInt(Subtract_IntInt(HighlightEnd, HighlightStart), 0))
	{
		DeleteChar();
	}
	if(NotEqual_StrStr(Unicode, ""))
	{
		ST = Unicode;
	}
	else
	{
		ST = Chr(int(Key));
	}
	if(OrOr_BoolBool(OrOr_BoolBool(EqualEqual_StrStr(AllowedCharSet, ""), AndAnd_BoolBool(AndAnd_BoolBool(bIncludeSign, OrOr_BoolBool(EqualEqual_StrStr(ST, "-"), EqualEqual_StrStr(ST, "+"))), EqualEqual_StrStr(TextStr, ""))), GreaterEqual_IntInt(InStr(AllowedCharSet, ST), 0)))
	{
		if(OrOr_BoolBool(EqualEqual_IntInt(MaxWidth, 0), Less_IntInt(Len(TextStr), MaxWidth)))
		{
			if(AndAnd_BoolBool(bConvertSpaces, OrOr_BoolBool(OrOr_BoolBool(EqualEqual_StrStr(ST, " "), EqualEqual_StrStr(ST, "?")), EqualEqual_StrStr(ST, "\\"))))
			{
				ST = "_";
			}
			if(OrOr_BoolBool(EqualEqual_StrStr(TextStr, ""), EqualEqual_IntInt(CaretPos, Len(TextStr))))
			{
				TextStr = Concat_StrStr(TextStr, ST);
				CaretPos = Len(TextStr);
			}
			else
			{
				temp = Concat_StrStr(Concat_StrStr(Left(TextStr, CaretPos), ST), Mid(TextStr, CaretPos));
				TextStr = temp;
				AddAdd_Int(CaretPos);
			}
		}
	}
	if(NotEqual_StrStr(PrevText, TextStr))
	{
		Change();
	}
	return true;
	return;
}

function bool InternalOnKeyEvent(out byte Key, out byte State, float Delta)
{
	if(bReadOnly)
	{
		return false;
	}
	if(AndAnd_BoolBool(EqualEqual_IntInt(int(Key), int(13)), EqualEqual_IntInt(int(State), int(1))))
	{
		if(Not_PreBool(Controller.bDesignMode))
		{
			OnEntryCompleted(self);
		}
		return true;
	}
	if(AndAnd_BoolBool(EqualEqual_IntInt(int(Key), int(27)), EqualEqual_IntInt(int(State), int(1))))
	{
		if(Not_PreBool(Controller.bDesignMode))
		{
			OnEntryCancelled(self);
		}
		return true;
	}
	if(AndAnd_BoolBool(EqualEqual_IntInt(int(Key), int(8)), EqualEqual_IntInt(int(State), int(1))))
	{
		if(Greater_IntInt(CaretPos, 0))
		{
			SubtractSubtract_Int(CaretPos);
			DeleteChar();
			Change();
		}
		return true;
	}
	if(AndAnd_BoolBool(EqualEqual_IntInt(int(Key), int(46)), EqualEqual_IntInt(int(State), int(1))))
	{
		DeleteChar();
		Change();
		return true;
	}
	if(AndAnd_BoolBool(EqualEqual_IntInt(int(Key), int(37)), EqualEqual_IntInt(int(State), int(1))))
	{
		if(Controller.CtrlPressed)
		{
			CaretPos = 0;
		}
		else
		{
			if(Greater_IntInt(CaretPos, 0))
			{
				SubtractSubtract_Int(CaretPos);
			}
			else
			{
				if(Controller.ShiftPressed)
				{
					return true;
				}
			}
		}
		if(Controller.ShiftPressed)
		{
			if(Greater_IntInt(HighlightStart, CaretPos))
			{
				HighlightStart = CaretPos;
			}
			else
			{
				HighlightEnd = CaretPos;
			}
		}
		else
		{
			if(AndAnd_BoolBool(Greater_IntInt(Subtract_IntInt(HighlightEnd, HighlightStart), 0), Greater_IntInt(CaretPos, HighlightStart)))
			{
				CaretPos = HighlightStart;
			}
			HighlightEnd = CaretPos;
			HighlightStart = CaretPos;
		}
		return true;
	}
	if(AndAnd_BoolBool(EqualEqual_IntInt(int(Key), int(39)), EqualEqual_IntInt(int(State), int(1))))
	{
		if(Controller.CtrlPressed)
		{
			CaretPos = Len(TextStr);
		}
		else
		{
			if(Less_IntInt(CaretPos, Len(TextStr)))
			{
				AddAdd_Int(CaretPos);
			}
			else
			{
				if(Controller.ShiftPressed)
				{
					return true;
				}
			}
		}
		if(Controller.ShiftPressed)
		{
			if(Less_IntInt(HighlightEnd, CaretPos))
			{
				HighlightEnd = CaretPos;
			}
			else
			{
				HighlightStart = CaretPos;
			}
		}
		else
		{
			if(AndAnd_BoolBool(Greater_IntInt(Subtract_IntInt(HighlightEnd, HighlightStart), 0), Less_IntInt(CaretPos, HighlightEnd)))
			{
				CaretPos = HighlightEnd;
			}
			HighlightEnd = CaretPos;
			HighlightStart = CaretPos;
		}
		return true;
	}
	if(AndAnd_BoolBool(EqualEqual_IntInt(int(Key), int(36)), EqualEqual_IntInt(int(State), int(1))))
	{
		CaretPos = 0;
		HighlightStart = CaretPos;
		if(Not_PreBool(Controller.ShiftPressed))
		{
			HighlightEnd = CaretPos;
		}
		return true;
	}
	if(AndAnd_BoolBool(EqualEqual_IntInt(int(Key), int(35)), EqualEqual_IntInt(int(State), int(1))))
	{
		CaretPos = Len(TextStr);
		HighlightEnd = CaretPos;
		if(Not_PreBool(Controller.ShiftPressed))
		{
			HighlightStart = CaretPos;
		}
		return true;
	}
	return false;
	return;
}

function string ConvertIllegal(string inputstr)
{
	local int i, Max;
	local string retval, C;

	i = 0;
	Max = Len(inputstr);
	J0x14:

	if(Less_IntInt(i, Max))
	{
		C = Mid(inputstr, i, 1);
		if(AndAnd_BoolBool(NotEqual_StrStr(AllowedCharSet, ""), Less_IntInt(InStr(AllowedCharSet, C), 0)))
		{
			C = "";
		}
		if(AndAnd_BoolBool(bConvertSpaces, OrOr_BoolBool(OrOr_BoolBool(EqualEqual_StrStr(C, " "), EqualEqual_StrStr(C, "?")), EqualEqual_StrStr(C, "\\"))))
		{
			C = "_";
		}
		retval = Concat_StrStr(retval, C);
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x14;
	}
	if(Greater_IntInt(MaxWidth, 0))
	{
		return Left(retval, MaxWidth);
	}
	else
	{
		return retval;
	}
	return;
}

defaultproperties
{
	CursorColor=(R=0,G=0,B=0,A=255)
	CursorImage=Texture'gui_tex.White'
	HighlightColor=(R=112,G=112,B=112,A=255)
	HighlightImage=Texture'gui_tex.White'
	MaskedChar="#"
	LastLength=-1
	LastCaret=-1
	TextAlign=0
	StyleName="STY_SquareButton"
	WinHeight=0.0273440
	bNeverFocus=false
	bFocusWhenReleaseHitTestFails=true
	OnClickSound=2
}