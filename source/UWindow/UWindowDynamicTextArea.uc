class UWindowDynamicTextArea extends UWindowDialogControl
	config;

var config int MaxLines;
var bool bTopCentric;
var float DefaultTextHeight;
var bool bScrollOnResize;
var bool bVCenter;
var bool bHCenter;
var bool bAutoScrollbar;
var bool bVariableRowHeight;
var float WrapWidth;
var UWindowDynamicTextRow List;
var UWindowVScrollbar VertSB;
var float OldW;
var float OldH;
var bool bDirty;
var int Count;
var int VisibleRows;
var int Font;
var Font AbsoluteFont;
var Color TextColor;
var Class<UWindowDynamicTextRow> RowClass;

function Created()
{
	super.Created();
	VertSB = UWindowVScrollbar(CreateWindow(Class'UWindow.UWindowVScrollbar', Subtract_FloatFloat(WinWidth, float(12)), 0.0000000, 12.0000000, WinHeight));
	VertSB.bAlwaysOnTop = true;
	Cursor = Root.NormalCursor;
	Clear();
	return;
}

function Clear()
{
	bDirty = true;
	if(NotEqual_ObjectObject(List, none))
	{
		if(EqualEqual_ObjectObject(List.Next, none))
		{
			return;
		}
		List.DestroyList();
	}
	List = RowClass.static.Allocate(self).;
	Construct_Void();
	List.SetupSentinel();
	return;
}

function SetAbsoluteFont(Font F)
{
	AbsoluteFont = F;
	return;
}

function SetFont(int F)
{
	Font = F;
	return;
}

function SetTextColor(Color C)
{
	TextColor = C;
	return;
}

function TextAreaClipText(Canvas C, float DrawX, float DrawY, coerce string S, optional bool bCheckHotKey)
{
	ClipText(C, DrawX, DrawY, S, bCheckHotKey);
	return;
}

function TextAreaTextSize(Canvas C, string Text, out float W, out float H)
{
	TextSize(C, Text, W, H);
	return;
}

function BeforePaint(Canvas C, float X, float Y)
{
	super.BeforePaint(C, X, Y);
	VertSB.WinTop = 0.0000000;
	VertSB.WinHeight = WinHeight;
	VertSB.WinWidth = LookAndFeel.Size_ScrollbarWidth;
	VertSB.WinLeft = Subtract_FloatFloat(WinWidth, LookAndFeel.Size_ScrollbarWidth);
	return;
}

function Paint(Canvas C, float MouseX, float MouseY)
{
	local UWindowDynamicTextRow L;
	local int SkipCount, DrawCount, i;
	local float Y, Junk;
	local bool bWrapped;

	C.DrawColor = TextColor;
	if(NotEqual_ObjectObject(AbsoluteFont, none))
	{
		C.Font = AbsoluteFont;
	}
	else
	{
		C.Font = Root.Fonts[Font];
	}
	if(OrOr_BoolBool(NotEqual_FloatFloat(OldW, WinWidth), NotEqual_FloatFloat(OldH, WinHeight)))
	{
		WordWrap(C, true);
		OldW = WinWidth;
		OldH = WinHeight;
		bWrapped = true;
	}
	else
	{
		if(bDirty)
		{
			WordWrap(C, false);
			bWrapped = true;
		}
	}
	if(bWrapped)
	{
		TextAreaTextSize(C, "A", Junk, DefaultTextHeight);
		VisibleRows = int(Divide_FloatFloat(WinHeight, DefaultTextHeight));
		Count = List.Count();
		VertSB.SetRange(0.0000000, float(Count), float(VisibleRows));
		if(bScrollOnResize)
		{
			if(bTopCentric)
			{
				VertSB.pos = 0.0000000;
			}
			else
			{
				VertSB.pos = VertSB.MaxPos;
			}
		}
		if(AndAnd_BoolBool(bAutoScrollbar, Not_PreBool(bVariableRowHeight)))
		{
			if(LessEqual_IntInt(Count, VisibleRows))
			{
				VertSB.HideWindow();
			}
			else
			{
				VertSB.ShowWindow();
			}
		}
	}
	if(bTopCentric)
	{
		SkipCount = int(VertSB.pos);
		L = UWindowDynamicTextRow(List.Next);
		i = 0;
		J0x1FA:

		if(AndAnd_BoolBool(Less_IntInt(i, SkipCount), NotEqual_ObjectObject(L, none)))
		{
			L = UWindowDynamicTextRow(L.Next);
			AddAdd_Int(i);
			// [Loop Continue]
			goto J0x1FA;
		}
		if(AndAnd_BoolBool(bVCenter, LessEqual_IntInt(Count, VisibleRows)))
		{
			Y = float(int(Divide_FloatFloat(Subtract_FloatFloat(WinHeight, Multiply_FloatFloat(float(Count), DefaultTextHeight)), float(2))));
		}
		else
		{
			Y = 1.0000000;
		}
		DrawCount = 0;
		J0x28D:

		if(Less_FloatFloat(Y, WinHeight))
		{
			AddAdd_Int(DrawCount);
			if(NotEqual_ObjectObject(L, none))
			{
				AddEqual_FloatFloat(Y, DrawTextLine(C, L, Y));
				L = UWindowDynamicTextRow(L.Next);
			}
			else
			{
				AddEqual_FloatFloat(Y, DefaultTextHeight);
			}
			// [Loop Continue]
			goto J0x28D;
		}
		if(bVariableRowHeight)
		{
			VisibleRows = Subtract_IntInt(DrawCount, 1);
			J0x30C:

			if(Greater_FloatFloat(Add_FloatFloat(VertSB.pos, float(VisibleRows)), float(Count)))
			{
				SubtractSubtract_Int(VisibleRows);
				// [Loop Continue]
				goto J0x30C;
			}
			VertSB.SetRange(0.0000000, float(Count), float(VisibleRows));
			if(bAutoScrollbar)
			{
				if(LessEqual_IntInt(Count, VisibleRows))
				{
					VertSB.HideWindow();
				}
				else
				{
					VertSB.ShowWindow();
				}
			}
		}
	}
	else
	{
		SkipCount = Max(0, int(Subtract_FloatFloat(float(Count), Add_FloatFloat(float(VisibleRows), VertSB.pos))));
		L = UWindowDynamicTextRow(List.Last);
		i = 0;
		J0x3E2:

		if(AndAnd_BoolBool(Less_IntInt(i, SkipCount), NotEqual_ObjectObject(L, List)))
		{
			L = UWindowDynamicTextRow(L.Prev);
			AddAdd_Int(i);
			// [Loop Continue]
			goto J0x3E2;
		}
		Y = Subtract_FloatFloat(WinHeight, DefaultTextHeight);
		J0x437:

		if(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(L, List), NotEqual_ObjectObject(L, none)), Greater_FloatFloat(Y, Subtract_PreFloat(DefaultTextHeight))))
		{
			DrawTextLine(C, L, Y);
			Y = Subtract_FloatFloat(Y, DefaultTextHeight);
			L = UWindowDynamicTextRow(L.Prev);
			// [Loop Continue]
			goto J0x437;
		}
	}
	return;
}

function UWindowDynamicTextRow AddText(string NewLine)
{
	local UWindowDynamicTextRow L;
	local string temp;
	local int i;

	bDirty = true;
	i = InStr(NewLine, "\\n");
	if(NotEqual_IntInt(i, -1))
	{
		temp = Mid(NewLine, Add_IntInt(i, 2));
		NewLine = Left(NewLine, i);
	}
	else
	{
		temp = "";
	}
	L = CheckMaxRows();
	if(NotEqual_ObjectObject(L, none))
	{
		List.AppendItem(L);
	}
	else
	{
		L = UWindowDynamicTextRow(List.Append(RowClass));
	}
	L.Text = NewLine;
	L.WrapParent = none;
	L.bRowDirty = true;
	if(NotEqual_StrStr(temp, ""))
	{
		AddText(temp);
	}
	return L;
	return;
}

function UWindowDynamicTextRow CheckMaxRows()
{
	local UWindowDynamicTextRow L;

	L = none;
	J0x07:

	if(AndAnd_BoolBool(AndAnd_BoolBool(Greater_IntInt(MaxLines, 0), Greater_IntInt(List.Count(), Subtract_IntInt(MaxLines, 1))), NotEqual_ObjectObject(List.Next, none)))
	{
		L = UWindowDynamicTextRow(List.Next);
		RemoveWrap(L);
		L.Remove();
		// [Loop Continue]
		goto J0x07;
	}
	return L;
	return;
}

function WordWrap(Canvas C, bool bForce)
{
	local UWindowDynamicTextRow L;

	L = UWindowDynamicTextRow(List.Next);
	J0x19:

	if(NotEqual_ObjectObject(L, none))
	{
		if(AndAnd_BoolBool(EqualEqual_ObjectObject(L.WrapParent, none), OrOr_BoolBool(L.bRowDirty, bForce)))
		{
			WrapRow(C, L);
		}
		L = UWindowDynamicTextRow(L.Next);
		// [Loop Continue]
		goto J0x19;
	}
	bDirty = false;
	return;
}

function WrapRow(Canvas C, UWindowDynamicTextRow L)
{
	local UWindowDynamicTextRow CurrentRow, n;
	local float MaxWidth;
	local int WrapPos;

	if(EqualEqual_FloatFloat(WrapWidth, float(0)))
	{
		if(OrOr_BoolBool(VertSB.bWindowVisible, bAutoScrollbar))
		{
			MaxWidth = Subtract_FloatFloat(WinWidth, VertSB.WinWidth);
		}
		else
		{
			MaxWidth = WinWidth;
		}
	}
	else
	{
		MaxWidth = WrapWidth;
	}
	L.bRowDirty = false;
	n = UWindowDynamicTextRow(L.Next);
	if(OrOr_BoolBool(EqualEqual_ObjectObject(n, none), NotEqual_ObjectObject(n.WrapParent, L)))
	{
		if(EqualEqual_IntInt(GetWrapPos(C, L, MaxWidth), -1))
		{
			return;
		}
	}
	RemoveWrap(L);
	CurrentRow = L;
	J0xE7:

	if(true)
	{
		WrapPos = GetWrapPos(C, CurrentRow, MaxWidth);
		if(EqualEqual_IntInt(WrapPos, -1))
		{
			// [Explicit Break]
			goto J0x131;
		}
		CurrentRow = SplitRowAt(CurrentRow, WrapPos);
		// [Loop Continue]
		goto J0xE7;
	}
	J0x131:

	return;
}

function float DrawTextLine(Canvas C, UWindowDynamicTextRow L, float Y)
{
	local float X, W, H;

	if(bHCenter)
	{
		TextAreaTextSize(C, L.Text, W, H);
		if(VertSB.bWindowVisible)
		{
			X = float(int(Divide_FloatFloat(Subtract_FloatFloat(Subtract_FloatFloat(WinWidth, VertSB.WinWidth), W), float(2))));
		}
		else
		{
			X = float(int(Divide_FloatFloat(Subtract_FloatFloat(WinWidth, W), float(2))));
		}
	}
	else
	{
		X = 2.0000000;
	}
	TextAreaClipText(C, X, Y, L.Text);
	return DefaultTextHeight;
	return;
}

function int GetWrapPos(Canvas C, UWindowDynamicTextRow L, float MaxWidth)
{
	local float W, H, LineWidth, NextWordWidth;
	local string Input, NextWord;
	local int WordsThisRow, WrapPos;

	TextAreaTextSize(C, L.Text, W, H);
	if(LessEqual_FloatFloat(W, MaxWidth))
	{
		return -1;
	}
	Input = L.Text;
	WordsThisRow = 0;
	LineWidth = 0.0000000;
	WrapPos = 0;
	NextWord = "";
	J0x6D:

	if(OrOr_BoolBool(NotEqual_StrStr(Input, ""), NotEqual_StrStr(NextWord, "")))
	{
		if(EqualEqual_StrStr(NextWord, ""))
		{
			RemoveNextWord(Input, NextWord);
			TextAreaTextSize(C, NextWord, NextWordWidth, H);
		}
		if(AndAnd_BoolBool(Greater_IntInt(WordsThisRow, 0), Greater_FloatFloat(Add_FloatFloat(LineWidth, NextWordWidth), MaxWidth)))
		{
			return WrapPos;
		}
		else
		{
			AddEqual_IntInt(WrapPos, Len(NextWord));
			AddEqual_FloatFloat(LineWidth, NextWordWidth);
			NextWord = "";
			AddAdd_Int(WordsThisRow);
		}
		// [Loop Continue]
		goto J0x6D;
	}
	return -1;
	return;
}

function UWindowDynamicTextRow SplitRowAt(UWindowDynamicTextRow L, int SplitPos)
{
	local UWindowDynamicTextRow n;

	n = UWindowDynamicTextRow(L.InsertAfter(RowClass));
	if(EqualEqual_ObjectObject(L.WrapParent, none))
	{
		n.WrapParent = L;
	}
	else
	{
		n.WrapParent = L.WrapParent;
	}
	n.Text = Mid(L.Text, SplitPos);
	L.Text = Left(L.Text, SplitPos);
	return n;
	return;
}

function RemoveNextWord(out string Text, out string NextWord)
{
	local int i;

	i = InStr(Text, " ");
	if(EqualEqual_IntInt(i, -1))
	{
		NextWord = Text;
		Text = "";
	}
	else
	{
		J0x35:

		if(EqualEqual_StrStr(Mid(Text, i, 1), " "))
		{
			AddAdd_Int(i);
			// [Loop Continue]
			goto J0x35;
		}
		NextWord = Left(Text, i);
		Text = Mid(Text, i);
	}
	return;
}

function RemoveWrap(UWindowDynamicTextRow L)
{
	local UWindowDynamicTextRow n;

	n = UWindowDynamicTextRow(L.Next);
	J0x19:

	if(AndAnd_BoolBool(NotEqual_ObjectObject(n, none), EqualEqual_ObjectObject(n.WrapParent, L)))
	{
		L.Text = Concat_StrStr(L.Text, n.Text);
		n.Remove();
		n = UWindowDynamicTextRow(L.Next);
		// [Loop Continue]
		goto J0x19;
	}
	return;
}

defaultproperties
{
	bScrollOnResize=true
	TextColor=(R=255,G=255,B=255,A=255)
	RowClass=Class'UWindow.UWindowDynamicTextRow'
	bNoKeyboard=true
}