class UWindowLayoutControl extends UWindowLayoutBase;

var UWindowDialogClientWindow OwnerWindow;
var float WinTop;
var float WinLeft;
var float WinWidth;
var float WinHeight;
var float MinimumWidth;
var float MinimumHeight;
var UWindowLayoutRow RowList;

static function UWindowLayoutControl Create()
{
	local UWindowLayoutControl C;

	C = Class'UWindow.UWindowLayoutControl'.static.Allocate(self).;
	Construct_Void();
	C.RowList = Class'UWindow.UWindowLayoutRow'.static.Allocate(self).;
	Construct_Void();
	C.RowList.SetupSentinel();
	return C;
	return;
}

function PerformLayout()
{
	local UWindowLayoutRow R;
	local float TotalWidth, TotalHeight;

	R = UWindowLayoutRow(RowList.Next);
	J0x19:

	if(NotEqual_ObjectObject(R, none))
	{
		AddEqual_FloatFloat(TotalHeight, R.CalcMinHeight());
		R = UWindowLayoutRow(R.Next);
		// [Loop Continue]
		goto J0x19;
	}
	AddEqual_FloatFloat(TotalWidth, R.CalcMinHeight());
	return;
}

function UWindowLayoutRow AddRow()
{
	return UWindowLayoutRow(RowList.Append(Class'UWindow.UWindowLayoutRow'));
	return;
}

function UWindowLayoutCell AddCell(optional int ColSpan, optional int RowSpan)
{
	return RowList.AddCell(ColSpan, RowSpan);
	return;
}
