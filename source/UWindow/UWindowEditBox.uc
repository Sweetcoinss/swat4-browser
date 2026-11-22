class UWindowEditBox extends UWindowDialogControl;

var string Value;
var string Value2;
var int CaretOffset;
var int MaxLength;
var float LastDrawTime;
var bool bShowCaret;
var float Offset;
var UWindowDialogControl NotifyOwner;
var bool bNumericOnly;
var bool bNumericFloat;
var bool bCanEdit;
var bool bAllSelected;
var bool bSelectOnFocus;
var bool bDelayedNotify;
var bool bChangePending;
var bool bControlDown;
var bool bShiftDown;
var bool bHistory;
var bool bKeyDown;
var UWindowEditBoxHistory HistoryList;
var UWindowEditBoxHistory CurrentHistory;

function Created()
{
	super.Created();
	bCanEdit = true;
	bControlDown = false;
	bShiftDown = false;
	MaxLength = 255;
	CaretOffset = 0;
	Offset = 0.0000000;
	LastDrawTime = 0.0000000;
	return;
}

function SetHistory(bool bInHistory)
{
	bHistory = bInHistory;
	if(AndAnd_BoolBool(bHistory, EqualEqual_ObjectObject(HistoryList, none)))
	{
		HistoryList = Class'UWindow.UWindowEditBoxHistory'.static.Allocate(self, none).;
		Construct_Void();
		HistoryList.SetupSentinel();
		CurrentHistory = none;
	}
	else
	{
		if(AndAnd_BoolBool(Not_PreBool(bHistory), NotEqual_ObjectObject(HistoryList, none)))
		{
			HistoryList = none;
			CurrentHistory = none;
		}
	}
	return;
}

function SetEditable(bool bEditable)
{
	bCanEdit = bEditable;
	return;
}

function SetValue(string NewValue, optional string NewValue2)
{
	Value = NewValue;
	Value2 = NewValue2;
	if(Greater_IntInt(CaretOffset, Len(Value)))
	{
		CaretOffset = Len(Value);
	}
	Notify(1);
	return;
}

function Clear()
{
	CaretOffset = 0;
	Value = "";
	Value2 = "";
	bAllSelected = false;
	if(bDelayedNotify)
	{
		bChangePending = true;
	}
	else
	{
		Notify(1);
	}
	return;
}

function SelectAll()
{
	if(AndAnd_BoolBool(bCanEdit, NotEqual_StrStr(Value, "")))
	{
		CaretOffset = Len(Value);
		bAllSelected = true;
	}
	return;
}

function string GetValue()
{
	return Value;
	return;
}

function string GetValue2()
{
	return Value2;
	return;
}

function Notify(byte E)
{
	if(NotEqual_ObjectObject(NotifyOwner, none))
	{
		NotifyOwner.Notify(E);
	}
	else
	{
		super.Notify(E);
	}
	return;
}

function InsertText(string Text)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, Len(Text)))
	{
		Insert(byte(Asc(Mid(Text, i, 1))));
		AddAdd_Int(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

function bool Insert(byte C)
{
	local string NewValue;

	NewValue = Concat_StrStr(Concat_StrStr(Left(Value, CaretOffset), Chr(int(C))), Mid(Value, CaretOffset));
	if(Greater_IntInt(Len(NewValue), MaxLength))
	{
		return false;
	}
	AddAdd_Int(CaretOffset);
	Value = NewValue;
	if(bDelayedNotify)
	{
		bChangePending = true;
	}
	else
	{
		Notify(1);
	}
	return true;
	return;
}

function bool Backspace()
{
	local string NewValue;

	if(EqualEqual_IntInt(CaretOffset, 0))
	{
		return false;
	}
	NewValue = Concat_StrStr(Left(Value, Subtract_IntInt(CaretOffset, 1)), Mid(Value, CaretOffset));
	SubtractSubtract_Int(CaretOffset);
	Value = NewValue;
	if(bDelayedNotify)
	{
		bChangePending = true;
	}
	else
	{
		Notify(1);
	}
	return true;
	return;
}

function bool Delete()
{
	local string NewValue;

	if(EqualEqual_IntInt(CaretOffset, Len(Value)))
	{
		return false;
	}
	NewValue = Concat_StrStr(Left(Value, CaretOffset), Mid(Value, Add_IntInt(CaretOffset, 1)));
	Value = NewValue;
	Notify(1);
	return true;
	return;
}

function bool WordLeft()
{
	J0x00:
	if(AndAnd_BoolBool(Greater_IntInt(CaretOffset, 0), EqualEqual_StrStr(Mid(Value, Subtract_IntInt(CaretOffset, 1), 1), " ")))
	{
		SubtractSubtract_Int(CaretOffset);
		// [Loop Continue]
		goto J0x00;
	}
	J0x2F:

	if(AndAnd_BoolBool(Greater_IntInt(CaretOffset, 0), NotEqual_StrStr(Mid(Value, Subtract_IntInt(CaretOffset, 1), 1), " ")))
	{
		SubtractSubtract_Int(CaretOffset);
		// [Loop Continue]
		goto J0x2F;
	}
	LastDrawTime = GetLevel().TimeSeconds;
	bShowCaret = true;
	return true;
	return;
}

function bool MoveLeft()
{
	if(EqualEqual_IntInt(CaretOffset, 0))
	{
		return false;
	}
	SubtractSubtract_Int(CaretOffset);
	LastDrawTime = GetLevel().TimeSeconds;
	bShowCaret = true;
	return true;
	return;
}

function bool MoveRight()
{
	if(EqualEqual_IntInt(CaretOffset, Len(Value)))
	{
		return false;
	}
	AddAdd_Int(CaretOffset);
	LastDrawTime = GetLevel().TimeSeconds;
	bShowCaret = true;
	return true;
	return;
}

function bool WordRight()
{
	J0x00:
	if(AndAnd_BoolBool(Less_IntInt(CaretOffset, Len(Value)), NotEqual_StrStr(Mid(Value, CaretOffset, 1), " ")))
	{
		AddAdd_Int(CaretOffset);
		// [Loop Continue]
		goto J0x00;
	}
	J0x32:

	if(AndAnd_BoolBool(Less_IntInt(CaretOffset, Len(Value)), EqualEqual_StrStr(Mid(Value, CaretOffset, 1), " ")))
	{
		AddAdd_Int(CaretOffset);
		// [Loop Continue]
		goto J0x32;
	}
	LastDrawTime = GetLevel().TimeSeconds;
	bShowCaret = true;
	return true;
	return;
}

function bool MoveHome()
{
	CaretOffset = 0;
	LastDrawTime = GetLevel().TimeSeconds;
	bShowCaret = true;
	return true;
	return;
}

function bool MoveEnd()
{
	CaretOffset = Len(Value);
	LastDrawTime = GetLevel().TimeSeconds;
	bShowCaret = true;
	return true;
	return;
}

function EditCopy()
{
	if(OrOr_BoolBool(bAllSelected, Not_PreBool(bCanEdit)))
	{
		GetPlayerOwner().CopyToClipboard(Value);
	}
	return;
}

function EditPaste()
{
	if(bCanEdit)
	{
		if(bAllSelected)
		{
			Clear();
		}
		InsertText(GetPlayerOwner().PasteFromClipboard());
	}
	return;
}

function EditCut()
{
	if(bCanEdit)
	{
		if(bAllSelected)
		{
			GetPlayerOwner().CopyToClipboard(Value);
			bAllSelected = false;
			Clear();
		}
	}
	else
	{
		EditCopy();
	}
	return;
}

function KeyPressed(int Key, float MouseX, float MouseY)
{
	if(AndAnd_BoolBool(bCanEdit, bKeyDown))
	{
		if(Not_PreBool(bControlDown))
		{
			if(bAllSelected)
			{
				Clear();
			}
			bAllSelected = false;
			if(bNumericOnly)
			{
				if(AndAnd_BoolBool(GreaterEqual_IntInt(Key, 48), LessEqual_IntInt(Key, 57)))
				{
					Insert(byte(Key));
				}
			}
			else
			{
				if(AndAnd_BoolBool(GreaterEqual_IntInt(Key, 32), Less_IntInt(Key, 128)))
				{
					Insert(byte(Key));
				}
			}
		}
	}
	return;
}

function KeyUp(int Key, float X, float Y)
{
	local PlayerController P;

	bKeyDown = false;
	P = GetPlayerOwner();
	switch(Key)
	{
		case int(P.Player.Console.17):
			bControlDown = false;
			break;
		case int(P.Player.Console.16):
			bShiftDown = false;
			break;
		default:
			break;
	}
	return;
}

function KeyDown(int Key, float X, float Y)
{
	bKeyDown = true;
	switch(Key)
	{
		case 17:
			bControlDown = true;
			break;
		case 16:
			bShiftDown = true;
			break;
		case 27:
			break;
		case 13:
			if(bCanEdit)
			{
				if(bHistory)
				{
					if(NotEqual_StrStr(Value, ""))
					{
						CurrentHistory = UWindowEditBoxHistory(HistoryList.Insert(Class'UWindow.UWindowEditBoxHistory'));
						CurrentHistory.HistoryText = Value;
					}
					CurrentHistory = HistoryList;
				}
				Notify(7);
			}
			break;
		case 236:
			if(bCanEdit)
			{
				Notify(14);
			}
			break;
		case 237:
			if(bCanEdit)
			{
				Notify(15);
			}
			break;
		case 39:
			if(bCanEdit)
			{
				if(bControlDown)
				{
					WordRight();
				}
				else
				{
					MoveRight();
				}
			}
			bAllSelected = false;
			break;
		case 37:
			if(bCanEdit)
			{
				if(bControlDown)
				{
					WordLeft();
				}
				else
				{
					MoveLeft();
				}
			}
			bAllSelected = false;
			break;
		case 38:
			if(AndAnd_BoolBool(bCanEdit, bHistory))
			{
				bAllSelected = false;
				if(AndAnd_BoolBool(NotEqual_ObjectObject(CurrentHistory, none), NotEqual_ObjectObject(CurrentHistory.Next, none)))
				{
					CurrentHistory = UWindowEditBoxHistory(CurrentHistory.Next);
					SetValue(CurrentHistory.HistoryText);
					MoveEnd();
				}
			}
			break;
		case 40:
			if(AndAnd_BoolBool(bCanEdit, bHistory))
			{
				bAllSelected = false;
				if(AndAnd_BoolBool(NotEqual_ObjectObject(CurrentHistory, none), NotEqual_ObjectObject(CurrentHistory.Prev, none)))
				{
					CurrentHistory = UWindowEditBoxHistory(CurrentHistory.Prev);
					SetValue(CurrentHistory.HistoryText);
					MoveEnd();
				}
			}
			break;
		case 36:
			if(bCanEdit)
			{
				MoveHome();
			}
			bAllSelected = false;
			break;
		case 35:
			if(bCanEdit)
			{
				MoveEnd();
			}
			bAllSelected = false;
			break;
		case 8:
			if(bCanEdit)
			{
				if(bAllSelected)
				{
					Clear();
				}
				else
				{
					Backspace();
				}
			}
			bAllSelected = false;
			break;
		case 46:
			if(bCanEdit)
			{
				if(bAllSelected)
				{
					Clear();
				}
				else
				{
					Delete();
				}
			}
			bAllSelected = false;
			break;
		case 190:
		case 110:
			if(bNumericFloat)
			{
				Insert(byte(Asc(".")));
			}
			break;
		default:
			if(bControlDown)
			{
				if(OrOr_BoolBool(EqualEqual_IntInt(Key, Asc("c")), EqualEqual_IntInt(Key, Asc("C"))))
				{
					EditCopy();
				}
				if(OrOr_BoolBool(EqualEqual_IntInt(Key, Asc("v")), EqualEqual_IntInt(Key, Asc("V"))))
				{
					EditPaste();
				}
				if(OrOr_BoolBool(EqualEqual_IntInt(Key, Asc("x")), EqualEqual_IntInt(Key, Asc("X"))))
				{
					EditCut();
				}
			}
			else
			{
				if(NotEqual_ObjectObject(NotifyOwner, none))
				{
					NotifyOwner.KeyDown(Key, X, Y);
				}
				else
				{
					super.KeyDown(Key, X, Y);
				}
			}
			break;
			break;
	}
	return;
}

function Click(float X, float Y)
{
	Notify(2);
	return;
}

function LMouseDown(float X, float Y)
{
	super(UWindowWindow).LMouseDown(X, Y);
	Notify(10);
	return;
}

function Paint(Canvas C, float X, float Y)
{
	local float W, H, TextY;

	C.Font = Root.Fonts[Font];
	TextSize(C, "A", W, H);
	TextY = Divide_FloatFloat(Subtract_FloatFloat(WinHeight, H), float(2));
	TextSize(C, Left(Value, CaretOffset), W, H);
	C.SetDrawColor(byte(255), byte(255), byte(255));
	if(Less_FloatFloat(Add_FloatFloat(W, Offset), float(0)))
	{
		Offset = Subtract_PreFloat(W);
	}
	if(Greater_FloatFloat(Add_FloatFloat(W, Offset), Subtract_FloatFloat(WinWidth, float(2))))
	{
		Offset = Subtract_FloatFloat(Subtract_FloatFloat(WinWidth, float(2)), W);
		if(Greater_FloatFloat(Offset, float(0)))
		{
			Offset = 0.0000000;
		}
	}
	C.DrawColor = TextColor;
	if(bAllSelected)
	{
		DrawStretchedTexture(C, Add_FloatFloat(Offset, float(1)), TextY, W, H, Texture'UWindow_res.WhiteTexture');
		C.SetDrawColor(byte(Xor_IntInt(255, int(C.DrawColor.R))), byte(Xor_IntInt(255, int(C.DrawColor.G))), byte(Xor_IntInt(255, int(C.DrawColor.B))));
	}
	ClipText(C, Add_FloatFloat(Offset, float(1)), TextY, Value);
	if(OrOr_BoolBool(Not_PreBool(bHasKeyboardFocus), Not_PreBool(bCanEdit)))
	{
		bShowCaret = false;
	}
	else
	{
		if(OrOr_BoolBool(Greater_FloatFloat(GetLevel().TimeSeconds, Add_FloatFloat(LastDrawTime, 0.3000000)), Less_FloatFloat(GetLevel().TimeSeconds, LastDrawTime)))
		{
			LastDrawTime = GetLevel().TimeSeconds;
			bShowCaret = Not_PreBool(bShowCaret);
		}
	}
	if(bShowCaret)
	{
		ClipText(C, Subtract_FloatFloat(Add_FloatFloat(Offset, W), float(1)), TextY, "|");
	}
	return;
}

function Close(optional bool bByParent)
{
	if(bChangePending)
	{
		bChangePending = false;
		Notify(1);
	}
	bKeyDown = false;
	super(UWindowWindow).Close(bByParent);
	return;
}

function FocusOtherWindow(UWindowWindow W)
{
	if(bChangePending)
	{
		bChangePending = false;
		Notify(1);
	}
	if(NotEqual_ObjectObject(NotifyOwner, none))
	{
		NotifyOwner.FocusOtherWindow(W);
	}
	else
	{
		super(UWindowWindow).FocusOtherWindow(W);
	}
	return;
}

function KeyFocusEnter()
{
	if(AndAnd_BoolBool(bSelectOnFocus, Not_PreBool(bHasKeyboardFocus)))
	{
		SelectAll();
	}
	super.KeyFocusEnter();
	return;
}

function DoubleClick(float X, float Y)
{
	super(UWindowWindow).DoubleClick(X, Y);
	SelectAll();
	return;
}

function KeyFocusExit()
{
	bAllSelected = false;
	super.KeyFocusExit();
	return;
}
