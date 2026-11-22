class AI_SensorRecipient extends DeleteableObject;

var ISensorNotification Recipient;
var bool bNotify;
var float lowerBound;
var float upperBound;
var Object userData;

defaultproperties
{
	bNotify=true
}