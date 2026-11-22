class UWindowMessageBox extends UWindowFramedWindow;

var UWindowBase.MessageBoxResult Result;
var float TimeOutTime;
var int TimeOut;
var bool bSetupSize;
var int FrameCount;

function SetupMessageBox(string Title, string Message, UWindowBase.MessageBoxButtons Buttons, UWindowBase.MessageBoxResult InESCResult, optional UWindowBase.MessageBoxResult InEnterResult, optional int InTimeOut)
{
	WindowTitle = Title;
	UWindowMessageBoxCW(ClientArea).SetupMessageBoxClient(Message, Buttons, InEnterResult);
	Result = InESCResult;
	TimeOutTime = 0.0000000;
	TimeOut = InTimeOut;
	FrameCount = 0;
	return;
}

function BeforePaint(Canvas C, float X, float Y)
{
	local Region R;

	if(Not_PreBool(bSetupSize))
	{
		SetSize(200.0000000, WinHeight);
		R = LookAndFeel.FW_GetClientArea(self);
		SetSize(200.0000000, Add_FloatFloat(Subtract_FloatFloat(WinHeight, float(R.H)), UWindowMessageBoxCW(ClientArea).GetHeight(C)));
		WinLeft = float(int(Divide_FloatFloat(Subtract_FloatFloat(Root.WinWidth, WinWidth), float(2))));
		WinTop = float(int(Divide_FloatFloat(Subtract_FloatFloat(Root.WinHeight, WinHeight), float(2))));
		bSetupSize = true;
	}
	super.BeforePaint(C, X, Y);
	return;
}

function AfterPaint(Canvas C, float X, float Y)
{
	super(UWindowWindow).AfterPaint(C, X, Y);
	if(NotEqual_IntInt(TimeOut, 0))
	{
		AddAdd_Int(FrameCount);
		if(GreaterEqual_IntInt(FrameCount, 5))
		{
			TimeOutTime = Add_FloatFloat(GetEntryLevel().TimeSeconds, float(TimeOut));
			TimeOut = 0;
		}
	}
	if(AndAnd_BoolBool(NotEqual_FloatFloat(TimeOutTime, float(0)), Greater_FloatFloat(GetEntryLevel().TimeSeconds, TimeOutTime)))
	{
		TimeOutTime = 0.0000000;
		Close();
	}
	return;
}

function Close(optional bool bByParent)
{
	super(UWindowWindow).Close(bByParent);
	OwnerWindow.MessageBoxDone(self, Result);
	return;
}

defaultproperties
{
	ClientClass=Class'UWindow.UWindowMessageBoxCW'
}