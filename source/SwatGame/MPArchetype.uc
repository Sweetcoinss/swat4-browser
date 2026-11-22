class MPArchetype extends Archetype
	config(MPArchetypes)
	perobjectconfig;

var config Class<Actor> actorClass;

function Class<Actor> PickClass()
{
	return actorClass;
	return;
}

defaultproperties
{
	InstanceClass=Class'SwatGame.MPArchetypeInstance'
}