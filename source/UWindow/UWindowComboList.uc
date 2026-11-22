class UWindowComboList extends UWindowListControl;

var UWindowComboControl Owner;
var UWindowVScrollbar VertSB;
var UWindowComboListItem Selected;
var int ItemHeight;
var int VBorder;
var int HBorder;
var int TextBorder;
var int MaxVisible;

function Sort()
{
	Items.Sort();
	return;
}

function WindowShown()
{
	super(UWindowWindow).WindowShown();
	FocusWindow();
	return;
}

function Clear()
{
	Items.Clear();
	return;
}

function Texture GetLookAndFeelTexture()
{
	return LookAndFeel.Active;
	return;
}

function Setup()
{
	VertSB = UWindowVScrollbar(CreateWindow(Class'UWindow.UWindowVScrollbar', 0.0000000, Subtract_FloatFloat(WinWidth, float(16)), 16.0000000, WinHeight));
	return;
}

function Created()
{
	ListClass = Class'UWindow.UWindowComboListItem';
	bAlwaysOnTop = true;
	bTransient = true;
	super.Created();
	ItemHeight = 15;
	VBorder = 3;
	HBorder = 3;
	TextBorder = 9;
	super.Created();
	return;
}

function int FindItemIndex(string Value, optional bool bIgnoreCase)
{
	local UWindowComboListItem i;
	local int Count;

	i = UWindowComboListItem(Items.Next);
	Count = 0;
	J0x20:

	if(NotEqual_ObjectObject(i, none))
	{
		if(AndAnd_BoolBool(bIgnoreCase, ComplementEqual_StrStr(i.Value, Value)))
		{
			return Count;
		}
		if(EqualEqual_StrStr(i.Value, Value))
		{
			return Count;
		}
		AddAdd_Int(Count);
		i = UWindowComboListItem(i.Next);
		// [Loop Continue]
		goto J0x20;
	}
	return -1;
	return;
}

function int FindItemIndex2(string Value2, optional bool bIgnoreCase)
{
	local UWindowComboListItem i;
	local int Count;

	i = UWindowComboListItem(Items.Next);
	Count = 0;
	J0x20:

	if(NotEqual_ObjectObject(i, none))
	{
		if(AndAnd_BoolBool(bIgnoreCase, ComplementEqual_StrStr(i.Value2, Value2)))
		{
			return Count;
		}
		if(EqualEqual_StrStr(i.Value2, Value2))
		{
			return Count;
		}
		AddAdd_Int(Count);
		i = UWindowComboListItem(i.Next);
		// [Loop Continue]
		goto J0x20;
	}
	return -1;
	return;
}

function string GetItemValue(int Index)
{
	local UWindowComboListItem i;
	local int Count;

	i = UWindowComboListItem(Items.Next);
	Count = 0;
	J0x20:

	if(NotEqual_ObjectObject(i, none))
	{
		if(EqualEqual_IntInt(Count, Index))
		{
			return i.Value;
		}
		AddAdd_Int(Count);
		i = UWindowComboListItem(i.Next);
		// [Loop Continue]
		goto J0x20;
	}
	return "";
	return;
}

function RemoveItem(int Index)
{
	local UWindowComboListItem i;
	local int Count;

	if(EqualEqual_IntInt(Index, -1))
	{
		return;
	}
	i = UWindowComboListItem(Items.Next);
	Count = 0;
	J0x31:

	if(NotEqual_ObjectObject(i, none))
	{
		if(EqualEqual_IntInt(Count, Index))
		{
			i.Remove();
			return;
		}
		AddAdd_Int(Count);
		i = UWindowComboListItem(i.Next);
		// [Loop Continue]
		goto J0x31;
	}
	return;
}

function string GetItemValue2(int Index)
{
	local UWindowComboListItem i;
	local int Count;

	i = UWindowComboListItem(Items.Next);
	Count = 0;
	J0x20:

	if(NotEqual_ObjectObject(i, none))
	{
		if(EqualEqual_IntInt(Count, Index))
		{
			return i.Value2;
		}
		AddAdd_Int(Count);
		i = UWindowComboListItem(i.Next);
		// [Loop Continue]
		goto J0x20;
	}
	return "";
	return;
}

function AddItem(string Value, optional string Value2, optional int SortWeight)
{
	local UWindowComboListItem i;

	i = UWindowComboListItem(Items.Append(Class'UWindow.UWindowComboListItem'));
	i.Value = Value;
	i.Value2 = Value2;
	i.SortWeight = SortWeight;
	return;
}

function InsertItem(string Value, optional string Value2, optional int SortWeight)
{
	local UWindowComboListItem i;

	i = UWindowComboListItem(Items.Insert(Class'UWindow.UWindowComboListItem'));
	i.Value = Value;
	i.Value2 = Value2;
	i.SortWeight = SortWeight;
	return;
}

function SetSelected(float X, float Y)
{
	local UWindowComboListItem NewSelected, Item;
	local int i, Count;

	Count = 0;
	Item = UWindowComboListItem(Items.Next);
	J0x20:

	if(NotEqual_ObjectObject(Item, none))
	{
		AddAdd_Int(Count);
		Item = UWindowComboListItem(Item.Next);
		// [Loop Continue]
		goto J0x20;
	}
	i = int(Add_FloatFloat(float(Divide_IntInt(int(Subtract_FloatFloat(Y, float(VBorder))), ItemHeight)), VertSB.pos));
	if(Less_IntInt(i, 0))
	{
		i = 0;
	}
	if(GreaterEqual_FloatFloat(float(i), Add_FloatFloat(VertSB.pos, float(Min(Count, MaxVisible)))))
	{
		i = int(Subtract_FloatFloat(Add_FloatFloat(VertSB.pos, float(Min(Count, MaxVisible))), float(1)));
	}
	NewSelected = UWindowComboListItem(Items.FindEntry(i));
	if(NotEqual_ObjectObject(NewSelected, Selected))
	{
		if(EqualEqual_ObjectObject(NewSelected, none))
		{
			Selected = none;
		}
		else
		{
			Selected = NewSelected;
		}
	}
	return;
}

function MouseMove(float X, float Y)
{
	super(UWindowDialogControl).MouseMove(X, Y);
	if(Greater_FloatFloat(Y, WinHeight))
	{
		VertSB.Scroll(1.0000000);
	}
	if(Less_FloatFloat(Y, float(0)))
	{
		VertSB.Scroll(-1.0000000);
	}
	SetSelected(X, Y);
	FocusWindow();
	return;
}

function LMouseUp(float X, float Y)
{
	if(AndAnd_BoolBool(AndAnd_BoolBool(GreaterEqual_FloatFloat(Y, float(0)), LessEqual_FloatFloat(Y, WinHeight)), NotEqual_ObjectObject(Selected, none)))
	{
		ExecuteItem(Selected);
	}
	super(UWindowWindow).LMouseUp(X, Y);
	return;
}

function LMouseDown(float X, float Y)
{
	Root.CaptureMouse();
	return;
}

function BeforePaint(Canvas C, float X, float Y)
{
	local float W, H, MaxWidth;
	local int Count;
	local UWindowComboListItem i;
	local float ListX, ListY, ExtraWidth;

	C.Font = Root.Fonts[0];
	C.SetPos(0.0000000, 0.0000000);
	MaxWidth = Owner.EditBoxWidth;
	ExtraWidth = Multiply_FloatFloat(float(Add_IntInt(HBorder, TextBorder)), float(2));
	Count = Items.Count();
	if(Greater_IntInt(Count, MaxVisible))
	{
		AddEqual_FloatFloat(ExtraWidth, LookAndFeel.Size_ScrollbarWidth);
		WinHeight = Add_FloatFloat(float(Multiply_IntInt(ItemHeight, MaxVisible)), float(Multiply_IntInt(VBorder, 2)));
	}
	else
	{
		VertSB.pos = 0.0000000;
		WinHeight = Add_FloatFloat(float(Multiply_IntInt(ItemHeight, Count)), float(Multiply_IntInt(VBorder, 2)));
	}
	i = UWindowComboListItem(Items.Next);
	J0x111:

	if(NotEqual_ObjectObject(i, none))
	{
		TextSize(C, RemoveAmpersand(i.Value), W, H);
		if(Greater_FloatFloat(Add_FloatFloat(W, ExtraWidth), MaxWidth))
		{
			MaxWidth = Add_FloatFloat(W, ExtraWidth);
		}
		i = UWindowComboListItem(i.Next);
		// [Loop Continue]
		goto J0x111;
	}
	WinWidth = MaxWidth;
	ListX = Subtract_FloatFloat(Add_FloatFloat(Owner.EditAreaDrawX, Owner.EditBoxWidth), WinWidth);
	ListY = Add_FloatFloat(Owner.Button.WinTop, Owner.Button.WinHeight);
	if(Greater_IntInt(Count, MaxVisible))
	{
		VertSB.ShowWindow();
		VertSB.SetRange(0.0000000, float(Count), float(MaxVisible));
		VertSB.WinLeft = Subtract_FloatFloat(Subtract_FloatFloat(WinWidth, LookAndFeel.Size_ScrollbarWidth), float(HBorder));
		VertSB.WinTop = float(HBorder);
		VertSB.WinWidth = LookAndFeel.Size_ScrollbarWidth;
		VertSB.WinHeight = Subtract_FloatFloat(WinHeight, float(Multiply_IntInt(2, VBorder)));
	}
	else
	{
		VertSB.HideWindow();
	}
	Owner.WindowToGlobal(ListX, ListY, WinLeft, WinTop);
	return;
}

function Paint(Canvas C, float X, float Y)
{
	local int Count;
	local UWindowComboListItem i;

	DrawMenuBackground(C);
	Count = 0;
	i = UWindowComboListItem(Items.Next);
	J0x2B:

	if(NotEqual_ObjectObject(i, none))
	{
		if(VertSB.bWindowVisible)
		{
			if(GreaterEqual_FloatFloat(float(Count), VertSB.pos))
			{
				DrawItem(C, i, float(HBorder), Add_FloatFloat(float(VBorder), Multiply_FloatFloat(float(ItemHeight), Subtract_FloatFloat(float(Count), VertSB.pos))), Subtract_FloatFloat(Subtract_FloatFloat(WinWidth, float(Multiply_IntInt(2, HBorder))), VertSB.WinWidth), float(ItemHeight));
			}
		}
		else
		{
			DrawItem(C, i, float(HBorder), float(Add_IntInt(VBorder, Multiply_IntInt(ItemHeight, Count))), Subtract_FloatFloat(WinWidth, float(Multiply_IntInt(2, HBorder))), float(ItemHeight));
		}
		AddAdd_Int(Count);
		i = UWindowComboListItem(i.Next);
		// [Loop Continue]
		goto J0x2B;
	}
	return;
}

function DrawMenuBackground(Canvas C)
{
	LookAndFeel.ComboList_DrawBackground(self, C);
	return;
}

function DrawItem(Canvas C, UWindowList Item, float X, float Y, float W, float H)
{
	LookAndFeel.ComboList_DrawItem(self, C, X, Y, W, H, UWindowComboListItem(Item).Value, EqualEqual_ObjectObject(Selected, Item));
	return;
}

function ExecuteItem(UWindowComboListItem i)
{
	Owner.SetValue(i.Value, i.Value2);
	CloseUp();
	return;
}

function CloseUp()
{
	Owner.CloseUp();
	return;
}

function FocusOtherWindow(UWindowWindow W)
{
	super(UWindowWindow).FocusOtherWindow(W);
	if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(bWindowVisible, NotEqual_ObjectObject(W.ParentWindow.ParentWindow, self)), NotEqual_ObjectObject(W.ParentWindow, self)), NotEqual_ObjectObject(W.ParentWindow, Owner)))
	{
		CloseUp();
	}
	return;
}

defaultproperties
{
	MaxVisible=10
}