class UWindowMenuBar extends UWindowListControl;

var UWindowMenuBarItem Selected;
var UWindowMenuBarItem Over;
var bool bAltDown;
var int Spacing;

function Created()
{
	ListClass = Class'UWindow.UWindowMenuBarItem';
	SetAcceptsHotKeys(true);
	super.Created();
	Spacing = 10;
	return;
}

function UWindowMenuBarItem AddHelpItem(string Caption)
{
	local UWindowMenuBarItem i;

	i = AddItem(Caption);
	i.SetHelp(true);
	return i;
	return;
}

function UWindowMenuBarItem AddItem(string Caption)
{
	local UWindowMenuBarItem i;

	i = UWindowMenuBarItem(Items.Append(Class'UWindow.UWindowMenuBarItem'));
	i.Owner = self;
	i.SetCaption(Caption);
	return i;
	return;
}

function ResolutionChanged(float W, float H)
{
	local UWindowMenuBarItem i;

	if(NotEqual_ObjectObject(Items, none))
	{
		i = UWindowMenuBarItem(Items.Next);
		J0x24:

		if(NotEqual_ObjectObject(i, none))
		{
			if(NotEqual_ObjectObject(i.Menu, none))
			{
				i.Menu.ResolutionChanged(W, H);
			}
			i = UWindowMenuBarItem(i.Next);
			// [Loop Continue]
			goto J0x24;
		}
	}
	super(UWindowWindow).ResolutionChanged(W, H);
	return;
}

function Paint(Canvas C, float MouseX, float MouseY)
{
	local float X, W, H;
	local UWindowMenuBarItem i;

	DrawMenuBar(C);
	i = UWindowMenuBarItem(Items.Next);
	J0x24:

	if(NotEqual_ObjectObject(i, none))
	{
		C.Font = Root.Fonts[0];
		TextSize(C, RemoveAmpersand(i.Caption), W, H);
		if(i.bHelp)
		{
			DrawItem(C, i, Subtract_FloatFloat(WinWidth, Add_FloatFloat(W, float(Spacing))), 1.0000000, Add_FloatFloat(W, float(Spacing)), 14.0000000);
		}
		else
		{
			DrawItem(C, i, X, 1.0000000, Add_FloatFloat(W, float(Spacing)), 14.0000000);
			X = Add_FloatFloat(Add_FloatFloat(X, W), float(Spacing));
		}
		i = UWindowMenuBarItem(i.Next);
		// [Loop Continue]
		goto J0x24;
	}
	return;
}

function MouseMove(float X, float Y)
{
	local UWindowMenuBarItem i;

	super(UWindowDialogControl).MouseMove(X, Y);
	Over = none;
	i = UWindowMenuBarItem(Items.Next);
	J0x30:

	if(NotEqual_ObjectObject(i, none))
	{
		if(AndAnd_BoolBool(GreaterEqual_FloatFloat(X, i.ItemLeft), LessEqual_FloatFloat(X, Add_FloatFloat(i.ItemLeft, i.ItemWidth))))
		{
			if(NotEqual_ObjectObject(Selected, none))
			{
				if(NotEqual_ObjectObject(Selected, i))
				{
					Selected.DeSelect();
					Selected = i;
					Selected.Select();
					Select(Selected);
				}
			}
			else
			{
				Over = i;
			}
		}
		i = UWindowMenuBarItem(i.Next);
		// [Loop Continue]
		goto J0x30;
	}
	return;
}

function MouseLeave()
{
	super(UWindowDialogControl).MouseLeave();
	Over = none;
	return;
}

function Select(UWindowMenuBarItem i)
{
	return;
}

function LMouseDown(float X, float Y)
{
	local UWindowMenuBarItem i;

	i = UWindowMenuBarItem(Items.Next);
	J0x19:

	if(NotEqual_ObjectObject(i, none))
	{
		if(AndAnd_BoolBool(GreaterEqual_FloatFloat(X, i.ItemLeft), LessEqual_FloatFloat(X, Add_FloatFloat(i.ItemLeft, i.ItemWidth))))
		{
			if(NotEqual_ObjectObject(Selected, none))
			{
				Selected.DeSelect();
			}
			if(EqualEqual_ObjectObject(Selected, i))
			{
				Selected = none;
				Over = i;
			}
			else
			{
				Selected = i;
				Selected.Select();
			}
			Select(Selected);
			return;
		}
		i = UWindowMenuBarItem(i.Next);
		// [Loop Continue]
		goto J0x19;
	}
	if(NotEqual_ObjectObject(Selected, none))
	{
		Selected.DeSelect();
	}
	Selected = none;
	Select(Selected);
	return;
}

function DrawItem(Canvas C, UWindowList Item, float X, float Y, float W, float H)
{
	C.SetDrawColor(byte(255), byte(255), byte(255));
	UWindowMenuBarItem(Item).ItemLeft = X;
	UWindowMenuBarItem(Item).ItemWidth = W;
	LookAndFeel.Menu_DrawMenuBarItem(self, UWindowMenuBarItem(Item), X, Y, W, H, C);
	return;
}

function DrawMenuBar(Canvas C)
{
	DrawStretchedTexture(C, 0.0000000, 0.0000000, WinWidth, 16.0000000, Texture'UWindow_res.Icons.MenuBar');
	return;
}

function CloseUp()
{
	if(NotEqual_ObjectObject(Selected, none))
	{
		Selected.DeSelect();
		Selected = none;
	}
	return;
}

function Close(optional bool bByParent)
{
	return;
}

function UWindowMenuBar GetMenuBar()
{
	return self;
	return;
}

function bool HotKeyDown(int Key, float X, float Y)
{
	local UWindowMenuBarItem i;

	if(EqualEqual_IntInt(Key, 18))
	{
		bAltDown = true;
	}
	if(bAltDown)
	{
		i = UWindowMenuBarItem(Items.Next);
		J0x36:

		if(NotEqual_ObjectObject(i, none))
		{
			if(EqualEqual_IntInt(Key, int(i.HotKey)))
			{
				if(NotEqual_ObjectObject(Selected, none))
				{
					Selected.DeSelect();
				}
				Selected = i;
				Selected.Select();
				Select(Selected);
				bAltDown = false;
				return true;
			}
			i = UWindowMenuBarItem(i.Next);
			// [Loop Continue]
			goto J0x36;
		}
	}
	return false;
	return;
}

function bool HotKeyUp(int Key, float X, float Y)
{
	if(EqualEqual_IntInt(Key, 18))
	{
		bAltDown = false;
	}
	return false;
	return;
}

function KeyDown(int Key, float X, float Y)
{
	local UWindowMenuBarItem i;

	switch(Key)
	{
		case 37:
			i = UWindowMenuBarItem(Selected.Prev);
			if(OrOr_BoolBool(EqualEqual_ObjectObject(i, none), EqualEqual_ObjectObject(i, Items)))
			{
				i = UWindowMenuBarItem(Items.Last);
			}
			if(NotEqual_ObjectObject(Selected, none))
			{
				Selected.DeSelect();
			}
			Selected = i;
			Selected.Select();
			Select(Selected);
			break;
		case 39:
			i = UWindowMenuBarItem(Selected.Next);
			if(EqualEqual_ObjectObject(i, none))
			{
				i = UWindowMenuBarItem(Items.Next);
			}
			if(NotEqual_ObjectObject(Selected, none))
			{
				Selected.DeSelect();
			}
			Selected = i;
			Selected.Select();
			Select(Selected);
			break;
		default:
			break;
	}
	return;
}

function MenuCmd(int Menu, int Item)
{
	local UWindowMenuBarItem i;
	local int j;

	j = 0;
	i = UWindowMenuBarItem(Items.Next);
	J0x20:

	if(NotEqual_ObjectObject(i, none))
	{
		if(AndAnd_BoolBool(EqualEqual_IntInt(j, Menu), NotEqual_ObjectObject(i.Menu, none)))
		{
			if(NotEqual_ObjectObject(Selected, none))
			{
				Selected.DeSelect();
			}
			Selected = i;
			Selected.Select();
			Select(Selected);
			i.Menu.MenuCmd(Item);
			return;
		}
		AddAdd_Int(j);
		i = UWindowMenuBarItem(i.Next);
		// [Loop Continue]
		goto J0x20;
	}
	return;
}

function MenuItemSelected(UWindowBase Sender, UWindowBase Item)
{
	return;
}
