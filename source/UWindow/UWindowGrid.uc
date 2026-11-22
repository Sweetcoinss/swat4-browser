class UWindowGrid extends UWindowWindow;

var UWindowGridColumn FirstColumn;
var UWindowGridColumn LastColumn;
var UWindowGridClient ClientArea;
var int TopRow;
var float RowHeight;
var UWindowVScrollbar VertSB;
var UWindowHScrollbar HorizSB;
var bool bShowHorizSB;
var bool bSizingColumn;
var bool bNoKeyboard;

function Created()
{
	ClientArea = UWindowGridClient(CreateWindow(Class'UWindow.UWindowGridClient', 0.0000000, 0.0000000, Subtract_FloatFloat(WinWidth, float(12)), WinHeight));
	VertSB = UWindowVScrollbar(CreateWindow(Class'UWindow.UWindowVScrollbar', Subtract_FloatFloat(WinWidth, float(12)), 0.0000000, 12.0000000, WinHeight));
	VertSB.bAlwaysOnTop = true;
	HorizSB = UWindowHScrollbar(CreateWindow(Class'UWindow.UWindowHScrollbar', 0.0000000, Subtract_FloatFloat(WinHeight, float(12)), WinWidth, 12.0000000));
	HorizSB.bAlwaysOnTop = true;
	HorizSB.HideWindow();
	bShowHorizSB = false;
	if(Not_PreBool(bNoKeyboard))
	{
		SetAcceptsFocus();
	}
	super.Created();
	return;
}

function BeforePaint(Canvas C, float X, float Y)
{
	super.BeforePaint(C, X, Y);
	Resized();
	return;
}

function Resized()
{
	local float Offset;
	local UWindowGridColumn colColumn;
	local float TotalWidth;

	TotalWidth = 0.0000000;
	colColumn = FirstColumn;
	J0x16:

	if(NotEqual_ObjectObject(colColumn, none))
	{
		TotalWidth = Add_FloatFloat(TotalWidth, colColumn.WinWidth);
		colColumn = colColumn.NextColumn;
		// [Loop Continue]
		goto J0x16;
	}
	if(Not_PreBool(bSizingColumn))
	{
		HorizSB.SetRange(0.0000000, TotalWidth, Subtract_FloatFloat(WinWidth, LookAndFeel.Size_ScrollbarWidth), 10.0000000);
	}
	if(Not_PreBool(HorizSB.bDisabled))
	{
		HorizSB.ShowWindow();
		bShowHorizSB = true;
	}
	else
	{
		HorizSB.HideWindow();
		bShowHorizSB = false;
		HorizSB.pos = 0.0000000;
	}
	ClientArea.WinTop = 0.0000000;
	ClientArea.WinLeft = 0.0000000;
	ClientArea.WinWidth = Subtract_FloatFloat(WinWidth, LookAndFeel.Size_ScrollbarWidth);
	if(bShowHorizSB)
	{
		ClientArea.WinHeight = Subtract_FloatFloat(WinHeight, LookAndFeel.Size_ScrollbarWidth);
	}
	else
	{
		ClientArea.WinHeight = WinHeight;
	}
	if(bShowHorizSB)
	{
		HorizSB.WinTop = Subtract_FloatFloat(WinHeight, LookAndFeel.Size_ScrollbarWidth);
		HorizSB.WinLeft = 0.0000000;
		HorizSB.WinWidth = Subtract_FloatFloat(WinWidth, LookAndFeel.Size_ScrollbarWidth);
		HorizSB.WinHeight = LookAndFeel.Size_ScrollbarWidth;
	}
	VertSB.WinTop = 0.0000000;
	VertSB.WinLeft = Subtract_FloatFloat(WinWidth, LookAndFeel.Size_ScrollbarWidth);
	VertSB.WinWidth = LookAndFeel.Size_ScrollbarWidth;
	if(bShowHorizSB)
	{
		VertSB.WinHeight = Subtract_FloatFloat(WinHeight, LookAndFeel.Size_ScrollbarWidth);
	}
	else
	{
		VertSB.WinHeight = WinHeight;
	}
	if(bShowHorizSB)
	{
		Offset = Subtract_FloatFloat(1.0000000, HorizSB.pos);
	}
	else
	{
		Offset = 1.0000000;
	}
	colColumn = FirstColumn;
	J0x2D2:

	if(NotEqual_ObjectObject(colColumn, none))
	{
		colColumn.WinLeft = Offset;
		colColumn.WinTop = 0.0000000;
		colColumn.WinHeight = WinHeight;
		Offset = Add_FloatFloat(Offset, colColumn.WinWidth);
		colColumn = colColumn.NextColumn;
		// [Loop Continue]
		goto J0x2D2;
	}
	return;
}

function UWindowGridColumn AddColumn(string ColumnHeading, float DefaultWidth)
{
	local UWindowGridColumn NewColumn, OldLastColumn;

	OldLastColumn = LastColumn;
	if(EqualEqual_ObjectObject(LastColumn, none))
	{
		NewColumn = UWindowGridColumn(ClientArea.CreateWindow(Class'UWindow.UWindowGridColumn', 0.0000000, 0.0000000, DefaultWidth, WinHeight));
		FirstColumn = NewColumn;
		NewColumn.ColumnNum = 0;
	}
	else
	{
		NewColumn = UWindowGridColumn(ClientArea.CreateWindow(Class'UWindow.UWindowGridColumn', Add_FloatFloat(LastColumn.WinLeft, LastColumn.WinWidth), 0.0000000, DefaultWidth, WinHeight));
		LastColumn.NextColumn = NewColumn;
		NewColumn.ColumnNum = Add_IntInt(LastColumn.ColumnNum, 1);
	}
	LastColumn = NewColumn;
	NewColumn.NextColumn = none;
	NewColumn.PrevColumn = OldLastColumn;
	NewColumn.ColumnHeading = ColumnHeading;
	return NewColumn;
	return;
}

function Paint(Canvas C, float MouseX, float MouseY)
{
	local float X;
	local Texture t;
	local Region R;

	X = Add_FloatFloat(LastColumn.WinWidth, LastColumn.WinLeft);
	t = GetLookAndFeelTexture();
	DrawUpBevel(C, X, 0.0000000, Subtract_FloatFloat(WinWidth, X), float(LookAndFeel.ColumnHeadingHeight), t);
	if(bShowHorizSB)
	{
		DrawStretchedTextureSegment(C, Subtract_FloatFloat(WinWidth, LookAndFeel.Size_ScrollbarWidth), Subtract_FloatFloat(WinHeight, LookAndFeel.Size_ScrollbarWidth), LookAndFeel.Size_ScrollbarWidth, LookAndFeel.Size_ScrollbarWidth, float(R.X), float(R.Y), float(R.W), float(R.H), t);
	}
	return;
}

function PaintColumn(Canvas C, UWindowGridColumn Column, float MouseX, float MouseY)
{
	return;
}

function SortColumn(UWindowGridColumn Column)
{
	return;
}

function SelectRow(int Row)
{
	return;
}

function RightClickRow(int Row, float X, float Y)
{
	return;
}

function RightClickRowDown(int Row, float X, float Y)
{
	return;
}

function DoubleClickRow(int Row)
{
	return;
}

function MouseLeaveColumn(UWindowGridColumn Column)
{
	return;
}

function KeyDown(int Key, float X, float Y)
{
	switch(Key)
	{
		case 38:
		case 236:
			VertSB.Scroll(-1.0000000);
			break;
		case 40:
		case 237:
			VertSB.Scroll(1.0000000);
			break;
		case 33:
			VertSB.Scroll(Subtract_PreFloat(Subtract_FloatFloat(VertSB.MaxVisible, float(1))));
			break;
		case 34:
			VertSB.Scroll(Subtract_FloatFloat(VertSB.MaxVisible, float(1)));
			break;
		default:
			break;
	}
	return;
}

defaultproperties
{
	RowHeight=10.0000000
}