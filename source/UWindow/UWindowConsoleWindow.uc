class UWindowConsoleWindow extends UWindowFramedWindow;

var float OldParentWidth;
var float OldParentHeight;

function Created()
{
	super.Created();
	bSizable = true;
	bStatusBar = true;
	bLeaveOnscreen = true;
	OldParentWidth = ParentWindow.WinWidth;
	OldParentHeight = ParentWindow.WinHeight;
	SetDimensions();
	SetAcceptsFocus();
	return;
}

function ShowWindow()
{
	super(UWindowWindow).ShowWindow();
	if(OrOr_BoolBool(NotEqual_FloatFloat(ParentWindow.WinWidth, OldParentWidth), NotEqual_FloatFloat(ParentWindow.WinHeight, OldParentHeight)))
	{
		SetDimensions();
		OldParentWidth = ParentWindow.WinWidth;
		OldParentHeight = ParentWindow.WinHeight;
	}
	return;
}

function ResolutionChanged(float W, float H)
{
	SetDimensions();
	return;
}

function SetDimensions()
{
	if(Less_FloatFloat(ParentWindow.WinWidth, float(500)))
	{
		SetSize(200.0000000, 150.0000000);
	}
	else
	{
		SetSize(410.0000000, 310.0000000);
	}
	WinLeft = Subtract_FloatFloat(Divide_FloatFloat(ParentWindow.WinWidth, float(2)), Divide_FloatFloat(WinWidth, float(2)));
	WinTop = Subtract_FloatFloat(Divide_FloatFloat(ParentWindow.WinHeight, float(2)), Divide_FloatFloat(WinHeight, float(2)));
	return;
}

function Close(optional bool bByParent)
{
	ClientArea.Close(true);
	Root.GotoState('None');
	return;
}

defaultproperties
{
	ClientClass=Class'UWindow.UWindowConsoleClientWindow'
	WindowTitle="Game Console"
}