class TexPannerTriggered extends TexPanner
	native
	editinlinenew
	collapsecategories
	hidecategories(Object,Material);

cpptext
{
	// UTexModifier interface
	virtual FMatrix* GetMatrix(FLOAT TimeSeconds);

}

var TexOscillatorTriggered.ERetriggerAction RetriggerAction;
var float StopAfterPeriod;
var transient float TriggeredTime;
var transient bool Reverse;
var transient bool Triggered;

function Trigger(Actor Other, Actor EventInstigator)
{
	if(Triggered)
	{
		switch(RetriggerAction)
		{
			case 0:
				Triggered = false;
				TriggeredTime = Other.Level.TimeSeconds;
				Reverse = true;
				break;
			case 1:
				Triggered = false;
				TriggeredTime = -1.0000000;
				Reverse = true;
				break;
			default:
				break;
		}
	}
	else
	{
		if(NotEqual_IntInt(int(RetriggerAction), int(3)))
		{
			Triggered = true;
		}
		TriggeredTime = Other.Level.TimeSeconds;
		Reverse = false;
	}
	return;
}

function Reset()
{
	Triggered = false;
	TriggeredTime = -1.0000000;
	Reverse = false;
	return;
}

defaultproperties
{
	RetriggerAction=3
	StopAfterPeriod=0.5000000
}