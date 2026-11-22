class UWindowScrollingDialogClient extends UWindowPageWindow;

var bool bShowHorizSB;
var bool bShowVertSB;
var UWindowDialogClientWindow ClientArea;
var UWindowDialogClientWindow FixedArea;
var Class<UWindowDialogClientWindow> ClientClass;
var Class<UWindowDialogClientWindow> FixedAreaClass;
var UWindowVScrollbar VertSB;
var UWindowHScrollbar HorizSB;
var UWindowBitmap BRBitmap;

function Created()
{
	super(UWindowWindow).Created();
	if(NotEqual_ObjectObject(FixedAreaClass, none))
	{
		FixedArea = UWindowDialogClientWindow(CreateWindow(FixedAreaClass, 0.0000000, 0.0000000, 100.0000000, 100.0000000, OwnerWindow));
		FixedArea.bAlwaysOnTop = true;
	}
	else
	{
		FixedArea = none;
	}
	ClientArea = UWindowDialogClientWindow(CreateWindow(ClientClass, 0.0000000, 0.0000000, WinWidth, WinHeight, OwnerWindow));
	VertSB = UWindowVScrollbar(CreateWindow(Class'UWindow.UWindowVScrollbar', Subtract_FloatFloat(WinWidth, float(12)), 0.0000000, 12.0000000, WinHeight));
	VertSB.bAlwaysOnTop = true;
	VertSB.HideWindow();
	HorizSB = UWindowHScrollbar(CreateWindow(Class'UWindow.UWindowHScrollbar', 0.0000000, Subtract_FloatFloat(WinHeight, float(12)), WinWidth, 12.0000000));
	HorizSB.bAlwaysOnTop = true;
	HorizSB.HideWindow();
	BRBitmap = UWindowBitmap(CreateWindow(Class'UWindow.UWindowBitmap', Subtract_FloatFloat(WinWidth, float(12)), Subtract_FloatFloat(WinHeight, float(12)), 12.0000000, 12.0000000));
	BRBitmap.bAlwaysOnTop = true;
	BRBitmap.HideWindow();
	BRBitmap.bStretch = true;
	return;
}

function BeforePaint(Canvas C, float X, float Y)
{
	local float ClientWidth, ClientHeight, FixedHeight;

	if(NotEqual_ObjectObject(FixedArea, none))
	{
		FixedHeight = FixedArea.WinHeight;
	}
	else
	{
		FixedHeight = 0.0000000;
	}
	ClientWidth = ClientArea.DesiredWidth;
	ClientHeight = ClientArea.DesiredHeight;
	if(LessEqual_FloatFloat(ClientWidth, WinWidth))
	{
		ClientWidth = WinWidth;
	}
	if(LessEqual_FloatFloat(ClientHeight, Subtract_FloatFloat(WinHeight, FixedHeight)))
	{
		ClientHeight = Subtract_FloatFloat(WinHeight, FixedHeight);
	}
	ClientArea.SetSize(ClientWidth, ClientHeight);
	bShowVertSB = Greater_FloatFloat(ClientHeight, Subtract_FloatFloat(WinHeight, FixedHeight));
	bShowHorizSB = Greater_FloatFloat(ClientWidth, WinWidth);
	if(bShowHorizSB)
	{
		ClientHeight = ClientArea.DesiredHeight;
		if(LessEqual_FloatFloat(ClientHeight, Subtract_FloatFloat(Subtract_FloatFloat(WinHeight, LookAndFeel.Size_ScrollbarWidth), FixedHeight)))
		{
			ClientHeight = Subtract_FloatFloat(Subtract_FloatFloat(WinHeight, LookAndFeel.Size_ScrollbarWidth), FixedHeight);
		}
		bShowVertSB = Greater_FloatFloat(ClientHeight, Subtract_FloatFloat(Subtract_FloatFloat(WinHeight, LookAndFeel.Size_ScrollbarWidth), FixedHeight));
	}
	if(bShowVertSB)
	{
		VertSB.ShowWindow();
		VertSB.WinTop = 0.0000000;
		VertSB.WinLeft = Subtract_FloatFloat(WinWidth, LookAndFeel.Size_ScrollbarWidth);
		VertSB.WinWidth = LookAndFeel.Size_ScrollbarWidth;
		if(bShowHorizSB)
		{
			BRBitmap.ShowWindow();
			BRBitmap.WinWidth = LookAndFeel.Size_ScrollbarWidth;
			BRBitmap.WinHeight = LookAndFeel.Size_ScrollbarWidth;
			BRBitmap.WinTop = Subtract_FloatFloat(Subtract_FloatFloat(WinHeight, LookAndFeel.Size_ScrollbarWidth), FixedHeight);
			BRBitmap.WinLeft = Subtract_FloatFloat(WinWidth, LookAndFeel.Size_ScrollbarWidth);
			BRBitmap.t = GetLookAndFeelTexture();
			VertSB.WinHeight = Subtract_FloatFloat(Subtract_FloatFloat(WinHeight, LookAndFeel.Size_ScrollbarWidth), FixedHeight);
		}
		else
		{
			BRBitmap.HideWindow();
			VertSB.WinHeight = Subtract_FloatFloat(WinHeight, FixedHeight);
		}
		VertSB.SetRange(0.0000000, ClientHeight, VertSB.WinHeight, 10.0000000);
	}
	else
	{
		BRBitmap.HideWindow();
		VertSB.HideWindow();
		VertSB.pos = 0.0000000;
	}
	if(bShowHorizSB)
	{
		HorizSB.ShowWindow();
		HorizSB.WinLeft = 0.0000000;
		HorizSB.WinTop = Subtract_FloatFloat(Subtract_FloatFloat(WinHeight, LookAndFeel.Size_ScrollbarWidth), FixedHeight);
		HorizSB.WinHeight = LookAndFeel.Size_ScrollbarWidth;
		if(bShowVertSB)
		{
			HorizSB.WinWidth = Subtract_FloatFloat(WinWidth, LookAndFeel.Size_ScrollbarWidth);
		}
		else
		{
			HorizSB.WinWidth = WinWidth;
		}
		HorizSB.SetRange(0.0000000, ClientWidth, HorizSB.WinWidth, 10.0000000);
	}
	else
	{
		HorizSB.HideWindow();
		HorizSB.pos = 0.0000000;
	}
	ClientArea.WinLeft = Subtract_PreFloat(HorizSB.pos);
	ClientArea.WinTop = Subtract_PreFloat(VertSB.pos);
	if(NotEqual_ObjectObject(FixedArea, none))
	{
		FixedArea.WinLeft = 0.0000000;
		FixedArea.WinTop = Subtract_FloatFloat(WinHeight, FixedHeight);
		if(NotEqual_FloatFloat(FixedArea.WinWidth, WinWidth))
		{
			FixedArea.SetSize(WinWidth, FixedArea.WinHeight);
		}
	}
	super(UWindowWindow).BeforePaint(C, X, Y);
	return;
}

function GetDesiredDimensions(out float W, out float H)
{
	super(UWindowWindow).GetDesiredDimensions(W, H);
	return;
}

function Paint(Canvas C, float X, float Y)
{
	return;
}

defaultproperties
{
	ClientClass=Class'UWindow.UWindowDialogClientWindow'
}