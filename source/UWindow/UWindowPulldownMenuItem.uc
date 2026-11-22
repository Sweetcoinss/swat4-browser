class UWindowPulldownMenuItem extends UWindowList;

var string Caption;
var Texture Graphic;
var byte HotKey;
var UWindowPulldownMenu SubMenu;
var bool bChecked;
var bool bDisabled;
var UWindowPulldownMenu Owner;
var float ItemTop;

function UWindowPulldownMenu CreateSubMenu(Class<UWindowPulldownMenu> MenuClass, optional UWindowWindow InOwnerWindow)
{
	SubMenu = UWindowPulldownMenu(Owner.ParentWindow.CreateWindow(MenuClass, 0.0000000, 0.0000000, 100.0000000, 100.0000000, InOwnerWindow));
	SubMenu.HideWindow();
	SubMenu.Owner = self;
	return SubMenu;
	return;
}

function Select()
{
	if(NotEqual_ObjectObject(SubMenu, none))
	{
		SubMenu.WinLeft = Subtract_FloatFloat(Add_FloatFloat(Owner.WinLeft, Owner.WinWidth), float(Owner.HBorder));
		SubMenu.WinTop = Subtract_FloatFloat(ItemTop, float(Owner.VBorder));
		SubMenu.ShowWindow();
	}
	return;
}

function SetCaption(string C)
{
	local string Junk, Junk2;

	Caption = C;
	HotKey = Owner.ParseAmpersand(C, Junk, Junk2, false);
	return;
}

function DeSelect()
{
	if(NotEqual_ObjectObject(SubMenu, none))
	{
		SubMenu.DeSelect();
		SubMenu.HideWindow();
	}
	return;
}

function CloseUp()
{
	Owner.CloseUp();
	return;
}

function UWindowMenuBar GetMenuBar()
{
	return Owner.GetMenuBar();
	return;
}
