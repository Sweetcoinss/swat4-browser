class CloseDoorGoal extends MoveToDoorGoal
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) bool CloseDoorFromBehind;
var(Parameters) bool CloseDoorFromLeft;

function SetCloseDoorFromBehind(bool bInCloseDoorFromBehind)
{
	CloseDoorFromBehind = bInCloseDoorFromBehind;
	return;
}

function SetCloseDoorFromLeft(bool bInCloseDoorFromLeft)
{
	CloseDoorFromLeft = bInCloseDoorFromLeft;
	return;
}

defaultproperties
{
	goalName="CloseDoor"
}