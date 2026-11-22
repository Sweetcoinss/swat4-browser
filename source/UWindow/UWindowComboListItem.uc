class UWindowComboListItem extends UWindowList;

var string Value;
var string Value2;
var int SortWeight;
var float ItemTop;

function int Compare(UWindowList t, UWindowList B)
{
	local UWindowComboListItem TI, BI;
	local string TS, BS;

	TI = UWindowComboListItem(t);
	BI = UWindowComboListItem(B);
	if(EqualEqual_IntInt(TI.SortWeight, BI.SortWeight))
	{
		TS = Caps(TI.Value);
		BS = Caps(BI.Value);
		if(EqualEqual_StrStr(TS, BS))
		{
			return 0;
		}
		if(Less_StrStr(TS, BS))
		{
			return -1;
		}
		return 1;
	}
	else
	{
		return Subtract_IntInt(TI.SortWeight, BI.SortWeight);
	}
	return;
}
