class UWindowListBox extends UWindowListControl;

var float ItemHeight;
var UWindowVScrollbar VertSB;
var UWindowListBoxItem SelectedItem;
var bool bCanDrag;
var bool bCanDragExternal;
var string DefaultHelpText;
var bool bDragging;
var float DragY;
var UWindowListBox DoubleClickList;
var bool bHotTrack;

function Created()
{
	super.Created();
	VertSB = UWindowVScrollbar(CreateWindow(Class'UWindow.UWindowVScrollbar', Subtract_FloatFloat(WinWidth, float(12)), 0.0000000, 12.0000000, WinHeight));
	return;
}

function UWindowListBoxItem AddItem(string C)
{
	local UWindowListBoxItem i;

	i = UWindowListBoxItem(Items.Append(ListClass));
	i.Caption = C;
	return i;
	return;
}

function BeforePaint(Canvas C, float MouseX, float MouseY)
{
	local UWindowListBoxItem OverItem;
	local string NewHelpText;

	VertSB.SetRange(0.0000000, float(Items.CountShown()), float(int(Divide_FloatFloat(WinHeight, ItemHeight))));
	NewHelpText = DefaultHelpText;
	if(NotEqual_ObjectObject(SelectedItem, none))
	{
		OverItem = GetItemAt(MouseX, MouseY);
		if(AndAnd_BoolBool(EqualEqual_ObjectObject(OverItem, SelectedItem), NotEqual_StrStr(OverItem.HelpText, "")))
		{
			NewHelpText = OverItem.HelpText;
		}
	}
	if(NotEqual_StrStr(NewHelpText, HelpText))
	{
		HelpText = NewHelpText;
		Notify(13);
	}
	return;
}

function SetHelpText(string t)
{
	super(UWindowDialogControl).SetHelpText(t);
	DefaultHelpText = t;
	return;
}

function Sort()
{
	Items.Sort();
	return;
}

function Paint(Canvas C, float MouseX, float MouseY)
{
	local float Y;
	local UWindowList CurItem;
	local int i;
	local Color OldColor;

	CurItem = Items.Next;
	i = 0;
	J0x1B:

	if(AndAnd_BoolBool(NotEqual_ObjectObject(CurItem, none), Less_FloatFloat(float(i), VertSB.pos)))
	{
		if(CurItem.ShowThisItem())
		{
			AddAdd_Int(i);
		}
		CurItem = CurItem.Next;
		// [Loop Continue]
		goto J0x1B;
	}
	Y = 3.0000000;
	J0x7D:

	if(AndAnd_BoolBool(Less_FloatFloat(Y, WinHeight), NotEqual_ObjectObject(CurItem, none)))
	{
		if(CurItem.ShowThisItem())
		{
			OldColor = TextColor;
			if(bHotTrack)
			{
				if(AndAnd_BoolBool(EqualEqual_ObjectObject(GetItemAt(MouseX, MouseY), CurItem), NotEqual_ObjectObject(CurItem, SelectedItem)))
				{
					TextColor = SelectionColor;
					TextColor.R = byte(Max(0, Subtract_IntInt(int(TextColor.R), 96)));
					TextColor.G = byte(Max(0, Subtract_IntInt(int(TextColor.G), 96)));
					TextColor.B = byte(Max(0, Subtract_IntInt(int(TextColor.B), 96)));
				}
			}
			if(VertSB.bWindowVisible)
			{
				DrawItem(C, CurItem, 5.0000000, Y, Subtract_FloatFloat(WinWidth, float(12)), ItemHeight);
			}
			else
			{
				DrawItem(C, CurItem, 5.0000000, Y, WinWidth, ItemHeight);
			}
			Y = Add_FloatFloat(Y, ItemHeight);
			TextColor = OldColor;
		}
		CurItem = CurItem.Next;
		// [Loop Continue]
		goto J0x7D;
	}
	return;
}

function Resized()
{
	super(UWindowWindow).Resized();
	VertSB.WinLeft = Subtract_FloatFloat(WinWidth, float(12));
	VertSB.WinTop = 0.0000000;
	VertSB.SetSize(12.0000000, WinHeight);
	return;
}

function UWindowListBoxItem GetItemAt(float MouseX, float MouseY)
{
	local float Y;
	local UWindowList CurItem;
	local int i;

	if(OrOr_BoolBool(Less_FloatFloat(MouseX, float(0)), Greater_FloatFloat(MouseX, WinWidth)))
	{
		return none;
	}
	CurItem = Items.Next;
	i = 0;
	J0x3B:

	if(AndAnd_BoolBool(NotEqual_ObjectObject(CurItem, none), Less_FloatFloat(float(i), VertSB.pos)))
	{
		if(CurItem.ShowThisItem())
		{
			AddAdd_Int(i);
		}
		CurItem = CurItem.Next;
		// [Loop Continue]
		goto J0x3B;
	}
	Y = 0.0000000;
	J0x9D:

	if(AndAnd_BoolBool(Less_FloatFloat(Y, WinHeight), NotEqual_ObjectObject(CurItem, none)))
	{
		if(CurItem.ShowThisItem())
		{
			if(AndAnd_BoolBool(GreaterEqual_FloatFloat(MouseY, Y), LessEqual_FloatFloat(MouseY, Add_FloatFloat(Y, ItemHeight))))
			{
				return UWindowListBoxItem(CurItem);
			}
			Y = Add_FloatFloat(Y, ItemHeight);
		}
		CurItem = CurItem.Next;
		// [Loop Continue]
		goto J0x9D;
	}
	return none;
	return;
}

function MakeSelectedVisible()
{
	local UWindowList CurItem;
	local int i;

	VertSB.SetRange(0.0000000, float(Items.CountShown()), float(int(Divide_FloatFloat(WinHeight, ItemHeight))));
	if(EqualEqual_ObjectObject(SelectedItem, none))
	{
		return;
	}
	i = 0;
	CurItem = Items.Next;
	J0x5D:

	if(NotEqual_ObjectObject(CurItem, none))
	{
		if(EqualEqual_ObjectObject(CurItem, SelectedItem))
		{
			// [Explicit Break]
			goto J0xAA;
		}
		if(CurItem.ShowThisItem())
		{
			AddAdd_Int(i);
		}
		CurItem = CurItem.Next;
		// [Loop Continue]
		goto J0x5D;
	}
	J0xAA:

	VertSB.Show(float(i));
	return;
}

function SetSelectedItem(UWindowListBoxItem NewSelected)
{
	if(AndAnd_BoolBool(NotEqual_ObjectObject(NewSelected, none), NotEqual_ObjectObject(SelectedItem, NewSelected)))
	{
		if(NotEqual_ObjectObject(SelectedItem, none))
		{
			SelectedItem.bSelected = false;
		}
		SelectedItem = NewSelected;
		if(NotEqual_ObjectObject(SelectedItem, none))
		{
			SelectedItem.bSelected = true;
		}
		Notify(2);
	}
	return;
}

function SetSelected(float X, float Y)
{
	local UWindowListBoxItem NewSelected;

	NewSelected = GetItemAt(X, Y);
	SetSelectedItem(NewSelected);
	return;
}

function LMouseDown(float X, float Y)
{
	super(UWindowWindow).LMouseDown(X, Y);
	SetSelected(X, Y);
	if(OrOr_BoolBool(bCanDrag, bCanDragExternal))
	{
		bDragging = true;
		Root.CaptureMouse();
		DragY = Y;
	}
	return;
}

function DoubleClick(float X, float Y)
{
	super(UWindowWindow).DoubleClick(X, Y);
	if(EqualEqual_ObjectObject(GetItemAt(X, Y), SelectedItem))
	{
		DoubleClickItem(SelectedItem);
	}
	return;
}

function ReceiveDoubleClickItem(UWindowListBox L, UWindowListBoxItem i)
{
	i.Remove();
	Items.AppendItem(i);
	SetSelectedItem(i);
	L.SelectedItem = none;
	L.Notify(1);
	Notify(1);
	return;
}

function DoubleClickItem(UWindowListBoxItem i)
{
	if(AndAnd_BoolBool(NotEqual_ObjectObject(DoubleClickList, none), NotEqual_ObjectObject(i, none)))
	{
		DoubleClickList.ReceiveDoubleClickItem(self, i);
	}
	return;
}

function MouseMove(float X, float Y)
{
	local UWindowListBoxItem OverItem;

	super(UWindowDialogControl).MouseMove(X, Y);
	if(AndAnd_BoolBool(bDragging, bMouseDown))
	{
		OverItem = GetItemAt(X, Y);
		if(AndAnd_BoolBool(AndAnd_BoolBool(AndAnd_BoolBool(bCanDrag, NotEqual_ObjectObject(OverItem, SelectedItem)), NotEqual_ObjectObject(OverItem, none)), NotEqual_ObjectObject(SelectedItem, none)))
		{
			SelectedItem.Remove();
			if(Less_FloatFloat(Y, DragY))
			{
				OverItem.InsertItemBefore(SelectedItem);
			}
			else
			{
				OverItem.InsertItemAfter(SelectedItem, true);
			}
			Notify(1);
			DragY = Y;
		}
		else
		{
			if(AndAnd_BoolBool(bCanDragExternal, NotEqual_ObjectObject(CheckExternalDrag(X, Y), none)))
			{
				bDragging = false;
			}
		}
	}
	else
	{
		bDragging = false;
	}
	return;
}

function bool ExternalDragOver(UWindowDialogControl ExternalControl, float X, float Y)
{
	local UWindowListBox B;
	local UWindowListBoxItem OverItem;

	B = UWindowListBox(ExternalControl);
	if(AndAnd_BoolBool(NotEqual_ObjectObject(B, none), NotEqual_ObjectObject(B.SelectedItem, none)))
	{
		OverItem = GetItemAt(X, Y);
		B.SelectedItem.Remove();
		if(NotEqual_ObjectObject(OverItem, none))
		{
			OverItem.InsertItemBefore(B.SelectedItem);
		}
		else
		{
			Items.AppendItem(B.SelectedItem);
		}
		SetSelectedItem(B.SelectedItem);
		B.SelectedItem = none;
		B.Notify(1);
		Notify(1);
		if(OrOr_BoolBool(bCanDrag, bCanDragExternal))
		{
			Root.CancelCapture();
			bDragging = true;
			bMouseDown = true;
			Root.CaptureMouse(self);
			DragY = Y;
		}
		return true;
	}
	return false;
	return;
}

function DrawItem(Canvas C, UWindowList Item, float X, float Y, float W, float H)
{
	local float tX, XL, YL;

	if(UWindowListBoxItem(Item).bSelected)
	{
		if(Not_PreBool(bNoSelectionBox))
		{
			C.DrawColor = SelectionBkgColor;
			DrawStretchedTexture(C, X, Y, W, Subtract_FloatFloat(H, float(1)), Texture'UWindow_res.WhiteTexture');
		}
		C.DrawColor = SelectionColor;
	}
	else
	{
		C.DrawColor = TextColor;
	}
	C.Font = Root.Fonts[Font];
	C.StrLen(UWindowListBoxItem(Item).Caption, XL, YL);
	switch(Align)
	{
		case 0:
			tX = Add_FloatFloat(X, float(2));
		case 2:
			tX = Divide_FloatFloat(Subtract_FloatFloat(Subtract_FloatFloat(W, float(4)), XL), float(2));
			break;
		case 1:
			tX = Subtract_FloatFloat(Subtract_FloatFloat(Subtract_FloatFloat(W, XL), W), float(2));
			break;
		default:
			break;
	}
	ClipText(C, tX, Y, UWindowListBoxItem(Item).Caption);
	return;
}

function KeyUp(int Key, float X, float Y)
{
	if(OrOr_BoolBool(EqualEqual_IntInt(Key, 200), EqualEqual_IntInt(Key, 78)))
	{
		if(NotEqual_ObjectObject(SelectedItem.Prev.Prev, none))
		{
			SetSelectedItem(UWindowListBoxItem(SelectedItem.Prev));
		}
	}
	else
	{
		if(OrOr_BoolBool(EqualEqual_IntInt(Key, 201), EqualEqual_IntInt(Key, 80)))
		{
			if(NotEqual_ObjectObject(SelectedItem.Next, none))
			{
				SetSelectedItem(UWindowListBoxItem(SelectedItem.Next));
			}
		}
		else
		{
			if(OrOr_BoolBool(EqualEqual_IntInt(Key, 205), EqualEqual_IntInt(Key, 13)))
			{
				if(AndAnd_BoolBool(NotEqual_ObjectObject(OwnerWindow, none), OwnerWindow.IsA('UWindowDialogClientWindow')))
				{
					UWindowDialogClientWindow(OwnerWindow).Notify(self, 1);
				}
			}
		}
	}
	super(UWindowWindow).KeyUp(Key, X, Y);
	return;
}

defaultproperties
{
	ItemHeight=10.0000000
	ListClass=Class'UWindow.UWindowListBoxItem'
	TextColor=(R=255,G=255,B=255,A=255)
}