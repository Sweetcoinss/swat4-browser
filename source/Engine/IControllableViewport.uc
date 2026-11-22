interface IControllableViewport
	native
	parseconfig;

simulated function OnBeginControlling()
{
	return;
}

simulated function OnEndControlling()
{
	return;
}

simulated function name GetControllingStateName()
{
	return;
}

simulated function bool ShouldControlViewport()
{
	return;
}

simulated function bool CanIssueCommands()
{
	return;
}

simulated function SetInput(int dMouseX, int dMouseY)
{
	return;
}

simulated function ViewportCalcView(out Vector CameraLocation, out Rotator CameraRotation)
{
	return;
}

simulated function HandleFire()
{
	return;
}

simulated function HandleAltFire()
{
	return;
}

simulated function HandleReload()
{
	return;
}

simulated function IControllableThroughViewport GetCurrentControllable()
{
	return;
}
