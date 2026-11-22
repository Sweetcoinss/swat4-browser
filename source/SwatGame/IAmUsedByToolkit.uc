interface IAmUsedByToolkit
	native
	parseconfig;

simulated function bool CanBeUsedByToolkitNow()
{
	return;
}

simulated function OnUsingByToolkitBegan(Pawn User)
{
	return;
}

simulated function OnUsedByToolkit(Pawn User)
{
	return;
}

simulated function OnUsingByToolkitInterrupted(Pawn User)
{
	return;
}

simulated function float GetQualifyTimeForToolkit()
{
	return;
}
