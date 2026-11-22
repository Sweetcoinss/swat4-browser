class UWindowTabControlTabArea extends UWindowWindow
	config;

var int TabOffset;
var bool bShowSelected;
var UWindowTabControlItem FirstShown;
var bool bDragging;
var UWindowTabControlItem DragTab;
var int TabRows;
var globalconfig bool bArrangeRowsLikeTimHates;
var float UnFlashTime;
var bool bFlashShown;

function Created()
{
	TabOffset = 0;
	super.Created();
	return;
}

function SizeTabsSingleLine(Canvas C)
{
	local UWindowTabControlItem i, Selected, LastHidden;
	local int Count, TabCount;
	local float ItemX, W, H;
	local bool bHaveMore;

	ItemX = LookAndFeel.Size_TabXOffset;
	TabCount = 0;
	i = UWindowTabControlItem(UWindowTabControl(ParentWindow).Items.Next);
	J0x42:

	if(NotEqual_ObjectObject(i, none))
	{
		LookAndFeel.Tab_GetTabSize(self, C, RemoveAmpersand(i.Caption), W, H);
		i.TabWidth = W;
		i.TabHeight = Add_FloatFloat(H, float(1));
		i.TabTop = 0.0000000;
		i.RowNumber = 0;
		AddAdd_Int(TabCount);
		i = UWindowTabControlItem(i.Next);
		// [Loop Continue]
		goto J0x42;
	}
	Selected = UWindowTabControl(ParentWindow).SelectedTab;
	J0x10D:

	if(true)
	{
		ItemX = LookAndFeel.Size_TabXOffset;
		Count = 0;
		LastHidden = none;
		FirstShown = none;
		i = UWindowTabControlItem(UWindowTabControl(ParentWindow).Items.Next);
		J0x161:

		if(NotEqual_ObjectObject(i, none))
		{
			if(Less_IntInt(Count, TabOffset))
			{
				i.TabLeft = -1.0000000;
				LastHidden = i;
			}
			else
			{
				if(EqualEqual_ObjectObject(FirstShown, none))
				{
					FirstShown = i;
				}
				i.TabLeft = ItemX;
				if(GreaterEqual_FloatFloat(Add_FloatFloat(i.TabLeft, i.TabWidth), Add_FloatFloat(WinWidth, float(5))))
				{
					bHaveMore = true;
				}
				AddEqual_FloatFloat(ItemX, i.TabWidth);
			}
			AddAdd_Int(Count);
			i = UWindowTabControlItem(i.Next);
			// [Loop Continue]
			goto J0x161;
		}
		if(AndAnd_BoolBool(AndAnd_BoolBool(Greater_IntInt(TabOffset, 0), NotEqual_ObjectObject(LastHidden, none)), Less_FloatFloat(Add_FloatFloat(LastHidden.TabWidth, float(5)), Subtract_FloatFloat(WinWidth, ItemX))))
		{
			SubtractSubtract_Int(TabOffset);
		}
		else
		{
			if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(bShowSelected, Less_IntInt(TabOffset, Subtract_IntInt(TabCount, 1))), NotEqual_ObjectObject(Selected, none)), NotEqual_ObjectObject(Selected, FirstShown)), Greater_FloatFloat(Add_FloatFloat(Selected.TabLeft, Selected.TabWidth), Subtract_FloatFloat(WinWidth, float(5)))))
			{
				AddAdd_Int(TabOffset);
			}
			else
			{
				// [Explicit Break]
				goto J0x2F9;
			}
		}
		// [Loop Continue]
		goto J0x10D;
	}
	J0x2F9:

	bShowSelected = false;
	UWindowTabControl(ParentWindow).LeftButton.bDisabled = LessEqual_IntInt(TabOffset, 0);
	UWindowTabControl(ParentWindow).RightButton.bDisabled = Not_PreBool(bHaveMore);
	TabRows = 1;
	return;
}

function SizeTabsMultiLine(Canvas C)
{
	local UWindowTabControlItem i, Selected;
	local float W, H;
	local int MinRow;
	local float RowWidths[10];
	local int TabCounts[10], j;
	local bool bTryAnotherRow;

	TabOffset = 0;
	FirstShown = none;
	TabRows = 1;
	bTryAnotherRow = true;
	J0x1D:

	if(AndAnd_BoolBool(bTryAnotherRow, LessEqual_IntInt(TabRows, 10)))
	{
		bTryAnotherRow = false;
		j = 0;
		J0x43:

		if(Less_IntInt(j, TabRows))
		{
			RowWidths[j] = 0.0000000;
			TabCounts[j] = 0;
			AddAdd_Int(j);
			// [Loop Continue]
			goto J0x43;
		}
		i = UWindowTabControlItem(UWindowTabControl(ParentWindow).Items.Next);
		J0xA1:

		if(NotEqual_ObjectObject(i, none))
		{
			LookAndFeel.Tab_GetTabSize(self, C, RemoveAmpersand(i.Caption), W, H);
			i.TabWidth = W;
			i.TabHeight = H;
			MinRow = 0;
			j = 1;
			J0x115:

			if(Less_IntInt(j, TabRows))
			{
				if(Less_FloatFloat(RowWidths[j], RowWidths[MinRow]))
				{
					MinRow = j;
				}
				AddAdd_Int(j);
				// [Loop Continue]
				goto J0x115;
			}
			if(Greater_FloatFloat(Add_FloatFloat(RowWidths[MinRow], W), WinWidth))
			{
				AddAdd_Int(TabRows);
				bTryAnotherRow = true;
				// [Explicit Break]
				goto J0x1D4;
			}
			else
			{
				AddEqual_FloatFloat(RowWidths[MinRow], W);
				AddAdd_Int(TabCounts[MinRow]);
				i.RowNumber = MinRow;
			}
			i = UWindowTabControlItem(i.Next);
			// [Loop Continue]
			goto J0xA1;
		}
		J0x1D4:

		// [Loop Continue]
		goto J0x1D;
	}
	Selected = UWindowTabControl(ParentWindow).SelectedTab;
	if(Greater_IntInt(TabRows, 1))
	{
		i = UWindowTabControlItem(UWindowTabControl(ParentWindow).Items.Next);
		J0x222:

		if(NotEqual_ObjectObject(i, none))
		{
			AddEqual_FloatFloat(i.TabWidth, Divide_FloatFloat(Subtract_FloatFloat(WinWidth, RowWidths[i.RowNumber]), float(TabCounts[i.RowNumber])));
			i = UWindowTabControlItem(i.Next);
			// [Loop Continue]
			goto J0x222;
		}
	}
	j = 0;
	J0x293:

	if(Less_IntInt(j, TabRows))
	{
		RowWidths[j] = 0.0000000;
		AddAdd_Int(j);
		// [Loop Continue]
		goto J0x293;
	}
	i = UWindowTabControlItem(UWindowTabControl(ParentWindow).Items.Next);
	J0x2E4:

	if(NotEqual_ObjectObject(i, none))
	{
		i.TabLeft = RowWidths[i.RowNumber];
		if(bArrangeRowsLikeTimHates)
		{
			i.TabTop = Multiply_FloatFloat(Percent_FloatFloat(float(Add_IntInt(i.RowNumber, Subtract_IntInt(Subtract_IntInt(TabRows, 1), Selected.RowNumber))), float(TabRows)), i.TabHeight);
		}
		else
		{
			i.TabTop = Multiply_FloatFloat(float(i.RowNumber), i.TabHeight);
		}
		AddEqual_FloatFloat(RowWidths[i.RowNumber], i.TabWidth);
		i = UWindowTabControlItem(i.Next);
		// [Loop Continue]
		goto J0x2E4;
	}
	return;
}

function LayoutTabs(Canvas C)
{
	if(UWindowTabControl(ParentWindow).bMultiLine)
	{
		SizeTabsMultiLine(C);
	}
	else
	{
		SizeTabsSingleLine(C);
	}
	return;
}

function Paint(Canvas C, float X, float Y)
{
	local UWindowTabControlItem i;
	local int Count, Row;
	local float t;

	t = GetEntryLevel().TimeSeconds;
	if(Less_FloatFloat(UnFlashTime, t))
	{
		bFlashShown = Not_PreBool(bFlashShown);
		if(bFlashShown)
		{
			UnFlashTime = Add_FloatFloat(t, 0.5000000);
		}
		else
		{
			UnFlashTime = Add_FloatFloat(t, 0.3000000);
		}
	}
	Row = 0;
	J0x6A:

	if(Less_IntInt(Row, TabRows))
	{
		Count = 0;
		i = UWindowTabControlItem(UWindowTabControl(ParentWindow).Items.Next);
		J0xA7:

		if(NotEqual_ObjectObject(i, none))
		{
			if(Less_IntInt(Count, TabOffset))
			{
				AddAdd_Int(Count);
			}
			else
			{
				if(EqualEqual_IntInt(i.RowNumber, Row))
				{
					DrawItem(C, i, i.TabLeft, i.TabTop, i.TabWidth, i.TabHeight, OrOr_BoolBool(Not_PreBool(i.bFlash), bFlashShown));
				}
			}
			i = UWindowTabControlItem(i.Next);
			// [Loop Continue]
			goto J0xA7;
		}
		AddAdd_Int(Row);
		// [Loop Continue]
		goto J0x6A;
	}
	return;
}

function LMouseDown(float X, float Y)
{
	local UWindowTabControlItem i;
	local int Count;

	super.LMouseDown(X, Y);
	Count = 0;
	i = UWindowTabControlItem(UWindowTabControl(ParentWindow).Items.Next);
	J0x3E:

	if(NotEqual_ObjectObject(i, none))
	{
		if(Less_IntInt(Count, TabOffset))
		{
			AddAdd_Int(Count);
		}
		else
		{
			if(AndAnd_BoolBool(AndAnd_BoolBool(GreaterEqual_FloatFloat(X, i.TabLeft), LessEqual_FloatFloat(X, Add_FloatFloat(i.TabLeft, i.TabWidth))), OrOr_BoolBool(EqualEqual_IntInt(TabRows, 1), AndAnd_BoolBool(GreaterEqual_FloatFloat(Y, i.TabTop), LessEqual_FloatFloat(Y, Add_FloatFloat(i.TabTop, i.TabHeight))))))
			{
				if(Not_PreBool(UWindowTabControl(ParentWindow).bMultiLine))
				{
					bDragging = true;
					DragTab = i;
					Root.CaptureMouse();
				}
				UWindowTabControl(ParentWindow).GotoTab(i, true);
			}
		}
		i = UWindowTabControlItem(i.Next);
		// [Loop Continue]
		goto J0x3E;
	}
	return;
}

function MouseMove(float X, float Y)
{
	if(AndAnd_BoolBool(bDragging, bMouseDown))
	{
		if(Less_FloatFloat(X, DragTab.TabLeft))
		{
			AddAdd_Int(TabOffset);
		}
		if(AndAnd_BoolBool(Greater_FloatFloat(X, Add_FloatFloat(DragTab.TabLeft, DragTab.TabWidth)), Greater_IntInt(TabOffset, 0)))
		{
			SubtractSubtract_Int(TabOffset);
		}
	}
	else
	{
		bDragging = false;
	}
	return;
}

function RMouseDown(float X, float Y)
{
	local UWindowTabControlItem i;
	local int Count;

	LMouseDown(X, Y);
	Count = 0;
	i = UWindowTabControlItem(UWindowTabControl(ParentWindow).Items.Next);
	J0x3E:

	if(NotEqual_ObjectObject(i, none))
	{
		if(Less_IntInt(Count, TabOffset))
		{
			AddAdd_Int(Count);
		}
		else
		{
			if(AndAnd_BoolBool(GreaterEqual_FloatFloat(X, i.TabLeft), LessEqual_FloatFloat(X, Add_FloatFloat(i.TabLeft, i.TabWidth))))
			{
				i.RightClickTab();
			}
		}
		i = UWindowTabControlItem(i.Next);
		// [Loop Continue]
		goto J0x3E;
	}
	return;
}

function DrawItem(Canvas C, UWindowList Item, float X, float Y, float W, float H, bool bShowText)
{
	if(EqualEqual_ObjectObject(Item, UWindowTabControl(ParentWindow).SelectedTab))
	{
		LookAndFeel.Tab_DrawTab(self, C, true, EqualEqual_ObjectObject(FirstShown, Item), X, Y, W, H, UWindowTabControlItem(Item).Caption, bShowText);
	}
	else
	{
		LookAndFeel.Tab_DrawTab(self, C, false, EqualEqual_ObjectObject(FirstShown, Item), X, Y, W, H, UWindowTabControlItem(Item).Caption, bShowText);
	}
	return;
}

function bool CheckMousePassThrough(float X, float Y)
{
	return GreaterEqual_FloatFloat(Y, Multiply_FloatFloat(LookAndFeel.Size_TabAreaHeight, float(TabRows)));
	return;
}
