class UWindowMessageBoxCW extends UWindowDialogClientWindow;

var UWindowBase.MessageBoxButtons Buttons;
var UWindowBase.MessageBoxResult EnterResult;
var UWindowSmallButton YesButton;
var UWindowSmallButton NoButton;
var UWindowSmallButton OKButton;
var UWindowSmallButton CancelButton;
var localized string YesText;
var localized string NoText;
var localized string OKText;
var localized string CancelText;
var UWindowMessageBoxArea MessageArea;

function Created()
{
	super(UWindowWindow).Created();
	SetAcceptsFocus();
	MessageArea = UWindowMessageBoxArea(CreateWindow(Class'UWindow.UWindowMessageBoxArea', 10.0000000, 10.0000000, Subtract_FloatFloat(WinWidth, float(20)), Subtract_FloatFloat(WinHeight, float(44))));
	return;
}

function KeyDown(int Key, float X, float Y)
{
	local UWindowMessageBox P;

	P = UWindowMessageBox(ParentWindow);
	if(AndAnd_BoolBool(EqualEqual_IntInt(Key, int(GetPlayerOwner().Player.Console.13)), NotEqual_IntInt(int(EnterResult), int(0))))
	{
		P = UWindowMessageBox(ParentWindow);
		P.Result = EnterResult;
		P.Close();
	}
	return;
}

function BeforePaint(Canvas C, float X, float Y)
{
	super(UWindowWindow).BeforePaint(C, X, Y);
	MessageArea.SetSize(Subtract_FloatFloat(WinWidth, float(20)), Subtract_FloatFloat(WinHeight, float(44)));
	switch(Buttons)
	{
		case 3:
			CancelButton.WinLeft = Subtract_FloatFloat(WinWidth, float(52));
			CancelButton.WinTop = Subtract_FloatFloat(WinHeight, float(20));
			NoButton.WinLeft = Subtract_FloatFloat(WinWidth, float(104));
			NoButton.WinTop = Subtract_FloatFloat(WinHeight, float(20));
			YesButton.WinLeft = Subtract_FloatFloat(WinWidth, float(156));
			YesButton.WinTop = Subtract_FloatFloat(WinHeight, float(20));
			break;
		case 0:
			NoButton.WinLeft = Subtract_FloatFloat(WinWidth, float(52));
			NoButton.WinTop = Subtract_FloatFloat(WinHeight, float(20));
			YesButton.WinLeft = Subtract_FloatFloat(WinWidth, float(104));
			YesButton.WinTop = Subtract_FloatFloat(WinHeight, float(20));
			break;
		case 1:
			CancelButton.WinLeft = Subtract_FloatFloat(WinWidth, float(52));
			CancelButton.WinTop = Subtract_FloatFloat(WinHeight, float(20));
			OKButton.WinLeft = Subtract_FloatFloat(WinWidth, float(104));
			OKButton.WinTop = Subtract_FloatFloat(WinHeight, float(20));
			break;
		case 2:
			OKButton.WinLeft = Subtract_FloatFloat(WinWidth, float(52));
			OKButton.WinTop = Subtract_FloatFloat(WinHeight, float(20));
			break;
		default:
			break;
	}
	return;
}

function Resized()
{
	super(UWindowWindow).Resized();
	MessageArea.SetSize(Subtract_FloatFloat(WinWidth, float(20)), Subtract_FloatFloat(WinHeight, float(44)));
	return;
}

function float GetHeight(Canvas C)
{
	return Add_FloatFloat(44.0000000, MessageArea.GetHeight(C));
	return;
}

function Paint(Canvas C, float X, float Y)
{
	local Texture t;

	super.Paint(C, X, Y);
	t = GetLookAndFeelTexture();
	DrawUpBevel(C, 0.0000000, Subtract_FloatFloat(WinHeight, float(24)), WinWidth, 24.0000000, t);
	return;
}

function SetupMessageBoxClient(string InMessage, UWindowBase.MessageBoxButtons InButtons, UWindowBase.MessageBoxResult InEnterResult)
{
	MessageArea.Message = InMessage;
	Buttons = InButtons;
	EnterResult = InEnterResult;
	switch(Buttons)
	{
		case 3:
			CancelButton = UWindowSmallButton(CreateControl(Class'UWindow.UWindowSmallButton', Subtract_FloatFloat(WinWidth, float(52)), Subtract_FloatFloat(WinHeight, float(20)), 48.0000000, 16.0000000));
			CancelButton.SetText(CancelText);
			if(EqualEqual_IntInt(int(EnterResult), int(4)))
			{
				CancelButton.SetFont(1);
			}
			else
			{
				CancelButton.SetFont(0);
			}
			NoButton = UWindowSmallButton(CreateControl(Class'UWindow.UWindowSmallButton', Subtract_FloatFloat(WinWidth, float(104)), Subtract_FloatFloat(WinHeight, float(20)), 48.0000000, 16.0000000));
			NoButton.SetText(NoText);
			if(EqualEqual_IntInt(int(EnterResult), int(2)))
			{
				NoButton.SetFont(1);
			}
			else
			{
				NoButton.SetFont(0);
			}
			YesButton = UWindowSmallButton(CreateControl(Class'UWindow.UWindowSmallButton', Subtract_FloatFloat(WinWidth, float(156)), Subtract_FloatFloat(WinHeight, float(20)), 48.0000000, 16.0000000));
			YesButton.SetText(YesText);
			if(EqualEqual_IntInt(int(EnterResult), int(1)))
			{
				YesButton.SetFont(1);
			}
			else
			{
				YesButton.SetFont(0);
			}
			break;
		case 0:
			NoButton = UWindowSmallButton(CreateControl(Class'UWindow.UWindowSmallButton', Subtract_FloatFloat(WinWidth, float(52)), Subtract_FloatFloat(WinHeight, float(20)), 48.0000000, 16.0000000));
			NoButton.SetText(NoText);
			if(EqualEqual_IntInt(int(EnterResult), int(2)))
			{
				NoButton.SetFont(1);
			}
			else
			{
				NoButton.SetFont(0);
			}
			YesButton = UWindowSmallButton(CreateControl(Class'UWindow.UWindowSmallButton', Subtract_FloatFloat(WinWidth, float(104)), Subtract_FloatFloat(WinHeight, float(20)), 48.0000000, 16.0000000));
			YesButton.SetText(YesText);
			if(EqualEqual_IntInt(int(EnterResult), int(1)))
			{
				YesButton.SetFont(1);
			}
			else
			{
				YesButton.SetFont(0);
			}
			break;
		case 1:
			CancelButton = UWindowSmallButton(CreateControl(Class'UWindow.UWindowSmallButton', Subtract_FloatFloat(WinWidth, float(52)), Subtract_FloatFloat(WinHeight, float(20)), 48.0000000, 16.0000000));
			CancelButton.SetText(CancelText);
			if(EqualEqual_IntInt(int(EnterResult), int(4)))
			{
				CancelButton.SetFont(1);
			}
			else
			{
				CancelButton.SetFont(0);
			}
			OKButton = UWindowSmallButton(CreateControl(Class'UWindow.UWindowSmallButton', Subtract_FloatFloat(WinWidth, float(104)), Subtract_FloatFloat(WinHeight, float(20)), 48.0000000, 16.0000000));
			OKButton.SetText(OKText);
			if(EqualEqual_IntInt(int(EnterResult), int(3)))
			{
				OKButton.SetFont(1);
			}
			else
			{
				OKButton.SetFont(0);
			}
			break;
		case 2:
			OKButton = UWindowSmallButton(CreateControl(Class'UWindow.UWindowSmallButton', Subtract_FloatFloat(WinWidth, float(52)), Subtract_FloatFloat(WinHeight, float(20)), 48.0000000, 16.0000000));
			OKButton.SetText(OKText);
			if(EqualEqual_IntInt(int(EnterResult), int(3)))
			{
				OKButton.SetFont(1);
			}
			else
			{
				OKButton.SetFont(0);
			}
			break;
		default:
			break;
	}
	return;
}

function Notify(UWindowDialogControl C, byte E)
{
	local UWindowMessageBox P;

	P = UWindowMessageBox(ParentWindow);
	if(EqualEqual_IntInt(int(E), 2))
	{
		switch(C)
		{
			case YesButton:
				P.Result = 1;
				P.Close();
				break;
			case NoButton:
				P.Result = 2;
				P.Close();
				break;
			case OKButton:
				P.Result = 3;
				P.Close();
				break;
			case CancelButton:
				P.Result = 4;
				P.Close();
				break;
			default:
				break;
		}
	}
	else
	{
		return;
	}
}

defaultproperties
{
	YesText="Yes"
	NoText="No"
	OKText="OK"
	CancelText="Cancel"
}