class OpenDoorGoal extends MoveToDoorGoal
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) bool bOpenFrantically;
var private bool bOpenedFromSide;

function SetOpenFrantically(bool bInOpenFrantically)
{
	bOpenFrantically = bInOpenFrantically;
	return;
}

function bool WasOpenedFromSide()
{
	return NotEqual_IntInt(int(DoorUsageSide), int(2));
	return;
}

defaultproperties
{
	goalName="OpenDoor"
}