class UWindowGridColumn extends UWindowWindow;

var UWindowGridColumn NextColumn;
var UWindowGridColumn PrevColumn;
var bool bSizing;
var string ColumnHeading;
var int ColumnNum;

function Created()
{
	super.Created();
	return;
}

function BeforePaint(Canvas C, float X, float Y)
{
	super.BeforePaint(C, X, Y);
	if(Less_FloatFloat(WinWidth, float(1)))
	{
		WinWidth = 1.0000000;
	}
	return;
}

function LMouseDown(float X, float Y)
{
	super.LMouseDown(X, Y);
	if(AndAnd_BoolBool(Greater_FloatFloat(X, float(Min(int(Subtract_FloatFloat(WinWidth, float(5))), int(Subtract_FloatFloat(Subtract_FloatFloat(ParentWindow.WinWidth, WinLeft), float(5)))))), Less_FloatFloat(Y, float(12))))
	{
		bSizing = true;
		UWindowGrid(ParentWindow.ParentWindow).bSizingColumn = true;
		Root.CaptureMouse();
	}
	return;
}

function LMouseUp(float X, float Y)
{
	super.LMouseUp(X, Y);
	UWindowGrid(ParentWindow.ParentWindow).bSizingColumn = false;
	return;
}

function MouseMove(float X, float Y)
{
	if(AndAnd_BoolBool(Greater_FloatFloat(X, float(Min(int(Subtract_FloatFloat(WinWidth, float(5))), int(Subtract_FloatFloat(Subtract_FloatFloat(ParentWindow.WinWidth, WinLeft), float(5)))))), Less_FloatFloat(Y, float(12))))
	{
		Cursor = Root.HSplitCursor;
	}
	else
	{
		Cursor = Root.NormalCursor;
	}
	if(AndAnd_BoolBool(bSizing, bMouseDown))
	{
		WinWidth = X;
		if(Less_FloatFloat(WinWidth, float(1)))
		{
			WinWidth = 1.0000000;
		}
		if(Greater_FloatFloat(WinWidth, Subtract_FloatFloat(Subtract_FloatFloat(ParentWindow.WinWidth, WinLeft), float(1))))
		{
			WinWidth = Subtract_FloatFloat(Subtract_FloatFloat(ParentWindow.WinWidth, WinLeft), float(1));
		}
	}
	else
	{
		bSizing = false;
		UWindowGrid(ParentWindow.ParentWindow).bSizingColumn = false;
	}
	return;
}

function Paint(Canvas C, float X, float Y)
{
	local Texture t;
	local Color FC;

	UWindowGrid(ParentWindow.ParentWindow).PaintColumn(C, self, X, Y);
	if(isActive())
	{
		t = LookAndFeel.Active;
		FC = LookAndFeel.HeadingActiveTitleColor;
	}
	else
	{
		t = LookAndFeel.Inactive;
		FC = LookAndFeel.HeadingInActiveTitleColor;
	}
	C.SetDrawColor(byte(255), byte(255), byte(255));
	DrawUpBevel(C, 0.0000000, 0.0000000, WinWidth, float(LookAndFeel.ColumnHeadingHeight), t);
	C.DrawColor = FC;
	ClipText(C, 2.0000000, 1.0000000, ColumnHeading);
	C.SetDrawColor(byte(255), byte(255), byte(255));
	return;
}

function Click(float X, float Y)
{
	local int Row;

	if(Less_FloatFloat(Y, float(12)))
	{
		if(LessEqual_FloatFloat(X, float(Min(int(Subtract_FloatFloat(WinWidth, float(5))), int(Subtract_FloatFloat(Subtract_FloatFloat(ParentWindow.WinWidth, WinLeft), float(5)))))))
		{
			UWindowGrid(ParentWindow.ParentWindow).SortColumn(self);
		}
	}
	else
	{
		Row = Add_IntInt(int(Divide_FloatFloat(float(int(Subtract_FloatFloat(Y, float(12)))), UWindowGrid(ParentWindow.ParentWindow).RowHeight)), UWindowGrid(ParentWindow.ParentWindow).TopRow);
		UWindowGrid(ParentWindow.ParentWindow).SelectRow(Row);
	}
	return;
}

function RMouseDown(float X, float Y)
{
	local int Row;

	super.RMouseDown(X, Y);
	if(Greater_FloatFloat(Y, float(12)))
	{
		Row = Add_IntInt(int(Divide_FloatFloat(float(int(Subtract_FloatFloat(Y, float(12)))), UWindowGrid(ParentWindow.ParentWindow).RowHeight)), UWindowGrid(ParentWindow.ParentWindow).TopRow);
		UWindowGrid(ParentWindow.ParentWindow).SelectRow(Row);
		UWindowGrid(ParentWindow.ParentWindow).RightClickRowDown(Row, Add_FloatFloat(X, WinLeft), Add_FloatFloat(Y, WinTop));
	}
	return;
}

function RMouseUp(float X, float Y)
{
	local int Row;

	super.RMouseUp(X, Y);
	if(Greater_FloatFloat(Y, float(12)))
	{
		Row = Add_IntInt(int(Divide_FloatFloat(float(int(Subtract_FloatFloat(Y, float(12)))), UWindowGrid(ParentWindow.ParentWindow).RowHeight)), UWindowGrid(ParentWindow.ParentWindow).TopRow);
		UWindowGrid(ParentWindow.ParentWindow).SelectRow(Row);
		UWindowGrid(ParentWindow.ParentWindow).RightClickRow(Row, Add_FloatFloat(X, WinLeft), Add_FloatFloat(Y, WinTop));
	}
	return;
}

function DoubleClick(float X, float Y)
{
	local int Row;

	if(Less_FloatFloat(Y, float(12)))
	{
		Click(X, Y);
	}
	else
	{
		Row = Add_IntInt(int(Divide_FloatFloat(float(int(Subtract_FloatFloat(Y, float(12)))), UWindowGrid(ParentWindow.ParentWindow).RowHeight)), UWindowGrid(ParentWindow.ParentWindow).TopRow);
		UWindowGrid(ParentWindow.ParentWindow).DoubleClickRow(Row);
	}
	return;
}

function MouseLeave()
{
	super.MouseLeave();
	UWindowGrid(ParentWindow.ParentWindow).MouseLeaveColumn(self);
	return;
}
