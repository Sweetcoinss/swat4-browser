class GUITimeDisplay extends GUINumericEdit
	native
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object,Menu,Object,Menu,Object);

var() export editinline config GUILabel TimerLabel "GUI Label associated with this Time display";
var() private config bool bShowWhileNotRunning "If true, will show this component while the timer is not running";
var() private config bool bPauseWhileGamePaused "If true, will pause this timer while the game is not running";
var(DEBUG) private bool bRunning;
var(DEBUG) private bool bLooping;
var(DEBUG) private int StartTime;
var(DEBUG) private int ElapsedTime;
//var delegate<OnTimeExpired> __OnTimeExpired__Delegate;

function InitComponent(GUIComponent MyOwner)
{
	super.InitComponent(MyOwner);
	if(NotEqual_ObjectObject(TimerLabel, none))
	{
		MyEditBox.TextAlign = 1;
		TimerLabel.bBoundToParent = false;
		TimerLabel.bScaleToParent = false;
	}
	return;
}

event Show()
{
	if(OrOr_BoolBool(bShowWhileNotRunning, bRunning))
	{
		super(GUIMultiComponent).Show();
	}
	return;
}

delegate OnTimeExpired()
{
	return;
}

function SetTime(int Time)
{
	SetValue(Time);
	return;
}

function StartTimer(optional int Time, optional bool Loop, optional bool Reset)
{
	if(AndAnd_BoolBool(Not_PreBool(Reset), bRunning))
	{
		return;
	}
	if(Greater_IntInt(Time, 0))
	{
		SetTime(Time);
	}
	bLooping = Loop;
	StartTime = Value;
	ElapsedTime = 0;
	bRunning = true;
	Show();
	SetTimer(float(Step), true);
	return;
}

function StopTimer()
{
	bRunning = false;
	KillTimer();
	if(Not_PreBool(bShowWhileNotRunning))
	{
		Hide();
	}
	return;
}

event Timer()
{
	SetValue(Subtract_IntInt(Value, Step));
	ElapsedTime = Subtract_IntInt(StartTime, Value);
	if(LessEqual_IntInt(Value, 0))
	{
		TimerExpired();
	}
	return;
}

private function TimerExpired()
{
	OnTimeExpired();
	if(bLooping)
	{
		SetTime(StartTime);
	}
	else
	{
		StopTimer();
	}
	return;
}

function bool IsRunning()
{
	return bRunning;
	return;
}

function int GetStartTime()
{
	return StartTime;
	return;
}

function int GetElapsedTime()
{
	return ElapsedTime;
	return;
}

defaultproperties
{
	bPauseWhileGamePaused=true
	bDisplayAsTime=true
	bReadOnly=true
	StyleName="STY_TimeDisplay"
	bAcceptsInput=false
}