class GUIListBase extends GUIComponent
	abstract
	native
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object);

cpptext
{
	virtual void DrawItem(UCanvas* Canvas, INT Item, FLOAT X, FLOAT Y, FLOAT W, FLOAT H) {}

}

var() config Color SelectedBKColor "Color for a selection background";
var() config Material SelectedImage "Image to use when displaying";
var() editconst int Top;
var() editconst int Index "Pointers in to the list";
var() editconst int ItemsPerPage "# of items per Page.  Is set natively";
var() editconst int ItemHeight "Size of each row.  Subclass should set in PreDraw.";
var() editconst int ItemWidth "Width of each row.. Subclass should set in PreDraw.";
var() editconst int ItemCount "# of items in this list";
var() config bool bHotTrack "Use the Mouse X/Y to always hightlight something";
var() config bool bVisibleWhenEmpty "List is still drawn when there are no items in it.";
var() config bool bReadOnly "If true, list is unselectable";
var() config bool bDeselectable "If true, list is not deselectable";
var export editinline GUIScrollBarBase MyScrollBar;
//var delegate<OnDrawItem> __OnDrawItem__Delegate;
//var delegate<OnAdjustTop> __OnAdjustTop__Delegate;

delegate OnDrawItem(Canvas Canvas, int Item, float X, float Y, float W, float H, bool bSelected)
{
	return;
}

delegate OnAdjustTop(GUIComponent Sender)
{
	return;
}

function InitComponent(GUIComponent Owner)
{
	super.InitComponent(Owner);
	return;
}

function Sort()
{
	return;
}

function int setIndex(int NewIndex, optional bool bDontPropChange, optional bool bDontReAlign)
{
	if(OrOr_BoolBool(Less_IntInt(NewIndex, 0), GreaterEqual_IntInt(NewIndex, ItemCount)))
	{
		Index = -1;
	}
	else
	{
		Index = NewIndex;
	}
	if(AndAnd_BoolBool(AndAnd_BoolBool(Not_PreBool(bDontReAlign), GreaterEqual_IntInt(Index, 0)), Greater_IntInt(ItemsPerPage, 0)))
	{
		if(Less_IntInt(Index, Top))
		{
			Top = Index;
		}
		if(AndAnd_BoolBool(NotEqual_IntInt(ItemsPerPage, 0), GreaterEqual_IntInt(Index, Add_IntInt(Top, ItemsPerPage))))
		{
			Top = Add_IntInt(Subtract_IntInt(Index, ItemsPerPage), 1);
		}
		if(GreaterEqual_IntInt(ItemsPerPage, ItemCount))
		{
			Top = 0;
		}
	}
	if(NotEqual_ObjectObject(MyScrollBar, none))
	{
		MyScrollBar.AlignThumb();
	}
	if(Not_PreBool(bDontPropChange))
	{
		OnChange(self);
	}
	SetDirty();
	return Index;
	return;
}

function int GetIndex()
{
	return Index;
	return;
}

function Clear()
{
	Top = 0;
	ItemCount = 0;
	setIndex(-1);
	if(NotEqual_ObjectObject(MyScrollBar, none))
	{
		MyScrollBar.AlignThumb();
	}
	return;
}

function MakeVisible(float Perc)
{
	SetTopItem(int(Multiply_FloatFloat(float(Subtract_IntInt(ItemCount, ItemsPerPage)), Perc)));
	return;
}

function SetTopItem(int Item)
{
	Top = Item;
	if(GreaterEqual_IntInt(Add_IntInt(Top, ItemsPerPage), ItemCount))
	{
		Top = Subtract_IntInt(ItemCount, ItemsPerPage);
	}
	if(OrOr_BoolBool(Less_IntInt(Top, 0), GreaterEqual_IntInt(ItemsPerPage, ItemCount)))
	{
		Top = 0;
	}
	SetDirty();
	OnAdjustTop(self);
	return;
}

defaultproperties
{
	SelectedBKColor=(R=255,G=255,B=255,A=255)
	SelectedImage=Texture'gui_tex.White'
	StyleName="STY_ListBox"
	bCaptureMouse=true
	bTabStop=true
}