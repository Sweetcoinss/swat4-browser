class Timer extends Actor
	native
	config
	notplaceable
	hidecategories(Karma);

var private float InitialTime;
var private bool Looping;
var private bool Running;
var private float LastStartTime;
var private float LastDuration;
//var delegate<TimerDelegate> __TimerDelegate__Delegate;

function SetTime(float newTime)
{
	InitialTime = newTime;
	return;
}

function StartTimer(optional float newTime, optional bool Loop, optional bool Reset)
{
	AssertWithDescription(OrOr_BoolBool(Greater_FloatFloat(newTime, float(0)), Greater_FloatFloat(InitialTime, float(0))), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] The ", string(Class.Name)), " owned by "), string(Owner)), " was called to StartTimer(), but newTime and InitialTime are both zero."));
	if(AndAnd_BoolBool(Running, Not_PreBool(Reset)))
	{
		return;
	}
	if(Greater_FloatFloat(newTime, float(0)))
	{
		SetTime(newTime);
	}
	Looping = Loop;
	SetTimer(InitialTime, false);
	Running = true;
	LastStartTime = Level.TimeSeconds;
	LastDuration = newTime;
	StartTimerHook(InitialTime, Loop, Reset);
	return;
}

function StartTimerHook(float newTime, bool Loop, bool Reset)
{
	return;
}

function StopTimer()
{
	SetTimer(0.0000000, false);
	Running = false;
	return;
}

function bool IsRunning()
{
	return Running;
	return;
}

event Timer()
{
	StopTimer();
	if(Looping)
	{
		StartTimer(InitialTime, true);
	}
	TimerHook();
	TimerDelegate();
	return;
}

function TimerHook()
{
	return;
}

delegate TimerDelegate()
{
	if(Level.GetEngine().EnableDevTools)
	{
		Log(Concat_StrStr(string(Name), "'s time expired, but nobody is interested. (delegate is unassigned)"));
	}
	return;
}

event float GetLastStartTime()
{
	return LastStartTime;
	return;
}

event float GetLastDuration()
{
	return LastDuration;
	return;
}

defaultproperties
{
	bHidden=true
	RemoteRole=0
}