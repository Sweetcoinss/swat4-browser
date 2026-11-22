class StunnedGoal extends SwatCharacterGoal
	abstract
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) Vector StunningDeviceLocation;
var(Parameters) float StunnedDuration;
var(Parameters) bool bShouldRunFromStunningDevice;
var(Parameters) bool bPlayedReaction;

overloaded function Construct(AI_Resource R)
{
	assert(false);
	return;
}

overloaded function Construct(AI_Resource R, Vector inStunningDeviceLocation, float inStunnedDuration)
{
	construct_AI_Resource(R);
	assert(Greater_FloatFloat(inStunnedDuration, 0.0000000));
	StunningDeviceLocation = inStunningDeviceLocation;
	StunnedDuration = inStunnedDuration;
	return;
}

defaultproperties
{
	bShouldRunFromStunningDevice=true
	Priority=95
}