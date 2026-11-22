class StungGoal extends StunnedGoal
	collapsecategories
	hidecategories(Object,InternalParameters);

var(Parameters) Actor stingGrenade;

overloaded function Construct(AI_Resource R, Actor inGrenade, Vector inStunningDeviceLocation, float inStunnedDuration)
{
	construct_AI_ResourceVectorFloat(R, inStunningDeviceLocation, inStunnedDuration);
	stingGrenade = inGrenade;
	return;
}

defaultproperties
{
	goalName="Stung"
}