class ThreatenedSensor extends AI_Sensor;

var Pawn ThreatenedBy;

function NotifyThreatened(Pawn inThreatenedBy)
{
	assert(NotEqual_ObjectObject(inThreatenedBy, none));
	ThreatenedBy = inThreatenedBy;
	setObjectValue(ThreatenedBy);
	return;
}

function NotifyNoLongerThreatened()
{
	ThreatenedBy = none;
	setObjectValue(none);
	return;
}
