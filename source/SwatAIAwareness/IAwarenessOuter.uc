interface IAwarenessOuter
	native
	parseconfig;

function RegisterVisionNotification(IVisionNotification Registrant)
{
	return;
}

function UnregisterVisionNotification(IVisionNotification Registrant)
{
	return;
}

function RegisterHearingNotification(IHearingNotification Registrant)
{
	return;
}

function UnregisterHearingNotification(IHearingNotification Registrant)
{
	return;
}

function bool IsOtherActorAThreat(Actor otherActor)
{
	return;
}

function bool GetKnownLocationOfPawn(Pawn otherPawn, out Vector Location)
{
	return;
}
