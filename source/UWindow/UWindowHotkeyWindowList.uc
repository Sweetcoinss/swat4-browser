class UWindowHotkeyWindowList extends UWindowList;

var UWindowWindow Window;

function UWindowHotkeyWindowList FindWindow(UWindowWindow W)
{
	local UWindowHotkeyWindowList L;

	L = UWindowHotkeyWindowList(Next);
	J0x10:

	if(NotEqual_ObjectObject(L, none))
	{
		if(EqualEqual_ObjectObject(L.Window, W))
		{
			return L;
		}
		L = UWindowHotkeyWindowList(L.Next);
		// [Loop Continue]
		goto J0x10;
	}
	return none;
	return;
}
