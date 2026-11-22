class UWindowPulldownMenu extends UWindowListControl;

var UWindowPulldownMenuItem Selected;
var UWindowList Owner;
var int ItemHeight;
var int VBorder;
var int HBorder;
var int TextBorder;
var UWindowMenuBar MyMenuBar;

function UWindowPulldownMenuItem AddMenuItem(string C, Texture G)
{
	local UWindowPulldownMenuItem i;

	i = UWindowPulldownMenuItem(Items.Append(Class'UWindow.UWindowPulldownMenuItem'));
	i.Owner = self;
	i.SetCaption(C);
	i.Graphic = G;
	i.Tag = Items.Count();
	return i;
	return;
}

function Created()
{
	ListClass = Class'UWindow.UWindowPulldownMenuItem';
	SetAcceptsFocus();
	super.Created();
	ItemHeight = int(LookAndFeel.Pulldown_ItemHeight);
	VBorder = int(LookAndFeel.Pulldown_VBorder);
	HBorder = int(LookAndFeel.Pulldown_HBorder);
	TextBorder = int(LookAndFeel.Pulldown_TextBorder);
	return;
}

function Clear()
{
	Items.Clear();
	Selected = none;
	return;
}

function DeSelect()
{
	if(NotEqual_ObjectObject(Selected, none))
	{
		Selected.DeSelect();
		Selected = none;
	}
	return;
}

function Select(UWindowPulldownMenuItem i)
{
	return;
}

function PerformSelect(UWindowPulldownMenuItem NewSelected)
{
	if(AndAnd_BoolBool(NotEqual_ObjectObject(Selected, none), NotEqual_ObjectObject(NewSelected, Selected)))
	{
		Selected.DeSelect();
	}
	if(EqualEqual_ObjectObject(NewSelected, none))
	{
		Selected = none;
	}
	else
	{
		if(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(Selected, NewSelected), NotEqual_StrStr(NewSelected.Caption, "-")), Not_PreBool(NewSelected.bDisabled)))
		{
			LookAndFeel.PlayMenuSound(self, 2);
		}
		Selected = NewSelected;
		if(NotEqual_ObjectObject(Selected, none))
		{
			Selected.Select();
			Select(Selected);
		}
	}
	return;
}

function SetSelected(float X, float Y)
{
	local UWindowPulldownMenuItem NewSelected;

	NewSelected = UWindowPulldownMenuItem(Items.FindEntry(Divide_IntInt(int(Subtract_FloatFloat(Y, float(VBorder))), ItemHeight)));
	PerformSelect(NewSelected);
	return;
}

function ShowWindow()
{
	super(UWindowWindow).ShowWindow();
	PerformSelect(none);
	FocusWindow();
	return;
}

function MouseMove(float X, float Y)
{
	super(UWindowDialogControl).MouseMove(X, Y);
	SetSelected(X, Y);
	FocusWindow();
	return;
}

function LMouseUp(float X, float Y)
{
	if(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(Selected, none), NotEqual_StrStr(Selected.Caption, "-")), Not_PreBool(Selected.bDisabled)))
	{
		BeforeExecuteItem(Selected);
		ExecuteItem(Selected);
	}
	super(UWindowWindow).LMouseUp(X, Y);
	return;
}

function LMouseDown(float X, float Y)
{
	return;
}

function BeforePaint(Canvas C, float X, float Y)
{
	local float W, H, MaxWidth;
	local int Count;
	local UWindowPulldownMenuItem i;

	MaxWidth = 100.0000000;
	Count = 0;
	C.Font = Root.Fonts[0];
	C.SetPos(0.0000000, 0.0000000);
	i = UWindowPulldownMenuItem(Items.Next);
	J0x63:

	if(NotEqual_ObjectObject(i, none))
	{
		AddAdd_Int(Count);
		TextSize(C, RemoveAmpersand(i.Caption), W, H);
		if(Greater_FloatFloat(W, MaxWidth))
		{
			MaxWidth = W;
		}
		i = UWindowPulldownMenuItem(i.Next);
		// [Loop Continue]
		goto J0x63;
	}
	WinWidth = Add_FloatFloat(MaxWidth, float(Multiply_IntInt(Add_IntInt(HBorder, TextBorder), 2)));
	WinHeight = Add_FloatFloat(float(Multiply_IntInt(ItemHeight, Count)), float(Multiply_IntInt(VBorder, 2)));
	if(OrOr_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(UWindowMenuBarItem(Owner), none), UWindowMenuBarItem(Owner).bHelp), Greater_FloatFloat(Add_FloatFloat(WinLeft, WinWidth), ParentWindow.WinWidth)))
	{
		WinLeft = Subtract_FloatFloat(ParentWindow.WinWidth, WinWidth);
	}
	if(NotEqual_ObjectObject(UWindowPulldownMenuItem(Owner), none))
	{
		i = UWindowPulldownMenuItem(Owner);
		if(Greater_FloatFloat(Add_FloatFloat(WinWidth, WinLeft), ParentWindow.WinWidth))
		{
			WinLeft = Subtract_FloatFloat(Add_FloatFloat(i.Owner.WinLeft, float(i.Owner.HBorder)), WinWidth);
		}
	}
	return;
}

function Paint(Canvas C, float X, float Y)
{
	local int Count;
	local UWindowPulldownMenuItem i;

	DrawMenuBackground(C);
	Count = 0;
	i = UWindowPulldownMenuItem(Items.Next);
	J0x2B:

	if(NotEqual_ObjectObject(i, none))
	{
		DrawItem(C, i, float(HBorder), float(Add_IntInt(VBorder, Multiply_IntInt(ItemHeight, Count))), Subtract_FloatFloat(WinWidth, float(Multiply_IntInt(2, HBorder))), float(ItemHeight));
		AddAdd_Int(Count);
		i = UWindowPulldownMenuItem(i.Next);
		// [Loop Continue]
		goto J0x2B;
	}
	return;
}

function DrawMenuBackground(Canvas C)
{
	LookAndFeel.Menu_DrawPulldownMenuBackground(self, C);
	return;
}

function DrawItem(Canvas C, UWindowList Item, float X, float Y, float W, float H)
{
	LookAndFeel.Menu_DrawPulldownMenuItem(self, UWindowPulldownMenuItem(Item), C, X, Y, W, H, EqualEqual_ObjectObject(Selected, Item));
	return;
}

function BeforeExecuteItem(UWindowPulldownMenuItem i)
{
	LookAndFeel.PlayMenuSound(self, 3);
	return;
}

function ExecuteItem(UWindowPulldownMenuItem i)
{
	MyMenuBar.MenuItemSelected(self, i);
	CloseUp();
	return;
}

function CloseUp(optional bool bByOwner)
{
	local UWindowPulldownMenuItem i;

	if(Not_PreBool(bByOwner))
	{
		if(NotEqual_ObjectObject(UWindowPulldownMenuItem(Owner), none))
		{
			UWindowPulldownMenuItem(Owner).CloseUp();
		}
		if(NotEqual_ObjectObject(UWindowMenuBarItem(Owner), none))
		{
			UWindowMenuBarItem(Owner).CloseUp();
		}
	}
	i = UWindowPulldownMenuItem(Items.Next);
	J0x6C:

	if(NotEqual_ObjectObject(i, none))
	{
		if(NotEqual_ObjectObject(i.SubMenu, none))
		{
			i.SubMenu.CloseUp(true);
		}
		i = UWindowPulldownMenuItem(i.Next);
		// [Loop Continue]
		goto J0x6C;
	}
	return;
}

function UWindowMenuBar GetMenuBar()
{
	if(NotEqual_ObjectObject(UWindowPulldownMenuItem(Owner), none))
	{
		return UWindowPulldownMenuItem(Owner).GetMenuBar();
	}
	if(NotEqual_ObjectObject(UWindowMenuBarItem(Owner), none))
	{
		return UWindowMenuBarItem(Owner).GetMenuBar();
	}
	return;
}

function FocusOtherWindow(UWindowWindow W)
{
	super(UWindowWindow).FocusOtherWindow(W);
	if(NotEqual_ObjectObject(Selected, none))
	{
		if(EqualEqual_ObjectObject(W, Selected.SubMenu))
		{
			return;
		}
	}
	if(NotEqual_ObjectObject(UWindowPulldownMenuItem(Owner), none))
	{
		if(EqualEqual_ObjectObject(UWindowPulldownMenuItem(Owner).Owner, W))
		{
			return;
		}
	}
	if(bWindowVisible)
	{
		CloseUp();
	}
	return;
}

function KeyDown(int Key, float X, float Y)
{
	local UWindowPulldownMenuItem i;

	i = Selected;
	switch(Key)
	{
		case 27:
			CloseUp();
			break;
		case 38:
			if(OrOr_BoolBool(EqualEqual_ObjectObject(i, none), EqualEqual_ObjectObject(i, Items.Next)))
			{
				i = UWindowPulldownMenuItem(Items.Last);
			}
			else
			{
				i = UWindowPulldownMenuItem(i.Prev);
			}
			if(EqualEqual_ObjectObject(i, none))
			{
				i = UWindowPulldownMenuItem(Items.Last);
			}
			else
			{
				if(EqualEqual_StrStr(i.Caption, "-"))
				{
					i = UWindowPulldownMenuItem(i.Prev);
				}
			}
			if(EqualEqual_ObjectObject(i, none))
			{
				i = UWindowPulldownMenuItem(Items.Last);
			}
			if(EqualEqual_ObjectObject(i.SubMenu, none))
			{
				PerformSelect(i);
			}
			else
			{
				Selected = i;
			}
			break;
		case 40:
			if(EqualEqual_ObjectObject(i, none))
			{
				i = UWindowPulldownMenuItem(Items.Next);
			}
			else
			{
				i = UWindowPulldownMenuItem(i.Next);
			}
			if(EqualEqual_ObjectObject(i, none))
			{
				i = UWindowPulldownMenuItem(Items.Next);
			}
			else
			{
				if(EqualEqual_StrStr(i.Caption, "-"))
				{
					i = UWindowPulldownMenuItem(i.Next);
				}
			}
			if(EqualEqual_ObjectObject(i, none))
			{
				i = UWindowPulldownMenuItem(Items.Next);
			}
			if(EqualEqual_ObjectObject(i.SubMenu, none))
			{
				PerformSelect(i);
			}
			else
			{
				Selected = i;
			}
			break;
		case 37:
			if(NotEqual_ObjectObject(UWindowPulldownMenuItem(Owner), none))
			{
				UWindowPulldownMenuItem(Owner).Owner.PerformSelect(none);
				UWindowPulldownMenuItem(Owner).Owner.Selected = UWindowPulldownMenuItem(Owner);
			}
			if(NotEqual_ObjectObject(UWindowMenuBarItem(Owner), none))
			{
				UWindowMenuBarItem(Owner).Owner.KeyDown(Key, X, Y);
			}
			break;
		case 39:
			if(AndAnd_BoolBool(NotEqual_ObjectObject(i, none), NotEqual_ObjectObject(i.SubMenu, none)))
			{
				Selected = none;
				PerformSelect(i);
				i.SubMenu.Selected = UWindowPulldownMenuItem(i.SubMenu.Items.Next);
			}
			else
			{
				if(NotEqual_ObjectObject(UWindowPulldownMenuItem(Owner), none))
				{
					UWindowPulldownMenuItem(Owner).Owner.PerformSelect(none);
					UWindowPulldownMenuItem(Owner).Owner.KeyDown(Key, X, Y);
				}
				if(NotEqual_ObjectObject(UWindowMenuBarItem(Owner), none))
				{
					UWindowMenuBarItem(Owner).Owner.KeyDown(Key, X, Y);
				}
			}
			break;
		case 13:
			if(NotEqual_ObjectObject(i.SubMenu, none))
			{
				Selected = none;
				PerformSelect(i);
			}
			else
			{
				if(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(Selected, none), NotEqual_StrStr(Selected.Caption, "-")), Not_PreBool(Selected.bDisabled)))
				{
					BeforeExecuteItem(Selected);
					ExecuteItem(Selected);
				}
			}
			break;
		default:
			break;
	}
	return;
}

function KeyUp(int Key, float X, float Y)
{
	local UWindowPulldownMenuItem i;

	if(AndAnd_BoolBool(GreaterEqual_IntInt(Key, 65), LessEqual_IntInt(Key, 96)))
	{
		i = UWindowPulldownMenuItem(Items.Next);
		J0x33:

		if(NotEqual_ObjectObject(i, none))
		{
			if(EqualEqual_IntInt(Key, int(i.HotKey)))
			{
				PerformSelect(i);
				if(AndAnd_BoolBool(AndAnd_BoolBool(NotEqual_ObjectObject(i, none), NotEqual_StrStr(i.Caption, "-")), Not_PreBool(i.bDisabled)))
				{
					BeforeExecuteItem(i);
					ExecuteItem(i);
				}
			}
			i = UWindowPulldownMenuItem(i.Next);
			// [Loop Continue]
			goto J0x33;
		}
	}
	return;
}

function MenuCmd(int Item)
{
	local int j;
	local UWindowPulldownMenuItem i;

	i = UWindowPulldownMenuItem(Items.Next);
	J0x19:

	if(NotEqual_ObjectObject(i, none))
	{
		if(EqualEqual_IntInt(j, Item))
		{
			PerformSelect(i);
			if(AndAnd_BoolBool(NotEqual_StrStr(i.Caption, "-"), Not_PreBool(i.bDisabled)))
			{
				BeforeExecuteItem(i);
				ExecuteItem(i);
			}
			return;
		}
		AddAdd_Int(j);
		i = UWindowPulldownMenuItem(i.Next);
		// [Loop Continue]
		goto J0x19;
	}
	return;
}

defaultproperties
{
	bAlwaysOnTop=true
}