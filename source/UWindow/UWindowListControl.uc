class UWindowListControl extends UWindowDialogControl;

var Class<UWindowList> ListClass;
var UWindowList Items;
var Color SelectionBkgColor;
var Color SelectionColor;
var bool bNoSelectionBox;

function DrawItem(Canvas C, UWindowList Item, float X, float Y, float W, float H)
{
	return;
}

function Created()
{
	super.Created();
	Items = ListClass.static.Allocate(self).;
	Construct_Void();
	Items.Last = Items;
	Items.Next = none;
	Items.Prev = none;
	Items.Sentinel = Items;
	return;
}

defaultproperties
{
	SelectionBkgColor=(R=0,G=0,B=192,A=255)
	SelectionColor=(R=255,G=255,B=255,A=255)
}