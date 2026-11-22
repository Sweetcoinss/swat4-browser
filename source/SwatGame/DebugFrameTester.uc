class DebugFrameTester extends Actor
	config
	placeable
	hidecategories(Karma);

var float Period;

function PostBeginPlay()
{
	super.PostBeginPlay();
	if(SwatGameInfo(Level.Game).bDebugFrames)
	{
		SetTimer(Period, true);
	}
	return;
}

event Timer()
{
	local int i;
	local float j;

	SwatGameInfo(Level.Game).GuardSlow(Concat_StrStr(Concat_StrStr(Concat_StrStr(string(Name), "::Timer() wasting a lot of time (happens every "), string(Period)), " second(s))"));
	i = 0;
	J0x76:

	if(Less_IntInt(i, 100000))
	{
		j = Sqrt(100000.0000000);
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x76;
	}
	return;
}

defaultproperties
{
	Period=1.0000000
}